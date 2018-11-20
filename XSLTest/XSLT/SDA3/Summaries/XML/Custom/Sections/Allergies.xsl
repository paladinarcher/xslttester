<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="AllergiesMinAge" select="0"/>
	<xsl:param name="AllergiesMaxAge" select="999999"/>
	<xsl:param name="AllergiesCount"  select="999999"/>
	<xsl:param name="AllergiesCode"   select="''"/>

	<xsl:template match="Allergy" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<!--
				<xsl:with-param name="date" select="FromTime" />
				-->
				<xsl:with-param name="date" select="EnteredOn" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Allergies" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Allergy
				[
					    @age &lt;= $AllergiesMaxAge
					and @age >= $AllergiesMinAge 
					and (($AllergiesCode = '') or (contains($AllergiesCode,concat(',',@code,',')))) 
				]">
				<!--
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
				-->
				<xsl:sort select="EnteredOn" order="descending"/>
				<xsl:sort select="VerifiedTime" order="descending"/>
	            	<xsl:if test="position() &lt;= $AllergiesCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
