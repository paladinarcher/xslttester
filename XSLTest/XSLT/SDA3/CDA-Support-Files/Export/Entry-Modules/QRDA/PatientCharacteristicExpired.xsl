<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Container" mode="patientCharacteristic-Expired-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="patientCharacteristic-Expired-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Patient Characteristic Expired</td>
				<td></td>
				<td><xsl:apply-templates select="Patient/DeathTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Container" mode="patientCharacteristic-Expired-Qualifies">1</xsl:template>
	
	<xsl:template match="Container" mode="patientCharacteristic-Expired-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="patientCharacteristic-Expired-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Patient Characteristic Expired </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-DeceasedObservation}"/>
					<templateId root="{$qrda-PatientCharacteristicExpired}"/>

					<id nullFlavor="NI"/>
					
					<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>

					<statusCode code="completed"/>
					
					<effectiveTime>
						<low>
							<xsl:choose>
								<xsl:when test="string-length(Patient/DeathTime)">
									<xsl:attribute name="value"><xsl:apply-templates select="Patient/DeathTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:otherwise>
							</xsl:choose>
						</low>
					</effectiveTime>
					
					<value code="419099009" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Dead" xsi:type="CD"/>
					
					<xsl:apply-templates select="Problems/Problem[CauseOfDeath='Y'][1]" mode="patientCharacteristic-Expired-CauseOfDeath"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Problem" mode="patientCharacteristic-Expired-CauseOfDeath">
		<entryRelationship typeCode="CAUS" negationInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<id nullFlavor="NI"/>
				<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>
				<statusCode code="completed"/>
				<xsl:apply-templates select="Problem" mode="value-Coded">
					<xsl:with-param name="narrativeLink" select="''"/>
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$snomedOID"/></xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
</xsl:stylesheet>
