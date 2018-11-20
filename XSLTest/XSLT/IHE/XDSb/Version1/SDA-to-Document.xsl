<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Convert a SDA Container into an intermediate XML representation of a XDSb ProvideAndRegisterDocumentSet-b request. 
See class HS.IHE.XDSb.Types.ProvideAndRegisterDocumentSet for details.

A single XDSb document is generated for each SDA container.

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
<xsl:apply-templates select="Container/Patients/Patient[1]"/>
</xsl:template>	

<xsl:template match="Patient">
<ProvideAndRegisterDocumentSet>
<SubmissionSet>

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

<Title>Patient Summary</Title>

<UniqueId>
<xsl:value-of select="isc:evaluate('createOID')"/>
</UniqueId>
</SubmissionSet>

<xsl:variable name="docUUID" select="isc:evaluate('createUUID')"/>
<xsl:variable name="docKey">
<xsl:value-of select="concat($PatientID,'|',$AffinityDomainOID)"/>
</xsl:variable>

<Document>
<Author>
<AuthorPerson>
<xsl:value-of select="isc:evaluate('getCodeForOID',$AffinityDomainOID,'AssigningAuthority')"/>
</AuthorPerson>
<AuthorInstitution>
<Value><xsl:value-of select="isc:evaluate('getCodeForOID',$AffinityDomainOID,'AssigningAuthority')"/></Value>
</AuthorInstitution>
</Author>

<ClassCode>
<Code>Summarization of episode</Code>
<Description>Summarization of episode</Description>
<Scheme>Connect-a-thon classCodes</Scheme>
</ClassCode>

<Comments/>

<ConfidentialityCode>
<Code>N</Code>
<Description>Normal</Description>
<Scheme>2.16.840.1.113883.5.25</Scheme>
</ConfidentialityCode>

<CreationTime>
<xsl:value-of select="isc:evaluate('createHL7Timestamp')"/>
</CreationTime>

<EntryUUID>
<xsl:value-of select="$docUUID"/>
</EntryUUID>

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
<Code>385432009</Code>
<Description>Not Applicable</Description>
<Scheme>SNOMED</Scheme>
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
<Code>385432009</Code>
<Description>Not Applicable</Description>
<Scheme>SNOMED</Scheme>
</PracticeSettingCode>

<PreviousUUID>
<xsl:value-of select="isc:evaluate('getPreviousUUID',$docKey)"/>
</PreviousUUID>

<SourcePatientId>
<xsl:value-of select="concat($PatientMRN,'^^^&amp;',$SourceOID,'&amp;ISO')"/>
</SourcePatientId>

<SourcePatientInfo>
<Value>PID-3|<xsl:value-of select="concat($PatientMRN,'^^^&amp;',$SourceOID,'&amp;ISO')"/></Value>
<Value>PID-5|<xsl:value-of select="concat(Name/FamilyName/text(),'^',Name/GivenName/text())"/></Value>
<Value>PID-7|<xsl:value-of select="translate(BirthTime/text(),'TZ:- ','')"/></Value>
<Value>PID-8|<xsl:value-of select="Gender/Code/text()"/></Value>
<xsl:variable name="street" select="Address/Address[1]/Street/text()"/>
<xsl:variable name="street1" select="isc:evaluate('piece',$street,';',1)"/>
<xsl:variable name="street2" select="isc:evaluate('piece',$street,';',2)"/>
<xsl:variable name="city" select="Address/Address[1]/City/Code/text()"/>
<xsl:variable name="state" select="Address/Address[1]/State/Code/text()"/>
<xsl:variable name="zip" select="Address/Address[1]/Zip/Code/text()"/>
<xsl:variable name="country" select="Address/Address[1]/Country/Code/text()"/>
<Value>PID-11|<xsl:value-of select="concat($street1,'^',$street2,'^',$city,'^',$state,'^',$zip,'^',$country)"/></Value>
</SourcePatientInfo>

<Title>Patient Detail</Title>

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
</ProvideAndRegisterDocumentSet>
</xsl:template>

</xsl:stylesheet>
