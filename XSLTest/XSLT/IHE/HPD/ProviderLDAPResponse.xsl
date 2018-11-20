<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform a Provider LDAPResponse into DSMLv2 -->
<xsl:stylesheet xmlns="urn:oasis:names:tc:DSML:2:0:core"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			 exclude-result-prefixes="xsi"
			 version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- Create the DSML Response -->
<xsl:template match="Response">
	<xsl:variable name="responseType">
		<xsl:choose>
			<xsl:when test="ResponseType='ADD'">addResponse</xsl:when>
			<xsl:when test="ResponseType='MOD'">modifyResponse</xsl:when>
			<xsl:when test="ResponseType='DEL'">delResponse</xsl:when>
			<xsl:when test="ResponseType='MDN'">modDNResponse</xsl:when>
			<xsl:when test="ResponseType='AUT'">authResponse</xsl:when>
			<xsl:when test="ResponseType='CMP'">compareResponse</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:element name="{$responseType}">
		<xsl:attribute name="requestID"><xsl:value-of select="RequestID"/></xsl:attribute>
		<xsl:call-template name="LDAPResult">
			<xsl:with-param name="message" select="ErrorMessage"/>
			<xsl:with-param name="resultCode" select="ResultCode"/>
		</xsl:call-template>
   </xsl:element>
</xsl:template>

</xsl:stylesheet>