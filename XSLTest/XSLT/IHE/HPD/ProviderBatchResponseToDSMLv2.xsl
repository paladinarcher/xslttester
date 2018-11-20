<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform a Provider BatchResponse into DSMLv2 -->
<xsl:stylesheet xmlns="urn:oasis:names:tc:DSML:2:0:core"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			 xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common"
			 extension-element-prefixes="exsl"
			 exclude-result-prefixes="xsi isc exsl"
			 version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:include href="Variables.xsl"/>
<xsl:include href="ProviderSearchResponseToDSMLv2.xsl"/>
<xsl:include href="ProviderLDAPResponse.xsl"/>
<xsl:include href="ProviderErrorResponseToDSMLv2.xsl"/>

<!--  Process each request in the batch -->
<xsl:template match="BatchResponse">
	<batchResponse>
		<xsl:attribute name="requestID"><xsl:value-of select="RequestID"/></xsl:attribute>
		<xsl:apply-templates/>
	</batchResponse>
</xsl:template>

<!-- Ignore elements not explicitly matched -->
<xsl:template match="*"/>

</xsl:stylesheet>