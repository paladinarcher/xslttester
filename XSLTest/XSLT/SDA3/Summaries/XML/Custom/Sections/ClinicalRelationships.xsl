<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="ClinicalRelationshipsMinAge" select="0"/>
	<xsl:param name="ClinicalRelationshipsMaxAge" select="999999"/>
	<xsl:param name="ClinicalRelationshipsCount"  select="999999"/>
	<xsl:param name="ClinicalRelationshipsCode"   select="''"/>

	<xsl:template match="ClinicalRelationship" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="ClinicalRelationships" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="ClinicalRelationship
				[
					    @age &lt;= $ClinicalRelationshipsMaxAge
					and @age >= $ClinicalRelationshipsMinAge 
					and (($ClinicalRelationshipsCode = '') or (contains($ClinicalRelationshipsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $ClinicalRelationshipsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
