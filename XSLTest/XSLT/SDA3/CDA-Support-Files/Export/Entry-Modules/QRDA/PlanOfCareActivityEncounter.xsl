<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Encounter" mode="encounterOrder-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
			<tr>
				<td>Encounter Order: <xsl:value-of select="$encounterType"/></td>
				<td><xsl:value-of select="$encounterType"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterOrder-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterOrder-Qualifies">1</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterRecommended-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterRecommended-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
			<tr>
				<td>Encounter Order: <xsl:value-of select="$encounterType"/></td>
				<td><xsl:value-of select="$encounterType"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterRecommended-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterRecommended-Qualifies">1</xsl:template>
	
	<xsl:template match="Encounter" mode="encounter-typeDescription">
		<xsl:choose>
			<xsl:when test="string-length(EncounterCodedType/OriginalText)"><xsl:value-of select="EncounterCodedType/OriginalText/text()"/></xsl:when>
			<xsl:when test="string-length(EncounterCodedType/Description)"><xsl:value-of select="EncounterCodedType/Description/text()"/></xsl:when>
			<xsl:when test="string-length(EncounterCodedType/Code)"><xsl:value-of select="EncounterCodedType/Code/text()"/></xsl:when>
			<xsl:when test="EncounterType/text() = 'E'">Emergency</xsl:when>
			<xsl:when test="EncounterType/text() = 'G'">Generated</xsl:when>
			<xsl:when test="EncounterType/text() = 'I'">Inpatient</xsl:when>
			<xsl:when test="EncounterType/text() = 'N'">Neo-natal</xsl:when>
			<xsl:when test="EncounterType/text() = 'O'">Outpatient</xsl:when>
			<xsl:when test="EncounterType/text() = 'S'">Silent</xsl:when>
			<xsl:otherwise>Unknown</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="encounterOrder-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Encounter Order </xsl:comment>
			<entry>
				<encounter classCode="ENC" moodCode="RQO">
					<templateId root="{$ccda-PlanOfCareActivityEncounter}"/>
					<templateId root="{$qrda-EncounterOrder}"/>
					
					<xsl:apply-templates select="." mode="id-External"/>
					
					<xsl:apply-templates select="." mode="id-Encounter"/>
					
					<xsl:apply-templates select="." mode="encounter-type-select">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
					
					<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
					<text>Encounter Order: <xsl:value-of select="$encounterType"/></text>
					
					<statusCode code="new"/>
					
					<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
				</encounter>
			</entry>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterOrder-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="encounterRecommended-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterRecommended-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Encounter Recommended </xsl:comment>
			<entry>
				<encounter classCode="ENC" moodCode="RQO">
					<templateId root="{$ccda-PlanOfCareActivityEncounter}"/>
					<templateId root="{$qrda-EncounterRecommended}"/>

					<xsl:apply-templates select="." mode="id-External"/>
					
					<xsl:apply-templates select="." mode="id-Encounter"/>
					
					<xsl:apply-templates select="." mode="encounter-type-select">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
					
					<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
					<text>Encounter Order: <xsl:value-of select="$encounterType"/></text>
					
					<statusCode code="new"/>
					
					<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
				</encounter>
			</entry>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterRecommended-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<!-- <xsl:template match="Encounter" mode="encounter-type-select"> See Encounter.xsl -->
	
	<!-- <xsl:template match="EncounterCodedType" mode="encounter-type-coded"> See Encounter.xsl -->
	
	<!-- <xsl:template match="Encounter" mode="encounter-type"> See Encounter.xsl -->
	
	<!-- <xsl:template match="HealthCareFacility" mode="encounter-FacilityLocation"> See Encounter.xsl -->

</xsl:stylesheet>
