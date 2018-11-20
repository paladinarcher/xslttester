<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="ReferralsMinAge" select="0"/>
	<xsl:param name="ReferralsMaxAge" select="$_18months"/>
	<xsl:param name="ReferralsCount"  select="10"/>
	<xsl:param name="ReferralsCode"   select="''"/>

	<xsl:template match="Referral" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Referrals" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Referral
				[
					    @age &lt;= $ReferralsMaxAge
					and @age >= $ReferralsMinAge 
					and (($ReferralsCode = '') or (contains($ReferralsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $ReferralsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
