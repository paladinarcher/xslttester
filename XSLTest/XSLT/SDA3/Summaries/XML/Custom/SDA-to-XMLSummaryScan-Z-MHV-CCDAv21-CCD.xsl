<?xml version="1.0"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:isc="http://extension-functions.intersystems.com"
	exclude-result-prefixes="isc">

	<!-- 
		Using 'import' to override named parameters
	 -->
	<xsl:import href="SDA-to-XMLSummaryScan-Z-VA-CCDAv21-CCD.xsl"/>
	
	<xsl:param name="ProblemsMinAge" select="3"/>
	<xsl:param name="LabOrdersMinAge" select="3"/>
	<xsl:param name="RadOrdersMinAge" select="3"/>
	<xsl:param name="LabOrdersMinAgeLR" select="14"/>
	<xsl:param name="DocumentsMinAge" select="3"/>

</xsl:stylesheet>
