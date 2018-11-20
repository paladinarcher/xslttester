<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="languagesSpoken">
		<xsl:apply-templates select="PrimaryLanguage" mode="languageCommunication"/>		
		<xsl:apply-templates select="OtherLanguages/PatientLanguage" mode="languageCommunication"/>		
	</xsl:template>
	
	<xsl:template match="PrimaryLanguage" mode="languageCommunication">
		<languageCommunication>
			<xsl:if test="string-length($hitsp-CDA-LanguageSpoken)"><templateId root="{$hitsp-CDA-LanguageSpoken}"/></xsl:if>
			<xsl:if test="string-length($ihe-PCC-LanguageCommunication)"><templateId root="{$ihe-PCC-LanguageCommunication}"/></xsl:if>
			
			<languageCode code="{Code/text()}"/>
			<preferenceInd value="true"/>
		</languageCommunication>
	</xsl:template>

	<xsl:template match="PatientLanguage" mode="languageCommunication">
		<languageCommunication>
			<xsl:if test="string-length($hitsp-CDA-LanguageSpoken)"><templateId root="{$hitsp-CDA-LanguageSpoken}"/></xsl:if>
			<xsl:if test="string-length($ihe-PCC-LanguageCommunication)"><templateId root="{$ihe-PCC-LanguageCommunication}"/></xsl:if>
			
			<languageCode code="{PreferredLanguage/Code/text()}"/>
			<preferenceInd value="false"/>
		</languageCommunication>
	</xsl:template>
</xsl:stylesheet>
