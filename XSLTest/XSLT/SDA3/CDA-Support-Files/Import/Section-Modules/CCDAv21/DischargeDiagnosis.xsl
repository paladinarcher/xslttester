<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">
	<!-- AlsoInclude: Condition.xsl -->
	
	<xsl:template match="*" mode="sDD-DischargeDiagnosesSection">
		<xsl:apply-templates select="key('sectionsByRoot',$ccda-HospitalDischargeDiagnosisSection)" mode="sDD-DischargeDiagnosesSectionEntries"/>
	</xsl:template>
	
	<xsl:template match="hl7:section" mode="sDD-DischargeDiagnosesSectionEntries">
		<xsl:variable name="isNoDataSection"><xsl:apply-templates select="." mode="sDD-IsNoDataSection-DischargeDiagnosis"/></xsl:variable>
		<xsl:variable name="sectionEntries" select="hl7:entry[(not(string-length(.//hl7:encounter/hl7:id/@extension)) and not(string-length(.//hl7:encounter/hl7:id/@root))) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@extension,'|')) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@root,'|'))]"/>
		
		<xsl:choose>
			<xsl:when test="$sectionEntries and $isNoDataSection = '0'">
				<Diagnoses>
					<xsl:apply-templates select="$sectionEntries" mode="sDD-DischargeDiagnoses"/>
				</Diagnoses>
			</xsl:when>
			<xsl:when test="$isNoDataSection = '1' and $documentActionCode = 'XFRM'">
				<Diagnoses>
					<xsl:apply-templates select="." mode="fn-XFRMAllEncounters">
						<xsl:with-param name="informationType" select="'Diagnosis'"/>
						<xsl:with-param name="actionScope" select="'DISCHARGE'"/>
					</xsl:apply-templates>
				</Diagnoses>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="hl7:entry" mode="sDD-DischargeDiagnoses">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'Diagnosis'"/>
			<xsl:with-param name="actionScope" select="'DISCHARGE'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:apply-templates select="hl7:act" mode="eCn-Diagnosis">
			<xsl:with-param name="diagnosisType" select="'D|Discharge'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Determine if the Discharge Diagnosis section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is $dischargeDiagnosisSection.
		Return 1 if the section is present and there is no hl7:entry element.
		Otherwise Return 0 (section is present and appears to include discharge diagnosis data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="sDD-IsNoDataSection-DischargeDiagnosis">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>