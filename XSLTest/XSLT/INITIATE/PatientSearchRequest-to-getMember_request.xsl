<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="USERNAME">rwuser</xsl:param>
	<xsl:param name="PASSWORD">rwuser</xsl:param>
	<xsl:param name="GETTYPE">ASENTITY</xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<!-- Match an PatientSearchRequest -->
	<xsl:template match="/PatientSearchRequest">
	   <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
		 				 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
		 				 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	      <soapenv:Body>

	         <getMember xmlns="urn:bean.initiate.com">
	            <memGetReq xmlns="">
					<userPassword>
						<xsl:value-of select="$PASSWORD"/>
					</userPassword>
					<userName>
						<xsl:value-of select="$USERNAME"/>
					</userName>
					<audMode xsi:nil="true"/>
					<cvwName xsi:nil="true"/>
					<recStatFilter xsi:nil="true"/>
					<xsl:choose>
						<xsl:when test="MPIID!=''">
							<memIdnum xsi:nil="true"/>
							<entRecno>
								<xsl:value-of select="MPIID"/>
							</entRecno>
						</xsl:when>
						<xsl:otherwise>
							<memIdnum>
								<xsl:value-of select="MRN"/>
							</memIdnum>
							<entRecno xsi:nil="true"/>
						</xsl:otherwise>
					</xsl:choose>
					<segCodeFilter>MEMHEAD,MEMADDR,MEMATTR,MEMDATE,MEMIDENT,MEMNAME,MEMPHONE</segCodeFilter>
					<memType>PERSON</memType>
					<getType><xsl:value-of select="$GETTYPE"/></getType>
					<segAttrFilter xsi:nil="true"/>
					<srcCodeFilter xsi:nil="true"/>
					<memStatFilter xsi:nil="true"/>
					<xsl:choose>
						<xsl:when test="MPIID!=''">
							<srcCode xsi:nil="true"/>
						</xsl:when>
						<xsl:otherwise>
							<srcCode>
								<xsl:value-of select="AssigningAuthority"/>
							</srcCode>
						</xsl:otherwise>
					</xsl:choose>
					<keySortOrder>+getSrcCode,-getMemIdnum</keySortOrder>
					<entType>id</entType>
					<memRecno xsi:nil="true"/>
	            </memGetReq>
	         </getMember>

	      </soapenv:Body>
	   </soapenv:Envelope>

	</xsl:template>

</xsl:stylesheet>
