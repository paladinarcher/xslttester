<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HL7.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-CCDA.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-NQF.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-QRDA.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-InterSystems.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CCDA/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/QRDA/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/QRDA/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/Variables.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/HealthcareProvider.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/InformationSource.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/LanguageSpoken.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/PersonalInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/Support.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/Condition.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/Encounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/Result.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/CCDA/VitalSign.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/DiagnosisActive.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/DiagnosisInactive.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/DiagnosticStudyResult.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/Encounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/LaboratoryTestResult.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/Measure.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/Medication.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/MedicationAllergy.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PatientCharacteristicClinicalTrial.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PatientCharacteristicExpired.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PatientData.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PhysicalExamFinding.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PlanOfCareActivityEncounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PlanOfCareActivityMedication.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/PlanOfCareActivitySupply.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/Procedure.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/ProcedureAct.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/ProcedureObservation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/ReportingParameter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/RiskCategoryAssessment.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/QRDA/SymptomActive.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/QRDA/Measures.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/QRDA/ReportingParameters.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/QRDA/PatientData.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Site/OutputEncoding.xsl"/>
	
	<xsl:template match="/Container">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
			<!-- Begin CDA Header -->
			<realmCode code="US"/>
			<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
			
			<xsl:apply-templates select="." mode="templateIds-documentHeader"/>
			
			<xsl:apply-templates select="Patient" mode="id-Document"/>
			
			<code code="55182-0" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Quality Measure Report"/>
			
			<xsl:apply-templates select="." mode="document-title">
				<xsl:with-param name="title1">QRDA Incidence Report</xsl:with-param>
			</xsl:apply-templates>
			
			<effectiveTime value="{$currentDateTime}"/>
			<xsl:apply-templates mode="document-confidentialityCode" select="."/>
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
			<!-- Begin QRDA Body -->
			<component>
				<structuredBody>
					<!-- Measures -->
					<xsl:apply-templates select="." mode="measures"/>
					
					<!-- Reporting Parameters -->
					<xsl:apply-templates select="." mode="reportingParameters"/>
					
					<!-- Patient Data -->
					<xsl:apply-templates select="." mode="patientData"/>
					
					<!-- Custom export -->
					<xsl:apply-templates select="." mode="ExportCustom-ClinicalDocument"/>
				</structuredBody>
			</component>
			<!-- End QRDA Body -->
		</ClinicalDocument>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-documentHeader">
		<templateId root="{$ccda-USRealmHeader}"/>
		<templateId root="{$qrda-Category1}"/>
		<templateId root="{$qrda-QualityDataModelBased}"/>
	</xsl:template>
	
	<!-- confidentialityCode may be overriden by stylesheets that import this one -->
	<xsl:template mode="document-confidentialityCode" match="Container">
		<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25" displayName="Normal"/>
	</xsl:template>

	<!-- This empty template may be overridden with custom logic. -->
	<xsl:template match="*" mode="ExportCustom-ClinicalDocument">
	</xsl:template>
</xsl:stylesheet>
