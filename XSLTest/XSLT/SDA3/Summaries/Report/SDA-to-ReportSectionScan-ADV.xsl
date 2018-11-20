<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>
<xsl:key name="EncNum" match="Encounter" use="EncounterNumber" /> 

<!-- Insert allergies under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
			<xsl:apply-templates select="/Container/AdvanceDirectives/AdvanceDirective">
				<xsl:sort select="string-length(ToTime)=0" order="descending"/>
				<xsl:sort select="ToTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="/Container/AdvanceDirectives/AdvanceDirective">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
	<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
	<xsl:variable name="desc" select="Alert/Description"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$desc)"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
