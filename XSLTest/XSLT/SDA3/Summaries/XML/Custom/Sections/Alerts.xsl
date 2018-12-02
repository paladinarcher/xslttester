<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="AlertsMinAge" select="-99999"/>
	<xsl:param name="AlertsMaxAge" select="999999"/>
	<xsl:param name="AlertsCount"  select="999999"/>
	<xsl:param name="AlertsCode"   select="''"/>
	<!--
	<xsl:param name="AlertsMinAge" select="0"/>
	<xsl:param name="AlertsMaxAge" select="$_18months"/>
	<xsl:param name="AlertsCount"  select="10"/>
	<xsl:param name="AlertsCode"   select="''"/>
	-->
	<xsl:template match="Alert" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Alerts" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Alert
				[
					    @age &lt;= $AlertsMaxAge
					and @age >= $AlertsMinAge 
					and (($AlertsCode = '') or (contains($AlertsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	            	<xsl:if test="position() &lt;= $AlertsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
