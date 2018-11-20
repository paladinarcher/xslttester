<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
	<xsl:output method="xml" indent="no" encoding="ISO-8859-1" omit-xml-declaration="yes"/>
	<xsl:param name="propertyList"/>
	<xsl:strip-space elements="*"/>

<xsl:template match="@*|node()">
<xsl:variable name="stuff">
	<xsl:text>,/</xsl:text>
	<xsl:for-each select="ancestor-or-self::*">
		 <xsl:value-of select="name()" /><xsl:text>/</xsl:text>
	</xsl:for-each>
	<xsl:text>,</xsl:text>
</xsl:variable>
<xsl:if test="not(contains($propertyList,$stuff))">
<xsl:copy>
<xsl:apply-templates/>
</xsl:copy>
</xsl:if>
</xsl:template>

</xsl:stylesheet>