<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="procedures-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Procedure</th>
						<th>Date / Time Performed</th>
						<th>Performing Clinician</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Procedures/Procedure" mode="procedures-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="procedures-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureNarrative/text(), $narrativeLinkSuffix)}">
			<td ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Procedure/Description/text()"/></td>
			<td><xsl:value-of select="ProcedureTime/text()"/></td>
			<td><xsl:value-of select="Clinician/Description/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="procedures-Entries">
		<xsl:apply-templates select="Encounter/Procedures/Procedure" mode="procedures-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry typeCode="DRIV">
			<procedure classCode="PROC" moodCode="EVN">
				<xsl:call-template name="templateIDs-procedureEntry"/>

				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="Procedure" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/procedures/narrativeLinkPrefixes/procedureNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
				
				<!-- Procedure body site/part -->
				<targetSiteCode nullFlavor="UNK"/>
				
				<xsl:apply-templates select="Clinician" mode="performer"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<!-- Link this problem to encounter noted in encounters section -->
				<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
			</procedure>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-NoData">
		<text><xsl:value-of select="$exportConfiguration/procedures/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-procedure">
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(ProcedureTime)">
					<low><xsl:attribute name="value"><xsl:apply-templates select="ProcedureTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
					<high><xsl:attribute name="value"><xsl:apply-templates select="ProcedureTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
				<xsl:otherwise>
					<low nullflavor="UNK"/>
					<high nullflavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<xsl:template name="templateIDs-procedureEntry">
		<xsl:if test="string-length($hitsp-CDA-Procedure)"><templateId root="{$hitsp-CDA-Procedure}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProcedureActivity)"><templateId root="{$hl7-CCD-ProcedureActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-ProcedureEntry)"><templateId root="{$ihe-PCC_CDASupplement-ProcedureEntry}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
