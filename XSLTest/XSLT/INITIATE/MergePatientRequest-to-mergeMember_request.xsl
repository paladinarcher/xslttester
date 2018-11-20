<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="USERNAME">rwuser</xsl:param>
	<xsl:param name="PASSWORD">rwuser</xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<!-- Match an MergePatientRequest -->
	<xsl:template match="/MergePatientRequest">
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			 			  xmlns:urn="urn:bean.initiate.com">
		   <soapenv:Header/>
		   <soapenv:Body>
		      <urn:mergeMember>
		         <memMergeReq>
			<audMode xsi:nil="true"/>
			<userPassword><xsl:value-of select="$PASSWORD"/></userPassword>
			<userName><xsl:value-of select="$USERNAME"/></userName>
			<entType>id</entType>
		            
				<!-- Obsolete and Surviving MRN -->
		            
		        <memIdnumObs><xsl:value-of select="PriorMRN"/></memIdnumObs>
			<memIdnumSrv><xsl:value-of select="MRN"/></memIdnumSrv>	
			<memType>PERSON</memType>

				<!-- Obsolete and Surviving AA -->

			<srcCodeObs><xsl:value-of select="PriorAssigningAuthority"/></srcCodeObs>
		        <srcCodeSrv><xsl:value-of select="AssigningAuthority"/></srcCodeSrv>
		            
		         </memMergeReq>
		      </urn:mergeMember>
		   </soapenv:Body>
		</soapenv:Envelope>		

	</xsl:template>

</xsl:stylesheet>