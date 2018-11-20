<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<!--
		All other templates for this AU version of Medication.xsl
		are in the base Medication.xsl.
	-->
	<xsl:template match="*" mode="Indication">
		<Indication><xsl:apply-templates select="hl7:act/hl7:text" mode="TextValue"/></Indication>
	</xsl:template>
</xsl:stylesheet>
