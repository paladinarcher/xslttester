<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>

<!-- Insert allergies under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
			<xsl:apply-templates select="/Container/ClinicalRelationships/ClinicalRelationship">
				<xsl:sort select="string-length(ExpirationDate)=0" order="descending"/>
				<xsl:sort select="ExpirationDate" order="descending"/>
			</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="/Container/ClinicalRelationships/ClinicalRelationship">
	<xsl:variable name="date" select="ExpirationDate"/>
	<xsl:variable name="clin" select="Clinician/Name/FamilyName"/>
	<xsl:variable name="grp" select="ClinicianGroup/Description"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,'','',$date,$clin,$grp)"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
