<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>
<xsl:param name="subTypes"/>
<xsl:key name="EncNum" match="Encounter" use="EncounterNumber" /> 

<!-- Insert documents under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
		<xsl:apply-templates select="/Container/Documents/Document">
			<xsl:sort select="DocumentTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="Document">
	<xsl:if  test="string-length($subTypes)= 0 or contains(concat(',',$subTypes,','),concat(',',DocumentType/Code,','))">
		<xsl:variable name="source">
			<xsl:choose>
				<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
		<xsl:variable name="date" select="DocumentTime"/>
		<xsl:variable name="type" select="DocumentType/Description"/>

		<xsl:copy>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$type)"/>
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
