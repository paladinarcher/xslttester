<?xml version="1.0" encoding="UTF-8"?>
<!-- STRIP out any living subject ID's since this is from another community  -->
<xsl:stylesheet version="1.0" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:hl7="urn:hl7-org:v3" 
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="/*[local-name()]/hl7:controlActProcess/hl7:queryByParameter/hl7:parameterList/hl7:livingSubjectId"/>
</xsl:stylesheet>