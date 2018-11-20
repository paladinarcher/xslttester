<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Convert a SDA Container into an intermediate XML representation of a XDSb ProvideAndRegisterDocumentSet-b request. 
See class HS.IHE.XDSb.Types.ProvideAndRegisterDocumentSet for details.

The a separate XDSb document is generated for each SDA encounter

This transform uses the IHE configuration and must be customized for each Affinity Domain.
TODO: create parameters affinity domain specific values, similar to DocumentFormat
-->

<xsl:stylesheet version="1.0" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- PARAMETERS
PatientMRN 				- Patient MRN
Facility 	 				- MRN facility
PatientID 				- Affinity domain ID (usually the MPI ID)
AffinityDomainOID - OID of the Affinity domain
SourceOID 				- OID of the source facility or gateway
DocumentFormat		- MIME TYPE|CODE|SCHEME|DESCRIPTION
-->
<xsl:param name="PatientMRN"/>        
<xsl:param name="Facility"/>
<xsl:param name="PatientID"/>
<xsl:param name="AffinityDomainOID"/>
<xsl:param name="SourceOID"/>
<xsl:param name="DocumentFormat"/>

<xsl:template match="/">
<ProvideAndRegisterDocumentSet>
<SubmissionSet>

<!-- skipping submission set author: optional, and makes more sense at the document level -->

<Comments>
<xsl:value-of select="/Container/EventDescription/text()"/>
</Comments>

<ContentTypeCode>
<Code>Summarization of episode</Code>
<Description>Summarization of episode</Description>
<Scheme>Connect-a-thon contentTypeCodes</Scheme>
</ContentTypeCode>

<PatientId>
<xsl:value-of select="concat($PatientID,'^^^&amp;',$AffinityDomainOID,'&amp;ISO')"/>
</PatientId>

<SourceId>
<xsl:value-of select="$SourceOID"/>
</SourceId>

<SubmissionTime>
<xsl:value-of select="isc:evaluate('createHL7Timestamp')"/>
</SubmissionTime>

<Title>Encounter Summary</Title>

<UniqueId>
<xsl:value-of select="isc:evaluate('createOID')"/>
</UniqueId>
</SubmissionSet>

<xsl:for-each select="/Container/Patients/Patient[1]/Encounters/Encounter">
<xsl:variable name="docUUID" select="isc:evaluate('createUUID')"/>
<xsl:variable name="docKey">
<xsl:value-of select="concat(HealthCareFacility/Organization/Code/text(),'|',HealthCareFacility/Code/text(),'|',$Facility,'|',$PatientMRN ,'|',VisitNumber/text())"/>
</xsl:variable>

<Document>
<!-- author -->
<xsl:apply-templates mode="author" select="AdmittingClinician">
<xsl:with-param name="docUUID" select="$docUUID"/>
<xsl:with-param name="authorRole" select="'Admitting'"/>
<xsl:with-param name="authorInstitution" select="HealthCareFacility"/>
</xsl:apply-templates>
<xsl:apply-templates mode="author" select="AttendingClinicians/CareProvider">
<xsl:with-param name="docUUID" select="$docUUID"/>
<xsl:with-param name="authorRole" select="'Attending'"/>
<xsl:with-param name="authorInstitution" select="HealthCareFacility"/>
</xsl:apply-templates>
<xsl:apply-templates mode="author" select="ConsultingClinicians/CareProvider">
<xsl:with-param name="docUUID" select="$docUUID"/>
<xsl:with-param name="authorRole" select="'Consulting'"/>
<xsl:with-param name="authorInstitution" select="HealthCareFacility"/>
</xsl:apply-templates>


<ClassCode>
<Code>Summarization of episode</Code>
<Description>Summarization of episode</Description>
<Scheme>Connect-a-thon classCodes</Scheme>
</ClassCode>

<Comments>  <!-- todo: clean this up -->
<xsl:value-of select="EncounterType/text()"/>
<xsl:value-of select="StartTime/text()"/>
</Comments>

<ConfidentialityCode>
<Code>N</Code>
<Description>Normal</Description>
<Scheme>2.16.840.1.113883.5.25</Scheme>
</ConfidentialityCode>

<CreationTime>
<xsl:choose>
<xsl:when test="EnteredOn">
<xsl:value-of select="translate(EnteredOn/text(), 'TZ:- ', '')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="isc:evaluate('createHL7Timestamp')"/>
</xsl:otherwise>
</xsl:choose>
</CreationTime>

<EntryUUID>
<xsl:value-of select="$docUUID"/>
</EntryUUID>

<!--TODO: <eventCodeList/> -->

<FormatCode>
<xsl:choose>
<xsl:when test="$DocumentFormat">
<Code><xsl:value-of select="isc:evaluate('piece',$DocumentFormat,'|',2)"/></Code>
<Description><xsl:value-of select="isc:evaluate('piece',$DocumentFormat,'|',4,99999)"/></Description>
<Scheme><xsl:value-of select="isc:evaluate('piece',$DocumentFormat,'|',3)"/></Scheme>
</xsl:when>
<xsl:otherwise>
<Code>TEXT</Code>
<Description>TEXT</Description>
<Scheme>Connect-a-thon formatCodes</Scheme>
</xsl:otherwise>
</xsl:choose>
</FormatCode>

