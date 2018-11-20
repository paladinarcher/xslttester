<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
  <!-- AlsoInclude: AuthorParticipation.xsl Comment.xsl -->
	
	<xsl:template match="AdvanceDirectives" mode="eAD-advanceDirectives-Narrative">		
		<xsl:param name="validAdvanceDirectives"/>
		
		<text>
			<paragraph>
				<content ID="advanceDirectiveTime">Section Date Range: From patient's date of birth to the date document was created.</content>
			</paragraph>
			<paragraph>
			<xsl:choose>
			<xsl:when test="$flavor = 'SES'">
				This section includes ALL of a patient's completed or amended VA Advance and Rescinded 
				Directives. The entries below indicate that a directive exists for the patient, but an 
				actual copy is not included with this document. The data comes from all VA facilities.
			</xsl:when>
			<xsl:otherwise>
				This section includes a list of a patient's completed, amended, or rescinded VA Advance 
				Directives, but an actual copy is not included.
			</xsl:otherwise>
			</xsl:choose>
			</paragraph>
			<!--
    		<table ID="advancedirectivesnarrative">
         	</table>
         	-->
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Date</th>
						<th>Advanced Directives</th>
						<th>Provider</th>
						<th>Source</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="AdvanceDirective[contains($validAdvanceDirectives,concat('|',AlertType/Code/text(),'|'))]" mode="eAD-advanceDirectives-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="AdvanceDirective" mode="eAD-advanceDirectives-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveNarrative/text(), position())}">
			<td><xsl:apply-templates select="FromTime" mode="formatDateTime"/></td>
			<td ID="{concat($exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), position())}"><xsl:apply-templates select="Alert" mode="fn-descriptionOrCode"/></td>
			<td ID="{concat('advDirProvider-', position())}"><xsl:value-of select="EnteredBy/Description/text()"/></td>
			<td ID="{concat('advDirSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="AdvanceDirectives" mode="eAD-advanceDirectives-Entries">
		<xsl:param name="validAdvanceDirectives"/>
		
		<xsl:apply-templates select="AdvanceDirective[contains($validAdvanceDirectives,concat('|',AlertType/Code/text(),'|'))]" mode="eAD-advanceDirectives-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="AdvanceDirective" mode="eAD-advanceDirectives-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="eAD-templateIds-AdvanceDirectiveEntry"/>
				
				<!--
					Field : Advance Directive Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/id
					Source: HS.SDA3.AdvanceDirective ExternalId
					Source: /Container/AdvanceDirectives/AdvanceDirective/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="fn-id-External"/>
				
				<!-- Advance Directive Type -->
				<xsl:apply-templates select="AlertType" mode="eAD-code-AdvanceDirectiveType"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				
				<statusCode code="completed"/>
				
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
				<xsl:apply-templates select="." mode="fn-effectiveTime-FromTo">
					<xsl:with-param name="includeHighTime" select="true()"/>
					<xsl:with-param name="paramNullFlavor" select="'NA'"/>
				</xsl:apply-templates>

				<xsl:apply-templates select="." mode="eAD-value-AdvanceDirective"/>
				
				<!--
					Field : Advance Directive Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/author
					Source: HS.SDA3.AdvanceDirective EnteredBy
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="eAP-author-Human"/>
				
				<!--
					Field : Advance Directive Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/informant
					Source: HS.SDA3.AdvanceDirective EnteredAt
					Source: /Container/AdvanceDirectives/AdvanceDirective/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="fn-informant"/>
				
				<xsl:apply-templates select="." mode="eAD-participant-AdvanceDirective"/>
				
				<!--
					Field : Advance Directive Free Text Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/entryRelationship/act[code/@code='48767-8']/text
					Source: HS.SDA3.AdvanceDirective Comments
					Source: /Container/AdvanceDirectives/AdvanceDirective/Comments
				-->
				<xsl:apply-templates select="Comments" mode="eCm-entryRelationship-comments">
					<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveComments/text(), $narrativeLinkSuffix)"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="." mode="eAD-reference-AdvanceDirective"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="eAD-advanceDirectives-NoData">
		<text><xsl:value-of select="$exportConfiguration/advanceDirectives/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="AlertType" mode="eAD-code-AdvanceDirectiveType">
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
		
		<code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SCT">
			<xsl:attribute name="code"><xsl:value-of select="$codeValue"/></xsl:attribute>
			<xsl:attribute name="displayName"><xsl:value-of select="$descValue"/></xsl:attribute>
			<xsl:attribute name="codeSystemName"><xsl:value-of select="$snomedName"/></xsl:attribute>
			<xsl:attribute name="codeSystem"><xsl:value-of select="$snomedOID"/></xsl:attribute>
			<originalText>
				<reference>
					<xsl:attribute name="value">
						<xsl:value-of select="concat('#', $exportConfiguration/advanceDirectives/narrativeLinkPrefixes/advanceDirectiveType/text(), $narrativeLinkSuffix)"/>
					</xsl:attribute>
				</reference>
			</originalText>
			<translation code="75320-2" displayName="Advance Directive" codeSystemName="{$loincName}" codeSystem="{$loincOID}"/>
		</code>
	</xsl:template>
	
	<!--
		Value:  explicit yes/no for advance directive; for example, NO I do not allow CPR.
		Following IHE guidelines, if AlertType/Code is 71388002 (Other Directive), omit <value> element
	-->
	<xsl:template match="AdvanceDirective" mode="eAD-value-AdvanceDirective">
		<!--
			Field : Advance Directive True/False
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/value/@value
			Source: HS.SDA3.AdvanceDirective Alert.Code
			Source: /Container/AdvanceDirectives/AdvanceDirective/Alert/Code
			Note  : If SDA AlertType/Code is Other Directive, then an empty value is exported.
					If SDA Alert/Code indicates "No", then Boolean false value is exported.
					Otherwise, Boolean true value is exported.
		-->
		<xsl:choose>
			<xsl:when test="contains('|71388002|AD|', concat('|', AlertType/Code/text(), '|'))">
				<!--Note the space below is needed as content of <value> to pass validation-->
				<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ST"><xsl:text> </xsl:text></value>
			</xsl:when>
			<xsl:when test="contains('|N|NO|', concat('|', translate(Alert/Code/text(), $lowerCase, $upperCase), '|'))">
				<value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="BL" value="false"/>
			</xsl:when>
			<xsl:otherwise><value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="BL" value="true"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Custodian:  name, address, or other contact information for the person or organization that can provide a copy of the document -->
	<xsl:template match="AdvanceDirective" mode="eAD-participant-AdvanceDirective">
		<participant typeCode="CST">
			<xsl:call-template name="eAD-templateIds-AdvanceDirectiveParticipant"/>
			<participantRole classCode="AGNT">
				<playingEntity>
					<name nullFlavor="UNK"/>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="AdvanceDirective" mode="eAD-reference-AdvanceDirective">
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
	
	<!-- The eAD-effectiveTime-AdvanceDirective mode is no longer used. Use fn-effectiveTime-FromTo instead. -->
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="eAD-templateIds-AdvanceDirectiveEntry">
		<templateId root="{$ccda-AdvanceDirectiveObservation}"/>
		<templateId root="{$ccda-AdvanceDirectiveObservation}" extension="2015-08-01"/>
	</xsl:template>
	
	<xsl:template name="eAD-templateIds-AdvanceDirectiveParticipant">
		<templateId root="{$ccda-AdvanceDirectiveParticipant}"/>
		<templateId root="{$ccda-AdvanceDirectiveParticipant}" extension="2015-08-01"/>
	</xsl:template>
</xsl:stylesheet>
