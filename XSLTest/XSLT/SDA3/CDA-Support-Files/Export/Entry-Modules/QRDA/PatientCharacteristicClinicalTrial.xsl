<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<!--
		SDA Input:
		
		CustomObject
		CustomType = 'ClinicalTrial'
		
		CustomPairs
			NVPair/Name ClinicalTrialCodingStandard
			NVPair/Value
			NVPair/Name ClinicalTrialCode
			NVPair/Value
			NVPair/Name ClinicalTrialDescription
			NVPair/Value
			
		Use the existing FromTime and ToTime properties on
		CustomObject for the clinical trial time span.
	-->
	<xsl:template match="CustomObject" mode="patientCharacteristic-ClinicalTrialParticipant-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="patientCharacteristic-ClinicalTrialParticipant-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Patient Characteristic Clinical Trial Participant</td>
				<td><xsl:value-of select="CustomPairs/NVPair[Name='ClinicalTrialDescription']/Value/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="patientCharacteristic-ClinicalTrialParticipant-Qualifies">
		<xsl:choose>
			<!-- If to start after today, then does not qualify. -->
			<xsl:when test="isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) &lt;= 0">0</xsl:when>
			<!-- If has not ended, then qualifies. -->
			<xsl:when test="not(string-length(ToTime/text()))">1</xsl:when>
			<!-- If ended before today, then does not qualify. -->
			<xsl:when test="isc:evaluate('dateDiff', 'dd', translate(ToTime/text(), 'TZ', ' ')) &gt; 0">0</xsl:when>
			<!-- Otherwise it ends today or later, so qualifies. -->
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="patientCharacteristic-ClinicalTrialParticipant-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="patientCharacteristic-ClinicalTrialParticipant-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Patient Characteristic Clinical Trial Participant </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$qrda-PatientCharacteristicClinicalTrialParticipant}"/>

					<id nullFlavor="NI"/>
					
					<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>

					<statusCode code="active"/>
					
					<effectiveTime>
						<low>
							<xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
						</low>
						<high nullFlavor="NA"/>
					</effectiveTime>
					
					<value code="428024001" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Clinical Trial Participant" xsi:type="CD"/>
					
					<xsl:apply-templates select="." mode="reason">
						<xsl:with-param name="hsCustomPairElementName" select="'ClinicalTrial'"/>
					</xsl:apply-templates>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
