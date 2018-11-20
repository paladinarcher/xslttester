<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="ext isc hl7 xsi exsl">

	<xsl:template match="*" mode="PersonalInformation-NEHTA">
		<!-- Deceased Indicator and Time -->
		<xsl:apply-templates select="hl7:patient/ext:deceasedInd[not(@nullFlavor)]" mode="deceased-indicator"/>
		<xsl:apply-templates select="hl7:patient/ext:deceasedTime[not(@nullFlavor)]" mode="deceased-time"/>
			
		<!-- Custom SDA Data-->
		<xsl:apply-templates select="." mode="ImportCustom-PersonalInformation-NEHTA"/>
	</xsl:template>
	
	<xsl:template match="*" mode="PatientNumbers">
		<!-- If there is no MRN in the document, import the IHI also as an MRN. -->
		<xsl:variable name="hasMRN">
			<xsl:apply-templates select="hl7:patient/ext:asEntityIdentifier" mode="checkPatientIdentifiers">
				<xsl:with-param name="identifierType" select="'MRN'"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<PatientNumbers>
			<xsl:apply-templates select="hl7:patient/ext:asEntityIdentifier" mode="PatientNumbers-asEntityIdentifier">
				<xsl:with-param name="hasMRN" select="$hasMRN"/>
			</xsl:apply-templates>
		</PatientNumbers>
	</xsl:template>
	
	<xsl:template match="*" mode="checkPatientIdentifiers">
		<xsl:param name="identifierType"/>
		
		<xsl:if test="@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and string-length(ext:id/@root)=37 and starts-with(ext:id/@root,$hiServiceOID) and substring(ext:id/@root,22,6)=$ihiPrefix and $identifierType='IHI'">1</xsl:if>
		<xsl:if test="@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and ext:id/@root=$hiServiceOID and string-length(ext:id/@extension)=16 and starts-with(ext:extension/@root,$ihiPrefix) and $identifierType='IHI'">1</xsl:if>
		<xsl:if test="@classCode='IDENT' and ext:code/@code='MR' and ext:code/@codeSystem='2.16.840.1.113883.12.203' and $identifierType='MRN'">1</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="PatientNumbers-asEntityIdentifier">
		<xsl:param name="hasMRN"/>
		
		<xsl:variable name="ihiNumber">
			<xsl:choose>
				<xsl:when test="@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and string-length(ext:id/@root)=37 and starts-with(ext:id/@root,$hiServiceOID) and substring(ext:id/@root,22,6)=$ihiPrefix">
					<xsl:value-of select="substring(ext:id/@root,22)"/>
				</xsl:when>
				<xsl:when test="@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and ext:id/@root=$hiServiceOID and string-length(ext:id/@extension)=16 and starts-with(ext:extension/@root,$ihiPrefix)">
					<xsl:value-of select="ext:extension/@root"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($ihiNumber)">
				<PatientNumber>
					<Number><xsl:value-of select="$ihiNumber"/></Number>
					<Organization>
						<Code><xsl:value-of select="$hiServiceOID"/></Code>
						<Description>HI Service</Description>
					</Organization>
					<NumberType>NI</NumberType>
				</PatientNumber>
				<xsl:if test="not(string-length($hasMRN))">
					<PatientNumber>
						<Number><xsl:value-of select="$ihiNumber"/></Number>
						<Organization>
							<Code><xsl:value-of select="$hiServiceOID"/></Code>
							<Description>HI Service</Description>
						</Organization>
						<NumberType>MRN</NumberType>
					</PatientNumber>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@classCode='IDENT' and ext:code/@code='MR' and ext:code/@codeSystem='2.16.840.1.113883.12.203'">
				<PatientNumber>
					<Number><xsl:value-of select="ext:id/@extension"/></Number>
					<Organization>
						<Code><xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="ext:id/@root"/></xsl:apply-templates></Code>
						<Description><xsl:value-of select="isc:evaluate('getDescriptionForOID', ext:id/@root, 'AssigningAuthority')"/></Description>
					</Organization>
					<NumberType>MRN</NumberType>
				</PatientNumber>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="deceased-indicator">
		<xsl:variable name="deathIndicator">
			<xsl:choose>
				<xsl:when test="@value='false'">0</xsl:when>
				<xsl:when test="@value='true'">1</xsl:when>
				<xsl:when test="number(@value)"><xsl:value-of select="number(@value)"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<IsDead><xsl:value-of select="$deathIndicator"/></IsDead>
	</xsl:template>
	
	<xsl:template match="*" mode="deceased-time">
		<DeathTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></DeathTime>
	</xsl:template>
		
	<!--
		This empty template may be overridden with custom logic.
		The input node spec is /hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole.
	-->
	<xsl:template match="*" mode="ImportCustom-PersonalInformation-NEHTA">
	</xsl:template>
</xsl:stylesheet>
