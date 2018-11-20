<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="presentIllness">
		<xsl:variable name="hasData" select="PastHistory"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/presentIllness/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-presentIllnessSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="10164-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PRESENT ILLNESS"/>
					<title>History of Present Illness</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="PastHistory" mode="presentIllness-Narrative"/>
							<xsl:apply-templates select="PastHistory" mode="presentIllness-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="presentIllness-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-presentIllnessSection">
		<xsl:if test="string-length($hitsp-CDA-HistoryOfPresentIllnessSection)"><templateId root="{$hitsp-CDA-HistoryOfPresentIllnessSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-HistoryOfPresentIllness)"><templateId root="{$ihe-PCC-HistoryOfPresentIllness}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
