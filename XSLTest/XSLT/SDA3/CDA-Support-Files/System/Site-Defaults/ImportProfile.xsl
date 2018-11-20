<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">

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
		
		<!-- The evaluation of diagnostic results to look for OtherOrders
			 incurs a significant performance cost that should be avoided
			 when not needed.  enableOtherOrders toggles that evaluation.
			 
			 It is possible for an order to be considered an OtherOrder
			 only when IsLabResult-site and IsRadResult-site have site-
			 specific logic that could cause an order to be considered
			 neither lab nor rad. Only when such logic is implemented
			 should enableOtherOrders be set to 1.
		-->
		<enableOtherOrders>0</enableOtherOrders>
		
		<!--
			concatRootAndNumericExtension is used during the parsing
			of hl7:representedOrganization/hl7:id when deriving facility
			information.  When concatRootAndNumericExtension equals 1,
			if hl7:representedOrganization/hl7:id @root is an OID and
			@extension is numeric, then @root and @extension are
			concatenated into one facility OID.
		-->
		<representedOrganizationId>
			<concatRootAndNumericExtension>0</concatRootAndNumericExtension>
		</representedOrganizationId>
		
		<!--
			narrativeImportMode is used when importing content from
			the section narrative, as opposed to the strucutured body.
			This general setting value is used when a field-specific
			value is not specified.
			1 = import as text, import both <br/> and narrative line feeds as line feeds
			2 = import as text, import <br/> as line feed, ignore narrative line feeds
		-->
		<narrativeImportMode>1</narrativeImportMode>

		<!--
			blockImportCTDCodeFromText is used to block the import of
			CDA string, narrative text, or originalText into an SDA
			CodeTableDetail Code property when the CDA @code attribute
			is not available.
			
			Long-standing import functionality has been to import from
			those items when @code is not present (i.e., @nullFlavor is
			present).  Setting this item to 1 will alter that behavior
			and will cause <Code/> to be imported if the CDA coded element
			is nullFlavor.
		-->
		<blockImportCTDCodeFromText>0</blockImportCTDCodeFromText>
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
	
	<xsl:variable name="assessmentAndPlanImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-AssessmentAndPlan"/></sectionTemplateId>
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
		<pharmacyStatus>DISCHARGE</pharmacyStatus>
	</xsl:variable>

	<xsl:variable name="encountersImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-EncounterHistories"/></sectionTemplateId>
		<!-- 
			encounterTypeMaps maps CDA coded encounter type information
			(code and codeSystem) to values for the SDA EncounterType
			string property.
			
			encounterTypeMap XML element names and intended values:
			- CDACode          = Encounter Code from the CDA document.
			- CDACodeSystem    = codeSystem OID associated with CDAcode.
			- SDAEncounterType = Valid values are I, O, or E.
			
			This is an example of what the map may look like:
			
			<encounterTypeMaps>
				<encounterTypeMap>
					<CDACode>92202</CDACode>
					<CDACodeSystem>2.16.840.1.113883.6.12</CDACodeSystem>
					<SDAEncounterType>O</SDAEncounterType>
				</encounterTypeMap>
				<encounterTypeMap>
					<CDACode>99212</CDACode>
					<CDACodeSystem>2.16.840.1.113883.6.12</CDACodeSystem>
					<SDAEncounterType>I</SDAEncounterType>
				</encounterTypeMap>
			</encounterTypeMaps>
			
			To add your own mappings, copy and paste the encounterTypeMap
			section that is within the encounterTypeMaps section below to
			create new entries with your desired values.
		-->
		<encounterTypeMaps>
			<encounterTypeMap>
				<CDACode>code</CDACode>
				<CDACodeSystem>oid</CDACodeSystem>
				<SDAEncounterType>IOE</SDAEncounterType>
			</encounterTypeMap>
		</encounterTypeMaps>
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
		<pharmacyStatus>MEDICATIONS</pharmacyStatus>
	</xsl:variable>

	<xsl:variable name="medicationsAdministeredImportConfiguration">
		<sectionTemplateId><xsl:value-of select="$ihe-PCC-SelectMedsAdministered"/></sectionTemplateId>
		<pharmacyStatus>ADMINISTERED</pharmacyStatus>
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
		<effectiveTimeCenter>0</effectiveTimeCenter>
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
