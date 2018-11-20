<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Convert a list of BPPC policies and a SDA container into a BPPC CDA document
See Also: HS.IHE.BPPC.Creator.Operations, HS.IHE.BPPC.Domain
-->
<xsl:stylesheet version="1.0" 
xmlns="urn:hl7-org:v3" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:sdtc="urn:hl7-org:sdtc" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:exsl="http://exslt.org/common" 
xmlns:set="http://exslt.org/sets" 
exclude-result-prefixes="isc xsi sdtc exsl set">
<xsl:include href="../../../SDA3/SDA-to-C32v25.xsl"/>

<xsl:template match="/">
<xsl:apply-templates mode="bppc" select="//Container"/>
</xsl:template>

<xsl:template mode="bppc" match="Container">
<xsl:variable name="hasScannedPart">
<xsl:choose>
<xsl:when test="string-length(Documents/Document/NoteText/text())>0">1</xsl:when>
<xsl:when test="string-length(Documents/Document/Stream/text())>0">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="{$hl7-CCD-GeneralHeader}"/>
<templateId root="{$hl7-CDA-Level1Declaration}"/>
<templateId root="{$hl7-CDA-Level2Declaration}"/>
<templateId root="{$hl7-CDA-Level3Declaration}"/>
<templateId root="{$ihe-MedicalDocumentsSpecification}"/>
<templateId root="{$ihe-BPPC}"/>
<xsl:if test="$hasScannedPart=1">	
<templateId root="{$ihe-BPPC-SD}"/>
<templateId root="{$ihe-XDS-SD}"/>
</xsl:if>

<id root="{isc:evaluate('createOID')}"/>
<code code="57016-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Privacy Policy Acknowledgement Document" />
<title>Basic Patient Privacy Consent Document</title>
<effectiveTime value="{$currentDateTime}"/>
<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25" displayName="Normal"/>
<languageCode code="en-US"/>

<xsl:apply-templates select="Patient" mode="personInformation"/>

<!-- The BPPC author must be the patient -->
<author typeCode="AUT">
<xsl:if test="$hasScannedPart=1">
<!-- TODO: (NA2013) IHE gave us the wrong template, keep an eye out for update to the spec -->
<templateId root="{$ihe-XDS-SD-OriginalAuthor}"/>
</xsl:if>
<time value="{translate(Documents/Document/DocumentTime/text(), 'TZ:- ', '')}"/>
<assignedAuthor classCode="ASSIGNED">
<xsl:apply-templates select="Patient" mode="id-Patient"/>
<code nullFlavor="NA">
<originalText>PATIENT</originalText>
</code>
<xsl:apply-templates select="Patient/Addresses" mode="address-WorkPrimary"/>
<xsl:apply-templates select="Patient" mode="telecom"/>
<xsl:apply-templates select="Patient" mode="assignedPerson"/>
<xsl:apply-templates select="Patient/EnteredAt" mode="representedOrganization"/>
</assignedAuthor>
</author>

<xsl:if test="$hasScannedPart=1">
<author typeCode="AUT">
<templateId root="{$ihe-XDS-SD-ScanningDevice}"/>
<time value="{$currentDateTime}"/>
<assignedAuthor>
<id>  <!-- root is required, so using the source facility OID -->
<xsl:attribute name="root">
<xsl:apply-templates select="." mode="oid-for-code">
<xsl:with-param name="Code" select="SendingFacility"/>
</xsl:apply-templates>
</xsl:attribute>
</id>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedAuthoringDevice>
<xsl:choose>
<xsl:when test="Documents/Document/NoteText">
<code code="WSD" codeSystem="1.2.840.10008.2.16.4" displayName="Workstation"/>
</xsl:when>
<xsl:otherwise>
<code code="CAPTURE" codeSystem="1.2.840.10008.2.16.4" displayName="Image Capture"/>
</xsl:otherwise>
</xsl:choose>
<manufacturerModelName nullFlavor="UNK"/>
<softwareName nullFlavor="UNK"/>
</assignedAuthoringDevice>
<xsl:apply-templates select="Documents/Document/EnteredAt" mode="representedOrganization"/>
</assignedAuthor>
</author>

