<?xml version="1.0" encoding="UTF-8"?>
<!--

CDA generator for OnDemand patient summary

TODO

-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:include href="SDA-to-Z-VA-CCDA-CCD.xsl"/>

	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
		</xsl:processing-instruction>
		<xsl:apply-templates select="Container"/>	
	</xsl:template>
	
</xsl:stylesheet>