<?xml version="1.0"?>
<!-- Removes all encounters other than the selected encounter from SDA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="visitNumber"/>

<xsl:template match="@* | node()">
	<xsl:copy>
  		<xsl:apply-templates select="@* | node()" /> 
	</xsl:copy>
</xsl:template>

<xsl:template match="Encounter">
	<xsl:if test="VisitNumber =$visitNumber">
		<xsl:copy-of select="."/>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
