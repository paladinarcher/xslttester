<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="allergies-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Allergy Name</th>
						<th>Allergy Type</th>
						<th>Status</th>
						<th>Severity</th>
						<th>Reaction(s)</th>
						<th>Onset Date</th>
						<th>Treating Clinician</th>
						<th>Treatment Method(s)</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Allergies" mode="allergies-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="allergies-NarrativeDetail">
		<xsl:variable name="allergyNumber" select="position()"/>
		
		<tr ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyNarrative/text(), position())}">
			<td ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyAllergen/text(), position())}"><xsl:value-of select="Allergy/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyCategory/text(), position())}"><xsl:value-of select="Allergy/AllergyCategory/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyStatus/text(), position())}">
				<xsl:variable name="statusCode"><xsl:value-of select="Status/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$statusCode = 'A'">Active</xsl:when>
					<xsl:when test="$statusCode = 'C'">To Be Confirmed</xsl:when>
					<xsl:when test="$statusCode = 'I'">Inactive</xsl:when>
					<xsl:when test="$statusCode = 'R'">Resolved</xsl:when>
					<xsl:otherwise>Unknown</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:value-of select="Severity/Description/text()"/></td>
			<td>
				<xsl:if test="string-length(Reaction)">
					<list>
						<xsl:for-each select="Reaction">
							<item><content ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyReaction/text(), $allergyNumber, '-', position())}"><xsl:value-of select="Description/text()"/></content></item>
						</xsl:for-each>
					</list>
				</xsl:if>
			</td>
			<td><xsl:value-of select="DiscoveryTime/text()"/></td>
			<td><xsl:value-of select="Clinician/Description/text()"/></td>
			<td><xsl:value-of select="TreatmentMethods/text()"/></td>
			<td ID="{concat($exportConfiguration/allergies/narrativeLinkPrefixes/allergyComments/text(), position())}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="allergies-Entries">
		<xsl:apply-templates select="Allergies" mode="allergies-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="allergies-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<xsl:call-template name="templateIds-allergiesEntry"/>
				
				<xsl:apply-templates select="." mode="id-External"/>
				
				<code nullFlavor="NA"/>
				<text><reference value="{concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyNarrative/text(), $narrativeLinkSuffix)}"/></text>

				<xsl:apply-templates select="." mode="statusCode-Allergy"/>
				<xsl:apply-templates select="Clinician" mode="performer"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="." mode="allergies-Detail"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</act>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="allergies-NoData">
		<text><xsl:value-of select="$exportConfiguration/allergies/emptySection/narrativeText/text()"/></text>
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.1.27"/>
				<templateId root="2.16.840.1.113883.3.88.11.83.6"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3"/>
				<id nullFlavor="NI"/>
				<code nullFlavor="NA"/>
				<text><reference value="#noAllergies-1"/></text>
				<statusCode code="active"/>						
				<effectiveTime>
					<low nullFlavor="NA"/>
				</effectiveTime>							
				<entryRelationship typeCode="SUBJ" inversionInd="false">
					<observation classCode="OBS" moodCode="EVN">
						<templateId root="2.16.840.1.113883.10.20.1.18"/>
						<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.6"/>
						<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
						<templateId root="2.16.840.1.113883.10.20.1.28"/>
						<id nullFlavor="NI"/>
						<code code="420134006" codeSystem="{$snomedOID}" displayName="Propensity to adverse reactions (disorder)" codeSystemName="{$snomedName}"/>
						<text><reference value="#noAllergies-1"/></text>
						<statusCode code="completed"/>
						<effectiveTime>
							<low nullFlavor="UNK"/>
						</effectiveTime>
						<value xsi:type="CD" code="160244002" codeSystem="{$snomedOID}" displayName="No Known allergies" codeSystemName="{$snomedName}">
							<originalText>
								<reference value="#noAllergies-1"/>
							</originalText>
						</value>
					</observation>
				</entryRelationship>
			</act>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="allergies-Detail">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<entryRelationship typeCode="SUBJ" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-allergiesCategory"/>
				
				<id nullFlavor="UNK"/>

				<xsl:choose>
					<xsl:when test="Allergy/AllergyCategory">
						<xsl:apply-templates select="Allergy/AllergyCategory" mode="allergies-category-code">
							<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyCategory/text(), $narrativeLinkSuffix)"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise><code nullFlavor="NA"/></xsl:otherwise>
				</xsl:choose>
				
				<text><reference value="{concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyCategory/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>				
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<value xsi:type="CD" nullFlavor="NA"/>
				
				<xsl:apply-templates select="Allergy" mode="participant-Allergy"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				<xsl:apply-templates select="Reaction" mode="observation-Reaction"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				<xsl:apply-templates select="Severity" mode="observation-Severity"/>
				<xsl:apply-templates select="Status" mode="observation-AllergyStatus"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="participant-Allergy">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<participant typeCode="CSM">
			<participantRole classCode="MANU">
				<addr nullFlavor="UNK"/>
				<telecom nullFlavor="UNK"/>
				<playingEntity classCode="MMAT">
					<!-- Allergy Detail -->
					<xsl:apply-templates select="." mode="generic-Coded">
						<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyAllergen/text(), $narrativeLinkSuffix)"/>
					</xsl:apply-templates>

					<name><xsl:value-of select="Description/text()"/></name>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Reaction">
		<xsl:param name="narrativeLinkSuffix"/>

		<entryRelationship typeCode="MFST" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-allergiesReaction"/>
				
				<id nullFlavor="UNK"/>
				<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>

				<!-- Currently, only one reaction supported, so is hard-coded to 1 -->
				<text><reference value="{concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyReaction/text(), $narrativeLinkSuffix, '-', 1)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="parent::node()" mode="effectiveTime-FromTo"/>

				<!-- Allergy Detail -->
				<xsl:apply-templates select="." mode="value-CD"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Severity">
		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-allergiesSeverity"/>
				
				<code code="SEV" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" displayName="Severity observation"/>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="value-CD"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-AllergyStatus">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-allergiesStatus"/>

				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text><reference value="{concat('#', $exportConfiguration/allergies/narrativeLinkPrefixes/allergyStatus/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<!-- Allergy Status is stored in the HSDB as String, so -->
				<!-- technically it comes to use with no code system.   -->
				<!-- HOWEVER, the SNOMED OID has always been forced in  -->
				<!-- there, so we will continue to do that.             -->
				<!-- Status Detail -->
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
								<xsl:otherwise>No Longer Active</xsl:otherwise>
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
		<!--
			HealthShare recognizes these states:  A = Active, R = resolved, I = Inactive, C = ToBeConfirmed
			
			We will map HealthShare to CDA as follows:
			A and C = active
			I = aborted
			R = completed				
		-->
		<statusCode>
			<xsl:attribute name="code">
				<xsl:choose>
					<xsl:when test="contains('A|C', Status/text())">active</xsl:when>
					<xsl:when test="text() = 'I'">aborted</xsl:when>
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
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>
		
		<xsl:variable name="sdaCodingStandardOID" select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/>
				
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
						<code code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}">
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
							<originalText>
							<xsl:choose>
								<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
							</xsl:choose>
							</originalText>

							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>
					
					<!-- If we got a valid SNOMED code but didn't get the SNOMED code system, -->
					<!-- then export the data with SNOMED code system plugged in, and also   -->
					<!-- export a <translation> with the data and code system that was      -->
					<!-- actually received. -->
					<xsl:when test="$isValidSnomedCode">
						<code code="{Code/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Description/text()}">
						<originalText><xsl:value-of select="Description/text()"/></originalText>
						<translation code="{Code/text()}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
						<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>

					<!-- Otherwise, it's not a valid SNOMED code, make it into one. -->
					<xsl:otherwise>
						<xsl:variable name="descUpper" select="isc:evaluate('toUpper', Description/text())"/>
		
						<xsl:variable name="codeValue">
							<xsl:choose>
								<xsl:when test="contains($descUpper, 'DRUG')">416098002</xsl:when>
								<xsl:when test="contains($descUpper, 'FOOD')">414285001</xsl:when>
								<xsl:otherwise>419199007</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<code code="{$codeValue}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Description/text()}">
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
						<originalText>
							<xsl:choose>
								<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
							</xsl:choose>
						</originalText>
						
						<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
						<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:otherwise>
					
				</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<code nullFlavor="NA"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="templateIds-allergiesEntry">
		<xsl:if test="string-length($hitsp-CDA-AllergyAndDrugSensitivityModule)"><templateId root="{$hitsp-CDA-AllergyAndDrugSensitivityModule}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemAct)"><templateId root="{$hl7-CCD-ProblemAct}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-AllergyAndIntoleranceConcern)"><templateId root="{$ihe-PCC-AllergyAndIntoleranceConcern}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ConcernEntry)"><templateId root="{$ihe-PCC-ConcernEntry}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-allergiesCategory">
		<xsl:if test="string-length($hl7-CCD-AlertObservation)"><templateId root="{$hl7-CCD-AlertObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemObservation)"><templateId root="{$hl7-CCD-ProblemObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemEntry)"><templateId root="{$ihe-PCC-ProblemEntry}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-AllergiesAndIntolerances)"><templateId root="{$ihe-PCC-AllergiesAndIntolerances}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-allergiesReaction">
		<xsl:if test="string-length($hl7-CCD-ReactionObservation)"><templateId root="{$hl7-CCD-ReactionObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemObservation)"><templateId root="{$hl7-CCD-ProblemObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemEntry)"><templateId root="{$ihe-PCC-ProblemEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-allergiesSeverity">
		<xsl:if test="string-length($hl7-CCD-SeverityObservation)"><templateId root="{$hl7-CCD-SeverityObservation}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-allergiesStatus">
		<xsl:if test="string-length($hl7-CCD-AlertStatusObservation)"><templateId root="{$hl7-CCD-AlertStatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemStatusObservation)"><templateId root="{$hl7-CCD-ProblemStatusObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemStatusObservation)"><templateId root="{$ihe-PCC-ProblemStatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
