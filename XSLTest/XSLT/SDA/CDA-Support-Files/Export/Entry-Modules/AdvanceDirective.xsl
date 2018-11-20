<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:variable name="advanceDirectiveTypeCodes" select="$exportConfiguration/advanceDirectives/advanceDirectiveType/codes/text()"/>

	<xsl:template match="*" mode="advanceDirectives-Narrative">		
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Directive</th>
						<th>Decision</th>
						<th>Effective Date</th>
						<th>Termination Date</th>
						<th>Status</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Alert[contains($advanceDirectiveTypeCodes, concat('|', AlertType/Code/text(), '|'))]" mode="advanceDirectives-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
		
	<xsl:template match="*" mode="advanceDirectives-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), position())}">
			<td ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), position())}">
				<xsl:choose>
					<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))"><xsl:value-of select="Alert/Description/text()"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="AlertType/Description/text()"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))">N/A</xsl:when>
					<xsl:otherwise><xsl:value-of select="Alert/Description/text()"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:value-of select="FromTime/text()"/></td>
			<td><xsl:value-of select="ToTime/text()"/></td>
			<td>
				<xsl:variable name="statusCode"><xsl:value-of select="Status/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$statusCode = 'A'">Active</xsl:when>
					<xsl:when test="$statusCode = 'C'">To Be Confirmed</xsl:when>
					<xsl:when test="$statusCode = 'I'">Inactive</xsl:when>
					<xsl:otherwise>Unknown</xsl:otherwise>
				</xsl:choose>
			</td>
			<td ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveComments/text(), position())}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>
	
	<!-- * match isn't matching so changing to explicit tag name -->
	<xsl:template match="Alerts" mode="advanceDirectives-Entries">
		<xsl:apply-templates select="Alert[contains($advanceDirectiveTypeCodes, concat('|', AlertType/Code/text(), '|'))]" mode="advanceDirectives-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="advanceDirectives-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-AdvanceDirectiveEntry"/>
				
				<xsl:apply-templates select="." mode="id-External"/>
				
				<!-- Advance Directive Type -->
				<xsl:apply-templates select="AlertType" mode="code-AdvanceDirectiveType"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-AdvanceDirective"/>
				<xsl:apply-templates select="." mode="value-AdvanceDirective"/>
				<xsl:apply-templates select="Clinician" mode="performer"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="." mode="participant-AdvanceDirective"/>
				<xsl:apply-templates select="." mode="observation-AdvanceDirectiveStatus"/>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="advanceDirectives-NoData">
		<text><xsl:value-of select="$exportConfiguration/advanceDirectives/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="code-AdvanceDirectiveType">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:variable name="advanceDirectiveInformation">
			<AdvanceDirective xmlns="">
				<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
				<Code>
					<xsl:choose>
						<xsl:when test="contains('|71388002|AD|', concat('|', Code/text(), '|'))">71388002</xsl:when>
						<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description>
					<xsl:choose>
						<xsl:when test="contains('|71388002|AD|', concat('|', Code/text(), '|'))">Other Directive</xsl:when>
						<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
					</xsl:choose>
				</Description>
			</AdvanceDirective>
		</xsl:variable>
		<xsl:variable name="advanceDirective" select="exsl:node-set($advanceDirectiveInformation)/AdvanceDirective"/>
		
		<xsl:apply-templates select="$advanceDirective" mode="code"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
	</xsl:template>
	
	<!--
		Value:  explicit yes/no for advance directive; for example, NO I do not allow CPR.
		Following IHE guidelines, if AlertType/Code is 71388002 (Other Directive), omit <value> element
	-->
	<xsl:template match="*" mode="value-AdvanceDirective">
		<xsl:choose>
			<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))"/>
			<xsl:when test="contains('|N|NO|', concat('|', isc:evaluate('toUpper', Alert/Code/text()), '|'))"><value xsi:type="BL" value="false"/></xsl:when>
			<xsl:otherwise><value xsi:type="BL" value="true"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Custodian:  name, address, or other contact information for the person or organization that can provide a copy of the document -->
	<xsl:template match="*" mode="participant-AdvanceDirective">
		<participant typeCode="CST">
			<participantRole classCode="AGNT">
				<playingEntity>
					<name nullFlavor="UNK"/>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>

	<xsl:template match="*" mode="observation-AdvanceDirectiveStatus">
		<entryRelationship typeCode="REFR">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-AdvanceDirectiveStatus"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:choose>
					<xsl:when test="Status/text() = 'A'">
						<!-- Status Detail -->
						<xsl:variable name="statusInformation">
							<Status xmlns="">
								<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
								<Code>425392003</Code>
								<Description>Current and Verified</Description>
							</Status>
						</xsl:variable>
						<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
						
						<xsl:apply-templates select="$status" mode="value-CE"/>
					</xsl:when>
					<xsl:otherwise>
						<value xsi:type="CD" nullFlavor="OTH" codeSystem="{$snomedOID}">
							<originalText>Not Verified</originalText>
						</value>
					</xsl:otherwise>
				</xsl:choose>
			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="effectiveTime-AdvanceDirective">
	<!-- For IHE PCC Simple Observation (1.3.6.1.4.1.19376.1.5.3.1.4.13)
		 the EnteredOn must be recorded at the top of effectiveTime.
	-->
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(EnteredOn/text())">
					<xsl:attribute name="value"><xsl:apply-templates select="EnteredOn" mode="xmlToHL7TimeStamp"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(FromTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(ToTime/text())">
					<high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
				<xsl:when test="not(string-length(ToTime/text()))">
					<high nullFlavor="UNK"/>
				</xsl:when>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<xsl:template name="templateIds-AdvanceDirectiveEntry">
		<xsl:if test="string-length($hitsp-CDA-AdvanceDirective)"><templateId root="{$hitsp-CDA-AdvanceDirective}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-AdvanceDirectiveObservation)"><templateId root="{$hl7-CCD-AdvanceDirectiveObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-AdvanceDirectiveObservation)"><templateId root="{$ihe-PCC_CDASupplement-AdvanceDirectiveObservation}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-AdvanceDirectiveStatus">
		<xsl:if test="string-length($hl7-CCD-AdvanceDirectiveStatusObservation)"><templateId root="{$hl7-CCD-AdvanceDirectiveStatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
