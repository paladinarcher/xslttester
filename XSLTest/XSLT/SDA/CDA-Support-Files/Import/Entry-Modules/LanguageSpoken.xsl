<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="LanguageSpoken">
		<!-- Primary Language -->
		<xsl:apply-templates select="hl7:languageCommunication[hl7:preferenceInd/@value = 'true']/hl7:languageCode" mode="Language"/>
		
		<!-- Other Languages -->
		<xsl:if test="hl7:languageCommunication[hl7:preferenceInd/@value != 'true']">
			<OtherLanguages>
				<xsl:apply-templates select="hl7:languageCommunication[hl7:preferenceInd/@value != 'true']/hl7:languageCode" mode="PatientLanguage"/>
			</OtherLanguages>
		</xsl:if>				
	</xsl:template>
	
	<xsl:template match="*" mode="Language">
		<xsl:param name="languageType" select="'PrimaryLanguage'"/>
		
		<xsl:apply-templates select="." mode="CodeTable">
			<xsl:with-param name="hsElementName" select="$languageType"/>
		</xsl:apply-templates>
	</xsl:template>	

	<xsl:template match="*" mode="PatientLanguage">
		<PatientLanguage>
			<xsl:apply-templates select="." mode="Language">
				<xsl:with-param name="languageType" select="'PreferredLanguage'"/>
			</xsl:apply-templates>
		</PatientLanguage>
	</xsl:template>
</xsl:stylesheet>
