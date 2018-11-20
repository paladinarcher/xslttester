<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Condition">
		<Problem>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation[@classCode='OBS' and @moodCode='EVN']" mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- From and To Time -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:high" mode="ToTime"/>

			<!-- Problem Details -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:text" mode="ProblemDetails"/>
			
			<!-- Problem -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Problem'"/>
			</xsl:apply-templates>

			<!-- Problem Type -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Category'"/>
			</xsl:apply-templates>

			<!-- Clinician -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:performer" mode="Clinician"/>
			
			<!-- Problem Status -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>

			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Problem>
	</xsl:template>

	<xsl:template match="*" mode="Diagnosis">
		<xsl:param name="diagnosisType"/>

		<Diagnosis>
			<!-- EnteredBy -->
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- Diagnosis -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Diagnosis'"/>
			</xsl:apply-templates>

			<!-- Diagnosis Type -->
			<xsl:call-template name="DiagnosisType"><xsl:with-param name="diagnosisType" select="$diagnosisType"/></xsl:call-template>
			
			<!-- Clinician -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:performer" mode="DiagnosingClinician"/>

			<!-- Identification Time -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime" mode="IdentificationTime"/>
			
			<!-- Diagnosis Status -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Status'"/>
			</xsl:apply-templates>
			
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Diagnosis>
	</xsl:template>

	<xsl:template match="*" mode="IdentificationTime">
		<xsl:choose>
			<xsl:when test="@value"><IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></IdentificationTime></xsl:when>
			<xsl:when test="hl7:low/@value"><IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:low/@value)"/></IdentificationTime></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="ProblemDetails">
		<ProblemDetails><xsl:apply-templates select="." mode="TextValue"/></ProblemDetails>
	</xsl:template>

	<xsl:template name="DiagnosisType">
		<xsl:param name="diagnosisType"/>
		
		<xsl:if test="string-length($diagnosisType)">
			<DiagnosisType>
				<Code><xsl:value-of select="substring-before($diagnosisType, '|')"/></Code>
				<Description><xsl:value-of select="substring-after($diagnosisType, '|')"/></Description>
			</DiagnosisType>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
