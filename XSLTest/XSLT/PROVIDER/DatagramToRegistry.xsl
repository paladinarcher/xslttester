<?xml version="1.0"?>
<!-- Copy HSPD DataGram into HS.Registry.Provider object -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" exclude-result-prefixes="isc" version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:param name="empty">""</xsl:param>

<!-- copy everything as is -->
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<!-- Single code: move value from attribute to text() -->
<xsl:template match="node()[string-length(@Code)>0]">
<xsl:element name="{local-name()}">
<xsl:value-of select="@Code"/>
</xsl:element>
</xsl:template>

<!-- List of codes: move from attribute and rename element from CodeItem to Code -->
<xsl:template match="node()[CodeItem]">
<xsl:element name="{local-name()}">
<xsl:for-each select="CodeItem">
<Code><xsl:value-of select="@Code"/></Code>
</xsl:for-each>
</xsl:element>
</xsl:template>

<!-- Just in case, strip out any "" empty values -->
<xsl:template match="text()">
<xsl:choose>
<xsl:when test=".=$empty"></xsl:when>
<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
</xsl:choose>
</xsl:template>	
</xsl:stylesheet>