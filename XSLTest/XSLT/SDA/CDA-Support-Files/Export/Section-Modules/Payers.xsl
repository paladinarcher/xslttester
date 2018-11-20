<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="payers">
		<xsl:variable name="hasData" select="Encounters/Encounter/HealthFunds"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/payers/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-payersSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Payers</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="payers-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="payers-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="payers-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-payersSection">
		<xsl:if test="string-length($hitsp-CDA-PayersSection)"><templateId root="{$hitsp-CDA-PayersSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-PayersSection)"><templateId root="{$hl7-CCD-PayersSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-Payers)"><templateId root="{$ihe-PCC-Payers}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
