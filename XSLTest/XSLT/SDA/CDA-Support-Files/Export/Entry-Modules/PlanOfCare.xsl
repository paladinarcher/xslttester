<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="planOfCare-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Planned Activity</th>
						<th>Planned Date</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Plan/Orders/Order | Encounter/Plan/Orders/Medication" mode="planOfCare-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="planOfCare-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/planOfCare/narrativeLinkPrefixes/planOfCareNarrative/text(), $narrativeLinkSuffix)}">
			<td><xsl:value-of select="OrderItem/Description/text()"/></td>
			<td><xsl:value-of select="ProcedureTime/text()"/></td>
			<td ID="{concat($exportConfiguration/planOfCare/narrativeLinkPrefixes/planOfCareComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="planOfCare-NoData">
		<text><xsl:value-of select="$exportConfiguration/planOfCare/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="planOfCare-Entries">
		<xsl:apply-templates select="Encounter/Plan/Orders/Order | Encounter/Plan/Orders/Medication" mode="planOfCare-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="planOfCare-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="RQO">
				<xsl:call-template name="templateIDs-planOfCareEntry"/>

				<!-- External, Placer, and Filler IDs-->
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="." mode="id-Placer"/>
				<xsl:apply-templates select="." mode="id-Filler"/>
				
				<xsl:apply-templates select="OrderItem" mode="code"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/planOfCare/narrativeLinkPrefixes/planOfCareDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/planOfCare/narrativeLinkPrefixes/planOfCareNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="complete"/>

				<!-- Effective Time -->
				<xsl:apply-templates select="." mode="effectiveTime"/>
				
				<value xsi:type="BL" value="true"/>

				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="Status" mode="observation-PlanStatus"/>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/planOfCare/narrativeLinkPrefixes/planOfCareComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>

				<!-- Link this care plan to encounter noted in encounters section -->
				<xsl:apply-templates select="parent::node()/parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-PlanStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-planStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="isc:evaluate('toUpper', text())"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">55561003</xsl:when>
								<xsl:when test="$statusValue = 'H'">421139008</xsl:when>
								<xsl:otherwise>73425007</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">Active</xsl:when>
								<xsl:when test="$statusValue = 'H'">On Hold</xsl:when>
								<xsl:otherwise>No Longer Active</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template name="templateIDs-planOfCareEntry">
		<xsl:if test="string-length($hitsp-CDA-PlanOfCare)"><templateId root="{$hitsp-CDA-PlanOfCare}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-PlanOfCareActivity)"><templateId root="{$hl7-CCD-PlanOfCareActivity}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-planStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>	
</xsl:stylesheet>
