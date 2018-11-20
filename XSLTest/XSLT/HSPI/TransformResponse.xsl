<?xml version="1.0"?>
<!-- Transform response from HSPI.  Just take as is for now -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes"/>

<!-- Identity template, copies all elements -->
<xsl:template match="node()|@*">
 	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
 	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
