<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="pastIllness">
		<xsl:variable name="currentConditionStatusCodes" select="$exportConfiguration/problems/currentCondition/codes/text()"/>
		<xsl:variable name="currentConditionWindowInDays" select="$exportConfiguration/problems/currentCondition/windowInDays/text()"/>
		<xsl:variable name="hasData" select="Encounters/Encounter/Problems/Problem[not(contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|')) or not(ToTime) or (isc:evaluate('dateDiff', 'dd', translate(translate(FromTime/text(), 'Z', ''), 'T', ' ')) &lt;= $currentConditionWindowInDays))]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/pastIllness/emptySection/exportData/text()"/>

		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-pastIllnessSection"/>

					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="11348-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of Past Illness"/>
					<title>History of Past Illness</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="conditions-Narrative">
								<xsl:with-param name="currentConditions" select="false()"/>
								<xsl:with-param name="narrativeLinkCategory">pastIllness</xsl:with-param>
							</xsl:apply-templates>
							
							<xsl:apply-templates select="Encounters" mode="conditions-Entries">
								<xsl:with-param name="currentConditions" select="false()"/>
								<xsl:with-param name="narrativeLinkCategory">pastIllness</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="pastIllness-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-pastIllnessSection">
		<xsl:if test="string-length($hitsp-CDA-HistoryOfPastIllnessSection)"><templateId root="{$hitsp-CDA-HistoryOfPastIllnessSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-HistoryOfPastIllnessSection)"><templateId root="{$hl7-CCD-HistoryOfPastIllnessSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-HistoryOfPastIllness)"><templateId root="{$ihe-PCC-HistoryOfPastIllness}"/></xsl:if>		
	</xsl:template>
</xsl:stylesheet>
