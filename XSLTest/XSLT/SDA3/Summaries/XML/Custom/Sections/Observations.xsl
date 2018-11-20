<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="ObservationsMinAge" select="0"/>
	<xsl:param name="ObservationsMaxAge" select="$_12months"/>
	
	<xsl:param name="ObservationsCount"  select="5"/>
	<xsl:param name="ObservationsCode"   select="',Passed,Refused,Unavailable,'"/>

    <!--
    Vitals
        Sort Date: taken
        Min Age: none
        Max Age: 12 months
        Count: 5 (only latest set of vitals per day, grouped by ObservationTime)
    -->

    <xsl:key name="ObsTime" match="Observation" use="ObservationTime"/>
    <xsl:key name="ObsDate" match="Observation" use="substring-before(ObservationTime,'T')"/>

	<xsl:template match="Observation" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="ObservationTime" />
				<xsl:with-param name="code" select="'ObservationValue'" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Observations" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Observation
				[
					    @age &lt;= $ObservationsMaxAge
					and @age >= $ObservationsMinAge 
					and (($ObservationsCode = '') or not(contains($ObservationsCode,concat(',',@code,','))))
					and count(. | key('ObsDate', substring-before(ObservationTime,'T'))[1]) = 1 
					 
				]">
				<xsl:sort select="ObservationTime" order="descending"/>
				
	            <xsl:if test="position() &lt;= $ObservationsCount">
            		<xsl:apply-templates mode="pass2" select="key('ObsTime',ObservationTime)">
            			<xsl:sort select="ObservationCode/Code"/>
            		</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
