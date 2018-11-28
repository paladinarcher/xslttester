<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

  <xsl:variable name="documentCreatedOn" select="isc:evaluate('xmltimestamp', isc:evaluate('timestamp'))" />
  
  <xsl:template match="/Container">
    <xsl:variable name="patientBirthDate" select="Patient/BirthTime/text()" />
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
    </xsl:processing-instruction>
    
    <!-- PUT TEMPLATE HERE -->
    
    
  </xsl:template>
  <xsl:template match="*" mode="standard-address">
    <xsl:param name="use" />
    <xsl:choose>
      <xsl:when test="boolean(Address)">
        <addr use="{$use}">
          <xsl:if test="boolean(Address/Street)">
            <streetAddressLine>
              <xsl:value-of select="Address/Street/text()" />
            </streetAddressLine>
          </xsl:if>
          <xsl:if test="boolean(Address/City/Code)">
            <city>
              <xsl:value-of select="Address/City/Code/text()" />
            </city>
          </xsl:if>
          <xsl:if test="boolean(Address/State/Code)">
            <state>
              <xsl:value-of select="Address/State/Code/text()" />
            </state>
          </xsl:if>
          <xsl:if test="boolean(Address/Zip/Code)">
            <postalCode>
              <xsl:value-of select="Address/Zip/Code/text()" />
            </postalCode>
          </xsl:if>
        </addr>
      </xsl:when>
      <xsl:otherwise>
        <addr nullFlavor="NI" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="standard-contact-info">
    <xsl:choose>
      <xsl:when test="boolean(ContactInfo) and (boolean(ContactInfo/HomePhoneNumber) or boolean(ContactInfo/WorkPhoneNumber) or boolean(ContactInfo/MobilePhoneNumber) or boolean(ContactInfo/EmailAddress))">
        <xsl:if test="boolean(ContactInfo/HomePhoneNumber)">
          <telecom use="HP" value="{concat('tel:',ContactInfo/HomePhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/WorkPhoneNumber)">
          <telecom use="WP" value="{concat('tel:',ContactInfo/WorkPhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/MobilePhoneNumber)">
          <telecom use="MC" value="{concat('tel:',ContactInfo/MobilePhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/EmailAddress)">
          <telecom value="{concat('mailto:',ContactInfo/EmailAddress)}" />
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <telecom nullFlavor="NI" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="Name" mode="standard-name">
    <xsl:param name="use" />
    <xsl:choose>
      <xsl:when test="boolean(FamilyName) or boolean(GivenName) or boolean(MiddleName)">
        <name>
          <xsl:if test="boolean($use)">
            <xsl:attribute name="use">
              <xsl:value-of select="$use" />
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="boolean(FamilyName)">
            <family>
              <xsl:value-of select="FamilyName/text()" />
            </family>
          </xsl:if>
          <xsl:if test="boolean(GivenName)">
            <given>
              <xsl:value-of select="GivenName/text()" />
            </given>
          </xsl:if>
          <xsl:if test="boolean(MiddleName)">
            <given>
              <xsl:value-of select="MiddleName/text()" />
            </given>
          </xsl:if>
        </name>
      </xsl:when>
      <xsl:otherwise>
        <name>
          <xsl:if test="boolean($use)">
            <xsl:attribute name="use">
              <xsl:value-of select="$use" />
            </xsl:attribute>
          </xsl:if>
        </name>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="SupportContact" mode="header-participant">
    <participant typeCode="IND">
      <!-- 3.01 DATE, REQUIRED -->
      <!-- 3.01 DATE date as nullFlavor b/c data not yet available via VA VistA 
        RPCs -->
      <time nullFlavor="UNK" />
      <!-- 3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value 
        in contactType -->
      <associatedEntity classCode="{ContactType/Code/text()}">
        <code codeSystem='2.16.840.1.113883.5.111' codeSystemName='{isc:evaluate("getCodeForOID","2.16.840.1.113883.5.111","","2.16.840.1.113883.5.111")}' nullFlavor='NA'>
          <originalText>
            <xsl:value-of select='Relationship/Code/text()' />
          </originalText>
        </code>
        <!-- 3.04 CONTACT Addresss, Home Permanent, Optional-R2 -->
        <xsl:apply-templates select='.' mode='standard-address'>
          <xsl:with-param name='use'>HP</xsl:with-param>
        </xsl:apply-templates>
        <!-- 3.05 CONTACT PHONE/EMAIL/URL, Optional-R2, Removed b/c data not yet 
            available via VA VistA RPCs -->
        <xsl:apply-templates select='.' mode='standard-contact-info' />
        <associatedPerson>
          <!-- 3.06 CONTACT NAME, REQUIRED -->
          <xsl:apply-templates select='Name' mode='standard-name' />
        </associatedPerson>
      </associatedEntity>
    </participant>
  </xsl:template>
  <xsl:template match='CareTeamMember' mode='header-careteammembers' >
    <xsl:param name="number" />
    <performer typeCode="PRF" testing="{$number}">
      <!-- ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* -->
      <!-- 4.02 PROVIDER ROLE CODED, optional -->
      <templateId root="2.16.840.1.113883.10.20.6.2.1" extension="2014-06-09" />
      <xsl:choose>
        <xsl:when test="$number=1">
          <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="{isc:evaluate('getCodeForOID','2.16.840.1.113883.5.88','CodeSystem','ParticipationFunction')}" displayName="{Description/text()}">
            <originalText>
              <xsl:value-of select="Description/text()" />
            </originalText>
          </functionCode>
        </xsl:when>
        <xsl:otherwise>
          <functionCode nullFlavor="NI">
            <originalText>
              <xsl:value-of select="concat('Care Team:  ', ../../CareTeamName/text())" />
            </originalText>
          </functionCode>
        </xsl:otherwise>
      </xsl:choose>
      <assignedEntity>
        <!-- Provider ID from Problems Module (7.05Treating Provider ID) -->
        <!-- <id extension="providerN" root="2.16.840.1.113883.4.349" /> -->
        <id nullFlavor="NI"/>
        <!--4.04 PROVIDER TYPE, optional, NUCC -->
        <code code="provTypeCode" codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" displayName="provTypeCodeName ">
          <originalText />
        </code>
        <!-- Address Required for assignedEntity -->
        <addr use="WP">
          <streetAddressLine />
          <city />
          <state />
          <postalCode />
        </addr>
        <!-- Telecom Required for iassignedEntity, but VA VistA data not yet available -->
        <telecom MAP_ID="TELEPHONE" />
        <telecom MAP_ID="EMAIL" />
        <!-- 4.07-PROVIDER NAME, REQUIRED -->
        <assignedPerson>
          <name />
        </assignedPerson>
        <representedOrganization>
          <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR -->
          <id root="2.16.840.1.113883.4.349" />
          <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
          <name />
          <!-- Telecom Required for representedOrganization, but VA VistA data not yet available -->
          <telecom nullFlavor="UNK" />
          <!-- Address Required for representedOrganization, but VA VistA data not yet available -->
          <addr nullFlavor="UNK" />
        </representedOrganization>
      </assignedEntity>
    </performer>
  </xsl:template>
</xsl:stylesheet>
