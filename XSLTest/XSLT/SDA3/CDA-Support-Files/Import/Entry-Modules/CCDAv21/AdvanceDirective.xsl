<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="isc hl7">
	<!-- AlsoInclude: Comment.xsl -->
	
	<xsl:template match="hl7:entry/hl7:observation" mode="eAD-AdvanceDirective">
		<xsl:variable name="isOtherDirective"><xsl:value-of select="contains('|71388002|AD||', concat('|', hl7:code/@code, '|')) or hl7:code/@nullFlavor"/></xsl:variable>
		
		<AdvanceDirective>
			<!--
				Field : Advance Directive Author
				Target: HS.SDA3.AdvanceDirective EnteredBy
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="fn-EnteredBy"/>
			
			<!--
				Field : Advance Directive Information Source
				Target: HS.SDA3.AdvanceDirective EnteredAt
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="fn-EnteredAt"/>
			
			<!--
				Field : Advance Directive Author Time
				Target: HS.SDA3.AdvanceDirective EnteredOn
				Target: /Container/AdvanceDirectives/AdvanceDirective/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/author/time/@value
			-->
			<!-- HS.SDA3.AdvanceDirective EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="fn-EnteredOn"/>

			<!--
				Field : Advance Directive Id
				Target: HS.SDA3.AdvanceDirective ExternalId
				Target: /Container/AdvanceDirectives/AdvanceDirective/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/id
				StructuredMappingRef: ExternalId
			-->
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="fn-ExternalId"/>

			<!--
				Field : Advance Directive Effective Date - Start
				Target: HS.SDA3.AdvanceDirective FromTime
				Target: /Container/AdvanceDirectives/AdvanceDirective/FromTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/effectiveTime/low/@value
				Note  : CDA effectiveTime for Advance Directive has only a single
						time value - low or high.  If low is found then SDA FromTime
						is imported.  Otherwise if high is found then SDA ToTime is
						imported.
			-->
			<!--
				Field : Advance Directive Effective Date - End
				Target: HS.SDA3.AdvanceDirective ToTime
				Target: /Container/AdvanceDirectives/AdvanceDirective/ToTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/effectiveTime/high/@value
				Note  : CDA effectiveTime for Advance Directive has only a single
						time value - low or high.  If low is found then SDA FromTime
						is imported.  Otherwise if high is found then SDA ToTime is
						imported.
			-->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="fn-FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="fn-ToTime"/>
			
			<!-- Alert Type -->
			<xsl:apply-templates select="." mode="eAD-AlertType"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert -->
			<xsl:apply-templates select="." mode="eAD-Alert"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert Status -->
			<xsl:apply-templates select="." mode="eAD-Status"/>
			
			<!--
				Field : Advance Directive Free Text Type
				Target: HS.SDA3.AdvanceDirective Comments
				Target: /Container/AdvanceDirectives/AdvanceDirective/Comments
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/entryRelationship/act[code/@code='48767-8']/text
			-->
			<xsl:apply-templates select="." mode="eCm-Comment"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="eAD-ImportCustom-AdvanceDirective"/>
		</AdvanceDirective>
	</xsl:template>
	
	<xsl:template match="hl7:observation" mode="eAD-Alert">
		<xsl:param name="isOtherDirective"/>
		
		<!--
			Field : Advance Directive True/False Code
			Target: HS.SDA3.AdvanceDirective Alert.Code
			Target: /Container/AdvanceDirectives/AdvanceDirective/Alert/Code
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/value/@value
		-->
		<!--
			Field : Advance Directive True/False Description
			Target: HS.SDA3.AdvanceDirective Alert.Description
			Target: /Container/AdvanceDirectives/AdvanceDirective/Alert/Description
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/value/@value
		-->
		
		<xsl:variable name="otherDirectiveRTF">
			<xsl:if test="$isOtherDirective = 'true'"><xsl:apply-templates select="hl7:code/hl7:originalText" mode="fn-TextValue"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="otherDirectiveText" select="translate($otherDirectiveRTF,'&#10;','')"/>

		<Alert>
			<Code>
				<xsl:choose>
					<xsl:when test="string-length($otherDirectiveText)"><xsl:value-of select="$otherDirectiveText"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Y</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</Code>
			<Description>
				<xsl:choose>
					<xsl:when test="string-length($otherDirectiveText)"><xsl:value-of select="$otherDirectiveText"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Yes</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Yes</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</Description>
		</Alert>		
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eAD-AlertType">
		<xsl:param name="isOtherDirective"/>
		
		<!--
			Field : Advance Directive Type
			Target: HS.SDA3.AdvanceDirective AlertType
			Target: /Container/AdvanceDirectives/AdvanceDirective/AlertType
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/code
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
				<xsl:apply-templates select="hl7:code" mode="fn-CodeTable">
					<xsl:with-param name="hsElementName" select="'AlertType'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="hl7:observation" mode="eAD-Status">
		<!-- The mode formerly known as AlertStatus -->
		<!--
			Field : Advance Directive Status
			Target: HS.SDA3.AdvanceDirective Status
			Target: /Container/AdvanceDirectives/AdvanceDirective/Status
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.21.1']/entry/observation/effectiveTime/high/@value
		-->
		<xsl:variable name="endDate" select="hl7:effectiveTime/hl7:high/@value"/>
		<xsl:variable name="dateDiff">
			<xsl:choose>
				<xsl:when test="string-length($endDate)">
					<xsl:value-of select="isc:evaluate('dateDiff', 'dd', concat(substring($endDate,5,2), '-', substring($endDate,7,2), '-', substring($endDate,1,4)))"/>
				</xsl:when>
				<xsl:otherwise>-999</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--
			There is no Advance Directive Status in C-CDA.  CDA Advance
			Directive effectiveTime/high is compared to the current
			date when determining the Status value to use in SDA.
		-->
		<Status>
			<xsl:choose>
				<xsl:when test="number($dateDiff)>0">I</xsl:when>
				<xsl:otherwise>A</xsl:otherwise>
			</xsl:choose>
		</Status>
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.	
		The input node spec is normally $sectionRootPath/hl7:entry.
	-->
	<xsl:template match="*" mode="eAD-ImportCustom-AdvanceDirective">
	</xsl:template>
	
</xsl:stylesheet>