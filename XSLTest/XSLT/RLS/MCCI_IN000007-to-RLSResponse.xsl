<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:hl7="urn:hl7-org:v3"
				xmlns:mif="urn:hl7-org:v3/mif"
				xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Ack -->
	<xsl:template match="hl7:acknowledgement">
		
		<Accepted>
			<xsl:choose>
				<xsl:when test="hl7:typeCode/@code = 'AA'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</Accepted>
		
		<xsl:apply-templates select="hl7:acknowledgementDetail"/>		
	</xsl:template>

	<!-- Ack -->
	<xsl:template match="hl7:acknowledgementDetail">
		<xsl:apply-templates select="hl7:acknowledgementDetail"/>
		<Code><xsl:value-of select="hl7:typeCode/@code"/></Code>
		<Text><xsl:value-of select="hl7:text"/></Text>
	</xsl:template>

	<!-- Match a MCCI_IN000007 message -->
	<xsl:template match="/hl7:MCCI_IN000007">
		<RLSResponse>
			<xsl:apply-templates select="hl7:acknowledgement"/>
		</RLSResponse>
	</xsl:template>

</xsl:stylesheet>

