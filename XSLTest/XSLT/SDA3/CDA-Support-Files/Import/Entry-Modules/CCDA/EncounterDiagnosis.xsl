<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 sdtc xsi exsl">

	<xsl:template match="*" mode="EncounterDiagnosis-OverriddenEncounter">
		<!-- Encounters using an <encounter> id -->
		<!--
			$encounterIDTemp is used as an intermediate so that
			$encounterID can be set such that "000nnn" does NOT
			match "nnn" when comparing encounter numbers.
			
			The EncounterId template is in Import/Entry-Modules/CCDA/Encounter.xsl.
			This template assumes that Encounter.xsl is included in the
			current transform.
		-->
		<xsl:variable name="encounterIDTemp"><xsl:apply-templates select="." mode="EncounterId"/></xsl:variable>
		<xsl:variable name="encounterID" select="string($encounterIDTemp)"/>
		
		<Diagnoses>
			<xsl:apply-templates select="hl7:entryRelationship/hl7:act[hl7:templateId/@root=$ccda-EncounterDiagnosis]" mode="Diagnosis">
				<xsl:with-param name="diagnosisType" select="D|Discharge"/>
				<xsl:with-param name="encounterID" select="$encounterID"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="ImportCustom-EncounterDiagnosis"/>
		</Diagnoses>
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.
	
		The input node spec is $sectionRootPath/hl7:entry/hl7:encounter
	-->
	<xsl:template match="*" mode="ImportCustom-EncounterDiagnosis">
	</xsl:template>
</xsl:stylesheet>
