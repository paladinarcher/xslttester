<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="AdvanceDirectivesMinAge" select="0"/>
	<xsl:param name="AdvanceDirectivesMaxAge" select="999999"/>
	<xsl:param name="AdvanceDirectivesCount"  select="999999"/>
	<xsl:param name="AdvanceDirectivesCode"   select="''"/>
	<!--
	<xsl:param name="AdvanceDirectivesMinAge" select="0"/>
	<xsl:param name="AdvanceDirectivesMaxAge" select="$_18months"/>
	<xsl:param name="AdvanceDirectivesCount"  select="10"/>
	<xsl:param name="AdvanceDirectivesCode"   select="',A,I,H,T,E,'"/>
	-->
	<xsl:template match="AdvanceDirective" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="AdvanceDirectives" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="AdvanceDirective
				[
					    @age &lt;= $AdvanceDirectivesMaxAge
					and @age >= $AdvanceDirectivesMinAge 
					and (($AdvanceDirectivesCode = '') or (contains($AdvanceDirectivesCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	            	<xsl:if test="position() &lt;= $AdvanceDirectivesCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
