<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:variable name="currentDateTime" select="isc:evaluate('timestamp')"/>
	<xsl:variable name="documentDateTime" select="/hl7:ClinicalDocument/hl7:effectiveTime/@value"/>
	<xsl:variable name="documentActionCode" select="/hl7:ClinicalDocument/hl7:relatedDocument/@typeCode"/>
	<xsl:variable name="sdaActionCodesEnabled" select="exsl:node-set($generalImportConfiguration)/sdaActionCodes/enabled/text()"/>
	<xsl:variable name="sdaOverrideExternalId" select="exsl:node-set($generalImportConfiguration)/sdaActionCodes/overrideExternalId/text()"/>

	<xsl:variable name="sectionRootPath" select="/hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section"/>
	<xsl:variable name="nonXMLBodyRootPath" select="/hl7:ClinicalDocument/hl7:component/hl7:nonXMLBody"/>
	<xsl:variable name="defaultAuthorRootPath" select="/hl7:ClinicalDocument/hl7:author"/>
	<xsl:variable name="defaultInformantRootPath" select="/hl7:ClinicalDocument/hl7:informant"/>
	
	<xsl:variable name="narrativeLinkInformation"><xsl:apply-templates select="//*[@ID]" mode="NarrativeLinks"/></xsl:variable>
	<xsl:variable name="narrativeLinks" select="exsl:node-set($narrativeLinkInformation)"/>

	<!-- Section Template IDs -->
	<xsl:variable name="activeProblemsSectionTemplateId" select="exsl:node-set($problemsImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="admissionDiagnosesSectionTemplateId" select="exsl:node-set($admissionDiagnosesImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="advanceDirectivesSectionTemplateId" select="exsl:node-set($advanceDirectivesImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="allergiesSectionTemplateId" select="exsl:node-set($allergiesImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="careConsiderationsSectionTemplateId" select="exsl:node-set($careConsiderationsImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="commentsEntryTemplateId" select="exsl:node-set($commentsImportConfiguration)/entryTemplateId/text()"/>
	<xsl:variable name="dischargeDiagnosesSectionTemplateId" select="exsl:node-set($dischargeDiagnosesImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="dischargeMedicationsSectionTemplateId" select="exsl:node-set($dischargeMedicationsImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="encountersSectionTemplateId" select="exsl:node-set($encountersImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="familyHistorySectionTemplateId" select="exsl:node-set($familyHistoryImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="immunizationsSectionTemplateId" select="exsl:node-set($immunizationsImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="medicationInstructionsEntryTemplateId" select="exsl:node-set($medicationInstructionsImportConfiguration)/entryTemplateId/text()"/>
	<xsl:variable name="medicationsSectionTemplateId" select="exsl:node-set($medicationsImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="medicationsAdministeredSectionTemplateId" select="exsl:node-set($medicationsAdministeredImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="payersSectionTemplateId" select="exsl:node-set($payersImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="payersEntryCoverageTemplateId" select="exsl:node-set($payersImportConfiguration)/entryTemplateId/text()"/>
	<xsl:variable name="planSectionTemplateId" select="exsl:node-set($planImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="presentIllnessSectionTemplateId" select="exsl:node-set($presentIllnessImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="proceduresSectionTemplateId" select="exsl:node-set($proceduresImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="resolvedProblemsSectionTemplateId" select="exsl:node-set($pastIllnessImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="resultsC32SectionTemplateId" select="exsl:node-set($resultsImportConfiguration)/sectionC32TemplateId/text()"/>
	<xsl:variable name="resultsC37SectionTemplateId" select="exsl:node-set($resultsImportConfiguration)/sectionC37TemplateId/text()"/>
	<xsl:variable name="resultOrganizerTemplateId" select="exsl:node-set($resultsImportConfiguration)/resultOrganizerTemplateId/text()"/>
	<xsl:variable name="orderItemDefaultCode" select="exsl:node-set($resultsImportConfiguration)/orderItemDefaultCode/text()"/>
	<xsl:variable name="orderItemDefaultDescription" select="exsl:node-set($resultsImportConfiguration)/orderItemDefaultDescription/text()"/>
	<xsl:variable name="socialHistorySectionTemplateId" select="exsl:node-set($socialHistoryImportConfiguration)/sectionTemplateId/text()"/>
	<xsl:variable name="vitalSignsSectionTemplateId" select="exsl:node-set($vitalSignsImportConfiguration)/sectionTemplateId/text()"/>

	<!-- Encountered Section Paths -->
	<xsl:variable name="activeProblemSection" select="$sectionRootPath[hl7:templateId/@root=$activeProblemsSectionTemplateId]"/>
	<xsl:variable name="resolvedProblemSection" select="$sectionRootPath[hl7:templateId/@root=$resolvedProblemsSectionTemplateId]"/>
	<xsl:variable name="admissionDiagnosisSection" select="$sectionRootPath[hl7:templateId/@root=$admissionDiagnosesSectionTemplateId]"/>
	<xsl:variable name="dischargeDiagnosisSection" select="$sectionRootPath[hl7:templateId/@root=$dischargeDiagnosesSectionTemplateId]"/>
	<xsl:variable name="dischargeMedicationSection" select="$sectionRootPath[hl7:templateId/@root=$dischargeMedicationsSectionTemplateId]"/>
	<xsl:variable name="immunizationSection" select="$sectionRootPath[hl7:templateId/@root=$immunizationsSectionTemplateId]"/>
	<xsl:variable name="medicationSection" select="$sectionRootPath[hl7:templateId/@root=$medicationsSectionTemplateId]"/>
	<xsl:variable name="medicationsAdministeredSection" select="$sectionRootPath[hl7:templateId/@root=$medicationsAdministeredSectionTemplateId]"/>
	<xsl:variable name="resultsC32Section" select="$sectionRootPath[hl7:templateId/@root=$resultsC32SectionTemplateId]"/>
	<xsl:variable name="resultsC37Section" select="$sectionRootPath[hl7:templateId/@root=$resultsC37SectionTemplateId]"/>
	<xsl:variable name="vitalSignSection" select="$sectionRootPath[hl7:templateId/@root=$vitalSignsSectionTemplateId]"/>
	<xsl:variable name="payerSection" select="$sectionRootPath[hl7:templateId/@root=$payersSectionTemplateId]"/>
	<xsl:variable name="planSection" select="$sectionRootPath[hl7:templateId/@root=$planSectionTemplateId]"/>
	<xsl:variable name="procedureSection" select="$sectionRootPath[hl7:templateId/@root=$proceduresSectionTemplateId]"/>
	<xsl:variable name="careConsiderationSection" select="$sectionRootPath[hl7:templateId/@root=$careConsiderationsSectionTemplateId]"/>
	
	<!-- Global variables to hold the code and OID for ISC "no code system" -->
	<xsl:variable name="noCodeSystemName">ISC-NoCodeSystem</xsl:variable>
	<xsl:variable name="noCodeSystemOID" select="isc:evaluate('getOIDForCode', $noCodeSystemName, 'CodeSystem')"/>
</xsl:stylesheet>
