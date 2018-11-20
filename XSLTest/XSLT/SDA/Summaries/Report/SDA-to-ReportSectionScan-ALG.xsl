<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="sectionName"/>

<!-- Insert allergies under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
			<xsl:apply-templates select="/Container/Patients/Patient/Allergies/Allergies">
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="/Container/Patients/Patient/Allergies/Allergies">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="date" select="FromTime"/>
	<xsl:variable name="category" select="Allergy/AllergyCategory/Description"/>
	<xsl:variable name="desc" select="Allergy/Description"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,'',$date,$category,$desc)"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
