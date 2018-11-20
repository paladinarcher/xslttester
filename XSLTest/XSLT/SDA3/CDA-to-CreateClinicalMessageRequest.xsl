<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:isc="http://extension-functions.intersystems.com"
	xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:exsl="http://exslt.org/common"
	exclude-result-prefixes="isc hl7 sdtc xsi exsl">
	
	<xsl:include href="CDA-Support-Files/System/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/ImportProfile.xsl"/>

	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/PersonalInformation.xsl"/>
	
	<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
	
	<!-- Canonicalize the SDA output -->
	<xsl:template match="/">
		<xsl:variable name="firstPass"><xsl:apply-templates select="/hl7:ClinicalDocument"/></xsl:variable>
		<xsl:apply-templates select="exsl:node-set($firstPass)" mode= "Canonicalize"/>
	</xsl:template>
	
	<!--
		The CDA format of the information required by this transform
		is common to HITSP/C83 and Consolidated CDA (C-CDA). Therefore
		this transform can handle documents of either type.
	-->
	<xsl:template match="/hl7:ClinicalDocument">
		<CreateClinicalMessageRequest>
			<!-- Sending Facility OID - SendingFacilityOID template is in Common/Functions.xsl -->
			<xsl:variable name="sendingFacilityOID">
				<xsl:apply-templates select="." mode="SendingFacilityOID"/>
			</xsl:variable>
			<xsl:if test="string-length($sendingFacilityOID)">
				<FacilityOID><xsl:value-of select="$sendingFacilityOID"/></FacilityOID>
			</xsl:if>
			
			<!-- MRN and Assigning Authority OID - MRNAndAAOID template is in PersonalInformation.xsl -->
			<xsl:variable name="patientNumbersInfo">
				<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole" mode="MRNAndAAOID"/>
			</xsl:variable>
			<xsl:if test="string-length(substring-before($patientNumbersInfo,'|'))">
				<AssigningAuthorityOID><xsl:value-of select="substring-before($patientNumbersInfo,'|')"/></AssigningAuthorityOID>
			</xsl:if>
			<xsl:if test="string-length(substring-after($patientNumbersInfo,'|'))">
				<MRN><xsl:value-of select="substring-after($patientNumbersInfo,'|')"/></MRN>
			</xsl:if>
			
			<!-- Patient Name - ContactName template is in Common/Functions.xsl -->
			<xsl:variable name="contactNameInfo">
				<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name" mode="ContactName"/>
			</xsl:variable>
			<xsl:variable name="contactName" select="exsl:node-set($contactNameInfo)/Name"/>
			<xsl:choose>
				<xsl:when test="string-length($contactName/GivenName/text())">
					<PatientName><xsl:value-of select="concat($contactName/FamilyName/text(), ',', $contactName/GivenName/text())"/></PatientName>
				</xsl:when>
				<xsl:when test="string-length($contactName/FamilyName/text()) and not(string-length($contactName/GivenName/text()))">
					<PatientName><xsl:value-of select="concat($contactName/FamilyName/text())"/></PatientName>
				</xsl:when>
			</xsl:choose>
			
			<!-- Address - AddressType template is in Common/Functions.xsl -->
			<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole/hl7:addr[not(@nullFlavor)][1]" mode="AddressType"/>
			
			<!-- Sex - CodeTable template is in Common/Functions.xsl -->
			<xsl:variable name="sexInfo">
				<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'Gender'"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="sex" select="exsl:node-set($sexInfo)/Gender"/>
			<xsl:if test="string-length($sex/Code/text())">
				<Sex><xsl:value-of select="$sex/Code/text()"/></Sex>
			</xsl:if>
			
			<!-- Birth Time - BirthTime template is in PersonalInformation.xsl -->
			<xsl:variable name="dobInfo">
				<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime" mode="BirthTime"/>
			</xsl:variable>
			<xsl:variable name="dob" select="exsl:node-set($dobInfo)/BirthTime"/>
			<xsl:if test="string-length($dob/text())">
				<DOB><xsl:value-of select="$dob/text()"/></DOB>
			</xsl:if>
		</CreateClinicalMessageRequest>
	</xsl:template>
	
	<!-- At the top SDA level, insert the first element, then loop through the node sets of subsequent elements with the same name -->
	<xsl:template match="/Container/*" mode="Canonicalize"> 
		<xsl:variable name="elementName" select="local-name()"/>
		<xsl:if test="count(preceding-sibling::*[name()=$elementName])=0">
				<xsl:copy>
					<xsl:for-each select="self::* | following-sibling::*[name()=$elementName]">
						<xsl:apply-templates mode="Canonicalize"/> 
					</xsl:for-each>
				</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<!-- Copy all other SDA elements as is -->
	<xsl:template match="*" mode="Canonicalize"> 
		<xsl:copy>
			<xsl:apply-templates mode="Canonicalize"/> 
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
