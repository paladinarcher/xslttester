<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Problem" mode="diagnosisActive-Problem-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="diagnosisActive-Problem-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:variable name="includeInExport">
				<xsl:apply-templates select="." mode="includeDiagnosisInExport">
					<xsl:with-param name="currentConditions" select="true()"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:if test="($includeInExport = '1')">
			
				<xsl:variable name="valueSetString">
					<xsl:choose>
						<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="Problem" mode="getValueSetString"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
				
				<tr>
					<td>Diagnosis Active: <xsl:value-of select="Problem/Description/text()"/></td>
					<td><xsl:value-of select="Problem/Description/text()"/></td>
					<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
				</tr>
				
				<!--
					If the diagnosis code is included in multiple value sets then
					recursively call this template until an entry for each value
					set is exported.
				-->
				<xsl:if test="string-length(substring-after($valueSetString,'|'))">
					<xsl:apply-templates select="." mode="diagnosisActive-Problem-Narrative">
						<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
					</xsl:apply-templates>
				</xsl:if>
				
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Problem" mode="diagnosisActive-Problem-Qualifies">1</xsl:template>
	
	<xsl:template match="Problem" mode="diagnosisActive-Problem-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="diagnosisActive-Problem-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:variable name="includeInExport">
				<xsl:apply-templates select="." mode="includeDiagnosisInExport">
					<xsl:with-param name="currentConditions" select="true()"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:if test="($includeInExport = '1')">
			
				<xsl:variable name="valueSetString">
					<xsl:choose>
						<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="Problem" mode="getValueSetString"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
				
				<xsl:comment> QRDA Diagnosis Active </xsl:comment>
				<entry typeCode="DRIV">
					<observation classCode="OBS" moodCode="EVN">
						<templateId root="{$ccda-ProblemObservation}"/>
						<templateId root="{$qrda-DiagnosisActive}"/>
						
						<id nullFlavor="NI"/>
						
						<xsl:choose>
							<xsl:when test="Category">
								<xsl:apply-templates select="Category" mode="problem-ProblemType"/>
							</xsl:when>
							<xsl:otherwise><code nullFlavor="UNK"/></xsl:otherwise>
						</xsl:choose>
						
						<text>Diagnosis Active: <xsl:value-of select="Problem/Description/text()"/></text>
						<statusCode code="completed"/>
						
						<!-- QRDA wants high time in there unconditionally. -->
						<xsl:apply-templates select="." mode="effectiveTime-FromTo">
							<xsl:with-param name="includeHighTime" select="true()"/>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="Problem" mode="generic-Coded">
							<xsl:with-param name="narrativeLink" select="''"/>
							<xsl:with-param name="xsiType">CD</xsl:with-param>
							<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$snomedOID"/></xsl:with-param>
							<xsl:with-param name="cdaElementName">value</xsl:with-param>
							<xsl:with-param name="valueSetOIDIn"><xsl:value-of select="$valueSetOID"/></xsl:with-param>
						</xsl:apply-templates>
						
						<!-- Problem Status -->
						<xsl:apply-templates select="." mode="observation-ProblemStatus-Active"/>
						
						<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
						
						<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
						
						<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
						
						<!-- Severity Observation -->
						<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='SeverityCode']]" mode="observation-Severity-CustomPair"/>
					</observation>
				</entry>
				
				<!--
					If the diagnosis code is included in multiple value sets then
					recursively call this template until an entry for each value
					set is exported.
				-->
				<xsl:if test="string-length(substring-after($valueSetString,'|'))">
					<xsl:apply-templates select="." mode="diagnosisActive-Problem-Entry">
						<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
					</xsl:apply-templates>
				</xsl:if>

			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
