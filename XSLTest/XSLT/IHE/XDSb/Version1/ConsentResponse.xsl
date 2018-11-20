<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:isc="http://extension-functions.intersystems.com" 

xmlns:xdsb="urn:ihe:iti:xds-b:2007" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"

exclude-result-prefixes="isc">

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
<xsl:choose>

<xsl:when test="/root/query:AdhocQueryResponse">
<query:AdhocQueryResponse status="urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success">
<rs:RegistryErrorList highestSeverity="urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Warning">
<rs:RegistryError codeContext="Consent Filter Applied" errorCode="XDSRegistryError" location="" severity="urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Warning"/>
</rs:RegistryErrorList>
<rim:RegistryObjectList>
<xsl:apply-templates select="//rim:ExtrinsicObject"/>
</rim:RegistryObjectList>
</query:AdhocQueryResponse>
</xsl:when>

<xsl:when test="/root/xdsb:RetrieveDocumentSetResponse">
<xsl:variable name="status">
<xsl:choose>
<xsl:when test="/root/PatientSearchResponse/Results">urn:ihe:iti:2007:ResponseStatusType:PartialSuccess</xsl:when>
<xsl:otherwise>urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xdsb:RetrieveDocumentSetResponse>
<rs:RegistryResponse status="{$status}">
<rs:RegistryErrorList highestSeverity="urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error">
<rs:RegistryError codeContext="Consent Filter Applied" errorCode="XDSRepositoryError" location="" severity="urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error"/>
</rs:RegistryErrorList>
</rs:RegistryResponse>
<xsl:apply-templates select="//xdsb:DocumentResponse"/>
</xdsb:RetrieveDocumentSetResponse>   
</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="rim:ExtrinsicObject">
<xsl:variable name="uuid" select="@id"/>
<xsl:if test="/root/PatientSearchResponse/Results/PatientSearchMatch/MRN[text() = $uuid]">
<xsl:copy-of select="."/>
</xsl:if>
</xsl:template>

<xsl:template match="xdsb:DocumentResponse">
<xsl:variable name="oid" select="xdsb:DocumentUniqueId/text()"/>
<xsl:if test="/root/PatientSearchResponse/Results/PatientSearchMatch/MRN[text() = $oid]">
<xsl:copy-of select="."/>
</xsl:if>
</xsl:template>

</xsl:stylesheet>