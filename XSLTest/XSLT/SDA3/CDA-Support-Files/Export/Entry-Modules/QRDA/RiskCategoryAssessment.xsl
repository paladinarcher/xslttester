<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="CustomObject" mode="riskCategoryAssessment-Narrative">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="riskCategoryAssessment-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="AssessmentScale" mode="getValueSetStringCustomPairs"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<tr>
				<td>Risk Category Assessment<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if>: <xsl:value-of select="CustomPairs/NVPair[Name='AssessmentScaleDescription']/Value/text()"/></td>
				<td><xsl:value-of select="CustomPairs/NVPair[Name='AssessmentScaleDescription']/Value/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
			
			<!--
				If the coded assessment is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="riskCategoryAssessment-Narrative">
					<xsl:with-param name="valueSetStringIn" select="substring-after($valueSetString,'|')"/>
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="riskCategoryAssessment-Qualifies">1</xsl:template>
	
	<xsl:template match="CustomObject" mode="riskCategoryAssessment-Entry">
		<xsl:param name="valueSetStringIn"/>
		
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="riskCategoryAssessment-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
		
			<xsl:variable name="valueSetString">
				<xsl:choose>
					<xsl:when test="$valueSetStringIn"><xsl:value-of select="$valueSetStringIn"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="AssessmentScale" mode="getValueSetStringCustomPairs"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valueSetOID" select="substring-before($valueSetString,'|')"/>
			
			<xsl:comment> QRDA Risk Category Assessment<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if><xsl:value-of select="' '"/></xsl:comment>
			<entry>
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-AssessmentScaleObservation}"/>
					<templateId root="{$qrda-RiskCategoryAssessment}"/>
					
					<id nullFlavor="UNK"/>
					
					<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
						<xsl:with-param name="narrativeLink" select="''"/>
						<xsl:with-param name="hsCustomPairElementName">AssessmentScale</xsl:with-param>
						<xsl:with-param name="valueSetOIDIn"><xsl:value-of select="$valueSetOID"/></xsl:with-param>
					</xsl:apply-templates>
					
					<xsl:if test="string-length(CustomPairs/NVPair[Name='DerivationExpression']/Value/text())"><derivationExpr><xsl:value-of select="CustomPairs/NVPair[Name='DerivationExpression']/Value/text()"/></derivationExpr></xsl:if>
					
					<text>Risk Category Assessment<xsl:if test="CustomPairs/NVPair[Name='NotDone']/Value/text()='1'">, Not Done </xsl:if>: <xsl:value-of select="CustomPairs/NVPair[Name='AssessmentScaleDescription']/Value/text()"/></text>
					
					<statusCode code="completed"/>
					
					<xsl:apply-templates select="FromTime" mode="effectiveTime-FromTo"/>
					
					<xsl:choose>
						<xsl:when test="number(CustomPairs/NVPair[Name='ObservationValue']/Value/text()) and not(contains(CustomPairs/NVPair[Name='ObservationValue']/Value/text(),'.'))">
							<value xsi:type="INT" value="{CustomPairs/NVPair[Name='ObservationValue']/Value/text()}"/>
						</xsl:when>
						<xsl:when test="number(CustomPairs/NVPair[Name='ObservationValue']/Value/text())">
							<value xsi:type="ST"><xsl:value-of select="CustomPairs/NVPair[Name='ObservationValue']/Value/text()"/></value>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
								<xsl:with-param name="narrativeLink" select="''"/>
								<xsl:with-param name="xsiType">CD</xsl:with-param>
								<xsl:with-param name="hsCustomPairElementName">ObservationValueCoded</xsl:with-param>
								<xsl:with-param name="cdaElementName">value</xsl:with-param>
								<xsl:with-param name="valueSetOIDIn"><xsl:value-of select="$valueSetOID"/></xsl:with-param>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</observation>
			</entry>
			
			<!--
				If the coded assessment is included in multiple value sets then
				recursively call this template until an entry for each value
				set is exported.
			-->
			<xsl:if test="string-length(substring-after($valueSetString,'|'))">
				<xsl:apply-templates select="." mode="riskCategoryAssessment-Entry">
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
					TODO: time is an addition to the code taken from encounter-location.
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
