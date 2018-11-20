<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Results">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:if test="($sdaActionCodesEnabled = 1) and string-length($documentActionCode) and (position() = 1)">
			<Result>
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'InitiatingOrder'"/>
					<xsl:with-param name="actionScope" select="'LAB'"/>
				</xsl:call-template>
			</Result>
		</xsl:if>
		
		<xsl:apply-templates select="." mode="Result"/>
	</xsl:template>
</xsl:stylesheet>
