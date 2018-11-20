<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ns0="urn:ihe:iti:svs:2008" xmlns:hl7="urn:hl7-org:v3" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc exsl set hl7">
<xsl:param name="code" select="''"/>

<xsl:output omit-xml-declaration="yes" indent="yes" method="xml"/>

<!--
	VSAC-to-HSValueSet.xsl parses a value set XML file from the
	the Value Set Authority Center (VSAC) and uses isc:evaluate
	calls to populate the value set information into a Cache
	storage structure.
	
	The VSAC offers several different formats of XML file, based
	on varying sort options.  This XSLT is intended to transform
	a XML sorted by the value set unique identifier.
-->
<xsl:template match="/ns0:RetrieveMultipleValueSetsResponse">
<xsl:apply-templates select="ns0:DescribedValueSet"/>
</xsl:template>

<xsl:template match="ns0:DescribedValueSet">
<xsl:apply-templates select="ns0:Group[@displayName='GUID']">
<xsl:with-param name="valueSetOID" select="@ID"/>
<xsl:with-param name="valueSetName" select="@displayName"/>
<xsl:with-param name="valueSetVersion" select="@version"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="ns0:Group">
<xsl:param name="valueSetOID"/>
<xsl:param name="valueSetName"/>
<xsl:param name="valueSetVersion"/>

<xsl:variable name="guid" select="ns0:Keyword/text()"/>
<xsl:apply-templates select="../ns0:ConceptList/ns0:Concept">
<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
<xsl:with-param name="valueSetName" select="$valueSetName"/>
<xsl:with-param name="valueSetVersion" select="$valueSetVersion"/>
<xsl:with-param name="guid" select="$guid"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="ns0:Concept">
<xsl:param name="valueSetOID"/>
<xsl:param name="valueSetName"/>
<xsl:param name="valueSetVersion"/>
<xsl:param name="guid"/>

<xsl:if test="isc:evaluate('setHSValueSetEntry',$valueSetOID,$valueSetName,$valueSetVersion,@code,@codeSystem,@codeSystemVersion,@displayName,$guid)"/>
</xsl:template>
</xsl:stylesheet>