<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:include href="InformationSource.xsl"/>
	<xsl:include href="LanguageSpoken.xsl"/>
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="PersonalInformation">
		<!-- Process CDA Append/Transform/Replace Directive -->
		<xsl:call-template name="ActionCode"><xsl:with-param name="informationType">Patient</xsl:with-param></xsl:call-template>
		
		<!-- Information Source module -->
		<xsl:apply-templates select="/hl7:ClinicalDocument" mode="InformationSource"/>

		<!-- Patient Name -->
		<xsl:apply-templates select="hl7:patient/hl7:name" mode="ContactName"/>
		
		<!-- Gender -->
		<xsl:apply-templates select="hl7:patient/hl7:administrativeGenderCode" mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'Gender'"/>
		</xsl:apply-templates>

		<!-- Marital Status -->
		<xsl:apply-templates select="hl7:patient/hl7:maritalStatusCode" mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'MaritalStatus'"/>
		</xsl:apply-templates>
		
		<!-- Religion -->
		<xsl:apply-templates select="hl7:patient/hl7:religiousAffiliationCode" mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'Religion'"/>
		</xsl:apply-templates>

		<!-- Birth Time -->
		<xsl:apply-templates select="hl7:patient/hl7:birthTime" mode="BirthTime"/>
		
		<!-- Race -->
		<xsl:apply-templates select="hl7:patient/hl7:raceCode" mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'Race'"/>
		</xsl:apply-templates>
		
		<!-- Language Module -->
		<xsl:apply-templates select="hl7:patient" mode="LanguageSpoken"/>

		<!-- Patient Numbers -->
		<xsl:apply-templates select="." mode="PatientNumbers"/>
		
		<!-- Patient Addresses -->
		<xsl:apply-templates select="." mode="Addresses"/>
		
		<!-- Patient Contact Info -->
		<xsl:apply-templates select="." mode="ContactInfo"/>
	</xsl:template>

	<xsl:template match="*" mode="PatientNumbers">
		<PatientNumber>
			<PatientNumber>
				<Number><xsl:value-of select="hl7:id/@extension"/></Number>
				<Organization>
					<Code><xsl:value-of select="isc:evaluate('getCodeForOID', hl7:id/@root, 'AssigningAuthority')"/></Code>
					<Description><xsl:value-of select="isc:evaluate('getDescriptionForOID', hl7:id/@root, 'AssigningAuthority')"/></Description>
				</Organization>
				<NumberType>MRN</NumberType>
			</PatientNumber>
		</PatientNumber>
	</xsl:template>

	<xsl:template match="*" mode="BirthTime">
		<BirthTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></BirthTime>
	</xsl:template>
</xsl:stylesheet>
