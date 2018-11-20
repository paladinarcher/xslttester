<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Medication" mode="medicationOrder-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Medication Order<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if>: <xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded medication is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="medicationOrder-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medicationOrder-Qualifies">1</xsl:template>
	
	<xsl:template match="Medication" mode="medicationOrder-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationOrder-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Medication Order<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry>
				<substanceAdministration classCode="SBADM" moodCode="RQO">
					<templateId root="{$ccda-PlanOfCareActivitySubstanceAdministration}"/>
					<templateId root="{$qrda-MedicationOrder}"/>
					
					<xsl:apply-templates select="." mode="id-Medication"/>

					<code nullFlavor="NA"/>
					<text>Medication Order: <xsl:value-of select="OrderItem/Description/text()"/></text>
					<statusCode code="new"/>
					
					<xsl:apply-templates select="." mode="medication-duration"/>
					<xsl:apply-templates select="Frequency" mode="medication-frequency"/>
					<xsl:apply-templates select="Route" mode="code-route"/>
					<xsl:apply-templates select="." mode="medication-doseQuantity"/>
					<xsl:apply-templates select="." mode="medication-rateAmount"/>
					<xsl:apply-templates select="OrderItem" mode="medication-consumable"/>
					
					<xsl:apply-templates select="Status" mode="observation-MedicationOrderStatus"/>
					<xsl:apply-templates select="." mode="medication-indication"/>
					
					<!-- Indicate supply both as ordered item and as filled drug product (if available) -->
					<xsl:apply-templates select="OrderItem" mode="medication-supplyOrder"/>
					<xsl:apply-templates select="DrugProduct" mode="medication-supplyFill"/>
					
					<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
				</substanceAdministration>
			</entry>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="medicationOrder-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="HealthCareFacility" mode="encounter-FacilityLocation">
		<xsl:if test="string-length(Code/text()) or string-length(Organization/Code/text())">
			<xsl:comment> QRDA Encounter Facility Location </xsl:comment>
			<participant typeCode="LOC">
				<!--
					QRDA: time is an addition to the code taken from encounter-location.
					It is meant to indicate the Facility Location arrival time
					and departure time.  Right now we are only using the encounter
					FromTime and ToTime for this.
				-->
				<xsl:apply-templates select="." mode="time"/>
				
				<participantRole classCode="SDLOC">
					<templateId root="{$qrda-FacilityLocation}"/>
					
					<xsl:apply-templates select="." mode="id-encounterLocation"/>
					
					<xsl:variable name="locationTypeCode">
						<xsl:choose>
							<xsl:when test="LocationType/text()='ER'">1108-0</xsl:when>
							<xsl:when test="LocationType/text()='CLINIC'">1160-1</xsl:when>
							<xsl:when test="LocationType/text()='DEPARTMENT'">1010-8</xsl:when>
							<xsl:when test="LocationType/text()='WARD'">1160-1</xsl:when>
							<xsl:when test="LocationType/text()='OTHER'">1117-1</xsl:when>
							<xsl:when test="../EncounterType/text()='E'">1108-0</xsl:when>
							<xsl:when test="../EncounterType/text()='I'">1160-1</xsl:when>
							<xsl:when test="../EncounterType/text()='O'">1160-1</xsl:when>
							<xsl:when test="../EncounterType/text()='P'">1108-0</xsl:when>
							<xsl:otherwise>1117-1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="locationTypeDesc">
						<xsl:choose>
							<xsl:when test="$locationTypeCode='1108-0'">Emergency Room</xsl:when>
							<xsl:when test="$locationTypeCode='1160-1'">Urgent Care Center</xsl:when>
							<xsl:when test="$locationTypeCode='1117-1'">Family Medicine Clinic</xsl:when>
							<xsl:when test="$locationTypeCode='1010-8'">General Laboratory</xsl:when>
							<xsl:otherwise>Urgent Care Center</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<code code="{$locationTypeCode}" codeSystem="{$healthcareServiceLocationOID}" codeSystemName="{$healthcareServiceLocationName}" displayName="{$locationTypeDesc}"/>
					<playingEntity classCode="PLC">
						<name>
							<xsl:choose>
								<xsl:when test="string-length(Organization/Description/text())">
									<xsl:value-of select="Organization/Description/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Organization/Code/text())">
									<xsl:value-of select="Organization/Code/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Description/text())">
									<xsl:value-of select="Description/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Code/text())">
									<xsl:value-of select="Code/text()"/>
								</xsl:when>
							</xsl:choose>
						</name>
					</playingEntity>
				</participantRole>
			</participant>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
