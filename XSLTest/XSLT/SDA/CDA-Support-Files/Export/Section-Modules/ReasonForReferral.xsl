<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="reasonForReferral">
		<xsl:variable name="hasData" select="string-length($eventReason)"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/reasonForReferral/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-reasonForReferralSection"/>
	
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="42349-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="REASON FOR REFERRAL"/>
					<title>Reason for Referral</title>
	
					<xsl:choose>
						<xsl:when test="$hasData"><xsl:apply-templates select="." mode="reasonForReferral-Narrative"/></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="." mode="reasonForReferral-NoData"/></xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="reasonForReferral-Narrative">
		<text><xsl:value-of select="$eventReason" disable-output-escaping="yes"/></text>
	</xsl:template>

	<xsl:template match="*" mode="reasonForReferral-NoData">
		<text><xsl:value-of select="$exportConfiguration/reasonForReferral/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template name="templateIDs-reasonForReferralSection">
		<xsl:if test="string-length($hitsp-CDA-ReasonForReferralSection)"><templateId root="{$hitsp-CDA-ReasonForReferralSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ReasonForReferralSection)"><templateId root="{$hl7-CCD-ReasonForReferralSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ReasonForReferral)"><templateId root="{$ihe-PCC-ReasonForReferral}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CodedReasonForReferral)"><templateId root="{$ihe-PCC-CodedReasonForReferral}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
