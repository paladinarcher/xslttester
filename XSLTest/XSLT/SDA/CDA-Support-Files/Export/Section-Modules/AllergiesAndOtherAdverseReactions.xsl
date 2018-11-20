<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="allergies">
		<xsl:variable name="hasData" select="Allergies"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/allergies/emptySection/exportData/text()"/>

		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-allergiesSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="48765-2" displayName="Allergies, Adverse Reactions, Alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Allergies, Adverse Reactions, Alerts</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Allergies" mode="allergies-Narrative"/>
							<xsl:apply-templates select="Allergies" mode="allergies-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="allergies-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-allergiesSection">
		<xsl:if test="string-length($hitsp-CDA-AllergiesAndOtherAdverseReactionsSection)"><templateId root="{$hitsp-CDA-AllergiesAndOtherAdverseReactionsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-AlertsSection)"><templateId root="{$hl7-CCD-AlertsSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-AllergiesAndOtherAdverseReactions)"><templateId root="{$ihe-PCC-AllergiesAndOtherAdverseReactions}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
