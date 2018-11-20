<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="familyHistory-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Family Member</th>
						<th>Diagnosis</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="set:distinct(FamilyHistory/FamilyMember/Code)">
						<xsl:variable name="currentFamilyMember" select="text()"/>
						
						<xsl:apply-templates select="/Container/Patients/Patient/FamilyHistory/FamilyHistory[FamilyMember/Code/text() = $currentFamilyMember]" mode="familyHistory-NarrativeDetail">
							<xsl:with-param name="familyMemberIndex" select="position()"/>
						</xsl:apply-templates>
					</xsl:for-each>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="familyHistory-NarrativeDetail">
		<xsl:param name="familyMemberIndex"/>
		<xsl:variable name="familyHistoryIndex" select="position()"/>
		
		<tr ID="{concat($exportConfiguration/familyHistory/narrativeLinkPrefixes/familyHistoryNarrative/text(), $familyMemberIndex, '-', $familyHistoryIndex)}">
			<td><xsl:value-of select="FamilyMember/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/familyHistory/narrativeLinkPrefixes/familyHistoryDiagnosis/text(), $familyMemberIndex, '-', $familyHistoryIndex)}"><xsl:value-of select="Diagnosis/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/familyHistory/narrativeLinkPrefixes/familyHistoryComments/text(), $familyMemberIndex, '-', $familyHistoryIndex)}"><xsl:value-of select="NoteText/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="familyHistory-Entries">
		<xsl:apply-templates select="." mode="familyHistory-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="familyHistory-EntryDetail">
		<xsl:for-each select="set:distinct(FamilyHistory/FamilyMember/Code)">
			<xsl:variable name="currentFamilyMember" select="text()"/>

			<entry>
				<organizer classCode="CLUSTER" moodCode="EVN">
					<xsl:call-template name="templateIDs-familyHistoryOrganizer"/>
					
					<id root="{isc:evaluate('createGUID')}"/>
					<statusCode code="completed"/>

					<xsl:apply-templates select="/Container/Patients/Patient/FamilyHistory/FamilyHistory[FamilyMember/Code/text() = $currentFamilyMember][1]/FamilyMember" mode="subject"/>
					
					<xsl:apply-templates select="/Container/Patients/Patient/FamilyHistory/FamilyHistory[FamilyMember/Code/text() = $currentFamilyMember]" mode="familyHistory-observation">
						<xsl:with-param name="familyMemberIndex" select="position()"/>
					</xsl:apply-templates>
				</organizer>
			</entry>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*" mode="familyHistory-NoData">
		<text><xsl:value-of select="$exportConfiguration/familyHistory/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="familyHistory-observation">
		<xsl:param name="familyMemberIndex"/>
		<xsl:variable name="familyHistoryIndex" select="position()"/>

		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-familyHistoryObservation"/>
				
				<xsl:apply-templates select="." mode="id-External"/>

				<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
				<text><reference value="{concat('#', $exportConfiguration/familyHistory/narrativeLinkPrefixes/familyHistoryDiagnosis/text(), $familyMemberIndex, '-', $familyHistoryIndex)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<xsl:apply-templates select="Diagnosis/Description" mode="value-ST"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="Status" mode="observation-familyHistoryStatus"/>
				<xsl:apply-templates select="NoteText" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/familyHistory/narrativeLinkPrefixes/familyHistoryComments/text(), $familyMemberIndex, '-', $familyHistoryIndex)"/></xsl:apply-templates>
			</observation>
		</component>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-familyHistoryStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-familyHistoryStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- FamilyHistory Status in SDA export is only I for Inactive or any  -->
				<!-- other value for Active. FamilyHistory Status is stored in the     -->
				<!-- HSDB as String, so technically it comes here with no code system. -->
				<!-- HOWEVER, the SNOMED OID has always been forced in there, so we    -->
				<!-- will continue to do that.                                         -->
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="isc:evaluate('toUpper', text())"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'I'">73425007</xsl:when>
								<xsl:otherwise>55561003</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'I'">No Longer Active</xsl:when>
								<xsl:otherwise>Active</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template name="templateIDs-familyHistoryOrganizer">
		<xsl:if test="string-length($hitsp-CDA-FamilyHistoryOrganizer)"><templateId root="{$hitsp-CDA-FamilyHistoryOrganizer}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-FamilyHistoryOrganizer)"><templateId root="{$hl7-CCD-FamilyHistoryOrganizer}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-FamilyHistoryOrganizer)"><templateId root="{$ihe-PCC-FamilyHistoryOrganizer}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-familyHistoryObservation">
		<xsl:if test="string-length($hitsp-CDA-FamilyHistory)"><templateId root="{$hitsp-CDA-FamilyHistory}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-FamilyHistoryObservation)"><templateId root="{$hl7-CCD-FamilyHistoryObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-FamilyHistoryObservation)"><templateId root="{$ihe-PCC_CDASupplement-FamilyHistoryObservation}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-familyHistoryStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
