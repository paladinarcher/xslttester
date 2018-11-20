<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="OtherOrdersMinAge" select="-45"/>
	<xsl:param name="OtherOrdersMaxAge" select="45"/>
	<xsl:param name="OtherOrdersCount"  select="999999"/>
	<xsl:param name="OtherOrdersCode"   select="''"/>
	<xsl:param name="OtherOrdersStatusExclude" select="',COMPLETE,'"/>

	<xsl:template match="OtherOrder" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="'OtherOrders/Status'" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="OtherOrders" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="OtherOrder
				[
                        	@age &lt;= $OtherOrdersMaxAge
						and @age >= $OtherOrdersMinAge 
						and (($OtherOrdersCode = '') or (contains($OtherOrdersCode,concat(',',@code,','))))
						and not(contains($OtherOrdersStatusExclude,concat(',',Status,','))) 
				]">
				<!--
				[
					    @age &lt;= $OtherOrdersMaxAge
					and @age >= $OtherOrdersMinAge 
					and (($OtherOrdersCode = '') or not(contains($OtherOrdersCode,concat(',',@code,',')))) 
				]">
				-->
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $OtherOrdersCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
