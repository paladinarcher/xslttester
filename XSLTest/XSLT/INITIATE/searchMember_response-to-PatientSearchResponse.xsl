<?xml version="1.0"?>
<xsl:stylesheet xmlns:tns="urn:bean.initiate.com"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				exclude-result-prefixes="tns soapenv xsi"
				version="1.0">
				
	<xsl:import href="item-to-PatientSearchMatch.xsl"/>

	<xsl:output method="xml" indent="yes"/>

	<!-- Process the results -->
	<xsl:template match="searchMemberReturn">
		<Results>
			<xsl:for-each select="item">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Results>
	</xsl:template>

	<!-- Handle a normal response -->
	<xsl:template match="tns:searchMemberResponse">
		<PatientSearchResponse>
			<xsl:apply-templates select="searchMemberReturn"/>
			<ResultsCount>
				<xsl:value-of select="count(searchMemberReturn/item)"/>
			</ResultsCount>
		</PatientSearchResponse>
	</xsl:template>
	
	<!-- Match a Initiate/SOAP response message -->
	<xsl:template match="/soapenv:Envelope/soapenv:Body">
		<xsl:apply-templates select="tns:searchMemberResponse"/>
	</xsl:template>

</xsl:stylesheet>