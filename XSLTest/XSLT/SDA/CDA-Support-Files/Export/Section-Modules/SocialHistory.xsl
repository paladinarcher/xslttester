<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="socialHistory">
		<xsl:variable name="hasData" select="SocialHistory"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/socialHistory/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-socialHistorySection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="29762-2" codeSystem="2.16.840.1.113883.6.1"/>
					<title>Social History</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="SocialHistory" mode="socialHistory-Narrative"/>
							<xsl:apply-templates select="SocialHistory" mode="socialHistory-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="socialHistory-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-socialHistorySection">
		<xsl:if test="string-length($hitsp-CDA-SocialHistorySection)"><templateId root="{$hitsp-CDA-SocialHistorySection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-SocialHistorySection)"><templateId root="{$hl7-CCD-SocialHistorySection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SocialHistory)"><templateId root="{$ihe-PCC-SocialHistory}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
