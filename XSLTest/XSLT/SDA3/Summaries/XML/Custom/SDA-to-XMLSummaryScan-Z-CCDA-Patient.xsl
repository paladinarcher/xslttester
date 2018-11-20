<?xml version="1.0"?>
<!--

Scanner for OnDemand CCDA Patient Summary

TODO: should use VA custom scanner to limit/organize data

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:import href="SDA-to-XMLSummaryScan-Z-VA-CCDA-CCD.xsl"/>

	<xsl:variable name="_from" select="$FromDate"/>
	<xsl:variable name="_thru" select="$ThruDate"/>
	
</xsl:stylesheet>