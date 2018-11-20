<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>

<xsl:template match="/">
	<xsl:element name="{$sectionName}">
		<xsl:apply-templates select="/Container/Patient"/>
		<xsl:apply-templates select="/Container/AdditionalInfo[AdditionalInfoItem/@AdditionalInfoKey='IncompleteResult']"/>
	</xsl:element>
</xsl:template>

<xsl:template match="AdditionalInfo">
	<xsl:element name="{AdditionalInfoItem/@AdditionalInfoKey}">
		<xsl:value-of select="AdditionalInfoItem/text()"/>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="Patient">
	<xsl:copy>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Add sequence to individual attributes -->
<xsl:template match="Race | Religion | PrimaryLanguage |  MaritalStatus">
	<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name()='MaritalStatus'">Marital Status</xsl:when>
				<xsl:when test="local-name()='PrimaryLanguage'">Language</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
	</xsl:variable>
	<xsl:copy>
		<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,'','','',$type,Description)"/>
		</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

<xsl:template match="*">
	<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
