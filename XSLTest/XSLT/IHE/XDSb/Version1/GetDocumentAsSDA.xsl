<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com" 

xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:xdsb="urn:ihe:iti:xds-b:2007" 
xmlns:xop="http://www.w3.org/2004/08/xop/include" 

exclude-result-prefixes="isc lcm query rim rs xdsb xop">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:param name="listConsumedDocuments"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="/">
<xsl:choose>
<xsl:when test="//Container">
<xsl:copy>
<xsl:apply-templates select="//Container"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates mode="inconsumable" select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="Patient">
<Patient>
<xsl:apply-templates select="@*|node()"/>
<xsl:if test="not(MPIID)">
<MPIID><xsl:value-of select="/GetDocumentAsSDA/PatientFetchRequestAsync/MPIID/text()"/></MPIID>
</xsl:if>
</Patient>
<xsl:if test="not(string-length(../Encounters))">
<Encounters>
<xsl:apply-templates select="//rim:ExtrinsicObject" mode="Encounters"/>
</Encounters>
</xsl:if>
<xsl:if test="not(string-length(../Documents))">
<Documents>
<xsl:apply-templates select="//rim:ExtrinsicObject" mode="Documents"/>
</Documents>
</xsl:if>
</xsl:template>

<xsl:template match="Encounters">
<Encounters>
<xsl:apply-templates select="Encounter"/>
<xsl:if test="$listConsumedDocuments = 1">
<xsl:apply-templates select="//rim:ExtrinsicObject" mode="Encounters"/>
</xsl:if>
</Encounters>
</xsl:template>

<xsl:template match="Documents">
<Documents>
<xsl:if test="$listConsumedDocuments = 1">
<xsl:apply-templates select="//rim:ExtrinsicObject" mode="Documents"/>
</xsl:if>
</Documents>
</xsl:template>

<xsl:template mode="inconsumable" match="GetDocumentAsSDA">
<Container>
<Action>QueryResponse</Action>
<EventDescription>XDSb Document List</EventDescription>
<SendingFacility><xsl:value-of select="PatientFetchRequestAsync/Facility/text()"/></SendingFacility>
<Patient>
<MPIID><xsl:value-of select="PatientFetchRequestAsync/MPIID/text()"/></MPIID>
<PatientNumbers>
<PatientNumber>
<Number><xsl:value-of select="PatientFetchRequestAsync/MRN/text()"/></Number>
<Organization>
<Code>
<xsl:value-of select="PatientFetchRequestAsync/AssigningAuthority/text()"/>
</Code>
<Description>
<xsl:variable name="aaOID" select="isc:evaluate('getOIDForCode',PatientFetchRequestAsync/AssigningAuthority/text(),'AssigningAuthority')"/>
<xsl:value-of select="isc:evaluate('getDescriptionForOID', $aaOID, 'AssigningAuthority')"/>
</Description>
</Organization>
<NumberType>MRN</NumberType>
</PatientNumber>
</PatientNumbers>

<!-- Use first document to fill in basic demographics -->
<xsl:for-each select="Document/rim:ExtrinsicObject[1]/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value">
<xsl:variable name="itm" select="isc:evaluate('piece',text(),'|',1)"/>
<xsl:variable name="val" select="isc:evaluate('piece',text(),'|',2)"/>
<xsl:choose>
<xsl:when test="$itm = 'PID-5'">
<Name>
<xsl:variable name="lastname" select="isc:evaluate('piece',$val,'^',1)"/>
<xsl:variable name="family" select="isc:evaluate('piece',$lastname,'&amp;',1)"/>
<xsl:variable name="familyprefix" select="isc:evaluate('piece',$lastname,'&amp;',2)"/>
<xsl:variable name="given" select="isc:evaluate('piece',$val,'^',2)"/>
<xsl:variable name="middle" select="isc:evaluate('piece',$val,'^',3)"/>
<xsl:variable name="suffix" select="isc:evaluate('piece',$val,'^',4)"/>
<xsl:variable name="preferred" select="isc:evaluate('piece',$val,'^',5)"/>

