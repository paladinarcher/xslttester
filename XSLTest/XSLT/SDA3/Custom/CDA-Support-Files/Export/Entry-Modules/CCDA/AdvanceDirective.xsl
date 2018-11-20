<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="*" mode="advanceDirectives-Narrative">		
		<xsl:param name="validAdvanceDirectives"/>
		<!-- ADVANCED DIRECTIVES NARRATIVE BLOCK -->
		<text>
			<paragraph>
				This section includes a list of a patient's completed, amended, or rescinded VA Advance Directives,
				but an actual copy is not included.
			</paragraph>
    		<table ID="advancedirectivesnarrative">
    		<!--
         	</table>
			<table border="1" width="100%">
			-->
				<thead>
					<tr>
						<th>Date</th>
						<th>Advanced Directives</th>
						<th>Provider</th>
						<th>Source</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="AdvanceDirective[contains(concat('|',$validAdvanceDirectives),concat('|',AlertType/Code/text(),'|'))]" mode="advanceDirectives-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="advanceDirectives-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), position())}">
			<td><xsl:apply-templates select="FromTime" mode="formatDateTime"/></td>
			<td ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), position())}"><xsl:apply-templates select="Alert" mode="descriptionOrCode"/></td>
			<td ID="{concat('advDirProvider-', position())}"><xsl:value-of select="EnteredBy/Description/text()"/></td>
			<td ID="{concat('advDirSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
	
	
	</xsl:template>

	
	<xsl:template match="*" mode="advanceDirectives-Entries">
		<xsl:param name="validAdvanceDirectives"/>
		
		<xsl:apply-templates select="AdvanceDirective[contains(concat('|',$validAdvanceDirectives),concat('|',AlertType/Code/text(),'|'))]" mode="advanceDirectives-EntryDetail"/>
	</xsl:template>

	
	<xsl:template match="*" mode="advanceDirectives-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-AdvanceDirectiveEntry"/>
				
				<!--
					Field : Advance Directive Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/id
					Source: HS.SDA3.AdvanceDirective ExternalId
					Source: /Container/AdvanceDirectives/AdvanceDirective/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="id-External"/>
				
				<!-- Advance Directive Type -->
				<xsl:apply-templates select="AlertType" mode="code-AdvanceDirectiveType"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-AdvanceDirective"/>				
				<xsl:apply-templates select="." mode="value-AdvanceDirective"/>
				
				<!--
					Field : Advance Directive Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/author
					Source: HS.SDA3.AdvanceDirective EnteredBy
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				
				<!--
					Field : Advance Directive Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/informant
					Source: HS.SDA3.AdvanceDirective EnteredAt
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<xsl:apply-templates select="." mode="participant-AdvanceDirective"/>
				
				<!--
					Field : Advance Directive Free Text Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/entryRelationship/act[code/@code='48767-8']/text
					Source: HS.SDA3.AdvanceDirective Comments
					Source: /Container/AdvanceDirectives/AdvanceDirective/Comments
				-->
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<xsl:apply-templates select="." mode="reference-AdvanceDirective"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="advanceDirectives-NoData">
		<text><xsl:value-of select="$exportConfiguration/advanceDirectives/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="*" mode="code-AdvanceDirectiveType">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:variable name="advanceDirectiveTypeCodes" select="$exportConfiguration/advanceDirectives/advanceDirectiveType/codes/text()"/>
		<xsl:variable name="descUpper" select="translate(Description/text(), $lowerCase, $upperCase)"/>
		<xsl:variable name="codeValue">
			<xsl:choose>
				<xsl:when test="contains($advanceDirectiveTypeCodes, concat('|', Code/text(), '|'))"><xsl:value-of select="Code/text()"/></xsl:when>
				<xsl:when test="$descUpper = 'AD'">71388002</xsl:when>
				<xsl:when test="Code/text() = 'AD'">71388002</xsl:when>
				<xsl:when test="contains($descUpper, 'OTHER DIRECTIVE')">71388002</xsl:when>
				<xsl:when test="contains($descUpper, 'RESUSC')">304251008</xsl:when>
				<xsl:when test="contains($descUpper, 'INTUB')">52765003</xsl:when>
				<xsl:when test="starts-with($descUpper, 'IV ')">225204009</xsl:when>
				<xsl:when test="contains($descUpper, 'INTRAVENOUS')">225204009</xsl:when>
				<xsl:when test="starts-with($descUpper, 'CPR')">89666000</xsl:when>
				<xsl:when test="contains($descUpper, 'ANTIBIOTIC')">281789004</xsl:when>
				<xsl:when test="contains($descUpper, 'LIFE SUPPORT')">78823007</xsl:when>
				<xsl:when test="contains($descUpper, 'TUBE FEED')">61420007</xsl:when>
				<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="descValue">
			<xsl:choose>
				<xsl:when test="string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:when test="$codeValue = '71388002'">Other Directive</xsl:when>
				<xsl:when test="$codeValue = '304251008'">Resuscitation</xsl:when>
				<xsl:when test="$codeValue = '52765003'">Intubation</xsl:when>
				<xsl:when test="$codeValue = '225204009'">IV Fluid and Support</xsl:when>
				<xsl:when test="$codeValue = '89666000'">CPR</xsl:when>
				<xsl:when test="$codeValue = '281789004'">Antibiotics</xsl:when>
				<xsl:when test="$codeValue = '78823007'">Life Support</xsl:when>
				<xsl:when test="$codeValue = '61420007'">Tube Feedings</xsl:when>
				<xsl:otherwise><xsl:value-of select="$codeValue"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="advanceDirectiveInformation">
			<AdvanceDirective xmlns="">
				<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
				<Code><xsl:value-of select="$codeValue"/></Code>
				<Description><xsl:value-of select="$descValue"/></Description>
			</AdvanceDirective>
		</xsl:variable>
		<xsl:variable name="advanceDirective" select="exsl:node-set($advanceDirectiveInformation)/AdvanceDirective"/>
		
		<!--
			Field : Advance Directive Type
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/code
			Source: HS.SDA3.AdvanceDirective AlertType
			Source: /Container/AdvanceDirectives/AdvanceDirective/AlertType
			StructuredMappingRef: generic-Coded
			Note  : The required value set for Advance Directive Type Code is 2.16.840.1.113883.1.11.20.2
					(PHVS_AdvanceDirectiveType_HL7_CCD).  All codes are from SNOMED CT.
					304251008  Resuscitation
					52765003   Intubation
					225204009  IV Fluid and Support
					89666000   CPR
					281789004  Antibiotics
					78823007   Life Support
					61420007   Tube Feedings
					71388002   Other Directive
					
					The code list is defined and configurable in ExportProfile.xml.
		-->
		<xsl:apply-templates select="$advanceDirective" mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), $narrativeLinkSuffix)"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!--
		Value:  explicit yes/no for advance directive; for example, NO I do not allow CPR.
		Following IHE guidelines, if AlertType/Code is 71388002 (Other Directive), omit <value> element
	-->
	<xsl:template match="*" mode="value-AdvanceDirective">
		<!--
			Field : Advance Directive True/False
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/value/@value
			Source: HS.SDA3.AdvanceDirective Alert.Code
			Source: /Container/AdvanceDirectives/AdvanceDirective/Alert/Code
			Note  : If SDA AlertType/Code indicates AdvanceDirective, then no value is exported.
					If SDA Alert/Code indicates "No", then Boolean false value is exported.
					Otherwise, Boolean true value is exported.
		-->
		<xsl:choose>
			<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))"/>
			<xsl:when test="contains('|N|NO|', concat('|', translate(Alert/Code/text(), $lowerCase, $upperCase), '|'))"><value xsi:type="BL" value="false"/></xsl:when>
			<xsl:otherwise><value xsi:type="BL" value="true"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Custodian:  name, address, or other contact information for the person or organization that can provide a copy of the document -->
	<xsl:template match="*" mode="participant-AdvanceDirective">
		<participant typeCode="CST">
			<xsl:apply-templates select="." mode="templateIds-AdvanceDirectiveParticipant"/>
			<participantRole classCode="AGNT">
				<playingEntity>
					<name nullFlavor="UNK"/>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-AdvanceDirective">
	
		<!--
			Field : Advance Directive Effective Date - Start
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/effectiveTime/low/@value
			Source: HS.SDA3.AdvanceDirective FromTime
			Source: /Container/AdvanceDirectives/AdvanceDirective/FromTime
			Note  : CDA effectiveTime for Advance Directive uses only a single time value, SDA FromTime or ToTime, whichever is found first.
		-->
		<!--
			Field : Advance Directive Effective Date - End
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/effectiveTime/high/@value
			Source: HS.SDA3.AdvanceDirective ToTime
			Source: /Container/AdvanceDirectives/AdvanceDirective/ToTime
			Note  : CDA effectiveTime for Advance Directive uses only a single time value, SDA FromTime or ToTime, whichever is found first.
		-->
		<effectiveTime>
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
	
	<xsl:template match="*" mode="reference-AdvanceDirective">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<!-- For now we only support AD code and description, and point to the narrative for text. -->
		<reference typeCode="REFR">
			<seperatableInd value="false"/>
			<externalDocument>
				<id root="{isc:evaluate('createUUID')}"/>
				<text mediaType="text/html">
					<reference value="{concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), $narrativeLinkSuffix)}"/>
				</text>
			</externalDocument>
		</reference>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-AdvanceDirectiveEntry">
		<templateId root="{$ccda-AdvanceDirectiveObservation}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-AdvanceDirectiveParticipant">
		<templateId root="{$ccda-AdvanceDirectiveParticipant}"/>
	</xsl:template>
</xsl:stylesheet>
