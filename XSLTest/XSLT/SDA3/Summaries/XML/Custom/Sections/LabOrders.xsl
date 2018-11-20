<?xml version="1.0"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"	
	exclude-result-prefixes="exsl"
	>

	<xsl:param name="LabOrdersMinAge" select="0"/>
	<xsl:param name="LabOrdersMaxAge" select="$_24months"/>

	<xsl:param name="LabOrdersCount"  select="10"/>
	<xsl:param name="LabOrdersCode"   select="',CH,'"/>
	
	<xsl:param name="LabOrdersCountLR"  select="5"/>
	<xsl:param name="LabOrdersMinAgeLR" select="0"/>

	<xsl:template match="LabOrder" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="Result/ResultItems/LabResultItem/ObservationTime" />  <!-- assumes all LabResultItem times are the same -->
				<xsl:with-param name="code" select="OrderCategory/Code" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="LabOrders" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			
			<!-- Store orders that pass filters in a variable -->
			<xsl:variable name="orders">
			
				<!-- first LR since it has a different count (these are actually stored in documents only)-->
				<!--
				<xsl:for-each select="LabOrder
					[
							@code = 'LR'
						and @age &lt;= $LabOrdersMaxAge
						and @age >= $LabOrdersMinAgeLR 
						and (($LabOrdersCode = '') or (contains($LabOrdersCode,concat(',',@code,',')))) 
					]">
					<xsl:sort select="@date" order="descending"/>
	            	        <xsl:if test="position() &lt;= $LabOrdersCountLR">
						<xsl:copy>
							<xsl:apply-templates select="node()|@*" mode="pass2"/>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
				-->
			
				<!--  next any other order category -->
				<xsl:for-each select="LabOrder
					[
							not(@code = 'LR')
						and @age &lt;= $LabOrdersMaxAge
						and @age >= $LabOrdersMinAge 
						and (($LabOrdersCode = '') or (contains($LabOrdersCode,concat(',',@code,',')))) 
					]">
					<xsl:sort select="@date" order="descending"/>
	            	<xsl:if test="position() &lt;= $LabOrdersCount">
						<xsl:copy>
							<xsl:apply-templates select="node()|@*" mode="pass2"/>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			<!-- convert the filtered orders into a node-set and sort again by date -->
			<xsl:for-each select="exsl:node-set($orders)/LabOrder">
				<xsl:sort select="@date" order="descending"/>
				<xsl:copy>
					<xsl:apply-templates select="node()|@*" mode="pass2"/>
				</xsl:copy>
			</xsl:for-each>	
		</xsl:copy>	
	</xsl:template>
</xsl:stylesheet>
