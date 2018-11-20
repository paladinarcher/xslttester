<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="HealthFund">
		<HealthFund>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Effective Date -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:low[not(@nullFlavor)]" mode="EffectiveDate"/>

			<!-- Expiration Date -->
			<xsl:apply-templates select="hl7:effectiveTime/hl7:high[not(@nullFlavor)]" mode="ExpirationDate"/>

			<!-- Health Plan Details -->
			<xsl:apply-templates select=".//hl7:act[hl7:templateId/@root=$payerPlanDetailsImportConfiguration]" mode="HealthPlanDetail"/>			
		</HealthFund>
	</xsl:template>
	
	<xsl:template match="*" mode="EffectiveDate">
		<EffectiveDate><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></EffectiveDate>
	</xsl:template>
	
	<xsl:template match="*" mode="ExpirationDate">
		<ExpirationDate><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ExpirationDate>
	</xsl:template>

	<xsl:template match="*" mode="HealthPlanDetail">
		<!-- Plan ID -->
		<xsl:apply-templates select="hl7:participant[@typeCode='COV']/hl7:participantRole/hl7:id[not(@nullFlavor)]" mode="PlanId"/>
		
		<!-- Plan Type -->
		<xsl:apply-templates select="hl7:code" mode="Code-HealthPlanType"/>
		
		<!-- Insured Person -->
		<xsl:apply-templates select="hl7:participant[@typeCode='HLD']/hl7:participantRole" mode="PolicyHolder"/>
		
		<!-- Insured Relationship -->
		<xsl:apply-templates select="hl7:participant[@typeCode='COV']/hl7:participantRole" mode="PolicyHolderRelationship"/>
		
		<!-- Membership Number -->
		<xsl:apply-templates select="hl7:participant[@typeCode='COV']/hl7:participantRole/hl7:id[not(@nullFlavor)]" mode="MembershipNumber"/>
	</xsl:template>
	
	<xsl:template match="*" mode="Code-HealthPlanType">
		<PlanType>
			<xsl:choose>
				<xsl:when test="string-length(@code)"><xsl:value-of select="@code"/></xsl:when>
				<xsl:when test="string-length(@displayName)"><xsl:value-of select="@displayName"/></xsl:when>
				<xsl:when test="string-length(originalText/text())"><xsl:value-of select="originalText/text()"/></xsl:when>
			</xsl:choose>
		</PlanType>
	</xsl:template>

	<xsl:template match="*" mode="PlanId">
		<xsl:variable name="healthPlanCode" select="isc:evaluate('getCodeForOID', @root, 'AssigningAuthority')"/>
		<xsl:variable name="healthPlanDescription" select="isc:evaluate('getDescriptionForOID', @root, 'AssigningAuthority')"/>
		
		<HealthFund>
			<Code><xsl:value-of select="$healthPlanCode"/></Code>
			<Description><xsl:value-of select="$healthPlanDescription"/></Description>
		</HealthFund>
		
		<HealthFundPlan>
			<Code><xsl:value-of select="$healthPlanCode"/></Code>
			<Description><xsl:value-of select="$healthPlanDescription"/></Description>
			<HealthFund>
				<Code><xsl:value-of select="$healthPlanCode"/></Code>
				<Description><xsl:value-of select="$healthPlanDescription"/></Description>
			</HealthFund>
		</HealthFundPlan>
	</xsl:template>

	<xsl:template match="*" mode="PolicyHolder">
		<xsl:if test="hl7:playingEntity/hl7:name"><xsl:apply-templates select="hl7:playingEntity/hl7:name" mode="ContactName"><xsl:with-param name="elementName" select="'InsuredName'"/></xsl:apply-templates></xsl:if>
		<xsl:apply-templates select="hl7:addr" mode="Address"><xsl:with-param name="elementName" select="'InsuredAddress'"/></xsl:apply-templates>
		<xsl:apply-templates select="." mode="ContactInfo"><xsl:with-param name="elementName" select="'InsuredContact'"/></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="PolicyHolderRelationship">
		<xsl:apply-templates select="hl7:code" mode="CodeTable">
			<xsl:with-param name="hsElementName">InsuredRelationship</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="MembershipNumber">
		<MembershipNumber><xsl:value-of select="@extension"/></MembershipNumber>
	</xsl:template>
	
</xsl:stylesheet>