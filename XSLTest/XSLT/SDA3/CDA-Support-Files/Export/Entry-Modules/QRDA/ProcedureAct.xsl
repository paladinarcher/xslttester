<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<!--
		ProcedureAct.xsl includes templates for exporting QRDA
		entries that conform to Procedure Activity Act.
	-->
	<xsl:template match="Procedure" mode="procedureAct-InterventionPerformed-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Intervention Performed<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done</xsl:if>: <xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:apply-templates select="ProcedureTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionPerformed-Qualifies">1</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionOrder-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureAct-InterventionOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Intervention Order: <xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:apply-templates select="ProcedureTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionOrder-Qualifies">1</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionPerformed-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Intervention Performed<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done</xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry typeCode="DRIV">
				<act classCode="ACT" moodCode="EVN">
					<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'"><xsl:attribute name="negationInd">true</xsl:attribute></xsl:if>
					<templateId root="{$ccda-ProcedureActivityAct}"/>
					<templateId root="{$qrda-InterventionPerformed}"/>
					<xsl:apply-templates select="." mode="procedureAct-Entry">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
						<xsl:with-param name="procedureType" select="'Intervention Performed'"/>
					</xsl:apply-templates>
				</act>
			</entry>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionOrder-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedureAct-InterventionPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Intervention Order </xsl:comment>
			<entry typeCode="DRIV">
				<act classCode="ACT" moodCode="RQO">
					<templateId root="{$ccda-PlanOfCareActivityAct}"/>
					<templateId root="{$qrda-InterventionOrder}"/>
					<xsl:apply-templates select="." mode="procedureAct-Entry">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
						<xsl:with-param name="procedureType" select="'Intervention Order'"/>
					</xsl:apply-templates>
				</act>
			</entry>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedureAct-InterventionOrder-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-InterventionPerformed-EntryRelationship">
		<xsl:comment> QRDA Intervention Performed </xsl:comment>
		<entryRelationship typeCode="CAUS" inversionInd="true">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="{$ccda-ProcedureActivityAct}"/>
				<templateId root="{$qrda-InterventionPerformed}"/>
				<xsl:apply-templates select="." mode="procedureAct-Entry">
					<xsl:with-param name="valueSetOID" select="''"/>
					<xsl:with-param name="procedureType" select="'Intervention Performed'"/>
				</xsl:apply-templates>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedureAct-Entry">
		<xsl:param name="valueSetOID"/>
		<xsl:param name="procedureType"/>
		
		<xsl:apply-templates select="." mode="id-External"/>
		
		<xsl:apply-templates select="Procedure" mode="generic-Coded">
			<xsl:with-param name="valueSetOIDIn" select="$valueSetOID"/>
		</xsl:apply-templates>
		
		<text><xsl:value-of select="$procedureType"/>: <xsl:value-of select="Procedure/Description/text()"/></text>
		
		<statusCode code="completed"/>
		
		<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
		
		<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
		
		<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
	</xsl:template>
</xsl:stylesheet>
