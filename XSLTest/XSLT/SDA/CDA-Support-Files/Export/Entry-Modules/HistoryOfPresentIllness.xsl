<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="presentIllness-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Period Start Date/Time</th>
						<th>Period End Date/Time</th>
						<th>Note Text</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="PastHistory" mode="presentIllness-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="presentIllness-NarrativeDetail">
		<tr ID="{concat($exportConfiguration/presentIllness/narrativeLinkPrefixes/presentIllnessNarrative/text(), position())}">
			<td><xsl:value-of select="translate(translate(FromTime/text(), 'T', ' '), 'Z', '')"/></td>
			<td><xsl:value-of select="translate(translate(ToTime/text(), 'T', ' '), 'Z', '')"/></td>
			<td ID="{concat($exportConfiguration/presentIllness/narrativeLinkPrefixes/presentIllnessNote/text(), position())}"><xsl:value-of select="NoteText/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="presentIllness-Entries">
		<xsl:apply-templates select="PastHistory" mode="presentIllness-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="presentIllness-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<xsl:apply-templates select="." mode="id-External"/>

				<code nullFlavor="OTH">
					<originalText><reference value="{concat('#', $exportConfiguration/presentIllness/narrativeLinkPrefixes/presentIllnessNote/text(), $narrativeLinkSuffix)}"/></originalText>
				</code>
				<text><reference value="{concat('#', $exportConfiguration/presentIllness/narrativeLinkPrefixes/presentIllnessNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="active"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
			</act>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="presentIllness-NoData">
		<text><xsl:value-of select="$exportConfiguration/presentIllness/emptySection/narrativeText/text()"/></text>
	</xsl:template>
</xsl:stylesheet>
