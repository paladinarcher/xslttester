<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
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
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="/Container">
		<xsl:apply-templates select="/Container/Patients"/>
		<xsl:apply-templates select="/Container/SessionId"/>
		<xsl:apply-templates select="/Container/ControlId"/>
		<xsl:apply-templates select="/Container/Action"/>
		<xsl:apply-templates select="/Container/EventDescription"/>
		<xsl:apply-templates select="/Container/SendingFacility"/>
	</xsl:template>
	
	<xsl:template match="/Container/Patients">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
			<!-- Begin CDA Header -->
			<realmCode code="US"/>
			<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/><!-- CDA R2 typeID -->

			<xsl:call-template name="templateIds-C48.2Header"/>
			<xsl:apply-templates select="Patient" mode="id-Document"/>

			<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="SUMMARIZATION OF EPISODE NOTE"/>
			<title>Discharge Summary Document</title>
			<effectiveTime value="{$currentDateTime}"/>
			<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>
			<languageCode code="en-US"/>

			<!-- Person Information module -->
			<xsl:apply-templates select="Patient" mode="personInformation"/>
			
			<!-- Information Source module -->
			<xsl:apply-templates select="Patient" mode="informationSource"/>
			
			<!-- Support module	-->
			<xsl:apply-templates select="Patient" mode="nextOfKin"/>
			
			<!-- Healthcare Providers module -->
			<xsl:apply-templates select="Patient" mode="healthcareProviders"/>
			
			<!-- End CDA Header -->
			<!-- Begin CCD Body -->
			<component>
				<structuredBody>
					<!-- Advance Directives module -->
					<xsl:apply-templates select="Patient" mode="advanceDirectives"/>
					
					<!-- History of Present Illness module -->
					<xsl:apply-templates select="Patient" mode="presentIllness"/>
					
					<!-- Problem List module -->
					<xsl:apply-templates select="Patient" mode="problems"/>
					
					<!-- History of Past Illness module -->
					<xsl:apply-templates select="Patient" mode="pastIllness"/>
					
					<!-- Hospital Admission Diagnosis module -->
					<xsl:apply-templates select="Patient" mode="admissionDiagnoses"/>
					
					<!-- Discharge Diagnosis module -->
					<xsl:apply-templates select="Patient" mode="dischargeDiagnoses"/>

					<!-- Allergies -->
					<xsl:apply-templates select="Patient" mode="allergies"/>
					
					<!-- Medications Administered module -->
					<xsl:apply-templates select="Patient" mode="administeredMedications"/>
					
					<!-- Hospital Discharge Medications module -->
					<xsl:apply-templates select="Patient" mode="dischargeMedications"/>
					
					<!-- Vital Signs module -->
					<xsl:apply-templates select="Patient" mode="vitalSigns"/>
					
					<!-- Hospital Course module -->
					<xsl:apply-templates select="Patient" mode="hospitalCourse"/>

					<!-- Plan of Care module -->
					<xsl:apply-templates select="Patient" mode="planOfCare"/>
					
					<!-- Encounters module -->
					<xsl:apply-templates select="Patient" mode="encounters"/>
				</structuredBody>
			</component>
			<!-- End CCD Body -->
		</ClinicalDocument>
	</xsl:template>
	
	<xsl:template match="/Container/SessionId"/>
	<xsl:template match="/Container/ControlId"/>
	<xsl:template match="/Container/Action"/>
	<xsl:template match="/Container/EventDescription"/>
	<xsl:template match="/Container/SendingFacility"/>
	
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
</xsl:stylesheet>
