<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Allergy" mode="medicationAllergy-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationAllergy-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Medication Allergy: <xsl:value-of select="Allergy/Description/text()"/></td>
				<td><xsl:value-of select="Allergy/Description/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Allergy" mode="medicationAllergy-Qualifies">1</xsl:template>
	
	<xsl:template match="Allergy" mode="medicationAllergy-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationAllergy-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Medication Allergy </xsl:comment>
			<entry typeCode="DRIV">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-AllergyIntoleranceObservation}"/>
					<templateId root="{$qrda-MedicationAllergy}"/>
					
					<xsl:apply-templates select="." mode="id-AllergyObservation"/>
					
					<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>
					
					<text>Medication Allergy: <xsl:value-of select="Allergy/Description/text()"/></text>
					
					<statusCode code="completed"/>
					
					<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
					
					<xsl:choose>
						<xsl:when test="AllergyCategory">
							<xsl:apply-templates select="AllergyCategory" mode="allergies-category-code">
								<xsl:with-param name="narrativeLink" select="''"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise><code nullFlavor="NA"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="Allergy" mode="participant-Allergy"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
					
					<xsl:apply-templates select="Reaction" mode="observation-Reaction"/>
					<xsl:apply-templates select="Severity" mode="observation-Severity"/>
					<xsl:apply-templates select="Status" mode="observation-AllergyStatus"/>
				</observation>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="participant-Allergy">
		<xsl:param name="narrativeLinkSuffix" select="''"/>
		
		<participant typeCode="CSM">
			<participantRole classCode="MANU">
				<addr nullFlavor="{$addrNullFlavor}"/>
				<telecom nullFlavor="UNK"/>
				<playingEntity classCode="MMAT">
					<xsl:apply-templates select="." mode="generic-Coded">
						<xsl:with-param name="narrativeLink" select="''"/>
					</xsl:apply-templates>

					<name><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></name>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Reaction">
		<xsl:param name="narrativeLinkSuffix" select="''"/>

		<entryRelationship typeCode="MFST" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-ReactionObservation}"/>
				
				<id nullFlavor="{$idNullFlavor}"/>
				<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>
				
				<text><xsl:value-of select="text()"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="parent::node()" mode="effectiveTime-FromTo"/>
				
				<xsl:apply-templates select="." mode="value-Coded">
					<xsl:with-param name="narrativeLink" select="''"/>
					<xsl:with-param name="xsiType">CD</xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Severity">
		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-SeverityObservation}"/>
				
				<code code="SEV" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}" displayName="Severity observation"/>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="value-Coded">
					<xsl:with-param name="narrativeLink" select="''"/>
					<xsl:with-param name="xsiType">CD</xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-AllergyStatus">
		<entryRelationship typeCode="REFR" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-AllergyStatusObservation}"/>

				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
				<xsl:choose>
					<xsl:when test="contains('A|C', text())"><text>Active</text></xsl:when>
					<xsl:otherwise><text>Inactive</text></xsl:otherwise>
				</xsl:choose>
				<statusCode code="completed"/>
				
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="contains('A|C', text())">55561003</xsl:when>
								<xsl:otherwise>73425007</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="contains('A|C', text())">Active</xsl:when>
								<xsl:otherwise>Inactive</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="value-CE"/>

			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="statusCode-Allergy">
		<statusCode>
			<xsl:attribute name="code">
				<xsl:choose>
					<xsl:when test="contains('A|C', Status/text())">active</xsl:when>
					<xsl:when test="text() = 'I'">aborted</xsl:when>
					<xsl:when test="not(string-length(ToTime/text()))">active</xsl:when>
					<xsl:otherwise>completed</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</statusCode>
		
		<!--
			IHE mandates special handling of "aborted" and "completed" states when building <effectiveTime>:
				The <high> element shall be present for concerns in the completed or aborted state, and shall not be present otherwise.
		-->
		<xsl:apply-templates select="." mode="effectiveTime-FromTo">
			<xsl:with-param name="includeHighTime" select="not(contains('A|C', Status/text()))"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- allergies-category-code is a special case coded entry template for  -->
	<!-- allergy category, which must be a SNOMED allery category if we want -->
	<!-- to be standards compliant. -->
	<xsl:template match="*" mode="allergies-category-code">
		<xsl:param name="narrativeLink" select="''"/>
		<xsl:param name="xsiType" select="'CD'"/>
		
		<xsl:variable name="sdaCodingStandardOID"><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="SDACodingStandard/text()"/></xsl:apply-templates></xsl:variable>
				
		<xsl:variable name="codeSystemOIDForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystemNameForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<!-- If there is Code text, then work with it, otherwise it just gets nullFlavor. -->
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="snomedAllergyCategories">|420134006|418038007|419511003|418471000|419199007|416098002|414285001|59037007|235719002|</xsl:variable>
				<xsl:variable name="isValidSnomedCode" select="contains($snomedAllergyCategories, concat('|', Code/text(), '|'))"/>
				
				<xsl:choose>
				
					<!-- If we got the SNOMED code system and a valid SNOMED code, then export -->
					<!-- the data as is.-->
					<xsl:when test="($sdaCodingStandardOID=$snomedOID) and ($isValidSnomedCode)">
						<value code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}">
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
							<originalText>
								<xsl:choose>
									<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
									<xsl:otherwise><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></xsl:otherwise>
								</xsl:choose>
							</originalText>
							
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>
						</value>
					</xsl:when>
					
					<!-- If we got a valid SNOMED code but didn't get the SNOMED code system, -->
					<!-- then export the data with SNOMED code system plugged in, and also   -->
					<!-- export a <translation> with the data and code system that was      -->
					<!-- actually received. -->
					<xsl:when test="$isValidSnomedCode">
						<value code="{Code/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Description/text()}">
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
							<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
							<translation code="{Code/text()}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>
						</value>
					</xsl:when>

					<!-- Otherwise, it's not a valid SNOMED code, make it into one. -->
					<xsl:otherwise>
						<xsl:variable name="descUpper" select="translate(Description/text(), $lowerCase, $upperCase)"/>
						
						<xsl:variable name="code">
							<xsl:choose>
								<xsl:when test="contains($descUpper, 'DRUG')">416098002</xsl:when>
								<xsl:when test="contains($descUpper, 'FOOD')">414285001</xsl:when>
								<xsl:otherwise>419199007</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="description">
							<xsl:choose>
								<xsl:when test="string-length(Description)"><xsl:value-of select="Description"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$code"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<value code="{$code}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{$description}">
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
							<originalText>
								<xsl:choose>
									<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
									<xsl:otherwise><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></xsl:otherwise>
								</xsl:choose>
							</originalText>
							
							<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{$description}"/>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>
						</value>
					</xsl:otherwise>
					
				</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<value nullFlavor="NA"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Allergy" mode="id-AllergyProblem">
		<xsl:apply-templates select="." mode="id-External"/>
	</xsl:template>
	
	<xsl:template match="Allergy" mode="id-AllergyObservation">
		<xsl:choose>
			<xsl:when test="$allergyObservationId='0'"><id nullFlavor="NI"/></xsl:when>
			<xsl:when test="$allergyObservationId='1'"><xsl:apply-templates select="." mode="id-External"/></xsl:when>
			<xsl:when test="$allergyObservationId='2'"><id root="{isc:evaluate('createUUID')}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="NI"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
