<?xml version="1.0"?>
<!-- Perform additional cleanup on Summary SDA-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes"/>

<!-- Identity template, copies all elements (except below) -->
<xsl:template match="node()|@*">
 	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
 	</xsl:copy>
</xsl:template>

<!-- Filter out lab results with no result items -->
<xsl:template match="LabResult">
	<xsl:if test="ResultItems/LabResultItem">
 		<xsl:copy>
			<xsl:apply-templates select="*" />
 		</xsl:copy>
		</xsl:if>
</xsl:template>

</xsl:stylesheet>
