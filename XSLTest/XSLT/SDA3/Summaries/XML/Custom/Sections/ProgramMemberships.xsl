<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="ProgramMembershipsMinAge" select="0"/>
	<xsl:param name="ProgramMembershipsMaxAge" select="999999"/>
	<xsl:param name="ProgramMembershipsCount"  select="999999"/>
	<xsl:param name="ProgramMembershipsCode"   select="''"/>

	<xsl:template match="ProgramMembership" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="ProgramMemberships" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="ProgramMembership
				[
					    @age &lt;= $ProgramMembershipsMaxAge
					and @age >= $ProgramMembershipsMinAge 
					and (($ProgramMembershipsCode = '') or (contains($ProgramMembershipsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $ProgramMembershipsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
