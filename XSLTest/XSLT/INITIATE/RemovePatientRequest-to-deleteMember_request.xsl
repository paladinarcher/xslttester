<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="USERNAME">rwuser</xsl:param>
	<xsl:param name="PASSWORD">rwuser</xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<!-- Match an RemovePatientRequest -->
	<xsl:template match="/RemovePatientRequest">
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			 			  xmlns:urn="urn:bean.initiate.com">
		   <soapenv:Header/>
		   <soapenv:Body>
		      <urn:deleteMember>
		         <memDelReq>
					<userPassword><xsl:value-of select="$PASSWORD"/></userPassword>
					<userName><xsl:value-of select="$USERNAME"/></userName>
		            <srcCode><xsl:value-of select="AssigningAuthority"/></srcCode>
		            <memIdnum><xsl:value-of select="MRN"/></memIdnum>
		         </memDelReq>
		      </urn:deleteMember>
		   </soapenv:Body>
		</soapenv:Envelope>		

	</xsl:template>

</xsl:stylesheet>