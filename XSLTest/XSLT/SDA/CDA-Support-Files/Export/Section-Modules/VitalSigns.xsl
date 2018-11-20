<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="vitalSigns">
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/vitalSigns/emptySection/exportData/text()"/>
		
		<!-- We only want to export Observations that are LOINC vital signs or can  -->
		<!-- be converted to LOINC vital signs. Parse all Observations and build    -->
		<!-- validVitalSigns with the codes of those that we want to export. This   -->
		<!-- is done to prevent another parse of Observations later.                -->
		<xsl:variable name="validVitalSigns">
			<xsl:variable name="loincVitalSignCodes">|9279-1|8867-4|2710-2|8480-6|8462-4|8310-5|8302-2|8306-3|8287-5|3141-9|</xsl:variable>
			<xsl:for-each select="Encounters/Encounter/Observations/Observation">
				<xsl:if test="contains($loincVitalSignCodes, concat('|', ObservationCode/Code/text(), '|'))"><xsl:value-of select="concat(ObservationCode/Code/text(), '|')"/></xsl:if>
				<xsl:variable name="dU" select="isc:evaluate('toUpper', ObservationCode/Description/text())"/>
				<xsl:if test="contains($dU,'RESPIRATORY') or contains($dU,'RESP RATE') or contains($dU,'RESPIRATION') or contains($dU,'HEART RATE') or contains($dU,'PULSE') or contains($dU,'O2 SAT') or contains($dU,'O2SAT') or contains($dU,'SO2') or contains($dU,'SYSTOLIC') or contains($dU,'DIASTOLIC') or contains($dU, 'TEMP') or contains($dU,'CRANIUM') or contains($dU,'SKULL') or contains($dU,'HEAD') or contains($dU,'WEIGHT') or contains($dU,'HEIGHT')"><xsl:value-of select="concat(ObservationCode/Code/text(), '|')"/></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="string-length($validVitalSigns) or (not(string-length($validVitalSigns)) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-vitalSignsSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Vital Signs"/>
					<title>Vital Signs</title>
	
					<xsl:choose>
						<xsl:when test="$validVitalSigns">
							<xsl:apply-templates select="Encounters" mode="vitalSigns-Narrative">
								<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="Encounters" mode="vitalSigns-Entries">
								<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="vitalSigns-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-vitalSignsSection">
		<xsl:if test="string-length($hitsp-CDA-VitalSignsSection)"><templateId root="{$hitsp-CDA-VitalSignsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-VitalSignsSection)"><templateId root="{$hl7-CCD-VitalSignsSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-VitalSigns)"><templateId root="{$ihe-PCC-VitalSigns}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CodedVitalSigns)"><templateId root="{$ihe-PCC-CodedVitalSigns}"/></xsl:if>		
	</xsl:template>
</xsl:stylesheet>
