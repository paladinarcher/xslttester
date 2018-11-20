<?xml version="1.0"?>
<xsl:stylesheet xmlns:tns="urn:bean.initiate.com"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				exclude-result-prefixes="tns soapenv xsi"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Process the putMemberReturn data -->
	<xsl:template match="putMemberReturn/item">
		<!-- Cant trust memRecno, as linking may not be complete
		<PatientId><xsl:value-of select="memHead/memRecno"/></PatientId> -->
		<PatientId></PatientId>
	</xsl:template>

	<!-- Handle a normal response -->
	<xsl:template match="tns:putMemberResponse">
		<AddPatientResponse>
			<xsl:apply-templates select="putMemberReturn/item"/>
		</AddPatientResponse>
	</xsl:template>
		
	<!-- Match a Initiate/SOAP response message -->
	<xsl:template match="/soapenv:Envelope/soapenv:Body">
		<xsl:apply-templates select="tns:putMemberResponse"/>
	</xsl:template>

</xsl:stylesheet>