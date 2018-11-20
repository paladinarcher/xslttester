<?xml version="1.0" encoding="UTF-8"?>
<!--  DEPRECATED - this stylesheet is no longer suppored by InterSystems
-->
<xsl:stylesheet 
version="1.0" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:xdsb="urn:ihe:iti:xds-b:2007" 
xmlns:xop="http://www.w3.org/2004/08/xop/include" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
exclude-result-prefixes="isc">
  
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  
<xsl:template match="/">
<xsl:apply-templates select="ProvideAndRegisterDocumentSet"/>
</xsl:template>

<xsl:template match="ProvideAndRegisterDocumentSet">
<xdsb:ProvideAndRegisterDocumentSetRequest>
<lcm:SubmitObjectsRequest>
<rim:RegistryObjectList>
	
<!-- XDSDocumentEntry -->
<xsl:for-each select="Document">
<xsl:variable name="docUUID" select="concat('urn:uuid:',EntryUUID/text())"/>

<!-- DocSource generating entryUUID to support RPLC option -->
<xsl:element name="rim:ExtrinsicObject">
<xsl:attribute name="id"><xsl:value-of select="$docUUID"/></xsl:attribute>
<xsl:attribute name="mimeType"><xsl:value-of select="MimeType/text()"/></xsl:attribute>
<xsl:attribute name="objectType"><xsl:value-of select="'urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1'"/></xsl:attribute>
<xsl:if test="AvailabilityStatus">
<xsl:attribute name="status"><xsl:value-of select="AvailabilityStatus/text()"/></xsl:attribute>
</xsl:if>
	  
<xsl:apply-templates mode="rimSlot" select="CreationTime"/>
<xsl:apply-templates mode="rimSlot" select="LanguageCode"/>
<xsl:apply-templates mode="rimSlot" select="SourcePatientId"/>
<xsl:apply-templates mode="rimSlot" select="LegalAuthenticator"/>
<xsl:apply-templates mode="rimSlot" select="ServiceStartTime"/>
<xsl:apply-templates mode="rimSlot" select="ServiceStopTime"/>
<xsl:apply-templates mode="rimSlot" select="SourcePatientInfo"/>
	    
<rim:Name><rim:LocalizedString value="{Title}"/></rim:Name>
<rim:Description><rim:LocalizedString value="{Comments}"/></rim:Description>
	    
<xsl:apply-templates mode="rimClassification" select="ClassCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="ConfidentialityCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="FormatCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="HealthcareFacilityTypeCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="PracticeSettingCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="TypeCode"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="rimClassification" select="EventCodeList"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>
<xsl:apply-templates mode="author" select="Author"><xsl:with-param name="object" select="$docUUID"/></xsl:apply-templates>

<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="{$docUUID}"
identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427"
value="{PatientId/text()}">
<rim:Name><rim:LocalizedString value="XDSDocumentEntry.patientId"/></rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="{$docUUID}"
identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab"
value="{UniqueId/text()}">
<rim:Name><rim:LocalizedString value="XDSDocumentEntry.uniqueId"/></rim:Name>
</rim:ExternalIdentifier>
<!--</rim:ExtrinsicObject>-->
</xsl:element>
</xsl:for-each>

<!-- XDSSubmissionSet -->
<rim:RegistryPackage id="SS" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
<xsl:apply-templates mode="rimSlot" select="SubmissionSet/SubmissionTime"/>
<xsl:apply-templates mode="rimSlot" select="SubmissionSet/IntendedRecipient"/>

<rim:Name><rim:LocalizedString value="{SubmissionSet/Title}"/></rim:Name>
<rim:Description><rim:LocalizedString value="{SubmissionSet/Comments}"/></rim:Description>

<xsl:apply-templates mode="rimClassification" select="SubmissionSet/ContentTypeCode"><xsl:with-param name="object">SS</xsl:with-param></xsl:apply-templates>
<xsl:apply-templates mode="author" select="/ProvideAndRegisterDocumentSet/Document/Author"><xsl:with-param name="object">SS</xsl:with-param></xsl:apply-templates>

<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="SS"
identificationScheme="urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446"
value="{SubmissionSet/PatientId/text()}">
<rim:Name><rim:LocalizedString value="XDSSubmissionSet.patientId"/></rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="SS"
identificationScheme="urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8"
value="{SubmissionSet/UniqueId/text()}">
<rim:Name><rim:LocalizedString value="XDSSubmissionSet.uniqueId"/></rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="SS"
identificationScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832"
value="{SubmissionSet/SourceId/text()}">
<rim:Name><rim:LocalizedString value="XDSSubmissionSet.sourceId"/></rim:Name>
</rim:ExternalIdentifier>
</rim:RegistryPackage>