<xsl:if test="$family"><FamilyName><xsl:value-of select="$family"/></FamilyName></xsl:if>
<xsl:if test="$familyprefix"><FamilyNamePrefix><xsl:value-of select="$familyprefix"/></FamilyNamePrefix></xsl:if>
<xsl:if test="$given"><GivenName><xsl:value-of select="$given"/></GivenName></xsl:if>
<xsl:if test="$middle"><MiddleName><xsl:value-of select="$middle"/></MiddleName></xsl:if>
<xsl:if test="$suffix"><ProfessionalSuffix><xsl:value-of select="$suffix"/></ProfessionalSuffix></xsl:if>
<xsl:if test="$preferred"><PreferredName><xsl:value-of select="$preferred"/></PreferredName></xsl:if>
</Name>
</xsl:when>
<xsl:when test="$itm = 'PID-7'">
<BirthTime><xsl:value-of select="isc:evaluate('xmltimestamp',$val)"/></BirthTime>
</xsl:when>
<xsl:when test="$itm = 'PID-8'">
<Gender><Code><xsl:value-of select="$val"/></Code></Gender>
</xsl:when>
<xsl:when test="$itm = 'PID-11'">
<Addresses>
<Address>
<xsl:variable name="street" select="isc:evaluate('piece',$val,'^',1,2)"/>
<xsl:variable name="city" select="isc:evaluate('piece',$val,'^',3)"/>
<xsl:variable name="state" select="isc:evaluate('piece',$val,'^',4)"/>
<xsl:variable name="zip" select="isc:evaluate('piece',$val,'^',5)"/>
<xsl:variable name="country" select="isc:evaluate('piece',$val,'^',6)"/>

<xsl:if test="$street"><Street><xsl:value-of select="translate($street,'^',';')"/></Street></xsl:if>
<xsl:if test="$city"><City><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',3)"/></Code></City></xsl:if>
<xsl:if test="$state"><State><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',4)"/></Code></State></xsl:if>
<xsl:if test="$zip"><Zip><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',5)"/></Code></Zip></xsl:if>
<xsl:if test="$country"><Country><Code><xsl:value-of select="isc:evaluate('piece',$val,'^',6)"/></Code></Country></xsl:if>
</Address>
</Addresses>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</Patient>

<Encounters>
<xsl:apply-templates select="Document/rim:ExtrinsicObject" mode="Encounters"/>
</Encounters>

<Documents>
<xsl:apply-templates select="Document/rim:ExtrinsicObject" mode="Documents"/>
</Documents>

</Container>
</xsl:template>

<xsl:template match="*" mode="Encounters">
</xsl:template>

<xsl:template match="*" mode="Documents">
<xsl:variable name="uniqueId" select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/>
<Document>
<!-- Use creationTime(converted to Local time) for EnteredOn and TranscriptionTime -->
<xsl:variable name="creationTime" select="isc:evaluate('xmltimestampToLocal',rim:Slot[@name='creationTime']/rim:ValueList/rim:Value/text())"/>
<EnteredOn><xsl:value-of select="$creationTime"/></EnteredOn>
<TranscriptionTime><xsl:value-of select="$creationTime"/></TranscriptionTime>

<!-- Use authorPerson (first one) for EnteredBy and Clinician -->
<!-- From the ITI TF 3: 4.1.7  Document Definition Metadata, XCN data type  -->
<!-- NOTE: Either ID+AA or Name is requried XCN -->
<xsl:variable name="author" select="rim:Classification[@classificationScheme='urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d']/rim:Slot[@name='authorPerson']/rim:ValueList/rim:Value/text()"/>
<xsl:if test="$author">
<xsl:variable name="authorid" select="isc:evaluate('piece',$author,'^',1)"/>
<xsl:variable name="authorlast" select="isc:evaluate('piece',$author,'^',2)"/>
<xsl:variable name="authorfamily" select="isc:evaluate('piece',$authorlast,'&amp;',1)"/>
<xsl:variable name="authorfamilyprefix" select="isc:evaluate('piece',$authorlast,'&amp;',2)"/>
<xsl:variable name="authorfirst" select="isc:evaluate('piece',$author,'^',3)"/>
<xsl:variable name="authormiddle" select="isc:evaluate('piece',$author,'^',4)"/>
<xsl:variable name="authorsuffix" select="isc:evaluate('piece',$author,'^',5)"/>
<xsl:variable name="authorprefix" select="isc:evaluate('piece',$author,'^',6)"/>
<xsl:variable name="authordegree" select="isc:evaluate('piece',$author,'^',7)"/>
<xsl:variable name="authorauthority" select="isc:evaluate('piece',$author,'^',9)"/>

<EnteredBy>
<xsl:choose>
<xsl:when test="$authorid">
<Code><xsl:value-of select="$authorid"/></Code>
<xsl:if test="$authorauthority">
	<SDACodingStandard><xsl:value-of select="$authorauthority"/></SDACodingStandard>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<Code><xsl:value-of select="concat($authorprefix,$authorfirst,$authormiddle,$authorfamilyprefix,$authorfamily,$authorsuffix,$authordegree)"/></Code>
