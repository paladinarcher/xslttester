<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Plan">
		<Order>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:effectiveTime" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Entering Organization -->
			<xsl:apply-templates select="." mode="EnteringOrganization"/>
			
			<!-- Start and End Time -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="StartTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="EndTime"/>
		
			<!-- Placer and Filler IDs -->
			<xsl:apply-templates select="." mode="PlacerId"/>
			<xsl:apply-templates select="." mode="FillerId"/>
			
			<!-- Order Item -->
			<xsl:apply-templates select="hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'OrderItem'"/>
				<xsl:with-param name="hsOrderType" select="'OTH'"/>
			</xsl:apply-templates>

			<!-- Order Status -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="PlanStatus"/>
 						
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Order>
	</xsl:template>
	
	<xsl:template match="*" mode="PlanStatus">
		<xsl:if test="@code">
			<Status>
				<xsl:choose>
					<xsl:when test="@code = '55561003'"><xsl:text>A</xsl:text></xsl:when>
					<xsl:when test="@code = '421139008'"><xsl:text>H</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>I</xsl:text></xsl:otherwise>
				</xsl:choose>
			</Status>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