<!-- XDSFolder -->
<xsl:for-each select="Folder">
<xsl:variable name="folderUUID" select="concat('urn:uuid:',EntryUUID/text())"/>
<rim:RegistryPackage 
id="{$folderUUID}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
	    
<rim:Name><rim:LocalizedString value="{Title}"/></rim:Name>
<rim:Description><rim:LocalizedString value="{Comments}"/></rim:Description>
	  
<xsl:apply-templates mode="rimClassification" select="CodeList"><xsl:with-param name="object" select="$folderUUID"/></xsl:apply-templates>

<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="{$folderUUID}"
identificationScheme="urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a"
value="{PatientId/text()}">
<rim:Name><rim:LocalizedString value="XDSFolder.patientId"/></rim:Name>
</rim:ExternalIdentifier>

<rim:ExternalIdentifier 
id="{isc:evaluate('createID')}"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier"
registryObject="{$folderUUID}"
identificationScheme="urn:uuid:75df8f67-9973-4fbe-a900-df66cefecc5a"
value="{UniqueId/text()}">
<rim:Name><rim:LocalizedString value="XDSFolder.uniqueId"/></rim:Name>
</rim:ExternalIdentifier>
</rim:RegistryPackage>
</xsl:for-each>

<!-- Classification: Indicate which RegistryPackage is a XSDSubmissionSet -->
<rim:Classification 
id="{isc:evaluate('createID','isSS')}"
classifiedObject="SS"
classificationNode="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>

<!-- Classification: Indicate which RegistryPackages are XDSFolders -->
<xsl:for-each select="Folder">
<rim:Classification 
id="{isc:evaluate('createID','isFolder')}"
classifiedObject="{concat('urn:uuid:',EntryUUID/text())}"
classificationNode="urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2" 
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>
</xsl:for-each>
	
<!-- Association: Insert documents into submission set -->
<xsl:for-each select="Document">
<rim:Association
id="{isc:evaluate('createID','ssDocument')}"
sourceObject="SS" 
targetObject="{concat('urn:uuid:',EntryUUID/text())}" 
associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association">
<rim:Slot name="SubmissionSetStatus">
<rim:ValueList>
<rim:Value>Original</rim:Value>
</rim:ValueList>
</rim:Slot>
</rim:Association>
</xsl:for-each>

<!-- Association: Insert folders into submission set -->
<xsl:for-each select="Folder">
<rim:Association
id="{isc:evaluate('createID','ssFolder')}"
sourceObject="SS" 
targetObject="{concat('urn:uuid:',EntryUUID/text())}" 
associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association">
</rim:Association>
</xsl:for-each>

<!-- Association: Insert documents into folders -->
<xsl:apply-templates mode="addDocToFolder" select="Document"/>
<xsl:apply-templates mode="addDocToFolder" select="FolderAssociation"/>

<!-- Association: replacements -->
<xsl:for-each select="Document">
<xsl:if test="PreviousUUID/text()">
<rim:Association 
id="{isc:evaluate('createID','replacement')}" 
sourceObject="{concat('urn:uuid:',EntryUUID/text())}"
targetObject="{concat('urn:uuid:',PreviousUUID/text())}"
associationType="urn:ihe:iti:2007:AssociationType:RPLC"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association"/>
</xsl:if>
</xsl:for-each>

<!-- Association: snapshots -->
<xsl:for-each select="Document">
<xsl:if test="IsSnapshotOf/text()">
<rim:Association 
id="{isc:evaluate('createID','snapshot')}" 
sourceObject="{concat('urn:uuid:',EntryUUID/text())}"
targetObject="{concat('urn:uuid:',IsSnapshotOf/text())}"
associationType="urn:ihe:iti:2010:AssociationType:IsSnapshotOf"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association"/>
</xsl:if>
</xsl:for-each>

<!-- Object References -->
<xsl:for-each select="ObjectRef">
<rim:ObjectRef id="{concat('urn:uuid:',id/text())}"/>
</xsl:for-each>
</rim:RegistryObjectList>
</lcm:SubmitObjectsRequest>

<!-- XOP document content pointer(s) -->
<xsl:for-each select="Document">
<xdsb:Document id="{concat('urn:uuid:',EntryUUID/text())}">
<xop:Include href="{concat('cid:urn:uuid:',EntryUUID/text())}"/>
</xdsb:Document>
</xsl:for-each>
</xdsb:ProvideAndRegisterDocumentSetRequest>
</xsl:template>

