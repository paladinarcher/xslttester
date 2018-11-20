<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:isc="http://extension-functions.intersystems.com"
   xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"
   xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
   exclude-result-prefixes="exsl isc rim rs">
   <!-- The prefix for template/mode names in this file is "utII" -->
   
<!--***** Includes *****
   <xsl:include href="Variables.xsl"/>
   <xsl:include href="UtilityMapURN.xsl"/>
   <xsl:include href="UtilityRoutines.xsl"/>-->
   
<!-- ***** key ***** -->
   <!-- The following two should be done by the caller when the respective utII-*-keyed templates are used:
   <xsl:key name="ExternalIdentifierByScheme"
      match="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryPackage/rim:ExternalIdentifier" use="@identificationScheme"/>
   <xsl:key name="SlotByName" match="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryPackage/rim:Slot" use="@name"/>
   WHERE xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0"
   The ones below are intended to placate XSLT processors that need to have the key declared at compile time -->
   <xsl:key name="ExternalIdentifierByScheme" match="/NO_SUCH_PATH/rim:ExternalIdentifier" use="@identificationScheme"/>
   <xsl:key name="SlotByName" match="/NO_SUCH_PATH/rim:Slot" use="@name"/>
   
   <xsl:template match="rs:RegistryError" mode="utII-Error">
      <Error>
         <Code>
            <xsl:value-of select="@errorCode"/>
         </Code>
         <Severity>
            <xsl:value-of select="substring-after(@severity,$errorSevPrefix)"/>
         </Severity>
         <Description>
            <xsl:value-of select="@codeContext"/>
         </Description>
         <Location>
            <xsl:value-of select="@location"/>
         </Location>
      </Error>
   </xsl:template>
   
   <xsl:template match="rim:Slot" mode="utII-Slot-MetadataObject">
      <Slot name="{@name}">
         <ValueList>
            <xsl:for-each select="rim:ValueList/rim:Value">
               <Value>
                  <xsl:value-of select="text()"/>
               </Value>
            </xsl:for-each>
         </ValueList>
      </Slot>
   </xsl:template>
   
   <!--******************** Named templates ********************-->
   <xsl:template name="utII-Author">
      <xsl:param name="includeID" select="0"/><!-- If 1, copy @id -->
      <!-- Produce an Author element with optional @id and data in sub-elements.
           When called, the context node should be rim:Classification, where the
           @classificationScheme is either $documentAuthorScheme or $submissionAuthorScheme,
           and containing rim:Slots that pertain to authors. -->
      <Author>
         <xsl:if test="$includeID = 1">
            <xsl:copy-of select="@id"/>
         </xsl:if>
         <xsl:call-template name="utII-pName-elementFromSlot">
            <xsl:with-param name="slotName" select="'authorPerson'"/>
         </xsl:call-template>
         <xsl:call-template name="utII-pName-elementFromSlot-multiValue">
            <xsl:with-param name="slotName" select="'authorInstitution'"/>
         </xsl:call-template>
         <xsl:call-template name="utII-pName-elementFromSlot-multiValue">
            <xsl:with-param name="slotName" select="'authorRole'"/>
         </xsl:call-template>
         <xsl:call-template name="utII-pName-elementFromSlot-multiValue">
            <xsl:with-param name="slotName" select="'authorSpecialty'"/>
         </xsl:call-template>
         <xsl:call-template name="utII-pName-elementFromSlot-multiValue">
            <xsl:with-param name="slotName" select="'authorTelecommunication'"/>
         </xsl:call-template>
         <!-- AuthorTelecommunication added for Direct XDR Support -->
      </Author>
   </xsl:template>
   
   <xsl:template name="utII-C-Clinician">
      <xsl:param name="facility"/>
      <!-- Create Clinician and related content. When called, the context node
           should be a rim:ExtrinsicObject having an authorPerson rim:Slot. -->
      <!-- Use authorPerson (first one) for EnteredBy and Clinician -->
      <!-- From the ITI TF 3: 4.1.7  Document Definition Metadata, XCN data type  -->
      <!-- NOTE: Either ID+AA or Name is required XCN -->
      <xsl:variable name="authorSlot"
         select="rim:Classification[@classificationScheme=$documentAuthorScheme]/rim:Slot[@name='authorPerson']/rim:ValueList/rim:Value/text()"/>
      <xsl:if test="$authorSlot">
         <!-- ToDoXSLT2: use tokenizing tools -->
         <xsl:variable name="authorid" select="substring-before($authorSlot, '^')"/>
         <xsl:variable name="authorRTF">
            <a>
               <xsl:call-template name="utR-directSplit">
                  <xsl:with-param name="string" select="$authorSlot"/>
                  <xsl:with-param name="delim" select="'^'"/>
                  <xsl:with-param name="emitElementName" select="'pc'"/>
               </xsl:call-template>
            </a>
         </xsl:variable>
         <xsl:variable name="author" select="exsl:node-set($authorRTF)"/>
         <xsl:variable name="authorlast" select="$author/a/pc[2]"/>
         <xsl:variable name="authorfamily">
            <xsl:choose>
               <xsl:when test="contains($authorlast,'&amp;')">
                  <xsl:value-of select="substring-before($authorlast,'&amp;')"/>
               </xsl:when>
               <xsl:otherwise><xsl:value-of select="$authorlast"/></xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="authorfamilyprefix" select="substring-after($authorlast,'&amp;')"/>
         <!-- Ready to start emitting elements; now choose one of two structures -->
         <xsl:choose>
            <xsl:when test="$authorid">
               <xsl:variable name="authorauthority" select="$author/a/pc[9]"/>
               <EnteredBy>
                  <Code><xsl:value-of select="$authorid"/></Code>
                  <xsl:if test="$authorauthority">
                     <SDACodingStandard><xsl:value-of select="$authorauthority"/></SDACodingStandard>
                  </xsl:if>
               </EnteredBy>
               <xsl:if test="$facility">
                  <EnteredAt>
                     <Code><xsl:value-of select="$facility"/></Code>
                     <Description><xsl:value-of select="$facility"/></Description>
                  </EnteredAt>
               </xsl:if>
               <Clinician>
                  <Code><xsl:value-of select="$authorid"/></Code>
                  <xsl:if test="$authorauthority">
                     <SDACodingStandard><xsl:value-of select="$authorauthority"/></SDACodingStandard>
                  </xsl:if>
                  <xsl:if test="$authorfamily">
                     <xsl:variable name="authorfirst" select="$author/a/pc[3]/text()"/>
                     <xsl:variable name="authormiddle" select="$author/a/pc[4]/text()"/>
                     <xsl:variable name="authorsuffix" select="$author/a/pc[5]/text()"/>
                     <xsl:variable name="authorprefix" select="$author/a/pc[6]/text()"/>
                     <xsl:variable name="authordegree" select="$author/a/pc[7]/text()"/>
                     <Name>
                        <FamilyName>
                           <xsl:value-of select="$authorfamily"/>
                        </FamilyName>
                        <xsl:if test="$authorfamilyprefix">
                           <FamilyNamePrefix>
                              <xsl:value-of select="$authorfamilyprefix"/>
                           </FamilyNamePrefix>
                        </xsl:if>
                        <xsl:if test="string-length($authorprefix) > 0">
                           <NamePrefix>
                              <xsl:value-of select="$authorprefix"/>
                           </NamePrefix>
                        </xsl:if>
                        <xsl:if test="string-length($authorsuffix) > 0">
                           <NameSuffix>
                              <xsl:value-of select="$authorsuffix"/>
                           </NameSuffix>
                        </xsl:if>
                        <xsl:if test="string-length($authorfirst) > 0">
                           <GivenName>
                              <xsl:value-of select="$authorfirst"/>
                           </GivenName>
                        </xsl:if>
                        <xsl:if test="string-length($authormiddle) > 0">
                           <MiddleName>
                              <xsl:value-of select="$authormiddle"/>
                           </MiddleName>
                        </xsl:if>
                        <xsl:if test="string-length($authordegree) > 0">
                           <ProfessionalSuffix>
                              <xsl:value-of select="$authordegree"/>
                           </ProfessionalSuffix>
                        </xsl:if>
                     </Name>
                  </xsl:if>
               </Clinician>
            </xsl:when>
            <xsl:otherwise>
               <!-- Did not obtain an ID, just pack in what we have -->
               <xsl:variable name="authorfirst" select="$author/a/pc[3]/text()"/>
               <xsl:variable name="authormiddle" select="$author/a/pc[4]/text()"/>
               <xsl:variable name="authorsuffix" select="$author/a/pc[5]/text()"/>
               <xsl:variable name="authorprefix" select="$author/a/pc[6]/text()"/>
               <xsl:variable name="authordegree" select="$author/a/pc[7]/text()"/>
               <EnteredBy>
                  <Code>
                     <xsl:value-of select="concat($authorprefix, $authorfirst, $authormiddle, $authorfamilyprefix, $authorfamily, $authorsuffix, $authordegree)"/>
                  </Code>
               </EnteredBy>
               <xsl:if test="$facility">
                  <EnteredAt>
                     <Code><xsl:value-of select="$facility"/></Code>
                     <Description><xsl:value-of select="$facility"/></Description>
                  </EnteredAt>
               </xsl:if>
               <Clinician>
                  <Code>
                     <xsl:value-of select="concat($authorprefix, $authorfirst, $authormiddle, $authorfamilyprefix, $authorfamily, $authorsuffix, $authordegree)"/>
                  </Code>
                  <xsl:if test="$authorfamily">
                     <Name>
                        <FamilyName>
                           <xsl:value-of select="$authorfamily"/>
                        </FamilyName>
                        <xsl:if test="$authorfamilyprefix">
                           <FamilyNamePrefix>
                              <xsl:value-of select="$authorfamilyprefix"/>
                           </FamilyNamePrefix>
                        </xsl:if>
                        <xsl:if test="$authorprefix">
                           <NamePrefix>
                              <xsl:value-of select="$authorprefix"/>
                           </NamePrefix>
                        </xsl:if>
                        <xsl:if test="$authorsuffix">
                           <NameSuffix>
                              <xsl:value-of select="$authorsuffix"/>
                           </NameSuffix>
                        </xsl:if>
                        <xsl:if test="$authorfirst">
                           <GivenName>
                              <xsl:value-of select="$authorfirst"/>
                           </GivenName>
                        </xsl:if>
                        <xsl:if test="$authormiddle">
                           <MiddleName>
                              <xsl:value-of select="$authormiddle"/>
                           </MiddleName>
                        </xsl:if>
                        <xsl:if test="$authordegree">
                           <ProfessionalSuffix>
                              <xsl:value-of select="$authordegree"/>
                           </ProfessionalSuffix>
                        </xsl:if>
                     </Name>
                  </xsl:if>
               </Clinician>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="utII-C-patientDemographics">
      <!-- Emit basic demographics as part of the content of a Patient element.
           Source is the first document (rim:ExtrinsicObject).
           Call this just after emitting the PatientNumbers element within Patient -->
      <xsl:for-each select="rim:ExtrinsicObject[1]/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value">
         <xsl:variable name="itm" select="substring-before(text(),'|')"/>
         <xsl:variable name="val" select="substring-after(text(),'|')"/>
         <xsl:choose>
            <xsl:when test="$itm = 'PID-5'">
               <xsl:variable name="splitRTF">
                  <x>
                     <xsl:call-template name="utR-directSplit">
                        <xsl:with-param name="string" select="$val"/>
                        <xsl:with-param name="delim" select="'^'"/>
                        <xsl:with-param name="emitElementName" select="'piece'"/>
                     </xsl:call-template>
                  </x>
               </xsl:variable>
               <xsl:variable name="split" select="exsl:node-set($splitRTF)"/>
               <Name>
                  <xsl:variable name="lastname" select="$split/x/piece[1]"/>
                  <xsl:variable name="family">
                     <xsl:choose>
                        <xsl:when test="contains($lastname,'&amp;')">
                           <xsl:value-of select="substring-before($lastname,'&amp;')"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="$lastname"/></xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="familyprefix" select="substring-after($lastname,'&amp;')"/>
                  <xsl:variable name="given" select="$split/x/piece[2]"/>
                  <xsl:variable name="middle" select="$split/x/piece[3]"/>
                  <xsl:variable name="suffix" select="$split/x/piece[4]"/>
                  <xsl:variable name="preferred" select="$split/x/piece[5]"/>
                  <xsl:if test="$family">
                     <FamilyName>
                        <xsl:value-of select="$family"/>
                     </FamilyName>
                  </xsl:if>
                  <xsl:if test="$familyprefix">
                     <FamilyNamePrefix>
                        <xsl:value-of select="$familyprefix"/>
                     </FamilyNamePrefix>
                  </xsl:if>
                  <xsl:if test="$given">
                     <GivenName>
                        <xsl:value-of select="$given"/>
                     </GivenName>
                  </xsl:if>
                  <xsl:if test="$middle">
                     <MiddleName>
                        <xsl:value-of select="$middle"/>
                     </MiddleName>
                  </xsl:if>
                  <xsl:if test="$suffix">
                     <ProfessionalSuffix>
                        <xsl:value-of select="$suffix"/>
                     </ProfessionalSuffix>
                  </xsl:if>
                  <xsl:if test="$preferred">
                     <PreferredName>
                        <xsl:value-of select="$preferred"/>
                     </PreferredName>
                  </xsl:if>
               </Name>
            </xsl:when>
            <xsl:when test="$itm = 'PID-7'">
               <BirthTime>
                  <xsl:call-template name="utR-S-timestamp">
                     <xsl:with-param name="inputString" select="$val"/>
                  </xsl:call-template>
               </BirthTime>
            </xsl:when>
            <xsl:when test="$itm = 'PID-8'">
               <Gender>
                  <Code>
                     <xsl:value-of select="$val"/>
                  </Code>
               </Gender>
            </xsl:when>
            <xsl:when test="$itm = 'PID-11'">
               <xsl:variable name="addrRTF">
                  <a>
                     <xsl:call-template name="utR-directSplit">
                        <xsl:with-param name="string" select="$val"/>
                        <xsl:with-param name="delim" select="'^'"/>
                        <xsl:with-param name="emitElementName" select="'piece'"/>
                     </xsl:call-template>
                  </a>
               </xsl:variable>
               <xsl:variable name="addr" select="exsl:node-set($addrRTF)"/>
               <Addresses>
                  <Address>
                     <xsl:variable name="street" select="$addr/a/piece[1]"/>
                     <xsl:variable name="city" select="$addr/a/piece[3]"/>
                     <xsl:variable name="state" select="$addr/a/piece[4]"/>
                     <xsl:variable name="zip" select="$addr/a/piece[5]"/>
                     <xsl:variable name="country" select="$addr/a/piece[6]"/>
                     <xsl:if test="$street">
                        <Street>
                           <xsl:value-of select="concat($street,';',$addr/a/piece[2])"/>
                        </Street>
                     </xsl:if>
                     <xsl:if test="$city">
                        <City>
                           <Code>
                              <xsl:value-of select="$city"/>
                           </Code>
                        </City>
                     </xsl:if>
                     <xsl:if test="$state">
                        <State>
                           <Code>
                              <xsl:value-of select="$state"/>
                           </Code>
                        </State>
                     </xsl:if>
                     <xsl:if test="$zip">
                        <Zip>
                           <Code>
                              <xsl:value-of select="$zip"/>
                           </Code>
                        </Zip>
                     </xsl:if>
                     <xsl:if test="$country">
                        <Country>
                           <Code>
                              <xsl:value-of select="$country"/>
                           </Code>
                        </Country>
                     </xsl:if>
                  </Address>
               </Addresses>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utII-Classification-Document">
      <!-- Emit a Classification in Document Registry format.
           The caller is responsible for setting up iteration over a
           set of rim:Classification elements, such that one of them
           is the context node when this is called. -->
      <Classification id="{@id}">
         <ClassifiedObject>
            <xsl:value-of select="@classifiedObject"/>
         </ClassifiedObject>
         <ClassificationScheme>
            <xsl:value-of select="@classificationScheme"/>
         </ClassificationScheme>
         <NodeRepresentation>
            <xsl:value-of select="@nodeRepresentation"/>
         </NodeRepresentation>
         <ClassificationNode>
            <xsl:value-of select="@classificationNode"/>
         </ClassificationNode>
         <xsl:call-template name="utII-replicateAllSlots">
            <xsl:with-param name="namePlacement" select="'ELEMENT'"/>
            <xsl:with-param name="innerElementName" select="'ValueListItem'"/>
         </xsl:call-template>
         <xsl:call-template name="utII-Title-Document"/>
         <xsl:call-template name="utII-Comments-Document"/>
      </Classification>
   </xsl:template>
   
   <xsl:template name="utII-Classification-MetadataObject">
      <!-- Emit a Classification in MetadataObject format.
           The caller is responsible for setting up iteration over a
           set of rim:Classification elements, such that one of them
           is the context node when this is called. -->
      <Classification id="{@id}">
         <Code>
            <xsl:value-of select="@nodeRepresentation"/>
         </Code>
         <xsl:if test="count(rim:Slot[@name='codingScheme'])=1">
            <!-- ToDo: find out if we should remove predicate or provide
                 alternative for case where there is exactly one rim:Slot
                 and we know it's the codingScheme -->
            <xsl:call-template name="utII-pName-elementFromSlot">
               <xsl:with-param name="slotName" select="'codingScheme'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:if test="string-length(@classificationScheme) > 0">
            <ClassificationScheme>
               <xsl:value-of select="@classificationScheme"/>
            </ClassificationScheme>
         </xsl:if>
         <xsl:for-each select="rim:Name">
            <xsl:call-template name="utII-Name-Meta"/>
         </xsl:for-each>
         <xsl:for-each select="rim:Description">
            <xsl:call-template name="utII-pName-fromDescription">
               <xsl:with-param name="emitElementName" select="'Description'"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:apply-templates select="rim:Slot[@name !='codingScheme']" mode="utII-Slot-MetadataObject"/>
      </Classification>
   </xsl:template>
   
   <xsl:template name="utII-Comments-Document">
      <!-- Convert rim:Description into Comments having Document structure
           (aka ProvideAndRegister), with sub-elements for everything.
           When this is called, the context node should be the element that
           contains one or more rim:Description elements.
           To obtain a Comments element with the value in a direct child text node,
           use utII-pName-fromDescription instead. -->
      <Comments>
         <ValueText>
            <xsl:value-of select="rim:Description/rim:LocalizedString/@value"/>
         </ValueText>
         <Charset>
            <xsl:value-of select="rim:Description/rim:LocalizedString/@charset"/>
         </Charset>
         <Lang>
            <xsl:value-of select="rim:Description/rim:LocalizedString/@xml:lang"/>
         </Lang>
      </Comments>
   </xsl:template>
   
   <xsl:template name="utII-DocumentName-pickBest">
      <!-- Populate a DocumentName element.
           Use title or typeCode or classCode or "Community Document" (fine to coarse granularity) -->
      <!-- Enhancement Note: if utII-pName-fromName is altered to add Lang/CharSet attributes,
           this template should be, too. -->
      <DocumentName>
         <xsl:choose>
            <xsl:when test="rim:Name/rim:LocalizedString/@value">
               <xsl:value-of select="rim:Name/rim:LocalizedString/@value"/>
            </xsl:when>
            <!-- Next, try the TypeCode -->
            <xsl:when test="rim:Classification[@classificationScheme='urn:uuid:f0306f51-975f-434e-a61c-c59651d33983']/rim:Name/rim:LocalizedString/@value">
               <xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:f0306f51-975f-434e-a61c-c59651d33983']/rim:Name/rim:LocalizedString/@value"/>
            </xsl:when>
            <!-- Next, try the ClassCode -->
            <xsl:when test="rim:Classification[@classificationScheme='urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a']/rim:Name/rim:LocalizedString/@value">
               <xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a']/rim:Name/rim:LocalizedString/@value"/>
            </xsl:when>
            <xsl:otherwise>Community Document</xsl:otherwise>
         </xsl:choose>
      </DocumentName>
   </xsl:template>
   
   <xsl:template name="utII-DocumentType-CodedEntry">
      <!-- Populate a DocumentType element. The context node should be rim:ExtrinsicObject. -->
      <DocumentType>
         <xsl:for-each select="rim:Classification[@classificationScheme = $FormatCodeScheme]">
            <Code>
               <xsl:value-of select="@nodeRepresentation"/>
            </Code>
            <xsl:call-template name="utII-pName-fromName">
               <xsl:with-param name="emitElementName" select="'Description'"/>
            </xsl:call-template>
            <SDACodingStandard>
               <!-- Presuming that there will be just one slot... -->
               <xsl:value-of select="rim:Slot/rim:ValueList/rim:Value/text()"/>
            </SDACodingStandard>
         </xsl:for-each>
      </DocumentType>
   </xsl:template>
   
   <xsl:template name="utII-E-elementFromSlot-current">
      <!-- Make a specially-named element from the context node, which is expected
           to be a rim:Slot. Just propagate the text content. -->
      <!-- Start with @name, change first letter to capital to obtain element name -->
      <xsl:variable name="targetName"
         select="concat(translate(substring(@name,1,1),$lowercase,$uppercase),substring(@name,2))"/>
      <xsl:element name="{$targetName}">
         <xsl:value-of select="rim:ValueList/rim:Value/text()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-E-elementFromSlot-currentMulti">
      <!-- Make a specially-named element from the context node, which is expected
           to be a rim:Slot. Copy text content of all Value sub-elements. -->
      <!-- change first letter to capital to obtain element name -->
      <xsl:variable name="targetName"
         select="concat(translate(substring(@name,1,1),$lowercase,$uppercase),substring(@name,2))"/>
      <xsl:element name="{$targetName}">
         <xsl:for-each select="rim:ValueList/rim:Value">
            <Value>
               <xsl:value-of select="text()"/>
            </Value>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-E-fromClassification-current">
      <xsl:param name="schemeEname"/>
      <xsl:param name="extras"/><!-- optional list -->
      <!-- When called, the context node should be rim:Classification.
           The param should be one of the keywords for a Classification
           Scheme (ClassCode, FormatCode, etc.). That keyword will be
           the name of the emitted element and also used to locate the
           correct rim:Classification from which to fetch the value.
           This is the singleton version, producing one element. -->
      <xsl:element name="{$schemeEname}">
         <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
         </xsl:attribute>
         <Code>
            <xsl:value-of select="@nodeRepresentation"/>
         </Code>
         <xsl:call-template name="utII-pName-elementFromSlot">
            <xsl:with-param name="slotName" select="'codingScheme'"/>
         </xsl:call-template>
         <xsl:for-each select="rim:Name">
            <xsl:call-template name="utII-Name-Meta"/>
         </xsl:for-each>
         <!--<xsl:apply-templates select="rim:Description" mode="getValueText"/> emits Description -->
         <xsl:if test="contains($extras, '|Description|')">
            <xsl:for-each select="rim:Description">
               <xsl:call-template name="utII-pName-fromDescription">
                  <xsl:with-param name="emitElementName" select="'Description'"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:if>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-E-identElement-LName-current">
      <!-- Produce an element having data from a rim:ExternalIdentifier.
           The created element has the "long name" (e.g., PatientIdentifier)
           and is in the "Document" format with child element Value.
           Rather than take any parameters, use the context node to
           determine the name and value. Typical usage of this template
           is within a loop where the goal is to create a non-namespaced
           element for each rim:ExternalIdentifier in the source. -->
      <xsl:variable name="targetName">
         <xsl:apply-templates select="$identSchemeTable" mode="utMU-getIdentLName">
            <xsl:with-param name="urn" select="@identificationScheme"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:element name="{$targetName}">
         <xsl:copy-of select="@id"/>
         <Value>
            <xsl:value-of select="@value"/>
         </Value>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-E-identElement-ShortName">
      <!-- Given the NameLS of the rim:ExternalIdentifier, this template will
           do a keyed lookup to find the ShortName and fetch the value of the
           rim:ExternalIdentifier whose rim:Name matches the NameLS.
           The emitted element has the ShortName. (Example: given input of
           XDSDocumentEntry.uniqueId, element will be named UniqueId.)
           The value is stored as a direct child of the emitted element. -->
      <xsl:param name="inputNameLS"/>
      <xsl:variable name="emitElementName">
         <xsl:apply-templates select="$identSchemeTable" mode="utMU-getIdentSName-byNameLS">
            <xsl:with-param name="lookup" select="$inputNameLS"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:element name="{$emitElementName}">
         <xsl:value-of select="rim:ExternalIdentifier[rim:Name/rim:LocalizedString/@value=$inputNameLS]/@value"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-ExternalIdentifier">
      <!-- Copy a rim:ExternalIdentifier to an ExternalIdentifier element.
           The param is used to select the structure of the sub-elements.
           At the time this is called, the context node should be rim:ExternalIdentifier -->
      <xsl:param name="structure" select="'Document'"/>
      <ExternalIdentifier id="{@id}">
         <IdentificationScheme>
            <xsl:value-of select="@identificationScheme"/>
         </IdentificationScheme>
         <xsl:choose>
            <xsl:when test="$structure = 'Document'">
               <RegistryObject>
                  <xsl:value-of select="@registryObject"/>
               </RegistryObject>
               <IdentificationValue>
                  <xsl:value-of select="@value"/>
               </IdentificationValue>
               <xsl:call-template name="utII-Title-Document"/>
               <xsl:call-template name="utII-Comments-Document"/>
            </xsl:when>
            <xsl:when test="$structure = 'MetadataObj'">
               <Value>
                  <xsl:value-of select="@value"/>
               </Value>
               <xsl:for-each select="rim:Name">
                  <xsl:call-template name="utII-Name-Meta"/>
               </xsl:for-each>
               <xsl:for-each select="rim:Description">
                  <xsl:call-template name="utII-pName-fromDescription">
                     <xsl:with-param name="emitElementName" select="'Description'"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
      </ExternalIdentifier>
   </xsl:template>
   
   <xsl:template name="utII-Name-Meta">
      <!-- Convert rim:Name into Name, with attributes.
           When this is called, rim:Name should be the context node. -->
      <Name>
         <xsl:if test="rim:LocalizedString/@charset">
            <xsl:attribute name="Charset">
               <xsl:value-of select="rim:LocalizedString/@charset"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="rim:LocalizedString/@xml:lang">
            <xsl:attribute name="Lang">
               <xsl:value-of select="rim:LocalizedString/@xml:lang"/>
            </xsl:attribute>
         </xsl:if>
         <!-- Now populate the text node content -->
         <xsl:value-of select="rim:LocalizedString/@value"/>
      </Name>
   </xsl:template>
   
   <xsl:template name="utII-ObjectRef">
      <!-- Call this when the context node is a rim:ObjectRef-->
      <ObjectRef id="{@id}">
         <xsl:copy-of select="@home"/>
      </ObjectRef>
   </xsl:template>
   
   <xsl:template name="utII-pName-allOfClassification">
      <xsl:param name="emitElementName"/>
      <!-- Produce one element for each rim:Classification having
           the associated URN. (Example: ConfidentialityCode).
           The element name given as the param must be one of the names
           (Ename) from the classification table in UtilityMapURN.
           Call this when the context node is the parent of the
           rim:Classification elements of interest. -->
      <xsl:variable name="associatedURN">
         <xsl:apply-templates select="$classificationTable" mode="utMU-getClassifURN">
            <xsl:with-param name="lookup" select="$emitElementName"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:for-each select="rim:Classification[@classificationScheme = $associatedURN]">
         <xsl:element name="{$emitElementName}">
            <Code>
               <xsl:value-of select="@nodeRepresentation"/>
            </Code>
            <Scheme>
               <!-- CAUTION: This assumes that there will be just one rim:Slot, for codingScheme -->
               <xsl:value-of select="rim:Slot/rim:ValueList/rim:Value/text()"/>
            </Scheme>
            <xsl:call-template name="utII-pName-fromName">
               <xsl:with-param name="emitElementName" select="'Description'"/>
            </xsl:call-template>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utII-pName-elementFromSlot">
      <xsl:param name="slotName"/>
      <!-- Make a specially-named element from a rim:Slot. The context node should
           be the parent of one or more rim:Slot elements. The param identifies the
           source-side rim:Slot by name, and is also the basis for the name of the
           emitted element. Just propagate the text content. -->
      <!-- change first letter to capital to obtain element name -->
      <xsl:variable name="adjustedName"
         select="concat(translate(substring($slotName,1,1),$lowercase,$uppercase),substring($slotName,2))"/>
      <!-- ToDoXSLT2: make a stylesheet function for the above translation -->
      <xsl:element name="{$adjustedName}">
         <xsl:value-of select="rim:Slot[@name=$slotName]/rim:ValueList/rim:Value/text()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-elementFromSlot-current">
      <xsl:param name="emitElementName"/>
      <!-- Use when context node is a rim:Slot to become a specially-named element,
           but where the name must be supplied as a param. This is a hybrid of
           utII-pName-fromNamedSlot and utII-E-elementFromSlot-current that
           would be used when iterating over many slots and needing
           exceptional naming on a few. -->
      <xsl:element name="{$emitElementName}">
         <xsl:value-of select="rim:ValueList/rim:Value/text()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-elementFromSlot-keyed">
      <!-- Make a specially-named element from a rim:Slot. When there is one global set of slots,
           or a key whose match pattern is sufficiently restrictive, this should be faster than
           utII-pName-elementFromSlot (and context node doesn't matter). -->
      <xsl:param name="slotName"/>
      <!-- change first letter to capital to obtain element name -->
      <xsl:variable name="adjustedName"
         select="concat(translate(substring($slotName,1,1),$lowercase,$uppercase),substring($slotName,2))"/>
      <xsl:element name="{$adjustedName}">
         <xsl:value-of select="key('SlotByName',$slotName)/rim:ValueList/rim:Value/text()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-elementFromSlot-multiValue">
      <xsl:param name="slotName"/>
      <!-- Make a specially-named element from a rim:Slot. The context node should
           be the parent of one or more rim:Slot elements. The param identifies the
           source-side rim:Slot by name, and is also the basis for the name of the
           emitted element. Copy text content of all Value sub-elements. -->
      <!-- change first letter to capital to obtain element name -->
      <xsl:variable name="adjustedName"
         select="concat(translate(substring($slotName,1,1),$lowercase,$uppercase),substring($slotName,2))"/>
      <xsl:element name="{$adjustedName}">
         <xsl:for-each select="rim:Slot[@name=$slotName]/rim:ValueList/rim:Value">
            <Value>
               <xsl:value-of select="text()"/>
            </Value>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-externalDocumentID">
      <!-- Given the name of the element you want to emit, this template will
           do a keyed lookup to find the URN for that property on a Document
           and fetch the value of the rim:ExternalIdentifier whose
           @identificationScheme matches the URN.
           The name supplied as a param does not need to be the "official"
           long or short name of the identifier, but it DOES need to be in
           the identScheme table, at least as an OtherName if nothing else.
           The value is stored as a direct child of the emitted element. -->
      <xsl:param name="emitElementName"/>
      <xsl:element name="{$emitElementName}">
         <xsl:variable name="associatedURN">
            <xsl:apply-templates select="$identSchemeTable" mode="utMU-getIdentURN-byAnyName">
               <xsl:with-param name="lookup" select="$emitElementName"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:value-of select="rim:ExternalIdentifier[@identificationScheme=string($associatedURN)]/@value"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-fromDescription">
      <xsl:param name="emitElementName"/>
      <!-- Convert rim:Description into an element (sometimes Description, sometimes
           Comments, but choose any name) having MetadataObject structure, with
           attributes for language and CharSet.
           When this is called, rim:Description should be the context node. -->
      <xsl:element name="{$emitElementName}">
         <xsl:if test="rim:LocalizedString/@charset">
            <xsl:attribute name="Charset">
               <xsl:value-of select="rim:LocalizedString/@charset"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="rim:LocalizedString/@xml:lang">
            <xsl:attribute name="Lang">
               <xsl:value-of select="rim:LocalizedString/@xml:lang"/>
            </xsl:attribute>
         </xsl:if>
         <!-- Now populate the text node content -->
         <xsl:value-of select="rim:LocalizedString/@value"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-fromName">
      <xsl:param name="emitElementName"/>
      <!-- Convert rim:Name into an element having MetadataObject structure,
           although no Language and CharSet attributes until a need is shown.
           Specify a name of your choosing; Name and Title are typical choices.
           When this is called, the context node should be the element that
           contains one or more rim:Name elements. -->
      <xsl:element name="{$emitElementName}">
         <xsl:value-of select="rim:Name/rim:LocalizedString/@value"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-pName-fromNamedSlot">
      <!-- Make a arbitrary-named element from a rim:Slot. The context node should
           be the parent of one or more rim:Slot elements. The slotName param identifies the
           source-side rim:Slot by name, but the emitElementName param controls the name of
           the emitted element. Just propagate the text content. -->
      <xsl:param name="slotName"/>
      <xsl:param name="emitElementName"/>
      <xsl:element name="{$emitElementName}">
         <xsl:value-of select="rim:Slot[@name=$slotName]/rim:ValueList/rim:Value/text()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template name="utII-replicateAllSlots">
      <xsl:param name="namePlacement" select="'ATTRIB'"/><!-- keyword: 'ATTRIB' or 'ELEMENT' -->
      <xsl:param name="innerElementName" select="'Value'"/>
      <!-- Make a Slot element from each rim:Slot. The context node should be
           the parent of one or more rim:Slot elements. The namePlacement param
           specifies where the slot name will be placed. Each slot has ValueList
           for a child, which in turn has one or more elements whose name comes
           from the innerElementName param, each containing one value from a
           rim:Value on the source side. Typical choices for innerElementName
           are: Value, SlotValue, ValueListItem.
           -->
      <xsl:for-each select="rim:Slot">
         <Slot>
            <xsl:choose>
               <xsl:when test="$namePlacement = 'ELEMENT'">
                  <Name><xsl:value-of select="@name"/></Name>
               </xsl:when>
               <xsl:otherwise>
                  <!-- name is an ATTRIBute -->
                  <xsl:copy-of select="@name"/>
               </xsl:otherwise>
            </xsl:choose>
            <ValueList>
               <xsl:for-each select="rim:ValueList/rim:Value">
                  <xsl:element name="{$innerElementName}">
                     <xsl:value-of select="text()"/>
                  </xsl:element>
               </xsl:for-each>
            </ValueList>
         </Slot>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="utII-Slot-SlotValue">
      <!-- Make a Slot element from the context node, which is expected
           to be a rim:Slot. The sub-structure of ValueList and Value
           is replicated, with each inner element being named SlotValue. -->
      <Slot name="{@name}">
         <ValueList>
            <xsl:for-each select="rim:ValueList/rim:Value">
               <SlotValue>
                  <xsl:value-of select="text()"/>
               </SlotValue>
            </xsl:for-each>
         </ValueList>
      </Slot>
   </xsl:template>
   
   <xsl:template name="utII-Slot-ValueListItem">
      <!-- Make a Slot element from the context node, which is expected
           to be a rim:Slot. The sub-structure of ValueList and Value
           is replicated, with each inner element being named ValueListItem. -->
      <Slot>
         <Name>
            <xsl:value-of select="@name"/>
         </Name>
         <ValueList>
            <xsl:for-each select="rim:ValueList/rim:Value">
               <ValueListItem>
                  <xsl:value-of select="text()"/>
               </ValueListItem>
            </xsl:for-each>
         </ValueList>
      </Slot>
   </xsl:template>
   
   <xsl:template name="utII-SourceIdentifier-keyed">
      <xsl:param name="idPlacement"/><!-- Keyword: 'ATTRIB', 'SUB-ELEMENT', 'NONE' -->
      <!-- Emit a SourceIdentifier element from a rim:ExternalIdentifier element.
           The caller is responsible for declaring a key:
           <xsl:key name="ExternalIdentifierByScheme" match="{see below}" use="@identificationScheme"/>
           The match pattern should be appropriately constrained so that just one
           rim:ExternalIdentifier will be located. A rooted path (starts with /) like
           /lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryPackage/rim:ExternalIdentifier
           is very desirable! That key is used to locate the rim:ExternalIdentifier
           containing the Submission Set source ID.
           The created element is in the "Document" format with child element Value.
           The ID can be omitted or placed in an attribute ("old metadata" format or
           in an IID sub-element ("Object Request" format).
      -->
      <SourceIdentifier>
         <xsl:choose>
            <xsl:when test="$idPlacement='ATTRIB'">
               <xsl:attribute name="id">
                  <xsl:value-of select="key('ExternalIdentifierByScheme',$SubmissionSetSourceIdURN)/@id"/>
               </xsl:attribute>
            </xsl:when>
            <xsl:when test="$idPlacement='SUB-ELEMENT'">
               <IID>
                  <xsl:value-of select="key('ExternalIdentifierByScheme',$SubmissionSetSourceIdURN)/@id"/>
               </IID>
            </xsl:when>
         </xsl:choose>
         <Value>
            <xsl:value-of select="key('ExternalIdentifierByScheme',$SubmissionSetSourceIdURN)/@value"/>
         </Value>
      </SourceIdentifier>
   </xsl:template>
   
   <xsl:template name="utII-Title-Document">
      <!-- Convert rim:Name into Title, having Document (aka ProvideAndRegister)
           structure, with sub-elements. When this is called, the context node
           should be the element that contains one or more rim:Name elements. -->
      <Title>
         <ValueText>
            <xsl:value-of select="rim:Name/rim:LocalizedString/@value"/>
         </ValueText>
         <Charset>
            <xsl:value-of select="rim:Name/rim:LocalizedString/@charset"/>
         </Charset>
         <Lang>
            <xsl:value-of select="rim:Name/rim:LocalizedString/@xml:lang"/>
         </Lang>
      </Title>
   </xsl:template>
   
   <!-- ***  Your handy guide to choosing the best template to process rim:Classification elements ***
        Most of the templates here create an element drawing from the context element
        of the source, which is expected to be rim:Classification. One template,
        utII-pName-allOfClassification, can be used to consolidate data from several
        rim:Classification elements having the same @classificationScheme, as would be
        done for ConfidentialityCode.
        
        To process one rim:Classification into a named element, where the name is mapped
        from the @classificationScheme, use utII-E-fromClassification-current.
        To process one rim:Classification into a Classification element, use either
        utII-Classification-Document or utII-Classification-MetadataObject, depending
        on the desired output format.
        To process one rim:Classification into an Author element, use utII-Author.
        
        A typical approach is to set up a loop over all the rim:Classification elements,
        and within the loop, use an xsl:choose to separate out those that become Author,
        some other specially-named element, or just fall through to an xsl:otherwise
        that emits a Classification element.
      -->
   
   <!-- ***  Your handy guide to choosing the best template to process rim:Slot elements ***
         In this guide, the term "specially-named element" refers to an element with
         a name like "AuthorPerson" rather than just "Slot". When the element name is
         "Slot", the name must be carried as either an attribute or Name sub-element,
         and the data always has the same three-level structure that rim:Slot elements
         have, except the name of the innermost element may vary.
         
         Follow this decison tree...
         Q1. Are you iterating over many rim:Slot elements?
         Q1=YES
         Qy2. Will every rim:Slot element become a Slot element, as opposed
              to some getting a specially-named element?
           Qy2=YES
             Use utII-replicateAllSlots and set the params to produce the
             output format that is needed.
           Qy2=NO
             The caller is responsible for setting up the for-each loop over
             the rim:Slot elements in the source. Within the loop, set up an
             xsl:choose to separate out those that become Slot (if any) from those
             that become specially-named elements. In each branch of the choose:
             To make a specially-named element where the name follows the standard
               pattern and the value is a text child, use utII-E-elementFromSlot-current.
             To make a specially-named element where the name follows the standard
               pattern and there is a ValueList that needs to be replicated with
               innermost elements named Value, use utII-E-elementFromSlot-currentMulti.
             To make a specially-named element where the name must be assigned and the
               value is a text child, use utII-pName-elementFromSlot-current.
             To make a Slot element when there is a ValueList that needs to be replicated
               with innermost elements named Value, do
               <xsl:apply-templates select="." mode="utII-Slot-MetadataObject"/>
             To make a Slot element when there is a ValueList that needs to be replicated
               with innermost elements named SlotValue, use utII-Slot-SlotValue.
             To make a Slot element when there is a ValueList that needs to be replicated
               with innermost elements named ValueListItem, and the name should go into
               a Name sub-element, use utII-Slot-ValueListItem.
             If some other situation arises, make a new template by combining techniques
             from the above templates.
             
         Q1=NO, just processing a rim:Slot individually
           In this part of the tree, it is unlikely that the target element would be
           named Slot, but if that were to be the case, there are options.
           Qn2. Could the rim:Slot have a ValueList with multiple values?
           Qn2=YES
             Use utII-pName-elementFromSlot-multiValue, assuming that the
             @name of the source becomes the element name of the target
             (after capitalization). If a different method for naming the
             target is needed, a new template should be added above
             (Suggested name: utII-pName-fromNamedSlot-multiValue).
             In the unlikely event that the target element should be named Slot,
             choose among utII-Slot-MetadataObject, utII-Slot-SlotValue, and
             utII-Slot-ValueListItem, as itemized under "Qy2=NO" above.
           Qn2=NO
             To make a specially-named element where the name follows the standard
               pattern and the value is a text child, use utII-pName-elementFromSlot
               UNLESS there is a 'SlotByName' key available, in which case
               utII-pName-elementFromSlot-keyed will operate faster.
             To make a specially-named element where the name must be assigned and the
               value is a text child, use utII-pName-fromNamedSlot.
             If some other situation arises, make a new template by combining techniques
             from the above templates.
   -->
   
</xsl:stylesheet>