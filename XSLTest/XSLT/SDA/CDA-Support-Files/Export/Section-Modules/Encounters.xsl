<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="encounters">
		<xsl:variable name="hasData" select="Encounters[not(contains('|G|S|', concat('|', Encounter/EncounterType/text(), '|')))]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/encounters/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-encountersSection"/>
	
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="46240-8" displayName="History of Encounters" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Encounters</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="encounters-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="encounters-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="encounters-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-encountersSection">
		<xsl:if test="string-length($hitsp-CDA-EncountersSection)"><templateId root="{$hitsp-CDA-EncountersSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-EncountersSection)"><templateId root="{$hl7-CCD-EncountersSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-EncounterHistories)"><templateId root="{$ihe-PCC-EncounterHistories}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
