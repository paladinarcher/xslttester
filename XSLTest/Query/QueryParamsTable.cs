using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XSLTest.Query
{
    public class QueryParamsTable : DataTable
    {
        public QueryParamsTable() : base()
        {
            TableName = "QueryParameters";
            Columns.Add(new DataColumn("Name", typeof(string)));
            Columns.Add(new DataColumn("Value", typeof(string)));
        }

        public void LoadXml(String xml)
        {
            MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(xml));
            ReadXml(ms);
        }

        public string ToXMLString()
        {
            MemoryStream ms = new MemoryStream();
            WriteXml(ms);
            return Encoding.UTF8.GetString(ms.ToArray());
        }
    }
}