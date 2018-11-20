<?xml version="1.0" encoding="UTF-8"?>
<!-- Remove documents denied by BPPC -->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="/">
<xsl:apply-templates select="XMLMessage/ContentStream/node()"/>
</xsl:template>

<xsl:template match="rim:ExtrinsicObject|rim:ObjectRef">
<xsl:variable name="key" select="concat('BPPC:Deny:',@id)"/>
<xsl:if test="string-length(/XMLMessage/AdditionalInfo/AdditionalInfoItem[@AdditionalInfoKey=$key]/text())=0">
<xsl:copy-of select="."/>
</xsl:if>
</xsl:template>


</xsl:stylesheet>