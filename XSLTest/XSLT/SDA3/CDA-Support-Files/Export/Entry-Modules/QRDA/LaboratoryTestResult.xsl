<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Result" mode="laboratoryTestResults-Narrative">
		<xsl:apply-templates select="ResultItems/LabResultItem[string-length(ResultValue/text())>0]" mode="laboratoryTestResult-Narrative"/>
	</xsl:template>
	
	<xsl:template match="LabResultItem" mode="laboratoryTestResult-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="laboratoryTestResult-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Laboratory Test Result: <xsl:value-of select="TestItemCode/Description/text()"/></td>
				<td><xsl:value-of select="ResultValue"/></td>
				<td><xsl:apply-templates select="../../ResultTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="LabResultItem" mode="laboratoryTestResult-Qualifies">1</xsl:template>
	
	<xsl:template match="Result" mode="laboratoryTestResults-Entry">
		<xsl:apply-templates select="ResultItems/LabResultItem[string-length(ResultValue/text())>0]" mode="laboratoryTestResult-Entry"/>
	</xsl:template>
	
	<xsl:template match="LabResultItem" mode="laboratoryTestResult-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="laboratoryTestResult-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Laboratory Test Result </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-ResultObservation}"/>
					<templateId root="{$qrda-LaboratoryTestResult}"/>
					
					<xsl:apply-templates select="." mode="id-results-Atomic"/>
					
					<xsl:apply-templates select="TestItemCode" mode="generic-Coded">
						<xsl:with-param name="requiredCodeSystemOID" select="$loincOID"/>
					</xsl:apply-templates>
					
					<text>Laboratory Test Result: <xsl:value-of select="TestItemCode/Description/text()"/></text>
					
					<!-- <statusCode> -->
					<xsl:apply-templates select="." mode="observation-TestItemStatusCode"/>
					
					<xsl:apply-templates select="parent::node()/parent::node()" mode="effectiveTime-Result"/>
					
					<xsl:choose>
						<xsl:when test="TestItemCode/IsNumeric/text() = 'true'"><xsl:apply-templates select="ResultValue" mode="value-PQ"><xsl:with-param name="units" select="translate(ResultValueUnits, ' ', '_')"/></xsl:apply-templates></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="ResultValue" mode="value-ST"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="ResultInterpretation" mode="results-Interpretation"/>
					<xsl:apply-templates select="TestItemStatus" mode="observation-TestItemStatus"/>
									
					<xsl:apply-templates select="ResultNormalRange" mode="results-ReferenceRange"/>
										
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
