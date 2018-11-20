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

	<!-- Person's name -->
	<xsl:template match="hl7:person.name">
		<FirstName><xsl:value-of select="hl7:value/hl7:given"/></FirstName>
		<LastName><xsl:value-of select="hl7:value/hl7:family"/></LastName>
	</xsl:template>
	
	<!-- Address -->
	<xsl:template match="hl7:person.addr">
		<Street><xsl:value-of select="hl7:value/hl7:street"/></Street>
		<City><xsl:value-of select="hl7:value/hl7:city"/></City>
		<Zip><xsl:value-of select="hl7:value/hl7:postalCode"/></Zip>
		<State><xsl:value-of select="hl7:value/hl7:state"/></State>
	</xsl:template>
	
	<!-- Gender -->
	<xsl:template match="hl7:person.administrativeGender[hl7:value/@codeSystem='2.16.840.1.113883.5.1']">
		<Sex><xsl:value-of select="hl7:value/@code"/></Sex>
	</xsl:template>

	<!-- DOB -->
	<xsl:template match="hl7:person.birthTime">
		<DOB><xsl:value-of select="hl7:value/@value"/></DOB>
	</xsl:template>
	
	<!-- Request info -->
	<xsl:template match="hl7:assignedPerson">
		<RequestingUser><xsl:value-of select="hl7:id/@extension"/></RequestingUser>
		<RequestingUserRoles><xsl:value-of select="hl7:code/@code"/></RequestingUserRoles>
	</xsl:template>

	<!-- Match a QUPA_IN101103 message -->
	<xsl:template match="/hl7:QUPA_IN101103">
		<PatientSearchRequest>
			<xsl:apply-templates
				 select="hl7:controlActProcess/hl7:authorOrPerformer"/>
			<xsl:apply-templates
				 select="hl7:controlActProcess/hl7:queryByParameter/hl7:queryByParameterPayload"/>
		</PatientSearchRequest>
	</xsl:template>

</xsl:stylesheet>

