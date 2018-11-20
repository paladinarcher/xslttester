<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="familyHistory">
		<xsl:variable name="hasData" select="FamilyHistory"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/familyHistory/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templatedIDs-familyHistorySection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="10157-6" codeSystem="2.16.840.1.113883.6.1"/>
					<title>Family History</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="FamilyHistory" mode="familyHistory-Narrative"/>
							<xsl:apply-templates select="FamilyHistory" mode="familyHistory-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="familyHistory-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templatedIDs-familyHistorySection">
		<xsl:if test="string-length($hitsp-CDA-FamilyHistorySection)"><templateId root="{$hitsp-CDA-FamilyHistorySection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-FamilyHistorySection)"><templateId root="{$hl7-CCD-FamilyHistorySection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-FamilyMedicalHistory)"><templateId root="{$ihe-PCC-FamilyMedicalHistory}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CodedFamilyMedicalHistory)"><templateId root="{$ihe-PCC-CodedFamilyMedicalHistory}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
