<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
                xmlns:isc="http://extension-functions.intersystems.com"
                exclude-result-prefixes="rim rs isc">
   <!-- Contains shared routines that emit IHE/RIM namespaced elements
        and related attributes. When including this file,
        AlsoInclude: UtilityMapURN.xsl Variables.xsl -->
   <!-- The prefix for template/mode names in this file is "utEI" -->
   
   <xsl:template match="*" mode="utEI-A-identifiers">
      <!-- To be used when emitting rim:RegistryPackage, rim:ExtrinsicObject, etc. -->
      <xsl:attribute name="id">
         <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="lid">
         <xsl:choose>
            <xsl:when test="@lid"><xsl:value-of select="@lid"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template match="*[local-name()='ObjectRef']" mode="utEI-rimObjectRef">
      <!-- Destination: child elements of rim:RegistryObjectList -->
      <rim:ObjectRef id="{@id}"/>
   </xsl:template>
   
   <!--******************** Named templates ********************-->
   <xsl:template name="moreRegistryError"/><!--placeholder; see utEI-rsRegistryErrorList -->
   
   <xsl:template name="utEI-allSlotValue">
      <!-- Source has @name, SlotValue- our internal "old metadata" format.\
           We need a name for rim:Slot; ensure that the source has one. -->
      <xsl:for-each select="Slot[@name]">
         <rim:Slot>
            <xsl:copy-of select="@name"/>
            <rim:ValueList>
               <xsl:for-each select="ValueList/SlotValue">
                  <rim:Value>
                     <xsl:value-of select="text()"/>
                  </rim:Value>
               </xsl:for-each>
            </rim:ValueList>
         </rim:Slot>
      </xsl:for-each>
   </xsl:template>
      
   <xsl:template name="utEI-allSlot-DocumentRegistry">
      <!-- Source has Name, ValueListItem- Document Registry Classification format (Cache' default naming scheme) -->
      <xsl:for-each select="Slot">
         <rim:Slot>
            <xsl:attribute name="name">
               <xsl:value-of select="Name"/>
            </xsl:attribute>
            <rim:ValueList>
               <xsl:for-each select="ValueList/ValueListItem">
                  <rim:Value>
                     <xsl:value-of select="text()"/>
                  </rim:Value>
               </xsl:for-each>
            </rim:ValueList>
         </rim:Slot>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utEI-allSlot-choose">
      <!-- Source has @name, Value (our internal "MetadataObject" format),
           or possibly just @name and text content -->
      <xsl:for-each select="Slot">
         <rim:Slot>
            <xsl:copy-of select="@name"/>
            <rim:ValueList>
               <xsl:choose>
                  <xsl:when test="ValueList">
                     <xsl:for-each select="ValueList/Value">
                        <rim:Value>
                           <xsl:value-of select="text()"/>
                        </rim:Value>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <rim:Value>
                        <xsl:value-of select="text()"/>
                     </rim:Value>
                  </xsl:otherwise>
               </xsl:choose>
            </rim:ValueList>
         </rim:Slot>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utEI-A-ObjectType">
      <!-- Codes are for ExtrinsicObject types -->
      <xsl:attribute name="objectType">
         <xsl:choose>
            <xsl:when test="@type='OnDemand'">
               <xsl:value-of select="$xdsbOnDemandDocument"/>
            </xsl:when>
            <xsl:when test="@type='Stable'">
               <xsl:value-of select="$xdsbStableDocument"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$xdsbStableDocument"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template name="utEI-A-status">
      <!-- Add in @status. Context node (of source) is Document.
           ToDo: consider defaulting to Submitted, which is apparently the initial
           status, if AvailabilityStatus is missing. -->
      <xsl:if test="string-length(AvailabilityStatus) > 0">
         <xsl:attribute name="status">
            <xsl:value-of select="concat($statusTypePrefix, AvailabilityStatus/text())"/>
         </xsl:attribute>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-copyObjectRefs">
      <!-- Source: old metadata, MetadataObject, ProvideAndRegister formats
           Destination: child elements of rim:RegistryObjectList -->
      <xsl:for-each select="ObjectRef">
         <rim:ObjectRef id="{@id}"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utEI-copyObjectRefs-QueryResponse">
      <!-- Source: Submission element in a query
           Destination: child elements of rim:RegistryObjectList -->
      <xsl:for-each select="ObjectRef">
         <rim:ObjectRef id="{text()}"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-author">
      <xsl:param name="idSeed" select="'id'"/>
      <xsl:param name="classifiedObj"/>
      <xsl:param name="schemeKey"/><!-- Keyword: Document, Submission -->
      <!-- possible new options: noTelecom, alwaysNewID -->

      <!-- per IHE_ITI_TF V3, 4.2.3.1.4, authorPerson, AuthorInstitution or AuthorTelecommunication must be present -->
      <xsl:if test="AuthorPerson or AuthorInstitution[Value/text() or text()] or AuthorTelecommunication[Value/text() or text()]">
         <rim:Classification>
            <xsl:attribute name="id">
               <xsl:choose>
                  <xsl:when test="@id">
                     <xsl:value-of select="@id"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="isc:evaluate('createID', $idSeed)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="nodeRepresentation"/>
            <xsl:attribute name="objectType">urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification</xsl:attribute>
            <xsl:attribute name="classifiedObject">
               <xsl:value-of select="$classifiedObj"/>
            </xsl:attribute>
            <xsl:attribute name="classificationScheme">
               <xsl:choose>
                  <xsl:when test="$schemeKey = 'Document'"><xsl:value-of select="$documentAuthorScheme"/></xsl:when>
                  <xsl:when test="$schemeKey = 'Submission'"><xsl:value-of select="$submissionAuthorScheme"/></xsl:when>
               </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="utEI-rimSlot-fromField">
               <xsl:with-param name="input" select="AuthorPerson"/>
            </xsl:call-template>
            <xsl:for-each select="AuthorInstitution[Value or text()]">
               <xsl:call-template name="utEI-rimSlot-fromField">
                  <xsl:with-param name="input" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="AuthorRole[Value or text()]">
               <xsl:call-template name="utEI-rimSlot-fromField">
                  <xsl:with-param name="input" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="AuthorSpecialty[Value or text()]">
               <xsl:call-template name="utEI-rimSlot-fromField">
                  <xsl:with-param name="input" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="AuthorTelecommunication[Value/text() or text()]">
               <xsl:call-template name="utEI-rimSlot-fromField">
                  <xsl:with-param name="input" select="."/>
               </xsl:call-template>
            </xsl:for-each>
         </rim:Classification>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-Folder">
      <xsl:param name="classifiedObj"/>
      <xsl:param name="idSeed" select="'isFolder'"/>
      <rim:Classification objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"
         id="{isc:evaluate('createID',$idSeed)}"
         classificationNode="{$folderClass}">
         <xsl:attribute name="classifiedObject">
            <xsl:value-of select="$classifiedObj"/>
         </xsl:attribute>
      </rim:Classification>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-Meta-generic">
      <xsl:param name="sourceElement"/><!-- node -->
      <xsl:param name="idValue"/><!-- string -->
      <xsl:param name="classifiedObj"/>
      <xsl:param name="extras"/><!-- |@lid|description| -->
      <!-- Read in MetadataObject format, allow subsidiary slots, ClassificationScheme from element -->
      <rim:Classification objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
         <xsl:attribute name="id">
            <xsl:value-of select="$idValue"/>
         </xsl:attribute>
         <xsl:if test="contains($extras,'|@lid|')">
            <xsl:attribute name="lid">
               <xsl:value-of select="$idValue"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:attribute name="classifiedObject">
            <xsl:value-of select="$classifiedObj"/>
         </xsl:attribute>
         <xsl:attribute name="nodeRepresentation">
            <xsl:value-of select="$sourceElement/Code/text()"/>
         </xsl:attribute>
         <xsl:attribute name="classificationScheme">
            <xsl:value-of select="$sourceElement/ClassificationScheme/text()"/>
         </xsl:attribute>
         <xsl:call-template name="utEI-rimSlot-codingScheme">
            <xsl:with-param name="value" select="$sourceElement/CodingScheme/text()"/>
         </xsl:call-template>
         <xsl:call-template name="utEI-rimName">
            <xsl:with-param name="value" select="$sourceElement/Name"/>
            <xsl:with-param name="augmentation" select="'MetadataObject'"/>
         </xsl:call-template>
         <xsl:if test="contains($extras, '|description|')">
            <xsl:for-each select="$sourceElement/Description">
               <xsl:call-template name="utEI-rimDescription">
                  <xsl:with-param name="value" select="."/>
                  <xsl:with-param name="augmentation" select="'MetadataObject'"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:if>
         <xsl:for-each select="Slot[@name != 'codingScheme']">
            <xsl:call-template name="utEI-rimSlot-fromGenericSlot"/>
         </xsl:for-each>
      </rim:Classification>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-Meta-map">
      <xsl:param name="sourceElement"/><!-- node -->
      <xsl:param name="idValue"/><!-- string -->
      <xsl:param name="classifiedObj"/>
      <xsl:param name="extras"/><!-- |@lid|description|displayName| -->
      <xsl:param name="version"/>
      <!-- Read in MetadataObject format, allow version, ClassificationScheme mapped -->
      <rim:Classification objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
         <xsl:attribute name="id">
            <xsl:value-of select="$idValue"/>
         </xsl:attribute>
         <xsl:if test="contains($extras,'|@lid|')">
            <xsl:attribute name="lid">
               <xsl:value-of select="$idValue"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:attribute name="classifiedObject">
            <xsl:value-of select="$classifiedObj"/>
         </xsl:attribute>
         <xsl:attribute name="nodeRepresentation">
            <xsl:value-of select="$sourceElement/Code/text()"/>
         </xsl:attribute>

         <xsl:attribute name="classificationScheme">
            <xsl:apply-templates select="$classificationTable" mode="utMU-getClassifURN">
               <xsl:with-param name="lookup" select="local-name($sourceElement)"/>
            </xsl:apply-templates>
         </xsl:attribute>
         <xsl:call-template name="utEI-rimSlot-codingScheme">
            <xsl:with-param name="value" select="$sourceElement/CodingScheme/text()"/>
         </xsl:call-template>
         <xsl:choose>
            <xsl:when test="$sourceElement/Name">
               <xsl:call-template name="utEI-rimName">
                  <xsl:with-param name="value" select="$sourceElement/Name"/>
                  <xsl:with-param name="augmentation" select="'MetadataObject'"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="contains($extras,'|displayName|')">
               <!-- If this extra is present, must force a name; fail over to Code -->
               <xsl:call-template name="utEI-rimName">
                  <xsl:with-param name="value" select="$sourceElement/Code"/>
                  <xsl:with-param name="augmentation" select="'NONE'"/>
               </xsl:call-template>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>

         <xsl:if test="contains($extras, '|description|')">
            <xsl:for-each select="$sourceElement/Description">
               <xsl:call-template name="utEI-rimDescription">
                  <xsl:with-param name="value" select="."/>
                  <xsl:with-param name="augmentation" select="'MetadataObject'"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:if>
         <xsl:if test="string-length($version) &gt; 0">
            <rim:VersionInfo versionName="{$version}"/>
         </xsl:if>
      </rim:Classification>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-ProvideAndRegister">
      <xsl:param name="sourceElement"/><!-- must be a node -->
      <xsl:param name="classifiedObj"/>
      <xsl:param name="augmentation" select="'NONE'"/>
      <rim:Classification objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"
         id="{isc:evaluate('createID',local-name($sourceElement))}">
         <xsl:attribute name="classifiedObject">
            <xsl:value-of select="$classifiedObj"/>
         </xsl:attribute>
         <xsl:attribute name="nodeRepresentation">
            <xsl:value-of select="$sourceElement/Code/text()"/>
         </xsl:attribute>
         <xsl:attribute name="classificationScheme">
            <xsl:apply-templates select="$classificationTable" mode="utMU-getClassifURN">
               <xsl:with-param name="lookup" select="local-name($sourceElement)"/>
            </xsl:apply-templates>
         </xsl:attribute>
         <xsl:call-template name="utEI-rimSlot-codingScheme">
            <xsl:with-param name="value" select="$sourceElement/Scheme/text()"/>
         </xsl:call-template>
         <xsl:call-template name="utEI-rimName">
            <xsl:with-param name="value" select="$sourceElement/Description"/>
            <xsl:with-param name="augmentation" select="$augmentation"/>
         </xsl:call-template>
      </rim:Classification>
   </xsl:template>
   
   <xsl:template name="utEI-rimClassification-SubmissionSet">
      <xsl:param name="classifiedObj"/>
      <rim:Classification objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"
         id="{isc:evaluate('createID','isSS')}"
         classificationNode="{$submissionSetClass}">
         <xsl:attribute name="classifiedObject">
            <xsl:value-of select="$classifiedObj"/>
         </xsl:attribute>
      </rim:Classification>
   </xsl:template>
   
   <xsl:template name="utEI-rimDescription">
      <xsl:param name="value"/>
      <xsl:param name="augmentation"/><!-- NONE, GLOBAL, MetadataObject, ProvideAndRegister, SIBLING; or language string -->
      <!-- Produce a rim:Description and, if there is content, the inner rim:LocalizedString
           to contain it. The caller is responsible for setting the value (a node which
           contains the real description as attribute value or text-node child) and the
           option for charset/lang, and also for determining whether a rim:Description
           should be emitted at all. -->
      <rim:Description>
         <xsl:if test="string-length($value) > 0"><!-- avoid setting charset/lang if empty $value -->
            <xsl:choose>
               <xsl:when test="$augmentation = 'NONE'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'ProvideAndRegister'"><!-- attributes already in RIM emplacement -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="charset" select="$value/../@charset"/>
                     <xsl:with-param name="language" select="$value/../@xml:lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'MetadataObject'"><!-- MetadataObject/Document/Submission IHE.XDSb.ValueType -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="charset" select="$value/@Charset"/>
                     <xsl:with-param name="language" select="$value/@Lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'SIBLING'"><!-- As seen in "registry object", for example -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="charset" select="$value/../Charset"/>
                     <xsl:with-param name="language" select="$value/../Lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'GLOBAL'"><!-- HS.Message.IHE.XDSb.Metadata string for Language -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value/text()"/>
                     <xsl:with-param name="language">
                        <xsl:if test="string-length(/*/Language/text())">
                           <!-- Previously had the added filter: and /*/Language/text()!='en-US' -->
                           <xsl:value-of select="/*/Language/text()"/>
                        </xsl:if>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise><!-- $augmentation to be used as the language -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="language" select="$augmentation"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
      </rim:Description>
   </xsl:template>
   
   <xsl:template name="utEI-rimExternalIdentifier">
      <xsl:param name="sourceType" select="'MetadataObject'"/><!-- Keyword: 'MetadataObject' or 'RegistryObject' -->
      <xsl:param name="value"/>
      <xsl:param name="RegObject"/>
      <xsl:param name="version"/>
      <!-- Use this template to produce rim:ExternalIdentifier for a
           rim:ExtrinsicObject or rim:RegistryPackage -->
      <xsl:if test="$value != ''">
         <rim:ExternalIdentifier>
            <xsl:choose>
               <xsl:when test="$sourceType = 'MetadataObject'">
                  <xsl:attribute name="id">
                     <xsl:choose>
                        <xsl:when test="@id">
                           <xsl:value-of select="@id"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="isc:evaluate('createID',concat('x',local-name()))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="$sourceType = 'RegistryObject'">
                  <xsl:attribute name="id">
                     <xsl:value-of select="@id"/>
                  </xsl:attribute>
                  <xsl:if test="string-length(@lid) &gt; 0">
                     <xsl:attribute name="lid">
                        <xsl:value-of select="@lid"/>
                     </xsl:attribute>
                  </xsl:if>
               </xsl:when>
            </xsl:choose>
            <xsl:attribute name="objectType">urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier</xsl:attribute>
            <xsl:attribute name="value">
               <xsl:value-of select="$value"/>
            </xsl:attribute>
            <xsl:attribute name="registryObject">
               <xsl:value-of select="$RegObject"/>
            </xsl:attribute>
            <xsl:attribute name="identificationScheme">
               <xsl:value-of select="IdentificationScheme/text()"/>
            </xsl:attribute>
            <xsl:choose>
               <xsl:when test="$sourceType = 'MetadataObject'">
                  <xsl:call-template name="utEI-rimName">
                     <xsl:with-param name="value" select="Name"/>
                     <xsl:with-param name="augmentation" select="'MetadataObject'"/>
                  </xsl:call-template>
                  <xsl:call-template name="utEI-rimDescription">
                     <xsl:with-param name="value" select="Description"/>
                     <xsl:with-param name="augmentation" select="'MetadataObject'"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$sourceType = 'RegistryObject'">
                  <xsl:choose>
                     <xsl:when test="Title/ValueText != ''">
                        <xsl:call-template name="utEI-rimName">
                           <xsl:with-param name="value" select="Title/ValueText"/>
                           <xsl:with-param name="augmentation" select="'SIBLING'"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:when test="Name/ValueText != ''">
                        <xsl:call-template name="utEI-rimName">
                           <xsl:with-param name="value" select="Name/ValueText"/>
                           <xsl:with-param name="augmentation" select="'SIBLING'"/>
                        </xsl:call-template>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:choose>
                     <xsl:when test="Comments/ValueText != ''">
                        <xsl:call-template name="utEI-rimDescription">
                           <xsl:with-param name="value" select="Comments/ValueText"/>
                           <xsl:with-param name="augmentation" select="'SIBLING'"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:when test="Description/ValueText != ''">
                        <xsl:call-template name="utEI-rimDescription">
                           <xsl:with-param name="value" select="Description/ValueText"/>
                           <xsl:with-param name="augmentation" select="'SIBLING'"/>
                        </xsl:call-template>
                     </xsl:when>
                  </xsl:choose>
                  <rim:VersionInfo versionName="{$version}"/>
               </xsl:when>
            </xsl:choose>
         </rim:ExternalIdentifier>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimExternalIdentifier-map">
      <xsl:param name="itemType" select="'Document'"/><!-- Keyword: 'Document', 'Submission', 'Folder' -->
      <xsl:param name="IDcopy" select="'NEVER'"/><!-- Keyword: 'ALWAYS', 'SUPPLIED', 'NEVER' -->
      <xsl:param name="idSeed" select="'id'"/>
      <xsl:param name="lid"/>
      <xsl:param name="value"/><!-- Element whose text content will be extracted for @value and whose name
                 is used as a selector for @identificationScheme and Name -->
      <xsl:param name="RegObject"/><!-- To override the default, which is the @id of the Document/Submission/Folder -->
      <xsl:param name="version"/><!-- For transformations that maintain rim:VersionInfo -->
      <xsl:if test="$value != ''">
         <rim:ExternalIdentifier>
            <xsl:attribute name="id">
               <xsl:choose>
                  <xsl:when test="$IDcopy = 'NEVER'"><!-- Normal case -->
                     <xsl:value-of select="isc:evaluate('createID', $idSeed)"/>
                  </xsl:when>
                  <xsl:when test="$IDcopy = 'ALWAYS'"><!-- e.g., if source is query response -->
                     <xsl:value-of select="$value/@id"/>
                  </xsl:when>
                  <xsl:when test="$IDcopy = 'SUPPLIED'"><!-- e.g., if source is MetadataObject -->
                     <xsl:value-of select="$idSeed"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:attribute>
            <xsl:if test="string-length($lid)>0">
               <xsl:attribute name="lid">
                  <xsl:value-of select="$lid"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="value">
               <xsl:choose>
                  <xsl:when test="$value/Value">
                     <xsl:value-of select="$value/Value/text()"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$value"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="registryObject">
               <xsl:choose>
                  <xsl:when test="string-length($RegObject) &gt; 0">
                     <xsl:value-of select="$RegObject"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$value/../@id"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="identSchemeURN">
               <xsl:apply-templates select="$identSchemeTable" mode="utMU-getIdentURN-byAnyName">
                  <xsl:with-param name="itemType" select="$itemType"/>
                  <xsl:with-param name="lookup" select="local-name($value)"/>
               </xsl:apply-templates>
            </xsl:variable>
            <xsl:attribute name="identificationScheme">
               <xsl:value-of select="$identSchemeURN"/>
            </xsl:attribute>
            <xsl:attribute name="objectType">urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier</xsl:attribute>
            <xsl:call-template name="utEI-rimName">
               <xsl:with-param name="value">
                  <xsl:apply-templates select="$identSchemeTable" mode="utMU-getIdentNameLS-byURN">
                     <xsl:with-param name="urn" select="$identSchemeURN"/>
                  </xsl:apply-templates>
               </xsl:with-param>
               <xsl:with-param name="augmentation" select="'NONE'"/>
               <!-- never localized anyway -->
            </xsl:call-template>
            <xsl:if test="string-length($version) &gt; 0">
               <rim:VersionInfo versionName="{$version}"/>
            </xsl:if>
         </rim:ExternalIdentifier>
      </xsl:if>
   </xsl:template>

   <xsl:template name="utEI-rimLocalizedString">
      <xsl:param name="value"/>
      <xsl:param name="charset"/>
      <xsl:param name="language"/>
      <!-- Produce rim:LocalizedString with @value and possibly other attributes.
           charset and xml:lang will not be set if inputs are null. -->
      <rim:LocalizedString value="{$value}">
         <xsl:if test="string-length($charset)>0">
            <xsl:attribute name="charset">
               <xsl:value-of select="$charset"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="string-length($language)>0">
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="$language"/>
            </xsl:attribute>
         </xsl:if>
      </rim:LocalizedString>
   </xsl:template>
   
   <xsl:template name="utEI-rimName">
      <xsl:param name="value"/>
      <xsl:param name="augmentation" select="'NONE'"/><!-- NONE, GLOBAL, MetadataObject, ProvideAndRegister, SIBLING; or language string -->
      <!-- Produce a rim:Name and, if there is content, the inner rim:LocalizedString
           to contain it. The caller is responsible for setting the value (a node which
           contains the real description as attribute value or text-node child
           OR a quoted string (in which case $augmentation must be NONE)
           and the option for charset/lang. -->
      <rim:Name>
         <xsl:if test="string-length($value) > 0"><!-- avoid setting charset/lang if empty $value -->
            <xsl:choose>
               <xsl:when test="$augmentation = 'NONE'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'ProvideAndRegister'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="charset" select="$value/../@charset"/>
                     <xsl:with-param name="language" select="$value/../@xml:lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'MetadataObject'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value/text()"/>
                     <xsl:with-param name="charset" select="$value/@Charset"/>
                     <xsl:with-param name="language" select="$value/@Lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'SIBLING'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="charset" select="$value/../Charset"/>
                     <xsl:with-param name="language" select="$value/../Lang"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$augmentation = 'GLOBAL'">
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value/text()"/>
                     <xsl:with-param name="language">
                        <xsl:if test="string-length(/*/Language/text())">
                           <xsl:value-of select="/*/Language/text()"/>
                        </xsl:if>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise><!-- $augmentation to be used as the language -->
                  <xsl:call-template name="utEI-rimLocalizedString">
                     <xsl:with-param name="value" select="$value"/>
                     <xsl:with-param name="language" select="$augmentation"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
      </rim:Name>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-choose">
      <xsl:param name="input"/>
      <!-- Emit one rim:Slot with one or more values, named as specified.
           The input node can have some Value children, a ValueList, or just a text node.
      -->
      <rim:Slot name="{local-name($input)}">
         <rim:ValueList>
            <xsl:choose>
               <xsl:when test="$input/Value">
                  <xsl:for-each select="$input/Value">
                     <rim:Value>
                        <xsl:value-of select="text()"/>
                     </rim:Value>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$input/ValueList">
                  <xsl:for-each select="$input/ValueList/Value">
                     <rim:Value>
                        <xsl:value-of select="text()"/>
                     </rim:Value>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <rim:Value>
                     <xsl:value-of select="$input/text()"/>
                  </rim:Value>
               </xsl:otherwise>
            </xsl:choose>
         </rim:ValueList>
      </rim:Slot>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-codingScheme">
      <xsl:param name="value"/>
      <!-- This type of rim:Slot is issued so often that it deserves an express template -->
      <rim:Slot name="codingScheme">
         <rim:ValueList>
            <rim:Value>
               <xsl:value-of select="$value"/>
            </rim:Value>
         </rim:ValueList>
      </rim:Slot>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-format">
      <xsl:param name="name"/>
      <xsl:param name="value"/>
      <xsl:param name="useParens" select="0"/>
      <xsl:param name="useApos" select="0"/>
      <!-- Emit one rim:Slot with one Value. Caller must format name correctly, but
           does not have to verify that $value has content. No content, no Slot. -->
      <xsl:if test="$value!=''">
         <rim:Slot name="{$name}">
            <rim:ValueList>
               <xsl:call-template name="utEI-rimValue-format">
                  <xsl:with-param name="value" select="$value"/>
                  <xsl:with-param name="useParens" select="$useParens"/>
                  <xsl:with-param name="useApos" select="$useApos"/>
               </xsl:call-template>
            </rim:ValueList>
         </rim:Slot>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-fromField">
      <xsl:param name="input"/>
      <!-- Emit one rim:Slot with one or more values. The name is taken from the name of
           the input/param node, but with the first letter mapped to lower-case.
           For efficiency, do NOT use this template unless the name can fit that pattern.
           The context node can have some Value children or just a text node.
      -->
      <xsl:if test="$input">
         <xsl:variable name="adjustedName" select="concat(translate(substring(local-name($input),1,1),$uppercase,$lowercase),substring(local-name($input),2))"/>
         <rim:Slot name="{$adjustedName}">
            <rim:ValueList>
               <xsl:choose>
                  <xsl:when test="$input/Value">
                     <xsl:for-each select="$input/Value">
                        <rim:Value>
                           <xsl:value-of select="text()"/>
                        </rim:Value>
                     </xsl:for-each>
                  </xsl:when>
                  <!-- If a ValueList/Value could occur, add a when clause for it here -->
                  <xsl:otherwise>
                     <rim:Value>
                        <xsl:value-of select="$input/text()"/>
                     </rim:Value>
                  </xsl:otherwise>
               </xsl:choose>
            </rim:ValueList>
         </rim:Slot>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-fromGenericSlot">
      <!-- The context node is assumed to be an element named Slot (though we don't check
           the element name), target name in @name, and a ValueList/Value structure. -->
      <rim:Slot>
         <xsl:copy-of select="@name"/>
         <rim:ValueList>
            <xsl:for-each select="ValueList/Value">
               <rim:Value>
                  <xsl:value-of select="text()"/>
               </rim:Value>
            </xsl:for-each>
         </rim:ValueList>
      </rim:Slot>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-merge">
      <xsl:param name="input"/><!-- must be a node-set, not just a string -->
      <!-- Emit one rim:Slot with one or more values. The name is taken from the name
           of the input node, but with the first letter mapped to lower-case.
           Find all source elements of the specified name, if any, and merge all their
           respective Value entries into one list.
      -->
      <xsl:if test="$input/Value">
         <xsl:variable name="adjustedName"
            select="concat(translate(substring(local-name($input), 1, 1), $uppercase, $lowercase), substring(local-name($input), 2))"/>
         <rim:Slot name="{$adjustedName}">
            <rim:ValueList>
               <xsl:for-each select="$input/Value">
                  <rim:Value>
                     <xsl:value-of select="text()"/>
                  </rim:Value>
               </xsl:for-each>
            </rim:ValueList>
         </rim:Slot>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimSlot-params">
      <xsl:param name="name"/>
      <xsl:param name="value"/>
      <!-- Emit one rim:Slot with one Value. Caller must format name correctly, but
           does not have to verify that $value has content. No content, no Slot. -->
      <xsl:if test="$value!=''">
         <rim:Slot name="{$name}">
            <rim:ValueList>
               <rim:Value>
                  <xsl:value-of select="$value"/>
               </rim:Value>
            </rim:ValueList>
         </rim:Slot>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utEI-rimValue-format">
      <xsl:param name="value"/>
      <xsl:param name="useParens" select="0"/>
      <xsl:param name="useApos" select="0"/>
      <!-- Emit one formatted rim:Value, as used within rim:Slot. -->
      <rim:Value>
         <xsl:choose>
            <xsl:when test="$useParens = 0">
               <xsl:choose>
                  <xsl:when test="$useApos = 0">
                     <xsl:value-of select="$value"/>
                  </xsl:when>
                  <xsl:when test="$useApos = 2">
                     <xsl:choose>
                        <!-- ToDoXSLT2: improve this test. The one here is reliable for XSLT 1.0, but awkward. -->
                        <xsl:when test="starts-with(number($value),'NaN')">
                           <xsl:value-of select='concat("&apos;", $value, "&apos;")'/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$value"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select='concat("&apos;", $value, "&apos;")'/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$useApos = 0">
                     <xsl:value-of select="concat('(', $value, ')')"/>
                  </xsl:when>
                  <xsl:when test="$useApos = 2">
                     <!-- Use apostrophes on non-numeric values only -->
                     <xsl:choose>
                        <xsl:when test="starts-with(number($value),'NaN')">
                           <xsl:value-of select='concat("(&apos;", $value, "&apos;)")'/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="concat('(', $value, ')')"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select='concat("(&apos;", $value, "&apos;)")'/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </rim:Value>
   </xsl:template>
   
   <xsl:template name="utEI-rsRegistryErrorList">
      <xsl:param name="highestSev" select="'FromInput'"/><!-- Keyword: FromInput, Error, Warning -->
      <xsl:param name="parentNodes"/><!-- node-set that has Error children -->
      <xsl:param name="setNullLocation" select="0"/><!-- If 1, force @location to null string -->
      <xsl:param name="moreErrors" select="0"/><!-- If 1, call back for more errors on ErrorList -->
      <!-- Produce an rs:RegistryErrorList element and the constituent rs:RegistryError sub-elements -->
      <!-- NOTE: If your stylesheet calls this template and uses the moreErrors=1 option,
           it must bring in this file via xsl:import rather than xsl:include, so that the
           moreRegistryError template in your stylesheet will be preferred over the one here. -->
      
      <rs:RegistryErrorList>
         <xsl:choose>
            <xsl:when test="$highestSev = 'FromInput'">
               <!-- If triggerErrorList=1 on the surrounding call, there may not actually be any errors.
                    The highestSeverity attribute is optional, but must be error/warning if set. -->
               <xsl:if test="string-length($parentNodes/HighestError) &gt; 0">
                  <xsl:attribute name="highestSeverity">
                     <xsl:value-of select="concat($errorSevPrefix, $parentNodes/HighestError/text())"/>
                  </xsl:attribute>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="highestSeverity">
                  <xsl:value-of select="concat($errorSevPrefix, $highestSev)"/>
               </xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select="$parentNodes/Error">
            <rs:RegistryError>
               <xsl:attribute name="errorCode">
                  <xsl:value-of select="Code/text()"/>
               </xsl:attribute>
               <xsl:attribute name="codeContext">
                  <xsl:value-of select="Description/text()"/>
               </xsl:attribute>
               <xsl:choose>
                  <xsl:when test="$setNullLocation = 1">
                     <xsl:attribute name="location"/>
                  </xsl:when>
                  <xsl:when test="Location/text() != ''">
                     <xsl:attribute name="location">
                        <xsl:value-of select="Location"/>
                     </xsl:attribute>
                  </xsl:when>
               </xsl:choose>
               <xsl:attribute name="severity">
                  <xsl:value-of select="concat($errorSevPrefix, Severity/text())"/>
               </xsl:attribute>
            </rs:RegistryError>
         </xsl:for-each>
         <xsl:if test="$moreErrors = 1">
            <!-- Calling stylesheet must provide template to add more -->
            <xsl:call-template name="moreRegistryError"/>
         </xsl:if>
      </rs:RegistryErrorList>
   </xsl:template>
   
   <xsl:template name="utEI-rsRegistryResponse">
      <xsl:param name="setStatus"/><!-- Keyword: Success, Failure, PartialSuccess -->
      <xsl:param name="triggerErrorList" select="0"/><!-- If not 0, emit ErrorList regardless of $setStatus -->
      <xsl:param name="highestSev" select="'FromInput'"/><!-- Keyword: NoList, FromInput, Error, Warning (also pass-through) -->
      <xsl:param name="parentNodes"/><!-- node-set that has Error children (pass-through) -->
      <xsl:param name="setNullLocation" select="0"/><!-- If 1, force @location to null string (pass-through) -->
      <xsl:param name="moreErrors" select="0"/><!-- If 1, call back for more errors on ErrorList (pass-through) -->
      <!-- Produce an rs:RegistryResponse element and its content -->
      
      <rs:RegistryResponse>
         <xsl:attribute name="status">
            <xsl:choose>
               <xsl:when test="$setStatus='Failure'">
                  <xsl:value-of select="$failureURN"/>
               </xsl:when>
               <xsl:when test="$setStatus='Success'">
                  <xsl:value-of select="$successURN"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$partialURN"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:if test="($setStatus != 'Success' or $triggerErrorList = 1) and not($highestSev = 'NoList')">
            <xsl:call-template name="utEI-rsRegistryErrorList">
               <xsl:with-param name="parentNodes" select="$parentNodes"/>
               <xsl:with-param name="highestSev" select="$highestSev"/>
               <xsl:with-param name="setNullLocation" select="$setNullLocation"/>
               <xsl:with-param name="moreErrors" select="$moreErrors"/>
            </xsl:call-template>
         </xsl:if>
      </rs:RegistryResponse>
   </xsl:template>
   
   <xsl:template name="utEI-S-variableID">
      <!-- Format an @id for use in xdsb:Document/@id, rim:ExternalIdentifier/@registryObject,
           rim:ExtrinsicObject/@id, rim:ExtrinsicObject/@lid, rim:RegistryPackage/@id,
           rim:Association/@sourceObject, rim:Association/@targetObject,
           rim:Classification/@classifiedObject, and similar usage.-->
      <!-- ToDoXSLT2: make this into a stylesheet function -->
      <xsl:param name="value"/>
      <xsl:choose>
         <xsl:when test="string-length($value) = 36">
            <xsl:value-of select="concat('urn:uuid:', $value)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$value"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!--******************** How-to documents ********************-->
   <!-- How to produce a rim:Classification
      When the rim:Classification element will be used to hold author information, use
      utEI-rimClassification-author at a point where the context node is an Author element
      having child elements AuthorPerson, AuthorRole, and so on. Set the schemeKey param
      to 'Document' or 'Submission' as needed, and set the classifiedObj param to be the
      @id of the structure that contains Author (e.g., the Document).
        
      For a rim:Classification element pertaining to a Folder, use utEI-rimClassification-Folder.
      For a rim:Classification element pertaining to a Submission Set, use
      utEI-rimClassification-SubmissionSet.
   
      For other rim:Classification elements, there are three templates available, based on
      the structure of the source. The quickest way to decide which to use is to see where
      the source has the name and coding scheme. Use one of utEI-rimClassification-Meta-*
      when the source has those values in Name and CodingScheme, respectively. Further details
      are in the next paragraph. Use utEI-rimClassification-ProvideAndRegister when the source
      has the name in an element called Description and the coding scheme in Scheme. For all
      three templates, set the sourceElement param to the node having child elements Code,
      Name/Description, etc.; the name of that parent node (e.g., ContentTypeCode) will be used
      to locate the URN for the Classification Scheme in two of them.
   
      If the source has the MetadataObject format and has an element name that is one of the
      recognized Classification Schemes, use utEI-rimClassification-Meta-map. Otherwise, use the
      template utEI-rimClassification-Meta-generic, where the ClassificationScheme element is
      used as the source of the Classification Scheme (and is not verified to have any
      particular format).
        
      For all 6 of these templates, set the classifiedObj param to be the @id of the structure
      to which the classification pertains.
   -->
   
   <!-- How to produce a rim:Description
      To use the utEI-rimDescription named template, you set the value param to the node (either
      element or attribute) whose string content is the description string. Your choice for the
      augmentation param tells the template how to locate the language/charset data relative to
      the value node. If augmentation is set to 'NONE', then the value param can be a simple
      string. The name of the outer containing element has no effect on the template, and you do
      not need to change the context node.
        
      Example: if the source has this format...
   <Description Charset="UTF-8" Lang="FR-ca">This is the description text.</Description>
      ...set value to "Description" (or whatever XPath is necessary to select the Description
      element whose text content is the value) and set augmentation to "'MetadataObject'" to
      have the attributes converted correctly.
        
      Note that the template is capable of producing an empty element, <rim:Description/>. The
      caller is responsible for deciding whether to invoke the template if no Description element
      is wanted when the value is null.
   -->
   
   <!-- How to produce a rim:ExternalIdentifier
      If the identifier is for the uniqueId, patientId, or SourceId of a Document, Submission Set,
      or Folder, use utEI-rimExternalIdentifier-map according to the instructions in the next
      paragraph. For other uses, try to use utEI-rimExternalIdentifier. There are two scenarios,
      designed for two sources that have been used up to 2016: 'MetadataObject' and 'RegistryObject'.
      The set of subsidiary data items varies by scenario, though value and registryObject must
      always be supplied as params. In the 'RegistryObject' scenario, a version param is expected, too.
        
      For utEI-rimExternalIdentifier-map, you just set the itemType param to one of the words Document,
      Submission, or Folder; set the value param to the element containing the value; supply the
      registryObject; and select how the @id will be determined. You can provide a version and/or @lid
      if you wish. By specifying value as an element, the element name can be used to determine the
      identificationScheme and other details.
   -->
   
   <!-- How to produce a rim:Name
      Use the utEI-rimName named template whenever possible. Set the value param to the node (either
      element or attribute) whose string content is the name. Your choice for the augmentation param
      tells the template how to locate the language/charset data relative to the value node. If
      augmentation is set to 'NONE', then the value param can be a simple string. The name of the outer
      containing element has no effect on the template, and you do not need to change the context node.
        
      The caller is responsible for deciding whether to invoke the template if no rim:Name element is
      wanted when the value is null.
   -->
   
   <!-- How to produce a rim:ObjectRef
      The rim:ObjectRef only needs an id attribute, no text content, but that @id could come from
      varying sources. Also, The @id should have a URN prefix. With mode="utEI-rimObjectRef", we
      assume that the @id of the source is already properly formatted.
      
      Use name="utEI-copyObjectRefs" to replicate a collection of 1 or more ObjectRef elements, each
      having the @id attribute already properly formatted. This can be used to populate a
      rim:RegistryObjectList. The utEI-copyObjectRefs-QueryResponse variant is to be used when the id
      is in the source as text content instead of @id.
   -->
   
   <!-- How to produce a rs:RegistryErrorList
      The utEI-rsRegistryErrorList template will populate an error list with an rs:RegistryError element
      for each Error element found as a child of an element from the parentNodes param. In addition, if
      the moreErrors param is set to 1, and if the calling stylesheet has a template named
      moreRegistryError, that template can be used to add more rs:RegistryError elements to the same list.
        
      The optional highestSev param may be set to one of the keywords 'FromInput', 'Error', or 'Warning'.
      'Error' and 'Warning' are literal, directly setting the value. 'FromInput' signals that the
      element from the parentNodes param has the value in its HighestError sub-element. As a general
      rule, when moreErrors is 1, the caller must check the severities of the additional errors, which
      precludes the use of 'FromInput'.
        
      Three attributes are set on every rs:RegistryError element, and the location attribute will be set
      if there is data in the source, unless the optional setNullLocation param is 1, in which case the
      location attribute will be forced to be present but null.
   -->
   
   <!-- How to produce individual rim:Slot elements
      There are several utility templates that emit one rim:Slot element and save a lot of detail work.
      Nevertheless, there are specialized situations where a hardwired custom slot must be written.
      
      Use utEI-rimSlot-params for a basic name-value pair. The context node does not matter.
      
      Use utEI-rimSlot-codingScheme when the name of the Slot is codingScheme.
      
      Use utEI-rimSlot-choose when the value may be found in one of several places on the source side.
      The context node may be Slot, Slot/ValueList, any element having a Value child, or just an element
      having the value in a text-node child.
      
      Use utEI-rimSlot-fromField like utEI-rimSlot-choose when there is the additional complication that
      the source is an element whose name starts with a upper-case letter and the name attribute of the
      resulting rim:Slot needs to start with the corresponding lower-case letter.
      
      Use utEI-rimSlot-merge when there are several elements of the same name and their contents should be
      merged. Initial-letter mapping is performed as with utEI-rimSlot-fromField. For example, if the input
      param is a node-set of IntendedRecipient nodes, the result is one rim:Slot with name="intendedRecipient"
      and one rim:ValueList containing a rim:Value for every ValueList/Value in every member of the node-set.
      
      Use utEI-rimSlot-format when the text content of rim:Value needs to be enclosed in parentheses and/or
      apostrophes. The name and value are both set as params, as with utEI-rimSlot-params. The
      utEI-rimValue-format template is also available when a formatted rim:Value is needed in a more
      extensive rim:ValueList.
   -->
   
   <!-- How to copy several Slots into rim:Slots
      Slot elements in the source document are expected to have structure parallel to rim:Slot, with two
      significant differences. Once you determine which structure your source has, you can pick the correct
      template for copying and transforming multiple Slots. Within the Slot element, there is one ValueList,
      which in turn has one or more child elements. The name used for the grandchildren of Slot is one
      indicator of format; the other is whether the name of the slot is in a name attribute or a Name child
      element. The target, rim:Slot, has rim:Value grandchildren and a name attribute.
      
      If your source has Value grandchildren and a name attribute, use utEI-allSlot-choose. This template can
      also handle the case where the value is just text content directly in the Slot element.
      
      If your source has ValueListItem grandchildren and a Name child, use utEI-allSlot-DocumentRegistry.
      
      If your source has SlotValue grandchildren and a name attribute, use utEI-allSlotValue. This template
      only copies Slot elements where the name starts with 'urn:', leaving that prefix intact.
   -->
   
   <!-- How to produce an xdsb:RetrieveDocumentSetResponse
      Follow the pattern below. Emit the outer xdsb:RetrieveDocumentSetResponse element as a literal result
      element. Use the utEI-rsRegistryResponse template to produce the rs:RegistryResponse element, then use
      specific code to produce zero or more xdsb:DocumentResponse elements.
      
      Prototype for invocation:
   <xsl:template match="*" mode="xdsbRetrieveResponse">
      <xdsb:RetrieveDocumentSetResponse>
         <xsl:call-template name="utEI-rsRegistryResponse">
            <xsl:with-param name="setStatus" select="'Failure'"/>
            <xsl:with-param name="parentNodes" select="Errors"/>
         </xsl:call-template>
         <xsl:for-each select="something">
            <xdsb:DocumentResponse>
               <!-/- content -/->
            </xdsb:DocumentResponse>
         </xsl:for-each>
      </xdsb:RetrieveDocumentSetResponse>
   </xsl:template>
      
      When calling utEI-rsRegistryResponse, you must set at least the parentNodes and setStatus params. Set
      parentNodes to be a node-set that contains all the parent nodes of all the Error elements to be processed;
      for all in the whole document, set it to /descendant-or-self::* (root and all elements). Use the moreErrors
      param and a moreRegistryError named template to add more rs:RegistryError entries to the ErrorList.
      
      Set the setStatus param to one these keywords: 'Success', 'Failure', 'PartialSuccess'.
      
      If the other params are allowed to default,
      (1) @highestSeverity will be copied from $parentNodes/HighestError,
      (2) $setStatus='Success' bars emitting the ErrorList,
      (3) rs:RegistryError/@location will not be emitted if there is no text,
      but note that there is interaction between (1) and (2).
      
      The optional highestSev param may be used in 3 ways. By specifying 'Error' or 'Warning' literally, the caller
      is asserting the highest severity, presumably having already determined it. One of those options should be
      used when the moreErrors param is 1. The 'FromInput' keyword directs the template to make the determination
      from the HighestError element that is a child of $parentNodes, which should be a single node for this scenario
      to work. The 'NoList' keyword directs utEI-rsRegistryResponse to NOT call utEI-rsRegistryErrorList, suppressing
      the ErrorList. On the opposite side, the triggerErrorList param can be used to cause creation of an ErrorList
      even when setStatus is 'Success'.
   -->
   
</xsl:stylesheet>