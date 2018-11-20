<?xml version="1.0" encoding="UTF-8"?>
<!--

CDA generator for OnDemand encounter summary

TODO

-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:include href="SDA-to-Z-CCDAv21-PRG.xsl"/>
	<!--
	<xsl:include href="../SDA-to-CCDAv21-PRG.xsl"/>
	-->
	
	<xsl:variable name="flavor" select="'SES'"/>
	
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
		</xsl:processing-instruction>
		<xsl:apply-templates select="Container"/>	
	</xsl:template>
	
	<!--  hack: override the standard which names this a "progress note" -->
	<xsl:template match="Container" mode="fn-title-forDocument">
		<xsl:param name="title1"/>
		<title>Encounter Summary</title>
	</xsl:template>
	
</xsl:stylesheet>