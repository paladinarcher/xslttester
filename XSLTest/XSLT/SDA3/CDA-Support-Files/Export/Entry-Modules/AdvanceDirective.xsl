<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="*" mode="advanceDirectives-Narrative">		
		<xsl:param name="validAdvanceDirectives"/>
		
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
					<xsl:apply-templates select="AdvanceDirective[contains(concat('|',$validAdvanceDirectives),concat('|',AlertType/Code/text(),'|'))]" mode="advanceDirectives-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="advanceDirectives-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), position())}">
			<td ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), position())}">
				<xsl:choose>
					<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))"><xsl:apply-templates select="Alert" mode="descriptionOrCode"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="AlertType" mode="descriptionOrCode"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))">N/A</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Alert" mode="descriptionOrCode"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			<td><xsl:apply-templates select="ToTime" mode="narrativeDateFromODBC"/></td>
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
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/id
					Source: HS.SDA3.AdvanceDirective ExternalId
					Source: /Container/AdvanceDirectives/AdvanceDirective/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="id-External"/>
				
				<!-- Advance Directive Type -->
				<xsl:apply-templates select="AlertType" mode="code-AdvanceDirectiveType"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-AdvanceDirective"/>
				
				<!-- Use AlertType and Alert to export a Boolean <value> if applicable. -->
				<xsl:apply-templates select="." mode="value-AdvanceDirective"/>
				
				<!--
					Field : Advance Directive Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/author
					Source: HS.SDA3.AdvanceDirective EnteredBy
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>

				<!--
					Field : Advance Directive Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/informant
					Source: HS.SDA3.AdvanceDirective EnteredAt
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<xsl:apply-templates select="." mode="participant-AdvanceDirective"/>
				<xsl:apply-templates select="." mode="observation-AdvanceDirectiveStatus"/>
				
				<!--
					Field : Advance Directive Free Text Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/entryRelationship/act[code/@code='48767-8']/text
					Source: HS.SDA3.AdvanceDirective Comments
					Source: /Container/AdvanceDirectives/AdvanceDirective/Comments
				-->
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
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
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/code
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
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/value/@value
			Source: HS.SDA3.AdvanceDirective Alert.Code
			Source: /Container/AdvanceDirectives/AdvanceDirective/Alert/Code
			Note  : If SDA AlertType/Code indicates AdvanceDirective then no value is exported.
					If SDA Alert/Code indicates "No" the Boolean false value is exported.
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
			<participantRole classCode="AGNT">
				<playingEntity>
					<name nullFlavor="UNK"/>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>

	<xsl:template match="*" mode="observation-AdvanceDirectiveStatus">
		<!--
			Field : Advance Directive Status
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value/@code
			Source: HS.SDA3.AdvanceDirective Status
			Source: /Container/AdvanceDirectives/AdvanceDirective/Status
		-->
		<entryRelationship typeCode="REFR">
			<observation classCode="OBS" moodCode="EVN">
				
				<xsl:apply-templates select="." mode="templateIds-AdvanceDirectiveStatus"/>
				
				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
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
		<!--
			Field : Advance Directive Effective Date - Start
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/effectiveTime/low/@value
			Source: HS.SDA3.AdvanceDirective FromTime
			Source: /Container/AdvanceDirectives/AdvanceDirective/FromTime
			Note  : CDA effectiveTime for Advance Directive uses only a single time value, SDA FromTime or ToTime, whichever is found first.
		-->
		<!--
			Field : Advance Directive Effective Date - End
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/effectiveTime/high/@value
			Source: HS.SDA3.AdvanceDirective ToTime
			Source: /Container/AdvanceDirectives/AdvanceDirective/ToTime
			Note  : CDA effectiveTime for Advance Directive uses only a single time value, SDA FromTime or ToTime, whichever is found first.
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
	
	<xsl:template match="*" mode="templateIds-AdvanceDirectiveEntry">
		<xsl:if test="$hitsp-CDA-AdvanceDirective"><templateId root="{$hitsp-CDA-AdvanceDirective}"/></xsl:if>
		<xsl:if test="$hl7-CCD-AdvanceDirectiveObservation"><templateId root="{$hl7-CCD-AdvanceDirectiveObservation}"/></xsl:if>
		<xsl:if test="$ihe-PCC-SimpleObservations"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="$ihe-PCC_CDASupplement-AdvanceDirectiveObservation"><templateId root="{$ihe-PCC_CDASupplement-AdvanceDirectiveObservation}"/></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="templateIds-AdvanceDirectiveStatus">
		<xsl:if test="$hl7-CCD-AdvanceDirectiveStatusObservation"><templateId root="{$hl7-CCD-AdvanceDirectiveStatusObservation}"/></xsl:if>
		<xsl:if test="$hl7-CCD-StatusObservation"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
