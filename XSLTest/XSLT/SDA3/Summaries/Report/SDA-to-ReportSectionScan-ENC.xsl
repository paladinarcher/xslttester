<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>

<!-- Insert encounters under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
		<xsl:apply-templates select="/Container/Encounters/Encounter">
			<xsl:sort select="string-length(EndTime)=0" order="descending"/>
			<xsl:sort select="EndTime" order="descending"/>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="Encounter">
	<xsl:if test="not(EncounterType = 'S' or EncounterType = 'G')">
		<xsl:variable name="source" select="HealthCareFacility/Organization/Code"/>
		<xsl:variable name="sourceType" select="EncounterType"/>
		<xsl:variable name="date" select="concat(FromTime,'|',ToTime,'|',EndTime)"/>
		<xsl:variable name="visitNum" select="EncounterNumber"/>
		<xsl:copy>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$visitNum,$sourceType)"/>
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:copy> 
	</xsl:if>
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
