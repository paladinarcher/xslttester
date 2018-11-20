<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="planOfCare">
		<xsl:variable name="hasData" select="Encounters/Encounter/Plan"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/planOfCare/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-planOfCareSection"/>
	
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="18776-5" displayName="Treatment Plan" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Plan of Care</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="planOfCare-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="planOfCare-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="planOfCare-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-planOfCareSection">
		<xsl:if test="string-length($hitsp-CDA-PlanOfCareSection)"><templateId root="{$hitsp-CDA-PlanOfCareSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-PlanOfCareSection)"><templateId root="{$hl7-CCD-PlanOfCareSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-AssessmentAndPlanSection)"><templateId root="{$hl7-CCD-AssessmentAndPlanSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CarePlan)"><templateId root="{$ihe-PCC-CarePlan}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
