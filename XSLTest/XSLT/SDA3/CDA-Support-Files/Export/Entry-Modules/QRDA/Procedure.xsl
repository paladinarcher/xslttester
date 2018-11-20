<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<!--
		Procedure.xsl includes templates for exporting QRDA
		entries that conform to Procedure Activity Procedure.
	-->
	<xsl:template match="Procedure" mode="procedure-DeviceApplied-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedure-DeviceApplied-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Device Applied<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done</xsl:if>: <xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:value-of select="CustomPairs/NVPair[Name='DeviceDescription']/Value/text()"/></td>
				<td><xsl:apply-templates select="ProcedureTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-ProcedurePerformed-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Procedure Performed<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if>: <xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:value-of select="Procedure/Description/text()"/></td>
				<td><xsl:apply-templates select="ProcedureTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-DeviceApplied-Qualifies">1</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-ProcedurePerformed-Qualifies">
		<xsl:choose>
			<xsl:when test="not(string-length(Procedure/Code/text()))">0</xsl:when>
			<xsl:when test="contains($interventionCodes,concat('|',Procedure/Code/text(),'|'))">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-DeviceApplied-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedure-DeviceApplied-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Device Applied<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry typeCode="DRIV">
				<procedure classCode="PROC" moodCode="EVN">
					<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'"><xsl:attribute name="negationInd">true</xsl:attribute></xsl:if>
					<templateId root="{$ccda-ProcedureActivityProcedure}"/>
					<templateId root="{$qrda-DeviceApplied}"/>
					<xsl:apply-templates select="." mode="procedure-Entry">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
				</procedure>
			</entry>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="Procedure" mode="procedure-ProcedurePerformed-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="Procedure" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Procedure Performed<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry typeCode="DRIV">
				<procedure classCode="PROC" moodCode="EVN">
					<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'"><xsl:attribute name="negationInd">true</xsl:attribute></xsl:if>
					<templateId root="{$ccda-ProcedureActivityProcedure}"/>
					<templateId root="{$qrda-ProcedurePerformed}"/>
					<xsl:apply-templates select="." mode="procedure-Entry">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
				</procedure>
			</entry>
			
			<!--
				If the procedure code is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="procedure-ProcedurePerformed-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-ProcedurePerformed-EntryRelationship">
		<xsl:comment> QRDA Procedure Performed </xsl:comment>
		<entryRelationship typeCode="CAUS" inversionInd="true">
			<procedure classCode="PROC" moodCode="EVN">
				<templateId root="{$ccda-ProcedureActivityProcedure}"/>
				<templateId root="{$qrda-ProcedurePerformed}"/>
				<xsl:apply-templates select="." mode="procedure-Entry">
						<xsl:with-param name="valueSetOID" select="''"/>
					</xsl:apply-templates>
			</procedure>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="procedure-Entry">
		<xsl:param name="valueSetOID"/>
		
		<xsl:apply-templates select="." mode="id-External"/>
		
		<xsl:apply-templates select="Procedure" mode="generic-Coded">
			<xsl:with-param name="valueSetOIDIn" select="$valueSetOID"/>
		</xsl:apply-templates>
		
		<statusCode code="completed"/>
		
		<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
		
		<!-- Device Applied -->
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='DeviceCode']]" mode="participant-Device"/>
				
		<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ReasonCode']]" mode="reason"/>
		
		<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='IncisionDateTime']]" mode="procedure-incisionDateTime"/>
	</xsl:template>
</xsl:stylesheet>
