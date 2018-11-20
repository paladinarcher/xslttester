<?xml version="1.0" encoding="UTF-8"?>
<!-- Convert a push XDSbProcessRequest into a XDSb_DeliveryRequest XMLMessage -->
<xsl:stylesheet version="1.0" 
xmlns:exsl="http://exslt.org/common"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
exclude-result-prefixes="isc exsl">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:include href="Variables.xsl"/>

<xsl:param name="affinityDomainOID"/>
<xsl:param name="homeCommunityOID"/>

<xsl:variable name="isOnDemand" select="/XDSbProcessRequest/Subscription/DeliveryType/text()='XDSb.OnDemand'"/>
<xsl:variable name="isXACML" select="contains(/XDSbProcessRequest/Subscription/DeliveryOperation/text(),'XACML')"/>
<xsl:variable name="contentScope" select="/XDSbProcessRequest/Subscription/ContentScope/text()"/>
<xsl:variable name="transformType" select="/XDSbProcessRequest/Subscription/TransformationType/text()"/>
<xsl:variable name="transformOption">
<xsl:choose>
<xsl:when test="$transformType='XSLT'">
<xsl:value-of select="/XDSbProcessRequest/Subscription/XSLTFileSpec/text()"/>
</xsl:when>
<xsl:when test="$transformType='CUSTOM'">
<xsl:value-of select="/XDSbProcessRequest/Subscription/TransformCustomOperation/text()"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/XDSbProcessRequest/Subscription/PatientReportId/text()"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:template match="/XDSbProcessRequest">
<XMLMessage>
<Name>
<xsl:value-of select="$xdsbPushDeliveryRequest"/>
</Name>

<ContentStream>
<Metadata>
<Submission id="SS">
<xsl:apply-templates mode="author" select="."/>
<xsl:apply-templates mode="comments" select="."/>
<xsl:apply-templates mode="contentTypeCode" select="."/>
<xsl:apply-templates mode="intendedRecipient" select="."/>
<xsl:apply-templates mode="patientId" select="."/>
<xsl:apply-templates mode="sourceId" select="."/>
<xsl:apply-templates mode="submissionTime" select="."/>
<xsl:apply-templates mode="title" select="."/>
<xsl:apply-templates mode="uniqueId" select="."/>
</Submission>

<xsl:for-each select="Document">
<Association type="{$hasMember}" parent="SS" child="{DocumentId/text()}"/>
<Document id="{DocumentId/text()}">
<xsl:attribute name="type">
<xsl:choose>
<xsl:when test="$isOnDemand">OnDemand</xsl:when>
<xsl:otherwise>Stable</xsl:otherwise>
</xsl:choose>
</xsl:attribute>

<xsl:apply-templates mode="author" select="."/>
<xsl:apply-templates mode="classCode" select="."/>
<xsl:apply-templates mode="comments" select="."/>
<xsl:apply-templates mode="confidentialityCode" select="."/>
<xsl:apply-templates mode="context" select="."/>
<xsl:apply-templates mode="creationTime" select="."/>
<xsl:apply-templates mode="eventCodeList" select="."/>
<xsl:apply-templates mode="formatCode" select="."/>
<xsl:apply-templates mode="healthcareFacilityTypeCode" select="."/>
<xsl:apply-templates mode="languageCode" select="."/>
<xsl:apply-templates mode="legalAuthenticator" select="."/>
<xsl:apply-templates mode="mimeType" select="."/>
<xsl:apply-templates mode="patientId" select="."/>
<xsl:apply-templates mode="practiceSettingCode" select="."/>
<xsl:apply-templates mode="sourcePatientId" select="."/>
<xsl:apply-templates mode="sourcePatientInfo" select="."/>
<xsl:apply-templates mode="title" select="."/>
<xsl:apply-templates mode="typeCode" select="."/>
<xsl:apply-templates mode="uniqueId" select="."/>
</Document>
</xsl:for-each>

</Metadata>
</ContentStream>

