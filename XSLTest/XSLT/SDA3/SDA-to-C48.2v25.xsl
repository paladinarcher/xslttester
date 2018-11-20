<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HITSP.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HL7.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-IHE.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-InterSystems.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/Variables.xsl"/>

	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/AdvanceDirective.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/AllergyAndDrugSensitivity.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/Comment.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/Condition.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/Encounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/HealthcareProvider.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/HistoryOfPresentIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/InformationSource.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/LanguageSpoken.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/Medication.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/PersonalInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/PlanOfCare.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/Support.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/VitalSign.xsl"/>

	<xsl:include href="CDA-Support-Files/Export/Section-Modules/AdvanceDirectives.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/AllergiesAndOtherAdverseReactions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/DischargeDiagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounters.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/HistoryOfPastIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/HistoryOfPresentIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/HospitalAdmissionDiagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/HospitalCourse.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/HospitalDischargeMedications.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/MedicationsAdministered.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/PlanOfCare.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/ProblemList.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/VitalSigns.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Site/OutputEncoding.xsl"/>

	<xsl:template match="/Container">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
			<!-- Begin CDA Header -->
			<realmCode code="US"/>
			<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/><!-- CDA R2 typeID -->

			<xsl:call-template name="templateIds-C48.2Header"/>
			<xsl:apply-templates select="Patient" mode="id-Document"/>

			<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="SUMMARIZATION OF EPISODE NOTE"/>
			
			<xsl:apply-templates select="." mode="document-title">
				<xsl:with-param name="title1">Discharge Summary Document</xsl:with-param>
			</xsl:apply-templates>
			
			<effectiveTime value="{$currentDateTime}"/>
			<confidentialityCode nullFlavor="{$confidentialityNullFlavor}"/>
			<languageCode code="en-US"/>

			<!-- Person Information module -->
			<xsl:apply-templates select="Patient" mode="personInformation"/>
			
			<!-- Information Source module -->
			<xsl:apply-templates select="Patient" mode="informationSource"/>
			
			<!-- Support module	-->
			<xsl:apply-templates select="Patient" mode="nextOfKin"/>
			
			<!-- Healthcare Providers module -->
			<xsl:apply-templates select="Patient" mode="healthcareProviders">
				<xsl:with-param name="includeDiagnosisClinicians" select="'1'"/>
			</xsl:apply-templates>
			
			<!-- End CDA Header -->
			<!-- Begin CCD Body -->
			<component>
				<structuredBody>
					<!-- Advance Directives module -->
					<xsl:apply-templates select="." mode="advanceDirectives"/>
					
					<!-- History of Present Illness module -->
					<xsl:apply-templates select="." mode="presentIllness"/>
					
					<!-- Problem List module -->
					<xsl:apply-templates select="." mode="problems">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- History of Past Illness module -->
					<xsl:apply-templates select="." mode="pastIllness">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Hospital Admission Diagnosis module -->
					<xsl:apply-templates select="." mode="admissionDiagnoses">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Discharge Diagnosis module -->
					<xsl:apply-templates select="." mode="dischargeDiagnoses">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>

					<!-- Allergies -->
					<xsl:apply-templates select="." mode="allergies">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Medications Administered module -->
					<xsl:apply-templates select="." mode="administeredMedications"/>
					
					<!-- Hospital Discharge Medications module -->
					<xsl:apply-templates select="." mode="dischargeMedications">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Vital Signs module -->
					<xsl:apply-templates select="." mode="vitalSigns"/>
					
					<!-- Hospital Course module -->
					<xsl:apply-templates select="." mode="hospitalCourse">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>

					<!-- Plan of Care module -->
					<xsl:apply-templates select="." mode="planOfCare">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Encounters module -->
					<xsl:apply-templates select="." mode="encounters"/>
					
					<!-- Custom export -->
					<xsl:apply-templates select="." mode="ExportCustom-ClinicalDocument"/>
				</structuredBody>
			</component>
			<!-- End CCD Body -->
		</ClinicalDocument>
	</xsl:template>
	
	<xsl:template name="templateIds-C48.2Header">
		<xsl:if test="string-length($hl7-CDA-CDAR2GeneralHeader)"><templateId root="{$hl7-CDA-CDAR2GeneralHeader}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-RegisteredTemplatesRoot)"><templateId root="{$hl7-CCD-RegisteredTemplatesRoot}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-GeneralHeader)"><templateId root="{$hl7-CCD-GeneralHeader}"/></xsl:if>
		<xsl:if test="string-length($hl7-CDA-Level1Declaration)"><templateId root="{$hl7-CDA-Level1Declaration}"/></xsl:if>
		<xsl:if test="string-length($hl7-CDA-Level2Declaration)"><templateId root="{$hl7-CDA-Level2Declaration}"/></xsl:if>
		<xsl:if test="string-length($hl7-CDA-Level3Declaration)"><templateId root="{$hl7-CDA-Level3Declaration}"/></xsl:if>
		<xsl:if test="string-length($hitsp-C48-DischargeSummary)"><templateId root="{$hitsp-C48-DischargeSummary}"/></xsl:if>
		<xsl:if test="string-length($ihe-MedicalDocumentsSpecification)"><templateId root="{$ihe-MedicalDocumentsSpecification}"/></xsl:if>
		<xsl:if test="string-length($ihe-MedicalSummarySpecification)"><templateId root="{$ihe-MedicalSummarySpecification}"/></xsl:if>
		<xsl:if test="string-length($ihe-DischargeSummarySpecification)"><templateId root="{$ihe-DischargeSummarySpecification}"/></xsl:if>
	</xsl:template>
	
	<!-- This empty template may be overridden with custom logic. -->
	<xsl:template match="*" mode="ExportCustom-ClinicalDocument">
	</xsl:template>
</xsl:stylesheet>
