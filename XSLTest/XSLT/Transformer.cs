using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Data;

namespace XSLTest.XSLT
{
    class Transformer
    {
        private XslCompiledTransform xslt;
        private readonly XmlWriterSettings settings;
        private XsltArgumentList xslArgs;
        private bool loaded;
        private string tmpWrapperFilename;
        private Dictionary<string, string> args;

        public event OnParameterEmergencyAddEventHandler OnParameterEmergencyAdd;

        public Transformer()
        {
            xslt = new XslCompiledTransform(true);

            settings = new XmlWriterSettings
            {
                Indent = true
            };

            xslArgs = new XsltArgumentList();
            args = new Dictionary<string, string>();
            loaded = false;

            tmpWrapperFilename = Path.GetTempPath() + "XSLTbaseStub.xsl";
        }

        public void SetSourceXSLT(string filePath)
        {
            filloutTmpFile(filePath);
            XmlTextReader tmp = new XmlTextReader(tmpWrapperFilename);
            SetSourceXSLT(tmp, filePath);
            tmp.Close();
        }
        public void SetSourceXSLT(XmlReader xsl, string originalFilePath)
        {
            loaded = false;
            XsltSettings s = new XsltSettings(true, true);
            setSourceXSLT(xsl, s, new XmlUrlResolver(), originalFilePath);
            loaded = true;
        }

        private void setSourceXSLT(XmlReader x, XsltSettings s, XmlResolver r, string originalFilePath)
        {
            try
            {
                xslt.Load(x, s, r);
            }
            catch (System.Xml.Xsl.XsltException e)
            {
                string msg = e.Message;
                if (msg.IndexOf("variable or parameter ") < 0 || msg.IndexOf("not defined or it is out of scope") < 0)
                {
                    throw e;
                }
                x.Close();
                int st = msg.IndexOf("'")+1;
                int en = msg.IndexOf("'", st);
                string variable = msg.Substring(st, en - st);
                string newVal = "UNKNOWN_VARIABLE_"+variable;
                AddParameter(variable, newVal, true, true);
                OnParameterEmergencyAdded(new OnParameterEmergencyArgs(variable, newVal, e));
                filloutTmpFile(originalFilePath);
                XmlTextReader tmp = new XmlTextReader(tmpWrapperFilename);
                try
                {
                    setSourceXSLT(tmp, s, r, originalFilePath);
                }
                finally
                {
                    tmp.Close();
                }
            }
        }
        protected void OnParameterEmergencyAdded(OnParameterEmergencyArgs args)
        {
            OnParameterEmergencyAdd?.Invoke(this, args);
        }

        public void AddExtension(Extensions.Extension e)
        {
            xslArgs.AddExtensionObject(e.NameSpace, e.Object);
        }

        public void AddArguments(Query.QueryParamsTable table)
        {
            foreach(DataRow r in table.Rows)
            {
                string n = (string)r["Name"];
                string v = (string)r["Value"];
                if(r["AddParam"].GetType() == typeof(DBNull)) { r["AddParam"] = true; }
                if(r["SetParam"].GetType() == typeof(DBNull)) { r["SetParam"] = true; }
                bool a = (bool)(r["AddParam"]);
                bool s = (bool)(r["SetParam"]);
                AddParameter(n, v, a, s);
            }
        }

        public void AddParameter(string name, string value, bool addParam, bool setParam)
        {
            if (setParam)
            {
                xslArgs.RemoveParam(name, "");
                xslArgs.AddParam(name, "", value);
            }
            if (addParam)
            {
                if (args.ContainsKey(name)) { args[name] = value; }
                else { args.Add(name, value); }
            }
        }

        public void TransformXML(Stream instream, Stream outstream)
        {
            XmlWriter writer = XmlWriter.Create(outstream, settings);
            try
            {
                xslt.Transform(XmlReader.Create(instream), xslArgs, writer);
            }
            finally
            {
                writer.Close();
            }
        }
        public bool IsLoaded()
        {
            return loaded;
        }
        private void filloutTmpFile(String filename)
        {
            List<string> buffer = new List<string>();
            buffer.Add("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            buffer.Add("<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" >");
            foreach(KeyValuePair<string, string> nv in args)
            {
                buffer.Add("  <xsl:param name=\""+nv.Key+"\" select=\"'"+nv.Value+"'\" />");
            }
            buffer.Add("  <xsl:include href=\"" + filename + "\"/>");
            buffer.Add("</xsl:stylesheet>");

            File.WriteAllLines(tmpWrapperFilename, buffer.ToArray());
        }
    }

    public class OnParameterEmergencyArgs : EventArgs
    {
        public OnParameterEmergencyArgs(string name, string value, Exception e)
        {
            Name = name;
            Value = value;
            CausingError = e;
        }
        public string Name { get; set; }
        public string Value { get; set; }
        public Exception CausingError { get; set; }
    }

    public delegate void OnParameterEmergencyAddEventHandler(Object sender, OnParameterEmergencyArgs e);
}
