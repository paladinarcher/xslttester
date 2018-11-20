<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
<cargo>
	<!-- this will create the container -->
	<xsl:apply-templates mode="noenc"/>
	<!-- now we create encounters, in their own tree -->
	<Encounters>
	<xsl:for-each select="//Encounter">
		<xsl:sort select="StartTime" order="descending"/>
		<Encounter>
		<xsl:copy-of select="@*|node()" />
		</Encounter>
	</xsl:for-each>
    </Encounters>
</cargo>
</xsl:template>

<!-- this copied the whole original container, except for the encounters tree -->
 <xsl:template match="@*|node()" mode="noenc">
   <xsl:if test="local-name()!='Encounters'">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="noenc"/>
    </xsl:copy>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
