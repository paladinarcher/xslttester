<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>

<!-- Insert entities under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
			<xsl:apply-templates select="/Container/IllnessHistories/IllnessHistory | /Container/FamilyHistories/FamilyHistory | /Container/SocialHistories/SocialHistory">
				<xsl:sort select="string-length(ToTime)=0" order="descending"/>
				<xsl:sort select="ToTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<xsl:template match="IllnessHistory | FamilyHistory | SocialHistory">
	<xsl:variable name="source" select="EnteredAt/Code"/>
	<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="local-name()='IllnessHistory'">Medical</xsl:when>
			<xsl:when test="local-name()='FamilyHistory'">Family</xsl:when>
			<xsl:when test="local-name()='SocialHistory'">Social</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,'',$date,$type)"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Copy child nodes -->
<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
