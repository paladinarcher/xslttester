<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:isc="http://extension-functions.intersystems.com"
	xmlns:hl7="urn:hl7-org:v3"
	xmlns:sdtc="urn:hl7-org:sdtc"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:exsl="http://exslt.org/common"
	exclude-result-prefixes="isc hl7 sdtc xsi exsl">
	
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HITSP.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-HL7.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Templates/TemplateIdentifiers-IHE.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-InterSystems.xsl"/>
	<xsl:include href="CDA-Support-Files/System/OIDs/OIDs-Other.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/String-Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/System/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Common/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/ImportProfile.xsl"/>
	<xsl:include href="CDA-Support-Files/Site/Variables.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/Comment.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/PersonalInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Import/Entry-Modules/XDLAB/Result.xsl"/>
	
	<xsl:include href="CDA-Support-Files/Import/Section-Modules/XDLAB/DiagnosticResults.xsl"/>
	
	<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
	
	<!-- Canonicalize the SDA output -->
	<xsl:template match="/">
		<xsl:variable name="firstPass"><xsl:apply-templates select="/hl7:ClinicalDocument"/></xsl:variable>
		<xsl:apply-templates select="exsl:node-set($firstPass)" mode= "Canonicalize"/>
	</xsl:template>
	
	<xsl:template match="/hl7:ClinicalDocument">
		<Container>
			<!-- Sending Facility -->
			<xsl:variable name="sendingFacility"><xsl:apply-templates select="." mode="SendingFacilityValue"/></xsl:variable>
			<xsl:if test="string-length($sendingFacility)">
				<SendingFacility><xsl:value-of select="$sendingFacility"/></SendingFacility>
			</xsl:if>
			
			<Patient>
				<!-- Personal Information -->
				<xsl:apply-templates select="hl7:recordTarget/hl7:patientRole" mode="PersonalInformation"/>
			</Patient>
			
			<!-- Diagnostic Results -->
			<xsl:apply-templates select="." mode="ResultsSection"/>
			
			<!-- Custom import -->
			<xsl:apply-templates select="." mode="ImportCustom-Container"/>
		</Container>
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
	
	<!-- This empty template may be overridden with custom logic. -->
	<xsl:template match="*" mode="ImportCustom-Container">
	</xsl:template>	
</xsl:stylesheet>
