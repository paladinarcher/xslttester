<?xml version="1.0" encoding="UTF-8"?>
<!-- Converts an IHE XMLMessage into a list of key/value pairs for the HS.Test.IHE.MessageTrace utility -->
<xsl:stylesheet version="1.0" 
xmlns:hl7    ="urn:hl7-org:v3"
xmlns:isc    ="http://extension-functions.intersystems.com" 
xmlns:lcm    ="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0"
xmlns:query  ="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:rim    ="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs     ="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
xmlns:xdsb   ="urn:ihe:iti:xds-b:2007"
xmlns:xop    ="http://www.w3.org/2004/08/xop/include"
xmlns:xsl    ="http://www.w3.org/1999/XSL/Transform" 
exclude-result-prefixes="hl7 isc lcm query rim rs xdsb xop xsl">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- PDQ Query -->
<xsl:template match="/hl7:PRPA_IN201305UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Receiver"><xsl:value-of select="hl7:receiver/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="Sender"><xsl:value-of select="hl7:sender/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="SubjectId">
<xsl:call-template name="formatID">
<xsl:with-param name="id" select="hl7:controlActProcess/hl7:queryByParameter/hl7:parameterList/hl7:livingSubjectId/hl7:value"/>
</xsl:call-template>
</TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/hl7:PRPA_IN201306UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="QueryResponse"><xsl:value-of select="hl7:controlActProcess/hl7:queryAck/hl7:queryResponseCode/@code"/></TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- PIX Query -->
<xsl:template match="/hl7:PRPA_IN201309UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Receiver"><xsl:value-of select="hl7:receiver/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="Sender"><xsl:value-of select="hl7:sender/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="DataSource">
<xsl:value-of select="hl7:controlActProcess/hl7:queryByParameter/hl7:parameterList/hl7:dataSource/hl7:value/@code"/>
</TraceItem>
<TraceItem TraceKey="PatientId">
<xsl:call-template name="formatID">
<xsl:with-param name="id" select="hl7:controlActProcess/hl7:queryByParameter/hl7:parameterList/hl7:patientIdentifier/hl7:value"/>
</xsl:call-template>
</TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/hl7:PRPA_IN201310UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Acknowledgement"><xsl:value-of select="hl7:acknowledgement/hl7:typeCode/@code"/></TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- PIX Add -->
<xsl:template match="/hl7:PRPA_IN201301UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Receiver"><xsl:value-of select="hl7:receiver/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="Sender"><xsl:value-of select="hl7:sender/hl7:device/hl7:id/@root"/></TraceItem>

<xsl:variable name="patient" select="./hl7:controlActProcess/hl7:subject/hl7:registrationEvent/hl7:subject1/hl7:patient"/>
<TraceItem TraceKey="PatientId">
<xsl:call-template name="formatID"><xsl:with-param name="id" select="$patient/hl7:id"/></xsl:call-template>
</TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/hl7:MCCI_IN000002UV01">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Acknowledgement"><xsl:value-of select="hl7:acknowledgement/hl7:typeCode/@code"/></TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- PIX Merge -->
<xsl:template match="/hl7:PRPA_IN201304UV02">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Receiver"><xsl:value-of select="hl7:receiver/hl7:device/hl7:id/@root"/></TraceItem>
<TraceItem TraceKey="Sender"><xsl:value-of select="hl7:sender/hl7:device/hl7:id/@root"/></TraceItem>

