using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace XSLTest.XSLT
{
    class Transformer
    {
        private XslCompiledTransform xslt;
        private readonly XmlWriterSettings settings;
        private XsltArgumentList xslArgs;
        private bool loaded;

        public Transformer()
        {
            xslt = new XslCompiledTransform(true);

            settings = new XmlWriterSettings
            {
                Indent = true
            };

            xslArgs = new XsltArgumentList();
            loaded = false;
        }
        public Transformer(XmlReader xsl) : this()
        {
            SetSourceXSLT(xsl);
        }
        public Transformer(XmlReader xsl, Extensions.Extension[] extensions) : this(xsl)
        {
            foreach(Extensions.Extension e in extensions)
            {
               AddExtension(e);
            }
        }

        public void SetSourceXSLT(string filePath)
        {
            //FileInfo f = new FileInfo(filePath);
            //Directory.SetCurrentDirectory(f.DirectoryName);
            //FileStream fs = new FileStream(filePath, FileMode.Open);
            SetSourceXSLT(new XmlTextReader(filePath));
        }
        public void SetSourceXSLT(XmlReader xsl)
        {
            loaded = false;
            XsltSettings s = new XsltSettings(true, true);
            xslt.Load(xsl, s, new XmlUrlResolver());
            loaded = true;
        }

        public void AddExtension(Extensions.Extension e)
        {
            xslArgs.AddExtensionObject(e.NameSpace, e.Object);
        }

        public void TransformXML(Stream instream, Stream outstream)
        {
            XmlWriter writer = XmlWriter.Create(outstream, settings);
            xslt.Transform(XmlReader.Create(instream), xslArgs, writer);
            writer.Close();
        }
        public bool IsLoaded()
        {
            return loaded;
        }
    }
}
