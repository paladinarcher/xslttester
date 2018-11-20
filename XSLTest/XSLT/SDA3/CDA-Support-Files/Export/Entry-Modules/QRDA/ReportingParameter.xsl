<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<!-- Reporting Period Start and End must be YYYYMMDDHHSS, if supplied. Create timestamps. -->
	<xsl:variable name="reportingPeriodStartTimeStamp" select="isc:evaluate('xmltimestamp',$reportingPeriodStart)"/>
	<xsl:variable name="reportingPeriodEndTimeStamp" select="isc:evaluate('xmltimestamp',$reportingPeriodEnd)"/>
	
	<xsl:template match="*" mode="reportingParameters-Narrative">
		<text>
			<list>
				<xsl:if test="string-length($reportingPeriodStart) or string-length($reportingPeriodEnd)">
					<xsl:apply-templates select="." mode="reportingParameters-NarrativeDetail-TimeFrame"/>
				</xsl:if>
			</list>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="reportingParameters-NarrativeDetail-TimeFrame">
		<xsl:variable name="start"><xsl:value-of select="translate($reportingPeriodStartTimeStamp,'TZ',' ')"/></xsl:variable>
		<xsl:variable name="end"><xsl:value-of select="translate($reportingPeriodEndTimeStamp,'TZ',' ')"/></xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($reportingPeriodStart) and string-length($reportingPeriodEnd)">
				<item><xsl:value-of select="concat('Reporting Period: ',$start,' through ',$end)"/></item>
			</xsl:when>
			<xsl:when test="string-length($reportingPeriodStart) and not(string-length($reportingPeriodEnd))">
				<item><xsl:value-of select="concat('Reporting Period: ',$start,' through present')"/></item>
			</xsl:when>
			<xsl:when test="not(string-length($reportingPeriodStart)) and string-length($reportingPeriodEnd)">
				<item><xsl:value-of select="concat('Reporting Period: Up through ',$end)"/></item>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="reportingParameters-Entries">
		<xsl:apply-templates select="." mode="reportingParameters-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="reportingParameters-EntryDetail">
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="{$qrda-ReportingParametersAct}"/>
				
				<id nullFlavor="NI"/>
				
				<code code="252116004" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Observation Parameters"/>
				
				<effectiveTime>
					<xsl:choose>
						<xsl:when test="string-length($reportingPeriodStart)">
							<low value="{translate($reportingPeriodStart, 'TZ:- ', '')}"/>
						</xsl:when>
						<xsl:otherwise><low nullFlavor="NI"/></xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="string-length($reportingPeriodEnd)">
							<high value="{translate($reportingPeriodEnd, 'TZ:- ', '')}"/>
						</xsl:when>
						<xsl:otherwise><high nullFlavor="NI"/></xsl:otherwise>
					</xsl:choose>
				</effectiveTime>
			</act>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="reportingParameters-NoData">
		<text><xsl:value-of select="$exportConfiguration/reportingParameters/emptySection/narrativeText/text()"/></text>
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="{$qrda-ReportingParametersAct}"/>
				
				<code code="252116004" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Observation Parameters"/>
				
				<effectiveTime>
					<low value="NI"/>
					<high value="NI"/>
				</effectiveTime>
			</act>
		</entry>
	</xsl:template>
</xsl:stylesheet>
