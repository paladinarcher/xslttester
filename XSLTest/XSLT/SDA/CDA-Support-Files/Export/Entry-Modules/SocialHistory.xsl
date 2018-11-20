<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="socialHistory-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Social Habit</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="SocialHistory" mode="socialHistory-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="socialHistory-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), position())}">
			<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), position())}"><xsl:value-of select="SocialHabit/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryComments/text(), position())}"><xsl:value-of select="SocialHabitComments/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="socialHistory-Entries">
		<xsl:apply-templates select="SocialHistory" mode="socialHistory-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="socialHistory-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-socialHistoryEntry"/>
	
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="SocialHabit" mode="generic-Coded"/>
				
				<text><reference value="{concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
	
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<xsl:apply-templates select="SocialHabitQty/Description" mode="value-ST"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="Status" mode="observation-socialHistoryStatus"/>
				<xsl:apply-templates select="SocialHabitComments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="socialHistory-NoData">
		<text><xsl:value-of select="$exportConfiguration/socialHistory/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-socialHistoryStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-socialHistoryStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- SocialHistory Status in SDA export is only I for Inactive or any   -->
				<!-- other value for Active. SocialHistory Status is stored in the      -->
				<!-- HSDB as String, so technically it comes here with no code system.  -->
				<!-- HOWEVER, the SNOMED OID has always been forced in there, so we     -->
				<!-- will continue to do that.                                          -->
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

	<xsl:template name="templateIDs-socialHistoryEntry">
		<xsl:if test="string-length($hitsp-CDA-SocialHistory)"><templateId root="{$hitsp-CDA-SocialHistory}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-SocialHistoryObservation)"><templateId root="{$hl7-CCD-SocialHistoryObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SocialHistoryObservation)"><templateId root="{$ihe-PCC-SocialHistoryObservation}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-socialHistoryStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-SocialHistoryStatusObservation)"><templateId root="{$hl7-CCD-SocialHistoryStatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