<AdditionalInfo>
<xsl:apply-templates mode="additionalInfoItem" select="Subscription/EndPoint"/>
<xsl:apply-templates mode="additionalInfoItem" select="Subscription/AccessGWEndPoint"/>
<xsl:apply-templates mode="additionalInfoItem" select="Subscription/DeliveryOperation"/>
<xsl:apply-templates mode="additionalInfoItem" select="Subscription/DeliveryType"/>
<AdditionalInfoItem AdditionalInfoKey="USER:Roles">
<xsl:value-of select="Subscription/RecipientRoles/text()"/>
</AdditionalInfoItem>
<xsl:choose>
<xsl:when test="Document/SDA">
<xsl:variable name="patientRoot" select="Document/SDA/Container/Patient"/>
<AdditionalInfoItem AdditionalInfoKey="PatientMRN"><xsl:value-of select="$patientRoot/PatientNumbers/PatientNumber[NumberType='MRN']/Number/text()"/></AdditionalInfoItem>
<AdditionalInfoItem AdditionalInfoKey="PatientAA"><xsl:value-of select="$patientRoot/PatientNumbers/PatientNumber[NumberType='MRN']/Organization/Code/text()"/></AdditionalInfoItem>
</xsl:when>
<xsl:when test="Document/AddUpdateHubRequest">
<AdditionalInfoItem AdditionalInfoKey="PatientMRN"><xsl:value-of select="Document/AddUpdateHubRequest/MRN/text()"/></AdditionalInfoItem>
<AdditionalInfoItem AdditionalInfoKey="PatientAA"><xsl:value-of select="Document/AddHupdateHubRequest/AssigningAuthority/text()"/></AdditionalInfoItem>
</xsl:when>
</xsl:choose>
</AdditionalInfo>

<xsl:if test="not($isOnDemand)">
<StreamCollection>
<xsl:apply-templates mode="mimeAttachment" select="Document"/>
</StreamCollection>
</xsl:if>

</XMLMessage>
</xsl:template>	

<xsl:template mode="additionalInfoItem" match="*">
<AdditionalInfoItem AdditionalInfoKey="{local-name()}">
<xsl:value-of select="text()"/>
</AdditionalInfoItem>
</xsl:template>

<xsl:template mode="mimeAttachment" match="Document">
 <MIMEAttachment>
<ContentId><xsl:value-of select="DocumentId/text()"/></ContentId> 
<ContentType><xsl:apply-templates mode="mimeTypeValue" select="."/></ContentType> 
<ContentTransferEncoding>binary</ContentTransferEncoding> 
</MIMEAttachment>
</xsl:template>

<!--

			XDSb Metadata Elements (alphabetical order)

-->

<!-- author of SubmissionSet -->
<xsl:template mode="author" match="XDSbProcessRequest">
<xsl:call-template name="communityAuthor"/>
</xsl:template>

<!-- author of Document -->
<xsl:template mode="author" match="Document">
<xsl:choose>
<xsl:when test="$isOnDemand">
<xsl:call-template name="communityAuthor"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates mode="personAuthor" select="SDA//Encounter/AttendingClinicians/CareProvider"/>
<xsl:apply-templates mode="personAuthor" select="SDA//Encounter/AdmittingClinician"/>
<xsl:apply-templates mode="personAuthor" select="SDA//Encounter/EnteredBy"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- classCode of Document-->
<xsl:template mode="classCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','classCode',$contentScope,$transformType,$transformOption)"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'ClassCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">57017-6^Privacy Policy^LOINC</xsl:when>
<xsl:when test="$contentScope = 'Enc'">Summarization of episode^Summarization of episode^Connect-a-thon classCodes</xsl:when>
<xsl:when test="$contentScope = 'MRN'">History and Physical^History and Physical^Connect-a-thon classCodes</xsl:when>
<xsl:when test="$contentScope = 'MPI'">Comprehensive history and physical^Comprehensive history and physical^Connect-a-thon classCodes</xsl:when>
<xsl:otherwise>Targeted history and physical^Targeted history and physical^Connect-a-thon classCodes</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- comments for SubmissionSet-->
<xsl:template mode="comments" match="XDSbProcessRequest">
<!-- By default, no comments for submission -->
</xsl:template>

