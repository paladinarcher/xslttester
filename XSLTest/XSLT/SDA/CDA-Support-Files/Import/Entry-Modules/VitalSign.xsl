<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="VitalSign">
		<xsl:apply-templates select="hl7:organizer/hl7:component/hl7:observation" mode="VitalSignDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="VitalSignDetail">
		<Observation>
			<!-- EnteredBy -->
			<xsl:apply-templates select="parent::node()/parent::node()" mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="parent::node()/parent::node()" mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="parent::node()/parent::node()/hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Clinician -->
			<xsl:apply-templates select="hl7:performer" mode="Clinician"/>
			
			<!-- Observation Time -->
			<xsl:apply-templates select="hl7:effectiveTime" mode="ObservationTime"/>
			
			<!-- Observation Identifier -->
			<xsl:apply-templates select="hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'ObservationCode'"/>
			</xsl:apply-templates>
			
			<!-- Observation Value -->
			<xsl:apply-templates select="hl7:value" mode="ObservationValue"/>
			
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Observation>
	</xsl:template>
	
	<xsl:template match="*" mode="ObservationValue">
		<ObservationValue>
			<xsl:choose>
				<xsl:when test="@xsi:type = 'PQ'">
					<xsl:choose>
						<xsl:when test="string-length(@unit)"><xsl:value-of select="concat(@value, ' ', @unit)"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
					</xsl:choose>							
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
			</xsl:choose>
		</ObservationValue>
	</xsl:template>

	<xsl:template match="*" mode="ObservationTime">
		<ObservationTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ObservationTime>
	</xsl:template>
</xsl:stylesheet>