<dataEnterer>
<templateId root="{$ihe-XDS-SD-ScannerOperator}"/>
<time value="{$currentDateTime}"/>
<xsl:apply-templates select="Documents/Document/EnteredBy" mode="assignedEntity-performer"/>
</dataEnterer>
</xsl:if>

<xsl:apply-templates select="$homeCommunity/Organization" mode="custodian"/>

<!-- TODO: legal authenticator, use the HS.SDA3.Document.Clinician? -->

<documentationOf typeCode="DOC">
<xsl:for-each select="//PatientPolicy">
<serviceEvent classCode="ACT" moodCode="EVN">
<templateId root="{$ihe-BPPC-ConsentServiceEvent}"/>
<id root="{isc:evaluate('createOID')}"/>
<code code="{OID/text()}" codeSystem="{System/text()}" codeSystemName="{Scheme/text()}" displayName="{Name/text()}" />
<effectiveTime>
<low value="{translate(StartTime/text(),'TZ:- ','')}"/>
<xsl:if test="EndTime">
<high value="{translate(EndTime/text(),'TZ:- ','')}"/>
</xsl:if>
</effectiveTime>
</serviceEvent>
</xsl:for-each>
</documentationOf>

<component>
<xsl:choose>
<xsl:when test="$hasScannedPart=1">	
<xsl:apply-templates mode="bppc-sd" select="Documents/Document"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates mode="bppc" select="//Policies"/>
</xsl:otherwise>
</xsl:choose>

</component>
</ClinicalDocument>
</xsl:template>

<xsl:template mode="bppc" match="Policies">
<structuredBody>
<component>
<section>
<code code="57016-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Privacy Policy Acknowledgement Document" />
<title>Patient Privacy Policy</title>
<text>
<table>
<thead>
<tr>
<td>Policy</td>
<td>Effective</td>
<td>Expires</td>
<td>Description</td>
</tr>
</thead>
<tbody>
<xsl:for-each select="PatientPolicy">
<tr ID="bppc-policy-text">
<td><xsl:value-of select="Name/text()"/></td>
<td><xsl:value-of select="translate(StartTime/text(),'TZ',' ')"/></td>
<td><xsl:value-of select="translate(EndTime/text(),'TZ',' ')"/></td>
<td><xsl:value-of select="Description/text()"/></td>
</tr>
</xsl:for-each>
</tbody>
</table>
</text>
</section>
</component>
</structuredBody>
</xsl:template>
	
<xsl:template mode="bppc-sd" match="Document">

<nonXMLBody>
<xsl:variable name="mediaType"><xsl:apply-templates mode="documentMimeType" select="."/></xsl:variable>
<text representation="B64" mediaType="{$mediaType}">
<xsl:choose>
<xsl:when test="NoteText">
<xsl:value-of select="isc:evaluate('encode',NoteText/text())"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="Stream/text()"/>
</xsl:otherwise>
</xsl:choose>
</text>
</nonXMLBody>
</xsl:template>

<xsl:template mode="documentMimeType" match="Document">
<xsl:variable name="type" select="FileType/text()"/>
<xsl:choose>
<xsl:when test="$type='PDF'">application/pdf</xsl:when>
<xsl:when test="$type='RTF'">application/rtf</xsl:when>
<xsl:when test="$type='TIFF'">image/tiff</xsl:when>
<xsl:when test="$type='JPG' or $type='JEPG'">image/jpeg</xsl:when>
<xsl:when test="$type='GIF'">image/gif</xsl:when>
<xsl:when test="$type='PNG'">image/png</xsl:when>
<xsl:when test="$type='XML'">text/xml</xsl:when>
<xsl:when test="$type='HTM' or $type='HTML'">text/html</xsl:when>
<xsl:otherwise>text/plain</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
