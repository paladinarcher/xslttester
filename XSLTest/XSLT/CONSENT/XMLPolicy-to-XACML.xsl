<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns="urn:oasis:names:tc:xacml:2.0:policy:schema:os"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:hl7="urn:hl7-org:v3"
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/S">
<PolicySet 
PolicySetId="{@U}"
PolicyCombiningAlgId="urn:oasis:names:tc:xacml:1.0:policy-combining-algorithm:first-applicable">

<Target> 
<Resources>
<Resource> 
<ResourceMatch MatchId="http://www.hhs.gov/healthit/nhin/function#instance-identifier-equal"> 
<AttributeValue DataType="urn:hl7-org:v3#II"> 
<hl7:PatientId root="{@A}" extension="{@I}"/> 
</AttributeValue> 
<ResourceAttributeDesignator DataType="urn:hl7-org:v3#II" AttributeId="http://www.hhs.gov/healthit/nhin#subject-id"/> 
</ResourceMatch> 
</Resource> 
</Resources> 
</Target>

<xsl:apply-templates select="P"/>
</PolicySet>
</xsl:template>

<!-- Export the policy rule(s) -->
<xsl:template match="P">
<Policy 
PolicyId="{@U}"  
RuleCombiningAlgId="urn:oasis:names:tc:xacml:1.0:rule-combining-algorithm:first-applicable">
 
<Target> 
<xsl:if test="string-length(@F)"> 
<Resources>
<Resource> 
<ResourceMatch MatchId="urn:oasis:names:tc:xacml:1.0:function:string-equal"> 
<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string"> 
<xsl:value-of select="@F"/> 
</AttributeValue> 
<ResourceAttributeDesignator DataType="http://www.w3.org/2001/XMLSchema#anyURI" AttributeId="urn:oasis:names:tc:xacml:1.0:resource:resource-location"/> 
</ResourceMatch> 
</Resource> 
</Resources> 
</xsl:if>
</Target>

<xsl:for-each select="R">
<Rule RuleId="{@N}">

<xsl:attribute name="Effect">
<xsl:choose>
<xsl:when test="@D='1'">Permit</xsl:when>
<xsl:otherwise>Deny</xsl:otherwise>
</xsl:choose>
</xsl:attribute>

<Target>
<xsl:choose>
<xsl:when test="G">
<Subjects>
<xsl:for-each select="G">
<Subject>
<xsl:if test="../@B='1'">
<SubjectMatch MatchId="urn:oasis:names:tc:xacml:1.0:function:anyURI-equal">
<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string">EMERGENCY</AttributeValue>
<SubjectAttributeDesignator DataType="http://www.w3.org/2001/XMLSchema#string" AttributeId="urn:oasis:names:tc:xspa:1.0:subject:purposeofuse"/>
</SubjectMatch>
</xsl:if>
<xsl:if test="@F">
<SubjectMatch MatchId="urn:oasis:names:tc:xacml:1.0:function:anyURI-equal"> 
<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#anyURI"><xsl:value-of select="@F"/></AttributeValue> 
<SubjectAttributeDesignator AttributeId="urn:oasis:names:tc:xspa:1.0:subject:organization-id" DataType="http://www.w3.org/2001/XMLSchema#anyURI"/> 
</SubjectMatch> 
</xsl:if>
<xsl:if test="@R">
<SubjectMatch MatchId="urn:oasis:names:tc:xacml:1.0:function:string-equal">
<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#anyURI"><xsl:value-of select="@R"/></AttributeValue> 
<SubjectAttributeDesignator AttributeId="urn:oasis:names:tc:xspa:1.0:subject:role" DataType="http://www.w3.org/2001/XMLSchema#anyURI"/> 
</SubjectMatch> 
</xsl:if>
</Subject>
</xsl:for-each>
</Subjects>
</xsl:when>
<xsl:otherwise>
<xsl:if test="@B='1'">
<Subjects>
<Subject>
<SubjectMatch MatchId="urn:oasis:names:tc:xacml:1.0:function:anyURI-equal">
<AttributeValue DataType="http://www.w3.org/2001/XMLSchema#string">EMERGENCY</AttributeValue>
<SubjectAttributeDesignator DataType="http://www.w3.org/2001/XMLSchema#string" AttributeId="urn:oasis:names:tc:xspa:1.0:subject:purposeofuse"/>
</SubjectMatch>
</Subject>
</Subjects>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</Target>

</Rule>
</xsl:for-each>
</Policy>
</xsl:template>


</xsl:stylesheet>
