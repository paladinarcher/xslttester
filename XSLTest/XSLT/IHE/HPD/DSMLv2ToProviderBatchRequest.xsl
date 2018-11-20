<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform DSMLv2 request into a Provider BatchRequest -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
				xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core" xmlns:isc="http://extension-functions.intersystems.com" 
				xmlns:exsl="http://exslt.org/common"
				 extension-element-prefixes="exsl"
				exclude-result-prefixes="dsml isc xsi exsl"
				version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:include href="Variables.xsl"/>
<xsl:include href="Common.xsl"/>
<xsl:include href="DSMLv2ToProviderSearchRequest.xsl"/>
<xsl:include href="DSMLv2ToProviderAddEditRequest.xsl"/>
<xsl:include href="DSMLv2ToProviderModifyRequest.xsl"/>
<xsl:include href="DSMLv2ToProviderAuthRequest.xsl"/>

<!--  Process each request in the batch -->
<xsl:template match="dsml:batchRequest">
	<BatchRequest>
		<xsl:apply-templates/>
	</BatchRequest>
</xsl:template>

</xsl:stylesheet>