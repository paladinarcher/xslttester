<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:hl7="urn:hl7-org:v3"
				xmlns="urn:hl7-org:v3"
				xmlns:mif="urn:hl7-org:v3/mif"
				xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Dig out the patient's MRN and the assigning facility -->
	<xsl:template match="hl7:id[@root='2.16.840.1.113883.3.86.3.1.21']">
		<MRN><xsl:value-of select="@extension"/></MRN>
		<Facility><xsl:value-of select="@assigningAuthorityName"/></Facility>
	</xsl:template>
	
	<xsl:template match="hl7:rankOrScore">
		<RankOrScore><xsl:value-of select="@value"/></RankOrScore>
	</xsl:template>

	<xsl:template match="hl7:assigningOrganization">
		<Gateway><xsl:value-of select="hl7:contactParty/hl7:telecom/@value"/></Gateway>
		<MPIID><xsl:value-of select="hl7:id/@extension"/></MPIID>
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
		<Street><xsl:value-of select="hl7:street"/></Street>
		<City><xsl:value-of select="hl7:city"/></City>
		<Zip><xsl:value-of select="hl7:postalCode"/></Zip>
		<State><xsl:value-of select="hl7:state"/></State>
	</xsl:template>
	
	<!-- Consent: HACK! -->
	<xsl:template match="hl7:subjectOf">
		<Consent><xsl:value-of select="isc:evaluate('decode',hl7:observationEvent/hl7:code/@displayName)"/></Consent>
	</xsl:template>

	<!-- Match a QUPA_IN101104 message -->
	<xsl:template match="/hl7:QUPA_IN101104">
		<PatientSearchResponse>
			<Results>
				<xsl:for-each select="hl7:controlActProcess/hl7:subject/hl7:target">
					<PatientSearchMatch>
						<xsl:apply-templates select="."/>
					</PatientSearchMatch>
				</xsl:for-each>
			</Results>
			<ConsentApplied>
				<!-- Another hack to grab the 'ConsentApplied' flag -->
				<xsl:value-of select="hl7:controlActProcess/hl7:informationRecipient/hl7:assignedPerson/hl7:telecom[@use='CA']"/>
			</ConsentApplied>
		</PatientSearchResponse>
	</xsl:template>

</xsl:stylesheet>

