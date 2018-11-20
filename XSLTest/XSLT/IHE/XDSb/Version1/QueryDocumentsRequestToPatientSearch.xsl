<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:wrapper="http://wrapper.intersystems.com" version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" exclude-result-prefixes="isc wrapper">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="userName"/>
<xsl:param name="userRoles"/>
<xsl:param name="gatewayName"/>

<xsl:template match="//query:AdhocQueryRequest">
<xsl:variable name="patientIdentifier" select="isc:evaluate('stripapos',./rim:AdhocQuery/rim:Slot[@name='$XDSDocumentEntryPatientId']/rim:ValueList/rim:Value/text())"/>
<xsl:variable name="assigningAuthority" select="isc:evaluate('piece', isc:evaluate('piece', $patientIdentifier, '^', 4), '&amp;', 2)"/>
<xsl:variable name="facilityCode" select="isc:evaluate('piece', isc:evaluate('piece', $patientIdentifier, '^', 6), '&amp;', 2)"/>
<xsl:variable name="mrn" select="substring-before($patientIdentifier, '^')"/>


<PatientSearchRequest>
<AuthBy />
<AuthType/>
<BTGReason />
<LastName />
<MiddleName />
<FirstName />
<Sex />
<Street />
<City />
<State />
<Zip />
<SSN />
<Telephone />
<BreakTheGlass>false</BreakTheGlass>
<Consent />
<ClinicalTypes />
<RequestingUser><xsl:value-of select="$userName"/></RequestingUser>
<RequestingUserRoles><xsl:value-of select="$userRoles"/></RequestingUserRoles>
<Signature />
<RequestId>NHIN</RequestId>
<RequestingGateway><xsl:value-of select="$gatewayName"/></RequestingGateway>
<Type />
<Facility><xsl:value-of select="$facilityCode"/></Facility>
<AssigningAuthority>
<xsl:choose>
<xsl:when test="$assigningAuthority != ''"><xsl:value-of select="$assigningAuthority"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$facilityCode"/></xsl:otherwise>
</xsl:choose>
</AssigningAuthority>

<!--
<Facility>
<xsl:choose>
<xsl:when test="$facilityCode != ''"><xsl:value-of select="$facilityCode"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$assigningAuthority"/></xsl:otherwise>
</xsl:choose>
</Facility>
<AssigningAuthority>
<xsl:choose>
<xsl:when test="$assigningAuthority != ''"><xsl:value-of select="$assigningAuthority"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$facilityCode"/></xsl:otherwise>
</xsl:choose>
</AssigningAuthority>
-->
<MRN><xsl:value-of select="$mrn"/></MRN>
<MPIID></MPIID>
<SearchMode>user</SearchMode>
</PatientSearchRequest>
</xsl:template>

</xsl:stylesheet>
