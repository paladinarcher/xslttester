<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Encounter" mode="encounterActive-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterActive-Qualifies"/></xsl:variable>
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
				<td>Encounter Active: <xsl:value-of select="$encounterType"/></td>
				<td><xsl:value-of select="$encounterType"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterActive-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterPerformed-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterPerformed-Qualifies"/></xsl:variable>
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
				<td>Encounter Performed: <xsl:value-of select="$encounterType"/></td>
				<td><xsl:value-of select="$encounterType"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/> - <xsl:apply-templates select="ToTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded encounter type is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="encounterPerformed-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterActive-Qualifies">1</xsl:template>
	
	<xsl:template match="Encounter" mode="encounterPerformed-Qualifies">1</xsl:template>
	
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
	
	<xsl:template match="*" mode="admission-type">
			<xsl:apply-templates select="AdmissionType" mode="generic-Coded">
				<xsl:with-param name="narrativeLink" select="''"/>
				<xsl:with-param name="requiredCodeSystemOID" select="$nubcUB92OID"/>
				<xsl:with-param name="cdaElementName" select="'priorityCode'"/>
			</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="encounterActive-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterActive-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Encounter Active </xsl:comment>
			<entry>
				<encounter classCode="ENC" moodCode="EVN">
					<templateId root="{$ccda-EncounterActivity}"/>
					<templateId root="{$qrda-EncounterActive}"/>
					
					<xsl:apply-templates select="." mode="id-External"/>
					
					<xsl:apply-templates select="." mode="id-Encounter"/>
					
					<xsl:apply-templates select="." mode="encounter-type-select">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
					
					<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
					<text>Encounter Active: <xsl:value-of select="$encounterType"/></text>
					
					<statusCode code="active"/>
					
					<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
					
					<xsl:apply-templates select="." mode="admission-type"/>
					
					<!-- Encounter location -->
					<xsl:apply-templates select="HealthCareFacility" mode="encounter-location"/>
					
					<xsl:apply-templates select="HealthCareFacility" mode="encounter-FacilityLocation"/>
					
					<xsl:apply-templates select="." mode="encounter-diagnoses">
						<xsl:with-param name="encounterPosition" select="position()"/>
						<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
					</xsl:apply-templates>
					
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
				<xsl:apply-templates select="." mode="encounterActive-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="encounterPerformed-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="encounterPerformed-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="EncounterCodedType" mode="getValueSetString"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Encounter Performed </xsl:comment>
			<entry>
				<encounter classCode="ENC" moodCode="EVN">
					<templateId root="{$ccda-EncounterActivity}"/>
					<templateId root="{$qrda-EncounterPerformed}"/>
					
					<xsl:apply-templates select="." mode="id-External"/>
					
					<xsl:apply-templates select="." mode="id-Encounter"/>
					
					<xsl:apply-templates select="." mode="encounter-type-select">
						<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
					</xsl:apply-templates>
					
					<xsl:variable name="encounterType"><xsl:apply-templates select="." mode="encounter-typeDescription"/></xsl:variable>
					<text>Encounter Performed: <xsl:value-of select="$encounterType"/></text>
					
					<statusCode code="completed"/>
					
					<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
					
					<xsl:apply-templates select="." mode="admission-type"/>
					
					<!-- Encounter location -->
					<xsl:apply-templates select="HealthCareFacility" mode="encounter-location"/>
					
					<xsl:apply-templates select="HealthCareFacility" mode="encounter-FacilityLocation"/>
					
					<xsl:apply-templates select="self::node()[string-length(AdmissionSource/Code)>0]" mode="encounter-TransferFrom"/>
					
					<xsl:apply-templates select="self::node()[string-length(DischargeLocation/Code)>0]" mode="encounter-TransferTo"/>
					
					<xsl:apply-templates select="." mode="encounter-diagnoses">
						<xsl:with-param name="encounterPosition" select="position()"/>
						<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
					</xsl:apply-templates>
					
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
				<xsl:apply-templates select="." mode="encounterPerformed-Entry">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<!--
		encounter-type-select determines whether to export CDA
		encounter type using SDA EncounterCodedType or EncounterType.
		This template calls encounter-type-coded or encounter-type,
		based on the available SDA data.
	-->
	<xsl:template match="Encounter" mode="encounter-type-select">
		<xsl:param name="valueSetOID"/>
		
		<xsl:choose>
			<xsl:when test="string-length(EncounterCodedType)">
				<xsl:apply-templates select="EncounterCodedType" mode="encounter-type-coded">
					<xsl:with-param name="valueSetOID" select="$valueSetOID"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="encounter-type"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EncounterCodedType" mode="encounter-type-coded">
		<xsl:param name="valueSetOID"/>
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="''"/>
			<xsl:with-param name="valueSetOIDIn" select="$valueSetOID"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounter-type">
		<xsl:variable name="encounterTypeInformation">
			<EncounterType xmlns="">
				<SDACodingStandard><xsl:value-of select="$cpt4Name"/></SDACodingStandard>
				<Code>
					<xsl:choose>
						<xsl:when test="EncounterType/text() = 'E'">EMER</xsl:when>
						<xsl:when test="EncounterType/text() = 'I'">IMP</xsl:when>
						<xsl:when test="EncounterType/text() = 'O'">AMB</xsl:when>
						<xsl:otherwise>AMB</xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description>
					<xsl:choose>
						<xsl:when test="EncounterType/text() = 'E'">Emergency</xsl:when>
						<xsl:when test="EncounterType/text() = 'I'">Inpatient Encounter</xsl:when>
						<xsl:when test="EncounterType/text() = 'O'">Ambulatory</xsl:when>
						<xsl:otherwise>Ambulatory</xsl:otherwise>
					</xsl:choose>
				</Description>
			</EncounterType>
		</xsl:variable>
		
		<xsl:variable name="encounterType" select="exsl:node-set($encounterTypeInformation)/EncounterType"/>
		
		<xsl:apply-templates select="$encounterType" mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="''"/>
		</xsl:apply-templates>
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
	
	<xsl:template match="Encounter" mode="encounter-TransferFrom">
		<!--
			From the QRDA Implementation Guide:
			Transfer of care refers to the different locations or
			settings a patient is released to, or received from,
			in order to ensure the coordination and continuity of
			healthcare. Transfer from specifies the setting from
			which a patient is received (e.g., home, acute care
			hospital, skilled nursing).
			
			Additional ISC Notes:
			QRDA TransferFrom uses SDA Encounter AdmissionSource
			and FromTime.
		-->
		<xsl:comment> QRDA Encounter Transfer From </xsl:comment>
		
		<participant typeCode="ORG">
			<time>
				<xsl:choose>
					<xsl:when test="string-length(FromTime)">
						<xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</time>
			<participantRole classCode="LOCE">
				<templateId root="{$qrda-TransferFrom}"/>
				<xsl:apply-templates select="AdmissionSource" mode="generic-Coded"/>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="encounter-TransferTo">
		<!--
			From the QRDA Implementation Guide:
			Transfer of care refers to the different locations or
			settings a patient is released to, or received from,
			in order to ensure the coordination and continuity of
			healthcare. "Transfer to" specifies the setting the
			patient is released to (e.g., home, acute care hospital,
			skilled nursing).
			
			Additional ISC Notes:
			QRDA TransferTo uses SDA Encounter DischargeLocation
			and ToTime.
		-->
		<xsl:comment> QRDA Encounter Transfer To </xsl:comment>
		
		<participant typeCode="DST">
			<time>
				<xsl:choose>
					<xsl:when test="string-length(ToTime)">
						<xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</time>
			<participantRole classCode="LOCE">
				<templateId root="{$qrda-TransferTo}"/>
				<xsl:apply-templates select="DischargeLocation" mode="generic-Coded"/>
			</participantRole>
		</participant>
	</xsl:template>
	
	<!-- OVERRIDE encounter-diagnosis to not pass narrativeLink -->
	<xsl:template match="*" mode="encounter-diagnosis">
		<xsl:param name="encounterPosition"/>
				
		<entryRelationship typeCode="SUBJ">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="{$ccda-EncounterDiagnosis}"/>
				<id nullFlavor="UNK"/>
				<code code="29308-4" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Diagnosis"/>
				<statusCode code="active"/>
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<!-- Template observation-Diagnosis is located in Condition.xsl -->
				<xsl:apply-templates select="." mode="observation-Diagnosis">
					<xsl:with-param name="narrativeLinkCategory" select="'encounterDiagnoses'"/>
				</xsl:apply-templates>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<!-- OVERRIDE observation-Diagnosis to not write narrative link -->
	<xsl:template match="*" mode="observation-Diagnosis">
		<xsl:param name="narrativeLinkCategory"/>
		
		<entryRelationship typeCode="SUBJ" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-ProblemObservation}"/>
				
				<id nullFlavor="NI"/>
				
				<!-- Diagnosis Type -->
				<code code="282291009" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Diagnosis"/>
				
				<text/>
				<statusCode code="completed"/>
				
				<!--
					IHE mandates special handling of "aborted" and "completed" states when building <effectiveTime>:
					The <high> element shall be present for concerns in the completed or aborted state, and shall not be present otherwise.
				-->
				<xsl:variable name="snomedStatusCode"><xsl:apply-templates select="Status" mode="snomed-Status-Code"/></xsl:variable>
				<xsl:apply-templates select="." mode="effectiveTime-Identification">
					<xsl:with-param name="includeHighTime" select="not(contains($currentConditionStatusCodes, concat('|', $snomedStatusCode, '|')))"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="Diagnosis" mode="value-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
				</xsl:apply-templates>
				
				<!-- Diagnosis Status -->
				<!--
					Don't export Status for Encounter Diagnoses because it
					requires including a link to a Status value in the narrative,
					and there is no room for another narrative column for Status.
				-->
				<xsl:if test="not($narrativeLinkCategory='encounterDiagnoses')">
					<xsl:apply-templates select="Status" mode="observation-ProblemStatus"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisStatus/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				</xsl:if>
			</observation>
		</entryRelationship>
	</xsl:template>
</xsl:stylesheet>
