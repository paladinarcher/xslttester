<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:hl7="urn:hl7-org:v3"
				xmlns:mif="urn:hl7-org:v3/mif"
				xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Dig out the patient's MRN and the assigning facility -->
	<xsl:template match="hl7:id[@root='2.16.840.1.113883.3.86.3.1.21']">
		<MRN><xsl:value-of select="@extension"/></MRN>
		<Facility><xsl:value-of select="@assigningAuthorityName"/></Facility>
	</xsl:template>

	<xsl:template match="hl7:assigningOrganization">
		<!-- <Facility><xsl:value-of select="hl7:id/@extension"/></Facility> -->
	</xsl:template>

	<!-- Patient -->
	<xsl:template match="hl7:identifiedPerson">
		<FirstName><xsl:value-of select="hl7:name/hl7:given"/></FirstName>
		<LastName><xsl:value-of select="hl7:name/hl7:family"/></LastName>
		<Sex><xsl:value-of select="hl7:administrativeGenderCode/@code"/></Sex>
		<DOB><xsl:value-of select="hl7:birthTime/@value"/></DOB>
	</xsl:template>
	
	<!-- Address -->
	<xsl:template match="hl7:addr">
		<Street><xsl:value-of select="hl7:address"/></Street>
		<City><xsl:value-of select="hl7:city"/></City>
		<Zip><xsl:value-of select="hl7:postalCode"/></Zip>
		<State><xsl:value-of select="hl7:state"/></State>
	</xsl:template>

	<!-- Patient -->
	<xsl:template match="hl7:subject1/hl7:identifiedPerson">
		<xsl:apply-templates select="hl7:id"/>
		<xsl:apply-templates select="hl7:assigningOrganization"/>
		<xsl:apply-templates select="hl7:identifiedPerson"/>
		<xsl:apply-templates select="hl7:addr"/>
	</xsl:template>

	<!-- Match a PRPA_IN101001 message -->
	<xsl:template match="/hl7:PRPA_IN101001">
		<AddPatientRequest>
			<xsl:apply-templates
				 select="hl7:controlActProcess/hl7:subject/hl7:registrationEvent/hl7:subject1"/>
		</AddPatientRequest>
	</xsl:template>

</xsl:stylesheet>

