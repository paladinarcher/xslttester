<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">
	<!-- AlsoInclude: Comment.xsl -->
	
	<xsl:template match="hl7:act" mode="eCn-Condition">
		<Problem>
			<!--
				Field : Problem Encounter
				Target: HS.SDA3.Problem EncounterNumber
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/EncounterNumber
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/encounter/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/encounter/id
				Note  : If the CDA encounter link @extension is present then
						it is imported to SDA EncounterNumber.  Otherwise if
						the encounter link @root is present then it is used.
						If there is no encounter link on the CDA Problem and
						there is an encompassingEncounter in the CDA document
						header then the id from the encompassingEncounter is
						imported to SDA EncounterNumber.
			-->
			<EncounterNumber><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></EncounterNumber>

			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation" mode="eCn-Condition-observation"/>
			
			<!--
				Field : Problem Comments
				Target: HS.SDA3.Problem Comments
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Comments
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/act[code/@code='48767-8']/text
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/act[code/@code='48767-8']/text
			-->
			<xsl:apply-templates select="." mode="eCm-Comment"/>
			
			<!--
				Field : Problem Author
				Target: HS.SDA3.Problem EnteredBy
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/author
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="fn-EnteredBy"/>
			
			<!--
				Field : Problem Information Source
				Target: HS.SDA3.Problem EnteredAt
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/informant
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="fn-EnteredAt"/>
			
			<!--
				Field : Problem Author Time
				Target: HS.SDA3.Problem EnteredOn
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/author/time/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/author/time/@value
			-->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="fn-EnteredOn"/>
			
			<!--
				Field : Problem Concern Act Id
				Target: HS.SDA3.Problem ExternalId
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/id
				StructuredMappingRef: ExternalId
			-->
			<xsl:apply-templates select="." mode="fn-ExternalId"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="eCn-ImportCustom-Problem"/>
		</Problem>
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eCn-Condition-observation">
			<!-- Problem Details -->
			<!--
				Field : Problem ProblemDetails
				Target: HS.SDA3.Problem ProblemDetails
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Problem/ProblemDetails
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/text
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/text
			-->
			<xsl:apply-templates select="hl7:text" mode="eCn-ProblemDetails"/>			

			<!--
				Field : Problem Code
				Target: HS.SDA3.Problem Problem
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Problem
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:value" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Problem'"/>
			</xsl:apply-templates>
			
			<!--
				Field : Problem Status
				Target: HS.SDA3.Problem Status
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Status
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>
			
			<!--
				Field : Problem Type
				Target: HS.SDA3.Problem Category
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Category
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/code
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/code
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:code" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Category'"/>
			</xsl:apply-templates>

			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<xsl:apply-templates select="hl7:performer | ../../hl7:performer" mode="fn-Clinician"/>

			<!--
				Field : Problem Start Date/Time
				Target: HS.SDA3.Problem FromTime
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/FromTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/effectiveTime/low/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/effectiveTime/low/@value
			-->
			<!--
				Field : Problem End Date/Time
				Target: HS.SDA3.Problem ToTime
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/ToTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/effectiveTime/high/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/effectiveTime/high/@value
			-->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="fn-FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="fn-ToTime"/>

	</xsl:template>

	<xsl:template match="hl7:act" mode="eCn-Diagnosis">
		<xsl:param name="diagnosisType"/>
		<xsl:param name="encounterID" select="''"/>

		<Diagnosis>
			<!--
				Field : Diagnosis Encounter
				Target: HS.SDA3.Diagnosis EncounterNumber
				Target: /Container/Diagnoses/Diagnosis/EncounterNumber
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/encounter/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/encounter/id
				Note  : If the CDA encounter link @extension is present then
						it is imported to SDA EncounterNumber.  Otherwise if
						the encounter link @root is present then it is used.
						If there is no encounter link on the CDA Diagnosis and
						there is an encompassingEncounter in the CDA document
						header then the id from the encompassingEncounter is
						imported to SDA EncounterNumber.
			-->
			<EncounterNumber>
				<xsl:choose>
					<xsl:when test="not(string-length($encounterID))"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$encounterID"/></xsl:otherwise>
				</xsl:choose>
			</EncounterNumber>

