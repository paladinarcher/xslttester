<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="nextOfKin">
		<xsl:apply-templates select="NextOfKin/NextOfKin" mode="participant-NextOfKin"/>
	</xsl:template>

	<xsl:template match="NextOfKin" mode="participant-NextOfKin">
		<participant typeCode="IND">			
			<xsl:call-template name="templateIds-NextOfKinParticipant"/>
			
			<!-- IHE supplemental templates (currently Spouse or Father only) -->
			<xsl:variable name="ihe-PCC-SupplementalTemplate">
				<xsl:choose>
					<xsl:when test="Relationship/Code/text() = 'SPO'"><xsl:value-of select="$ihe-PCC_CDASupplement-Spouse"/></xsl:when>
					<xsl:when test="Relationship/Code/text() = 'FTH'"><xsl:value-of select="$ihe-PCC_CDASupplement-NaturalFatherOfFetus"/></xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="string-length($ihe-PCC-SupplementalTemplate)"><templateId root="{$ihe-PCC-SupplementalTemplate}"/></xsl:if>

			<!-- According to CCD, this should represent the time during which the NextOfKin provides support.  Not known in SDA. -->
			<time nullFlavor="UNK"/>

			<!-- Here, the address will always be constructed as Work-Primary since SDA doesn't have an addressUse field.  We should fix this. -->
			<xsl:apply-templates select="." mode="associatedEntity">
				<xsl:with-param name="contactType">
					<xsl:choose>
						<xsl:when test="ContactType/Code/text() = 'F'"><xsl:text>AGNT</xsl:text></xsl:when>
						<xsl:when test="ContactType/Code/text() = 'C'"><xsl:text>ECON</xsl:text></xsl:when>
						<xsl:when test="ContactType/Code/text() = 'N'"><xsl:text>NOK</xsl:text></xsl:when>
						<xsl:when test="ContactType/Code/text() = 'O'"><xsl:text>CAREGIVER</xsl:text></xsl:when>
						<xsl:when test="ContactType/Code/text() = 'S'"><xsl:text>GUARD</xsl:text></xsl:when>
						<xsl:when test="ContactType/Code/text() = 'U'"><xsl:text>PRS</xsl:text></xsl:when>
						<xsl:otherwise><xsl:text>PRS</xsl:text></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:apply-templates>
		</participant>
	</xsl:template>

	<xsl:template name="templateIds-NextOfKinParticipant">
		<xsl:if test="string-length($hitsp-CDA-Support)"><templateId root="{$hitsp-CDA-Support}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-PatientContacts)"><templateId root="{$ihe-PCC-PatientContacts}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
