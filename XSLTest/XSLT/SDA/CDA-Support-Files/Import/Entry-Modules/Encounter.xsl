<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 sdtc xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="DefaultEncounter">
		<Encounter>
			<xsl:apply-templates select="." mode="DefaultEncounterDetail"/>
	
			<!-- Process CDA Append/Transform/Replace Directive -->
			<xsl:call-template name="ActionCode">
				<xsl:with-param name="informationType" select="'Encounter'"/>
			</xsl:call-template>
			
			<!-- Entries using either (1) the <encompassingEncounter> ID or (2) no encounter ID -->
			<!-- encounterIDTemp is used as an intermediate so that encounterID
				can be set up such that "000nnn" does NOT match "nnn" when
				comparing encounter numbers.
			-->
			<xsl:variable name="encounterIDTemp"><xsl:apply-templates select="." mode="EncounterId"/></xsl:variable>
			<xsl:variable name="encounterID" select="string($encounterIDTemp)"/>

			<!-- Check for "no data" sections to prevent exporting empty or incomplete SDA.  -->
			<!-- 10/27/2011 Only checking these sections for now because NIST requires these -->
			<!-- CDA sections to explicitly state no data when no data.                      -->
			<xsl:variable name="activeProblemsNoData" select="(count($activeProblemSection/hl7:entry)=0) or (count($activeProblemSection/hl7:entry)=1 and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@nullFlavor='NI' and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:value/@nullFlavor='NI')"/>
			<xsl:variable name="dischargeMedicationsNoData" select="(count($dischargeMedicationSection/hl7:entry)=0) or ($dischargeMedicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsNoData" select="(count($medicationSection/hl7:entry)=0) or ($medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsAdministeredNoData" select="(count($medicationsAdministeredSection/hl7:entry)=0) or ($medicationsAdministeredSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			
			<xsl:call-template name="Encounter">
				<xsl:with-param name="activeProblemEntries" select="$activeProblemSection/hl7:entry[((.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)) and not($activeProblemsNoData)]"/>
				<xsl:with-param name="resolvedProblemEntries" select="$resolvedProblemSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="admissionDiagnosisEntries" select="$admissionDiagnosisSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="dischargeDiagnosisEntries" select="$dischargeDiagnosisSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="dischargeMedicationEntries" select="$dischargeMedicationSection/hl7:entry[((.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)) and not($dischargeMedicationsNoData)]"/>
				<xsl:with-param name="immunizationEntries" select="$immunizationSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="medicationEntries" select="$medicationSection/hl7:entry[((.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)) and not($medicationsNoData)]"/>
				<xsl:with-param name="medicationsAdministeredEntries" select="$medicationsAdministeredSection/hl7:entry[((.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)) and not($medicationsAdministeredNoData)]"/>
				<xsl:with-param name="resultsC32Entries" select="$resultsC32Section/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="resultsC37Entries" select="$resultsC37Section/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="vitalSignEntries" select="$vitalSignSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="payerEntries" select="$payerSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="planEntries" select="$planSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="procedureEntries" select="$procedureSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="careConsiderationEntries" select="$careConsiderationSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
			</xsl:call-template>
		</Encounter>
	</xsl:template>

	<xsl:template match="*" mode="SilentEncounter">
		<Encounter>
			<xsl:apply-templates select="." mode="SilentEncounterDetail"/>
			
			<!-- No ActionCode processing done here by design, to protect the "current issue" list from being overwritten -->

			<!-- Check for "no data" sections to prevent exporting empty or incomplete SDA.  -->
			<!-- 10/27/2011 Only checking these sections for now because NIST requires these -->
			<!-- CDA sections to explicitly state no data when no data.                      -->
			<xsl:variable name="activeProblemsNoData" select="(count($activeProblemSection/hl7:entry)=0) or (count($activeProblemSection/hl7:entry)=1 and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@nullFlavor='NI' and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:value/@nullFlavor='NI')"/>
			<xsl:variable name="dischargeMedicationsNoData" select="(count($dischargeMedicationSection/hl7:entry)=0) or ($dischargeMedicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsNoData" select="(count($medicationSection/hl7:entry)=0) or ($medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsAdministeredNoData" select="(count($medicationsAdministeredSection/hl7:entry)=0) or ($medicationsAdministeredSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>

			<!-- Encounters without any encounter specified -->
			<xsl:call-template name="Encounter">
				<xsl:with-param name="activeProblemEntries" select="$activeProblemSection/hl7:entry[not(.//hl7:encounter) and not($activeProblemsNoData)]"/>
				<xsl:with-param name="resolvedProblemEntries" select="$resolvedProblemSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="admissionDiagnosisEntries" select="$admissionDiagnosisSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="dischargeDiagnosisEntries" select="$dischargeDiagnosisSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="dischargeMedicationEntries" select="$dischargeMedicationSection/hl7:entry[not(.//hl7:encounter) and not($dischargeMedicationsNoData)]"/>
				<xsl:with-param name="immunizationEntries" select="$immunizationSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="medicationEntries" select="$medicationSection/hl7:entry[not(.//hl7:encounter)  and not($medicationsNoData)]"/>
				<xsl:with-param name="medicationsAdministeredEntries" select="$medicationsAdministeredSection/hl7:entry[not(.//hl7:encounter) and not($medicationsAdministeredNoData)]"/>
				<xsl:with-param name="resultsC32Entries" select="$resultsC32Section/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="resultsC37Entries" select="$resultsC37Section/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="vitalSignEntries" select="$vitalSignSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="payerEntries" select="$payerSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="planEntries" select="$planSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="procedureEntries" select="$procedureSection/hl7:entry[not(.//hl7:encounter)]"/>
				<xsl:with-param name="careConsiderationEntries" select="$careConsiderationSection/hl7:entry[not(.//hl7:encounter)]"/>
			</xsl:call-template>
		</Encounter>
	</xsl:template>
	
	<xsl:template match="*" mode="OverriddenEncounter">
		<Encounter>
			<xsl:apply-templates select="." mode="OverriddenEncounterDetail"/>
			
			<!-- Process CDA Append/Transform/Replace Directive -->
			<xsl:call-template name="ActionCode">
				<xsl:with-param name="informationType" select="'Encounter'"/>
			</xsl:call-template>
			
			<!-- Encounters using an <encounter> id -->
			<!-- encounterIDTemp is used as an intermediate so that encounterID
				can be set up such that "000nnn" does NOT match "nnn" when
				comparing encounter numbers.
			-->
			<xsl:variable name="encounterIDTemp"><xsl:apply-templates select="." mode="EncounterId"/></xsl:variable>
			<xsl:variable name="encounterID" select="string($encounterIDTemp)"/>

			<!-- Check for "no data" sections to prevent exporting empty or incomplete SDA.  -->
			<!-- 10/27/2011 Only checking these sections for now because NIST requires these -->
			<!-- CDA sections to explicitly state no data when no data.                      -->
			<xsl:variable name="activeProblemsNoData" select="(count($activeProblemSection/hl7:entry)=0) or (count($activeProblemSection/hl7:entry)=1 and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@nullFlavor='NI' and $activeProblemSection/hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:value/@nullFlavor='NI')"/>
			<xsl:variable name="dischargeMedicationsNoData" select="(count($dischargeMedicationSection/hl7:entry)=0) or ($dischargeMedicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsNoData" select="(count($medicationSection/hl7:entry)=0) or ($medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>
			<xsl:variable name="medicationsAdministeredNoData" select="(count($medicationsAdministeredSection/hl7:entry)=0) or ($medicationsAdministeredSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@code='182849000' and $medicationSection/hl7:entry[1]/hl7:substanceAdministration[1]/hl7:code/@codeSystem='2.16.840.1.113883.6.96')"/>

			<xsl:call-template name="Encounter">
				<xsl:with-param name="activeProblemEntries" select="$activeProblemSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID and not($activeProblemsNoData)]"/>
				<xsl:with-param name="resolvedProblemEntries" select="$resolvedProblemSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="admissionDiagnosisEntries" select="$admissionDiagnosisSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="dischargeDiagnosisEntries" select="$dischargeDiagnosisSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="dischargeMedicationEntries" select="$dischargeMedicationSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID and not($dischargeMedicationsNoData)]"/>
				<xsl:with-param name="immunizationEntries" select="$immunizationSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="medicationEntries" select="$medicationSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID and not($medicationsNoData)]"/>
				<xsl:with-param name="medicationsAdministeredEntries" select="$medicationsAdministeredSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID and not($medicationsAdministeredNoData)]"/>
				<xsl:with-param name="resultsC32Entries" select="$resultsC32Section/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="resultsC37Entries" select="$resultsC37Section/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="vitalSignEntries" select="$vitalSignSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="payerEntries" select="$payerSection/hl7:entry[(.//hl7:encounter/hl7:id/@extension=$encounterID) or not(.//hl7:encounter)]"/>
				<xsl:with-param name="planEntries" select="$planSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="procedureEntries" select="$procedureSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
				<xsl:with-param name="careConsiderationEntries" select="$careConsiderationSection/hl7:entry[.//hl7:encounter/hl7:id/@extension=$encounterID]"/>
			</xsl:call-template>
		</Encounter>
	</xsl:template>

	<xsl:template match="*" mode="DefaultEncounterDetail">
		<!-- EnteredBy -->
		<xsl:apply-templates select="$defaultAuthorRootPath" mode="EnteredBy"/>
		
		<!-- EnteredAt -->
		<xsl:apply-templates select="$defaultAuthorRootPath" mode="EnteredAt"/>
		
		<!-- EnteredOn -->
		<xsl:apply-templates select="$defaultAuthorRootPath/hl7:time" mode="EnteredOn"/>
		
		<!-- Override ExternalId with the <id> values from the source CDA -->
		<xsl:apply-templates select="." mode="ExternalId"/>
		
		<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/hl7:low/@value)"/></StartTime>
		<EndTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/hl7:high/@value)"/></EndTime>
		
		<!-- Encounter Type -->
		<xsl:apply-templates select="hl7:code" mode="EncounterType"/>
		
		<!-- Admission Type -->
		<xsl:apply-templates select="hl7:priorityCode" mode="AdmissionType"/>

		<!-- Admitting, Attending, Referring, and Consulting Clinicians -->
		<xsl:apply-templates select="hl7:encounterParticipant[@typeCode = 'ADM']" mode="AdmittingClinician"/>
		<xsl:apply-templates select="hl7:encounterParticipant[@typeCode = 'ATND']" mode="AttendingClinicians"/>
		<xsl:apply-templates select="hl7:encounterParticipant[@typeCode = 'REF']" mode="ReferringClinician"/>
		<xsl:apply-templates select="hl7:encounterParticipant[@typeCode = 'CON']" mode="ConsultingClinicians"/>
		
		<!-- Encounter ID -->
		<VisitNumber><xsl:apply-templates select="." mode="EncounterId"/></VisitNumber>
		
		<!-- Encounter MRN -->
		<xsl:apply-templates select="hl7:encounterParticipant/hl7:assignedEntity/sdtc:patient" mode="EncounterMRN"/>
		
		<!-- Healthcare Facility -->
		<xsl:apply-templates select="hl7:location" mode="HealthCareFacility"/>
	</xsl:template>
	
	<xsl:template match="*" mode="SilentEncounterDetail">
		<!-- EnteredBy -->
		<xsl:apply-templates select="." mode="EnteredBy"/>
		
		<!-- EnteredAt -->
		<xsl:apply-templates select="." mode="EnteredAt"/>
		
		<!-- EnteredOn -->
		<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
		
		<!-- Override ExternalId with the <id> values from the source CDA -->
		<xsl:apply-templates select="." mode="ExternalId"/>
		
		<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/@value)"/></StartTime>
		<EndTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/@value)"/></EndTime>
		
		<!-- Encounter and Admission Type -->
		<EncounterType>S</EncounterType>
		
		<!-- Encounter ID -->
		<xsl:variable name="visitNumber" select="concat(/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id/@root, '_', isc:evaluate('getCodeForOID', /hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id/@root, 'AssigningAuthority'), '_', /hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id/@extension)"/>
		<VisitNumber><xsl:value-of select="$visitNumber"/></VisitNumber>
	</xsl:template>

	<xsl:template match="*" mode="OverriddenEncounterDetail">
		<!-- EnteredBy -->
		<xsl:apply-templates select="." mode="EnteredBy"/>
		
		<!-- EnteredAt -->
		<xsl:apply-templates select="." mode="EnteredAt"/>
		
		<!-- EnteredOn -->
		<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
		
		<!-- Override ExternalId with the <id> values from the source CDA -->
		<xsl:apply-templates select="." mode="ExternalId"/>
		
		<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/hl7:low/@value)"/></StartTime>
		<EndTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:effectiveTime/hl7:high/@value)"/></EndTime>
		
		<!-- Encounter Type -->
		<xsl:apply-templates select="hl7:code" mode="EncounterType"/>
		
		<!-- Admission Type -->
		<xsl:apply-templates select="hl7:priorityCode" mode="AdmissionType"/>
		
		<!-- Admitting, Attending, Referring, and Consulting Clinicians -->
		<xsl:apply-templates select="hl7:participant[@typeCode = 'ADM']" mode="AdmittingClinician"/>
		<xsl:apply-templates select="hl7:participant[@typeCode = 'ATND'] | hl7:performer[@typeCode = 'PRF']" mode="AttendingClinicians"/>
		<xsl:apply-templates select="hl7:participant[@typeCode = 'REF']" mode="ReferringClinician"/>
		<xsl:apply-templates select="hl7:participant[@typeCode = 'CON']" mode="ConsultingClinicians"/>
		
		<!-- Encounter ID -->
		<VisitNumber><xsl:apply-templates select="." mode="EncounterId"/></VisitNumber>
		
		<!-- Encounter MRN -->
		<xsl:apply-templates select="hl7:informant/hl7:assignedEntity/sdtc:patient" mode="EncounterMRN"/>
		
		<!-- Healthcare Facility -->
		<xsl:apply-templates select="hl7:informant" mode="HealthCareFacility"/>
	</xsl:template>
	
	<xsl:template name="Encounter">
		<xsl:param name="activeProblemEntries"/>
		<xsl:param name="resolvedProblemEntries"/>
		<xsl:param name="admissionDiagnosisEntries"/>
		<xsl:param name="dischargeDiagnosisEntries"/>
		<xsl:param name="dischargeMedicationEntries"/>
		<xsl:param name="immunizationEntries"/>
		<xsl:param name="medicationEntries"/>
		<xsl:param name="medicationsAdministeredEntries"/>
		<xsl:param name="resultsC32Entries"/>
		<xsl:param name="resultsC37Entries"/>
		<xsl:param name="vitalSignEntries"/>
		<xsl:param name="payerEntries"/>
		<xsl:param name="planEntries"/>
		<xsl:param name="procedureEntries"/>
		<xsl:param name="careConsiderationEntries"/>
		
		<!-- Health Funds -->
		<xsl:if test="$payerEntries">
			<HealthFunds>
				<xsl:apply-templates select="$payerEntries" mode="HealthFunds"/>
			</HealthFunds>
		</xsl:if>
		
		<!-- Problems and History of Past Illness -->
		<xsl:if test="$activeProblemEntries or $resolvedProblemEntries">
			<Problems>
				<xsl:apply-templates select="$activeProblemEntries" mode="ActiveProblems"/>
				<xsl:apply-templates select="$resolvedProblemEntries" mode="ResolvedProblems"/>
			</Problems>
		</xsl:if>
		
		<!-- Hospital Admission and Discharge Diagnoses -->
		<xsl:if test="$admissionDiagnosisEntries or $dischargeDiagnosisEntries">
			<Diagnoses>
				<xsl:apply-templates select="$admissionDiagnosisEntries" mode="AdmissionDiagnoses"/>
				<xsl:apply-templates select="$dischargeDiagnosisEntries" mode="DischargeDiagnoses"/>
			</Diagnoses>
		</xsl:if>
		
		<!-- Medications, Medications Administered, Discharge Medications, and Immunizations -->
		<xsl:if test="$dischargeMedicationEntries or $immunizationEntries or $medicationEntries or $medicationsAdministeredEntries">
			<Medications>
				<xsl:apply-templates select="$dischargeMedicationEntries[(string-length(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference/@value) or not($dischargeMedicationEntries/hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor))]" mode="DischargeMedications"/>
				<xsl:apply-templates select="$medicationEntries[(string-length(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference/@value) or not($medicationEntries/hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor))]" mode="Medications"/>
				<xsl:apply-templates select="$medicationsAdministeredEntries[(string-length(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference/@value) or not($medicationsAdministeredEntries/hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor))]" mode="MedicationsAdministered"/>
				<xsl:apply-templates select="$immunizationEntries[(string-length(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference/@value) or not($immunizationEntries/hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor))]" mode="Immunizations"/>
			</Medications>
		</xsl:if>

		<!-- Diagnostic Results -->
		<xsl:if test="$resultsC32Entries or $resultsC37Entries">
			<Results>
				<xsl:apply-templates select="$resultsC32Entries[(.//hl7:organizer) and (string-length(.//hl7:procedure/hl7:code/hl7:originalText/hl7:reference/@value) or not(.//hl7:procedure/hl7:code/@nullFlavor))]" mode="Results"/>
				<xsl:apply-templates select="$resultsC37Entries[(.//hl7:organizer) and (string-length(hl7:act/hl7:code/hl7:originalText/hl7:reference/@value) or not(hl7:act/hl7:code/@nullFlavor))]" mode="Results"/>
			</Results>
		</xsl:if>
		
		<!-- Vital Signs -->
		<xsl:if test="$vitalSignEntries">
			<Observations>
				<xsl:apply-templates select="$vitalSignEntries" mode="VitalSigns"/>
			</Observations>
		</xsl:if>
		
		<!-- Plan of Care -->
		<xsl:if test="$planEntries">
			<Plan>
				<Orders>
					<xsl:apply-templates select="$planEntries" mode="PlanOfCare"/>
				</Orders>
			</Plan>
		</xsl:if>
		
		<!-- Procedures and Interventions -->
		<xsl:if test="$procedureEntries">
			<Procedures>
				<xsl:apply-templates select="$procedureEntries" mode="Procedures"/>
			</Procedures>
		</xsl:if>
		
		<!-- Care Considerations -->
		<xsl:if test="$careConsiderationEntries">
			<Documents>
				<xsl:apply-templates select="$careConsiderationEntries" mode="CareConsiderations"/>
			</Documents>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="EncounterType">
		<!-- useFirstTranslation and codeValue are created and used -->
		<!-- to provide for importing a CDA that was exported as a  -->
		<!-- standards compliant CDA.                               -->
		<xsl:variable name="useFirstTranslation">
			<xsl:choose>
				<xsl:when test="hl7:translation[1]/@codeSystem=$noCodeSystemOID">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeValue">
			<xsl:choose>
				<xsl:when test="$useFirstTranslation='0'"><xsl:value-of select="@code"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="hl7:translation[1]/@code"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
				
		<EncounterType>
			<xsl:choose>
				<xsl:when test="$codeValue = 'AMB'">O</xsl:when>
				<xsl:when test="$codeValue = 'IMP'">I</xsl:when>
				<xsl:when test="$codeValue = 'EMER'">E</xsl:when>
				<xsl:otherwise>O</xsl:otherwise>
			</xsl:choose>
		</EncounterType>
	
	</xsl:template>
	
	<xsl:template match="*" mode="EncounterMRN">
		<EncounterMRN><xsl:value-of select="sdtc:id/@extension"/></EncounterMRN>
	</xsl:template>
	
	<xsl:template match="*" mode="EncounterId">
		<xsl:choose>
			<xsl:when test="string-length(hl7:id/@extension)"><xsl:value-of select="hl7:id/@extension"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="hl7:id/@root"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="AdmissionType">
		<xsl:apply-templates select="." mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'AdmissionType'"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
