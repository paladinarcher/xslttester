<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">

	<xsl:template match="*" mode="AdvanceDirectivesSection">
		<xsl:apply-templates select="$sectionRootPath[(hl7:templateId/@root=$ccda-AdvanceDirectivesSectionEntriesOptional or hl7:templateId/@root=$ccda-AdvanceDirectivesSectionEntriesRequired)]" mode="AdvanceDirectives"/>
	</xsl:template>
	
	<xsl:template match="*" mode="AdvanceDirectives">
		<xsl:variable name="IsNoDataSection">
			<xsl:apply-templates select="." mode="IsNoDataSection-AdvanceDirectives"/>
		</xsl:variable>
		
		<xsl:if test="$IsNoDataSection='0' or $documentActionCode='XFRM'">
			<AdvanceDirectives>
				<!-- Process CDA Append/Transform/Replace Directive -->
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'AdvanceDirective'"/>
				</xsl:call-template>
				
				<xsl:apply-templates select="hl7:entry[$IsNoDataSection='0']/hl7:observation" mode="AdvanceDirective"/>
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
	<xsl:template match="*" mode="IsNoDataSection-AdvanceDirectives">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
