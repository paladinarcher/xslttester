<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				xmlns:ssm="http://www.surescripts.com/messaging"
				exclude-result-prefixes="ssm xsi isc"
				version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="MESSAGEID"></xsl:param>

<xsl:template match="//@* | //node()">
  <xsl:copy>
	<xsl:apply-templates select="MessageID"/>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="/ssm:Message//ssm:MessageID">
	<ssm:MessageID><xsl:value-of select="//ssm:MessageID"></xsl:value-of></ssm:MessageID>
	<ssm:RelatesToMessageID><xsl:value-of select="$MESSAGEID"></xsl:value-of></ssm:RelatesToMessageID>
</xsl:template>
</xsl:stylesheet>
