<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">
  <!-- Entry module has non-parallel name. AlsoInclude: InsuranceProvider.xsl -->
	
	<xsl:template match="hl7:entry" mode="sP-HealthFunds">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'HealthFund'"/>
		</xsl:call-template>
		
		<xsl:apply-templates select=".//hl7:act[hl7:templateId/@root=$ccda-CoverageActivity]" mode="eIP-HealthFund"/>
	</xsl:template>
	
</xsl:stylesheet>