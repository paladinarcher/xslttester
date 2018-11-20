<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="AssessmentsSection">
		<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$ccda-AssessmentSection]" mode="Assessments"/>
	</xsl:template>
	
	<xsl:template match="*" mode="AssessmentsSection">
		<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$ccda-AssessmentSection]" mode="AssessmentsSectionEntries"/>
	</xsl:template>
	
	<xsl:template match="*" mode="AssessmentsSectionEntries">
		<xsl:variable name="isNoDataSection"><xsl:apply-templates select="." mode="IsNoDataSection-Assessments"/></xsl:variable>
		<xsl:variable name="sectionEntries" select="hl7:entry[(not(string-length(.//hl7:encounter/hl7:id/@extension)) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@extension,'|')))]"/>
		
		<xsl:choose>
			<xsl:when test="$sectionEntries and $isNoDataSection='0'">
				<Diagnoses>
					<xsl:apply-templates select="$sectionEntries" mode="Assessments"/>
				</Diagnoses>
			</xsl:when>
			<xsl:when test="$isNoDataSection='1' and $documentActionCode='XFRM'">
				<Diagnoses>
					<xsl:apply-templates select="." mode="XFRMAllEncounters">
						<xsl:with-param name="informationType" select="'Diagnosis'"/>
						<xsl:with-param name="actionScope" select="'DISCHARGE'"/>
					</xsl:apply-templates>
			</Diagnoses>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="Assessments">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'Diagnosis'"/>
			<xsl:with-param name="actionScope" select="'DISCHARGE'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:apply-templates select="hl7:act" mode="Diagnosis">
			<xsl:with-param name="diagnosisType" select="'D|Discharge'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Determine if the Assessment section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is $assessmentSection.
		Return 1 if the section is present and there is no hl7:entry element.
		Otherwise Return 0 (section is present and appears to include assessment data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="*" mode="IsNoDataSection-Assessments">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
