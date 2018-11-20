<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform a Provider ErrorResponse into DSMLv2 -->
<xsl:stylesheet xmlns="urn:oasis:names:tc:DSML:2:0:core"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			 exclude-result-prefixes="xsi"
			 version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- Create the DSML errorResponse -->
<xsl:template match="ErrorResponse">
   <errorResponse>
	   <xsl:attribute name="requestID"><xsl:value-of select="RequestID"/></xsl:attribute>
	   <xsl:attribute name="type"><xsl:value-of select="Type"/></xsl:attribute>
	   <message><xsl:value-of select="ErrorMessage"/></message>
   </errorResponse>
</xsl:template>

</xsl:stylesheet>