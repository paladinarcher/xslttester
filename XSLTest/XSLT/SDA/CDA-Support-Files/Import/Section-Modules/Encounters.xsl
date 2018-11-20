<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Encounters">
		<xsl:variable name="hasSilentEncounters">
			<xsl:choose>
				<xsl:when test="$activeProblemSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$resolvedProblemSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$admissionDiagnosisSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$dischargeDiagnosisSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$dischargeMedicationSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$medicationSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$medicationsAdministeredSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$resultsC32Section/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$resultsC37Section/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$vitalSignSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$payerSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$planSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$procedureSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:when test="$careConsiderationSection/hl7:entry[not(.//hl7:encounter)]">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<Encounters>
			<!-- Entries using default encounter -->
			<xsl:if test="hl7:componentOf/hl7:encompassingEncounter"><xsl:apply-templates select="hl7:componentOf/hl7:encompassingEncounter" mode="DefaultEncounter"/></xsl:if>
			
			<!-- Entries using silent encounter -->
			<xsl:if test="not(hl7:componentOf/hl7:encompassingEncounter) and ($hasSilentEncounters = 1)"><xsl:apply-templates select="." mode="SilentEncounter"/></xsl:if>

			<!-- Entries using overridden encounter-->
			<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$encountersSectionTemplateId]/hl7:entry/hl7:encounter" mode="OverriddenEncounter"/>
		</Encounters>
	</xsl:template>
</xsl:stylesheet>