<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="VISITNUMBER">__VISIT_NUMBER_NOT_SET__</xsl:param>

	<!-- Visit number -->
	<xsl:template match="/Container/Patients/Patient/Encounters">
		<xsl:copy>
		<xsl:for-each select="Encounter">
			<xsl:if test="VisitNumber = $VISITNUMBER">
			  <xsl:copy>
			    <xsl:apply-templates select="@* | node()"/>
			  </xsl:copy>
			</xsl:if>
		</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*">
		<xsl:if test="node()">			
			<xsl:copy>
			    <xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
