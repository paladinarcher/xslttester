using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XSLTest.XSLT.Extensions
{
    interface Extension
    {
        string NameSpace { get; }

        object Object { get; }
    }
}
