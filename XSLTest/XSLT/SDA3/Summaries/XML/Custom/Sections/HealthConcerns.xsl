<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="HealthConcernsMinAge" select="0"/>
	<xsl:param name="HealthConcernsMaxAge" select="999999"/>
	<xsl:param name="HealthConcernsCount"  select="999999"/>
	<xsl:param name="HealthConcernsCode"   select="''"/>

	<xsl:template match="HealthConcern" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="HealthConcerns" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="HealthConcern
				[
					    @age &lt;= $HealthConcernsMaxAge
					and @age >= $HealthConcernsMinAge 
					and (($HealthConcernsCode = '') or (contains($HealthConcernsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $HealthConcernsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