<xsl:variable name="patient" select="./hl7:controlActProcess/hl7:subject/hl7:registrationEvent/hl7:subject1/hl7:patient"/>
<TraceItem TraceKey="PatientId">
<xsl:call-template name="formatID"><xsl:with-param name="id" select="$patient/hl7:id"/></xsl:call-template>
</TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- XDSb Retrieve -->
<xsl:template match="/xdsb:RetrieveDocumentSetRequest">
<MessageTrace>
<Trace>
<xsl:for-each select="xdsb:DocumentRequest">
<TraceItem TraceKey="Home"><xsl:value-of select="xdsb:HomeCommunityId/text()"/></TraceItem>
<TraceItem TraceKey="Repo"><xsl:value-of select="xdsb:RepositoryUniqueId/text()"/></TraceItem>
<TraceItem TraceKey="OID"><xsl:value-of select="xdsb:DocumentUniqueId/text()"/></TraceItem>
</xsl:for-each>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/xdsb:RetrieveDocumentSetResponse">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Status"><xsl:value-of select="rs:RegistryResponse/@status"/></TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- XDSb Provide (response same as register) -->
<xsl:template match="/xdsb:ProvideAndRegisterDocumentSetRequest">
<MessageTrace>
<Trace>
<xsl:apply-templates select="lcm:SubmitObjectsRequest/rim:RegistryObjectList"/>
</Trace>
</MessageTrace>
</xsl:template>

<!-- XDSb Register -->
<xsl:template match="/lcm:SubmitObjectsRequest">
<MessageTrace>
<Trace>
<xsl:apply-templates select="rim:RegistryObjectList"/>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/rs:RegistryResponse">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Status"><xsl:value-of select="@status"/></TraceItem>
</Trace>
</MessageTrace>
</xsl:template>

<!-- XDSb Query -->
<xsl:template match="/query:AdhocQueryRequest">
<MessageTrace>
<Trace>
<TraceItem TraceKey="ReturnType"><xsl:value-of select="query:ResponseOption/@returnType"/></TraceItem>
<xsl:for-each select="rim:AdhocQuery">
<TraceItem TraceKey="Home"><xsl:value-of select="@home"/></TraceItem>
<TraceItem TraceKey="Query">
<xsl:choose>
<xsl:when test="@id='urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d'">FindDocuments</xsl:when> 
<xsl:when test="@id='urn:uuid:f26abbcb-ac74-4422-8a30-edb644bbc1a9'">FindSubmissionSets</xsl:when> 
<xsl:when test="@id='urn:uuid:958f3006-baad-4929-a4de-ff1114824431'">FindFolders</xsl:when> 
<xsl:when test="@id='urn:uuid:10b545ea-725c-446d-9b95-8aeb444eddf3'">GetAll</xsl:when> 
<xsl:when test="@id='urn:uuid:5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4'">GetDocuments</xsl:when> 
<xsl:when test="@id='urn:uuid:5737b14c-8a1a-4539-b659-e03a34a5e1e4'">GetFolders</xsl:when> 
<xsl:when test="@id='urn:uuid:a7ae438b-4bc2-4642-93e9-be891f7bb155'">GetAssociations</xsl:when> 
<xsl:when test="@id='urn:uuid:bab9529a-4a10-40b3-a01f-f68a615d247a'">GetDocumentsAndAssociations</xsl:when> 
<xsl:when test="@id='urn:uuid:51224314-5390-4169-9b91-b1980040715a'">GetSubmissionSets</xsl:when> 
<xsl:when test="@id='urn:uuid:e8e3cb2c-e39c-46b9-99e4-c12f57260b83'">GetSubmissionSetAndContents</xsl:when> 
<xsl:when test="@id='urn:uuid:b909a503-523d-4517-8acf-8e5834dfc4c7'">GetFolderAndContents</xsl:when> 
<xsl:when test="@id='urn:uuid:10cae35a-c7f9-4cf5-b61e-fc3278ffb578'">GetFoldersForDocument</xsl:when> 
<xsl:when test="@id='urn:uuid:d90e5407-b356-4d91-a89f-873917b4b0e6'">GetRelatedDocuments</xsl:when> 
<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
</xsl:choose>
</TraceItem>

