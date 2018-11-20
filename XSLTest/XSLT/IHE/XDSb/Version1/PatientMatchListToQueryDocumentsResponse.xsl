<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" version="1.0" xmlns="urn:ihe:iti:xds-b:2007" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- status: 'Success' or 'Failed' -->
<xsl:param name="status"/>
<xsl:param name="homeCommunityID"/>

<xsl:template match="/PatientSearchResponse">
<query:AdhocQueryResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<xsl:attribute name="status">
<xsl:value-of select="concat('urn:oasis:names:tc:ebxml-regrep:StatusType:', $status)"/>
</xsl:attribute>

<xsl:if test="($status = 'Success') and (./ResultsCount/text() &gt; 0)">
<rim:RegistryObjectList>
<!-- Build extrinsic object collection -->
<xsl:for-each select="./Results/PatientSearchMatch">
<rim:ExtrinsicObject xmlns:q="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" id="urn:uuid:08a15a6f-5b4a-42de-8f95-89474f83abdf" isOpaque="false" mimeType="text/xml" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
<xsl:attribute name="home">
urn:oid:<xsl:value-of select="$homeCommunityID"/>
</xsl:attribute>
<xsl:attribute name="status">
<xsl:value-of select="concat('urn:oasis:names:tc:ebxml-regrep:StatusType:', $status)"/>
</xsl:attribute>

<rim:Slot name="URI">
<rim:ValueList>
<rim:Value><xsl:value-of select="isc:evaluate('GWtoOID',./Gateway/text())"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="repositoryUniqueId">
<rim:ValueList>
<rim:Value><xsl:value-of select="isc:evaluate('GWtoOID',./Gateway/text())"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="authorInstitution">
<rim:ValueList>
<rim:Value><xsl:value-of select="./Facility/text()"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="creationTime">
<rim:ValueList>
<rim:Value><xsl:value-of select="isc:evaluate('timestamp')"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="hash">
<rim:ValueList>
<rim:Value>-1</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="languageCode">
<rim:ValueList>
<rim:Value>en-us</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="serviceStartTime">
<rim:ValueList>
<rim:Value>N/A</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="serviceStopTime">
<rim:ValueList>
<rim:Value>N/A</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="size">
<rim:ValueList>
<rim:Value>N/A</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="sourcePatientId">
<rim:ValueList>
<rim:Value><xsl:value-of select="concat(./MRN/text(), '^^^&amp;', ./AssigningAuthority/text(), '^^&amp;', ./Facility/text())"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="sourcePatientInfo">
<rim:ValueList>
<rim:Value>PID-3|<xsl:value-of select="concat(./MRN/text(), '^^^&amp;', ./AssigningAuthority/text(), '^^&amp;', ./Facility/text())"/></rim:Value>
<rim:Value>PID-5|<xsl:value-of select="concat(./LastName/text(), '^', ./FirstName/text(), '^', ./MiddleName/text())"/></rim:Value>
<rim:Value>PID-7|<xsl:value-of select="translate(./DOB/text(), 'TZ- ', '')"/></rim:Value>
<rim:Value>PID-8|<xsl:value-of select="./Sex/text()"/></rim:Value>
<rim:Value>PID-11|<xsl:value-of select="concat(./Street/text(), '^^', ./City/text(), '^', ./State/text(), '^', ./Zip/text(), '^', ./Country/text())"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Name>
<rim:LocalizedString charset="UTF-8" value="Patient Summary Document" xml:lang="en-us"/>
</rim:Name>
<rim:Description/>

<!-- To Do:  One classification per document type returned
<rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="urn:uuid:08a15a6f-5b4a-42de-8f95-89474f83abdf" id="urn:uuid:ac872fc0-1c6e-439f-84d1-f76770a0ccdf" nodeRepresentation="Education" objectType="Urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
<rim:Slot name="codingScheme">
<rim:ValueList>
<rim:Value>Connect-a-thon classCodes</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Name>
<rim:LocalizedString charset="UTF-8" value="Education" xml:lang="en-us"/>
</rim:Name>
<rim:Description/>
</rim:Classification>
-->

<rim:ExternalIdentifier id="urn:uuid:db9f4438-ffff-435f-9d34-d76190728637" registryObject="urn:uuid:08a15a6f-5b4a-42de-8f95-89474f83abdf" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="ExternalIdentifier">
<xsl:attribute name="value">
<!--<xsl:value-of select="concat(./MRN/text(), '^^^&amp;', ./AssigningAuthority/text(), '^^&amp;', ./Facility/text())"/>-->
<xsl:value-of select="./AssigningAuthority/text()"/>.<xsl:value-of select="./Facility/text()"/>.<xsl:value-of select="./MRN/text()"/>
</xsl:attribute>

<rim:Name>
<rim:LocalizedString charset="UTF-8" value="XDSDocumentEntry.patientId" xml:lang="en-us"/>
</rim:Name>
<rim:Description/>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier id="urn:uuid:c3fcbf0e-9765-4f5b-abaa-b37ac8ff05a5" registryObject="urn:uuid:08a15a6f-5b4a-42de-8f95-89474f83abdf" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="ExternalIdentifier">
<xsl:attribute name="value">
<xsl:value-of select="./AssigningAuthority/text()"/>.<xsl:value-of select="./Facility/text()"/>.<xsl:value-of select="./MRN/text()"/>
</xsl:attribute>

<rim:Name>
<rim:LocalizedString charset="UTF-8" value="XDSDocumentEntry.uniqueId" xml:lang="en-us"/>
</rim:Name>
<rim:Description/>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier id="urn:uuid:c3fcbf0e-9765-4f5b-abaa-b37ac8ff05a5" registryObject="urn:uuid:08a15a6f-5b4a-42de-8f95-89474f83abdf" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="ExternalIdentifier">
<xsl:attribute name="value">
<xsl:value-of select="isc:evaluate('GWtoOID',./Gateway/text())"/>
</xsl:attribute>

<rim:Name>
<rim:LocalizedString charset="UTF-8" value="XDSDocumentEntry.repositoryUniqueId" xml:lang="en-us"/>
</rim:Name>
<rim:Description/>
</rim:ExternalIdentifier>
</rim:ExtrinsicObject>
</xsl:for-each>

<!-- Build object reference collection -->
<!-- To Do:  One object reference per document type returned
<xsl:for-each select="./Results/PatientSearchMatch">
<rim:ObjectRef xmlns:q="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" id="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a"/>
</xsl:for-each>
-->
</rim:RegistryObjectList>
</xsl:if>
</query:AdhocQueryResponse>
</xsl:template>

</xsl:stylesheet>
