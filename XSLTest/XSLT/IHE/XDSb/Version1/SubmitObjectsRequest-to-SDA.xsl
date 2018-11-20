<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:ihe="urn:ihe:iti:xds-b:2007" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="patientId"/>
<xsl:param name="facility"/>
<xsl:param name="assigningAuthority"/>
<xsl:param name="excludeCommunity"/>

<xsl:template match="/lcm:SubmitObjectsRequest/rim:RegistryObjectList">
<Container>
<Action>SubmitObjects</Action>
<EventDescription>XDSb Document List</EventDescription>
<SendingFacility><xsl:value-of select="$facility"/></SendingFacility>
<Patient>
<PatientNumbers>
<PatientNumber>
<Number><xsl:value-of select="$patientId"/></Number>
<Organization><Code><xsl:value-of select="$facility"/></Code></Organization>
<NumberType>MRN</NumberType>
</PatientNumber>
</PatientNumbers>

<!-- Use first document to fill in basic demographics -->
<xsl:for-each select="rim:ExtrinsicObject[1]/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value">
<xsl:variable name="itm" select="isc:evaluate('piece',text(),'|',1)"/>
<xsl:variable name="val" select="isc:evaluate('piece',text(),'|',2)"/>
<xsl:choose>
<xsl:when test="$itm = 'PID-5'">
<Name>
<xsl:variable name="lastname" select="isc:evaluate('piece',$val,'^',1)"/>
<xsl:variable name="family" select="isc:evaluate('piece',$lastname,'&amp;',1)"/>
<xsl:variable name="familyprefix" select="isc:evaluate('piece',$lastname,'&amp;',2)"/>
<xsl:variable name="given" select="isc:evaluate('piece',$val,'^',2)"/>
<xsl:variable name="middle" select="isc:evaluate('piece',$val,'^',3)"/>
<xsl:variable name="suffix" select="isc:evaluate('piece',$val,'^',4)"/>
<xsl:variable name="preferred" select="isc:evaluate('piece',$val,'^',5)"/>

<xsl:if test="$family"><FamilyName><xsl:value-of select="$family"/></FamilyName></xsl:if>
<xsl:if test="$familyprefix"><FamilyNamePrefix><xsl:value-of select="$familyprefix"/></FamilyNamePrefix></xsl:if>
<xsl:if test="$given"><GivenName><xsl:value-of select="$given"/></GivenName></xsl:if>
<xsl:if test="$middle"><MiddleName><xsl:value-of select="$middle"/></MiddleName></xsl:if>
<xsl:if test="$suffix"><ProfessionalSuffix><xsl:value-of select="$suffix"/></ProfessionalSuffix></xsl:if>
<xsl:if test="$preferred"><PreferredName><xsl:value-of select="$preferred"/></PreferredName></xsl:if>
</Name>
</xsl:when>
<xsl:when test="$itm = 'PID-7'">
<BirthTime><xsl:value-of select="isc:evaluate('xmltimestamp',$val)"/></BirthTime>
</xsl:when>
<xsl:when test="$itm = 'PID-8'">
<Gender><Code><xsl:value-of select="$val"/></Code></Gender>
</xsl:when>
<xsl:when test="$itm = 'PID-11'">
<Addresses>
<Address>
<xsl:variable name="street" select="isc:evaluate('piece',$val,'^',1,2)"/>
<xsl:variable name="city" select="isc:evaluate('piece',$val,'^',3)"/>
<xsl:variable name="state" select="isc:evaluate('piece',$val,'^',4)"/>
<xsl:variable name="zip" select="isc:evaluate('piece',$val,'^',5)"/>
<xsl:variable name="country" select="isc:evaluate('piece',$val,'^',6)"/>

<xsl:if test="$street"><Street><xsl:value-of select="translate($street,'^',';')"/></Street></xsl:if>
<xsl:if test="$city"><City><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',3)"/></Code></City></xsl:if>
<xsl:if test="$state"><State><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',4)"/></Code></State></xsl:if>
<xsl:if test="$zip"><Zip><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',5)"/></Code></Zip></xsl:if>
<xsl:if test="$country"><Country><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',6)"/></Code></Country></xsl:if>
</Address>
</Addresses>
</xsl:when>
</xsl:choose>
</xsl:for-each>

</Patient>
</Container>
</xsl:template>

</xsl:stylesheet>