<!--
Many query parameters support multiples, and AND/OR semantics          
See ITI-TF 2a: 3.18.4.1.2.3.5 Coding of Single/Multiple Values         
Using isc:evaluate('varInc') since using position() returns the raw    
position, not the one relative to the @name attribute.                 
Example: EventCodeList2.3 the second EventCode param, third rim:Value  
Since sending one value is common, 1.1 will always be stripped         
-->
<xsl:for-each select="rim:Slot">
<xsl:variable name="slotPos" select="isc:evaluate('varInc',@name)"/>
<xsl:variable name="name">
<xsl:choose>
<xsl:when test="starts-with(@name, '$XDSDocumentEntry')"><xsl:value-of select="substring-after(@name, '$XDSDocumentEntry')"/></xsl:when>
<xsl:when test="starts-with(@name, '$XDSSubmissionSet')"><xsl:value-of select="substring-after(@name, '$XDSDocumentEntry')"/></xsl:when>
<xsl:when test="starts-with(@name, '$XDSFolder')"><xsl:value-of select="substring-after(@name, '$XDSDocumentEntry')"/></xsl:when>
<xsl:when test="starts-with(@name, '$')"><xsl:value-of select="substring-after(@name, '$')"/></xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:for-each select="rim:ValueList/rim:Value">
<xsl:variable name="valuePos" select="position()"/>
<xsl:variable name="key" select="concat($name, $slotPos, '.', $valuePos)"/>
<TraceItem TraceKey="{isc:evaluate('piece',$key,'1.1',1)}"><xsl:value-of select="text()"/></TraceItem>
</xsl:for-each>
</xsl:for-each>
</xsl:for-each>
</Trace>
</MessageTrace>
</xsl:template>

<xsl:template match="/query:AdhocQueryResponse">
<MessageTrace>
<Trace>
<TraceItem TraceKey="Status"><xsl:value-of select="@status"/></TraceItem>
<xsl:apply-templates select="rim:RegistryObjectList"/>
</Trace>
</MessageTrace>
</xsl:template>

<!--
			COMMON TEMPLATES
-->
<xsl:template match="rim:RegistryObjectList">
<xsl:apply-templates select="rim:ExtrinsicObject"/>
<xsl:apply-templates select="rim:RegistryPackage"/>
</xsl:template>

<xsl:template match="rim:RegistryPackage">
<TraceItem TraceKey="{concat('SS',position(),'.MPI')}"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446']/@value"/></TraceItem>
<TraceItem TraceKey="{concat('SS',position(),'.OID')}"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8']/@value"/></TraceItem>
<TraceItem TraceKey="{concat('SS',position(),'.Source')}"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832']/@value"/></TraceItem>
</xsl:template>

<xsl:template match="rim:ExtrinsicObject">
<TraceItem TraceKey="{concat('Doc',position(),'.UUID')}"><xsl:value-of select="@id"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.MIME')}"><xsl:value-of select="@mimeType"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.Home')}"><xsl:value-of select="@home"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.MRN')}"><xsl:value-of select="rim:Slot[@name='sourcePatientId']/rim:ValueList/rim:Value/text()"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.Format')}"><xsl:apply-templates select="rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.MPI')}"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427']/@value"/></TraceItem>
<TraceItem TraceKey="{concat('Doc',position(),'.OID')}"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/></TraceItem>
</xsl:template>

<xsl:template match="rim:Classification">
<xsl:variable name="code" select="@nodeRepresentation"/>
<xsl:variable name="name" select="rim:Name/rim:LocalizedString/@value"/>
<xsl:variable name="type" select="rim:Slot/rim:ValueList/rim:Value/text()"/>
<xsl:value-of select="concat($name,'^',$code,'^',$type)"/>
</xsl:template>

<!-- 
			FUNCTIONS
-->
<!-- format id's not in ISO format -->
<xsl:template name="formatID">
<xsl:param name="id"/>
<xsl:value-of select="concat($id/@extension,'^^^&amp;', $id/@root, '&amp;ISO')"/>
</xsl:template>
</xsl:stylesheet>