<!-- comments for Document -->
<xsl:template mode="comments" match="Document">
<Comments>
<xsl:if test="not($isXACML)">
<xsl:choose>
<xsl:when test="SDA"><xsl:value-of select="SDA/Container/EventDescription/text()"/></xsl:when>
<xsl:when test="AddUpdateHubRequest"><xsl:value-of select="AddUpdateHubRequest/EventType/text()"/></xsl:when>
</xsl:choose>
</xsl:if>
</Comments>
</xsl:template>

<!-- confidentialityCode for Document -->
<xsl:template mode="confidentialityCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','confidentialityCode',$contentScope,$transformType,$transformOption)"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'ConfidentialityCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:otherwise>N^Normal^2.16.840.1.113883.5.25</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- contentTypeCode for SubmissionSet  -->
<xsl:template mode="contentTypeCode" match="XDSbProcessRequest">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','contentTypeCode',$contentScope,$transformType,$transformOption)"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'ContentTypeCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">57017-6^Privacy Policy^LOINC</xsl:when>
<xsl:when test="$contentScope = 'Enc'">Summarization of episode^Summarization of episode^Connect-a-thon contentTypeCodes</xsl:when>
<xsl:when test="$contentScope = 'MRN'">History and Physical^History and Physical^Connect-a-thon contentTypeCodes</xsl:when>
<xsl:when test="$contentScope = 'MPI'">Comprehensive history and physical^Comprehensive history and physical^Connect-a-thon contentTypeCodes</xsl:when>
<xsl:otherwise>Targeted history and physical^Targeted history and physical^Connect-a-thon contentTypeCodes</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- context for Document -->
<xsl:template mode="context" match="Document">
<!-- Create context for this document use for on-demand creation and stable replacement -->
<!-- Message scope does not have a context, and thus will never issue a replace -->
<xsl:if test="$contentScope != 'Msg'">
<Context>
<xsl:copy-of select="../MPIID"/>
<xsl:if test="$contentScope != 'MPI'">
<xsl:copy-of select="../MRN"/>
<xsl:copy-of  select="../AssigningAuthority"/>
<xsl:copy-of  select="../Facility"/>
</xsl:if>
<xsl:if test="$contentScope = 'Enc'">
<xsl:choose>
<xsl:when test="SDA//Encounter/EncounterNumber/text()">
<VisitNumber><xsl:value-of select="SDA//Encounter/EncounterNumber/text()"/></VisitNumber>
</xsl:when>
<xsl:otherwise>
<VisitNumber><xsl:value-of select="SDA//Encounter/ExternalId/text()"/></VisitNumber>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<TransformType><xsl:value-of select="$transformType"/></TransformType>
<TransformOption><xsl:value-of select="$transformOption"/></TransformOption>
<ServiceId><xsl:value-of select="../Subscription/EndPoint/text()"/></ServiceId>
<TransProfile><xsl:value-of select="../Subscription/TransProfile/text()"/></TransProfile>
</Context>
</xsl:if>
</xsl:template>

<!-- creationTime of Document -->
<xsl:template mode="creationTime" match="Document">
<xsl:if test="not($isOnDemand)">
<xsl:variable name="enteredOn" select="SDA//Encounter/EnteredOn/text()"/>
<CreationTime>
<xsl:choose>
<xsl:when test="$enteredOn">
<xsl:value-of select="translate($enteredOn,'-:TZ ','')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="isc:evaluate('createHL7Timestamp')"/>
</xsl:otherwise>
</xsl:choose>
</CreationTime>
</xsl:if>
</xsl:template>

<!-- eventCodeList for Document -->
<xsl:template mode="eventCodeList" match="Document">
<!-- The NIST codes only specify to radiology procedures -->
<!-- Default no event codes since context is so broad    -->
<!-- RHIO's may override by customizing this XSL -->
</xsl:template>