<!-- Generic <rim:Slot> element generator -->
<xsl:template match="*" mode="rimSlot">
<xsl:variable name="localname" select="concat(translate(substring(local-name(),1,1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'	),substring(local-name(),2))"/>
<rim:Slot name="{$localname}"> 
<rim:ValueList>
<xsl:choose>
<xsl:when test="Value">
<xsl:for-each select="Value">
<rim:Value><xsl:value-of select="text()"/></rim:Value> 
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<rim:Value><xsl:value-of select="text()"/></rim:Value> 
</xsl:otherwise>
</xsl:choose>
</rim:ValueList> 
</rim:Slot>
</xsl:template>

<!-- Generic <rim:Classification> element generator -->
<xsl:template match="*" mode="rimClassification">
<xsl:param name="object"/>
<xsl:if test="Code">
<xsl:element name="rim:Classification">
<xsl:attribute name="id"><xsl:value-of select="isc:evaluate('createID',local-name())"/></xsl:attribute>
<xsl:attribute name="nodeRepresentation"><xsl:value-of select="Code/text()"/></xsl:attribute>
<xsl:attribute name="objectType">urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification</xsl:attribute>
<xsl:attribute name="classifiedObject"><xsl:value-of select="$object"/></xsl:attribute>
<xsl:attribute name="classificationScheme">
<xsl:choose>
<xsl:when test="local-name() = 'ClassCode'">urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a</xsl:when>
<xsl:when test="local-name() = 'ConfidentialityCode'">urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f</xsl:when>
<xsl:when test="local-name() = 'ContentTypeCode'">urn:uuid:aa543740-bdda-424e-8c96-df4873be8500</xsl:when>
<xsl:when test="local-name() = 'EventCodeList'">urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4</xsl:when>
<xsl:when test="local-name() = 'FormatCode'">urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d</xsl:when>
<xsl:when test="local-name() = 'HealthcareFacilityTypeCode'">urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1</xsl:when>
<xsl:when test="local-name() = 'TypeCode'">urn:uuid:f0306f51-975f-434e-a61c-c59651d33983</xsl:when>
<xsl:when test="local-name() = 'PracticeSettingCode'">urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead</xsl:when>
<xsl:when test="local-name() = 'CodeList'">urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5</xsl:when>
</xsl:choose>
</xsl:attribute>
<rim:Slot name="codingScheme">
<rim:ValueList>
<rim:Value><xsl:value-of select="Scheme/text()"/></rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Name><rim:LocalizedString value="{Description/text()}"/></rim:Name>
</xsl:element>
</xsl:if>
</xsl:template>

<!-- Specialized version of the rimClassification generator for authors -->
<xsl:template match="Author" mode="author">
<xsl:param name="object"/>
<xsl:element name="rim:Classification">
<xsl:attribute name="id"><xsl:value-of select="isc:evaluate('createID',local-name())"/></xsl:attribute>
<xsl:attribute name="nodeRepresentation"/>
<xsl:attribute name="objectType">urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification</xsl:attribute>
<xsl:attribute name="classifiedObject"><xsl:value-of select="$object"/></xsl:attribute>
<xsl:choose>
<xsl:when test="$object= 'SS'"><xsl:attribute name="classificationScheme">urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d</xsl:attribute></xsl:when>
<xsl:otherwise><xsl:attribute name="classificationScheme">urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d</xsl:attribute></xsl:otherwise>
</xsl:choose>                                                

<xsl:apply-templates mode="rimSlot" select="AuthorPerson"/>
<xsl:apply-templates mode="rimSlot" select="AuthorInstitution"/>
<xsl:apply-templates mode="rimSlot" select="AuthorRole"/>
<xsl:apply-templates mode="rimSlot" select="AuthorSpecialty"/>
</xsl:element>
</xsl:template>

<!-- Associate folders to documents implicitly or from document object ref -->
<xsl:template match="*" mode="addDocToFolder">
<xsl:if test="FolderUUID">
<xsl:variable name="folderDocID" select="isc:evaluate('createID','folderDocument')"/>
<rim:Association
id="{$folderDocID}"
sourceObject="{concat('urn:uuid:',FolderUUID/text())}" 
targetObject="{concat('urn:uuid:',EntryUUID/text())}" 
associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association">
</rim:Association>
<rim:Association
id="{isc:evaluate('createID','ssFolderDoc')}"
sourceObject="SS" 
targetObject="{$folderDocID}" 
associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember"
objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Association">
</rim:Association>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
