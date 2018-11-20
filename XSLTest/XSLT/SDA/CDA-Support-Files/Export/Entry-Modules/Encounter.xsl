<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="encounters-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Start Date/Time</th>
						<th>End Date/Time</th>
						<th>Encounter Type</th>
						<th>Admission Type</th>
						<th>Attending Clinicians</th>
						<th>Care Facility</th>
						<th>Care Department</th>
						<th>Encounter ID</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|')))]" mode="encounters-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="." mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/encounters/narrativeLinkPrefixes/encounterNarrative/text(), $narrativeLinkSuffix)}">
			<td><xsl:value-of select="translate(translate(StartTime/text(), 'T', ' '), 'Z', '')"/></td>
			<td><xsl:value-of select="translate(translate(EndTime/text(), 'T', ' '), 'Z', '')"/></td>
			<td ID="{concat($exportConfiguration/encounters/narrativeLinkPrefixes/encounterDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="EncounterType" mode="encounter-typeDescription"/></td>
			<td ID="{concat($exportConfiguration/encounters/narrativeLinkPrefixes/encounterAdmission/text(), $narrativeLinkSuffix)}"><xsl:value-of select="AdmissionType/Description/text()"/></td>
			<td><xsl:for-each select="AttendingClinicians/CareProvider"><br/><xsl:value-of select="/Description/text()"/></xsl:for-each></td>
			<td><xsl:value-of select="HealthCareFacility/Organization/Description/text()"/></td>
			<td><xsl:value-of select="HealthCareFacility/Description/text()"/></td>
			<td><xsl:value-of select="VisitNumber/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-Entries">
		<xsl:apply-templates select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|')))]" mode="encounters-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="encounters-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="." mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry>
			<encounter classCode="ENC" moodCode="EVN">
				<xsl:call-template name="templateIDs-encounterEntry"/>

				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="." mode="id-Encounter"/>
				<xsl:apply-templates select="." mode="encounter-type"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"></xsl:with-param></xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/encounters/narrativeLinkPrefixes/encounterNarrative/text(), $narrativeLinkSuffix)}"/></text>
				
				<xsl:apply-templates select="." mode="effectiveTime-StartEnd"/>
				<xsl:apply-templates select="." mode="admission-type"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"></xsl:with-param></xsl:apply-templates>
				<xsl:apply-templates select="AttendingClinicians/CareProvider" mode="performer"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<!-- Admission Source (to be done later as participant[@typeCode='ORG']/code) -->
			</encounter>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="encounters-NoData">
		<text><xsl:value-of select="$exportConfiguration/encounters/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="encounter-type">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:variable name="cpt4OID">2.16.840.1.113883.6.12</xsl:variable>
		<xsl:variable name="cpt4Name" select="isc:evaluate('getCodeForOID', $cpt4OID, 'CodeSystem')"/>

			<xsl:variable name="encounterTypeInformation">
				<EncounterType xmlns="">
					<SDACodingStandard><xsl:value-of select="$cpt4Name"/></SDACodingStandard>
					<Code>
						<xsl:choose>
							<xsl:when test="EncounterType/text() = 'E'">EMER</xsl:when>
							<xsl:when test="EncounterType/text() = 'I'">IMP</xsl:when>
							<xsl:when test="EncounterType/text() = 'O'">AMB</xsl:when>
							<xsl:otherwise>AMB</xsl:otherwise>
						</xsl:choose>
					</Code>
					<Description>
						<xsl:choose>
							<xsl:when test="EncounterType/text() = 'E'">Emergency</xsl:when>
							<xsl:when test="EncounterType/text() = 'I'">Inpatient Encounter</xsl:when>
							<xsl:when test="EncounterType/text() = 'O'">Ambulatory</xsl:when>
							<xsl:otherwise>Ambulatory</xsl:otherwise>
						</xsl:choose>
					</Description>
				</EncounterType>
			</xsl:variable>
			
			<xsl:variable name="encounterType" select="exsl:node-set($encounterTypeInformation)/EncounterType"/>
			
			<xsl:apply-templates select="$encounterType" mode="code"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/encounters/narrativeLinkPrefixes/encounterDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
	</xsl:template>

	<xsl:template match="*" mode="encounter-typeDescription">
		<xsl:choose>
			<xsl:when test="text() = 'E'">Emergency</xsl:when>
			<xsl:when test="text() = 'G'">Generated</xsl:when>
			<xsl:when test="text() = 'I'">Inpatient</xsl:when>
			<xsl:when test="text() = 'N'">Neo-natal</xsl:when>
			<xsl:when test="text() = 'O'">Outpatient</xsl:when>
			<xsl:when test="text() = 'S'">Silent</xsl:when>
			<xsl:otherwise>Unknown</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="admission-type">
		<xsl:param name="narrativeLinkSuffix"/>
			<xsl:apply-templates select="AdmissionType" mode="generic-Coded">
				<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/encounters/narrativeLinkPrefixes/encounterAdmission/text(), $narrativeLinkSuffix)"/>
				<!-- 2.16.840.1.113883.6.21 is nubc-UB92 -->
				<xsl:with-param name="requiredCodeSystemOID" select="'2.16.840.1.113883.6.21'"/>
				<xsl:with-param name="cdaElementName" select="'priorityCode'"/>
			</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="templateIDs-encounterEntry">
		<xsl:if test="string-length($hitsp-CDA-Encounters)"><templateId root="{$hitsp-CDA-Encounters}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-EncounterActivity)"><templateId root="{$hl7-CCD-EncounterActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-Encounters)"><templateId root="{$ihe-PCC_CDASupplement-Encounters}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
