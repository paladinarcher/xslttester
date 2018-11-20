<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="AdvanceDirective">
		<xsl:variable name="isOtherDirective"><xsl:value-of select="contains('|71388002|AD||', concat('|', hl7:code/@code, '|')) or hl7:code/@nullFlavor"/></xsl:variable>
		
		<Alert>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>

			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>

			<!-- From and To Time -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="ToTime"/>
			
			<!-- Alert Type -->
			<xsl:apply-templates select="." mode="AlertType"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert -->
			<xsl:apply-templates select="." mode="Alert"><xsl:with-param name="isOtherDirective" select="$isOtherDirective"/></xsl:apply-templates>
			
			<!-- Alert Status -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="AlertStatus"/>
			
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Alert>
	</xsl:template>
	
	<xsl:template match="*" mode="Alert">
		<xsl:param name="isOtherDirective"/>
		
		<xsl:variable name="otherDirectiveText"><xsl:if test="$isOtherDirective = 'true'"><xsl:apply-templates select="hl7:code/hl7:originalText" mode="TextValue"/></xsl:if></xsl:variable>
		<Alert>
			<Code>
				<xsl:choose>
					<xsl:when test="string-length($otherDirectiveText)"><xsl:value-of select="$otherDirectiveText"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Y</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</Code>
			<Description>
				<xsl:choose>
					<xsl:when test="string-length($otherDirectiveText)"><xsl:value-of select="$otherDirectiveText"/></xsl:when>
					<xsl:when test="not(hl7:value/@value)">Yes</xsl:when>
					<xsl:when test="hl7:value/@value = 'true'">Yes</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</Description>
		</Alert>		
	</xsl:template>

	<xsl:template match="*" mode="AlertType">
		<xsl:param name="isOtherDirective"/>
		
		<xsl:choose>
			<xsl:when test="$isOtherDirective = 'true'">
				<AlertType>
					<SDACodingStandard><xsl:value-of select="isc:evaluate('getCodeForOID', '2.16.840.1.113883.6.96', 'CodeSystem')"/></SDACodingStandard>
					<Code>71388002</Code>
					<Description>Other Directive</Description>
				</AlertType>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:code" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'AlertType'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="*" mode="AlertStatus">
		<Status>
			<xsl:choose>
				<xsl:when test="contains('|425392003|310305009|425396000|425397009|425393008|425395001|425394002|', concat('|', @code, '|'))">A</xsl:when>
				<xsl:otherwise>I</xsl:otherwise>
			</xsl:choose>
		</Status>
	</xsl:template>
</xsl:stylesheet>
