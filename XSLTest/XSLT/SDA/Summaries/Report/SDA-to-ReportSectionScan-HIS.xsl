<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="sectionName"/>

<!-- Insert entities under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
			<xsl:apply-templates select="/Container/Patients/Patient/PastHistory/PastHistory | /Container/Patients/Patient/FamilyHistory/FamilyHistory | /Container/Patients/Patient/SocialHistory/SocialHistory">
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<xsl:template match="PastHistory">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="date" select="FromTime"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,'',$date,'Medical')"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="FamilyHistory">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="date" select="FromTime"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,'',$date,'Family')"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="SocialHistory">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="date" select="FromTime"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,'',$date,'Social')"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
