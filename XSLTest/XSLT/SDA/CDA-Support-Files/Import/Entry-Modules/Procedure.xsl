<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Procedure">
		<Procedure>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Procedure -->
			<xsl:apply-templates select="hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Procedure'"/>
			</xsl:apply-templates>

			<!-- Procedure Time -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="ProcedureTime"/>

			<!-- Clinician -->
			<xsl:apply-templates select="hl7:performer" mode="Clinician"/>
		</Procedure>
	</xsl:template>
	
	<xsl:template match="*" mode="ProcedureTime">
		<ProcedureTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ProcedureTime>
	</xsl:template>
</xsl:stylesheet>
