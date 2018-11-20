<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:here="http://xslt.intersystems.com/lookup"
   exclude-result-prefixes="here">
   <!-- Contains shared routines to support rapid access to properties of a
        Classification Scheme of a rim:Classification or Identification
        Scheme of a rim:ExternalIdentifier. In the future, this could be
        used for similar mapping of ClassificationNode or other types of
        UUIDs that map to and from strings. -->
   <!-- The prefix for template/mode names in this file is "utMU" -->
   
   <!-- ***** key ***** -->
   <xsl:key name="classificationByEname" match="here:classification/row" use="Ename"/>
   <xsl:key name="classificationByURN" match="here:classification/row" use="URN"/>
   <xsl:key name="identSchemeByAnyNameType" match="here:identScheme/row" use="OtherName"/>
   <xsl:key name="identSchemeByAnyNameType" match="here:identScheme/row" use="ShortName"/>
   <xsl:key name="identSchemeByAnyNameType" match="here:identScheme/row" use="LongName"/>
   <xsl:key name="identSchemeByNameLS" match="here:identScheme/row" use="NameLS"/>
   <xsl:key name="identSchemeByURN" match="here:identScheme/row" use="URN"/>
   <xsl:key name="identSchemeByLNameType" match="here:identScheme/row" use="concat(ItemType,LongName)"/>
   <xsl:key name="identSchemeBySNameType" match="here:identScheme/row" use="concat(ItemType,ShortName)"/>
   
   <!-- ***** Top-level data tables ***** -->
   <here:classification>
      <row><Ename>FormatCode</Ename><URN>urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d</URN></row>
      <row><Ename>ClassCode</Ename><URN>urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a</URN></row>
      <row><Ename>ConfidentialityCode</Ename><URN>urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f</URN></row>
      <row><Ename>ContentTypeCode</Ename><URN>urn:uuid:aa543740-bdda-424e-8c96-df4873be8500</URN></row>
      <row><Ename>EventCodeList</Ename><URN>urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4</URN></row>
      <row><Ename>HealthCareFacilityTypeCode</Ename><URN>urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1</URN></row>
      <row><Ename>TypeCode</Ename><URN>urn:uuid:f0306f51-975f-434e-a61c-c59651d33983</URN></row>
      <row><Ename>PracticeSettingCode</Ename><URN>urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead</URN></row>
      <row><Ename>CodeList</Ename><URN>urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5</URN></row>
      <!-- Below: extra rows for old name formats -->
      <row><Ename>HealthcareFacilityTypeCode</Ename><URN>urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1</URN></row>
   </here:classification>
   <!-- ToDo: HealthCareFacilityTypeCode is the newer MetadataObject format.
        Need a kluge to handle HealthcareFacilityTypeCode -->
   
   <here:identScheme>
      <!-- Rows for Document must come first! -->
      <row>
         <NameLS>XDSDocumentEntry.uniqueId</NameLS>
         <ItemType>Document</ItemType>
         <ShortName>UniqueId</ShortName>
         <LongName>DocumentUniqueIdentifier</LongName>
         <URN>urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab</URN>
         <OtherName>DocumentUniqueId</OtherName>
         <OtherName>DocumentID</OtherName>
         <OtherName>DocumentNumber</OtherName>
      </row>
      <row>
         <NameLS>XDSDocumentEntry.patientId</NameLS>
         <ItemType>Document</ItemType>
         <ShortName>PatientId</ShortName>
         <LongName>PatientIdentifier</LongName>
         <URN>urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427</URN>
         <OtherName>PatientID</OtherName>
      </row>
      <row>
         <NameLS>XDSFolder.uniqueId</NameLS>
         <ItemType>Folder</ItemType>
         <ShortName>UniqueId</ShortName>
         <LongName>UniqueIdentifier</LongName>
         <URN>urn:uuid:75df8f67-9973-4fbe-a900-df66cefecc5a</URN>
      </row>
      <row>
         <NameLS>XDSFolder.patientId</NameLS>
         <ItemType>Folder</ItemType>
         <ShortName>PatientId</ShortName>
         <LongName>PatientIdentifier</LongName>
         <URN>urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a</URN>
      </row>
      <row>
         <NameLS>XDSSubmissionSet.uniqueId</NameLS>
         <ItemType>Submission</ItemType>
         <ShortName>UniqueId</ShortName>
         <LongName>UniqueIdentifier</LongName>
         <URN>urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8</URN>
      </row>
      <row>
         <NameLS>XDSSubmissionSet.patientId</NameLS>
         <ItemType>Submission</ItemType>
         <ShortName>PatientId</ShortName>
         <LongName>PatientIdentifier</LongName>
         <URN>urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446</URN>
      </row>
      <row>
         <NameLS>XDSSubmissionSet.sourceId</NameLS>
         <ItemType>Submission</ItemType>
         <ShortName>SourceId</ShortName>
         <LongName>SourceIdentifier</LongName>
         <URN>urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832</URN>
      </row>
   </here:identScheme>
   
   <!-- ***** Top-level variables ***** -->
   <xsl:variable name="classificationTable" select="document('')/*/here:classification"/>
   <xsl:variable name="identSchemeTable" select="document('')/*/here:identScheme"/>
   
   <!-- Invocation example: 
      At the point in the output stream where you need to emit the URN as text node or
      attribute value, and having local-name(.) as the associated "Ename" string...
      <xsl:apply-templates select="$classificationTable" mode="utMU-getClassifURN">
         <xsl:with-param name="lookup" select="local-name(.)"/>
      </xsl:apply-templates>
      
      Above is for XSLT 1.0; in XSLT 2.0, you can just do...
      <xsl:value-of select="key('classificationByEname',local-name(.),$classificationTable)/URN"/>
   -->
   
   <xsl:template match="here:classification" mode="utMU-getClassifEname">
      <!-- For Classification Schemes.
           Input: URN; Output: keyword, which can be used as element name -->
      <xsl:param name="urn"/>
      <xsl:value-of select="key('classificationByURN',$urn)[1]/Ename"/>
   </xsl:template>
   
   <xsl:template match="here:classification" mode="utMU-getClassifURN">
      <!-- For Classification Schemes.
           Input: keyword (ClassCode, TypeCode, etc.); Output: URN -->
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('classificationByEname',$lookup)/URN"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentItemType">
      <!-- Input: URN; Output: type keyword (Document, Folder, Submission) -->
      <xsl:param name="urn"/>
      <xsl:value-of select="key('identSchemeByURN',$urn)/ItemType"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentLName">
      <!-- Input: URN; Output: Long name (e.g., SourceIdentifier) -->
      <xsl:param name="urn"/>
      <xsl:value-of select="key('identSchemeByURN',$urn)/LongName"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentNameLS-byLName">
      <!-- Input: both type and long name; Output: NameLS (e.g., XDSFolder.patientId) -->
      <xsl:param name="itemType" select="'Document'"/>
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('identSchemeByLNameType',concat($itemType,$lookup))/NameLS"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentNameLS-bySName">
      <!-- Input: both type and short name; Output: NameLS (e.g., XDSFolder.patientId) -->
      <xsl:param name="itemType" select="'Document'"/>
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('identSchemeBySNameType',concat($itemType,$lookup))/NameLS"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentNameLS-byURN">
      <!-- Input: URN; Output: NameLS (e.g., XDSFolder.patientId) -->
      <xsl:param name="urn"/>
      <xsl:value-of select="key('identSchemeByURN',$urn)/NameLS"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentSName-byNameLS">
      <!-- Input: NameLS (e.g., XDSFolder.patientId); Output: Short name (e.g., PatientId) -->
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('identSchemeByNameLS',$lookup)/ShortName"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentSName-byURN">
      <!-- Input: URN; Output: Short name (e.g., UniqueId) -->
      <xsl:param name="urn"/>
      <xsl:value-of select="key('identSchemeByURN',$urn)/ShortName"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentURN-byAnyName">
      <!-- Input: any name; Output: URN
           The name must be found as ShortName, LongName, or OtherName
           for the Document item type in the identScheme table above. -->
      <xsl:param name="itemType" select="'Document'"/>
      <xsl:param name="lookup"/>
      <xsl:variable name="found" select="key('identSchemeByAnyNameType',$lookup)/URN"/>
      <!-- In XSLT 1.0, returns are not specified to be in document order. Need to pick
           the correct one if multiple nodes returned. In XSLT 2.0, take the first one. -->
      <xsl:choose>
         <xsl:when test="count($found)=1"><xsl:value-of select="$found"/></xsl:when>
         <xsl:when test="count($found)=0">
            <xsl:message terminate="no">
               <xsl:value-of select="concat('ERROR: no matching URN for ',$lookup,' of a ',$itemType)"/>
            </xsl:message>
            <xsl:text/>
         </xsl:when>
         <xsl:otherwise>
            <!-- We got more than one URN. Pick the one pertaining to Document. -->
            <xsl:value-of select="key('identSchemeByURN',$found)[ItemType=$itemType]/URN"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentURN-byNameLS">
      <!-- Input: NameLS (e.g., XDSFolder.patientId); Output: URN -->
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('identSchemeByNameLS',$lookup)/URN"/>
   </xsl:template>
   
   <xsl:template match="here:identScheme" mode="utMU-getIdentURN-bySName">
      <!-- Input: both type and short name; Output: URN -->
      <xsl:param name="itemType" select="'Document'"/>
      <xsl:param name="lookup"/>
      <xsl:value-of select="key('identSchemeBySNameType',concat($itemType,$lookup))/URN"/>
   </xsl:template>
   
</xsl:stylesheet>