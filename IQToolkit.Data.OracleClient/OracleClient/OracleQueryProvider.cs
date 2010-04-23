using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using IQToolkit;
using IQToolkit.Data.Common;
using IQToolkit.Data.OracleCore;

namespace IQToolkit.Data.OracleClient
{    

    public class OracleQueryProvider : OracleEntityProvider 
    {
        public OracleQueryProvider(DbConnection connection, QueryMapping mapping, QueryPolicy policy)
            : base(connection, mapping, policy)
        {            
        }

        public override AdoProvider AdoProvider
        {
            get
            {
                return AdoOracleClientProvider.Default;
            }
        }

        public static Type AdoConnectionType
        {
            get
            {
                return AdoOracleClientProvider.Default.DbConnectionType;
            }
        }

    }
}
