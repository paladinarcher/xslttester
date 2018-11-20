<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="immunizations">
		<!-- C = Cancelled, D = Discontinued -->
		<xsl:variable name="immunizationCancelledStatusCodes">|C|D|</xsl:variable>
		<xsl:variable name="hasData" select="Encounters/Encounter/Medications/Medication[(OrderItem/OrderType = 'VXU') and not(contains($immunizationCancelledStatusCodes, concat('|', Status/text(), '|')))]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/immunizations/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-immunizationsSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="11369-6" displayName="History of Immunizations" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Immunizations</title>
					
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="immunizations-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="immunizations-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="immunizations-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-immunizationsSection">
		<xsl:if test="string-length($hitsp-CDA-ImmunizationsSection)"><templateId root="{$hitsp-CDA-ImmunizationsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ImmunizationsSection)"><templateId root="{$hl7-CCD-ImmunizationsSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-Immunizations)"><templateId root="{$ihe-PCC-Immunizations}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>