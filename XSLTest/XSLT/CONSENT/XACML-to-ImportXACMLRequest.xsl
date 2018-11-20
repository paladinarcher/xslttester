<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xacml="urn:oasis:names:tc:xacml:2.0:policy:schema:os"
xmlns:hl7="urn:hl7-org:v3"
exclude-result-prefixes="xacml hl7">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="UserID"/>
<xsl:param name="Roles"/>
<xsl:param name="Gateway"/>
<xsl:param name="allFacilitiesDefault" select="0"/>
<xsl:param name="allFacilitiesExceptions"/>

<xsl:template match="/">
<ImportXACML xmlns='http://www.intersystems.com/hs/hub/consent'>
<pPolicy>
<_User><xsl:value-of select="$UserID"/></_User> 
<_Roles><xsl:value-of select="$Roles"/></_Roles> 
<_Gateway><xsl:value-of select="$Gateway"/></_Gateway> 
<ContentStream>
<xsl:copy-of select="."/>
</ContentStream>

<xsl:variable name="allFacilities">
<xsl:choose>
<xsl:when test="$allFacilitiesExceptions and contains($allFacilitiesExceptions,concat('^',//hl7:PatientId/@root,'^'))">
<xsl:value-of select="($allFacilitiesDefault + 1) mod 2"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$allFacilitiesDefault"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$allFacilities = 1">
<AdditionalInfo>
<AdditionalInfoItem AdditionalInfoKey="allFacilities">1</AdditionalInfoItem>
</AdditionalInfo>
</xsl:if>
</pPolicy>
</ImportXACML>
</xsl:template>
</xsl:stylesheet>