<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<!--
		ProcedureObservation.xsl includes templates for exporting QRDA
		entries that conform to Procedure Activity Observation.
		
		Input is currently RadOrder but it is possible that we
		would want to also pass in OtherOrder in the future.
	-->
	<xsl:template match="*" mode="procedureObservation-DiagnosticStudyPerformed-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureObservation-DiagnosticStudyPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Diagnostic Study Performed<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if>: <xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="procedureObservation-DiagnosticStudyPerformed-Qualifies">1</xsl:template>
	
	<!--
		Input is currently RadOrder but it is possible that we
		would want to also pass in OtherOrder in the future.
	-->
	<xsl:template match="*" mode="procedureObservation-DiagnosticStudyPerformed-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureObservation-DiagnosticStudyPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Diagnostic Study Performed <xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'"><xsl:attribute name="negationInd">true</xsl:attribute></xsl:if>
					<templateId root="{$ccda-ProcedureActivityObservation}"/>
					<templateId root="{$qrda-DiagnosticStudyPerformed}"/>
					<xsl:apply-templates select="." mode="procedureObservation-Entry"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureObservation-InterventionPerformed-EntryRelationship">
		<xsl:comment> QRDA Intervention Performed </xsl:comment>
		<entryRelationship typeCode="CAUS" inversionInd="true">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="{$ccda-ProcedureActivityAct}"/>
				<templateId root="{$qrda-InterventionPerformed}"/>
				<xsl:apply-templates select="." mode="procedureObservation-Entry"/>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureObservation-InterventionPerformed-Entry">
		<xsl:apply-templates select="." mode="id-External"/>
		
		<xsl:apply-templates select="Procedure" mode="generic-Coded"/>
		
		<statusCode code="completed"/>
		
		<value xsi:type="CD" nullFlavor="UNK"/>
		
		<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
		
		<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
	</xsl:template>
	
	<xsl:template match="*" mode="procedureObservation-Entry">
	
		<xsl:apply-templates select="." mode="id-External"/>
		
		<xsl:apply-templates select="Result" mode="generic-Coded"/>
		
		<statusCode code="completed"/>
		
		<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
		
		<value xsi:type="CD" nullFlavor="UNK"/>
		
		<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
	</xsl:template>
</xsl:stylesheet>
