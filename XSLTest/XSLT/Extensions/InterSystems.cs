using System;
using System.Collections.Generic;
using System.Linq;
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
                try
                {
                    switch (func)
                    {
                        case "xmltimestamp":
                            return xmltimestamp(code, system, def);
                        case "createGUID":
                            return createGUID(code, system, def);
                        case "currentDate":
                            return currentDate(code, system, def);
                        case "lookup":
                            return lookup(code, system, def);
                        case "dateNoDash":
                            return dateNoDash(code, system, def);
                        case "stripapos":
                            return stripapos(code, system, def);
                        case "piece":
                            return piece(code, system, def);
                        case "pieceStrip":
                            return pieceStrip(code, system, def);
                        case "strip":
                            return strip(code, system, def);
                        case "encode":
                            return encode(code, system, def);
                        case "decode":
                            return decode(code, system, def);
                        case "timestamp":
                            return timestamp(code, system, def);
                        case "xmltimestampisbefore":
                            return xmltimestampisbefore(code, system, def);
                        case "dateDiff":
                            return dateDiff(code, system, def);
                        case "GWtoOID":
                            return GWtoOID(code, system, def);
                        case "CodetoOID":
                            return CodetoOID(code, system, def);
                        case "OIDtoCode":
                            return OIDtoCode(code, system, def);
                        case "OIDtoGW":
                            return OIDtoGW(code, system, def);
                        case "OIDtoFacilityName":
                            return OIDtoFacilityName(code, system, def);
                        case "OIDtoFacilityContact":
                            return OIDtoFacilityContact(code, system, def);
                        case "getHomeCommunityCode":
                            return getHomeCommunityCode(code, system, def);
                        case "getSystemOID":
                            return getSystemOID(code, system, def);
                        case "GetIdentifierType":
                            return GetIdentifierType(code, system, def);
                        case "lookupIHETransaction":
                            return lookupIHETransaction(code, system, def);
                        case "resultFlag":
                            return resultFlag(code, system, def);
                        case "getNumberType":
                            return getNumberType(code, system, def);
                        case "debug":
                            return debug(code, system, def);
                        case "getOIDForCode":
                            return getOIDForCode(code, system, def);
                        case "getCodeForOID":
                            return getCodeForOID(code, system, def);
                        case "getDescriptionForOID":
                            return getDescriptionForOID(code, system, def);
                        case "getURLForCode":
                            return getURLForCode(code, system, def);
                        case "getCodeForURL":
                            return getCodeForURL(code, system, def);
                        case "getDescriptionForURL":
                            return getDescriptionForURL(code, system, def);
                        case "hex2dec":
                            return hex2dec(code, system, def);
                        case "uuid2oid":
                            return uuid2oid(code, system, def);
                        case "createUUID":
                            return createUUID(code, system, def);
                        case "createOID":
                            return createOID(code, system, def);
                        case "createHL7Timestamp":
                            return createHL7Timestamp(code, system, def);
                        case "createID":
                            return createID(code, system, def);
                        case "varReset":
                            return varReset(code, system, def);
                        case "varSet":
                            return varSet(code, system, def);
                        case "varGet":
                            return varGet(code, system, def);
                        case "varInc":
                            return varInc(code, system, def);
                        case "varKill":
                            return varKill(code, system, def);
                        case "varData":
                            return varData(code, system, def);
                        case "varConcat":
                            return varConcat(code, system, def);
                        case "varDebug":
                            return varDebug(code, system, def);
                        case "getPreviousUUID":
                            return getPreviousUUID(code, system, def);
                        case "encodeURL":
                            return encodeURL(code, system, def);
                        case "decodeURL":
                            return decodeURL(code, system, def);
                        case "makeURL":
                            return makeURL(code, system, def);
                        case "encodeJS":
                            return encodeJS(code, system, def);
                        case "decodeJS":
                            return decodeJS(code, system, def);
                        case "getConfigValue":
                            return getConfigValue(code, system, def);
                        case "getHierarchicalConfigValue":
                            return getHierarchicalConfigValue(code, system, def);
                        case "getCodedEntryConfig":
                            return getCodedEntryConfig(code, system, def);
                        case "getCID":
                            return getCID(code, system, def);
                        case "getUniqueTime":
                            return getUniqueTime(code, system, def);
                        case "toUpper":
                            return toUpper(code, system, def);
                        case "toLower":
                            return toLower(code, system, def);
                        case "getServiceNameFromOID":
                            return getServiceNameFromOID(code, system, def);
                        case "getServiceHostFromOID":
                            return getServiceHostFromOID(code, system, def);
                        case "getServiceURLFromOID":
                            return getServiceURLFromOID(code, system, def);
                        case "getServiceNameFromURL":
                            return getServiceNameFromURL(code, system, def);
                        case "getServiceOIDFromURL":
                            return getServiceOIDFromURL(code, system, def);
                        case "addFilterEntity":
                            return addFilterEntity(code, system, def);
                        case "includeEntity":
                            return includeEntity(code, system, def);
                        case "generateVisitNumber":
                            return generateVisitNumber(code, system, def);
                        case "addStreamletType":
                            return addStreamletType(code, system, def);
                        case "recordSDAData":
                            return recordSDAData(code, system, def);
                        case "xmltimestampToUTC":
                            return xmltimestampToUTC(code, system, def);
                        case "getQuickStream":
                            return getQuickStream(code, system, def);
                        case "getMeasuresTemplates":
                            return getMeasuresTemplates(code, system, def);
                        case "getMeasuresHeaderInfo":
                            return getMeasuresHeaderInfo(code, system, def);
                        case "getMeasuresSetIds":
                            return getMeasuresSetIds(code, system, def);
                        case "getValueSetOIDs":
                            return getValueSetOIDs(code, system, def);
                        case "setHSValueSetEntry":
                            return setHSValueSetEntry(code, system, def);
                        case "addUTCtoDateTime":
                            return addUTCtoDateTime(code, system, def);
                        case "xmltimestampToLocal":
                            return xmltimestampToLocal(code, system, def);
                        default:
                            throw new NotImplementedException(func + " is an unknown function");
                    }
                }
                catch (Exception er)
                {
                    return func + "(" + code + ", " + system + ", " + def + ")";
                }
            }

            private string xmltimestampToLocal(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string addUTCtoDateTime(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string setHSValueSetEntry(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getValueSetOIDs(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getMeasuresSetIds(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getMeasuresHeaderInfo(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getMeasuresTemplates(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getQuickStream(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string xmltimestampToUTC(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string recordSDAData(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string addStreamletType(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string includeEntity(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string generateVisitNumber(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string addFilterEntity(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getServiceOIDFromURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getServiceNameFromURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getServiceURLFromOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getServiceHostFromOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getServiceNameFromOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string toLower(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string toUpper(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getUniqueTime(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getCID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getCodedEntryConfig(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getHierarchicalConfigValue(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getConfigValue(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string decodeJS(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string encodeJS(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string makeURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string decodeURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string encodeURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getPreviousUUID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varDebug(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varConcat(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varData(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varKill(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varInc(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varGet(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varSet(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string varReset(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string createID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string createHL7Timestamp(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string createOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string createUUID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string uuid2oid(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string hex2dec(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getDescriptionForURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getCodeForURL(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getURLForCode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getDescriptionForOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getCodeForOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getOIDForCode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string debug(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getNumberType(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string resultFlag(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string lookupIHETransaction(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string GetIdentifierType(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getSystemOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string getHomeCommunityCode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string OIDtoFacilityContact(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string OIDtoFacilityName(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string OIDtoGW(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string OIDtoCode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string CodetoOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string GWtoOID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string dateDiff(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string xmltimestampisbefore(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string timestamp(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string decode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string encode(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string strip(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string pieceStrip(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string piece(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string stripapos(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string dateNoDash(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string lookup(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string currentDate(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string createGUID(string code, string system, string def)
            {
                throw new NotImplementedException();
            }

            private string xmltimestamp(string code, string system, string def)
            {
                throw new NotImplementedException();
            }
        }
    }
}
