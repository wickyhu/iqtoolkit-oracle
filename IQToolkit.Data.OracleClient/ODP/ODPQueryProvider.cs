using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using IQToolkit;
using IQToolkit.Data.Common;
using IQToolkit.Data.OracleCore;

namespace IQToolkit.Data.ODP 
{    

    public class ODPQueryProvider : OracleEntityProvider 
    {
        public ODPQueryProvider(DbConnection connection, QueryMapping mapping, QueryPolicy policy)
            : base(connection, mapping, policy)
        {            
        }

        public override AdoProvider AdoProvider
        {
            get
            {
                return AdoOracleDataProvider.Default;
            }
        }

        public static Type AdoConnectionType
        {
            get
            {
                return AdoOracleDataProvider.Default.DbConnectionType;
            }
        }

    }
}