<!--
				Field : Diagnosis Code
				Target: HS.SDA3.Diagnosis Diagnosis
				Target: /Container/Diagnoses/Diagnosis/Diagnosis
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/observation/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/observation/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:value" mode="fn-CodeTable">
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
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Diagnosis entry will have either one or the other.
			-->
			<!--
				Field : Diagnosis Treating Provider
				Target: HS.SDA3.Diagnosis Clinician
				Target: /Container/Diagnoses/Diagnosis/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/observation/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/observation/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Diagnosis entry will have either one or the other.
			-->
			<xsl:apply-templates select="hl7:performer | hl7:entryRelationship/hl7:observation/hl7:performer" mode="fn-DiagnosingClinician"/>

			<!-- Identification Time -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime" mode="eCn-IdentificationTime"/>
			
			<!--
				Field : Diagnosis Status
				Target: HS.SDA3.Diagnosis Status
				Target: /Container/Diagnoses/Diagnosis/Status
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>

			<!--
				Field : Diagnosis Author
				Target: HS.SDA3.Diagnosis EnteredBy
				Target: /Container/Diagnoses/Diagnosis/EnteredBy
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/author
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/author
				StructuredMappingRef: EnteredByDetail
			-->
			<xsl:apply-templates select="." mode="fn-EnteredBy"/>
			
			<!--
				Field : Diagnosis Information Source
				Target: HS.SDA3.Diagnosis EnteredAt
				Target: /Container/Diagnoses/Diagnosis/EnteredAt
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/informant
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/informant
				StructuredMappingRef: EnteredAt
			-->
			<xsl:apply-templates select="." mode="fn-EnteredAt"/>
			
			<!--
				Field : Diagnosis Author Time
				Target: HS.SDA3.Diagnosis EnteredOn
				Target: /Container/Diagnoses/Diagnosis/EnteredOn
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/author/time/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/author/time/@value
			-->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="fn-EnteredOn"/>
			
			<!--
				Field : Diagnosis Id
				Target: HS.SDA3.Diagnosis ExternalId
				Target: /Container/Diagnoses/Diagnosis/ExternalId
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/id
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/id
				StructuredMappingRef: ExternalId
			-->
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="fn-ExternalId"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="eCn-ImportCustom-Diagnosis"/>
		</Diagnosis>
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eCn-ProblemObservation">
			<!-- Problem Details -->
			<xsl:apply-templates select="hl7:text" mode="eCn-ProblemDetails"/>
			
			<!--
				Field : Problem Code
				Target: HS.SDA3.Problem Problem
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Problem
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:value" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Problem'"/>
			</xsl:apply-templates>
			
			<!--
				Field : Problem Type
				Target: HS.SDA3.Problem Category
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Category
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/code
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/code
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:code" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Category'"/>
			</xsl:apply-templates>
			
			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<!--
				Field : Problem Treating Provider
				Target: HS.SDA3.Problem Clinician
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Clinician
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/performer
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/performer
				StructuredMappingRef: Clinician
				Note  : Import gets SDA Clincian from either entry/act/performer
						or entry/act/entryRelationship/observation/performer.
						A CDA Problem entry will have either one or the other.
			-->
			<xsl:apply-templates select="hl7:performer" mode="fn-Clinician"/>
			
			<!--
				Field : Problem Status
				Target: HS.SDA3.Problem Status
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/Status
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/entryRelationship/observation[code/@code='33999-4']/value
				StructuredMappingRef: CodeTableDetail
			-->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation[hl7:code/@code='33999-4']/hl7:value" mode="fn-CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>

			<!--
				Field : Problem Start Date/Time
				Target: HS.SDA3.Problem FromTime
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/FromTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/effectiveTime/low/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/effectiveTime/low/@value
			-->
			<!--
				Field : Problem End Date/Time
				Target: HS.SDA3.Problem ToTime
				Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/ToTime
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/effectiveTime/high/@value
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/effectiveTime/high/@value
			-->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="fn-FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="fn-ToTime"/>
	</xsl:template>

	<xsl:template match="hl7:effectiveTime" mode="eCn-IdentificationTime">
		<!--
			Field : Diagnosis Identification Date/Time
			Target: HS.SDA3.Diagnosis IdentificationTime
			Target: /Container/Diagnoses/Diagnosis/IdentificationTime
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/observation/effectiveTime/@value
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/observation/effectiveTime/@value
			Note  : If CDA effectiveTime/@value is not present
					then SDA IdentificationTime is imported from
					effectiveTime/low/@value instead.
		-->
		<xsl:choose>
			<xsl:when test="@value">
				<xsl:apply-templates select="@value" mode="fn-E-paramName-timestamp">
					<xsl:with-param name="emitElementName" select="'IdentificationTime'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="hl7:low/@value">
				<xsl:apply-templates select="hl7:low/@value" mode="fn-E-paramName-timestamp">
					<xsl:with-param name="emitElementName" select="'IdentificationTime'"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:text" mode="eCn-ProblemDetails">
		<!--
			Field : Problem Name
			Target: HS.SDA3.Problem ProblemDetails
			Target: /Container/Problems/Problem[not(Category/Code='248536006' or Category/Code='373930000')]/ProblemDetails
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/entry/act/entryRelationship/observation/text
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.20']/entry/act/entryRelationship/observation/text
		-->
		<ProblemDetails><xsl:apply-templates select="." mode="fn-TextValue"/></ProblemDetails>
	</xsl:template>
		
	<!--
		This empty template may be overridden with custom logic.
		The input node spec is normally $sectionRootPath/hl7:entry/hl7:act.
	-->
	<xsl:template match="*" mode="eCn-ImportCustom-Problem">
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.
		The input node spec is normally $sectionRootPath/hl7:entry/hl7:act.
	-->
	<xsl:template match="*" mode="eCn-ImportCustom-Diagnosis">
	</xsl:template>
	
</xsl:stylesheet>