<?xml version="1.0"?>
<xsl:stylesheet xmlns:tns="urn:bean.initiate.com"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				exclude-result-prefixes="tns soapenv xsi"
				version="1.0">

	<xsl:output method="xml" indent="yes"/>

	<!-- Handle a normal response -->
	<xsl:template match="tns:deleteMemberResponse">
		<RemovePatientResponse>
			<Accepted><xsl:value-of select="deleteMemberReturn"/></Accepted>
		</RemovePatientResponse>
	</xsl:template>
	
	<!-- Match a Initiate/SOAP response message -->
	<xsl:template match="/soapenv:Envelope/soapenv:Body">
		<xsl:apply-templates select="tns:deleteMemberResponse"/>
	</xsl:template>

</xsl:stylesheet>