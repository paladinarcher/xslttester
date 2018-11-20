<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="HealthFunds">
		
		<!-- ActionCode is not supported for HealthFund, causes parse error in SDA3. -->
		
		<xsl:apply-templates select=".//hl7:act[hl7:templateId/@root=$payersEntryCoverageTemplateId]" mode="HealthFund"/>
	</xsl:template>
</xsl:stylesheet>
