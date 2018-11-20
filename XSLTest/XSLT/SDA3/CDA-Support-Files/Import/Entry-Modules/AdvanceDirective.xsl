<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="AdvanceDirective">
		<xsl:variable name="isOtherDirective"><xsl:value-of select="contains('|71388002|AD||', concat('|', hl7:code/@code, '|')) or hl7:code/@nullFlavor"/></xsl:variable>
		
		<AdvanceDirective>
			<!--
				Field : Advance Directive Author
				Target: HS.SDA3.AdvanceDirective EnteredBy
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!--
				Field : Advance Directive Information Source
				Target: HS.SDA3.AdvanceDirective EnteredAt
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!--
				Field : Advance Directive Author Time
				Target: HS.SDA3.AdvanceDirective EnteredOn
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/author/time/@value
			-->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>

			<!--
				Field : Advance Directive Id
				Target: HS.SDA3.AdvanceDirective ExternalId
				Target: /Container/AdvanceDirectives/AdvanceDirective/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/id
				StructuredMappingRef: ExternalId
			-->
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>

			<!--
				Field : Advance Directive Effective Date - Start
				Target: HS.SDA3.AdvanceDirective FromTime
				Target: /Container/AdvanceDirectives/AdvanceDirective/FromTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/effectiveTime/low/@value
				Note  : CDA effectiveTime for Advance Directive has only a single
						time value - low or high.  If low is found then SDA FromTime
						is imported.  Otherwise if high is found then SDA ToTime is
						imported.
			-->
			<!--
				Field : Advance Directive Effective Date - End
				Target: HS.SDA3.AdvanceDirective ToTime
				Target: /Container/AdvanceDirectives/AdvanceDirective/ToTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/effectiveTime/high/@value
				Note  : CDA effectiveTime for Advance Directive has only a single
						time value - low or high.  If low is found then SDA FromTime
						is imported.  Otherwise if high is found then SDA ToTime is
						imported.
			-->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="ToTime"/>
			
			<!-- Alert Type -->
			<xsl:apply-templates select="." mode="AlertType"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert -->
			<xsl:apply-templates select="." mode="Alert"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert Status -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="AlertStatus"/>
			
			<!--
				Field : Advance Directive Free Text Type
				Target: HS.SDA3.AdvanceDirective Comments
				Target: /Container/AdvanceDirectives/AdvanceDirective/Comments
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/entryRelationship/act[code/@code='48767-8']/text
			-->
			<xsl:apply-templates select="." mode="Comment"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="ImportCustom-AdvanceDirective"/>
		</AdvanceDirective>
	</xsl:template>
	
	<xsl:template match="*" mode="Alert">
		<xsl:param name="isOtherDirective"/>
		
		<!--
			Field : Advance Directive True/False Code
			Target: HS.SDA3.AdvanceDirective Alert.Code
			Target: /Container/AdvanceDirectives/AdvanceDirective/Alert/Code
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/value/@value
		-->
		<!--
			Field : Advance Directive True/False Description
			Target: HS.SDA3.AdvanceDirective Alert.Description
			Target: /Container/AdvanceDirectives/AdvanceDirective/Alert/Description
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/value/@value
		-->
		
		<xsl:variable name="otherDirectiveText"><xsl:if test="$isOtherDirective = 'true'"><xsl:apply-templates select="hl7:code/hl7:originalText" mode="TextValue"/></xsl:if></xsl:variable>
		<Alert>
			<Code>
				<xsl:choose>
					<xsl:when test="string-length(translate($otherDirectiveText,'&#10;',''))"><xsl:value-of select="translate($otherDirectiveText,'&#10;','')"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Y</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</Code>
			<Description>
				<xsl:choose>
					<xsl:when test="string-length(translate($otherDirectiveText,'&#10;',''))"><xsl:value-of select="translate($otherDirectiveText,'&#10;','')"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Yes</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Yes</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</Description>
		</Alert>		
	</xsl:template>

	<xsl:template match="*" mode="AlertType">
		<xsl:param name="isOtherDirective"/>
		
		<!--
			Field : Advance Directive Type
			Target: HS.SDA3.AdvanceDirective AlertType
			Target: /Container/AdvanceDirectives/AdvanceDirective/AlertType
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/code
			StructuredMappingRef: CodeTableDetail
		-->
		
		<xsl:choose>
			<xsl:when test="$isOtherDirective = 'true'">
				<AlertType>
					<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
					<Code>71388002</Code>
					<Description>Other Directive</Description>
				</AlertType>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:code" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'AlertType'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="*" mode="AlertStatus">
		<!--
			Field : Advance Directive Status
			Target: HS.SDA3.AdvanceDirective Status
			Target: /Container/AdvanceDirectives/AdvanceDirective/Status
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.35']/entry/observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value/@code
		-->
		<Status>
			<xsl:choose>
				<xsl:when test="contains('|425392003|310305009|425396000|425397009|425393008|425395001|425394002|', concat('|', @code, '|'))">A</xsl:when>
				<xsl:otherwise>I</xsl:otherwise>
			</xsl:choose>
		</Status>
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.	
		The input node spec is $sectionRootPath/hl7:entry/hl7:observation.
	-->
	<xsl:template match="*" mode="ImportCustom-AdvanceDirective">
	</xsl:template>
</xsl:stylesheet>
