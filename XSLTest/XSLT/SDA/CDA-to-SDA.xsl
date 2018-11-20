<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 sdtc xsi exsl">
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HITSP.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HL7.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-IHE.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-InterSystems.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/String-Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/ImportProfile.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/Variables.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/AdvanceDirective.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/AllergyAndDrugSensitivity.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Comment.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Condition.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Encounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/FamilyHistory.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/HealthcareProvider.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/HistoryOfPresentIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/InsuranceProvider.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Medication.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/PersonalInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/PlanOfCare.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Procedure.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Result.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/SocialHistory.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Support.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/VitalSign.xsl"/>

	<xsl:include href="CDA-Support-Files/Import/Section-Modules/AdvanceDirectives.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/AllergiesAndOtherAdverseReactions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/DiagnosticResults.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/DischargeDiagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/Encounters.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/FamilyHistory.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/HistoryOfPastIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/HistoryOfPresentIllness.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/HospitalAdmissionDiagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/HospitalDischargeMedications.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/Immunizations.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/Medications.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/MedicationsAdministered.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/Non-RatifiedSections.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/Payers.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/PlanOfCare.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/ProblemList.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/ProceduresAndInterventions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/SocialHistory.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/VitalSigns.xsl"/>
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="/hl7:ClinicalDocument">
		<Container>
			<!-- Sending Facility -->
			<xsl:choose>
				<xsl:when test="$defaultInformantRootPath"><xsl:apply-templates select="$defaultInformantRootPath" mode="SendingFacility"/></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="$defaultAuthorRootPath" mode="SendingFacility"/></xsl:otherwise>
			</xsl:choose>

			<Patients>
				<Patient>
					<!-- Personal Information -->
					<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole" mode="PersonalInformation"/>
					
					<!-- Healthcare Provider module -->
					<xsl:apply-templates select="hl7:documentationOf" mode="HealthcareProvider"/>

					<!-- Support module -->
					<xsl:apply-templates select="." mode="Support"/>
					
					<!-- Alerts and Allergies -->
					<!-- SNOMED code 160244002 is for "No Known allergies".  This is our -->
					<!-- indicator that we should not try to import Allergies at all.    -->
					<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$allergiesSectionTemplateId and not(hl7:entry[1]/hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code='160244002' and hl7:entry[1]/hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@codeSystem='2.16.840.1.113883.6.96') and not(count(hl7:entry)=0)]" mode="Allergies"/>
					
					<!-- Advance Directives -->
					<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$advanceDirectivesSectionTemplateId]" mode="AdvanceDirectives"/>
					
					<!-- Family History -->
					<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$familyHistorySectionTemplateId]" mode="FamilyHistories"/>
					
					<!-- Social History -->
					<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$socialHistorySectionTemplateId]" mode="SocialHistories"/>
					
					<!-- History of Present Illness -->
					<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$presentIllnessSectionTemplateId]" mode="PresentIllnesses"/>

					<!-- Encounters -->
					<xsl:apply-templates select="." mode="Encounters"/>
				</Patient>
			</Patients>
		</Container>
	</xsl:template>
</xsl:stylesheet>
