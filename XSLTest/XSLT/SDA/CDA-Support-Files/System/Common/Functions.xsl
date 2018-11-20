<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" name="copyNodeTree" mode="copy" priority="2">
		<xsl:element namespace="urn:hl7-org:v3" name="{local-name()}">
			<xsl:apply-templates select="@*|node()" mode="copy"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@*|node()" mode="copy">
		<xsl:copy><xsl:apply-templates select="@*|node()" mode="copy" /></xsl:copy>
	</xsl:template>
</xsl:stylesheet>
