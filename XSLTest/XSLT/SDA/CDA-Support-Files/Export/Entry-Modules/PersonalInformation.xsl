<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="personInformation">
		<recordTarget>
			<patientRole>
				<!-- Patient ID -->
				<xsl:apply-templates select="." mode="id-Patient"/>

				<!-- Addresses -->
				<xsl:apply-templates select="." mode="address-Person"/>
								
				<!-- Telecoms -->
				<xsl:apply-templates select="." mode="telecom"/>
				
				<patient>
					<!-- Name -->
					<xsl:apply-templates select="." mode="name-Person"/>
					
					<!-- Gender -->
					<xsl:apply-templates select="." mode="code-administrativeGender"/>

					<!-- Date of Birth -->
					<xsl:apply-templates select="BirthTime" mode="birthTime"/>
					
					<!-- Marital Status -->
					<xsl:apply-templates select="MaritalStatus" mode="code-maritalStatus"/>
					
					<!-- Religion -->
					<xsl:apply-templates select="Religion" mode="code-religiousAffiliation"/>

					<!-- Race Code -->
					<xsl:apply-templates select="Race" mode="code-race"/>

					<!-- Languages Spoken -->
					<xsl:apply-templates select="." mode="languagesSpoken"/>
				</patient>
			</patientRole>
		</recordTarget>
	</xsl:template>
	
	<xsl:template match="Patient" mode="id-Patient">
		<xsl:variable name="assigningAuthority">
			<xsl:choose>
				<xsl:when test="MPIID"><xsl:value-of select="$homeCommunityOID"/></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="PatientNumber/PatientNumber[NumberType/text() = 'MRN'][1]/Organization/Code" mode="code-to-oid"><xsl:with-param name="identityType" select="'AssigningAuthority'"/></xsl:apply-templates></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="patientIdentifier">
			<xsl:choose>
				<xsl:when test="MPIID"><xsl:value-of select="MPIID/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="PatientNumber/PatientNumber[NumberType/text() = 'MRN'][1]/Number/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- The presence of a comma (,) indicates that multiple MPIIDs are being reported for the patient.  In this case, we "mask" the IDs since we can't report a single one. -->
		<xsl:choose>
			<xsl:when test="contains($patientIdentifier, ',')"><id nullFlavor="MSK"/></xsl:when>
			<xsl:when test="not(string-length($assigningAuthority) and string-length($patientIdentifier))"><id nullFlavor="UNK"/></xsl:when>
			<xsl:when test="string-length($assigningAuthority) and string-length($patientIdentifier)"><id root="{$assigningAuthority}" extension="{$patientIdentifier}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="NI"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="BirthTime" mode="birthTime">
		<birthTime>
			<xsl:attribute name="value"><xsl:apply-templates select="." mode="xmlToHL7TimeStamp"/></xsl:attribute>
		</birthTime>
	</xsl:template>
</xsl:stylesheet>
