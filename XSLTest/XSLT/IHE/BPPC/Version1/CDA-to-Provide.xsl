<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Convert a BPPC CDA to a XDSb Provide using the PCC bindings with BPPC extensions
See Also: HS.IHE.BPPC.Creator.Operations, HS.IHE.BPPC.Domain
-->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:sdtc="urn:hl7-org:sdtc" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:exsl="http://exslt.org/common" 
xmlns:set="http://exslt.org/sets" 
xmlns:hl7="urn:hl7-org:v3" 
exclude-result-prefixes="isc xsi sdtc exsl set hl7">

<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- For connect-a-thon, set this to 1 to avoid doing a MPI search for the MPIID -->
<xsl:param name="patientIdIsMRN"/>

<xsl:template match="/">
<ProvideAndRegisterRequest>

<ContentTypeCode>
<Code>Communication</Code>
<Description>Communication</Description>
<Scheme>Connect-a-thon contentTypeCodes</Scheme>
</ContentTypeCode>

<SourceId>
<xsl:value-of select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id/@root"/>
</SourceId>

<xsl:if test="$patientIdIsMRN=1">
<PatientId>
<xsl:apply-templates mode="xdsId" select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id"/>
</PatientId>
</xsl:if>

<Documents>
<ProvidedDocument>
<!-- Issue replacements if for the same MRN, format code and nonXMLBody type -->
<ReplacementContext>
<QueryItem>
<ItemName>$XDSDocumentEntryFormatCode</ItemName>
<Values>
<ValuesItem>
<xsl:choose>
<xsl:when test="hl7:ClinicalDocument/hl7:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.1.7.1']">urn:ihe:iti:bppc-sd:2007^^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="hl7:ClinicalDocument/hl7:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.1.7']">urn:ihe:iti:bppc:2007^^1.3.6.1.4.1.19376.1.2.3</xsl:when>
</xsl:choose>
</ValuesItem>
</Values>
</QueryItem>
<QueryItem>
<ItemName>urn:healthshare:slots:sourcePatientId</ItemName>
<Values>
<ValuesItem>
<xsl:apply-templates mode="xdsId" select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id"/>
</ValuesItem>
</Values>
</QueryItem>
<QueryItem>
<ItemName>urn:healthshare:slots:cda:mediaType</ItemName>
<Values>
<ValuesItem>
<xsl:value-of select="hl7:ClinicalDocument/hl7:component/hl7:nonXMLBody/hl7:text/@mediaType"/>
</ValuesItem>
</Values>
</QueryItem>
</ReplacementContext>

<!-- the custom slots to support replacement -->
<DocumentSlots>
<Slot name="urn:healthshare:slots:sourcePatientId">
<ValueList>
<SlotValue>
<xsl:apply-templates mode="xdsId" select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id"/>
</SlotValue>
</ValueList>
</Slot>
<Slot name="urn:healthshare:slots:cda:mediaType">
<ValueList>
<SlotValue>
<xsl:value-of select="hl7:ClinicalDocument/hl7:component/hl7:nonXMLBody/hl7:text/@mediaType"/>
</SlotValue>
</ValueList>
</Slot>
</DocumentSlots>


<xsl:apply-templates mode="author" select="hl7:ClinicalDocument/hl7:author"/>

<ClassCode>
<Code>57016-8</Code>
<Description>Privacy Policy Acknowledgement Document</Description>
<Scheme>2.16.840.1.113883.6.1</Scheme>
</ClassCode>

<xsl:for-each select="hl7:ClinicalDocument/hl7:confidentialityCode">
<ConfidentialityCode>
<Code><xsl:value-of select="@code"/></Code>
<Description><xsl:value-of select="@displayName"/></Description>
<Scheme><xsl:value-of select="@codeSystem"/></Scheme>
</ConfidentialityCode>
</xsl:for-each>

<CreationTime>
<xsl:value-of select="isc:evaluate('xmltimestampToUTC',hl7:ClinicalDocument/hl7:effectiveTime/@value)"/>
</CreationTime>

<xsl:for-each select="hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent[hl7:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.2.6']/hl7:code">
<EventCodeList>
<Code><xsl:value-of select="@code"/></Code>
<Description><xsl:value-of select="@displayName"/></Description>
<Scheme><xsl:value-of select="@codeSystemName"/></Scheme> <!-- use the name, since the @codeSystem is the domain OID in CDA -->
</EventCodeList>
</xsl:for-each>

