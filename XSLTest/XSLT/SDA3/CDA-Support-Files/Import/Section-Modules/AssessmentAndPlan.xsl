<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="AssessmentAndPlanSection">
		<xsl:apply-templates select="$sectionRootPath[hl7:templateId/@root=$assessmentAndPlanSectionTemplateId]" mode="AssessmentAndPlanSectionEntries"/>
	</xsl:template>
	
	<xsl:template match="*" mode="AssessmentAndPlanSectionEntries">
		<xsl:variable name="isNoDataSection"><xsl:apply-templates select="." mode="IsNoDataSection-AssessmentAndPlan"/></xsl:variable>
		<xsl:variable name="sectionEntries" select="hl7:entry"/>
		
		<xsl:choose>
			<xsl:when test="$sectionEntries and $isNoDataSection='0'">
				<Documents>
					<xsl:apply-templates select="$sectionEntries" mode="AssessmentAndPlan"/>
				</Documents>
			</xsl:when>
			<xsl:when test="$isNoDataSection='1' and $documentActionCode='XFRM'">
				<Documents>
					<xsl:apply-templates select="." mode="XFRMAllEncounters">
						<xsl:with-param name="informationType" select="'Documents'"/>
						<xsl:with-param name="actionScope" select="'AssessmentAndPlan'"/>
					</xsl:apply-templates>
			</Documents>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="AssessmentAndPlan">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'Document'"/>
			<xsl:with-param name="actionScope" select="'AssessmentAndPlan'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:apply-templates select="hl7:act" mode="AssessmentAndPlan-EntryDetail"/>
	</xsl:template>
	
	<!-- Determine if the Assessment and Plan section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is the hl7:section for the Assessment and Plan section.
		Otherwise Return 0 (section is present and appears to include assessment and plan data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="IsNoDataSection-AssessmentAndPlan">
		<xsl:choose>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
