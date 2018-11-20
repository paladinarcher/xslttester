<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">
	<!-- AlsoInclude: Condition.xsl -->
	
	<xsl:template match="*" mode="sPL-ActiveProblemsSection">
		<xsl:apply-templates select="key('sectionsByRoot',$ccda-ProblemSectionEntriesOptional) | key('sectionsByRoot',$ccda-ProblemSectionEntriesRequired)" mode="sPL-ActiveProblemsSectionEntries"/>
	</xsl:template>
	
	<xsl:template match="hl7:section" mode="sPL-ActiveProblemsSectionEntries">
		<xsl:variable name="isNoDataSection"><xsl:apply-templates select="." mode="sPL-IsNoDataSection-ActiveProblems"/></xsl:variable>
		<xsl:variable name="sectionEntries" select="hl7:entry[(not(string-length(.//hl7:encounter/hl7:id/@extension)) and not(string-length(.//hl7:encounter/hl7:id/@root))) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@extension,'|')) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@root,'|'))]"/>

		<xsl:choose>
			<xsl:when test="$sectionEntries and $isNoDataSection='0'">
				<Problems>
					<xsl:apply-templates select="$sectionEntries" mode="sPL-ActiveProblems"/>
				</Problems>
			</xsl:when>
			<xsl:when test="$isNoDataSection='1' and $documentActionCode='XFRM'">
				<Problems>
					<xsl:apply-templates select="." mode="fn-XFRMAllEncounters">
						<xsl:with-param name="informationType" select="'Problem'"/>
						<xsl:with-param name="actionScope" select="'PRESENT'"/>
					</xsl:apply-templates>
				</Problems>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="hl7:entry" mode="sPL-ActiveProblems">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'Problem'"/>
			<xsl:with-param name="actionScope" select="'PRESENT'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
		
		<xsl:apply-templates select="hl7:act" mode="eCn-Condition"/>
	</xsl:template>
	
	<!-- Determine if the Active Problems (Problem List) section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is $activeProblemSection.
		Return 1 if the section is present and there is no hl7:entry element.
		Return 1 if the section is present and explicitly indicates "No Data" according to HS standard logic.
		Otherwise Return 0 (section is present and appears to include active problems data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="sPL-IsNoDataSection-ActiveProblems">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:when test="count(hl7:entry)=1 and (hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/@negationInd='true')">1</xsl:when>
			<xsl:when test="count(hl7:entry)=1 and (hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@nullFlavor='NI' or hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:value/@nullFlavor='NI')">1</xsl:when>
			<xsl:when test="count(hl7:entry)=1 and (hl7:entry[1]/hl7:act[1]/hl7:id/@nullFlavor='NI' or hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:id/@nullFlavor='NI') and hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@code='ASSERTION' and hl7:entry[1]/hl7:act[1]/hl7:entryRelationship[1]/hl7:observation/hl7:code/@codeSystem='2.16.840.1.113883.5.4'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>