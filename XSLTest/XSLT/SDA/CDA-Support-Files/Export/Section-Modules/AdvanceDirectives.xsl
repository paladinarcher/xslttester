<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="advanceDirectives">
		<xsl:variable name="hasData" select="Alerts/Alert[contains($advanceDirectiveTypeCodes, concat('|', AlertType/Code/text(), '|'))]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/advanceDirectives/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-advanceDirectivesSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>
					
					<code code="42348-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Advance Directives</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Alerts" mode="advanceDirectives-Narrative"/>
							<xsl:apply-templates select="Alerts" mode="advanceDirectives-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="advanceDirectives-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-advanceDirectivesSection">
		<xsl:if test="string-length($hitsp-CDA-AdvanceDirectivesSection)"><templateId root="{$hitsp-CDA-AdvanceDirectivesSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-AdvanceDirectivesSection)"><templateId root="{$hl7-CCD-AdvanceDirectivesSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-AdvanceDirectives)"><templateId root="{$ihe-PCC-AdvanceDirectives}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CodedAdvanceDirectives)"><templateId root="{$ihe-PCC-CodedAdvanceDirectives}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