<!-- formatCode for Document -->
<xsl:template mode="formatCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<!-- TODO: Figure out the right default codes for XSLT xforms -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','formatCode',$contentScope,$transformType,$transformOption)"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'FormatCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">urn:nhin:names:acp:XACML^XACML Policy^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformType='PDF'">PDF^PDF^Connect-a-thon formatCodes</xsl:when>
<xsl:when test="$transformType='XSLT'">
<xsl:choose>
<xsl:when test="$transformOption='C32v25'">urn:ihe:pcc:xphr:2007^Exchange of Personal Health Records^IHE PCC</xsl:when>
<xsl:when test="$transformOption='C37v23'">urn:ihe:lab:xd-lab:2008^CDA Laboratory Report^IHE PCC</xsl:when>
<xsl:when test="$transformOption='C48.1v25'">urn:ihe:pcc:xds-ms:2007^Medical Summaries^IHE PCC</xsl:when>
<xsl:when test="$transformOption='C48.2v25'">urn:ihe:pcc:xds-ms:2007^Medical Summaries^IHE PCC</xsl:when>
<xsl:when test="$transformOption='CCR'">CCR V1.0^CCR V1.0^Connect-a-thon formatCodes</xsl:when>
<xsl:when test="$transformOption='CCDA-CCD'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-ClinicalSummary'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-ExportAmbulatory'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-ExportInpatient'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-ExportSummary'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-TocRefAmbulatory'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-TocRefInpatient'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-TocRefSummary'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-VDTAmbulatory'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-VDTInpatient'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-CON'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-DIR'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-DSC'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-HNP'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-SRG'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-PRC'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-PRG'">urn:hl7-org:sdwg:ccda-structuredBody:1.1^Consolidated CDA R1.1 Structured Body Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='CCDA-UNS'">urn:hl7-org:sdwg:ccda-nonXMLBody:1.1^Consolidated CDA R1.1 Unstructured Document^1.3.6.1.4.1.19376.1.2.3</xsl:when>
<xsl:when test="$transformOption='AU-DSCv34'">1.2.36.1.2001.1001.101.100.1002.4^Discharge Summary Document^NEHTA</xsl:when>
<xsl:when test="$transformOption='AU-EVTv12'">1.2.36.1.2001.1001.101.100.1002.136^Event Summary Document^NEHTA</xsl:when>
<xsl:when test="$transformOption='AU-REFv22'">1.2.36.1.2001.1001.101.100.1002.2^Referral Document^NEHTA</xsl:when>
<xsl:when test="$transformOption='AU-SHSv13'">1.2.36.1.2001.1001.101.100.1002.120^Shared Health Summary Document^NEHTA</xsl:when>
<xsl:otherwise>2.16.840.1.113883.10.20.1^HL7 CCD Document^2.16.840.1.113883.3.88</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>TEXT^TEXT^Connect-a-thon formatCodes</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- healthcareFacilityTypeCode for Document -->
<xsl:template mode="healthcareFacilityTypeCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<!-- TODO: enhance this to look at EncounterType node -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','healthcareFacilityTypeCode',../Facility/text())"/>

<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'HealthcareFacilityTypeCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">385432009^Not Applicable^SNOMED</xsl:when>
<xsl:otherwise>Outpatient^Outpatient^Connect-a-thon healthcareFacilityTypeCodes</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- intendedRecipient list for SubmissionSet-->
<xsl:template mode="intendedRecipient" match="XDSbProcessRequest">
<!-- By default, no intendedRecipient for submission -->
<!-- FUTURE: Send more info in the subscription recipient to be able to fill this in -->
</xsl:template>

<!-- languageCode for Document-->
<xsl:template mode="languageCode" match="Document">
<LanguageCode>en-us</LanguageCode>
</xsl:template>

<!-- legalAuthenticator for Document -->
<xsl:template mode="legalAuthenticator" match="Document">
<xsl:if test="not($isOnDemand)">
<!-- By default, no authenticator for stable documents -->
</xsl:if>
</xsl:template>

