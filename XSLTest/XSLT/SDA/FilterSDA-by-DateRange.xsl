<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="ADMITDATE">__ADMIT_DATE_NOT_SET__</xsl:param>
	<xsl:param name="DISCHARGEDATE">__DISCHARGE_DATE_NOT_SET__</xsl:param>

	<!-- Visit number -->
	<xsl:template match="/Container/Patients/Patient/Encounters">
		<xsl:copy>
		<xsl:for-each select="Encounter">
			<xsl:if test="boolean(number(isc:evaluate('xmltimestampisbefore',$ADMITDATE,StartTime))) and boolean(number(isc:evaluate('xmltimestampisbefore',EndTime,$DISCHARGEDATE)))">
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
