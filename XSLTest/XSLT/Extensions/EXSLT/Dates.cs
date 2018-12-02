using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GotDotNet.Exslt;

namespace XSLTest.XSLT.Extensions.EXSLT
{
    class Dates : Extension
    {
        public string NameSpace => "http://exslt.org/dates-and-times";
        public object Object => new ExsltDatesAndTimes();
    }
}
