using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GotDotNet.Exslt;

namespace XSLTest.XSLT.Extensions.EXSLT
{
    class Strings : Extension
    {
        public string NameSpace => "http://exslt.org/strings";

        public object Object => new ExsltStrings();
    }
}
