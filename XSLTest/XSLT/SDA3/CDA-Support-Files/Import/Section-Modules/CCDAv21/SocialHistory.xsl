<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="hl7">

	<xsl:template match="*" mode="sSH-SocialHistorySection">
		<xsl:apply-templates select="key('sectionsByRoot',$ccda-SocialHistorySection)" mode="sSH-SocialHistories"/>
	</xsl:template>
	
	<xsl:template match="hl7:section" mode="sSH-SocialHistories">
		<xsl:variable name="IsNoDataSection">
			<xsl:apply-templates select="." mode="sSH-IsNoDataSection-SocialHistory"/>
		</xsl:variable>
		<xsl:if test="$IsNoDataSection='0' or $documentActionCode='XFRM'">
			<SocialHistories>
				<!-- Process CDA Append/Transform/Replace Directive -->
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'SocialHistory'"/>
				</xsl:call-template>
				<xsl:if test="$IsNoDataSection='0'">
					<xsl:apply-templates select="hl7:entry/hl7:observation[not(hl7:templateId/@root=$ccda-BirthSexObservation)]" mode="eSH-SocialHistory"/>
				</xsl:if>
			</SocialHistories>
		</xsl:if>
	</xsl:template>
	
	<!-- Determine if the Social History section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is the $sectionRootPath for the Social History section.
		Return 1 if the section is present and there is no hl7:entry element.
		Otherwise Return 0 (section is present and appears to include social history data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="sSH-IsNoDataSection-SocialHistory">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<!--
				Birth Sex Observations are represented in the Patient section. 
				There must be entries without birth sex observations.
			-->
			<xsl:when test="count(hl7:entry) &gt; count(hl7:entry[hl7:observation/hl7:templateId/@root=$ccda-BirthSexObservation])">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>