<FormatCode>
<xsl:choose>
<xsl:when test="hl7:ClinicalDocument/hl7:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.1.7.1']">
<Code>urn:ihe:iti:bppc-sd:2007</Code>
<Description>Basic Patient Privacy Consents with Scanned Document</Description>
<Scheme>1.3.6.1.4.1.19376.1.2.3</Scheme>
</xsl:when>
<xsl:when test="hl7:ClinicalDocument/hl7:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.1.7']">
<Code>urn:ihe:iti:bppc:2007</Code>
<Description>Basic Patient Privacy Consents</Description>
<Scheme>1.3.6.1.4.1.19376.1.2.3</Scheme>
</xsl:when>
</xsl:choose>
</FormatCode>

<HealthcareFacilityTypeCode>
<Code>GIM</Code>
<Description>General internal medicine clinic</Description>
<Scheme>2.16.840.1.113883.5.11</Scheme>  <!-- NOTE: required by ITI TFv3, but not in the ihexds.nist.gov code listing -->
</HealthcareFacilityTypeCode>

<LanguageCode>
<xsl:value-of select="hl7:ClinicalDocument/hl7:languageCode/@code"/>
</LanguageCode>

<MimeType>text/xml</MimeType>

<PracticeSettingCode>
<Code>394802001</Code>
<Description>General Medicine</Description>
<Scheme>2.16.840.1.113883.6.96</Scheme>
</PracticeSettingCode>

<xsl:apply-templates mode="serviceStartStopTimes" select="hl7:ClinicalDocument/hl7:documentationOf[1]/hl7:serviceEvent[1]/hl7:effectiveTime"/>

<SourcePatientId>
<xsl:apply-templates mode="xdsId" select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id"/>
</SourcePatientId>

<xsl:if test="$patientIdIsMRN=1">
<PatientId>
<xsl:apply-templates mode="xdsId" select="hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:id"/>
</PatientId>
</xsl:if>

<Title>
<xsl:value-of select="hl7:ClinicalDocument/hl7:title"/>
</Title>

<TypeCode>
<Code>11488-4</Code>
<Description>Consultation Note</Description>
<Scheme>LOINC</Scheme>
</TypeCode>

<UniqueId>
<xsl:value-of select="hl7:ClinicalDocument/hl7:id/@root"/>
<xsl:if test="string-length(hl7:ClinicalDocument/hl7:id/@extension)>0">
<xsl:value-of select="concat('^',hl7:ClinicalDocument/hl7:id/@extension)"/>
</xsl:if>
</UniqueId>

</ProvidedDocument>
</Documents>
</ProvideAndRegisterRequest>
</xsl:template>

<xsl:template mode="author" match="hl7:author">
<xsl:apply-templates mode="author" select="hl7:assignedAuthor/hl7:assignedPerson"/>
</xsl:template>

<xsl:template mode="author" match="hl7:assignedPerson">
<Author>
<AuthorPerson>
<xsl:value-of select="../hl7:id/@extension"/>
<xsl:value-of select="concat('^',hl7:name/hl7:family/text())"/>
<xsl:value-of select="concat('^',hl7:name/hl7:given[1]/text())"/>
<xsl:value-of select="concat('^',hl7:name/hl7:given[2]/text())"/>
<xsl:value-of select="concat('^',hl7:name/hl7:suffix/text())"/>
<xsl:value-of select="concat('^',hl7:name/hl7:prefix/text())"/>
<xsl:value-of select="concat('^^^&amp;',../hl7:id/@root,'&amp;ISO')"/>
</AuthorPerson>
</Author>
</xsl:template>

<xsl:template mode="serviceStartStopTimes" match="hl7:effectiveTime">
<xsl:if test="string-length(hl7:low/@value)>0">
<ServiceStartTime>
<xsl:value-of select="hl7:low/@value"/>
</ServiceStartTime>
</xsl:if>
<xsl:if test="string-length(hl7:high/@value)>0">
<ServiceStopTime>
<xsl:value-of select="hl7:high/@value"/>
</ServiceStopTime>
</xsl:if>
</xsl:template>

<xsl:template mode="xdsId" match="hl7:id">
<xsl:value-of select="concat(@extension,'^^^&amp;',@root,'&amp;ISO')"/>
</xsl:template>
</xsl:stylesheet>