</xsl:otherwise>
</xsl:choose>
</EnteredBy>

<Clinician>
<xsl:choose>
<xsl:when test="$authorid">
<Code><xsl:value-of select="$authorid"/></Code>
<xsl:if test="$authorauthority">
	<SDACodingStandard><xsl:value-of select="$authorauthority"/></SDACodingStandard>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<Code><xsl:value-of select="concat($authorprefix,$authorfirst,$authormiddle,$authorfamilyprefix,$authorfamily,$authorsuffix,$authordegree)"/></Code>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$authorfamily">
<Name>
<FamilyName><xsl:value-of select="$authorfamily"/></FamilyName>
<xsl:if test="$authorfamilyprefix"><FamilyNamePrefix><xsl:value-of select="$authorfamilyprefix"/></FamilyNamePrefix></xsl:if>
<xsl:if test="$authorprefix"><NamePrefix><xsl:value-of select="$authorprefix"/></NamePrefix></xsl:if>
<xsl:if test="$authorsuffix"><NameSuffix><xsl:value-of select="$authorsuffix"/></NameSuffix></xsl:if>
<xsl:if test="$authorfirst"><GivenName><xsl:value-of select="$authorfirst"/></GivenName></xsl:if>
<xsl:if test="$authormiddle"><MiddleName><xsl:value-of select="$authormiddle"/></MiddleName></xsl:if>
<xsl:if test="$authordegree"><ProfessionalSuffix><xsl:value-of select="$authordegree"/></ProfessionalSuffix></xsl:if>
</Name>
</xsl:if>
</Clinician>
</xsl:if>

<EnteredAt> 
<Code> 
<xsl:value-of select="//Container/SendingFacility/text()"/> 
</Code> 
</EnteredAt>

<!-- Use mimeType for file type -->
<FileType><xsl:value-of select="@mimeType"/></FileType>

<!-- Use formatCode to fill in the type -->
<DocumentType>
<xsl:apply-templates mode="CodedEntry" select="rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']"/>
</DocumentType>

<!-- Use title or typeCode or classCode  or "Community Document" (fine to coarse granularity) -->
<DocumentName>
<xsl:choose>
<xsl:when test="rim:Name/rim:LocalizedString/@value"><xsl:value-of select="rim:Name/rim:LocalizedString/@value"/></xsl:when>
<xsl:when test="rim:Classification[@classificationScheme='urn:uuid:f0306f51-975f-434e-a61c-c59651d33983']/rim:Name/rim:LocalizedString/@value"><xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:f0306f51-975f-434e-a61c-c59651d33983']/rim:Name/rim:LocalizedString/@value"/></xsl:when>
<xsl:when test="rim:Classification[@classificationScheme='urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a']/rim:Name/rim:LocalizedString/@value"><xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a']/rim:Name/rim:LocalizedString/@value"/></xsl:when>
<xsl:otherwise>Community Document</xsl:otherwise>
</xsl:choose>
</DocumentName>

<!-- uniqueId for document number (UUID is in the URL) -->
<DocumentNumber><xsl:value-of select="isc:evaluate('encode',$uniqueId)"/></DocumentNumber>

<!-- Use a link to the on-demand loader/viewer page -->
<xsl:variable name="docUUID" select="substring(@id,10)"/>
<xsl:variable name="docHOME" select="substring(@home,9)"/>
<DocumentURL><xsl:value-of select="isc:evaluate('makeURL','HS.UI.IHE.DocumentViewer.cls','FAC',../../PatientFetchRequestAsync/Facility/text(),'AA',../../PatientFetchRequestAsync/AssigningAuthority/text(),'MRN',../../PatientFetchRequestAsync/MRN/text(),'UUID',$docUUID,'HOME',$docHOME)"/></DocumentURL>

<!-- Status of active is required -->
<Status>
<Code>AV</Code>
<Description>Active</Description>
</Status>
</Document>
</xsl:template>

<xsl:template mode="CodedEntry" match="*">
<Code><xsl:value-of select="@nodeRepresentation"/></Code>
<Description><xsl:value-of select="rim:Name/rim:LocalizedString/@value"/></Description>
<SDACodingStandard><xsl:value-of select="rim:Slot/rim:ValueList/rim:Value/text()"/></SDACodingStandard>
</xsl:template>

</xsl:stylesheet>