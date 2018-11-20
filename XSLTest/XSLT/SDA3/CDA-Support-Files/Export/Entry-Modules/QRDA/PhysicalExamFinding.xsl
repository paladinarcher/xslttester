<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Observation" mode="physicalExamFinding-Observation-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="physicalExamFinding-Observation-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Physical Exam Finding: <xsl:value-of select="ObservationCode/Description/text()"/></td>
				<td>
					<xsl:choose>
						<xsl:when test="string-length(ObservationCodedValue/Description)">
							<xsl:value-of select="ObservationCodedValue/Description/text()"/>
						</xsl:when>
						<xsl:when test="string-length(ObservationCodedValue/Code)">
							<xsl:value-of select="ObservationCodedValue/Code/text()"/>
						</xsl:when>
						<xsl:when test="string-length(ObservationValue)">
							<xsl:value-of select="ObservationValue/text()"/><xsl:if test="string-length(ObservationCode/ObservationValueUnits/Description)"><xsl:value-of select="concat(' ',ObservationCode/ObservationValueUnits/Description/text())"/></xsl:if>
						</xsl:when>
					</xsl:choose>
				</td>
				<td><xsl:apply-templates select="ObservationTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Observation" mode="physicalExamFinding-Observation-Qualifies">1</xsl:template>
	
	<xsl:template match="PhysicalExam" mode="physicalExamFinding-PhysicalExam-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="physicalExamFinding-PhysicalExam-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Physical Exam Finding: <xsl:value-of select="PhysExamObsValue/Description/text()"/></td>
				<td><xsl:value-of select="PhysExamObsValue/Description/text()"/></td>
				<td><xsl:apply-templates select="PhysExamTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="PhysicalExam" mode="physicalExamFinding-PhysicalExam-Qualifies">1</xsl:template>
	
	<xsl:template match="Observation" mode="physicalExamFinding-Observation-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="physicalExamFinding-Observation-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Physical Exam Finding </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-ResultObservation}"/>
					<templateId root="{$qrda-PhysicalExamFinding}"/>
					
					<xsl:apply-templates select="." mode="id-results-Atomic"/>
					
					<xsl:apply-templates select="ObservationCode" mode="generic-Coded">
						<xsl:with-param name="narrativeLink" select="''"/>
					</xsl:apply-templates>
										
					<xsl:variable name="observationValueString">
						<xsl:choose>
							<xsl:when test="string-length(ObservationCodedValue/Description)">
								<xsl:value-of select="ObservationCodedValue/Description/text()"/>
							</xsl:when>
							<xsl:when test="string-length(ObservationCodedValue/Code)">
								<xsl:value-of select="ObservationCodedValue/Code/text()"/>
							</xsl:when>
							<xsl:when test="string-length(ObservationValue)">
								<xsl:value-of select="ObservationValue/text()"/><xsl:if test="string-length(ObservationCode/ObservationValueUnits/Description)"><xsl:value-of select="concat(' ',ObservationCode/ObservationValueUnits/Description/text())"/></xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<text>Physical Exam Finding: <xsl:value-of select="concat(ObservationCode/Description/text(),' ',$observationValueString)"/></text>
					
					<statusCode code="completed"/>
					
					<effectiveTime>
						<xsl:choose>
							<xsl:when test="string-length(ObservationTime)">
								<low><xsl:attribute name="value"><xsl:apply-templates select="ObservationTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
								<high><xsl:attribute name="value"><xsl:apply-templates select="ObservationTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
							</xsl:when>
							<xsl:otherwise>
								<low nullFlavor="UNK"/>
								<high nullFlavor="UNK"/>
							</xsl:otherwise>
						</xsl:choose>
					</effectiveTime>
					
					<xsl:choose>
						<xsl:when test="string-length(ObservationValue)">
							<xsl:apply-templates select="." mode="observation-value"/>
						</xsl:when>
						<xsl:when test="string-length(ObservationCodedValue)">
							<xsl:apply-templates select="ObservationCodedValue" mode="generic-Coded">
								<xsl:with-param name="narrativeLink" select="''"/>
								<xsl:with-param name="xsiType">CD</xsl:with-param>
								<xsl:with-param name="cdaElementName">value</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="PhysicalExam" mode="physicalExamFinding-PhysicalExam-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="physicalExamFinding-PhysicalExam-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Physical Exam Finding </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-ResultObservation}"/>
					<templateId root="{$qrda-PhysicalExamFinding}"/>
					
					<xsl:apply-templates select="." mode="id-results-Atomic"/>
					
					<code code="404684003" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="finding"/>
					
					<text>Physical Exam Finding: <xsl:value-of select="PhysExamObsValue/Description/text()"/></text>
					
					<statusCode code="completed"/>
					
					<effectiveTime>
						<xsl:choose>
							<xsl:when test="string-length(PhysExamTime)">
								<low><xsl:attribute name="value"><xsl:apply-templates select="PhysExamTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
								<high><xsl:attribute name="value"><xsl:apply-templates select="PhysExamTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
							</xsl:when>
							<xsl:otherwise>
								<low nullFlavor="UNK"/>
								<high nullFlavor="UNK"/>
							</xsl:otherwise>
						</xsl:choose>
					</effectiveTime>
					
					<xsl:choose>
						<xsl:when test="number(PhysExamObsValue/Description)">
							<value xsi:type="ST"><xsl:value-of select="PhysExamObsValue/Description/text()"/></value>
						</xsl:when>
						<xsl:when test="number(PhysExamObsValue/Code)">
							<value xsi:type="ST"><xsl:value-of select="PhysExamObsValue/Code/text()"/></value>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="PhysExamObsValue" mode="generic-Coded">
								<xsl:with-param name="narrativeLink" select="''"/>
								<xsl:with-param name="xsiType">CD</xsl:with-param>
								<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$snomedOID"/></xsl:with-param>
								<xsl:with-param name="cdaElementName">value</xsl:with-param>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
