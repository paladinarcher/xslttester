<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="GenomicsOrdersMinAge" select="0"/>
	<xsl:param name="GenomicsOrdersMaxAge" select="$_24months"/>
	<xsl:param name="GenomicsOrdersCount"  select="10"/>
	<xsl:param name="GenomicsOrdersCode"   select="''"/>

	<xsl:template match="GenomicsOrder" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="GenomicsOrders" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="GenomicsOrder
				[
					    @age &lt;= $GenomicsOrdersMaxAge
					and @age >= $GenomicsOrdersMinAge 
					and (($GenomicsOrdersCode = '') or (contains($GenomicsOrdersCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $GenomicsOrdersCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
