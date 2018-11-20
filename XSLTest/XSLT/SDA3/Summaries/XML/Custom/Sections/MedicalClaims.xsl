<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="MedicalClaimsMinAge" select="0"/>
	<xsl:param name="MedicalClaimsMaxAge" select="999999"/>
	<xsl:param name="MedicalClaimsCount"  select="999999"/>
	<xsl:param name="MedicalClaimsCode"   select="''"/>

	<xsl:template match="MedicalClaim" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="MedicalClaims" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="MedicalClaim
				[
					    @age &lt;= $MedicalClaimsMaxAge
					and @age >= $MedicalClaimsMinAge 
					and (($MedicalClaimsCode = '') or (contains($MedicalClaimsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $MedicalClaimsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
