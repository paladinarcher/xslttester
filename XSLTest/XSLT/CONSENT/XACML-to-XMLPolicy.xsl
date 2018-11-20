<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:xacml="urn:oasis:names:tc:xacml:2.0:policy:schema:os"
xmlns:hl7="urn:hl7-org:v3"
exclude-result-prefixes="isc xacml hl7">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="//xacml:Policy">
<P U="{@PolicyId}" 
I="{xacml:Target/xacml:Resources/xacml:Resource/xacml:ResourceMatch/xacml:AttributeValue/hl7:PatientId/@extension}" 
A="{xacml:Target/xacml:Resources/xacml:Resource/xacml:ResourceMatch/xacml:AttributeValue/hl7:PatientId/@root}">

<xsl:choose>
<xsl:when test="@RuleCombiningAlgId = 'urn:oasis:names:tc:xacml:1.0:rule-combining-algorithm:first-applicable'">
<xsl:for-each select="xacml:Rule">
<xsl:variable name="decision"><xsl:choose><xsl:when test="@Effect='Permit'">1A</xsl:when><xsl:otherwise>0A</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="startDate" select="xacml:Target/xacml:Environments/xacml:Environment/xacml:EnvironmentMatch/xacml:EnvironmentAttributeDesignator[@AttributeId='http://www.hhs.gov/healthit/nhin#rule-start-date']/../xacml:AttributeValue/text()"/>
<xsl:variable name="endDate" select="xacml:Target/xacml:Environments/xacml:Environment/xacml:EnvironmentMatch/xacml:EnvironmentAttributeDesignator[@AttributeId='http://www.hhs.gov/healthit/nhin#rule-end-date']/../xacml:AttributeValue/text()"/>
<xsl:choose>
<xsl:when test="xacml:Target/xacml:Subjects/xacml:Subject">
<!-- Each subject must have it's own rule, since it's possible one subject has purpose=emergency and another does not-->
<xsl:for-each select="xacml:Target/xacml:Subjects/xacml:Subject">
<xsl:variable name="org">
<xsl:choose>
<xsl:when test="contains(xacml:SubjectMatch/xacml:SubjectAttributeDesignator[@AttributeId='urn:oasis:names:tc:xspa:1.0:subject:organization-id']/../xacml:AttributeValue/text(), 'urn:oid:')">
<xsl:value-of select="substring-after(xacml:SubjectMatch/xacml:SubjectAttributeDesignator[@AttributeId='urn:oasis:names:tc:xspa:1.0:subject:organization-id']/../xacml:AttributeValue/text(),'urn:oid:')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="xacml:SubjectMatch/xacml:SubjectAttributeDesignator[@AttributeId='urn:oasis:names:tc:xspa:1.0:subject:organization-id']/../xacml:AttributeValue/text()"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="role" select="xacml:SubjectMatch/xacml:SubjectAttributeDesignator[@AttributeId='urn:oasis:names:tc:xspa:1.0:subject:role']/../xacml:AttributeValue/text()"/>
<xsl:variable name="purpose" select="xacml:SubjectMatch/xacml:SubjectAttributeDesignator[@AttributeId='urn:oasis:names:tc:xspa:1.0:subject:purposeofuse']/../xacml:AttributeValue/text()"/>
<xsl:variable name="btg" select="$purpose = 'EMERGENCY'"/>
<xsl:element name="R">
<xsl:attribute name="N"><xsl:value-of select="isc:evaluate('varInc','ruleNum')"/></xsl:attribute>
<xsl:if test="$btg">
<xsl:attribute name="B">1</xsl:attribute>
</xsl:if>
<xsl:attribute name="D"><xsl:value-of select="$decision"/></xsl:attribute>
<xsl:if test="$startDate"><xsl:attribute name="S"><xsl:value-of select="$startDate"/></xsl:attribute></xsl:if>
<xsl:if test="$endDate"><xsl:attribute name="E"><xsl:value-of select="$endDate"/></xsl:attribute></xsl:if>
<xsl:if test="$org or $role">
<xsl:element name="G">
<xsl:if test="$org"><xsl:attribute name="F"><xsl:value-of select="$org"/></xsl:attribute></xsl:if>
<xsl:if test="$role"><xsl:attribute name="R"><xsl:value-of select="$role"/></xsl:attribute></xsl:if>
</xsl:element>
</xsl:if>
</xsl:element>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:element name="R">
<xsl:attribute name="N"><xsl:value-of select="isc:evaluate('varInc','ruleNum')"/></xsl:attribute>
<xsl:attribute name="D"><xsl:value-of select="$decision"/></xsl:attribute>
<xsl:if test="$startDate"><xsl:attribute name="S"><xsl:value-of select="$startDate"/></xsl:attribute></xsl:if>
<xsl:if test="$endDate"><xsl:attribute name="E"><xsl:value-of select="$endDate"/></xsl:attribute></xsl:if>
</xsl:element>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:when>
</xsl:choose>
</P>
</xsl:template>

</xsl:stylesheet>
