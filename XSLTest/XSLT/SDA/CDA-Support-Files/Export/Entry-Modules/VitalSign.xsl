<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="vitalSigns-Narrative">
		<xsl:param name="validVitalSigns"/>
		
		<!-- validVitalSigns contains the ObservationCodes of those -->
		<!-- Observations that are okay to export to Vital Signs.   -->
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Vital Name</th>
						<th>Observation Time</th>
						<th>Observation Value</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Observations/Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|'))]" mode="vitalSigns-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		<xsl:variable name="observationCode" select="ObservationCode/Code/text()"/>
		
		<tr ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignNarrative/text(), $narrativeLinkSuffix)}">
			<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignIdentifier/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ObservationCode/Description/text()"/></td>
			<td><xsl:value-of select="ObservationTime/text()"/></td>
			<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignValue/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ObservationValue/text()"/></td>
			<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-Entries">
		<xsl:param name="validVitalSigns"/>
		
		<!-- validVitalSigns contains the ObservationCodes of those -->
		<!-- Observations that are okay to export to Vital Signs.   -->
		<xsl:apply-templates select="Encounter/Observations" mode="vitalSigns-EntryDetail">
			<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-EntryDetail">
		<xsl:param name="validVitalSigns"/>
		
		<!-- validVitalSigns contains the ObservationCodes of those -->
		<!-- Observations that are okay to export to Vital Signs.   -->
		<entry>
			<organizer classCode="CLUSTER" moodCode="EVN">
				<xsl:call-template name="templateIDs-vitalSignsEntry"/>

				<id root="a40027e0-67a5-11db-bd13-0800200c9a66"/>
				<code code="46680005" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Vital signs"/>
				<statusCode code="completed"/>

				<xsl:choose>
					<xsl:when test="string-length(Observation[1]/EnteredOn)">
						<xsl:apply-templates select="Observation[1]/EnteredOn" mode="effectiveTime"/>
					</xsl:when>
					<xsl:otherwise><effectiveTime nullFlavor="UNK"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="Observation[1]/EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="Observation[1]/EnteredAt" mode="informant"/>
				<xsl:apply-templates select="Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|'))]" mode="observation-vitalSign"/>

				<!-- Link this battery to encounter noted in encounters section -->
				<xsl:apply-templates select="parent::node()" mode="encounterLink-component"/>
			</organizer>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-NoData">
		<text><xsl:value-of select="$exportConfiguration/vitalSigns/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="observation-vitalSign">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		

		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-vitalSignObservation"/>
				
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="ObservationCode" mode="observation-code"/>
				
				<text><reference value="{concat('#', $exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:choose>
					<xsl:when test="string-length(ObservationTime/text())">
						<xsl:apply-templates select="ObservationTime" mode="effectiveTime"/>
					</xsl:when>
					<xsl:otherwise>
						<effectiveTime nullFlavor="UNK"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="ObservationValue" mode="observation-value"/>
				<xsl:apply-templates select="Clinician" mode="performer"/>
				<xsl:apply-templates select="." mode="observation-vitalSignStatus"/>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</component>
	</xsl:template>

	<xsl:template match="*" mode="observation-vitalSignStatus">
		<!-- Not currently supported by SDA, so wired to be final/completed -->
		<entryRelationship typeCode="REFR">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-vitalSignObservationStatus"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>				
				<value xsi:type="CE" code="final" codeSystem="2.16.840.1.113883.5.14" displayName="final"/>
			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="observation-value">
	
		<!-- ObservationValue is a String that may be just be a -->
		<!-- value, or a value and unit, separated by a space.  -->
		<xsl:variable name="obsVal">
			<xsl:choose>
				<xsl:when test="string-length(substring-before(text(), ' '))"><xsl:value-of select="substring-before(text(), ' ')"/></xsl:when>
				<xsl:when test="string-length(text()) and not(string-length(substring-before(text(), ' ')))"><xsl:value-of select="text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<!-- The ObservationCode Code and Description are evaluated -->
		<!-- to determine which LOINC code this Observation is or   -->
		<!-- can be construed as.                                   -->
		<xsl:variable name="loincVitalSignCodes">|9279-1|8867-4|2710-2|8480-6|8462-4|8310-5|8302-2|8306-3|8287-5|3141-9|</xsl:variable>
		<xsl:variable name="descUpper" select="isc:evaluate('toUpper', parent::node()/ObservationCode/Description/text())"/>
		<xsl:variable name="codeValue">
			<xsl:choose>
				<xsl:when test="contains($loincVitalSignCodes, concat('|', parent::node()/ObservationCode/Code/text(), '|'))"><xsl:value-of select="parent::node()/ObservationCode/Code/text()"/></xsl:when>
				<xsl:when test="contains($descUpper, 'SYSTOLIC')">8480-6</xsl:when>
				<xsl:when test="contains($descUpper, 'DIASTOLIC')">8462-4</xsl:when>
				<xsl:when test="contains($descUpper, 'TEMP')">8310-5</xsl:when>
				<xsl:when test="contains($descUpper, 'HEIGHT')">8302-2</xsl:when>
				<xsl:when test="contains($descUpper, 'HEART RATE')">8867-4</xsl:when>
				<xsl:when test="contains($descUpper, 'PULSE')">8867-4</xsl:when>
				<xsl:when test="contains($descUpper, 'WEIGHT')">3141-9</xsl:when>
				<xsl:when test="contains($descUpper, 'O2 SAT')">2710-2</xsl:when>
				<xsl:when test="contains($descUpper, 'O2SAT')">2710-2</xsl:when>
				<xsl:when test="contains($descUpper, 'SO2')">2710-2</xsl:when>
				<xsl:when test="contains($descUpper, 'CRANIUM')">8287-5</xsl:when>
				<xsl:when test="contains($descUpper, 'SKULL')">8287-5</xsl:when>
				<xsl:when test="contains($descUpper, 'HEAD')">8287-5</xsl:when>
				<xsl:when test="contains($descUpper, 'RESPIRATORY')">9279-1</xsl:when>
				<xsl:when test="contains($descUpper, 'RESP RATE')">9279-1</xsl:when>
				<xsl:when test="contains($descUpper, 'RESPIRATION')">9279-1</xsl:when>
				<xsl:otherwise><xsl:value-of select="parent::node()/ObservationCode/Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Use the LOINC code to determine the unit. If not able to get it -->
		<!-- from LOINC code, see if it was included in ObservationValue.    -->
		<xsl:variable name="obsUnit">
			<xsl:choose>
				<xsl:when test="$codeValue = '9279-1'">/min</xsl:when>
				<xsl:when test="$codeValue = '8867-4'">/min</xsl:when>
				<xsl:when test="$codeValue = '2710-2'">%</xsl:when>
				<xsl:when test="$codeValue = '8480-6'">mm[Hg]</xsl:when>
				<xsl:when test="$codeValue = '8462-4'">mm[Hg]</xsl:when>
				<xsl:when test="string-length(substring-after(text(), ' '))"><xsl:value-of select="substring-after(text(), ' ')"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<value>
			<xsl:choose>
				<xsl:when test="number($obsVal)">
					<xsl:attribute name="xsi:type">PQ</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$obsVal"/></xsl:attribute>
					<xsl:attribute name="unit"><xsl:value-of select="$obsUnit"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xsi:type">ST</xsl:attribute>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</value>
	</xsl:template>

	<xsl:template match="*" mode="observation-code">

		<xsl:variable name="sdaCodingStandardOID" select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/>
		<xsl:variable name="loincOID">2.16.840.1.113883.6.1</xsl:variable>
		<xsl:variable name="loincName" select="isc:evaluate('getCodeForOID', $loincOID, 'CodeSystem')"/>
		
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
			<!-- If there is Code text, then work with it, otherwise code nullFlavor=UNK. -->
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="loincVitalSignCodes">|9279-1|8867-4|2710-2|8480-6|8462-4|8310-5|8302-2|8306-3|8287-5|3141-9|</xsl:variable>
				<xsl:variable name="isValidLoincCode" select="contains($loincVitalSignCodes, concat('|', Code/text(), '|'))"/>
				<xsl:choose>
				
					<!-- If we got the LOINC code system and a valid LOINC code, -->
					<!-- or we don't need a standards compliant export, then     -->
					<!-- just export the data as is.                             -->
					<xsl:when test="(($sdaCodingStandardOID=$loincOID) and ($isValidLoincCode))">
						<code code="{Code/text()}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{Description/text()}">
						<originalText><xsl:value-of select="Description/text()"/></originalText>
						<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>
					
					<!-- If we got a valid LOINC code but didn't get the LOINC    -->
					<!-- code system, then export the data with LOINC code system -->
					<!-- plugged in, and also export a <translation> with the     -->
					<!-- data and code system that was actually received.         -->
					<xsl:when test="$isValidLoincCode">
						<code code="{Code/text()}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{Description/text()}">
						<originalText><xsl:value-of select="Description/text()"/></originalText>
						<translation code="{Code/text()}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
						<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>
					
					<!-- Otherwise, it's not a LOINC code, try to make it one. -->
					<xsl:otherwise>
						<xsl:variable name="descUpper" select="isc:evaluate('toUpper', Description/text())"/>
						<xsl:variable name="codeValue">
							<xsl:choose>
								<xsl:when test="contains($loincVitalSignCodes, concat('|', Code/text(), '|'))"><xsl:value-of select="Code/text()"/></xsl:when>
								<xsl:when test="contains($descUpper, 'RESPIRATORY')">9279-1</xsl:when>
								<xsl:when test="contains($descUpper, 'RESP RATE')">9279-1</xsl:when>
								<xsl:when test="contains($descUpper, 'RESPIRATION')">9279-1</xsl:when>
								<xsl:when test="contains($descUpper, 'HEART RATE')">8867-4</xsl:when>
								<xsl:when test="contains($descUpper, 'PULSE')">8867-4</xsl:when>
								<xsl:when test="contains($descUpper, 'O2 SAT')">2710-2</xsl:when>
								<xsl:when test="contains($descUpper, 'O2SAT')">2710-2</xsl:when>
								<xsl:when test="contains($descUpper, 'SO2')">2710-2</xsl:when>
								<xsl:when test="contains($descUpper, 'SYSTOLIC')">8480-6</xsl:when>
								<xsl:when test="contains($descUpper, 'DIASTOLIC')">8462-4</xsl:when>
								<xsl:when test="contains($descUpper, 'TEMP')">8310-5</xsl:when>
								<xsl:when test="contains($descUpper, 'HEIGHT')">8302-2</xsl:when>
								<xsl:when test="contains($descUpper, 'CRANIUM')">8287-5</xsl:when>
								<xsl:when test="contains($descUpper, 'SKULL')">8287-5</xsl:when>
								<xsl:when test="contains($descUpper, 'HEAD')">8287-5</xsl:when>
								<xsl:when test="contains($descUpper, 'WEIGHT')">3141-9</xsl:when>
								<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<code code="{$codeValue}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{Description/text()}">
							<originalText><xsl:value-of select="Description/text()"/></originalText>
							<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:otherwise>
		
				</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<code nullFlavor="UNK"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="templateIDs-vitalSignsEntry">
		<xsl:if test="string-length($hl7-CCD-ResultOrganizer)"><templateId root="{$hl7-CCD-ResultOrganizer}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-VitalSignsOrganizer)"><templateId root="{$hl7-CCD-VitalSignsOrganizer}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-VitalSignsOrganizer)"><templateId root="{$ihe-PCC-VitalSignsOrganizer}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-vitalSignObservation">
		<xsl:if test="string-length($hitsp-CDA-VitalSigns)"><templateId root="{$hitsp-CDA-VitalSigns}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ResultObservation)"><templateId root="{$hl7-CCD-ResultObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-VitalSignsObservation)"><templateId root="{$ihe-PCC-VitalSignsObservation}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-vitalSignObservationStatus">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
