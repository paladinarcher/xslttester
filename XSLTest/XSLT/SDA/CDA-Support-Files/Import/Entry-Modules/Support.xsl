<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Support">
		<xsl:if test="hl7:participant[@typeCode='IND']">
			<NextOfKin>
				<!-- Process CDA Append/Transform/Replace Directive -->
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'NextOfKin'"/>
				</xsl:call-template>
				
				<xsl:apply-templates select="hl7:participant[@typeCode='IND']" mode="NextOfKin"/>
			</NextOfKin>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="NextOfKin">
		<NextOfKin>
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Contact Name -->
			<xsl:apply-templates select="hl7:associatedEntity/hl7:associatedPerson/hl7:name" mode="ContactName"/>
			
			<!-- Contact Relationship -->
			<xsl:apply-templates select="hl7:associatedEntity/hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Relationship'"/>
			</xsl:apply-templates>

			<!-- Contact Type -->
			<xsl:apply-templates select="hl7:associatedEntity" mode="ContactType"/>
			
			<!-- Address (only one address supported by SDA today) -->
			<xsl:apply-templates select="hl7:associatedEntity/hl7:addr[1]" mode="Address"/>
			
			<!-- Contact Info -->
			<xsl:apply-templates select="hl7:associatedEntity" mode="ContactInfo"/>
		</NextOfKin>
	</xsl:template>
	
	<xsl:template match="*" mode="ContactType">
		<ContactType>
			<Code>
				<xsl:choose>
					<xsl:when test="@classCode = 'AGNT'"><xsl:text>F</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'CAREGIVER'"><xsl:text>O</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'ECON'"><xsl:text>C</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'GUARD'"><xsl:text>S</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'NOK'"><xsl:text>N</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'PRS'"><xsl:text>U</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>U</xsl:text></xsl:otherwise>
				</xsl:choose>
			</Code>
			<Description>
				<xsl:choose>
					<xsl:when test="@classCode = 'AGNT'"><xsl:text>Federal Agency</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'CAREGIVER'"><xsl:text>Other</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'ECON'"><xsl:text>Emergency Contact</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'GUARD'"><xsl:text>State Agency</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'NOK'"><xsl:text>Next-of-Kin</xsl:text></xsl:when>
					<xsl:when test="@classCode = 'PRS'"><xsl:text>Unknown</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>Unknown</xsl:text></xsl:otherwise>
				</xsl:choose>
			</Description>
		</ContactType>
	</xsl:template>
</xsl:stylesheet>