<HealthcareFacilityTypeCode>
<xsl:variable name="hcfCode" select="EncounterType/text()"/>
<xsl:choose>
<xsl:when test="$hcfCode = 'E'">
<Code>Emergency Department</Code>
<Description>Emergency Department</Description>
</xsl:when>
<xsl:when test="$hcfCode = 'I'">
<Code>Hospital Setting</Code>
<Description>Hospital Setting</Description>
</xsl:when>
<xsl:otherwise>
<Code>Outpatient</Code>
<Description>Outpatient</Description>
</xsl:otherwise>
</xsl:choose>
<Scheme>Connect-a-thon healthcareFacilityTypeCodes</Scheme>
</HealthcareFacilityTypeCode>

<Key>
<xsl:value-of select="$docKey"/>
</Key>

<LanguageCode>en-us</LanguageCode>

<LegalAuthenticator/>

<MimeType>
<xsl:choose>
<xsl:when test="$DocumentFormat">
<xsl:value-of select="isc:evaluate('piece',$DocumentFormat,'|',1)"/>
</xsl:when>
<xsl:otherwise>text/xml</xsl:otherwise>
</xsl:choose>
</MimeType>

<PatientId>
<xsl:value-of select="concat($PatientID,'^^^&amp;',$AffinityDomainOID,'&amp;ISO')"/>
</PatientId>

<PracticeSettingCode>
<Code>General Medicine</Code>
<Description>General Medicine</Description>
<Scheme>Connect-a-thon practiceSettingCodes</Scheme>
</PracticeSettingCode>

<PreviousUUID>
<xsl:value-of select="isc:evaluate('getPreviousUUID',$docKey)"/>
</PreviousUUID>

<ServiceStartTime>
<xsl:value-of select="translate(StartTime/text(),'-:TZ ','')"/>
</ServiceStartTime>
<ServiceStopTime>
<xsl:value-of select="translate(EndTime/text(),'-:TZ ','')"/>
</ServiceStopTime>

<SourcePatientId>
<xsl:value-of select="concat($PatientMRN,'^^^&amp;',$SourceOID,'&amp;ISO')"/>
</SourcePatientId>

<SourcePatientInfo>
<Value>PID-3|<xsl:value-of select="concat($PatientMRN,'^^^&amp;',$SourceOID,'&amp;ISO')"/></Value>
<Value>PID-5|<xsl:value-of select="concat(../../Name/FamilyName/text(),'^',../../Name/GivenName/text())"/></Value>
<Value>PID-7|<xsl:value-of select="translate(../../BirthTime/text(),'TZ:- ','')"/></Value>
<Value>PID-8|<xsl:value-of select="../../Gender/Code/text()"/></Value>
<xsl:variable name="street" select="../../Address/Address[1]/Street/text()"/>
<xsl:variable name="street1" select="isc:evaluate('piece',$street,';',1)"/>
<xsl:variable name="street2" select="isc:evaluate('piece',$street,';',2)"/>
<xsl:variable name="city" select="../../Address/Address[1]/City/Code/text()"/>
<xsl:variable name="state" select="../../Address/Address[1]/State/Code/text()"/>
<xsl:variable name="zip" select="../../Address/Address[1]/Zip/Code/text()"/>
<xsl:variable name="country" select="../../Address/Address[1]/Country/Code/text()"/>
<Value>PID-11|<xsl:value-of select="concat($street1,'^',$street2,'^',$city,'^',$state,'^',$zip,'^',$country)"/></Value>
</SourcePatientInfo>

<Title>Encounter Detail</Title>

<TypeCode>
<Code>34133-9</Code>
<Description>Summarization of Episode Note</Description>
<Scheme>LOINC</Scheme>
</TypeCode>

<UniqueId>
<xsl:value-of select="isc:evaluate('uuid2oid',$docUUID)"/>
</UniqueId>

<!-- The body is character based, so it is written to a temporary stream rather than converted to base64 -->
<BodyTmp>
<xsl:copy-of select="/"/>
</BodyTmp>

</Document>
</xsl:for-each>
</ProvideAndRegisterDocumentSet>
</xsl:template>

<!-- Construct an author node from a SDA CareProvider -->
<xsl:template match="*" mode="author">
<xsl:param name="docUUID"/>
<xsl:param name="authorRole"/>
<xsl:param name="authorInstitution"/>

<!-- duplicate check -->
<xsl:if test="0=isc:evaluate('varData','author',$docUUID,Code/text(),SDACodingStandard/text())">
<xsl:variable name="seen" select="isc:evaluate('varSet','author',$docUUID,Code/text(),SDACodingStandard/text())"/>
<Author>
<AuthorPerson>
<xsl:value-of select="concat('^',Name/FamilyName/text(),'^',Name/GivenName/text(),'^^^')"/>
</AuthorPerson>
<AuthorInstitution>
<Value><xsl:apply-templates select="$authorInstitution" mode="getDescription"/></Value>
</AuthorInstitution>
<AuthorRole>
<Value><xsl:value-of select="$authorRole"/></Value>
</AuthorRole>
<AuthorSpecialty>
<Value><xsl:apply-templates select="CareProviderType" mode="getDescription"/></Value>
</AuthorSpecialty>
</Author>
</xsl:if>
</xsl:template>

<!-- Get the best code table description we can -->
<xsl:template match="*" mode="getDescription">
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


</xsl:stylesheet>
