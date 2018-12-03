<?xml version="1.0"?>
<!--

Filter and sort SDA container prior to exporting as CCDA

This is done using two passes. The first pass calculates various attributes
for each stremlet, then the second pass filters and sorts them. This is done
for a few reasons:

- centralize logic (e.g. determining which date field to use)
- avoid duplicate isc:evaluate calls (e.g. age checks for both min and max)
- allow the to-CCDA xsl to use precomputed fields

Each section support the following parameters:

- MaxAge: items older than this will be removed
- MinAge: items younger than this will be removed
- Count: maximum number of items to keep
- Codes: comma-separated list, items not in this list will be removed

Some sections may not use all these filters but they are here for consistency.

All parameters are optional and may be provided when invoking the XSLT. The 
MHV stylesheet overrides the defaults for some values (e.g. LabOrderMinAge).

All the included sections follow a similar boilerplate - see the Encounters
file for a repesentative example. Some will have extra logic to deal with 
things like grouping (e.g. vitals) and associated documents.

 -->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:isc="http://extension-functions.intersystems.com"
	xmlns:exsl="http://exslt.org/common"	
	exclude-result-prefixes="isc exsl">
	
	<xsl:include href="Sections/AdvanceDirectives.xsl"/>
	<xsl:include href="Sections/Alerts.xsl"/>
	<xsl:include href="Sections/Allergies.xsl"/>
	<xsl:include href="Sections/Appointments.xsl"/>
	<xsl:include href="Sections/CarePlans.xsl"/>
	<xsl:include href="Sections/ClinicalRelationships.xsl"/>
	<xsl:include href="Sections/Diagnoses.xsl"/>
	<xsl:include href="Sections/Documents.xsl"/>
	<xsl:include href="Sections/Encounters.xsl"/>
	<xsl:include href="Sections/FamilyHistories.xsl"/>
	<xsl:include href="Sections/GenomicsOrders.xsl"/>
	<xsl:include href="Sections/Goals.xsl"/>
	<xsl:include href="Sections/Guarantors.xsl"/>
	<xsl:include href="Sections/HealthConcerns.xsl"/>
	<xsl:include href="Sections/IllnessHistories.xsl"/>
	<xsl:include href="Sections/LabOrders.xsl"/>
	<xsl:include href="Sections/MedicalClaims.xsl"/>
	<xsl:include href="Sections/Medications.xsl"/>
	<xsl:include href="Sections/MemberEnrollments.xsl"/>
	<xsl:include href="Sections/Observations.xsl"/>
	<xsl:include href="Sections/OtherOrders.xsl"/>
	<xsl:include href="Sections/PhysicalExams.xsl"/>
	<xsl:include href="Sections/Problems.xsl"/>
	<xsl:include href="Sections/Procedures.xsl"/>
	<xsl:include href="Sections/ProgramMemberships.xsl"/>
	<xsl:include href="Sections/RadOrders.xsl"/>
	<xsl:include href="Sections/Referrals.xsl"/>
	<xsl:include href="Sections/SocialHistories.xsl"/>
	<xsl:include href="Sections/Vaccinations.xsl"/>
	
	<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>

	<xsl:variable name="_6months" select="183"/>
	<xsl:variable name="_12months" select="365"/>
	<xsl:variable name="_15months" select="458"/>
	<xsl:variable name="_18months" select="540"/>
	<xsl:variable name="_24months" select="730"/>
	<xsl:variable name="_36months" select="1096"/>
	
	<xsl:variable name="_from" select="$FromDate"/>
	<xsl:variable name="_thru" select="$ThruDate"/>
	
	<xsl:template match="/">
		<xsl:variable name="pass1"><xsl:apply-templates select="/Container" mode="pass1"/></xsl:variable>
 		<xsl:apply-templates select="exsl:node-set($pass1)" mode="pass2"/>
 	</xsl:template>
	
	<xsl:template match="*" mode="attributes">
		<xsl:param name="date"/>
		<xsl:param name="code" select="''"/>

		<xsl:attribute name="age"><xsl:value-of select="isc:evaluate('dateDiff','dd',translate($date,'TZ',' '))"/></xsl:attribute>
		<xsl:attribute name="date"><xsl:value-of select="$date"/></xsl:attribute>
		<xsl:attribute name="code"><xsl:value-of select="$code"/></xsl:attribute>
	</xsl:template>
  <xsl:template name="attribute-set">
    <xsl:param name="element" />
    <xsl:param name="attrName" />
    <xsl:param name="attrValue" />
    <xsl:for-each select="$element">
      <xsl:attribute name="{$attrName}">
        <xsl:value-of select="$attrValue"/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>
	
	<!-- default for both passes is to copy node and children -->
	<xsl:template match="node()|@*" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" mode="pass1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="node()|@*" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" mode="pass2"/>
		</xsl:copy>
	</xsl:template>

	<!-- utility templates -->
	<xsl:template mode="lcase" match="*">
		<xsl:value-of select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	</xsl:template>
	<xsl:template mode="ucase" match="*">
		<xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:template>
</xsl:stylesheet>
