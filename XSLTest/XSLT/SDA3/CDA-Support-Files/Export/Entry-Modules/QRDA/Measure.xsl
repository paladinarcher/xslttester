<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="*" mode="measures-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>eMeasure Title</th>
						<th>Version neutral identifier</th>
						<th>eMeasure Version Number</th>
						<th>NQF eMeasure Number</th>
						<th>eMeasure Identifier (MAT)</th>
						<th>Version specific identifier</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="QualityMeasures/QualityMeasure" mode="measures-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="QualityMeasure" mode="measures-NarrativeDetail">
		<tr>
			<td><xsl:value-of select="Title/text()"/></td>
			<td><xsl:value-of select="VersionNeutralId/text()"/></td>
			<td><xsl:value-of select="VersionNumber/text()"/></td>
			<td><xsl:value-of select="NQFNumber/text()"/></td>
			<td><xsl:value-of select="AuthoringToolIdExtension/text()"/></td>
			<td><xsl:value-of select="VersionSpecificId/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="measures-Entries">
		<xsl:param name="assertionsContainer"/>
		
		<xsl:apply-templates select="QualityMeasures/QualityMeasure" mode="measures-EntryDetail">
			<xsl:with-param name="assertionsContainer" select="$assertionsContainer"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="QualityMeasure" mode="measures-EntryDetail">
		<xsl:param name="assertionsContainer"/>
		
		<entry typeCode="DRIV">
			<organizer classCode="CLUSTER" moodCode="EVN">
				<templateId root="{$qrda-MeasureReference}"/>
				<templateId root="{$qrda-QualityDataModelBasedMeasureReference}"/>
				
				<id nullFlavor="NI"/>
				
				<statusCode code="completed"/>
				
				<reference typeCode="REFR">
					<externalDocument classCode="DOC" moodCode="EVN">
						<xsl:comment> Version-specific identifier </xsl:comment>
						<id root="{VersionSpecificId/text()}"/>
						
						<xsl:if test="string-length(NQFNumber)">
							<xsl:comment> NQF Number </xsl:comment>
							<id root="{$nqfOID}" extension="{NQFNumber/text()}"/>
						</xsl:if>
						
						<xsl:if test="string-length(AuthoringToolIdExtension)">
							<xsl:comment> Measure Authoring Tool Identifier (aka CMS Number) </xsl:comment>
							<id root="2.16.840.1.113883.3.560.101.2" extension="{AuthoringToolIdExtension/text()}"/>
						</xsl:if>
						
						<code code="57024-2" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Health Quality Measure Document"/>
						
						<xsl:if test="string-length(Title)">
							<xsl:comment> Title </xsl:comment>
							<text><xsl:value-of select="Title/text()"/></text>
						</xsl:if>
						
						<xsl:if test="string-length(VersionNeutralId)">
							<xsl:comment> Version-neutral identifier (aka setId) </xsl:comment>
							<setId root="{VersionNeutralId/text()}"/>
						</xsl:if>
						
						<xsl:if test="string-length(VersionNumber)">
							<versionNumber value="{VersionNumber/text()}"/>
						</xsl:if>
					</externalDocument>
				</reference>
				<xsl:variable name="measureCode" select="Code/text()"/>
				<xsl:apply-templates select="$assertionsContainer/Assertions/Assertion[MeasureCode=$measureCode]" mode="measureAssertion"/>
			</organizer>
		</entry>
	</xsl:template>
	
	<xsl:template match="Assertion" mode="measureAssertion">
		<xsl:comment> Measure Result Assertion </xsl:comment>
		<component>
			<xsl:comment> observation negationInd indicates did or did not meet criteria </xsl:comment>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:attribute name="negationInd">
					<xsl:choose>
						<xsl:when test="AssertionResult/text()='1'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode"/>
				<!-- This logic assumes that the specified code is an HL7 Observation Value -->
				<value code="{AssertionCode/text()}" codeSystem="2.16.840.1.113883.5.1063" codeSystemName="HL7 Observation Value" displayName="Denominator Exception" xsi:type="CD"/>
				<!-- Explicit reference to the eMeasure population (because some eMeasures have multiple Numerators, etc -->
				<reference typeCode="REFR">
					<externalObservation classCode="OBS" moodCode="EVN">
						<xsl:comment> Measure Population Id </xsl:comment>
						<id root="{PopulationId/text()}"/>
					</externalObservation>
				</reference>
				<xsl:if test="string-length(Probability)">
					<referenceRange>
						<observationRange>
							<xsl:comment> Predicted probability that patient meets the criteria </xsl:comment>
							<value xsi:type="REAL" value="{Probability/text()}"/>
						</observationRange>
					</referenceRange>
				</xsl:if>
			</observation>
		</component>
	</xsl:template>
	
	<xsl:template match="*" mode="measures-NoData">
		<text><xsl:value-of select="$exportConfiguration/measures/emptySection/narrativeText/text()"/></text>
	</xsl:template>
</xsl:stylesheet>
