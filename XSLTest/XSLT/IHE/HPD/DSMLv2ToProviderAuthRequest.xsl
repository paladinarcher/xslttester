<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform DSMLv2 addRequest into a Provider AddEditIndividualRequest or AddEditOrganization Request -->
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				 xmlns:isc="http://extension-functions.intersystems.com" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core"
				 xmlns:exsl="http://exslt.org/common"
				 extension-element-prefixes="exsl"
				exclude-result-prefixes="xsi isc dsml exsl"
				version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- authRequests are not currently handled - return an empty request so we can return an error -->
<xsl:template match="dsml:authRequest">
	<AuthRequest/>
</xsl:template>
	
</xsl:stylesheet>