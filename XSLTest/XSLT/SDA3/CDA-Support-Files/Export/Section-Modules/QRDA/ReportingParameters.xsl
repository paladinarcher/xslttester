<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="Container" mode="reportingParameters">
		<!--
			QRDA Reporting Parameters are passed in as XSLT input parameters.
			See /csp/xslt/SDA3/CDA-Support-Files/Export/Common/QRDA/Variables.xsl.
		-->
		
		<xsl:variable name="hasData" select="(string-length($reportingPeriodStart) or string-length($reportingPeriodEnd))"/>
		
		<component>
			<section>
				<templateId root="{$qrda-ReportingParametersSection}"/>
				
				<code code="55187-9" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Reporting Parameters"/>
				<title>Reporting Parameters</title>
				
				<xsl:choose>
					<xsl:when test="$hasData">
						<xsl:apply-templates select="." mode="reportingParameters-Narrative"/>
						
						<xsl:apply-templates select="." mode="reportingParameters-Entries"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="reportingParameters-NoData"/>
					</xsl:otherwise>
				</xsl:choose>
			</section>
		</component>
	</xsl:template>
</xsl:stylesheet>
