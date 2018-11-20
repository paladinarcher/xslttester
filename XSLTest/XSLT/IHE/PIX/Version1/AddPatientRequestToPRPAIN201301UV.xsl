<?xml version="1.0" encoding="UTF-8"?>
<!-- Used by the HS.MPI.IHE.Operations -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" version="1.0" exclude-result-prefixes="isc" >
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:param name="receiverDeviceOID"/>
<xsl:param name="senderDeviceOID"/>
<xsl:param name="messageID" select="''"/>
<xsl:param name="creationTime" select="''"/>

<xsl:template match="//AddPatientRequest">	
<xsl:variable name="patientFirstName" select="./FirstName/text()"/>
<xsl:variable name="patientLastName" select="./LastName/text()"/>
<xsl:variable name="patientMiddleName" select="./MiddleName/text()"/>
<xsl:variable name="patientGender" select="./Sex/text()"/>
<xsl:variable name="patientBirthTime" select="translate(./DOB/text(), 'TZ:-', '')"/>
<xsl:variable name="patientPhoneNumber" select="./Telephone/text()"/>
<xsl:variable name="patientStreet" select="./Street/text()"/>
<xsl:variable name="patientCity" select="./City/text()"/>
<xsl:variable name="patientState" select="./State/text()"/>
<xsl:variable name="patientZip" select="./Zip/text()"/>
<xsl:variable name="patientSSN" select="./SSN/text()"/>
<xsl:variable name="patientMRN" select="./MRN/text()"/>
<xsl:variable name="facility" select="./Facility/text()"/>
<xsl:variable name="assigningAuthority" select="isc:evaluate('CodetoOID',./AssigningAuthority/text())"/>

<PRPA_IN201301UV02 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
<id root="{$messageID}"/>
<creationTime><xsl:value-of select="$creationTime"/></creationTime>
<interactionId root="2.16.840.1.113883.1.6" extension="PRPA_IN201301UV02"/>
<!-- processing code D (debugging) T (Testing) P (Production) -->
<processingCode code="P"/>
<processingModeCode code="T"/>
<acceptAckCode code="AL"/>
<receiver typeCode="RCV">
<device determinerCode="INSTANCE">
<id root="{$receiverDeviceOID}"/>
</device>
</receiver>
<sender typeCode="SND">
<device determinerCode="INSTANCE">
<id root="{$senderDeviceOID}"/>
</device>
</sender>
<controlActProcess moodCode="EVN">
<subject typeCode="SUBJ">
<registrationEvent>
<id nullFlavor="NA"/>
<statusCode code="active"/>
<subject1>
<patient classCode="PAT">
<id root="{$assigningAuthority}" extension="{$patientMRN}"/>
<statusCode code="active"/>
<patientPerson>
<name>
<prefix><xsl:value-of select='./Prefix/text()'/></prefix>
<given><xsl:value-of select='$patientFirstName'/></given>
<given><xsl:value-of select='$patientMiddleName'/></given>
<family><xsl:value-of select='$patientLastName'/></family>
<suffix><xsl:value-of select='./Suffix/text()'/></suffix>
</name>
<xsl:if test="$patientPhoneNumber!=''">
<telecom value="{concat('tel:', $patientPhoneNumber)}" use="H"/>
</xsl:if>
<administrativeGenderCode code="{$patientGender}"/>
<birthTime value="{$patientBirthTime}"/>
<addr>
<xsl:if test="$patientStreet!=''">
<streetAddressLine><xsl:value-of select="$patientStreet"/></streetAddressLine>
</xsl:if>
<xsl:if test="$patientCity!=''">
<city><xsl:value-of select="$patientCity"/></city>
</xsl:if>
<xsl:if test="$patientState!=''">
<state><xsl:value-of select="$patientState"/></state>
</xsl:if>
<xsl:if test="$patientZip!=''">
<Zip><xsl:value-of select="$patientZip"/></Zip>
</xsl:if>
</addr>
<xsl:if test="$patientSSN!=''">
<asOtherIDs classCode="CIT">
<id root="2.16.840.1.113883.4.1" extension="{$patientSSN}"/>
<scopingOrganization>
<id root="2.16.840.1.113883.4.1"/>
</scopingOrganization>
</asOtherIDs>
</xsl:if>
</patientPerson>
<providerOrganization>
<id root="{$facility}"/>
<!--<name><xsl:value-of select="$thisOrganizationName"/></name>
<contactParty>
<telecom value="tel:+1-342-555-8394"></telecom>
</contactParty>
-->
</providerOrganization>
</patient>
</subject1>
<!--
<custodian>
<assignedEntity>
<id root="{$thisOrganizationOID}"/>
<assignedOrganization>
<name><xsl:value-of select="$thisOrganizationName"/></name>
</assignedOrganization>   
</assignedEntity>
</custodian>
-->
</registrationEvent>
</subject>
</controlActProcess>
</PRPA_IN201301UV02>
</xsl:template>
</xsl:stylesheet>