<!-- mimeType for Document -->
<xsl:template mode="mimeType" match="Document">
<MimeType>
<xsl:apply-templates mode="mimeTypeValue" select="."/>
</MimeType>
</xsl:template>
<xsl:template mode="mimeTypeValue" match="Document">
<xsl:choose>
<xsl:when test="$isXACML">text/xml</xsl:when>
<xsl:when test="$transformType='PDF'">application/pdf</xsl:when>
<xsl:when test="$transformType='HTML'">text/html</xsl:when>
<xsl:when test="$transformType='CUSTOM'">application/octet-stream</xsl:when>
<xsl:otherwise>text/xml</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- patientId for SubmissionSet -->
<xsl:template mode="patientId" match="XDSbProcessRequest">
<PatientId>
<xsl:value-of select="concat(MPIID/text(),'^^^&amp;',$affinityDomainOID,'&amp;ISO')"/>
</PatientId>
</xsl:template>

<!-- patientId for Document -->
<xsl:template mode="patientId" match="Document">
<PatientId>
<xsl:value-of select="concat(../MPIID/text(),'^^^&amp;',$affinityDomainOID,'&amp;ISO')"/>
</PatientId>
</xsl:template>

<!-- practiceSettingCode for Document -->
<xsl:template mode="practiceSettingCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<!-- TODO: Enhance this to look at encounter AssignedWard node -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','practiceSettingCode',../Facility/text())"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'PracticeSettingCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">385432009^Not Applicable^SNOMED</xsl:when>
<xsl:otherwise>General Medicine^General Medicine^Connect-a-thon practiceSettingCodes</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- sourceId for SubmissionSet -->
<xsl:template mode="sourceId" match="XDSbProcessRequest">
<!-- always use the community OID -->
<SourceId>
<xsl:value-of select="$homeCommunityOID"/>
</SourceId>
</xsl:template>

<!-- sourcePatientId for Document -->
<xsl:template mode="sourcePatientId" match="Document">
<SourcePatientId>
<xsl:choose>
<xsl:when test="$contentScope = 'MPI'">
<!-- sourcePatientId is requried, so put the MPIID here -->
<xsl:value-of select="concat(../MPIID/text(),'^^^&amp;',$affinityDomainOID,'&amp;ISO')"/>
</xsl:when>
<xsl:otherwise>
<!-- NOTE: Using the MRN/AA that triggered the push, not the encounter MRN -->
<xsl:variable name="aaOID" select="isc:evaluate('getOIDForCode',../AssigningAuthority/text(),'AssigningAuthority')"/>
<xsl:value-of select="concat(../MRN/text(),'^^^&amp;',$aaOID,'&amp;ISO')"/>
</xsl:otherwise>
</xsl:choose>
</SourcePatientId>
</xsl:template>

