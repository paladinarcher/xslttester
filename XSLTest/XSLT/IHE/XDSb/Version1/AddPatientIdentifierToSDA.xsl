<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="isc xsi" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	
<xsl:param name="MPIID"/>

<xsl:template match="//@* | //node()">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="/Container/Patients/Patient">
<xsl:apply-templates select="@*"/>
<xsl:copy>
<xsl:if test="not(MPIID)">
<MPIID><xsl:value-of select="$MPIID"/></MPIID>
</xsl:if>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:template>
	
</xsl:stylesheet>
