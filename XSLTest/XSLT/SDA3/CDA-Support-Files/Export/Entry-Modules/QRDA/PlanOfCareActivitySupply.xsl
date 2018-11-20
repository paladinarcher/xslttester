<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="CustomObject" mode="deviceOrder-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="deviceOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Device Order: <xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="deviceOrder-Qualifies">1</xsl:template>
	
	<xsl:template match="CustomObject" mode="deviceOrder-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="deviceOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Device Order </xsl:comment>
			<entry typeCode="DRIV">
				<supply classCode="SPLY" moodCode="RQO">
					<templateId root="{$ccda-PlanOfCareActivitySupply}"/>
					<templateId root="{$qrda-DeviceOrder}"/>
					<xsl:apply-templates select="." mode="device-Supply"/>
				</supply>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="deviceRecommended-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="deviceRecommended-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Device Recommended: <xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="deviceRecommended-Qualifies">1</xsl:template>
	
	<xsl:template match="CustomObject" mode="deviceRecommended-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="deviceRecommended-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Device Recommended </xsl:comment>
			<entry typeCode="DRIV">
				<supply classCode="SPLY" moodCode="INT">
					<templateId root="{$ccda-PlanOfCareActivitySupply}"/>
					<templateId root="{$qrda-DeviceRecommended}"/>
					<xsl:apply-templates select="." mode="device-Supply"/>
				</supply>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="device-Supply">
		<xsl:apply-templates select="." mode="id-External"/>
		
		<text>Device Order: <xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></text>
		
		<statusCode code="new"/>
				
		<xsl:choose>
			<xsl:when test="string-length(FromTime)">
				<effectiveTime>
					<xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
				</effectiveTime>
			</xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>

		<!-- Device -->
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='DeviceCode']]" mode="participant-Device"/>
		
		<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
	</xsl:template>
</xsl:stylesheet>
