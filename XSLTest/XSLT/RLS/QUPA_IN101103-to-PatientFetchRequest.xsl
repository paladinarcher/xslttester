<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:hl7="urn:hl7-org:v3"
				xmlns="urn:hl7-org:v3"
				xmlns:mif="urn:hl7-org:v3/mif"
				xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Dig out the patient's MRN and the assigning facility -->
	<xsl:template match="hl7:person.id[hl7:value/@root='2.16.840.1.113883.3.86.3.1.21']">
		<Facility><xsl:value-of select="hl7:value/@assigningAuthorityName"/></Facility>
		<MRN><xsl:value-of select="hl7:value/@extension"/></MRN>
	</xsl:template>
	
	<xsl:template match="hl7:controlActProcess/hl7:queryByParameter/hl7:queryByParameterPayload">
		<xsl:apply-templates select="hl7:person.id"/>
	</xsl:template>

	<!-- Match a QUPA_IN101103 message -->
	<xsl:template match="/hl7:QUPA_IN101103">
		<PatientFetchRequest>
			<xsl:apply-templates
				 select="hl7:controlActProcess/hl7:queryByParameter/hl7:queryByParameterPayload"/>
		</PatientFetchRequest>
	</xsl:template>

</xsl:stylesheet>

