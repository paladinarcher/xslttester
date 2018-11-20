<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="SocialHistories">
		<SocialHistory>
			<!-- Process CDA Append/Transform/Replace Directive -->
			<xsl:call-template name="ActionCode">
				<xsl:with-param name="informationType" select="'SocialHistory'"/>
			</xsl:call-template>
			
			<xsl:apply-templates select="hl7:entry/hl7:observation" mode="SocialHistory"/>
		</SocialHistory>
	</xsl:template>
</xsl:stylesheet>
