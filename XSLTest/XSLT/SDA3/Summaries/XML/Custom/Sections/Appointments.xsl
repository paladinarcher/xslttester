<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:param name="AppointmentsMinAge" select="-$_6months"/>
	<xsl:param name="AppointmentsMaxAge" select="$_6months"/>
	<xsl:param name="AppointmentsCount"  select="20"/>
	<xsl:param name="AppointmentsCode"   select="',AMBULATORY,EMERGENCY,INPATIENT,'"/>
	
	<xsl:template match="Appointment" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="Extension/PatientStatus" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Appointments" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
      <xsl:call-template name="attribute-set">
        <xsl:with-param name="element" select="." />
        <xsl:with-param name="attrName">pocStartTime</xsl:with-param>
        <xsl:with-param name="attrValue">
          <xsl:value-of select="$fromDate"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="attribute-set">
        <xsl:with-param name="element" select="." />
        <xsl:with-param name="attrName">pocEndTime</xsl:with-param>
        <xsl:with-param name="attrValue">
          <xsl:value-of select="$thruDate"/>
        </xsl:with-param>
      </xsl:call-template>
			<xsl:for-each select="Appointment
				[
					    @age &lt;= $AppointmentsMaxAge
					and @age >= $AppointmentsMinAge 
					and (($AppointmentsCode = '') or (contains($AppointmentsCode,concat(',',@code,',')))) 
				]">
	
				<!--
				<xsl:sort select="FromTime" order="ascending"/>
				-->
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $AppointmentsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
