<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3"
   exclude-result-prefixes="hl7 isc">
   <!-- Contains shared routines that do NOT involve IHE/RIM namespaced elements,
        generally for internal XML formats. When including this file,
        AlsoInclude: Variables.xsl -->
   <!-- The prefix for template/mode names in this file is "utR" -->
   
   <xsl:template match="*" mode="utR-Author-fromSDA">
      <!-- Produce an Author element from a suitable person element in SDA. -->
      <xsl:param name="docUUID"/>
      <xsl:param name="authorInstitution"/>
      <xsl:param name="authorRole"/>
      <!-- Example apply-templates invocation, starting from Encounter:
      select="AdmittingClinician" etc. (i.e., context node has person data in child elements)
      with-param docUUID set by isc:evaluate('createUUID') for each iteration
      with-param authorInstitution: select="HealthCareFacility"
      with-param authorRole as static string -->
      <!-- First, check for duplicates -->
      <xsl:if test="0 = isc:evaluate('varData', 'author', $docUUID, Code/text(), SDACodingStandard/text())">
         <xsl:variable name="seen" select="isc:evaluate('varSet', 'author', $docUUID, Code/text(), SDACodingStandard/text())"/>
         <Author>
            <AuthorPerson>
               <xsl:value-of select="concat('^', Name/FamilyName/text(), '^', Name/GivenName/text(), '^^^')"/>
            </AuthorPerson>
            <AuthorInstitution>
               <Value>
                  <xsl:apply-templates select="$authorInstitution" mode="utR-getDescription"/>
               </Value>
            </AuthorInstitution>
            <AuthorRole>
               <Value>
                  <xsl:value-of select="$authorRole"/>
               </Value>
            </AuthorRole>
            <AuthorSpecialty>
               <Value>
                  <xsl:apply-templates select="CareProviderType" mode="utR-getDescription"/>
               </Value>
            </AuthorSpecialty>
         </Author>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="*" mode="utR-C-Description-pickBest">
      <!-- Get the best available string to be the description.
           Could come back empty. -->
      <xsl:choose>
         <xsl:when test="Description">
            <xsl:value-of select="Description/text()"/>
         </xsl:when>
         <xsl:when test="Code">
            <xsl:value-of select="Code/text()"/>
         </xsl:when>
         <xsl:when test="Organization/Description">
            <xsl:value-of select="Organization/Description/text()"/>
         </xsl:when>
         <xsl:when test="Organization/Code">
            <xsl:value-of select="Organization/Code/text()"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="utR-C-swapDevices">
      <xsl:param name="parentElement"/><!-- Path from / to parent of hl7:sender, hl7:receiver -->
      <!-- Copy sender/receiver devices but reverse them -->
      <hl7:receiver typeCode="RCV">
         <xsl:copy-of select="$parentElement/hl7:sender/hl7:device"/>
      </hl7:receiver>
      <hl7:sender typeCode="SND">
         <xsl:copy-of select="$parentElement/hl7:receiver/hl7:device"/>
      </hl7:sender>
   </xsl:template>
   
   <xsl:template match="*" mode="utR-getObjectType">
      <!-- Produce a type attribute (OnDemand or Stable) from a source that has
           the property in coded form. 
      -->
      <xsl:param name="sourceType" select="@objectType"/>
      <!-- $xdsbOnDemandDocument is a global variable set in Variables.xsl -->
      <xsl:attribute name="type">
         <xsl:choose>
            <xsl:when test="$sourceType = $xdsbOnDemandDocument">OnDemand</xsl:when>
            <xsl:when test="$sourceType = 'XDSb.OnDemand'">OnDemand</xsl:when>
            <xsl:otherwise>Stable</xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
   </xsl:template>
   
   <!--******************** Named templates ********************-->
   <xsl:template name="utR-Author-params">
      <!-- Produce an Author element, with one each of Institution, Role, etc.
           Context node doesn't matter; all data comes in via params. -->
      <xsl:param name="person"/>
      <xsl:param name="institution"/>
      <xsl:param name="role"/>
      <xsl:param name="specialty"/>
      <!-- ToDo: add Telecom element -->
      <!-- Author person is required -->
      <xsl:if test="$person">
         <Author>
            <AuthorPerson>
               <!-- since this is XCN, we should put this in the name piece since some vendors 
                    treat the first piece as an id *and* require an AA then -->
               <xsl:text>^</xsl:text>
               <xsl:value-of select="$person"/>
            </AuthorPerson>
            <xsl:if test="$institution">
               <AuthorInstitution>
                  <Value>
                     <xsl:value-of select="$institution"/>
                  </Value>
               </AuthorInstitution>
            </xsl:if>
            <xsl:if test="$role">
               <AuthorRole>
                  <Value>
                     <xsl:value-of select="$role"/>
                  </Value>
               </AuthorRole>
            </xsl:if>
            <xsl:if test="$specialty">
               <AuthorSpecialty>
                  <Value>
                     <xsl:value-of select="$specialty"/>
                  </Value>
               </AuthorSpecialty>
            </xsl:if>
         </Author>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utR-AvailabilityStatus">
      <!-- Map a @status to AvailabilityStatus element, removing URN prefix. -->
      <AvailabilityStatus>
         <!-- $statusTypePrefix is a global variable set in Variables.xsl -->
         <xsl:value-of select="substring-after(@status, $statusTypePrefix)"/>
      </AvailabilityStatus>
   </xsl:template>
   
   <xsl:template name="utR-directSplit">
      <xsl:param name="string"/>
      <xsl:param name="delim" select="';'"/>
      <xsl:param name="emitElementName"/>
      <!-- Given a string and a delimiter character, produce a sequence
           of elements, each having a text node that is one piece of
           the incoming string. (to be replaced by a tokenize call under
           XSLT 2.0) If the delimiter doesn't occur, the whole string is
           returned as one piece. -->
      <xsl:choose>
         <xsl:when test="not(contains($string, $delim))">
            <xsl:element name="{$emitElementName}">
               <xsl:value-of select="$string"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="current" select="substring-before($string, $delim)"/>
            <xsl:variable name="remainder" select="substring-after($string, $delim)"/>
            <!-- Should put out a zero-length string if field is empty, to maintain piece count -->
            <xsl:element name="{$emitElementName}">
               <xsl:value-of select="$current"/>
            </xsl:element>
            <xsl:choose>
               <xsl:when test="not(contains($remainder, $delim))">
                  <xsl:element name="{$emitElementName}">
                     <xsl:value-of select="$remainder"/>
                  </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                  <!-- Recursively call this template. -->
                  <xsl:call-template name="utR-directSplit">
                     <xsl:with-param name="string" select="$remainder"/>
                     <xsl:with-param name="delim" select="$delim"/>
                     <xsl:with-param name="emitElementName" select="$emitElementName"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="utR-hl7acknowledgementDetail">
      <xsl:for-each select="/root/Errors/Error">
         <hl7:acknowledgementDetail typeCode="E">
            <hl7:code code="{./Code}"/>
            <xsl:if test="./Description != ''">
               <hl7:text>
                  <xsl:value-of select="./Description"/>
               </hl7:text>
            </xsl:if>
            <xsl:if test="./Location != ''">
               <hl7:location>
                  <xsl:value-of select="./Location"/>
               </hl7:location>
            </xsl:if>
         </hl7:acknowledgementDetail>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utR-pName-attribFromElement">
      <!-- Given a context having child element with text such as <Prop>val</Prop>,
           produce an an attribute prop="val", changing capitalization -->
      <xsl:param name="inputName"/>
      <xsl:attribute name="{concat(translate(substring($inputName,1,1),$uppercase,$lowercase),substring($inputName,2))}">
         <xsl:value-of select="*[local-name()=$inputName]"/>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template name="utR-pName-elementFromAttrib">
      <!-- Given a context element having an attribute such as prop="val",
           produce an element with text <Prop>val</Prop>, changing capitalization -->
      <xsl:param name="inputName"/>
      <xsl:element name="{concat(translate(substring($inputName,1,1),$lowercase,$uppercase),substring($inputName,2))}">
         <xsl:value-of select="@*[local-name()=$inputName]"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utR-S-timestamp">
      <xsl:param name="inputString"/>
      <!-- Produce a string equal to or better than what isc:evaluate('xmltimestamp',$inputString) would get.
		     Input has the format YYYYMMDDHHNNSSpZZZZ, where all uppercase letters stand for digits and 
		     p stands for either a plus sign or minus sign. Valid input could be as short as YYYYMM for now,
		     and maybe YYYY in the future. Processing the time zone (pZZZZ) is a wish-list item.
		     Zeroes are supplied for time-of-day if some or all of the time fields are missing. -->
      <xsl:choose>
         <xsl:when test="string-length($inputString) &gt; 7">
            <xsl:variable name="nMonth" select="substring($inputString,5,2)"/>
            <xsl:if test="number($nMonth) &gt; 0 and number($nMonth) &lt; 13">
               <xsl:variable name="padded" select="concat(substring($inputString,1,14),'000000')"/>
               <!-- <xsl:variable name="nTimeOffset" select="substring($inputString,15)"/> may use this in the future -->
               <xsl:value-of select="concat(substring($inputString,1,4),'-',$nMonth,'-',substring($inputString,7,2),'T',substring($padded,9,2),':',substring($padded,11,2),':',substring($padded,13,2),'Z')"/>
            </xsl:if>
         </xsl:when>
         <xsl:when test="string-length($inputString)=6">
            <xsl:variable name="nMonth" select="substring($inputString,5,2)"/>
            <xsl:if test="number($nMonth) &gt; 0 and number($nMonth) &lt; 13">
               <xsl:value-of select="concat(substring($inputString,1,4),'-',$nMonth,'-01T00:00:00Z')"/>
            </xsl:if>
            <!-- If month is invalid, return nothing -->
         </xsl:when>
         <!-- need a policy decision on string-length($inputString)=4 - use January 01? -->
         <xsl:otherwise/><!-- Emit no content if length is 1-3, 5, 7, or 4 for the time being -->
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="utR-SourcePatientInfo">
      <!-- Produce a SourcePatientInfo element with Value sub-elements for 4 or 5 PIDs,
           (PIDs are from HL7 v2 segments; target is internal metadata object)
           taking data from the children of $patientRoot -->
      <xsl:param name="patientRoot"/><!-- node has person data in child elements -->
      <xsl:param name="emitPID3" select="0"/><!-- If 1, build PID-3 from next two params -->
      <xsl:param name="PatientMRN"/>
      <xsl:param name="SourceOID"/>
      <!-- Assemble a SourcePatientInfo element from a source node -->
      <SourcePatientInfo>
         <xsl:if test="$emitPID3 &gt; 0">
            <Value>PID-3|<xsl:value-of select="concat($PatientMRN,'^^^&amp;',$SourceOID,'&amp;ISO')"/></Value>
         </xsl:if>
         <Value>PID-5|<xsl:value-of select="concat($patientRoot/Name/FamilyName/text(),'^',$patientRoot/Name/GivenName/text())"/></Value>
         <Value>PID-7|<xsl:value-of select="translate($patientRoot/BirthTime/text(),'TZ:- ','')"/></Value>
         <Value>PID-8|<xsl:value-of select="$patientRoot/Gender/Code/text()"/></Value>
         <xsl:variable name="street" select="$patientRoot/Addresses/Address[1]/Street/text()"/>
         <!--<xsl:variable name="street1" select="isc:evaluate('piece', $street, ';', 1)"/>-->
         <xsl:variable name="street1" select="substring-before($street, ';')"/>
         <!--<xsl:variable name="street2" select="isc:evaluate('piece', $street, ';', 2)"/>-->
         <xsl:variable name="street2" select="substring-after($street, ';')"/>
         <xsl:variable name="city" select="$patientRoot/Addresses/Address[1]/City/Code/text()"/>
         <xsl:variable name="state" select="$patientRoot/Addresses/Address[1]/State/Code/text()"/>
         <xsl:variable name="zip" select="$patientRoot/Addresses/Address[1]/Zip/Code/text()"/>
         <xsl:variable name="country" select="$patientRoot/Addresses/Address[1]/Country/Code/text()"/>
         <Value>PID-11|<xsl:value-of select="concat($street1,'^',$street2,'^',$city,'^',$state,'^',$zip,'^',$country)"/></Value>
      </SourcePatientInfo>
   </xsl:template>
   
</xsl:stylesheet>