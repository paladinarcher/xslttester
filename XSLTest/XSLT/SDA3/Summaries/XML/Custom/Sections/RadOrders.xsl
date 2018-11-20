<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="RadOrdersMinAge" select="0"/>
	<xsl:param name="RadOrdersMaxAge" select="$_24months"/>
	<xsl:param name="RadOrdersCount"  select="5"/>
	<xsl:param name="RadOrdersCode"   select="''"/>

	<xsl:template match="RadOrder" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="RadOrders" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="RadOrder
				[
					    @age &lt;= $RadOrdersMaxAge
					and @age >= $RadOrdersMinAge 
					and (($RadOrdersCode = '') or (contains($RadOrdersCode,concat(',',@code,',')))) 
				]">

				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
				<!--
				<xsl:sort select="Result/ResultItems/EnteredOn" order="descending"/>
				-->
	            	<xsl:if test="position() &lt;= $RadOrdersCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
