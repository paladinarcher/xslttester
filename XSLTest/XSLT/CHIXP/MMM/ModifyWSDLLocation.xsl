<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	xmlns:wsntw="http://docs.oasis-open.org/wsn/bw-2"
	xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
	xmlns:wsa="http://www.w3.org/2005/08/addressing" 
	xmlns:wsrf-rw="http://docs.oasis-open.org/wsrf/rw-2" 
	xmlns:wsrf-rlw="http://docs.oasis-open.org/wsrf/rlw-2" 
	xmlns:wsrf-rp="http://docs.oasis-open.org/wsrf/rp-2" 
	xmlns:wsrf-rpw="http://docs.oasis-open.org/wsrf/rpw-2" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
	xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0"
	>
<xsl:output indent="yes"/>
<xsl:param name="URL" />
<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="/wsdl:definitions/wsdl:service/wsdl:port/soap:address/@location">
	<xsl:attribute name="location"><xsl:value-of select="$URL"/></xsl:attribute>
</xsl:template>
</xsl:stylesheet>