<!-- sourcePatientInfo for Document-->
<xsl:template mode="sourcePatientInfo" match="Document">
<xsl:choose>
<xsl:when test="SDA">
<xsl:variable name="patientRoot" select="SDA/Container/Patient"/>
<SourcePatientInfo>
<Value>PID-5|<xsl:value-of select="concat($patientRoot/Name/FamilyName/text(),'^',$patientRoot/Name/GivenName/text())"/></Value>
<Value>PID-7|<xsl:value-of select="translate($patientRoot/BirthTime/text(),'TZ:- ','')"/></Value>
<Value>PID-8|<xsl:value-of select="$patientRoot/Gender/Code/text()"/></Value>
<xsl:variable name="street" select="$patientRoot/Addresses/Address[1]/Street/text()"/>
<xsl:variable name="street1" select="isc:evaluate('piece',$street,';',1)"/>
<xsl:variable name="street2" select="isc:evaluate('piece',$street,';',2)"/>
<xsl:variable name="city" select="$patientRoot/Addresses/Address[1]/City/Code/text()"/>
<xsl:variable name="state" select="$patientRoot/Addresses/Address[1]/State/Code/text()"/>
<xsl:variable name="zip" select="$patientRoot/Addresses/Address[1]/Zip/Code/text()"/>
<xsl:variable name="country" select="$patientRoot/Addresses/Address[1]/Country/Code/text()"/>
<Value>PID-11|<xsl:value-of select="concat($street1,'^',$street2,'^',$city,'^',$state,'^',$zip,'^',$country)"/></Value>
</SourcePatientInfo>
</xsl:when>
<xsl:when test="AddUpdateHubRequest">
<SourcePatientInfo>
<Value>PID-5|<xsl:value-of select="concat(AddUpdateHubRequest/LastName/text(),'^',AddUpdateHubRequest/FirstName/text())"/></Value>
<Value>PID-7|<xsl:value-of select="translate(AddUpdateHubRequest/DOB/text(),'TZ:- ','')"/></Value>
<Value>PID-8|<xsl:value-of select="AddUpdateHubRequest/Sex/text()"/></Value>
<xsl:variable name="street" select="AddUpdateHubRequest/Street/text()"/>
<xsl:variable name="street1" select="isc:evaluate('piece',$street,';',1)"/>
<xsl:variable name="street2" select="isc:evaluate('piece',$street,';',2)"/>
<xsl:variable name="city" select="AddUpdateHubRequest/City/text()"/>
<xsl:variable name="state" select="AddUpdateHubRequest/State/text()"/>
<xsl:variable name="zip" select="AddUpdateHubRequest/Zip/text()"/>
<Value>PID-11|<xsl:value-of select="concat($street1,'^',$street2,'^',$city,'^',$state,'^',$zip)"/></Value>
</SourcePatientInfo>
</xsl:when>
</xsl:choose>

</xsl:template>

<!-- submissionTime for SubmissionSet-->
<xsl:template mode="submissionTime" match="XDSbProcessRequest">
<SubmissionTime>
<xsl:value-of select="isc:evaluate('createHL7Timestamp')"/>
</SubmissionTime>
</xsl:template>

<!-- title for SubmissionSet -->
<xsl:template mode="title" match="XDSbProcessRequest">
<Title>
<xsl:value-of select="Subscription/Subject/text()"/>
</Title>
</xsl:template>

<!-- title for Document -->
<xsl:template mode="title" match="Document">
<xsl:variable name="scope">
<xsl:choose>
<xsl:when test="$isXACML">XACML Privacy Policy</xsl:when>
<xsl:when test="$contentScope = 'Enc'">Encounter Summary</xsl:when>
<xsl:when test="$contentScope = 'MRN'">Medical Record Summary</xsl:when>
<xsl:when test="$contentScope = 'MPI'">Patient Summary</xsl:when>
<xsl:otherwise>Message Summary</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="detail">
<xsl:choose>
<xsl:when test="$transformType='PDF'"><xsl:value-of select=" (PDF)"/></xsl:when>
<xsl:when test="$transformType='HTML'"><xsl:value-of select=" (HTML)"/></xsl:when>
<!-- NOTE: overrides of the transform can look at the custom operation to determine a more accurate mimeType -->
<xsl:when test="$transformType='CUSTOM'"><xsl:value-of select=" (Other)"/></xsl:when>
<xsl:otherwise>
<xsl:value-of select="concat(' (',$transformOption,')')"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<Title>
<xsl:value-of select="concat($scope,$detail)"/>
</Title>
</xsl:template>

