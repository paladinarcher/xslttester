<?xml version="1.0"?>
<!-- Filters items out of SDA for XML or section-based patient summaries ,based on  the results of the Filter UI -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>

<!-- Identity template, copies all elements (except below) -->
<xsl:template match="node()|@*">
 	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
 	</xsl:copy>
</xsl:template>

<!-- Filter out items excluded by the Filter UI (and don't output the sequence attribute) -->
<xsl:template match="*[@sequence]">
	<xsl:variable name="sequence" select="@sequence"/>
	<xsl:variable name="filter">
		<xsl:value-of select="isc:evaluate('includeEntity',$sequence)"/>
	</xsl:variable>

	<xsl:if test="$filter = 1">
 		<xsl:copy>
			<xsl:apply-templates select="*" />
 		</xsl:copy>
		</xsl:if>
</xsl:template>

</xsl:stylesheet>
