<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="HealthcareProvider">
		<!-- Family Doctor -->
		<xsl:apply-templates select="hl7:serviceEvent/hl7:performer[hl7:functionCode/@codeSystem='2.16.840.1.113883.12.443' and hl7:functionCode/@code='PP'][1]" mode="FamilyDoctor"/>
	</xsl:template>
</xsl:stylesheet>
