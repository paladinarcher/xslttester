<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="SocialHistoriesMinAge" select="0"/>
	<xsl:param name="SocialHistoriesMaxAge" select="999999"/>
	<xsl:param name="SocialHistoriesCount"  select="999999"/>
	<xsl:param name="SocialHistoriesCode"   select="''"/>

	<xsl:template match="SocialHistory" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="EnteredOn" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="SocialHistories" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="SocialHistory
				[
					    @age &lt;= $SocialHistoriesMaxAge
					and @age >= $SocialHistoriesMinAge 
					and (($SocialHistoriesCode = '') or (contains($SocialHistoriesCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="EnteredOn" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $SocialHistoriesCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