<!-- typeCode for Document -->
<xsl:template mode="typeCode" match="Document">
<!-- Default using valid NIST code for connect-a-thon and demo -->
<!-- RHIO's may override by adding config keys to the registry -->
<xsl:variable name="config" select="isc:evaluate('getCodedEntryConfig','typeCode',$contentScope,$transformType,$transformOption)"/>
<xsl:call-template name="insertCode">
<xsl:with-param name="name" select="'TypeCode'"/>
<xsl:with-param name="code">
<xsl:choose>
<xsl:when test="$config"><xsl:value-of select="$config"/></xsl:when>
<xsl:when test="$isXACML">57017-6^Privacy Policy^LOINC</xsl:when>
<xsl:when test="$contentScope = 'Enc'">34133-9^Summarization of Episode Note^LOINC</xsl:when>
<xsl:when test="$contentScope = 'MRN'">34117-2^History And Physical Note^LOINC</xsl:when>
<xsl:when test="$contentScope = 'MPI'">34095-0^Comprehensive History and Physical Note^LOINC</xsl:when>
<xsl:otherwise>34138-8^Targeted History And Physical Note^LOINC</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<!-- uniqueId for SubmissionSet -->
<xsl:template mode="uniqueId" match="XDSbProcessRequest">
<UniqueId>
<xsl:value-of select="isc:evaluate('createOID')"/>
</UniqueId>
</xsl:template>

<!-- Document uniqueId -->
<xsl:template mode="uniqueId" match="Document">
<UniqueId>
<xsl:value-of select="DocumentUniqueId/text()"/>
</UniqueId>
</xsl:template>


<!-- 

			UTILITY TEMPLATES 
					
-->

<!-- Generate a simple author element, assuming only one value for institution, role and specialty -->
<xsl:template name="author">
<xsl:param name="person"/>
<xsl:param name="institution"/>
<xsl:param name="role"/>
<xsl:param name="specialty"/>

<!-- Author person is required -->
<xsl:if test="$person">
<Author>
<AuthorPerson>
<!-- since this is XCN, we should put this in the name piece since some vendors 
   treat the first piece as an id *and* require an AA then
   -->
<xsl:text>^</xsl:text>   
<xsl:value-of select="$person"/>
</AuthorPerson>
<xsl:if test="$institution">
<AuthorInstitution>
<Value>
<xsl:value-of select="$institution"/>
</Value>
</AuthorInstitution>
</xsl:if>

<xsl:if test="$role">
<AuthorRole>
<Value>
<xsl:value-of select="$role"/>
</Value>
</AuthorRole>
</xsl:if>

<xsl:if test="$specialty">
<AuthorSpecialty>
<Value>
<xsl:value-of select="$specialty"/>
</Value>
</AuthorSpecialty>
</xsl:if>

</Author>
</xsl:if>
</xsl:template>

<!-- Generate author element using the home community -->
<xsl:template name="communityAuthor">
<xsl:param name="oid" select="$homeCommunityOID"/>
<xsl:call-template name="author">
<xsl:with-param name="person" select="isc:evaluate('getCodeForOID',$oid,'HomeCommunity')"/>
<xsl:with-param name="institution" select="isc:evaluate('getDescriptionForOID',$oid,'HomeCommunity')"/>
</xsl:call-template>
</xsl:template>

<!-- Generate author element using clinician/entered-by -->
<xsl:template mode="personAuthor" match="*">
<xsl:variable name="oid" select="isc:evaluate('getOIDForCode',SDACodingStandard/text(),'AssigningAuthority')"/>
<xsl:call-template name="author">
<xsl:with-param name="person" select="Description/text()"/>
<xsl:with-param name="institution" select="isc:evaluate('getDescriptionForOID',$oid,'AssigningAuthority',SDACodingStandard/text())"/>
<!-- Care providers can have a role, EnteredBy will not -->
<xsl:with-param name="role" select="CareProviderType/Description/text()"/>
</xsl:call-template>
</xsl:template>

<!-- Convert a ^ delimited string into coded entry element -->
<xsl:template name="insertCode">
<xsl:param name="name"/>
<xsl:param name="code"/>
<xsl:element name="{$name}">
<Code>
<xsl:value-of select="substring-before($code,'^')"/>
</Code>
<Description>
<xsl:value-of select="substring-before(substring-after($code,'^'),'^')"/>
</Description>
<Scheme>
<xsl:value-of select="substring-after(substring-after($code,'^'),'^')"/>
</Scheme>
</xsl:element>
</xsl:template>


</xsl:stylesheet>
