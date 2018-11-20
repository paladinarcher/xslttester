<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">

	<xsl:template match="*" mode="sAD-AdvanceDirectivesSection">
		<xsl:apply-templates select="key('sectionsByRoot',$ccda-AdvanceDirectivesSectionEntriesOptional) | key('sectionsByRoot',$ccda-AdvanceDirectivesSectionEntriesRequired)" mode="sAD-AdvanceDirectives"/>
	</xsl:template>
	
	<xsl:template match="hl7:section" mode="sAD-AdvanceDirectives">
		<xsl:variable name="IsNoDataSection">
			<xsl:apply-templates select="." mode="sAD-IsNoDataSection-AdvanceDirectives"/>
		</xsl:variable>
		
		<xsl:if test="$IsNoDataSection='0' or $documentActionCode='XFRM'">
			<AdvanceDirectives>
				<!-- Process CDA Append/Transform/Replace Directive -->
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'AdvanceDirective'"/>
				</xsl:call-template>
				
				<xsl:if test="$IsNoDataSection='0'">
					<xsl:apply-templates select="hl7:entry/hl7:observation" mode="eAD-AdvanceDirective"/>
				</xsl:if>
			</AdvanceDirectives>
		</xsl:if>
	</xsl:template>
	
	<!-- Determine if the Advance Directives section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is the $sectionRootPath for the Advance Directives section.
		Return 1 if the section is present and there is no hl7:entry element.
		Otherwise Return 0 (section is present and appears to include advance directives data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="sAD-IsNoDataSection-AdvanceDirectives">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>