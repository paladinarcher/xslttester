<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="SocialHistory">
		<SocialHistory>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- From and To Time -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high" mode="ToTime"/>

			<!-- Social Habit -->
			<xsl:apply-templates select="." mode="SocialHabitDescription"/>
			
			<!-- Social Habit Quantity -->
			<xsl:apply-templates select="." mode="SocialHabitQuantity"/>
			
			<!-- Social History Status -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="SocialHistoryStatus"/>
			
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment">
				<xsl:with-param name="elementName" select="'SocialHabitComments'"/>
			</xsl:apply-templates>
		</SocialHistory>
	</xsl:template>
	
	<xsl:template match="*" mode="SocialHabitQuantity">
		<xsl:variable name="quantityText">
			<xsl:choose>
				<xsl:when test="hl7:value/@value and hl7:value/@unit">
					<xsl:value-of select="concat(hl7:value/@value,' ',hl7:value/@unit)"/>
				</xsl:when>
				<xsl:when test="hl7:value/@code and hl7:value/@displayName">
					<xsl:value-of select="hl7:value/@displayName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="hl7:value/text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="quantityCode">
			<xsl:choose>
				<xsl:when test="hl7:value/@value and hl7:value/@unit">
					<xsl:value-of select="concat(hl7:value/@value,' ',hl7:value/@unit)"/>
				</xsl:when>
				<xsl:when test="hl7:value/@code">
					<xsl:value-of select="hl7:value/@code"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="hl7:value/text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="quantityCodeSystem">
			<xsl:if test="hl7:value/@code and hl7:value/@codeSystem">
				<xsl:value-of select="hl7:value/@codeSystem"/>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="hl7:value">
			<SocialHabitQty>
				<Code><xsl:value-of select="$quantityCode"/></Code>
				<Description><xsl:value-of select="$quantityText"/></Description>
				<xsl:if test="string-length($quantityCodeSystem)">
					<SDACodingStandard>
						<xsl:value-of select="isc:evaluate('getCodeForOID', $quantityCodeSystem, 'CodeSystem')"/>
					</SDACodingStandard>
				</xsl:if>
				<xsl:apply-templates select="." mode="SocialHabitDescription"/>
			</SocialHabitQty>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="SocialHabitDescription">
		<xsl:choose>
			<xsl:when test="(hl7:code/@code) or (hl7:code/hl7:translation[1]/@codeSystem=$noCodeSystemOID) or (hl7:code/@nullFlavor and hl7:code/hl7:translation[1]/@code)">
				<xsl:apply-templates select="hl7:code" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'SocialHabit'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:text" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'SocialHabit'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="SocialHistoryStatus">
		<xsl:if test="@code">
			<Status>
				<xsl:choose>
					<xsl:when test="@code = '55561003'"><xsl:text>A</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>I</xsl:text></xsl:otherwise>
				</xsl:choose>
			</Status>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>