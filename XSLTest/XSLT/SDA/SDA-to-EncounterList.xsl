<?xml version="1.0"?>
<!-- Reduces input SDA to a patient containing just a list of encounters with basic information in reverse chronological order by default-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="sortOrder" select="''"/>

<xsl:template match="/">
<Patient>
	<Encounters>
		<xsl:apply-templates select="/Container/Patients/Patient/Encounters/Encounter">
				<xsl:sort select="StartTime" order="{$sortOrder}"/>
		</xsl:apply-templates>
	</Encounters>
</Patient>
</xsl:template>

 <xsl:template match="Encounter">
	<xsl:if test="not(EncounterType = 'S' or EncounterType = 'G')">
		<xsl:copy>
			<xsl:for-each select="VisitNumber | StartTime | EndTime | EncounterType | ExternalId">
				<xsl:copy><xsl:apply-templates /></xsl:copy>
			</xsl:for-each>
			<HealthCareFacility><Organization><Code><xsl:value-of select="HealthCareFacility/Organization/Code"/></Code></Organization></HealthCareFacility>
		</xsl:copy>
	</xsl:if>  
</xsl:template>

</xsl:stylesheet>