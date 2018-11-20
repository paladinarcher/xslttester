<?xml version="1.0"?>
<!--
Create a viewer fetch cache item from a CDA nonXMLBody element
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">
<xsl:apply-templates select="hl7:ClinicalDocument"/>
</xsl:template>

<xsl:template match="hl7:ClinicalDocument">
<CacheItem>
<xsl:apply-templates select="hl7:component/hl7:nonXMLBody/hl7:text"/>
</CacheItem>
</xsl:template>

<xsl:template match="hl7:text">
<xsl:if test="@representation='B64'">
<ContentType><xsl:value-of select="@mediaType"/></ContentType>
<Content><xsl:value-of select="text()"/></Content>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
