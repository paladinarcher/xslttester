<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:variable name="generalImportConfiguration">
		<!--
			SDA Action Codes:
				A = Add or Update
				C = Clear (physical delete) all existing entries in the ECR
				D = Delete (physical delete) existing entries where SDA's ExternalId matches the inbound CDA's setId
				I = Inactivate all existing entries in the ECR
		-->
		<sdaActionCodes>
			<enabled>1</enabled>
			<overrideExternalId>0</overrideExternalId>
		</sdaActionCodes>
	</xsl:variable>

	<xsl:variable name="admissionDiagnosesImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-HospitalAdmissionDiagnosis"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="advanceDirectivesImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-CodedAdvanceDirectives"/></sectionTemplateId>
	</xsl:variable>
	
	<xsl:variable name="allergiesImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-AllergiesAndOtherAdverseReactions"/></sectionTemplateId>
	</xsl:variable>
	
	<xsl:variable name="careConsiderationsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$other-ActiveHealth-CareConsiderationsSection"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="commentsImportConfiguration">
		<entryTemplateId><xsl:value-of select="$ihe-PCC-Comments"/></entryTemplateId>
	</xsl:variable>

	<xsl:variable name="dischargeDiagnosesImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-DischargeDiagnosis"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="dischargeMedicationsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-HospitalDischargeMedications"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="encountersImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-EncounterHistories"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="familyHistoryImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-FamilyMedicalHistory"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="functionalStatusImportConfiguration">
		<sectionTemplateId><xsl:value-of select="'Not Supported'"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="immunizationsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-Immunizations"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="medicalEquipmentImportConfiguration">
		<sectionTemplateId><xsl:value-of select="'Not Supported'"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="medicationInstructionsImportConfiguration">
		<entryTemplateId><xsl:value-of select="$ihe-PCC-PatientMedicationInstructions"/></entryTemplateId>
	</xsl:variable>

	<xsl:variable name="medicationsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-Medications"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="medicationsAdministeredImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-SelectMedsAdministered"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="pastIllnessImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-HistoryOfPastIllness"/></sectionTemplateId>
	</xsl:variable>
	
	<xsl:variable name="payersImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-Payers"/></sectionTemplateId>
		<entryTemplateId><xsl:value-of select="$ihe-PCC_CDASupplement-CoverageEntry"/></entryTemplateId>
	</xsl:variable>

	<xsl:variable name="payerPlanDetailsImportConfiguration">
		<entryTemplateId><xsl:value-of select="$ihe-PCC_CDASupplement-PayerEntry"/></entryTemplateId>
	</xsl:variable>

	<xsl:variable name="planImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-CarePlan"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="presentIllnessImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-HistoryOfPresentIllness"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="problemsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-ActiveProblems"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="proceduresImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-ListOfSurgeries"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="purposeImportConfiguration">
		<sectionTemplateId><xsl:value-of select="'Not Supported'"/></sectionTemplateId>
	</xsl:variable>

 	<!-- resultOrganizerTemplateId is used to help select the correct -->
 	<!-- hl7:organizer within a given results entry, in case there is -->
 	<!-- more than one. One alternate value that might be assigned to -->
 	<!-- this variable is $ihe-PCC-LabBatteryOrganizer.               -->
	<xsl:variable name="resultsImportConfiguration">
		<sectionC32TemplateId><xsl:value-of select="$ihe-PCC-CodedResults"/></sectionC32TemplateId>
		<sectionC37TemplateId><xsl:value-of select="$ihe-PCC-LaboratorySpecialty"/></sectionC37TemplateId>
		<resultOrganizerTemplateId><xsl:value-of select="$hl7-CCD-ResultOrganizer"/></resultOrganizerTemplateId>
		<orderItemDefaultCode></orderItemDefaultCode>
		<orderItemDefaultDescription></orderItemDefaultDescription>
	</xsl:variable>

	<xsl:variable name="socialHistoryImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-SocialHistory"/></sectionTemplateId>
	</xsl:variable>

	<xsl:variable name="vitalSignsImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-CodedVitalSigns"/></sectionTemplateId>
	</xsl:variable>
 
 </xsl:stylesheet>
