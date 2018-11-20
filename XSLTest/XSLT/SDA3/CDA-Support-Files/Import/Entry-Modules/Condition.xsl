<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="Condition">
		<Problem>
			<!--
				Field : Problem Encounter
				Target: HS.SDA3.Problem EncounterNumber
				Target: /Container/Problems/Problem/EncounterNumber
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/encounter/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/encounter/id
				Note  : If the CDA encounter link @extension is present then
						it is imported to SDA EncounterNumber.  Otherwise if
						the encounter link @root is present then it is used.
						If there is no encounter link on the CDA Problem and
						there is an encompassingEncounter in the CDA document
						header then the id from the encompassingEncounter is
						imported to SDA EncounterNumber.
			-->
			<EncounterNumber><xsl:apply-templates select="." mode="EncounterID-Entry"/></EncounterNumber>

			<!--
				Field : Problem Author
				Target: HS.SDA3.Problem EnteredBy
				Target: /Container/Problems/Problem/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/author
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!--
				Field : Problem Information Source
				Target: HS.SDA3.Problem EnteredAt
				Target: /Container/Problems/Problem/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/informant
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!--
				Field : Problem Author Time
				Target: HS.SDA3.Problem EnteredOn
				Target: /Container/Problems/Problem/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/author/time/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/author/time/@value
			-->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!--
				Field : Problem Concern Act Id
				Target: HS.SDA3.Problem ExternalId
				Target: /Container/Problems/Problem/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/id
				StructuredMappingRef: ExternalId
			-->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!--
				Field : Problem Start Date/Time
				Target: HS.SDA3.Problem FromTime
				Target: /Container/Problems/Problem/FromTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/effectiveTime/low/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/effectiveTime/low/@value
			-->
			<!--
				Field : Problem End Date/Time
				Target: HS.SDA3.Problem ToTime
				Target: /Container/Problems/Problem/ToTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/effectiveTime/high/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/effectiveTime/high/@value
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:high" mode="ToTime"/>

			<!-- Problem Details -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:text" mode="ProblemDetails"/>
			
			<!--
				Field : Problem Code
				Target: HS.SDA3.Problem Problem
				Target: /Container/Problems/Problem/Problem
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Problem'"/>
			</xsl:apply-templates>

			<!--
				Field : Problem Type
				Target: HS.SDA3.Problem Category
				Target: /Container/Problems/Problem/Category
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/code
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/code
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Category'"/>
			</xsl:apply-templates>

			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<xsl:apply-templates select="hl7:performer | hl7:entryRelationship/hl7:observation/hl7:performer" mode="Clinician"/>
			
			<!--
				Field : Problem Status
				Target: HS.SDA3.Problem Status
				Target: /Container/Problems/Problem/Status
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>

			<!--
				Field : Problem Comments
				Target: HS.SDA3.Problem Comments
				Target: /Container/Problems/Problem/Comments
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/act[code/@code='48767-8']/text
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/act[code/@code='48767-8']/text
			-->
			<xsl:apply-templates select="." mode="Comment"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="ImportCustom-Problem"/>
		</Problem>
	</xsl:template>

	<xsl:template match="*" mode="Diagnosis">
		<xsl:param name="diagnosisType"/>

		<Diagnosis>
			<!--
				Field : Diagnosis Encounter
				Target: HS.SDA3.Diagnosis EncounterNumber
				Target: /Container/Diagnoses/Diagnosis/EncounterNumber
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/entryRelationship/encounter
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/entryRelationship/encounter
				Note  : If there is no encounter link on the CDA Diagnosis and
						there is an encompassingEncounter in the CDA document
						header then the id from the encompassingEncounter is
						imported to SDA EncounterNumber.
			-->
			<EncounterNumber><xsl:apply-templates select="." mode="EncounterID-Entry"/></EncounterNumber>

			<!--
				Field : Diagnosis Author
				Target: HS.SDA3.Diagnosis EnteredBy
				Target: /Container/Diagnoses/Diagnosis/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/author
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!--
				Field : Diagnosis Information Source
				Target: HS.SDA3.Diagnosis EnteredAt
				Target: /Container/Diagnoses/Diagnosis/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/informant
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!--
				Field : Diagnosis Author Time
				Target: HS.SDA3.Diagnosis EnteredOn
				Target: /Container/Diagnoses/Diagnosis/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/author/time/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/author/time/@value
			-->
			<!-- HS.SDA3.Diagnosis EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!--
				Field : Diagnosis Id
				Target: HS.SDA3.Diagnosis ExternalId
				Target: /Container/Diagnoses/Diagnosis/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/id
				StructuredMappingRef: ExternalId
			-->
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!--
				Field : Diagnosis Code
				Target: HS.SDA3.Diagnosis Diagnosis
				Target: /Container/Diagnoses/Diagnosis/Diagnosis
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/entryRelationship/observation/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/entryRelationship/observation/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Diagnosis'"/>
				<xsl:with-param name="importOriginalText" select="'1'"/>
			</xsl:apply-templates>

			<!--
				DiagnosisType is not imported from a specific CDA field.  It is
				determined by the CDA section that is currently being imported -
				either Hospital Admission Diagnosis (A|Admitting) or Discharge
				Diagnosis (D|Discharge).
			-->
			<xsl:if test="string-length($diagnosisType)">
				<DiagnosisType>
					<Code><xsl:value-of select="substring-before($diagnosisType, '|')"/></Code>
					<Description><xsl:value-of select="substring-after($diagnosisType, '|')"/></Description>
				</DiagnosisType>
			</xsl:if>
			
			<!--
				Field : Diagnosis Treating Provider
				Target: HS.SDA3.Diagnosis Clinician
				Target: /Container/Diagnoses/Diagnosis/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Diagnosis entry will have either one or the other.
			-->
			<!--
				Field : Diagnosis Treating Provider
				Target: HS.SDA3.Diagnosis Clinician
				Target: /Container/Diagnoses/Diagnosis/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/entryRelationship/observation/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/entryRelationship/observation/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Diagnosis entry will have either one or the other.
			-->
			<xsl:apply-templates select="hl7:performer | hl7:entryRelationship/hl7:observation/hl7:performer" mode="DiagnosingClinician"/>

			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime" mode="IdentificationTime"/>
			
			<!--
				Field : Diagnosis Status
				Target: HS.SDA3.Diagnosis Status
				Target: /Container/Diagnoses/Diagnosis/Status
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="ImportCustom-Diagnosis"/>
		</Diagnosis>
	</xsl:template>

	<xsl:template match="*" mode="IdentificationTime">
		<!--
			Field : Diagnosis Identification Date/Time
			Target: HS.SDA3.Diagnosis IdentificationTime
			Target: /Container/Diagnoses/Diagnosis/IdentificationTime
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.3']/entry/act/entryRelationship/observation/effectiveTime/@value
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.7']/entry/act/entryRelationship/observation/effectiveTime/@value
			Note  : If CDA effectiveTime/@value is not present
					then SDA IdentificationTime is imported from
					effectiveTime/low/@value instead.
		-->
		<xsl:choose>
			<xsl:when test="@value"><IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></IdentificationTime></xsl:when>
			<xsl:when test="hl7:low/@value"><IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:low/@value)"/></IdentificationTime></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="ProblemDetails">
		<!--
			Field : Problem Name
			Target: HS.SDA3.Problem ProblemDetails
			Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/ProblemDetails
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6']/entry/act/entryRelationship/observation/text
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8']/entry/act/entryRelationship/observation/text
		-->
		<ProblemDetails><xsl:apply-templates select="." mode="TextValue"/></ProblemDetails>
	</xsl:template>
		
	<!--
		This empty template may be overridden with custom logic.
		The input node spec is $sectionRootPath/hl7:entry/hl7:act.
	-->
	<xsl:template match="*" mode="ImportCustom-Problem">
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.
		The input node spec is $sectionRootPath/hl7:entry/hl7:act.
	-->
	<xsl:template match="*" mode="ImportCustom-Diagnosis">
	</xsl:template>
</xsl:stylesheet>
