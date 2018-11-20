<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<!-- C = Cancelled, D = Discontinued -->
	<xsl:variable name="medicationCancelledStatusCodes">|C|D|</xsl:variable>
	
	<xsl:template match="Container" mode="patientData-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Data Element</th>
						<th>Value</th>
						<th>Date/Time</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="." mode="patientData-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="Container" mode="patientData-NarrativeDetail">
		<!--
			The measures specified for a given QRDA export determine what
			entries get exported.  The templateIds for the NQF templates
			used by the specified measures have been aggregated into a
			vertical bar-delimited string variable $templateIds.  For
			each type of entry, $templateIds is checked to see if the
			particular type of entry is required for export.  If so,
			then the logic proceeds with checking other entry-specific
			criteria before exporting.
		-->
		
		<!-- Device Applied - templates are in Procedure.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DeviceApplied,'|')) or contains($templateIds,concat('|',$nqf-DeviceAppliedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[Procedure/Code='360030002' and CustomPairs[NVPair/Name='DeviceCode']]" mode="procedure-DeviceApplied-Narrative"/>
		</xsl:if>
		
		<!-- Device Order - templates are in PlanOfCareActivitySupply.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DeviceOrder,'|')) or contains($templateIds,concat('|',$nqf-DeviceOrderNotDone,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='Device' and CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="deviceOrder-Narrative"/>
		</xsl:if>
		
		<!-- Diagnosis Active - templates are in DiagnosisActive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosisActive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='282291009']" mode="diagnosisActive-Problem-Narrative"/>
		</xsl:if>
		
		<!-- Diagnosis Inactive - templates are in DiagnosisInactive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosisInactive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='282291009']" mode="diagnosisInactive-Problem-Narrative"/>
		</xsl:if>
		
		<!-- Diagnostic Study Performed - templates are in ProcedureObservation.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosticStudyPerformed,'|')) or contains($templateIds,concat('|',$nqf-DiagnosticStudyPerformedNotDone,'|'))">
			<xsl:apply-templates select="RadOrders/RadOrder[not(string-length(Result/ResultItems))]" mode="procedureObservation-DiagnosticStudyPerformed-Narrative"/>
		</xsl:if>
		
		<!-- Diagnostic Study Result - templates are in DiagnosticStudyResult.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosticStudyResult,'|')) or contains($templateIds,concat('|',$nqf-DiagnosticStudyResultNotDone,'|'))">
			<xsl:apply-templates select="RadOrders/RadOrder/Result[ResultItems]" mode="diagnosticStudyResults-Narrative"/>
		</xsl:if>
		
		<!-- Encounter Active - templates are in Encounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$qrda-EncounterActive,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[not(string-length(ToTime)) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="encounterActive-Narrative"/>
		</xsl:if>
		
		<!-- Encounter Order - templates are in PlanOfCareActivityEncounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-EncounterOrder,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="encounterOrder-Narrative"/>
		</xsl:if>
		
		<!-- Encounter Performed - templates are in Encounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-EncounterPerformed,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[string-length(ToTime)>0 and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="encounterPerformed-Narrative"/>
		</xsl:if>
		
		<!-- Intervention Order - templates are in PlanOfCareActivityAct.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-InterventionOrder,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[contains($interventionCodes,concat('|',Procedure/Code/text(),'|')) and CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="procedureAct-InterventionOrder-Narrative"/>
		</xsl:if>
		
		<!-- Intervention Performed - templates are in ProcedureAct.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-InterventionPerformed,'|')) or contains($templateIds,concat('|',$nqf-InterventionPerformedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[contains($interventionCodes,concat('|',Procedure/Code/text(),'|')) and string-length(ProcedureTime) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="procedureAct-InterventionPerformed-Narrative"/>
		</xsl:if>
		
		<!-- Laboratory Test Result - templates are in Result.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-LaboratoryTestResult,'|'))">
			<xsl:apply-templates select="LabOrders/LabOrder/Result[string-length(ResultText) or string-length(ResultItems)]" mode="laboratoryTestResults-Narrative"/>
		</xsl:if>
		
		<!-- Medications Active - templates are in Medication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationActive,'|'))">
			<xsl:apply-templates select="Medications/Medication[not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|'))) and not(string-length(ToTime/text()))]" mode="medicationActive-Narrative"/>
		</xsl:if>
		
		<!-- Medications Administered - templates are in Medication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationAdministered,'|')) or contains($templateIds,concat('|',$nqf-MedicationAdministeredNotDone,'|'))">
			<xsl:apply-templates select="Medications/Medication[contains('E|I|O', key('EncNum', EncounterNumber)/EncounterType) and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|'))) and (string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(key('EncNum', EncounterNumber)/FromTime/text(), 'TZ', ' '), translate(FromTime/text(), 'TZ', ' ')) &gt;= 0) and (not(string-length(key('EncNum', EncounterNumber)/ToTime/text())) or (string-length(ToTime/text()) and string-length(key('EncNum', EncounterNumber)/ToTime/text()) and isc:evaluate('dateDiff', 'dd', translate(key('EncNum', EncounterNumber)/ToTime/text(), 'TZ', ' '), translate(ToTime/text(), 'TZ', ' ')) &lt;= 0))]" mode="medicationAdministered-Narrative"/>
		</xsl:if>
		
		<!-- Medication Allergy - templates are in MedicationAllergy.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationAllergy,'|'))">
			<xsl:apply-templates select="Allergies/Allergy[AllergyCategory/Code='416098002']" mode="medicationAllergy-Narrative"/>
		</xsl:if>
		
		<!-- Medication Order - templates are in PlanOfCareActivityMedication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationOrder,'|')) or contains($templateIds,concat('|',$nqf-MedicationOrderNotDone,'|'))">
			<xsl:apply-templates select="Medications/Medication[CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="medicationOrder-Narrative"/>
		</xsl:if>
		
		<!-- Patient Characteristic Clinical Trial Participant - templates are in PatientCharacteristicClinicalTrial.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PatientCharacteristicClinicalTrialParticipant,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='ClinicalTrial']" mode="patientCharacteristic-ClinicalTrialParticipant-Narrative"/>
		</xsl:if>
		
		<!-- Patient Characteristic Expired - templates are in PatientCharacteristicExpired.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PatientCharacteristicExpired,'|'))">
			<xsl:apply-templates select="self::node()[Patient/IsDead='1' or string-length(Patient/DeathTime)]" mode="patientCharacteristic-Expired-Narrative"/>
		</xsl:if>
		
		<!-- Physical Exam Finding - templates are in PhysicalExamFinding.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PhysicalExamFinding,'|'))">
			<xsl:apply-templates select="Observations/Observation" mode="physicalExamFinding-Observation-Narrative"/>
		</xsl:if>
		
		<!-- Procedure Performed - templates are in Procedure.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-ProcedurePerformed,'|')) or contains($templateIds,concat('|',$nqf-ProcedurePerformedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[not(contains($interventionCodes,concat('|',Procedure/Code/text(),'|'))) and not(Procedure/Code='360030002') and string-length(ProcedureTime) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="procedure-ProcedurePerformed-Narrative"/>
		</xsl:if>
		
		<!-- Risk Category Assessment - templates are in RiskCategoryAssessment.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-RiskCategoryAssessment,'|')) or contains($templateIds,concat('|',$nqf-RiskCategoryAssessmentNotDone,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='RiskCategoryAssessment']" mode="riskCategoryAssessment-Narrative"/>
		</xsl:if>
		
		<!-- Symptom Active - templates are in SymptomActive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-SymptomActive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='418799008']" mode="symptomActive-Narrative"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Container" mode="patientData-Entries">
		<!--
			The measures specified for a given QRDA export determine what
			entries get exported.  The templateIds for the NQF templates
			used by the specified measures have been aggregated into a
			vertical bar-delimited string variable $templateIds.  For
			each type of entry, $templateIds is checked to see if the
			particular type of entry is required for export.  If so,
			then the logic proceeds with checking other entry-specific
			criteria before exporting.
		-->
		
		<!-- Device Applied - templates are in Procedure.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DeviceApplied,'|')) or contains($templateIds,concat('|',$nqf-DeviceAppliedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[Procedure/Code='360030002' and CustomPairs[NVPair/Name='DeviceCode']]" mode="procedure-DeviceApplied-Entry"/>
		</xsl:if>
		
		<!-- Device Order - templates are in PlanOfCareActivitySupply.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DeviceOrder,'|')) or contains($templateIds,concat('|',$nqf-DeviceOrderNotDone,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='Device' and CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="deviceOrder-Entry"/>
		</xsl:if>
		
		<!-- Diagnosis Active - templates are in DiagnosisActive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosisActive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='282291009']" mode="diagnosisActive-Problem-Entry"/>
		</xsl:if>
		
		<!-- Diagnosis Inactive - templates are in DiagnosisInactive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosisInactive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='282291009']" mode="diagnosisInactive-Problem-Entry"/>
		</xsl:if>
		
		<!-- Diagnostic Study Performed - templates are in ProcedureObservation.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosticStudyPerformed,'|')) or contains($templateIds,concat('|',$nqf-DiagnosticStudyPerformedNotDone,'|'))">
			<xsl:apply-templates select="RadOrders/RadOrder[not(string-length(Result/ResultItems))]" mode="procedureObservation-DiagnosticStudyPerformed-Entry"/>
		</xsl:if>
		
		<!-- Diagnostic Study Result - templates are in DiagnosticStudyResult.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-DiagnosticStudyResult,'|')) or contains($templateIds,concat('|',$nqf-DiagnosticStudyResultNotDone,'|'))">
			<xsl:apply-templates select="RadOrders/RadOrder/Result[ResultItems]" mode="diagnosticStudyResults-Entry"/>
		</xsl:if>
		
		<!-- Encounter Active - templates are in Encounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$qrda-EncounterActive,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[not(string-length(ToTime)) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="encounterActive-Entry"/>
		</xsl:if>
		
		<!-- Encounter Order - templates are in PlanOfCareActivityEncounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-EncounterOrder,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="encounterOrder-Entry"/>
		</xsl:if>
		
		<!-- Encounter Performed - templates are in Encounter.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-EncounterPerformed,'|'))">
			<xsl:apply-templates select="Encounters/Encounter[string-length(ToTime)>0 and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="encounterPerformed-Entry"/>
		</xsl:if>
		
		<!-- Intervention Order - templates are in PlanOfCareActivityAct.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-InterventionOrder,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[contains($interventionCodes,concat('|',Procedure/Code/text(),'|')) and CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="procedureAct-InterventionOrder-Entry"/>
		</xsl:if>
		
		<!-- Intervention Performed - templates are in ProcedureAct.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-InterventionPerformed,'|')) or contains($templateIds,concat('|',$nqf-InterventionPerformedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[contains($interventionCodes,concat('|',Procedure/Code/text(),'|')) and string-length(ProcedureTime) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="procedureAct-InterventionPerformed-Entry"/>
		</xsl:if>
		
		<!-- Laboratory Test Result - templates are in Result.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-LaboratoryTestResult,'|'))">
			<xsl:apply-templates select="LabOrders/LabOrder/Result[string-length(ResultText) or string-length(ResultItems)]" mode="laboratoryTestResults-Entry"/>
		</xsl:if>
		
		<!-- Medications Active - templates are in Medication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationActive,'|'))">
			<xsl:apply-templates select="Medications/Medication[not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|'))) and not(string-length(ToTime/text()))]" mode="medicationActive-Entry"/>
		</xsl:if>
		
		<!-- Medications Administered - templates are in Medication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationAdministered,'|')) or contains($templateIds,concat('|',$nqf-MedicationAdministeredNotDone,'|'))">
			<xsl:apply-templates select="Medications/Medication[contains('E|I|O', key('EncNum', EncounterNumber)/EncounterType) and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|'))) and (string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(key('EncNum', EncounterNumber)/FromTime/text(), 'TZ', ' '), translate(FromTime/text(), 'TZ', ' ')) &gt;= 0) and (not(string-length(key('EncNum', EncounterNumber)/ToTime/text())) or (string-length(ToTime/text()) and string-length(key('EncNum', EncounterNumber)/ToTime/text()) and isc:evaluate('dateDiff', 'dd', translate(key('EncNum', EncounterNumber)/ToTime/text(), 'TZ', ' '), translate(ToTime/text(), 'TZ', ' ')) &lt;= 0))]" mode="medicationAdministered-Entry"/>
		</xsl:if>
		
		<!-- Medication Allergy - templates are in MedicationAllergy.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationAllergy,'|'))">
			<xsl:apply-templates select="Allergies/Allergy[AllergyCategory/Code='416098002']" mode="medicationAllergy-Entry"/>
		</xsl:if>
		
		<!-- Medication Order - templates are in PlanOfCareActivityMedication.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-MedicationOrder,'|')) or contains($templateIds,concat('|',$nqf-MedicationOrderNotDone,'|'))">
			<xsl:apply-templates select="Medications/Medication[CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()='RQO']" mode="medicationOrder-Entry"/>
		</xsl:if>
		
		<!-- Patient Characteristic Clinical Trial Participant - templates are in PatientCharacteristicClinicalTrial.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PatientCharacteristicClinicalTrialParticipant,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='ClinicalTrial']" mode="patientCharacteristic-ClinicalTrialParticipant-Entry"/>
		</xsl:if>
		
		<!-- Patient Characteristic Expired - templates are in PatientCharacteristicExpired.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PatientCharacteristicExpired,'|'))">
			<xsl:apply-templates select="self::node()[Patient/IsDead='1' or string-length(Patient/DeathTime)]" mode="patientCharacteristic-Expired-Entry"/>
		</xsl:if>
		
		<!-- Physical Exam Finding - templates are in PhysicalExamFinding.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-PhysicalExamFinding,'|'))">
			<xsl:apply-templates select="Observations/Observation" mode="physicalExamFinding-Observation-Entry"/>
			<!--<xsl:apply-templates select="PhysicalExams/PhysicalExam" mode="physicalExamFinding-PhysicalExam-Entry"/>-->
		</xsl:if>
		
		<!-- Procedure Performed - templates are in Procedure.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-ProcedurePerformed,'|')) or contains($templateIds,concat('|',$nqf-ProcedurePerformedNotDone,'|'))">
			<xsl:apply-templates select="Procedures/Procedure[not(contains($interventionCodes,concat('|',Procedure/Code/text(),'|'))) and not(Procedure/Code='360030002') and string-length(ProcedureTime) and not(string-length(CustomPairs/NVPair[Name='PlanOfCareType']/Value/text()))]" mode="procedure-ProcedurePerformed-Entry"/>
		</xsl:if>
		
		<!-- Risk Category Assessment - templates are in RiskCategoryAssessment.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-RiskCategoryAssessment,'|')) or contains($templateIds,concat('|',$nqf-RiskCategoryAssessmentNotDone,'|'))">
			<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='RiskCategoryAssessment']" mode="riskCategoryAssessment-Entry"/>
		</xsl:if>
		
		<!-- Symptom Active - templates are in SymptomActive.xsl -->
		<xsl:if test="contains($templateIds,concat('|',$nqf-SymptomActive,'|'))">
			<xsl:apply-templates select="Problems/Problem[Category/Code/text()='418799008']" mode="symptomActive-Entry"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
