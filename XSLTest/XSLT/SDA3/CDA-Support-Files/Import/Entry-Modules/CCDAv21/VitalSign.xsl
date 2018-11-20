<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="hl7 xsi">
	<!-- AlsoInclude: Comment.xsl -->
	
	<xsl:template match="hl7:entry" mode="eVS-VitalSign">
			<!--
				Field : Vital Sign Observation
				Target: HS.SDA3.Observation
				Target: /Container/Observations/Observation
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation
				StructuredMappingRef: eVS-Observation-Detail
			-->
		<xsl:apply-templates select="hl7:organizer/hl7:component/hl7:observation" mode="eVS-Observation-Detail">
			<!--
				Field : Vital Sign Encounter
				Target: HS.SDA3.Observation EncounterNumber
				Target: /Container/Observations/Observation/EncounterNumber
				Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/encounter/id
				Note  : If the CDA encounter link @extension is present then
						it is imported to SDA EncounterNumber.  Otherwise if
						the encounter link @root is present then it is used.
						If there is no encounter link on the CDA Vital Sign and
						there is an encompassingEncounter in the CDA document
						header then the id from the encompassingEncounter is
						imported to SDA EncounterNumber.
			-->
			<xsl:with-param name="encounterNum"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eVS-OutcomeObservation-Detail">
		<!-- The mode is specifically for Health Status Evaluation and Outcome section -->
		
		<!--
			StructuredMapping: OutcomeObservation-Detail

			Field
			Target: HS.SDA3.Observation EnteredBy
			Target: ./EnteredBy
			Source: author
			StructuredMappingRef: EnteredByDetail

			Field
			Target: HS.SDA3.Observation ExternalId
			Target: ./ExternalId
			Source: ./id
			StructuredMappingRef: ExternalId

			Field
			Target: HS.SDA3.Observation ObservationTime
			Target: ./ObservationTime
			Source: ./effectiveTime

			Field
			Target: HS.SDA3.Observation ObservationCode
			Target: ./ObservationCode
			Source: ./code
			StructuredMappingRef: CodeTableDetail

			Field
			Target: HS.SDA3.Observation ObservationCode.ObservationValueUnits
			Target: ./ObservationCode/ObservationValueUnits
			Source: ./value/@unit

			Field
			Target: HS.SDA3.Observation ObservationValue
			Target: ./ObservationValue
			Source: ./value/@value
			Note  : If the Result Value Unit is not available then the
					Result Value is imported from CDA value/text() instead
					of value/@value.

		-->
		<Observation>			
			<xsl:apply-templates select="hl7:author" mode="fn-EnteredBy"/>			
			
			<xsl:apply-templates select="hl7:author/hl7:time" mode="fn-EnteredOn"/>
			
			<xsl:apply-templates select="." mode="fn-ExternalId"/>
			
			<xsl:apply-templates select="hl7:performer" mode="fn-Clinician"/>
			
			<xsl:apply-templates select="hl7:effectiveTime" mode="fn-I-timestamp">
				<xsl:with-param name="emitElementName" select="'ObservationTime'"/>
			</xsl:apply-templates>			
			
			<xsl:apply-templates select="." mode="eVS-ObservationCode" />
			
			<xsl:apply-templates select="hl7:value" mode="eVS-ObservationValue"/>			

		</Observation>
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eVS-Observation-Detail">
		<!-- The mode formerly known as VitalSignDetail -->
		<xsl:param name="encounterNum"/>
		
		<!--
			StructuredMapping: eVS-Observation-Detail

			Field
			Target: HS.SDA3.Observation EnteredBy
			Target: ./EnteredBy
			Source: ../../author
			StructuredMappingRef: EnteredByDetail

			Field
			Target: HS.SDA3.Observation EnteredAt
			Target: ./EnteredAt
			Source: ../../informant
			StructuredMappingRef: EnteredAt

			Field
			Target: HS.SDA3.Observation EnteredOn
			Target: ./EnteredOn
			Source: ../../author/time/@value

			Field
			Target: HS.SDA3.Observation ExternalId
			Target: ./ExternalId
			Source: ./id
			StructuredMappingRef: ExternalId

			Field
			Target: HS.SDA3.Observation Clinician
			Target: ./Clinician
			Source: ./performer
			StructuredMappingRef: Clinician

			Field
			Target: HS.SDA3.Observation ObservationTime
			Target: ./ObservationTime
			Source: ./effectiveTime

			Field
			Target: HS.SDA3.Observation ObservationCode
			Target: ./ObservationCode
			Source: ./code
			StructuredMappingRef: CodeTableDetail

			Field
			Target: HS.SDA3.Observation ObservationCode.ObservationValueUnits
			Target: ./ObservationCode/ObservationValueUnits
			Source: ./value/@unit

			Field
			Target: HS.SDA3.Observation ObservationValue
			Target: ./ObservationValue
			Source: ./value/@value
			Note  : If the Result Value Unit is not available then the
					Result Value is imported from CDA value/text() instead
					of value/@value.

			Field
			Target: HS.SDA3.Observation Comments
			Target: ./Comments
			Source: ./entryRelationship/act[code/@code='48767-8']/text

		-->

		<Observation>
			<EncounterNumber><xsl:value-of select="$encounterNum"/></EncounterNumber>
			
			<xsl:apply-templates select="../.." mode="fn-EnteredBy"/>
			
			<xsl:apply-templates select="../.." mode="fn-EnteredAt"/>
			
			<xsl:apply-templates select="../../hl7:author/hl7:time" mode="fn-EnteredOn"/>
			
			<xsl:apply-templates select="." mode="fn-ExternalId"/>
			
			<xsl:apply-templates select="hl7:performer" mode="fn-Clinician"/>
			
			<xsl:apply-templates select="hl7:effectiveTime" mode="fn-I-timestamp">
				<xsl:with-param name="emitElementName" select="'ObservationTime'"/>
			</xsl:apply-templates>			
			
			<xsl:apply-templates select="." mode="eVS-ObservationCode" />
			
			<xsl:apply-templates select="hl7:value" mode="eVS-ObservationValue"/>
			
			<xsl:apply-templates select="." mode="eCm-Comment"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="eVS-ImportCustom-VitalSign"/>
		</Observation>
	</xsl:template>
	
	<xsl:template match="hl7:value" mode="eVS-ObservationValue">
		<ObservationValue>
			<xsl:choose>
				<xsl:when test="@xsi:type = 'PQ'"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
			</xsl:choose>
		</ObservationValue>
	</xsl:template>

	<xsl:template match="hl7:observation" mode="eVS-ObservationCode">
		<xsl:apply-templates select="hl7:code" mode="fn-CodeTable">
			<xsl:with-param name="hsElementName" select="'ObservationCode'"/>
			<xsl:with-param name="observationValueUnits">
				<xsl:if test="hl7:value/@xsi:type = 'PQ' and string-length(hl7:value/@unit)">
					<xsl:value-of select="hl7:value/@unit"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="importOriginalText" select="'1'"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
		This empty template may be overridden with custom logic.
		The input node spec is normally $sectionRootPath/hl7:entry/hl7:observation.
	-->
	<xsl:template match="*" mode="eVS-ImportCustom-VitalSign">
	</xsl:template>
	
</xsl:stylesheet>