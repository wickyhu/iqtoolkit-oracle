using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace IQToolkit.Data.OracleClient
{
    using IQToolkit.Data.Common;

    public class OracleQueryProvider : DbEntityProvider
    {
        bool? allowMulitpleActiveResultSets;

        public OracleQueryProvider(OracleConnection connection, QueryMapping mapping, QueryPolicy policy)
            : base(connection, PLSqlLanguage.Default, mapping, policy)
        {
        }

        public override DbEntityProvider New(DbConnection connection, QueryMapping mapping, QueryPolicy policy)
        {
            return new OracleQueryProvider((OracleConnection)connection, mapping, policy);
        }    
        
        public bool AllowsMultipleActiveResultSets
        {
            get
            {
                if (this.allowMulitpleActiveResultSets == null)
                {
                    var builder = new OracleConnectionStringBuilder(this.Connection.ConnectionString);
                    var result = builder.ContainsKey("MultipleActiveResultSets") ? builder["MultipleActiveResultSets"] : null;
                    this.allowMulitpleActiveResultSets = (result != null && result.GetType() == typeof(bool) && (bool)result);
                }
                return (bool)this.allowMulitpleActiveResultSets;
            }
        }

        protected override QueryExecutor CreateExecutor()
        {
            return new Executor(this);
        }

        new class Executor : DbEntityProvider.Executor
        {
            OracleQueryProvider provider;

            public Executor(OracleQueryProvider provider)
                : base(provider)
            {
                this.provider = provider;
            }

            protected override bool BufferResultRows
            {
                get { return !this.provider.AllowsMultipleActiveResultSets; }
            }

            protected override void AddParameter(DbCommand command, QueryParameter parameter, object value)
            {
                DbQueryType sqlType = (DbQueryType)parameter.QueryType;
                if (sqlType == null)
                    sqlType = (DbQueryType)this.Provider.Language.TypeSystem.GetColumnType(parameter.Type);
                int len = sqlType.Length;
                if (len == 0 && DbTypeSystem.IsVariableLength(sqlType.SqlDbType))
                {
                    len = Int32.MaxValue;
                }
                var p = ((OracleCommand)command).Parameters.Add(":" + parameter.Name, ToOracleType(sqlType.SqlDbType), len);
                /*
                if (sqlType.Precision != 0)
                    p.Precision = (byte)sqlType.Precision;
                if (sqlType.Scale != 0)
                    p.Scale = (byte)sqlType.Scale;
                */
                p.Value = value ?? DBNull.Value;
            }

            public override IEnumerable<int> ExecuteBatch(QueryCommand query, IEnumerable<object[]> paramSets, int batchSize, bool stream)
            {
                this.StartUsingConnection();
                try
                {
                    var result = this.ExecuteBatch(query, paramSets, batchSize);
                    if (!stream || this.ActionOpenedConnection)
                    {
                        return result.ToList();
                    }
                    else
                    {
                        return new EnumerateOnce<int>(result);
                    }
                }
                finally
                {
                    this.StopUsingConnection();
                }
            }

            private IEnumerable<int> ExecuteBatch(QueryCommand query, IEnumerable<object[]> paramSets, int batchSize)
            {
                OracleCommand cmd = (OracleCommand)this.GetCommand(query, null);
                DataTable dataTable = new DataTable();
                for (int i = 0, n = query.Parameters.Count; i < n; i++)
                {
                    var qp = query.Parameters[i];
                    cmd.Parameters[i].SourceColumn = qp.Name;
                    dataTable.Columns.Add(qp.Name, TypeHelper.GetNonNullableType(qp.Type));
                }
                OracleDataAdapter dataAdapter = new OracleDataAdapter();
                dataAdapter.InsertCommand = cmd;
                dataAdapter.InsertCommand.UpdatedRowSource = UpdateRowSource.None;
                dataAdapter.UpdateBatchSize = batchSize;

                this.LogMessage("-- Start SQL Batching --");
                this.LogMessage("");
                this.LogCommand(query, null);

                IEnumerator<object[]> en = paramSets.GetEnumerator();
                using (en)
                {
                    bool hasNext = true;
                    while (hasNext)
                    {
                        int count = 0;
                        for (; count < dataAdapter.UpdateBatchSize && (hasNext = en.MoveNext()); count++)
                        {
                            var paramValues = en.Current;
                            dataTable.Rows.Add(paramValues);
                            this.LogParameters(query, paramValues);
                            this.LogMessage("");
                        }
                        if (count > 0)
                        {
                            int n = dataAdapter.Update(dataTable);
                            for (int i = 0; i < count; i++)
                            {
                                yield return (i < n) ? 1 : 0;
                            }
                            dataTable.Rows.Clear();
                        }
                    }
                }

                this.LogMessage(string.Format("-- End SQL Batching --"));
                this.LogMessage("");
            }

        }//end of Executor

        public static OracleType ToOracleType(SqlDbType dbType)
        {
            switch (dbType)
            {
                case SqlDbType.BigInt:
                    return OracleType.Number;
                case SqlDbType.Binary:
                    return OracleType.Blob;
                case SqlDbType.Bit:
                    return OracleType.Byte;
                case SqlDbType.NChar:
                    return OracleType.NChar;
                case SqlDbType.Char:
                    return OracleType.Char;
                case SqlDbType.Date:
                    return OracleType.DateTime;
                case SqlDbType.DateTime:
                case SqlDbType.SmallDateTime:
                    return OracleType.DateTime;
                case SqlDbType.Decimal:
                    return OracleType.Number;
                case SqlDbType.Float:
                    return OracleType.Float;
                case SqlDbType.Image:
                    return OracleType.Blob;
                case SqlDbType.Int:
                    return OracleType.Int32;
                case SqlDbType.Money:
                case SqlDbType.SmallMoney:
                    return OracleType.Number;
                case SqlDbType.NVarChar:
                    return OracleType.NVarChar;
                case SqlDbType.VarChar:
                    return OracleType.VarChar;
                case SqlDbType.SmallInt:
                    return OracleType.Int16;
                case SqlDbType.NText:
                case SqlDbType.Text:
                    return OracleType.LongVarChar;
                case SqlDbType.Time:
                    return OracleType.Timestamp;
                case SqlDbType.Timestamp:
                    return OracleType.Timestamp;
                case SqlDbType.TinyInt:
                    return OracleType.Byte;
                case SqlDbType.UniqueIdentifier:
                    return OracleType.VarChar;
                case SqlDbType.VarBinary:
                    return OracleType.LongRaw;
                case SqlDbType.Xml:
                    return OracleType.LongVarChar;
                default:
                    throw new NotSupportedException(string.Format("The SQL type '{0}' is not supported", dbType));
            }
        }

    }
}
