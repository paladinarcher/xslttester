using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using XSLTest;

namespace XSLTest.Query
{
    public class QueryManager
    {
        private string currentQuery;
        private QueryParamsTable currentParams;

        public QueryParamsTable CurrentTable {
            get
            {
                return currentParams;
            }
        }

        public QueryManager() { }

        public event OnQueryChangeEventHandler OnQueryChange;

        public void ChangeQuery(string query)
        {
            if(currentQuery != null && currentQuery.Equals(query)) { return; }

            SaveState();

            QueryChangedEventArgs e = new QueryChangedEventArgs();
            e.OldQuery = currentQuery;
            e.Query = query;
            e.OldTable = currentParams;
            currentQuery = query;
            currentParams = new QueryParamsTable();
            object s = null;
            try
            {
                s = InputSettings.Default[getNormalizedName(query)];
            }
            catch
            {
                s = addProperty(query);
            }
            if(s != null && ((string) s).Length > 0)
            {
                currentParams.LoadXml(s as string);
            }
            e.Table = currentParams;
            OnQueryChanged(e);
        }

        public void SaveState()
        {
            if (currentQuery != null)
            {
                InputSettings.Default[getNormalizedName(currentQuery)] = currentParams.ToXMLString();
                InputSettings.Default.Save();
            }
        }

        private string addProperty(string query)
        {
            string name = getNormalizedName(query);
            System.Configuration.SettingsProperty p = new System.Configuration.SettingsProperty(name);
            p.IsReadOnly = false;
            p.PropertyType = typeof(string);
            p.DefaultValue = "";
            p.Provider = InputSettings.Default.Properties["xsltDir"].Provider;
            p.Attributes.Add(typeof(System.Configuration.UserScopedSettingAttribute), new System.Configuration.UserScopedSettingAttribute());
            InputSettings.Default.Properties.Add(p);
            InputSettings.Default.Reload();
            return (string)InputSettings.Default[name];
        }

        protected virtual void OnQueryChanged(QueryChangedEventArgs e)
        {
            OnQueryChange?.Invoke(this, e);
        }

        private string getNormalizedName(string query)
        {
            return Regex.Replace(query.Substring(query.LastIndexOf("\\")), "\\W", "") + "-params";
        }
    }

    public class QueryChangedEventArgs : EventArgs
    {
        public QueryParamsTable Table { get; set; }
        public string OldQuery { get; set; }
        public string Query { get; set; }
        public QueryParamsTable OldTable { get; set; }
    }

    public delegate void OnQueryChangeEventHandler(Object sender, QueryChangedEventArgs e);
}
