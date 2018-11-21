using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace XSLTest.XSLT.Extensions
{
    class InterSystems : Extension
    {
        public string NameSpace => "http://extension-functions.intersystems.com";

        public object Object => new Helper();

        public class Helper
        {
            public string evaluate(string func)
            {
                return evaluate(func, "");
            }
            public string evaluate(string func, string code)
            {
                return evaluate(func, code, "");
            }
            public string evaluate(string func, string code, string system)
            {
                return evaluate(func, code, system, "");
            }
            public string evaluate(string func, string code, string system, string def)
            {
                string ret;
                try
                {
                    switch (func)
                    {
                        case "xmltimestamp":
                            ret =  xmltimestamp(code, system, def);
                            break;
                        case "createGUID":
                            ret =  createGUID(code, system, def);
                            break;
                        case "currentDate":
                            ret =  currentDate(code, system, def);
                            break;
                        case "lookup":
                            ret =  lookup(code, system, def);
                            break;
                        case "dateNoDash":
                            ret =  dateNoDash(code, system, def);
                            break;
                        case "stripapos":
                            ret =  stripapos(code, system, def);
                            break;
                        case "piece":
                            ret =  piece(code, system, def);
                            break;
                        case "pieceStrip":
                            ret =  pieceStrip(code, system, def);
                            break;
                        case "strip":
                            ret =  strip(code, system, def);
                            break;
                        case "encode":
                            ret =  encode(code, system, def);
                            break;
                        case "decode":
                            ret =  decode(code, system, def);
                            break;
                        case "timestamp":
                            ret =  timestamp(code, system, def);
                            break;
                        case "xmltimestampisbefore":
                            ret =  xmltimestampisbefore(code, system, def);
                            break;
                        case "dateDiff":
                            ret =  dateDiff(code, system, def);
                            break;
                        case "GWtoOID":
                            ret =  GWtoOID(code, system, def);
                            break;
                        case "CodetoOID":
                            ret =  CodetoOID(code, system, def);
                            break;
                        case "OIDtoCode":
                            ret =  OIDtoCode(code, system, def);
                            break;
                        case "OIDtoGW":
                            ret =  OIDtoGW(code, system, def);
                            break;
                        case "OIDtoFacilityName":
                            ret =  OIDtoFacilityName(code, system, def);
                            break;
                        case "OIDtoFacilityContact":
                            ret =  OIDtoFacilityContact(code, system, def);
                            break;
                        case "getHomeCommunityCode":
                            ret =  getHomeCommunityCode(code, system, def);
                            break;
                        case "getSystemOID":
                            ret =  getSystemOID(code, system, def);
                            break;
                        case "GetIdentifierType":
                            ret =  GetIdentifierType(code, system, def);
                            break;
                        case "lookupIHETransaction":
                            ret =  lookupIHETransaction(code, system, def);
                            break;
                        case "resultFlag":
                            ret =  resultFlag(code, system, def);
                            break;
                        case "getNumberType":
                            ret =  getNumberType(code, system, def);
                            break;
                        case "debug":
                            ret =  debug(code, system, def);
                            break;
                        case "getOIDForCode":
                            ret =  getOIDForCode(code, system, def);
                            break;
                        case "getCodeForOID":
                            ret =  getCodeForOID(code, system, def);
                            break;
                        case "getDescriptionForOID":
                            ret =  getDescriptionForOID(code, system, def);
                            break;
                        case "getURLForCode":
                            ret =  getURLForCode(code, system, def);
                            break;
                        case "getCodeForURL":
                            ret =  getCodeForURL(code, system, def);
                            break;
                        case "getDescriptionForURL":
                            ret =  getDescriptionForURL(code, system, def);
                            break;
                        case "hex2dec":
                            ret =  hex2dec(code, system, def);
                            break;
                        case "uuid2oid":
                            ret =  uuid2oid(code, system, def);
                            break;
                        case "createUUID":
                            ret =  createUUID(code, system, def);
                            break;
                        case "createOID":
                            ret =  createOID(code, system, def);
                            break;
                        case "createHL7Timestamp":
                            ret =  createHL7Timestamp(code, system, def);
                            break;
                        case "createID":
                            ret =  createID(code, system, def);
                            break;
                        case "varReset":
                            ret =  varReset(code, system, def);
                            break;
                        case "varSet":
                            ret =  varSet(code, system, def);
                            break;
                        case "varGet":
                            ret =  varGet(code, system, def);
                            break;
                        case "varInc":
                            ret =  varInc(code, system, def);
                            break;
                        case "varKill":
                            ret =  varKill(code, system, def);
                            break;
                        case "varData":
                            ret =  varData(code, system, def);
                            break;
                        case "varConcat":
                            ret =  varConcat(code, system, def);
                            break;
                        case "varDebug":
                            ret =  varDebug(code, system, def);
                            break;
                        case "getPreviousUUID":
                            ret =  getPreviousUUID(code, system, def);
                            break;
                        case "encodeURL":
                            ret =  encodeURL(code, system, def);
                            break;
                        case "decodeURL":
                            ret =  decodeURL(code, system, def);
                            break;
                        case "makeURL":
                            ret =  makeURL(code, system, def);
                            break;
                        case "encodeJS":
                            ret =  encodeJS(code, system, def);
                            break;
                        case "decodeJS":
                            ret =  decodeJS(code, system, def);
                            break;
                        case "getConfigValue":
                            ret =  getConfigValue(code, system, def);
                            break;
                        case "getHierarchicalConfigValue":
                            ret =  getHierarchicalConfigValue(code, system, def);
                            break;
                        case "getCodedEntryConfig":
                            ret =  getCodedEntryConfig(code, system, def);
                            break;
                        case "getCID":
                            ret =  getCID(code, system, def);
                            break;
                        case "getUniqueTime":
                            ret =  getUniqueTime(code, system, def);
                            break;
                        case "toUpper":
                            ret =  toUpper(code, system, def);
                            break;
                        case "toLower":
                            ret =  toLower(code, system, def);
                            break;
                        case "getServiceNameFromOID":
                            ret =  getServiceNameFromOID(code, system, def);
                            break;
                        case "getServiceHostFromOID":
                            ret =  getServiceHostFromOID(code, system, def);
                            break;
                        case "getServiceURLFromOID":
                            ret =  getServiceURLFromOID(code, system, def);
                            break;
                        case "getServiceNameFromURL":
                            ret =  getServiceNameFromURL(code, system, def);
                            break;
                        case "getServiceOIDFromURL":
                            ret =  getServiceOIDFromURL(code, system, def);
                            break;
                        case "addFilterEntity":
                            ret =  addFilterEntity(code, system, def);
                            break;
                        case "includeEntity":
                            ret =  includeEntity(code, system, def);
                            break;
                        case "generateVisitNumber":
                            ret =  generateVisitNumber(code, system, def);
                            break;
                        case "addStreamletType":
                            ret =  addStreamletType(code, system, def);
                            break;
                        case "recordSDAData":
                            ret =  recordSDAData(code, system, def);
                            break;
                        case "xmltimestampToUTC":
                            ret =  xmltimestampToUTC(code, system, def);
                            break;
                        case "getQuickStream":
                            ret =  getQuickStream(code, system, def);
                            break;
                        case "getMeasuresTemplates":
                            ret =  getMeasuresTemplates(code, system, def);
                            break;
                        case "getMeasuresHeaderInfo":
                            ret =  getMeasuresHeaderInfo(code, system, def);
                            break;
                        case "getMeasuresSetIds":
                            ret =  getMeasuresSetIds(code, system, def);
                            break;
                        case "getValueSetOIDs":
                            ret =  getValueSetOIDs(code, system, def);
                            break;
                        case "setHSValueSetEntry":
                            ret =  setHSValueSetEntry(code, system, def);
                            break;
                        case "addUTCtoDateTime":
                            ret =  addUTCtoDateTime(code, system, def);
                            break;
                        case "xmltimestampToLocal":
                            ret =  xmltimestampToLocal(code, system, def);
                            break;
                        default:
                            throw new NotImplementedException(func + " is an unknown function");
                    }
                }
                catch (Exception er)
                {
                    ret = func + "(" + code + ", " + system + ", " + def + ")";
                }
                //System.Diagnostics.Debug.WriteLine(func + "(" + code + ", " + system + ", " + def + ") == "+ret);
                return ret;
            }

            private string xmltimestampToLocal(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string addUTCtoDateTime(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string setHSValueSetEntry(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getValueSetOIDs(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getMeasuresSetIds(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getMeasuresHeaderInfo(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getMeasuresTemplates(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getQuickStream(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string xmltimestampToUTC(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string recordSDAData(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string addStreamletType(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string includeEntity(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string generateVisitNumber(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string addFilterEntity(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getServiceOIDFromURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getServiceNameFromURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getServiceURLFromOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getServiceHostFromOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getServiceNameFromOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string toLower(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string toUpper(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getUniqueTime(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getCID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getCodedEntryConfig(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getHierarchicalConfigValue(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getConfigValue(string code, string system, string def)
            {
                object ret = InputSettings.Default[code.Replace('\\', '_')];
                if(ret == null)
                {
                    throw new NotImplementedException(MethodBase.GetCurrentMethod().Name + " doesn't exist yet.");
                }
                return ret as string;
            }

            private string decodeJS(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string encodeJS(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string makeURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string decodeURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string encodeURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getPreviousUUID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varDebug(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varConcat(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varData(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varKill(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varInc(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varGet(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varSet(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string varReset(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string createID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string createHL7Timestamp(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string createOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string createUUID(string code, string system, string def)
            {
                return Guid.NewGuid().ToString();
            }

            private string uuid2oid(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string hex2dec(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getDescriptionForURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getCodeForURL(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getURLForCode(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getDescriptionForOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getCodeForOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getOIDForCode(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string debug(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getNumberType(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string resultFlag(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string lookupIHETransaction(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string GetIdentifierType(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getSystemOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string getHomeCommunityCode(string code, string system, string def)
            {
                return (string)InputSettings.Default.HCID;
            }

            private string OIDtoFacilityContact(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string OIDtoFacilityName(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string OIDtoGW(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string OIDtoCode(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string CodetoOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string GWtoOID(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string dateDiff(string code, string system, string def)
            {
                DateTime start;
                DateTime end;
                try
                {
                    start = DateTime.Parse(system);
                }
                catch
                {
                    start = DateTime.Now;
                }
                try
                {
                    end = DateTime.Parse(def);
                }
                catch
                {
                    end = DateTime.Now;
                }
                //System.Diagnostics.Debug.WriteLine("DateDiff "+end.ToString()+" - "+start.ToString()+" = "+((end - start).Days.ToString())+" [" + MethodBase.GetCurrentMethod().Name + "([" + code + "],[" + system + "],[" + def + "])]");
                return (end - start).Days.ToString();
            }

            private string xmltimestampisbefore(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string timestamp(string code, string system, string def)
            {
                return DateTime.Now.ToString("yyyyMMddHHmmss");
            }

            private string decode(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string encode(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string strip(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string pieceStrip(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string piece(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string stripapos(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string dateNoDash(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string lookup(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string currentDate(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }

            private string createGUID(string code, string system, string def)
            {
                return Guid.NewGuid().ToString();
            }

            private string xmltimestamp(string code, string system, string def)
            {
                return " UNKNOWN_FUNC["+MethodBase.GetCurrentMethod().Name+"(["+code+"],["+system+"],["+def+"])]";
            }
        }
    }
}
