<?xml version="1.0" encoding="UTF-8"?>
<!--

CDA generator for OnDemand C62 unstructured document

Based on SDA-to-CCDA-USD.xsl, modified to match VA samples

-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
<xsl:include href="../CDA-Support-Files/System/Templates/TemplateIdentifiers-HL7.xsl"/>
<xsl:include href="../CDA-Support-Files/System/Templates/TemplateIdentifiers-IHE.xsl"/>
<xsl:include href="../CDA-Support-Files/System/OIDs/OIDs-InterSystems.xsl"/>
<xsl:include href="../CDA-Support-Files/System/OIDs/OIDs-Other.xsl"/>
<xsl:include href="../CDA-Support-Files/System/Common/Functions.xsl"/>
<xsl:include href="../CDA-Support-Files/Export/Common/Functions.xsl"/>
<xsl:include href="../CDA-Support-Files/Export/Common/Variables.xsl"/>
<xsl:include href="../CDA-Support-Files/Site/Variables.xsl"/>	
<xsl:include href="../CDA-Support-Files/Export/Entry-Modules/Comment.xsl"/>
<xsl:include href="../CDA-Support-Files/Export/Entry-Modules/PersonalInformation.xsl"/>
<xsl:include href="../CDA-Support-Files/Export/Entry-Modules/LanguageSpoken.xsl"/>
<xsl:include href="../CDA-Support-Files/Export/Section-Modules/CCDA/Non-RatifiedSections.xsl"/>  <!-- intentional CCDA, it uses correct @mediaType -->
<!--  for now use indent to make it easier to inspect output in soapUI -->
<!-- <xsl:include href="../CDA-Support-Files/Site/OutputEncoding.xsl"/> -->
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:include href="Utility.xsl"/>

<xsl:template match="/Container">

<xsl:processing-instruction name="xml-stylesheet">
<xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
</xsl:processing-instruction>

<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="{$hl7-CCD-GeneralHeader}"/>
<templateId root="{$ihe-MedicalDocumentsSpecification}"/>
<templateId root="'2.16.840.1.113883.3.88.11.62.1'"/>  <!-- HITSP C62 -->
<templateId root="{$ihe-XDS-SD}"/>
<templateId root="'2.16.840.1.113883.10.20.19.1'"/> <!-- HL7 Unstructured Documents -->

<xsl:apply-templates select="Patient" mode="id-Document"/>

<xsl:variable name="type">
<xsl:call-template name="toLOINC">
<xsl:with-param name="type" select="Documents/Document/DocumentType/Code"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="typeCode" select="substring-before($type,'^')"/>
<xsl:variable name="typeDesc" select="substring-before(substring-after($type,'^'),'^')"/>
<code code="{$typeCode}" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="{$typeDesc}"/>

<xsl:apply-templates select="." mode="document-title">
<xsl:with-param name="title1" select="$typeDesc"/>
</xsl:apply-templates>

<effectiveTime>
<xsl:attribute name="value">
<xsl:apply-templates select="Documents/Document/DocumentTime" mode="xmlToHL7TimeStamp"/>
</xsl:attribute>
</effectiveTime>

<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>

<languageCode code="en-US"/>

<xsl:apply-templates select="Patient" mode="personInformation"/>

<author>
<templateId root="1.3.6.1.4.1.19376.1.2.20.1"/>
<time>
<xsl:attribute name="value">
<xsl:apply-templates select="Documents/Document/DocumentTime" mode="xmlToHL7TimeStamp"/>
</xsl:attribute>
</time>
<xsl:apply-templates select="Documents/Document/Clinician" mode="assignedAuthor-Human"/>
</author>

<author>
<templateId root="1.3.6.1.4.1.19376.1.2.20.2"/>
<time>
<xsl:attribute name="value">
<xsl:apply-templates select="Documents/Document/DocumentTime" mode="xmlToHL7TimeStamp"/>
</xsl:attribute>
</time>
<assignedAuthor>
<id root="{$homeCommunityOID}"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedAuthoringDevice>
<code code="WSD" codeSystem="1.2.840.10008.2.16.4" displayName="Workstation"/>
<manufacturerModelName>Department of Veterans Affairs</manufacturerModelName>
<softwareName>VA Computerized Patient Record System (CPRS)</softwareName>
</assignedAuthoringDevice>
<xsl:apply-templates select="$homeCommunity/Organization" mode="representedOrganization-Document"/>
</assignedAuthor>
</author>

<dataEnterer>
<templateId root="1.3.6.1.4.1.19376.1.2.20.3"/>
<time>
<xsl:attribute name="value">
<xsl:apply-templates select="Documents/Document/EnteredOn" mode="xmlToHL7TimeStamp"/>
</xsl:attribute>
</time>
<assignedEntity>
<!-- TODO: not sure where to pull id/@extension here, supposed to be workstation id -->
<id root="{$homeCommunityOID}"/>
<assignedPerson>
<name>VA Computerized Patient Record System (CPRS)</name>
</assignedPerson>
</assignedEntity>
</dataEnterer>

<xsl:apply-templates select="$homeCommunity/Organization" mode="custodian"/>

<xsl:if test="Documents/Document/AuthorizationTime">
<legalAuthenticator>
<time>
<xsl:attribute name="value">
<xsl:apply-templates select="Documents/Document/AuthorizationTime" mode="xmlToHL7TimeStamp"/>
</xsl:attribute>
</time>
<signatureCode code="S"/>
<xsl:apply-templates select="Documents/Document/Clinician" mode="assignedEntity-performer"/>
</legalAuthenticator>
</xsl:if>

<documentationOf>
<serviceEvent>
<xsl:apply-templates select="/Container/Encounters/Encounter" mode="effectiveTime-FromTo"/>
</serviceEvent>
</documentationOf>

<xsl:apply-templates select="." mode="nonXMLBody"/>
</ClinicalDocument>
</xsl:template>
</xsl:stylesheet>
