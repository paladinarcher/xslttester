<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:str="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="isc xsi sdtc exsl set date str">
  <xsl:include href="DateFormatter.xsl" />

  <xsl:variable name="documentCreatedOn" select="isc:evaluate('timestamp')" />
  <xsl:key name="vitals" match="Observations/Observation" use="GroupId/text()" />

  <xsl:template match="/Container">
    <xsl:variable name="patientBirthDate" select="translate(Patient/BirthTime/text(),'TZ:- ','')" />
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
    </xsl:processing-instruction>

    <ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 http://xreg2.nist.gov:11080/hitspValidation/schema/cdar2c32/infrastructure/cda/C32_CDA.xsd">
      <xsl:comment>
        ********************************************************
        CDA Header
        ********************************************************
      </xsl:comment>
      <xsl:comment> HITSP C32 V2.5:  Add realmCode </xsl:comment>
      <realmCode code='US'/>
      <xsl:comment> Following template is HL7 CDA Release 2 </xsl:comment>
      <xsl:comment> POCD_HD000040 is for Lab.Report.Clinical.Document </xsl:comment>
      <typeId extension="POCD_HD000040" root="2.16.840.1.113883.1.3"/>
      <xsl:comment> HITSP C32 V2.5:  Template for IHE PCC Medical Documents specification </xsl:comment>
      <templateId root='1.3.6.1.4.1.19376.1.5.3.1.1.1'/>
      <xsl:comment> Following template is the CCD v1.0 Templates Root </xsl:comment>
      <templateId root="2.16.840.1.113883.10.20.1"/>
      <xsl:comment> HITSP C32 V2.5:  Template for HL7 General Header constraints</xsl:comment>
      <templateId root='2.16.840.1.113883.10.20.3'/>
      <xsl:comment> Following template is the HITSP/C32 Registration and Medication Template </xsl:comment>
      <templateId root="2.16.840.1.113883.3.88.11.32.1"/>
      <xsl:comment> HITSP C32 V2.5:  Template for HITSP C32 V2.5 </xsl:comment>
      <templateId root='2.16.840.1.113883.3.88.11.83.1'/>
      <xsl:comment> CDA Document Identifer, id=VA OID, extension=system-generated </xsl:comment>
      <id extension="{isc:evaluate('createUUID')}" root="2.16.840.1.113883.4.349"/>
      <xsl:comment> CDA Document Code </xsl:comment>
      <code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="{isc:evaluate('lookup', '34133-9','Summary of episode note')}" />
      <xsl:comment> CDA Document Title </xsl:comment>
      <title>Department of Veterans Affairs Summarization of Episode Note</title>
      <xsl:comment> 1.01 DOCUMENT TIMESTAMP, REQUIRED </xsl:comment>
      <effectiveTime value="{$documentCreatedOn}"/>
      <xsl:comment> CDA Confiedntiality Code </xsl:comment>
      <confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>
      <xsl:comment> CDA DOCUMENT LANGUAGE </xsl:comment>
      <languageCode code="en-US"/>
      <xsl:comment>
        ********************************************************
        PERSON INFORMATION CONTENT MODULE, REQUIRED
        ********************************************************
      </xsl:comment>
      <recordTarget>
        <patientRole>

          <xsl:comment> 1.02 PERSON ID, REQUIRED, id=VA OID, extension=GUID </xsl:comment>
          <id extension="{Patient/MPIID/text()}" root="2.16.840.1.113883.4.349"/>

          <xsl:comment>  1.03 PERSON ADDRESS-HOME PERMANENT, REQUIRED </xsl:comment>
          <xsl:apply-templates select="Patient/Addresses" mode="standard-address">
            <xsl:with-param name="use">HP</xsl:with-param>
          </xsl:apply-templates>

          <xsl:comment> 1.04 PERSON PHONE/EMAIL/URL, REQUIRED </xsl:comment>
          <xsl:apply-templates select="Patient" mode="standard-contact-info" />

          <patient>
            <xsl:comment>  1.05 PERSON NAME LEGAL, REQUIRED </xsl:comment>
            <xsl:apply-templates select="Patient/Name" mode="standard-name">
              <xsl:with-param name="use">L</xsl:with-param>
            </xsl:apply-templates>

            <xsl:comment>  1.05 PERSON NAME Alias Name, Optional </xsl:comment>
            <xsl:apply-templates select="Patient/Aliases/Name" mode="standard-name">
              <xsl:with-param name="use">A</xsl:with-param>
            </xsl:apply-templates>

            <!-- TODO: confirm GENDER construct & confirm where OriginalTextGender is valued after retrieval from ESR -->
            <xsl:comment> HITSP C32 V2.5: 1.06 GENDER, REQUIRED AND REQUIRED Terminology </xsl:comment>
            <xsl:comment> HITSP C32 V2.5: When Vista value is M, F, send as HL7AdminGenderCode  </xsl:comment>
            <xsl:comment> HITSP C32 V2.5: When Vista value is "Unknown", send as genderCode nullFlavor=UNK"  </xsl:comment>
            <administrativeGenderCode code="{Patient/Gender/Code/text()}" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="{Patient/Gender/Description/text()}">
              <originalText>originalText-GENDER</originalText>/>
            </administrativeGenderCode>

            <xsl:comment> 1.07 PERSON DATE OF BIRTH, REQUIRED </xsl:comment>
            <birthTime value="{$patientBirthDate}"/>

            <!--  TODO: confirm MARITAL STATUS construct & confirm where OriginalTextMaritalStatus is valued after retrieval from ESR interface -->
            <xsl:comment>  1.08 MARITAL STATUS, Optional-R2 </xsl:comment>
            <xsl:comment> VLER SEG 1B:  Send as HL7 MaritalStatus  </xsl:comment>
            <maritalStatusCode code="{Patient/MaritalStatus/Code/text()}" codeSystem='2.16.840.1.113883.5.2' codeSystemName='MaritalStatusCode' displayName="{Patient/MaritalStatus/Description/text()}">
              <originalText>originaltext-MARITAL STATUS</originalText>
            </maritalStatusCode>

            <xsl:comment>  1.09 RELIGIOUS AFFILIATION, Optional, Removed b/c data not yet available via VA VIstA RPCs </xsl:comment>

            <!--  TODO: confirm RACE construct & confirm where OriginalTextRace is valued after retrieval from ESR interface -->
            <xsl:comment>  1.10 RACE, Optional </xsl:comment>
            <xsl:comment>  1.10 RACE as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
            <raceCode code="{Patient/Race/Code/text()}" codeSystem='2.16.840.1.113883.6.238' codeSystemName='CDC Race and Ethnicity' displayName="{Patient/Race/Description/text()}">
              <originalText>originalText-RACE</originalText>/>
            </raceCode>

            <!--  TODO: confirm ETHNICITY construct & confirm where OriginalTextEthnicity is valued after retrieval from ESR interface -->
            <xsl:comment> 1.11 ETHNICITY, Optional </xsl:comment>
            <xsl:comment> 1.11 ETHNICITY as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
            <ethnicGroupCode code="{Patient/EthnicGroup/Code/text()}" codeSystem='2.16.840.1.113883.6.238' codeSystemName='CDC Race and Ethnicity' displayName="{Patient/EthnicGroup/Description/text()}">
              <originalText>originalText-ETHNICITY </originalText>
            </ethnicGroupCode>

            <xsl:comment>
              ********************************************************
              LANGUAGE SPOKEN CONTENT MODULE
              ********************************************************
            </xsl:comment>
            <languageCommunication>
              <templateId root="2.16.840.1.113883.3.88.11.32.2"/>
              <xsl:comment>  2.01 LANGUAGE, REQUIRED, languageCode as nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
              <xsl:choose>
                <xsl:when test="boolean(Patient/PrimaryLanguage/Code)">
                  <languageCode code="{Patient/PrimaryLanguage/Code/text()}" />
                </xsl:when>
                <xsl:otherwise>
                  <languageCode nullFlavor="UNK" />
                </xsl:otherwise>
              </xsl:choose>
            </languageCommunication>
          </patient>
        </patientRole>
      </recordTarget>
      <xsl:comment>
        ********************************************************
        INFORMATION SOURCE CONTENT MODULE, REQUIRED
        ********************************************************
      </xsl:comment>
      <xsl:comment> AUTHOR SECTION (REQUIRED) OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
      <author>
        <xsl:comment> 10.01 AUTHOR TIME (=Document Creation Date), REQUIRED </xsl:comment>
        <time value="{$documentCreatedOn}"/>
        <assignedAuthor>
          <xsl:comment> 10.02 AUTHOR ID (VA OID) (authorOID), REQUIIRED </xsl:comment>
          <id root="2.16.840.1.113883.4.349"/>
          <xsl:comment> HITSP C32 V2.5:  Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
          <addr/>
          <xsl:comment> HITSP C32 V2.5:  Assigned Author  Telecom Required, but VA VistA data not yet available </xsl:comment>
          <telecom/>
          <xsl:comment> 10.02 AUTHOR NAME REQUIRED </xsl:comment>
          <xsl:comment> HITSP C32 V2.5:  C83  assignedPerson/Author Name REQUIRED but provided as representedOrganization </xsl:comment>
          <assignedPerson>
            <name/>
          </assignedPerson>
          <xsl:comment> 10.02 AUTHOR NAME REQUIRED as representedOrganization </xsl:comment>
          <representedOrganization>
            <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION OID (VA OID) (deviceOrgOID), REQUIIRED </xsl:comment>
            <id root="2.16.840.1.113883.4.349"/>
            <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION NAME (deviceOrgName), REQUIIRED </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> HITSP C32 V2.5:  Assigned Author  Telecom Required, but VA VistA data not yet available </xsl:comment>
            <telecom/>
            <xsl:comment> HITSP C32 V2.5:  Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
            <addr/>
          </representedOrganization>
        </assignedAuthor>
      </author>
      <xsl:comment> INFORMATION SOURCE SECTION (OPTIONAL)OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
      <!-- 10.06 INFORMATION SOURCE AS AN ORGANIZATION, REQUIRED -->
      <informant>
        <assignedEntity>
          <id nullFlavor="NI"/>
          <xsl:comment> HITSP C32 V2.5:   Address Required for informant/assignedEntity, but VA VistA data not yet available </xsl:comment>
          <addr/>
          <xsl:comment> HITSP C32 V2.5:    Telecom Required for informant/assignedEntity, but VA VistA data not yet available </xsl:comment>
          <telecom/>
          <xsl:comment> HITSP C32 V2.5:  assignedPerson Required for informant/assignedEntity, but VA VistA data not yet available </xsl:comment>
          <assignedPerson>
            <xsl:comment> HITSP C32 V2.5:  Name Required for informant/assignedEntity/assignedPerson </xsl:comment>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <xsl:comment> 10.06 INFORMATION SOURCE ORGANIZATION OID (VA OID) (sourceOrgOID), REQUIRED </xsl:comment>
            <id root="2.16.840.1.113883.4.349"/>
            <xsl:comment> 10.06 INFORMATION SOURCE ORGANIZATION NAME (sourceOrgName), REQUIRED </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <telecom/>
            <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <addr/>
          </representedOrganization>
        </assignedEntity>
      </informant>
      <xsl:comment>
        ********************************************************
        CCD CDA R2 CUSTODIAN AS AN ORGANIZATION, REQUIRED
        ********************************************************
      </xsl:comment>
      <custodian>
        <assignedCustodian>
          <representedCustodianOrganization>
            <xsl:comment> CCD CDA R2 CUSTODIAN OID (VA) (custodianOID) </xsl:comment>
            <id root="2.16.840.1.113883.4.349"/>
            <xsl:comment> CCD CDA R2 CUSTODIAN NAME (custodianName) </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <telecom/>
            <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <addr/>
          </representedCustodianOrganization>
        </assignedCustodian>
      </custodian>
      <xsl:comment>
        ********************************************************
        CCD CDA R2 LEGAL AUTHENTICATOR AS AN ORGANIZATION, REQUIRED
        ********************************************************
      </xsl:comment>
      <legalAuthenticator>
        <!-- CCD CDA R2 TIME OF AUTHENTICATION -->
        <time value="{$documentCreatedOn}"/>
        <signatureCode code="S"/>
        <assignedEntity>
          <id nullFlavor="NI"/>
          <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
          <addr/>
          <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
          <telecom/>
          <xsl:comment> HITSP C32 V2.5:   assigned Person Required for legalAuthenticator/assignedEntity  </xsl:comment>
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <xsl:comment> CCD CDA R2 LEGAL AUTHENTICATOR OID (VA)  </xsl:comment>
            <id root="2.16.840.1.113883.4.349"/>
            <xsl:comment> CCD CDA R2 LEGAL AUTHENTICATOR NAME (authenticatorName) </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <telecom/>
            <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
            <addr/>
          </representedOrganization>
        </assignedEntity>
      </legalAuthenticator>
      <xsl:comment>
        ********************************************************
        SUPPORT CONTENT MODULE, REQUIRED
        ********************************************************
      </xsl:comment>
      <xsl:apply-templates select="Patient/SupportContacts/SupportContact" mode="header-participant" />

      <xsl:comment>
        ********************************************************
        CCD CDA R2 DOCUMENTATION OF MODULE - QUERY META DATA, Optional
        ********************************************************
      </xsl:comment>

      <documentationOf>
        <serviceEvent classCode="PCPR">
          <effectiveTime>
            <xsl:comment> QUERY META DATA, SERVICE START TIME, Optional </xsl:comment>
            <low value="{$patientBirthDate}"/>
            <xsl:comment> QUERY META DATA, SERVICE STOP TIME, Optional </xsl:comment>
            <high value="{$documentCreatedOn}"/>
          </effectiveTime>
          <xsl:comment>
            ********************************************************
            HEALTHCARE PROVIDER MODULE, OPTIONAL
            ********************************************************
          </xsl:comment>
          <xsl:apply-templates select="Patient/Extension/CareTeamMembers/CareTeamMember[Description = 'PRIMARY CARE PROVIDER']" mode="header-careteammembers">
            <xsl:with-param name="number" select="'1'" />
          </xsl:apply-templates>
          <xsl:apply-templates select="Patient/Extension/CareTeamMembers/CareTeamMember[not(Description = 'PRIMARY CARE PROVIDER')]" mode="header-careteammembers">
            <xsl:with-param name="number" select="'2'" />
          </xsl:apply-templates>
        </serviceEvent>
      </documentationOf>
      <xsl:comment>
        ********************************************************
        CDA BODY
        ********************************************************
      </xsl:comment>
      <component>
        <structuredBody>
          <xsl:comment>
            ********************************************************
            ALLERGY/DRUG SECTION SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:choose>
              <xsl:when test="not(boolean(Allergies/Allergy))">
                <section nullFlavor="NI">
                  <xsl:comment> CCD Alert Section Template</xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.2"/>
                  <xsl:comment> HITSP C32 V2.5:  Allergy and Adverse Reaction Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.102"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Allergies and Other Adverse Reactions  Section Template </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.13"/>
                  <xsl:comment> HITSP C32 V2.5:  CCD Section Conformance code value , static </xsl:comment>
                  <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" displayName="Allergies, adverse reactions, alerts"/>
                  <title>Allergies</title>
                  <xsl:comment> ALLERGIES NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Alert Section Template</xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.2"/>
                  <xsl:comment> HITSP C32 V2.5:  Allergy and Adverse Reaction Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.102"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Allergies and Other Adverse Reactions  Section Template </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.13"/>
                  <xsl:comment> HITSP C32 V2.5:  CCD Section Conformance code value , static </xsl:comment>
                  <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" displayName="Allergies, adverse reactions, alerts"/>
                  <title>Allergies</title>
                  <xsl:comment>  ALLERGIES NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment> VLER SEG 1B: Allergies/Drug Business Rules for Medical Content  </xsl:comment>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Department of Veterans Affairs</th>
                          <th>Business Rules for Construction of Medical Information</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>Allergies</td>
                          <td>This section contains all patient allergy information from all VA treatment facilities. It does not contain patient allergies that were deleted or entered in error.</td>
                        </tr>
                      </tbody>
                    </table>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Allergy</th>
                          <th>Coded Allergy</th>
                          <th>Verification Date</th>
                          <th>Event Type</th>
                          <th>Reaction</th>
                          <th>Severity</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Allergies/Allergy">
                          <xsl:sort select="Allergy/Description" />
                          <xsl:if test="boolean(Allergy/SDACodingStandard) or (count(../Allergies/Allergy/SDACodingStandard) = 0 and ((Allergy/Code/text() = 'NKA' and count(preceding::Allergy[Code/text() = 'NKA']) = 0) or ((Allergy/Code/text() = 'NONE' and count(preceding::Allergy[Code/text() = 'NONE']) = 0))))">
                            <xsl:choose>
                              <xsl:when test="boolean(Allergy/SDACodingStandard)">
                                <xsl:variable name="allergyIndex" select="position()" />
                                <tr>
                                  <td>
                                    <content ID="{concat('andAllergy',position())}" >
                                      <xsl:value-of select="Allergy/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('andCodedAllergyName',position())}" >
                                      Coded Allergy Name Not Available
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('andVerificationDate',position())}">
                                      <xsl:value-of select="(VerifiedTime | EnteredOn)" />                                    
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('andEventType',position())}" >
                                      <!-- TODO: get translation from VETS ? -->
                                      <xsl:value-of select="AllergyCategory/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <list>
                                      <xsl:for-each select="Extension/Reactions/Reaction">
                                        <item>
                                          <content ID="{concat('andReaction', $allergyIndex, '-', position())}" >
                                            <xsl:value-of select="Description/text()" />
                                          </content>
                                        </item>
                                      </xsl:for-each>
                                    </list>
                                  </td>
                                  <td>
                                    <content ID="{concat('andSeverity',position())}" >
                                      <xsl:value-of select="Severity/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('andSource',position())}" >
                                      <xsl:value-of select="EnteredAt/Description/text()" />
                                    </content>
                                  </td>
                                </tr>
                              </xsl:when>
                              <xsl:otherwise>
                                <tr>
                                  <td colspan="5">
                                    <xsl:value-of select="Allergy/Description/text()" />
                                  </td>
                                  <td>
                                    <content ID="{concat('andSource',position())}" >
                                      <xsl:value-of select="EnteredAt/Description/text()" />
                                    </content>
                                  </td>
                                </tr>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:comment> ALLERGIES STRUCTURED DATA </xsl:comment>
                  <xsl:for-each select="Allergies/Allergy">
                    <xsl:sort select="Allergy/Description" />
                    <xsl:if test="boolean(Allergy/SDACodingStandard) or (count(../Allergy/Allergy/SDACodingStandard) = 0 and ((Allergy/Code/text() = 'NKA' and count(preceding::Allergy[Code/text() = 'NKA']) = 0) or ((Allergy/Code/text() = 'NONE' and count(preceding::Allergy[Code/text() = 'NONE']) = 0))))">
                      <xsl:choose>
                        <xsl:when test="boolean(Allergy/SDACodingStandard)">
                          <xsl:variable name="allergyIndex" select="position()" />
                          <entry typeCode="DRIV">
                            <act classCode="ACT" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.1.27" assigningAuthorityName="CCD" />
                              <xsl:comment> HITSP C32 V2.5:  Templates for Allergy/Drug Module/Entry </xsl:comment>
                              <templateId root="2.16.840.1.113883.3.88.11.83.6"/>
                              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
                              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3"/>
                              <xsl:comment> CCD Allergy Act ID as nullflavor </xsl:comment>
                              <id nullFlavor="UNK" />
                              <code nullFlavor="NA" />
                              <xsl:comment> HITSP C32 V2.5:  IHE Concern Template Requires statusCode and effectiveTime </xsl:comment>
                              <statusCode code="active" />
                              <effectiveTime>
                                <xsl:choose>
                                  <xsl:when test="boolean(VerifiedTime)">
                                    <low value="{translate(VerifiedTime/text(), 'TZ:- ','')}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <low value="{translate(EnteredOn/text(),'TZ:- ','')}" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </effectiveTime>
                              <xsl:comment> INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional </xsl:comment>
                              <author>
                                <xsl:comment> ADD TIME TO INFORMATION SOURCE FOR ALLERGIES/DRUG </xsl:comment>
                                <time nullFlavor="UNK" />
                                <assignedAuthor>
                                  <id nullFlavor="NI" />
                                  <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                                  <addr/>
                                  <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                                  <telecom/>
                                  <code nullFlavor="NA" />
                                  <representedOrganization>
                                    <xsl:comment> INFORMATION SOURCE ID, root=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                                    <id extension="{EnteredAt/Code/text()}"  root="2.16.840.1.113883.4.349"/>
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
                                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                    <telecom/>
                                    <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                    <addr/>
                                  </representedOrganization>
                                </assignedAuthor>
                              </author>
                              <entryRelationship typeCode="SUBJ" inversionInd="false">
                                <observation classCode="OBS" moodCode="EVN">
                                  <xsl:comment> HITSP C32 V2.5:    Allergy Templates </xsl:comment>
                                  <templateId root='2.16.840.1.113883.10.20.1.28'/>
                                  <xsl:comment> Alert observation template </xsl:comment>
                                  <templateId root="2.16.840.1.113883.10.20.1.18"/>
                                  <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                                  <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6'/>
                                  <xsl:comment> HITSP C32 V2.5: IHE Observation Templates Require Id </xsl:comment>
                                  <id nullFlavor="UNK"/>
                                  <xsl:comment> 6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT </xsl:comment>
                                  <xsl:comment> HITSP C32 V2.5:  6.02 ADVERSE EVENT TYPE SNOMED CT Terminology Required </xsl:comment>
                                  <code code="{Allergies/AllergyCategory/Code/text()}" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" >
                                    <!--  TODO: confirm ALLERGY CODE construct & confirm where OriginalTextAllergyCategory is valued after translation -->
                                    <originalText>originalText-AllergyCategory</originalText>
                                  </code>
                                  <xsl:comment> IHE  Status Code fro Observation </xsl:comment>
                                  <statusCode code="completed" />
                                  <xsl:comment> 6.01 ADVERSE EVENT DATE, Optional-R2 </xsl:comment>
                                  <effectiveTime>
                                    <xsl:choose>
                                      <xsl:when test="boolean(VerifiedTime)">
                                        <low value="{translate(VerifiedTime/text(),'TZ:- ','')}" />
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <low value="{translate(EnteredOn/text(),'TZ:- ','')}" />
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </effectiveTime>
                                  <xsl:comment> HITSP C32 V2.5:  IHE Allergy Concern Template Requires value, When uncoded only xsi:type=CD allowed </xsl:comment>
                                  <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                    <originalText>
                                      <reference value="{concat('#andEventType',position())}"/>
                                    </originalText>
                                  </value>
                                  <xsl:comment> HITSP C32 V2.5: Participant block for 6.04-Product Coded </xsl:comment>
                                  <participant typeCode="CSM">
                                    <participantRole classCode="MANU">
                                      <playingEntity classCode="MMAT">
                                        <xsl:comment> 6.04 PRODUCT CODED, Optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                        <code code="UNK" nullFlavor="UNK">
                                          <originalText>
                                            <reference  value="{concat('#andCodedAllergyName',position())}"/>
                                          </originalText>
                                        </code>
                                        <xsl:comment> 6.03 PRODUCT FREE TEXT, REQUIRED </xsl:comment>
                                        <name>
                                          <xsl:value-of select="Allergy/Description/text()"/>
                                        </name>
                                      </playingEntity>
                                    </participantRole>
                                  </participant>
                                  <xsl:comment> SEVERITY ENTRY RELATIONSHIP BLOCK optional, 0 or 1 per Allergy </xsl:comment>
                                  <xsl:if test="boolean(Severity)">
                                    <entryRelationship typeCode="SUBJ" inversionInd="true">
                                      <xsl:comment>Template ID for Problem Entry - Allergy Reaction Uses Same Structure</xsl:comment>
                                      <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6.1'/>
                                      <observation classCode="OBS" moodCode="EVN">
                                        <xsl:comment> SeverityTemplate ID </xsl:comment>
                                        <templateId root="2.16.840.1.113883.10.20.1.55"/>
                                        <xsl:comment>HITSP C32 V2.5:    Allergy Templates</xsl:comment>
                                        <templateId root="2.16.840.1.113883.10.20.1.28"/>
                                        <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
                                        <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.6"/>
                                        <xsl:comment> CCD Obs ID as nullFlavor </xsl:comment>
                                        <id nullFlavor="UNK"/>
                                        <code code='SEV' displayName='Severity' codeSystem='2.16.840.1.113883.5.4' codeSystemName='HL7ActCode' />
                                        <xsl:comment> 6.07 SEVERITY-FREE TEXT, optional, Pointer to Narrative Block </xsl:comment>
                                        <text>
                                          <reference value="{concat('#andSeverity',position())}" />
                                        </text>
                                        <statusCode code="completed" />
                                        <effectiveTime>
                                          <low nullFlavor="UNK" />
                                        </effectiveTime>
                                        <xsl:comment> 6.08 SEVERITY CODED, optional, When uncoded only xsi:type="CD" allowed </xsl:comment>
                                        <!-- TODO: Internal Translation -->
                                        <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                                      </observation>
                                    </entryRelationship>
                                  </xsl:if>
                                  <xsl:comment> REACTION ENTRY RELATIONSHIP BLOCK R2, repeatable </xsl:comment>
                                  <xsl:for-each select="Extension/Reactions/Reaction">
                                    <entryRelationship typeCode="MFST" inversionInd="true">
                                      <observation classCode="OBS" moodCode="EVN">
                                        <templateId root='2.16.840.1.113883.10.20.1.28'/>
                                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6'/>
                                        <id nullFlavor="NA" />
                                        <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>
                                        <statusCode code="completed" />
                                        <effectiveTime nullFlavor="UNK" /><!-- not in DMSS? Legacy puts a low in this... -->
                                        <xsl:comment> 6.06 REACTION CODED, REQUIRED </xsl:comment>
                                        <!-- TODO: DMSS says static... self closed. not null, not populated...  -->
                                        <xsl:choose>
                                          <xsl:when test="boolean(Code)">
                                            <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                              <xsl:comment> 6.05 REACTION-FREE TEXT, optional, </xsl:comment>
                                              <originalText>
                                                <reference value="{concat('#andReaction', $allergyIndex, '-', position())}" />
                                              </originalText>
                                            </value>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <value xsi:type="CD" nullFlavor="NA" />
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </observation>
                                    </entryRelationship>
                                  </xsl:for-each>
                                </observation>
                              </entryRelationship>
                            </act>
                          </entry>
                        </xsl:when>
                        <xsl:otherwise>
                          <entry typeCode="DRIV">
                            <act classCode="ACT" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.1.27" assigningAuthorityName="CCD" />
                              <xsl:comment> HITSP C32 V2.5:  Templates for Allergy/Drug Module/Entry </xsl:comment>
                              <templateId root="2.16.840.1.113883.3.88.11.83.6"/>
                              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
                              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3"/>
                              <xsl:comment> CCD Allergy Act ID as nullflavor </xsl:comment>
                              <id nullFlavor="UNK" />
                              <code nullFlavor="NA" />
                              <xsl:comment> HITSP C32 V2.5:  IHE Concern Template Requires statusCode and effectiveTime </xsl:comment>
                              <statusCode code="active"/>
                              <effectiveTime>
                                <low nullFlavor="NA"/>
                              </effectiveTime>
                              <xsl:comment> INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional </xsl:comment>
                              <author>
                                <xsl:comment> ADD TIME TO INFORMATION SOURCE FOR ALLERGIES/DRUG </xsl:comment>
                                <time nullFlavor="UNK" />
                                <assignedAuthor>
                                  <id nullFlavor="NI" />
                                  <code nullFlavor="NA"/>
                                  <representedOrganization>
                                    <xsl:comment> INFORMATION SOURCE ID, root=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                                    <id extension="{EnteredAt/Code/text()}"  root="2.16.840.1.113883.4.349"/>
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
                                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                                    <addr nullFlavor="NA"/>
                                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                                    <telecom nullFlavor="NA" />
                                  </representedOrganization>
                                </assignedAuthor>
                              </author>
                              <entryRelationship typeCode="SUBJ">
                                <xsl:comment>Allergy Intolerance Observation Entry</xsl:comment>
                                <observation classCode="OBS" moodCode="EVN">
                                  <xsl:choose>
                                    <xsl:when test="Allergy/Code/text() = 'NKA'">
                                      <xsl:attribute name="negationInd">true</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="nullFlavor">NASK</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <templateId root='2.16.840.1.113883.10.20.1.28'/>
                                  <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                                  <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6'/>
                                  <id nullFlavor="NA"/>
                                  <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>
                                  <statusCode code="completed"/>
                                  <xsl:comment>6.01 ADVERSE EVENT DATE, REQUIRED</xsl:comment>
                                  <effectiveTime>
                                    <low nullFlavor="NA"/>
                                  </effectiveTime>
                                  <xsl:comment>6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT</xsl:comment>
                                  <value code="419199007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Allergy to substance (disorder)" xsi:type="CD"/>
                                  <xsl:comment>REACTION ENTRY RELATIONSHIP BLOCK R2, repeatable</xsl:comment>
                                  <xsl:comment>SEVERITY ENTRY RELATIONSHIP BLOCK R2, 0 or 1 per Allergy</xsl:comment>
                                </observation>
                              </entryRelationship>
                            </act>
                          </entry>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment>
            ********************************************************
            PROBLEM/CONDITION SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 2 </xsl:comment>
            <section>
              <xsl:comment> CCD Problem Section Template </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.1.11"/>
              <xsl:comment> HITSP C32 V2.5:  Problem Section Template </xsl:comment>
              <templateId root="2.16.840.1.113883.3.88.11.83.103"/>
              <xsl:comment> HITSP C32 V2.5:  IHE Active Problems Section Template </xsl:comment>
              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.6"/>
              <xsl:comment> HITSP C32 V2.5:  C83 - IHE Problem Concern Templates </xsl:comment>
              <!-- templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
					<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2"/> -->
              <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problems"/>
              <title>Problems/Conditions</title>
              <xsl:comment>  PROBLEMS NARRATIVE BLOCK, Required </xsl:comment>
              <text>
                <xsl:comment> VLER SEG 1B: Problem/Condition Business Rules for Medical Content  </xsl:comment>
                <table border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Department of Veterans Affairs</th>
                      <th>Business Rules for Construction of Medical Information</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Problems/Conditions</td>
                      <td>This section contains patient conditions (active and inactive) information from all VA treatment facilities. It does not contain patient conditions that were deleted.</td>
                    </tr>
                  </tbody>
                </table>
                <table ID="problemNarritive" border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Problem</th>
                      <th>Status</th>
                      <th>Problem Code</th>
                      <th>Date of Onset</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="Diagnoses">
                      <xsl:variable name="diagnosisIndex" select="position()" />
                      <tr>
                        <td>
                          <content ID="{concat('pndProblem',position())}">
                            <xsl:value-of select="Diagnosis/OriginalText/text()" />
                          </content>
                        </td>
                        <td>
                          <content ID="{concat('pndStatus',position())}">
                            <xsl:value-of select="Status/Description/text()" />
                          </content>
                        </td>
                        <td>
                          <content ID="{concat('pndProblemcode',position())}">
                            <xsl:value-of select="Diagnosis/Code/text()" />
                          </content>
                        </td>
                        <td>
                          <content ID="{concat('pndDateOfOnset',position())}" >
                            <xsl:value-of select="FromTime/text()" />
                          </content>
                        </td>
                        <td>
                          <content ID="{concat('pndProvider',position())}">
                            <xsl:value-of select="EnteredBy/Description/text()" />
                          </content>
                        </td>
                        <td>
                          <content ID="{concat('pndSource',position())}">
                            <xsl:value-of select="EnteredAt/Description/text()" />
                          </content>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </text>
              <xsl:for-each select="Diagnoses">
                <entry typeCode="DRIV">
                  <act classCode="ACT" moodCode="EVN">
                    <xsl:comment> CCD Problem Act Template </xsl:comment>
                    <templateId root="2.16.840.1.113883.10.20.1.27"/>
                    <xsl:comment> HITSP V2.5:  C83 Templates for Problem Module/Entry </xsl:comment>
                    <templateId root="2.16.840.1.113883.3.88.11.83.7"/>
                    <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
                    <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2"/>
                    <xsl:comment> CCD Problem Act ID as nullFlavor  </xsl:comment>
                    <id nullFlavor="UNK"/>
                    <code nullFlavor="NA" />
                    <xsl:comment> HITSP V2.5 IHE Problem Concern Templates Requires statusCode </xsl:comment>
                    <xsl:choose>
                      <xsl:when test="boolean(ToTime)">
                        <statusCode code="completed"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <statusCode code="active"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:comment>  7.01 PROBLEM DATE (cda:low=Date of Onset, cda:high=Date Resolved), Optional R2 </xsl:comment>
                    <effectiveTime>
                      <xsl:choose>
                        <xsl:when test="boolean(FromTime)">
                          <low value="{translate(FromTime/text(), 'TZ:- ','')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <low nullFlavor="UNK"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="boolean(ToTime)">
                          <high value="{translate(ToTime/text(), 'TZ:- ','')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <high nullFlavor="UNK"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </effectiveTime>
                    <xsl:comment> 7.05 TREATING PROVIDER id link to HealthCare Provider Entry</xsl:comment>
                    <performer typeCode="PRF">
                      <assignedEntity>
                        <id nullFlavor="NA" root="2.16.840.1.113883.4.349"/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                        <addr/>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                        <telecom/>
                      </assignedEntity>
                    </performer>
                    <xsl:comment> INFORMATION SOURCE FOR PROBLEM, Optional </xsl:comment>
                    <author>
                      <xsl:comment> HITSP C32 V2.5:    Time as nullFlavor because VA VistA data not yet available </xsl:comment>
                      <time nullFlavor="UNK"/>
                      <assignedAuthor>
                        <id nullFlavor="NI"/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                        <addr/>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                        <telecom/>
                        <representedOrganization>
                          <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                          <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349"/>
                          <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                          <name>
                            <xsl:value-of select="EnteredAt/Description/text()"/>
                          </name>
                          <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                          <telecom/>
                          <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                          <addr/>
                        </representedOrganization>
                      </assignedAuthor>
                    </author>
                    <entryRelationship typeCode="SUBJ" inversionInd='false'>
                      <xsl:comment> CCD Problem observation - Required </xsl:comment>
                      <observation classCode="OBS" moodCode="EVN">
                        <xsl:comment> Problem observation template </xsl:comment>
                        <templateId root="2.16.840.1.113883.10.20.1.28"/>
                        <xsl:comment> HITSP V2.5:  C83 Templates for Problem Module/Entry </xsl:comment>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                        <xsl:comment> CCD Problem Obs ID as nullFlavor  </xsl:comment>
                        <id nullFlavor="UNK"/>
                        <xsl:comment> 7.02 PROBLEM TYPE, R2, SNOMED CT  </xsl:comment>
                        <xsl:comment> HITSP C32 V2.5:  7.02 PROBLEM TYPE, Optional SNOMED CT, provided as nullFalvor b/c data not yet available via VA VistA RPCs </xsl:comment>
                        <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                          <originalText>
                            <xsl:value-of select="Diagnosis/OriginalText/text()"/>
                          </originalText>
                        </code>
                        <xsl:comment> 7.03 PROBLEM NAME, REQUIRED </xsl:comment>
                        <text>
                          <reference value="concat('#pndProblem',position())"/>
                        </text>
                        <statusCode code="completed"/>
                        <xsl:comment> HITSP V2.5:  IHE Problem Templates Require low value entry </xsl:comment>
                        <effectiveTime>
                          <low nullFlavor="UNK"/>
                        </effectiveTime>
                        <xsl:comment>  7.04 PROBLEM CODE, Optional, When uncoded only xsi:type="CD" allowed, Available as ICD-9, not SNOMED CT,  </xsl:comment>
                        <xsl:comment> HITSP V2.5:  IHE Problem Templates Require value entry </xsl:comment>
                        <value xsi:type="CD">
                          <translation code="{Diagnosis/Code/text()}" codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM'/>
                        </value>
                        <xsl:comment>  7.12 PROBLEM STATUS entryRelationship block, Optional, </xsl:comment>
                        <entryRelationship typeCode="REFR">
                          <observation classCode="OBS" moodCode="EVN">
                            <xsl:comment> HITSP C32 V2.5:  CCD Problem status observation template </xsl:comment>
                            <templateId root='2.16.840.1.113883.10.20.1.50'/>
                            <code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status"/>
                            <statusCode code="completed"/>
                            <xsl:comment>  HITSP C32 V2.5: 7.12 PROBLEM STATUS  Optional, Translated ftom VistA value </xsl:comment>
                            <value xsi:type="CE" codeSystem="2.16.840.1.113883.6.96" >
                              <originalText/>
                            </value>
                          </observation>
                        </entryRelationship>
                      </observation>
                    </entryRelationship>
                  </act>
                </entry>
              </xsl:for-each>
            </section>
          </component>
          <xsl:comment>
            ********************************************************
            MEDICATIONS (RX &amp; Non-RX)  SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 3 </xsl:comment>
            <xsl:choose>
              <!-- TODO Meds Filtering [((OrderCategory/Code/text() = 'O RX' or OrderCategory/Code/text() = 'O') and isc:evaluate('dateDiff', 'mm', translate((Extension/LastFilled | Extension/Expires)/text(), 'TZ', ' ')) &lt; 16 and not(Status/text() = 'DELETED')) or (OrderCategory/Code/text() = 'NV RX' and not(Status/text() = 'DISCONTINUED'))]-->
              <xsl:when test="not(boolean(Medications/Medication))">
                <section nullFlavor="NI">
                  <xsl:comment> C-CDA Medications Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.1.1" extension="2014-06-09"/>
                  <templateId root="2.16.840.1.113883.10.20.22.2.1" />
                  <code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of medication use" />
                  <title>Medications: VA Dispensed and Non-VA Dispensed</title>
                  <xsl:comment> MEDICATIONS NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Medication Template Id</xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.8"/>
                  <xsl:comment> HITSP C32 V2.5:  Medications Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.112"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Medications Section Template </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.19"/>
                  <code code="10160-0" codeSystem="2.16.840.1.113883.6.1"/>
                  <title>Medications - Prescription and Non-Prescription</title>
                  <xsl:comment>  MEDICATIONS NARRATIVE BLOCK, REQUIRED </xsl:comment>
                  <text>
                    <xsl:comment> VLER SEG 1B: Medication Business Rules for Medical Content  </xsl:comment>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Department of Veterans Affairs</th>
                          <th>Business Rules for Construction of Medical Information</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>Medications</td>
                          <td>This section contains patient medications (outpatient and self-reported) information from all VA treatment facilities for which the dispense date was within the last 15 months. Only medications that have an active or non-active prescription status are listed.</td>
                        </tr>
                      </tbody>
                    </table>
                    <table ID="medicationNarritive" border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Medication</th>
                          <th>Status</th>
                          <th>Quantity</th>
                          <th>Order Expiration</th>
                          <th>Provider</th>
                          <th>Prescription</th>
                          <th>Dispense Date</th>
                          <th>Sig</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Medications/Medication">
                          <xsl:sort select="(DrugProduct/Description | OrderItem[not(preceding-sibling::DrugProduct/Description) and not(following-sibling::DrugProduct/Description)]/Description)" />
                          <xsl:sort select="PharmacyStatus" />
                          <tr>
                            <td>
                              <content ID="{concat('mndMedication', position())}">
                                <xsl:value-of select="(DrugProduct/Description | OrderItem[not(preceding-sibling::DrugProduct/Description) and not(following-sibling::DrugProduct/Description)]/Description)" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndStatus', position())}">
                                <xsl:choose>
                                  <xsl:when test="OrderCategory/Code/text() = 'NV RX'">
                                    Non-VA
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="PharmacyStatus/text()" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndQuantity', position())}">
                                <xsl:value-of select="OrderQuantity/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndOrderExpiration', position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="Extension/Expires/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                                </xsl:call-template>
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndProvider', position())}">
                                <xsl:if test="OrderCategory/Code/text() = 'NV RX'">
                                  Documented by: <br />
                                </xsl:if>
                                <xsl:value-of select="EnteredBy/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndPrescription', position())}">
                                <xsl:choose>
                                  <xsl:when test="OrderCategory/Code/text() = 'NV RX'">
                                    Non-VA
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="PrescriptionNumber/text()" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndDispenseDate', position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="Extension/LastFilled/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndSig', position())}">
                                <xsl:if test="OrderCategory/Code/text() = 'NV RX'">
                                  Documented by: <br />
                                </xsl:if>
                                <xsl:value-of select="EnteredBy/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndSource', position())}">
                                <xsl:if test="OrderCategory/Code/text() = 'NV RX'">
                                  Documented at: <br />
                                </xsl:if>
                                <xsl:value-of select="EnteredAt/Description/text()" />
                              </content>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:comment> C-CDA R2.1 Section Time Range, Optional </xsl:comment>
                  <xsl:for-each select="Medications/Medication">
                    <xsl:sort select="(DrugProduct/Description | OrderItem/Description)" />
                    <xsl:sort select="PharmacyStatus" />
                    <xsl:choose>
                      <xsl:when test="OrderCategory/Code/text() = 'O RX' or OrderCategory/Code/text() = 'O'">
                        <entry typeCode="DRIV">
                          <substanceAdministration classCode="SBADM" moodCode="EVN">
                            <xsl:comment> CCD Medication Act Template Id </xsl:comment>
                            <templateId root="2.16.840.1.113883.10.20.1.24"/>
                            <xsl:comment> HITSP V2.5:  Templates for Medications Module/Entry </xsl:comment>
                            <templateId root="2.16.840.1.113883.3.88.11.83.8"/>
                            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7"/>
                            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName="IHE PCC"/>
                            <xsl:comment> CCD Medication Act ID as nullflavor </xsl:comment>
                            <id nullFlavor="UNK"/>
                            <xsl:comment>   8.01 FREE TEXT SIG REFERENCE, Optional </xsl:comment>
                            <id assigningAuthorityName="Department of Veterans Affairs" extension="nullFlavor" root="2.16.840.1.113883.4.349"/>
                            <text>
                              <reference value="{concat('#mndSig',position())}" />
                            </text>
                            <statusCode code="completed"/>
                            <xsl:comment> 8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.03 ADMINISTRATION TIMING, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.04 FREQUENCY, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.05 INTERVAL, Optional,Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.06 DURATION, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.07 ROUTE, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.08 DOSE, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <consumable>
                              <manufacturedProduct>
                                <templateId root="2.16.840.1.113883.10.20.1.53"/>
                                <xsl:comment> HITSP C32 V2.5:  C83 Medication Templates </xsl:comment>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.2'/>
                                <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2'/>
                                <xsl:comment>  Added medications template </xsl:comment>
                                <templateId root="2.16.840.1.113883.3.88.11.32.9"/>
                                <xsl:comment> HITSP C32 V2.5:  C83 Manufactured Material Attributes </xsl:comment>
                                <manufacturedMaterial classCode='MMAT' determinerCode='KIND'>
                                  <xsl:comment>  8.13 CODED PRODUCT NAME, Optional-R2, UNII, RXNorm, NDF-RT, NDC Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                  <xsl:comment> 8.14 CODED BRAND NAME, Optional-R2, UNII, RXNorm, NDF-RT, NDC, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                  <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                  <!-- hkh: choose when/other selections provided below added to allow for CDA logic which includes coded entry if available....existing C32 uses only <code code="UNK" nullFlavor="UNK">  -->
                                  <xsl:choose>
                                    <xsl:when test="boolean(DrugProduct/Code)">
                                      <code code="UNK" nullFlavor="UNK">
                                        <!-- hkh: if desired, replace above with <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" code="{DrugProduct/Code/text()}" displayName="{DrugProduct/Description/text()}" > -->
                                        <originalText>
                                          <reference value="#mndMedication"/>
                                        </originalText>
                                      </code>
                                      <xsl:comment> 8.16 FREE TEXT BRAND NAME, Optional R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <code code="UNK" nullFlavor="UNK">
                                        <!-- hkh: if desired, replace above with <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" nullFlavor="UNK" > -->
                                        <originalText>
                                          <reference value="#mndMedication"/>
                                        </originalText>
                                      </code>
                                      <xsl:comment> 8.16 FREE TEXT BRAND NAME, Optional R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </manufacturedMaterial>
                              </manufacturedProduct>
                            </consumable>
                            <xsl:comment> INFORMATION SOURCE FOR MEDICATIONS, Optional </xsl:comment>
                            <author>
                              <time nullFlavor="UNK"/>
                              <assignedAuthor>
                                <id nullFlavor="NI"/>
                                <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                <addr/>
                                <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                <telecom/>
                                <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                                <assignedPerson>
                                  <name>
                                    <xsl:value-of select="EnteredBy/Description" />
                                  </name>
                                </assignedPerson>
                                <representedOrganization>
                                  <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                                  <id extension="" root="2.16.840.1.113883.4.349"/>
                                  <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description" />
                                  </name>
                                  <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                  <telecom/>
                                  <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                  <addr/>
                                </representedOrganization>
                              </assignedAuthor>
                            </author>
                            <entryRelationship typeCode='SUBJ'>
                              <observation classCode='OBS' moodCode='EVN'>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.1'/>
                                <xsl:comment> VLER SEG 1B:  8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <code codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'>
                                  <originalText>
                                    <value-of select="OrderCategory/OriginalText" />
                                  </originalText>
                                </code>
                                <statusCode code='completed'/>
                              </observation>
                            </entryRelationship>
                            <entryRelationship typeCode="REFR">
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.47"/>
                                <code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
                                <statusCode code="completed"/>
                                <xsl:comment> VLER SEG 1B: 8.20 STATUS OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <xsl:comment>  8.20 STATUS OF MEDICATION as originalText b/c SNOMED CT translation not yet available </xsl:comment>
                                <value xsi:type="CE">
                                  <!-- TODO: Need/Confirm Vets Translation of Status -->
                                  <originalText>
                                    <value-of select="PharmacyStatus" />
                                  </originalText>
                                </value>
                              </observation>
                            </entryRelationship>
                            <xsl:comment> 8.22 PATIENT INSTRUCTIONS, Optional ,  Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> ORDER INFORMATION </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <supply classCode="SPLY" moodCode="INT">
                                <templateId root="2.16.840.1.113883.10.20.1.34"/>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.3'/>
                                <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3'/>
                                <xsl:comment> VLER SEG 1B:  8.26 ORDER NUMBER, Optional-R2  </xsl:comment>
                                <id extension="{PlacerId/text()}" root="2.16.840.1.113883.4.349"/>
                                <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                                <effectiveTime value="{translate(Extension/LastFilled/text(),'TZ:- ','')}" />
                                <xsl:comment> VLER SEG 1B:  8.27 FILLS, Optional </xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(NumberOfRefills)">
                                    <repeatNumber value="{NumberOfRefills/text()}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <repeatNumber nullFlavor="UNK" />
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:comment> VLER SEG 8.28 Quantity Ordered omitted until unit of measure available in VistA </xsl:comment>
                                <xsl:comment>  8.31 ORDERING PROVIDER as author/assignedAuthor</xsl:comment>
                                <author>
                                  <xsl:comment>  VLER SEG 1B:  8.30 ORDER DATE/TIME, Optional-R2 </xsl:comment>
                                  <time value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                                  <assignedAuthor>
                                    <id nullFlavor="UNK"/>
                                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                    <addr/>
                                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                    <telecom/>
                                    <assignedPerson>
                                      <xsl:comment>  8.31 ORDERING PROVIDER, Optional </xsl:comment>
                                      <name>
                                        <xsl:value-of select="OrderedBy/Description/text()" />
                                      </name>
                                    </assignedPerson>
                                  </assignedAuthor>
                                </author>
                              </supply>
                            </entryRelationship>
                            <xsl:comment> FULFILLMENT HISTORY INFORMATION </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <supply classCode="SPLY" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.34"/>
                                <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                                <id extension="" root="2.16.840.1.113883.4.349"/>
                                <xsl:comment> 8.37 DISPENSE DATE, Optional-R2 </xsl:comment>
                                <xsl:if test="boolean(Extension/LastFilled)">
                                  <effectiveTime value="{translate(Extension/LastFilled/text(),'TZ:- ','')}"/>
                                </xsl:if>
                              </supply>
                            </entryRelationship>
                          </substanceAdministration>
                        </entry>
                      </xsl:when>
                      <xsl:otherwise>

                        <entry typeCode="DRIV">
                          <substanceAdministration classCode="SBADM" moodCode="EVN">
                            <xsl:comment> CCD Medication Act Template Id </xsl:comment>
                            <templateId root="2.16.840.1.113883.10.20.1.24"/>
                            <xsl:comment> HITSP V2.5:  Templates for Medications Module/Entry </xsl:comment>
                            <templateId root="2.16.840.1.113883.3.88.11.83.8"/>
                            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7"/>
                            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName="IHE PCC"/>
                            <xsl:comment> CCD Medication Act ID as nullflavor </xsl:comment>
                            <id nullFlavor="UNK"/>
                            <xsl:comment>   8.01 FREE TEXT SIG REFERENCE, Optional </xsl:comment>
                            <id assigningAuthorityName="Department of Veterans Affairs" extension="nullFlavor" root="2.16.840.1.113883.4.349"/>
                            <text>
                              <reference value="{concat('#mndSig',position())}" />
                            </text>
                            <statusCode code="completed"/>
                            <xsl:comment> 8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.03 ADMINISTRATION TIMING, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.04 FREQUENCY, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.05 INTERVAL, Optional,Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.06 DURATION, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.07 ROUTE, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> 8.08 DOSE, Optional, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <consumable>
                              <manufacturedProduct>
                                <templateId root="2.16.840.1.113883.10.20.1.53"/>
                                <xsl:comment> HITSP C32 V2.5:  C83 Medication Templates </xsl:comment>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.2'/>
                                <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.7.2'/>
                                <xsl:comment>  Added medications template </xsl:comment>
                                <templateId root="2.16.840.1.113883.3.88.11.32.9"/>
                                <xsl:comment> HITSP C32 V2.5:  C83 Manufactured Material Attributes </xsl:comment>
                                <manufacturedMaterial classCode='MMAT' determinerCode='KIND'>
                                  <xsl:comment>  8.13 CODED PRODUCT NAME, Optional-R2, UNII, RXNorm, NDF-RT, NDC Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                  <xsl:comment> 8.14 CODED BRAND NAME, Optional-R2, UNII, RXNorm, NDF-RT, NDC, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                  <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                  <!-- hkh: choose when/other selections provided below added to allow for CDA logic which includes coded entry if available....existing C32 uses only <code code="UNK" nullFlavor="UNK">  -->
                                  <xsl:choose>
                                    <xsl:when test="boolean(DrugProduct/Code)">
                                      <code code="UNK" nullFlavor="UNK">
                                        <!-- hkh: if desired, replace above with <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" code="{DrugProduct/Code/text()}" displayName="{DrugProduct/Description/text()}" > -->
                                        <originalText>
                                          <reference value="#mndMedication"/>
                                        </originalText>
                                      </code>
                                      <xsl:comment> 8.16 FREE TEXT BRAND NAME, Optional R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <code code="UNK" nullFlavor="UNK">
                                        <!-- hkh: if desired, replace above with <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" nullFlavor="UNK" > -->
                                        <originalText>
                                          <reference value="#mndMedication"/>
                                        </originalText>
                                      </code>
                                      <xsl:comment> 8.16 FREE TEXT BRAND NAME, Optional R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </manufacturedMaterial>
                              </manufacturedProduct>
                            </consumable>
                            <xsl:comment> INFORMATION SOURCE FOR MEDICATIONS, Optional </xsl:comment>
                            <author>
                              <time nullFlavor="UNK"/>
                              <assignedAuthor>
                                <id nullFlavor="NI"/>
                                <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                <addr/>
                                <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                <telecom/>
                                <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                                <assignedPerson>
                                  <name>
                                    <xsl:value-of select="EnteredBy/Description" />
                                  </name>
                                </assignedPerson>
                                <representedOrganization>
                                  <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                                  <id extension="" root="2.16.840.1.113883.4.349"/>
                                  <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description" />
                                  </name>
                                  <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                  <telecom/>
                                  <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                                  <addr/>
                                </representedOrganization>
                              </assignedAuthor>
                            </author>
                            <entryRelationship typeCode='SUBJ'>
                              <observation classCode='OBS' moodCode='EVN'>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.1'/>
                                <xsl:comment> VLER SEG 1B:  8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <!-- TODO: Add/Confirm VETS SNO Code -->
                                <code code="{OrderCategory/Code/text()}" codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'>
                                  <originalText>
                                    <value-of select="OrderCategory/OriginalText" />
                                  </originalText>
                                </code>
                                <statusCode code='completed'/>
                              </observation>
                            </entryRelationship>
                            <entryRelationship typeCode="REFR">
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.47"/>
                                <code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
                                <statusCode code="completed"/>
                                <xsl:comment> VLER SEG 1B: 8.20 STATUS OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <xsl:comment>  8.20 STATUS OF MEDICATION as originalText b/c SNOMED CT translation not yet available </xsl:comment>
                                <value xsi:type="CD">
                                  <!-- TODO: Need/Confirm Vets Translation of Status -->
                                  <originalText>
                                    <value-of select="PharmacyStatus" />
                                  </originalText>
                                </value>
                              </observation>
                            </entryRelationship>
                            <xsl:comment> 8.22 PATIENT INSTRUCTIONS, Optional ,  Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> ORDER INFORMATION </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <supply classCode="SPLY" moodCode="INT">
                                <templateId root="2.16.840.1.113883.10.20.1.34"/>
                                <templateId root='2.16.840.1.113883.3.88.11.83.8.3'/>
                                <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3'/>
                                <xsl:comment> VLER SEG 1B:  8.26 ORDER NUMBER, Optional-R2  </xsl:comment>
                                <id extension="{PlacerId/text()}" root="2.16.840.1.113883.4.349"/>
                                <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                                <effectiveTime xsi:type="IVL_TS">
                                  <low nullFlavor="UNK" />
                                  <high nullFlavor="UNK" />
                                </effectiveTime>
                                <xsl:comment> VLER SEG 1B:  8.27 FILLS, Optional </xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(NumberOfRefills)">
                                    <repeatNumber value="{NumberOfRefills/text()}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <repeatNumber nullFlavor="UNK" />
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:comment> VLER SEG 8.28 Quantity Ordered omitted until unit of measure available in VistA </xsl:comment>
                                <xsl:comment>  8.31 ORDERING PROVIDER as author/assignedAuthor</xsl:comment>
                                <author>
                                  <xsl:comment>  VLER SEG 1B:  8.30 ORDER DATE/TIME, Optional-R2 </xsl:comment>
                                  <time value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                                  <assignedAuthor>
                                    <id nullFlavor="UNK"/>
                                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                    <addr/>
                                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                                    <telecom/>
                                    <assignedPerson>
                                      <xsl:comment>  8.31 ORDERING PROVIDER, Optional </xsl:comment>
                                      <name>
                                        <xsl:value-of select="OrderedBy/Description/text()" />
                                      </name>
                                    </assignedPerson>
                                  </assignedAuthor>
                                </author>
                              </supply>
                            </entryRelationship>
                            <xsl:comment> FULFILLMENT HISTORY INFORMATION </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <supply classCode="SPLY" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.34"/>
                                <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                                <id nullFlavor="UNK" />
                                <xsl:comment> 8.37 DISPENSE DATE, Optional-R2 </xsl:comment>
                                <xsl:if test="boolean(Extension/LastFilled)">
                                  <effectiveTime value="{translate(Extension/LastFilled/text(),'TZ:- ','')}"/>
                                </xsl:if>
                              </supply>
                            </entryRelationship>
                          </substanceAdministration>
                        </entry>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment>
            ********************************************************
            VLER SEG 1B:  VITAL SIGNS SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 4 </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(Observations/Observation))">
                <section>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD Vital signs section template </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.16"/>
                  <xsl:comment> HITSP C32 V2.5:  HITSP CDA Vital Signs Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.119"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Coded Vital Signs Section Templates </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.25"/>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"/>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD 8716-3 LOINC Code for Physical Findings/Vital Signs </xsl:comment>
                  <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" displayName='VITAL SIGNS'/>
                  <title>Vital Signs</title>
                  <xsl:comment>  VITAL SIGNS NARRATIVE BLOCK , REQUIRED </xsl:comment>
                  <text>No Data Provided for this Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD Vital signs section template </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.16"/>
                  <xsl:comment> HITSP C32 V2.5:  HITSP CDA Vital Signs Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.119"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Coded Vital Signs Section Templates </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.25"/>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"/>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD 8716-3 LOINC Code for Physical Findings/Vital Signs </xsl:comment>
                  <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" displayName='VITAL SIGNS'/>
                  <title>Vital Signs</title>
                  <xsl:comment>  VITAL SIGNS NARRATIVE BLOCK , REQUIRED </xsl:comment>
                  <text>
                    <xsl:comment> VLER SEG 1B: Vital Signs Business Rules for Medical Content  </xsl:comment>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Department of Veterans Affairs</th>
                          <th>Business Rules for Construction of Medical Information</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>Vital Signs</td>
                          <td>This section contains information from the 5 most recent patient vital signs (inpatient and outpatient) from all VA treatment facilities for which the panel date taken was within the last 12 months. Note: If more than one panel was taken on the same date, only the most recent panel is populated for that date.</td>
                        </tr>
                      </tbody>
                    </table>
                    <table ID="vitalNarritive" border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Date</th>
                          <th>Measurements</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Observations/Observation[generate-id() = generate-id(key('vitals', GroupId)[1])]">
                          <xsl:sort select="ObservationTime" order="descending" />
                          <xsl:variable name="grp" select="GroupId/text()" />
                          <tr>
                            <td>
                              <content ID="{concat('vndDate', position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="ObservationTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                              </content>
                            </td>
                            <td>
                              <list>
                                <item>
                                  <content ID="{concat('vndMeasurement', position())}">
                                    <xsl:value-of select="ObservationCode/Description" />
                                    <xsl:value-of select="Observation/ObservationValue" />
                                    <xsl:value-of select="ObservationCode/ObservationValueUnits/Code" />
                                  </content>
                                </item>
                              </list>
                            </td>
                            <td>
                              <content ID="{concat('vndSource', position())}">
                                <xsl:value-of select="EnteredAt/Description" />
                              </content>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <xsl:comment>  CDA Observation Text as a Reference tag </xsl:comment>
                    <content ID="vital1" revised='delete' >Vital Sign Observation Text Not Available</content>
                  </text>
                  <xsl:for-each select="Observations/Observation[generate-id() = generate-id(key('vitals', GroupId)[1])]">
                    <xsl:sort select="ObservationTime" order="descending" />
                    <xsl:variable name="grp" select="GroupId/text()" />
                    <entry typeCode="DRIV">
                      <xsl:comment> Repeat Entry/Organizer block for each vital sign panel </xsl:comment>
                      <organizer classCode="CLUSTER" moodCode="EVN">
                        <xsl:comment> HITSP C32 V2.5:  ASTM/HL7 CCD Specification for Vital Signs, Organizer parent templates </xsl:comment>
                        <templateId root="2.16.840.1.113883.10.20.1.32"/>
                        <templateId root="2.16.840.1.113883.10.20.1.35"/>
                        <xsl:comment> HITSP C32 V2.5:  Vital Signs Organizer Template, REQUIRED </xsl:comment>
                        <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.1"/>
                        <xsl:comment> Vital Sign Organizer ID as nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
                        <id nullFlavor="UNK"/>
                        <code code='46680005' displayName='Vital signs' codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'/>
                        <statusCode code="completed"/>
                        <xsl:comment> HITSP C32 V2.5:  All Vital Signs Recorded on this date will be grouped under the observation block </xsl:comment>
                        <xsl:comment> HITSP C32 V2.5: if blank, then effectiveTime nullFlavor="UNK" </xsl:comment>
                        <xsl:choose>
                          <xsl:when test="boolean(ObservationTime)">
                            <effectiveTime>
                              <low value="{translate(ObservationTime/text(), 'TZ:-','')}"/>
                              <high value="{translate(ObservationTime/text(), 'TZ:-','')}"/>
                            </effectiveTime>
                          </xsl:when>
                          <xsl:otherwise>
                            <effectiveTime>
                              <low nullflavor="UNK"/>
                              <high nullflavor="UNK"/>
                            </effectiveTime>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:comment> INFORMATION SOURCE FOR VITAL SIGN ORGANIZER/PANEL, Optional </xsl:comment>
                        <author>
                          <time nullFlavor="UNK"/>
                          <assignedAuthor>
                            <id nullFlavor="NI"/>
                            <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                            <addr/>
                            <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                            <telecom/>
                            <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                            <assignedPerson>
                              <name>
                                <xsl:value-of select="EnteredBy/Description"/>
                              </name>
                            </assignedPerson>
                            <representedOrganization>
                              <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                              <id extension="" root="2.16.840.1.113883.4.349"/>
                              <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                              <name>
                                <xsl:value-of select="EnteredAt/Description"/>
                              </name>
                              <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                              <telecom/>
                              <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                              <addr/>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <xsl:for-each select="../Observation[GroupId = $grp]">
                          <xsl:comment> HITSP C32 V2.5:  One component block for each Vital Sign </xsl:comment>
                          <xsl:choose>
                            <xsl:when test="ObservationCode/Code = 4500634">
                              <xsl:call-template name="standard-vitalsStink">
                                <xsl:with-param name="grp" select="$grp" />
                                <xsl:with-param name="ob" select="." />
                                <xsl:with-param name="pressureIndex" select="'1'"/>
                              </xsl:call-template>
                              <xsl:call-template name="standard-vitalsStink">
                                <xsl:with-param name="grp" select="$grp" />
                                <xsl:with-param name="ob" select="." />
                                <xsl:with-param name="pressureIndex" select="'2'"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="ObservationCode/Code = 4500639">
                              <xsl:call-template name="standard-vitalsStink">
                                <xsl:with-param name="grp" select="$grp" />
                                <xsl:with-param name="ob" select="." />
                              </xsl:call-template>
                              <xsl:call-template name="standard-vitalsStink">
                                <xsl:with-param name="grp" select="$grp" />
                                <xsl:with-param name="ob" select="." />
                                <xsl:with-param name="isBMI" select="'true'" />
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:call-template name="standard-vitalsStink">
                                <xsl:with-param name="grp" select="$grp" />
                                <xsl:with-param name="ob" select="." />
                              </xsl:call-template>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </organizer>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment>
            ********************************************************
            VLER SEG 1B:  LAB RESULTS SECTION (Chemistry/Hematology)
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:choose>
              <xsl:when test="not(boolean(LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]))">
                <section nullFlavor="NI">
                  <xsl:comment> Component 5 </xsl:comment>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD Lab Results section template </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.14"/>
                  <xsl:comment> HITSP C32 V2.5:  HITSP CDA Diagniostic Results Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.122"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Coded Results Section Templates </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.28"/>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD 30954-2 LOINC Code (Required) for Diagnostic tests and/or Laboratory Data </xsl:comment>
                  <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data"/>
                  <title>Lab Results - Chemistry and Hematology</title>
                  <text>No Data Provided for This Section </text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> Component 5 </xsl:comment>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD Lab Results section template </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.14"/>
                  <xsl:comment> HITSP C32 V2.5:  HITSP CDA Diagniostic Results Section Template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.122"/>
                  <xsl:comment> HITSP C32 V2.5:  IHE Coded Results Section Templates </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.28"/>
                  <xsl:comment> HITSP C32 V2.5:  HL7 CCD 30954-2 LOINC Code (Required) for Diagnostic tests and/or Laboratory Data </xsl:comment>
                  <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data"/>
                  <title>Lab Results - Chemistry and Hematology</title>
                  <xsl:comment>  LAB RESULTS  NARRATIVE BLOCK , REQUIRED </xsl:comment>
                  <text>
                    <xsl:comment> VLER SEG 1B: Lab Results Business Rules for Medical Content  </xsl:comment>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Department of Veterans Affairs</th>
                          <th>Business Rules for Construction of Medical Information</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>Lab Results</td>
                          <td>This section contains the 10 most recent patient Chemistry and Hematology lab results from all VA treatment facilities for which the result date was within the last 12 months.</td>
                        </tr>
                      </tbody>
                    </table>
                    <table ID="labNarritive" border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Result Type</th>
                          <th>Source</th>
                          <th>Result - Unit</th>
                          <th>Interpretation</th>
                          <th>Reference Range</th>
                          <th>Status</th>
                          <th>Comment</th>
                        </tr>
                      </thead>
                      <xsl:for-each select="LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]">
                        <xsl:sort select="FromTime" order="descending" />
                        <xsl:variable name="lid" select="position()" />
                        <tbody>
                          <tr ID="{concat('labTest',position())}">
                            <td>
                              <xsl:call-template name="tmpDateTemplate" >
                                <xsl:with-param name="date-time" select="FromTime/text()" />
                                <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                              </xsl:call-template>
                            </td>
                            <td colspan="4">
                              <content ID="{concat('lndResultType',position())}">
                                <xsl:value-of select="OrderItem/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('lndSource',position())}">
                                <xsl:value-of select="EnteredAt/Description/text()" />
                              </content>
                            </td>
                            <!-- hkh: check to see if next three should be empty or removed (not present in CDA code) -->
                            <td>
                              <content />
                            </td>
                            <td>
                              <content />
                            </td>
                            <td>
                              <content />
                            </td>
                            <td>
                              <content>completed</content>
                            </td>
                            <td>
                              <content ID="{concat('lndComment',position())}">
                                <xsl:choose>
                                  <xsl:when test="boolean(Specimen)">
                                    Specimen Type: <xsl:value-of select="Specimen" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    Specimen Type: Not Available.
                                  </xsl:otherwise>
                                </xsl:choose>
                                <br />
                                <xsl:choose>
                                  <xsl:when test="boolean(Result/Comments)">
                                    Comment: <xsl:value-of select="Result/Comments" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    No comment entered.
                                  </xsl:otherwise>
                                </xsl:choose>
                                <br />
                                <xsl:choose>
                                  <xsl:when test="boolean(OrderedBy)">
                                    Ordering Provider: <xsl:value-of select="OrderedBy/Description" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    No Provider, they just decided to do this themselves.
                                  </xsl:otherwise>
                                </xsl:choose>
                                <br />
                                <xsl:choose>
                                  <xsl:when test="boolean(AuthorizationTime)">
                                    Report Released Date Time: <xsl:value-of select="AuthorizationTime" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    Not yet released.
                                  </xsl:otherwise>
                                </xsl:choose>
                                <br />
                                <xsl:choose>
                                  <xsl:when test="boolean(EnteredAt)">
                                    Performing Lab: <xsl:value-of select="EnteredAt/Description" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    No lab. Guy on the street did it. Free!
                                  </xsl:otherwise>
                                </xsl:choose>
                              </content>
                            </td>
                          </tr>
                          <xsl:for-each select="Result/ResultItems/LabResultItem">
                            <tr >
                              <td />
                              <td />
                              <td>
                                <content ID="{concat('loincLabValues',$lid,'-',position())}">
                                  <xsl:value-of select="TestItemCode/Description/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('resultLabValues',$lid,'-',position())}">
                                  <xsl:value-of select="ResultValue/text()" />
                                  <xsl:value-of select="ResultValueUnits/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('interpLabValues',$lid,'-',position())}">
                                  <xsl:value-of select="ResultInterpretation/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('rangeLabValues',$lid,'-',position())}">
                                  <xsl:value-of select="isc:evaluate('strip', ResultNormalRange/text(),'P')" />
                                </content>
                              </td>
                              <td/>
                            </tr>
                          </xsl:for-each>
                        </tbody>
                      </xsl:for-each>
                    </table>
                    <xsl:comment>  CDA Observation Text as a Reference tag </xsl:comment>
                    <xsl:comment> IHE Simple Observations Text Element Required, For 15.03-LAB RESULT TYPE  Static "Observation Text Not Available" </xsl:comment>
                    <content ID="lab-1" revised="delete">Result Observation Text Not Available</content>
                    <xsl:comment> IHE Procedure Text Element Required,  Static "Procedure Text Not Available" </xsl:comment>
                    <content ID="labproc1" revised="delete">Result Procedure Text Not Available</content>
                  </text>
                  <entry>
                    <xsl:comment> Do Not Repeat per Result  </xsl:comment>
                    <xsl:comment> Required IHE Procedure Entry element, REQUIRED </xsl:comment>
                    <xsl:comment> HITSP 32 V2.5:  IHE Proceure Element Required, but data not available through VistA RPCs </xsl:comment>
                    <procedure classCode='PROC' moodCode="EVN">
                      <templateId root="2.16.840.1.113883.3.88.11.83.17" assigningAuthorityName="HITSP C83"/>
                      <templateId root="2.16.840.1.113883.10.20.1.29" assigningAuthorityName="CCD"/>
                      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.19" assigningAuthorityName="IHE PCC"/>
                      <id nullFlavor="UNK"/>
                      <code nullFlavor="UNK">
                        <originalText>
                          <reference value="#labproc1"/>
                        </originalText>
                      </code>
                      <text>
                        <reference value="#labproc1"/>
                      </text>
                      <statusCode code='completed'/>
                    </procedure>
                  </entry>
                  <xsl:comment> Required IHE Simple Oberservation Entry element </xsl:comment>
                  <xsl:for-each select="LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]">
                    <xsl:sort select="FromTime" order="descending" />
                    <xsl:variable name="lid" select="position()" />
                    <entry typeCode="DRIV">
                      <xsl:comment> VLER 1Bii:  Lab Result Organizer, Reapeats for Each VA Order </xsl:comment>
                      <organizer classCode="BATTERY" moodCode="EVN">
                        <xsl:comment> HL7 CCD Lab Result Organizer Template, Required  </xsl:comment>
                        <templateId root="2.16.840.1.113883.10.20.1.32"/>
                        <xsl:comment> Lab Result Organizer Id </xsl:comment>
                        <!-- hkh:TODO - need extension if available to replace line below <id root="2.16.840.1.113883.4.349" extension="labOrgId"/>  -->
                        <id nullFlavor="NI" />
                        <xsl:comment> Lab Result Organizer Code</xsl:comment>
                        <code nullFlavor="UNK">
                          <originalText>
                            <xsl:value-of select="OrderItem/Description" />
                          </originalText>
                        </code>
                        <xsl:comment> Lab Result Organizer Status, static</xsl:comment>
                        <statusCode code="completed"/>
                        <xsl:comment> Lab Result Organizer  Date/Time</xsl:comment>
                        <effectiveTime>
                          <xsl:choose>
                            <xsl:when test="boolean(SpecimenCollectedTime)">
                              <low value="{translate(SpecimenCollectedTime/text(),'TZ:- ','')}"/>
                              <high value="{translate(SpecimenCollectedTime/text(),'TZ:- ','')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <low nullFlavor="UNK"/>
                              <high nullFlavor="UNK"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </effectiveTime>
                        <xsl:comment> INFORMATION SOURCE FOR LAB RESULT ORGANIZER, Optional </xsl:comment>
                        <author>
                          <time nullFlavor="UNK"/>
                          <assignedAuthor>
                            <id nullFlavor="NI"/>
                            <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                            <addr/>
                            <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                            <telecom/>
                            <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                            <assignedPerson>
                              <name>
                                <xsl:value-of select="EnteredBy/Description"/>
                              </name>
                            </assignedPerson>
                            <representedOrganization>
                              <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                              <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349"/>
                              <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                              <name>
                                <xsl:value-of select="EnteredAt/Description"/>
                              </name>
                              <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                              <telecom/>
                              <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                              <addr/>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <xsl:for-each select="Result/ResultItems/LabResultItem">
                          <component>
                            <xsl:comment> Component Repeats for Each VA Test Result </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <xsl:comment> Result observation template </xsl:comment>
                              <templateId root="2.16.840.1.113883.10.20.1.31"/>
                              <templateId root='2.16.840.1.113883.3.88.11.83.15'/>
                              <templateId root='2.16.840.1.113883.3.88.11.83.15.1'/>
                              <xsl:comment> IHE Simple Observation template </xsl:comment>
                              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
                              <xsl:comment>  HITSP C32 V2.5:  15.01-LAB RESULT ID, REQUIRED  </xsl:comment>
                              <xsl:comment> 15.01-LAB RESULT ID  </xsl:comment>
                              <id root="2.16.840.1.113883.4.349" extension="{ExternalId/text()}"/>
                              <xsl:comment> HITSP C32 V2.5:  15.03-LAB RESULT TYPE, REQUIRED, LOINC  </xsl:comment>
                              <xsl:comment> 15.03-LAB RESULT TYPE,  Adapter must obtain LOINC Code Long Common Name from LOINC DB  </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(ResultCodedValue)">
                                  <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="{ResultCodedValue/Code/text()}" displayName="{ResultCodedValue/Description/text()}">
                                    <originalText>
                                      <reference value="{concat('#loincLabValues',$lid,'-',position())}"/>
                                    </originalText>
                                  </code>
                                </xsl:when>
                                <xsl:otherwise>
                                  <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" nullFlavor="UNK">
                                    <originalText>
                                      <reference value="{concat('#loincLabValues',$lid,'-',position())}"/>
                                    </originalText>
                                  </code>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:comment> IHE Simple Observations Text element Required </xsl:comment>
                              <text>
                                <reference value="{concat('#labTest',$lid)}"/>
                              </text>
                              <xsl:comment> HITSP C32 V2.5:  15.04-RESULT STATUS, REQUIRED, IHE Requires Static value of completed  </xsl:comment>
                              <statusCode code="completed"/>
                              <xsl:comment> HITSP C32 V2.5:  15.02-RESULT DATE/TIME, REQURIED  </xsl:comment>
                              <xsl:comment> HITSP C32 V2.5: if blank, then effectiveTime nullFlavor="UNK" </xsl:comment>
                              <effectiveTime value="{translate(ObservationTime/text(), 'TZ:- ','')}"/>
                              <xsl:comment> HITSP C32 V2.5:  15.05- RESULT VALUE, CONDITIONAL REQUIRED when moodCode=EVN  </xsl:comment>
                              <xsl:comment> HITSP C32 V2.5:  15.05- RESULT VALUE, Sent as String (not INT) for VistA results that are POS, NEG, pending </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(ResultValueUnits) and number(ResultValue/text()) = ResultValue/text()">
                                  <value xsi:type="PQ" value="{ResultValue/text()}" unit="{ResultValueUnits/text()}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <value xsi:type="ST" representation="TXT">
                                    <xsl:value-of select="ResultValue"/>
                                    <xsl:value-of select="ResultValueUnits"/>
                                  </value>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:comment> HITSP C32 V2.5:  15.06-RESULT INTERPRETATION, Optional, Translation to HL7 Result Normalcy Status Value Set not yet available </xsl:comment>
                              <xsl:comment> If 15.06-RESULT INTERPRETATION is blank, omit XML tags </xsl:comment>
                              <xsl:comment> interpretationCode code="H" codeSystem="2.16.840.1.113883.1.11.78" codeSystemName="HL7 Result Normalcy Status Value Set" displayName="High"/ </xsl:comment>
                              <interpretationCode nullFlavor="UNK">
                                <originalText>
                                  <reference value="{concat('#interpLabValues',$lid,'-',position())}"/>
                                </originalText>
                              </interpretationCode>
                              <xsl:comment> COMMENT FOR LAB RESULT, Optional </xsl:comment>
                              <entryRelationship typeCode='SUBJ' inversionInd='true'>
                                <act classCode='ACT' moodCode='EVN'>
                                  <templateId root='2.16.840.1.113883.10.20.1.40'/>
                                  <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.2'/>
                                  <code code='48767-8' displayName='Annotation Comment' codeSystem="2.16.840.1.113883.6.1" codeSystemName='LOINC' />
                                  <xsl:comment> COMMENT REFERENCE points to Narrative Block </xsl:comment>
                                  <text>
                                    <reference value="{concat('#lndComment',position())}"/>
                                  </text>
                                  <statusCode code='completed' />
                                  <author>
                                    <time nullFlavor="UNK"/>
                                    <assignedAuthor>
                                      <id nullFlavor="NI"/>
                                      <addr/>
                                      <telecom/>
                                      <assignedPerson>
                                        <name/>
                                      </assignedPerson>
                                      <representedOrganization>
                                        <name/>
                                        <telecom/>
                                        <addr/>
                                      </representedOrganization>
                                    </assignedAuthor>
                                  </author>
                                </act>
                              </entryRelationship>
                              <xsl:comment> HITSP C32 V2.5: 15.07-RESULT REFERENCE RANGE, Optional, Lo:Hi </xsl:comment>
                              <xsl:comment> If 15.07-RESULT REFERENCE RANGE is blank, omit XML tags </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(ResultValueUnits) and boolean(ResultNormalRange) and contains(ResultNormalRange, '-')">
                                  <referenceRange>
                                    <observationRange>
                                      <text>
                                        <reference value="{concat('#rangeLabValues',$lid,'-',position())}"/>
                                      </text>
                                      <value xsi:type="IVL_PQ">
                                        <low value="{isc:evaluate('piece', ResultNormalRange/text(), '-', 1)}"/>
                                        <high value="{isc:evaluate('piece', ResultNormalRange/text(), '-', 2)}"/>
                                      </value>
                                    </observationRange>
                                  </referenceRange>
                                </xsl:when>
                                <xsl:otherwise>
                                  <referenceRange>
                                    <observationRange>
                                      <text>
                                        <reference nullFlavor="NI"/>
                                      </text>
                                      <value xsi:type="IVL_PQ">
                                        <low nullFlavor="NI"/>
                                        <high nullFlavor="NI"/>
                                      </value>
                                    </observationRange>
                                  </referenceRange>
                                </xsl:otherwise>
                              </xsl:choose>
                            </observation>
                          </component>
                        </xsl:for-each>
                      </organizer>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment>
            ********************************************************
            VLER SEGMENT 1B:  IMMUNIZATION SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 6 </xsl:comment>
            <section>
              <xsl:comment> Immunizations section template </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.1.6"/>
              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.23"/>
              <templateId root="2.16.840.1.113883.3.88.11.83.117"/>

              <code code='11369-6' displayName=' History of immunizations ' codeSystem='2.16.840.1.113883.6.1' codeSystemName='LOINC'/>
              <title>Immunizations</title>
              <xsl:comment>  IMMUNIZATIONS NARRATIVE BLOCK , REQUIRED </xsl:comment>
              <text>
                <xsl:comment> VLER SEG 1B: Immunization Business Rules for Medical Content  </xsl:comment>
                <table border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Department of Veterans Affairs</th>
                      <th>Business Rules for Construction of Medical Information</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Immunizations</td>
                      <td>This section contains patient immunizations information from all VA treatment facilities. Only administred (i.e., not refused) immunizations are included.</td>
                    </tr>
                  </tbody>
                </table>
                <table ID="immunizationNarritive" border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Immunization</th>
                      <th>Series</th>
                      <th>Date Issued</th>
                      <th>Reaction</th>
                      <th>Comments</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="indImmunization" />
                      </td>
                      <td>
                        <content ID="indSeries" />
                      </td>
                      <td>
                        <content ID="indDateIssued" />
                      </td>
                      <td>
                        <content ID="indReaction" />
                      </td>
                      <td>
                        <content ID="indComments" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode="DRIV">
                <xsl:comment> Repeat entry/substanceAdminstration block for each Immunization </xsl:comment>
                <xsl:comment> 13.01-REFUSAL, REQUIRED, static value of "false" </xsl:comment>
                <xsl:comment> HITSP C32 V2.5:  HL7 CDA R2-If Immunization was administered, @negationInd=false </xsl:comment>
                <substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">
                  <xsl:comment> HITSP C32 V2.5:  Immunization Templates  </xsl:comment>
                  <templateId root='2.16.840.1.113883.10.20.1.24'/>
                  <templateId root='2.16.840.1.113883.3.88.11.83.13'/>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.12"/>
                  <xsl:comment> HITSP C32 V2.5: Immunization Id as nullFlavor  </xsl:comment>
                  <id nullFlavor="UNK"/>
                  <code code='IMMUNIZ' codeSystem='2.16.840.1.113883.5.4' codeSystemName='ActCode'/>
                  <xsl:comment> COMMENT REFERENCE points to Narrative Block </xsl:comment>
                  <text>
                    <reference value="#indComments"/>
                  </text>
                  <statusCode code="completed"/>
                  <xsl:comment> 13.02-ADMINISTERED DATE, REQUIRED,  </xsl:comment>
                  <effectiveTime value=""/>
                  <consumable>
                    <xsl:comment> HITSP C32 V2.5:  Immunization Medication  </xsl:comment>
                    <manufacturedProduct>
                      <xsl:comment> Product template </xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.1.53"/>
                      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2"/>
                      <id nullFlavor="UNK"/>
                      <!-- <manufacturedLabeledDrug></manufacturedLabeledDrug> -->
                      <manufacturedMaterial>
                        <xsl:comment> 13.06-CODED PRODUCT NAME, Optional, nullFlavor b/c data not yet available thru VistA RPCs </xsl:comment>
                        <xsl:comment> HITSP C32 V2.5:  CODED PRODUCT NAME, Optional, Requires CVX-Vaccines Adminstered , VA provides CPT-4</xsl:comment>
                        <code code="UNK" nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.59" codeSystemName="CVX">
                          <xsl:comment> 13.07-FREE TEXTPRODUCT NAME, REQUIRED, Pointer to Narrative Block  </xsl:comment>
                          <originalText>
                            <reference value="#indImmunization"/>
                          </originalText>
                          <translation code='' displayName='' codeSystem='2.16.840.1.113883.6.12' codeSystemName='Current Procedural Terminology (CPT�) Fourth Edition (CPT-4)'/>
                        </code>
                        <xsl:comment> 13.09-LOT NUMBER, Optional, XML omitted b/c not yet  data available thru VistA RPCs </xsl:comment>
                      </manufacturedMaterial>
                      <manufacturerOrganization>
                        <xsl:comment> 13.08 DRUG MANUFACTURER, Optional, XML omitted b/c not yet data available thru VistA RPCs </xsl:comment>
                      </manufacturerOrganization>
                    </manufacturedProduct>
                  </consumable>
                  <xsl:comment> 13.05-PERFORMER, Optional  </xsl:comment>
                  <performer typeCode="PRF">
                    <xsl:comment> Provider Template Id  </xsl:comment>
                    <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
                    <time>
                      <high nullFlavor="UNK"/>
                    </time>
                    <assignedEntity>
                      <xsl:comment> Provider ID, extension = Provider ID, root=VA OID  </xsl:comment>
                      <id extension="providerID" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <assignedPerson>
                        <name/>
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment> INFORMATION SOURCE FOR IMMUNIZATION, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="UNK"/>
                    <assignedAuthor>
                      <id nullFlavor="NI"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                      <assignedPerson>
                        <name/>
                      </assignedPerson>
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                        <id extension="" root="2.16.840.1.113883.4.349"/>
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                        <name/>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <telecom/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <addr/>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment> HITSP C32 V2.5:  Immunization Medication Series Nbr </xsl:comment>
                  <entryRelationship typeCode='SUBJ'>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root='2.16.840.1.113883.10.20.1.46'/>
                      <xsl:comment> HITSP C32 V2.5:  Required Code under Observation </xsl:comment>
                      <code code='30973-2' displayName='Dose Number' codeSystem='2.16.840.1.113883.6.1' codeSystemName='LOINC'/>
                      <xsl:comment> HITSP C32 V2.5:  Required statusCode under Observation </xsl:comment>
                      <statusCode code='completed'/>
                      <xsl:comment> 13.03-MEDICATION SERIES NUMBER,  Optional, Sent as STring not INTeger  to accommodate VA VistA data such as P-Partial, B-Booster, C-Complete </xsl:comment>
                      <value xsi:type="INT"/>
                    </observation>
                  </entryRelationship>
                  <xsl:comment> HITSP C32 V2.5:  Immunization Reaction  </xsl:comment>
                  <entryRelationship typeCode='CAUS' inversionInd="false">
                    <xsl:comment> Repeat entryRelationship/observation block for each immuniz reaction </xsl:comment>
                    <observation classCode='OBS' moodCode='EVN'>
                      <templateId root='2.16.840.1.113883.10.20.1.28'/>
                      <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                      <templateId root='2.16.840.1.113883.10.20.1.54'/>
                      <xsl:comment> 13.04-REACTION,  Optional, Repeatable </xsl:comment>
                      <id nullFlavor="UNK"/>
                      <xsl:comment> HITSP C32 V2.5:  Required Code under Observation </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <xsl:comment> HITSP C32 V2.5:  Required statusCode under Observation </xsl:comment>
                      <xsl:comment> 13.04-REACTION,  Pointer to IMMUNIZATION NARRATIVE BLOCK not Allergy Entry per IHE Template </xsl:comment>
                      <text>
                        <reference/>
                      </text>
                      <statusCode code='completed'/>
                      <xsl:comment> HITSP C32 V2.5:  IHE Template requires low value entry </xsl:comment>
                      <effectiveTime>
                        <low nullFlavor="UNK"/>
                      </effectiveTime>
                      <xsl:comment> HITSP C32 V2.5:  IHE Template requires value entry </xsl:comment>
                      <value xsi:type="CD" nullFlavor="UNK"/>
                    </observation>
                  </entryRelationship>
                </substanceAdministration>
              </entry>
            </section>
          </component>
          <xsl:comment>
            ********************************************************
            NHIN_CR_101, CR100
            VLER Segment 1Bii:  ENCOUNTER SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 7 </xsl:comment>
            <section>
              <xsl:comment>CCD Encounters Section Conformance Identifier</xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.1.3" />
              <xsl:comment>C83 Encounters Section Conformance Identifier</xsl:comment>
              <templateId root="2.16.840.1.113883.3.88.11.83.127" />
              <xsl:comment>IHE Encounters History Section Conformance Identifier</xsl:comment>
              <templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3" />
              <code code="46240-8" displayName="History of Encounters" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
              <title>History of Encounters</title>
              <xsl:comment>  ENCOUNTER NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VLER SEG 1B: Encounter Business Rules for Medical Content  </xsl:comment>
                <table border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Department of Veterans Affairs</th>
                      <th>Business Rules for Construction of Encounter Information</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Encounters</td>
                      <td>This section contains information for all outpatient encounters (completed) for the patient from all VA treatment facilities for which the encounter date was within the last 36 months. Note: Ancillary visits are not included.</td>
                    </tr>
                  </tbody>
                </table>
                <table ID="encounterNarritive" border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Date Time</th>
                      <th>Encounter Type</th>
                      <th>Encounter Description</th>
                      <th>Reason</th>
                      <th>Arrival</th>
                      <th>Departure</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="endDateTime" />
                      </td>
                      <td>
                        <content ID="endEncounterType" />
                      </td>
                      <td>
                        <content ID="endEncounterDescription"/>
                      </td>
                      <td>
                        <content ID="endReason" />
                      </td>
                      <td>
                        <content ID="endArrival" />
                      </td>
                      <td>
                        <content ID="endDeparture" />
                      </td>
                      <td>
                        <content ID="endProvider" />
                      </td>
                      <td>
                        <content ID="endSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment>  CDA Observation Text as a Reference tag </xsl:comment>
                <content ID='encNote-1' revised="delete">IHE Encounter Template Text not used by VA</content>
              </text>
              <entry>
                <xsl:comment> Entry block repeats for each Encounter </xsl:comment>
                <encounter classCode="ENC" moodCode="EVN">
                  <xsl:comment>CCD Encounter Activity</xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.21" />
                  <xsl:comment>C83 Encounter Entry</xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.16"/>
                  <xsl:comment>IHE Encounter Entry</xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
                  <xsl:comment>16.01 - ENCOUNTER ID,  REQUIRED </xsl:comment>
                  <id nullFlavor="UNK" />
                  <!--
                                        <id root="2.16.840.1.113883.4.349" extension="enc1234"/>
                                    -->
                  <xsl:comment>16.02 - ENCOUNTER TYPE, R2-Optional,  VA Provides CPT </xsl:comment>
                  <xsl:comment>16.02 - When CPT code not present, then code nullFlavor="UNK" </xsl:comment>
                  <code code="encCode" displayName="encDisplay" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment>16.03 - ENCOUNTER FREE TEXT TYPE, REQUIRED</xsl:comment>
                    <originalText>
                      <reference value="#endEncounterDescription"/>
                    </originalText>
                  </code>
                  <xsl:comment> Required per IHE Template, not use by VA  </xsl:comment>
                  <text>
                    <reference value="#encNote-1" />
                  </text>
                  <xsl:comment>16.04 - ENCOUNTER DATE / TIME, REQUIRED</xsl:comment>
                  <effectiveTime>
                    <low value="encTime" />
                  </effectiveTime>
                  <xsl:comment>16.07 - ADMISSION TYPE, Optional,  VA VistA Data not yet available </xsl:comment>
                  <priorityCode nullFlavor="UNK"/>
                  <xsl:comment>16.05 - ENCOUNTER PROVIDER, R2-Optional </xsl:comment>
                  <performer typeCode="PRF">
                    <xsl:comment> Provider Template Id  </xsl:comment>
                    <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
                    <time>
                      <high nullFlavor="UNK"/>
                    </time>
                    <assignedEntity>
                      <xsl:comment> Provider ID nullFlavor="UNK" b/c VA VistA data not yet available </xsl:comment>
                      <id nullFlavor="UNK"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <assignedPerson>
                        <name>encProvider</name>
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment> INFORMATION SOURCE FOR ENCOUNTER, Optional </xsl:comment>
                  <author>
                    <xsl:comment>  ADD TIME TO INFORMATION SOURCE FOR ENCOUNTER </xsl:comment>
                    <time nullFlavor="UNK"/>
                    <assignedAuthor>
                      <id nullFlavor="NI"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                      <assignedPerson>
                        <name/>
                      </assignedPerson>
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349"/>
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                        <name>facilityName</name>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <telecom/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <addr/>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <templateId root="2.16.840.1.113883.10.20.1.45" />
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low value="arrTime" />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high value="departTime" />
                    </time>
                    <participantRole classCode="SDLOC">
                      <playingEntity classCode="PLC"/>
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5" />
                      <templateId root="2.16.840.1.113883.10.20.1.28" />
                      <id nullFlavor="UNK" />
                      <code nullFlavor="UNK"/>
                      <xsl:comment>16.13 - REASON FOR VISIT, Optional </xsl:comment>
                      <text>
                        <reference value="#endReason" />
                      </text>
                      <statusCode code="completed" />
                      <effectiveTime>
                        <low nullFlavor="UNK"/>
                      </effectiveTime>
                      <value xsi:type="CD" />
                    </observation>
                  </entryRelationship>
                </encounter>
              </entry>
            </section>
          </component>
          <xsl:comment>
            ********************************************************
            NHIN_CR95, CR94
            VLER Segment 1Bii:  PROCEDURE SECTION
            ********************************************************
          </xsl:comment>
          <component>
            <xsl:comment> Component 8 </xsl:comment>
            <section>
              <xsl:comment> Procedures section template </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.1.12"/>
              <code code="47519-4" codeSystem="2.16.840.1.113883.6.1"/>
              <title>History of Procedures</title>
              <xsl:comment> PROCEDURE NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VLER SEG 1Bii: Procedure Business Rules for Medical Content  </xsl:comment>
                <table border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Department of Veterans Affairs</th>
                      <th>Business Rules for Construction of Procedure Information</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Procedures</td>
                      <td>This section contains information for the 25 most recent historical (completed) surgical and radiological procedures for the patient from all VA treatment facilities for which the procedure date was within the last 12 months.</td>
                    </tr>
                  </tbody>
                </table>
                <table ID="procedureNarritive" border="1" width="100%">
                  <thead>
                    <tr>
                      <th>Date Time</th>
                      <th>Procedure Type</th>
                      <th>Qualifiers</th>
                      <th>Description</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="prndDateTime" />
                      </td>
                      <td>
                        <content ID="prndProcedureType" />
                      </td>
                      <td>
                        <list>
                          <item>
                            <content ID="prndQualifiers" />
                          </item>
                        </list>
                      </td>
                      <td>
                        <content ID="prndDescription" />
                      </td>
                      <td>
                        <content ID="prndProvider" />
                      </td>
                      <td>
                        <content ID="prndSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode="DRIV">
                <xsl:comment> HITSP C32 V2.5:  Entry block Repeats for Each Procedure </xsl:comment>
                <procedure classCode="PROC" moodCode="EVN">
                  <xsl:comment> HITSP C32 V2.5: Procedures entries template </xsl:comment>
                  <templateId root="2.16.840.1.113883.3.88.11.83.17"/>
                  <xsl:comment> Procedure activity template </xsl:comment>
                  <xsl:comment> IHE: Procedures entries template </xsl:comment>
                  <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.19"/>
                  <xsl:comment> IHE: Procedures entries template for EVN </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.1.29"/>
                  <xsl:comment> HITSP C32 V2.5: 17.01-PROCEDURE ID, REQUIRED </xsl:comment>
                  <xsl:comment> 17.01-Provider ID nulFlavor="UNK" b/c VA VistA data not yet available </xsl:comment>
                  <id nullFlavor="UNK"/>
                  <xsl:comment> HITSP C32 V2.5: 17.02-PROCEDURE TYPE, R2-Optional, VA provides CPT code </xsl:comment>
                  <code code="procCode" displayName="procDisplay" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> HITSP C32 V2.5: Reference to 17.03-PROCEDURE FREE TEXT TYPE, REQUIRED </xsl:comment>
                    <originalText>
                      <reference value="#prndDescription"/>
                    </originalText>
                    <xsl:comment> MODIFIERS for 17.02-PROCEDURE TYPE, Surgery=Other Procedure CPT Code, Radiology=CPT Modifier </xsl:comment>
                    <qualifier>
                      <xsl:comment> qualifier block repeats for each CPT Modifier </xsl:comment>
                      <name nullFlavor="UNK" displayName="qualType"/>
                      <value code="qualCode" displayName="qualDisplay"/>
                    </qualifier>
                  </code>
                  <text>
                    <reference nullFlavor="UNK"/>
                  </text>
                  <statusCode code="completed"/>
                  <xsl:comment> HITSP C32 V2.5: 17.04-PROCEDURE DATE/TIME, R2-Optional </xsl:comment>
                  <effectiveTime value="procTime"/>
                  <xsl:comment> HITSP C32 V2.5: 17.06-BODY SITE, R2-Optional, SNOMED CT </xsl:comment>
                  <xsl:comment> 17.06-BODY SITE nullFlavor="UNK" b/c VA VistA data not yet available </xsl:comment>
                  <targetSiteCode nullFlavor="UNK"/>
                  <xsl:comment> HITSP C32 V2.5: 17.05-PROCEDURE PROVIDER, R2-Optional, SNOMED CT </xsl:comment>
                  <performer typeCode="PRF">
                    <xsl:comment> Provider Template Id  </xsl:comment>
                    <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
                    <time>
                      <high nullFlavor="UNK"/>
                    </time>
                    <assignedEntity>
                      <xsl:comment> Provider ID nulFlavor="UNK" b/c VA VistA data not yet available </xsl:comment>
                      <id nullFlavor="UNK"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <assignedPerson>
                        <name/>
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment> INFORMATION SOURCE FOR PROCEDURE, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="UNK"/>
                    <assignedAuthor>
                      <id nullFlavor="NI"/>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <addr/>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                      <telecom/>
                      <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                      <assignedPerson>
                        <name/>
                      </assignedPerson>
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349"/>
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                        <name>facilityName</name>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <telecom/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                        <addr/>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                </procedure>
              </entry>
            </section>
          </component>
        </structuredBody>
      </component>
    </ClinicalDocument>
  </xsl:template>
  <!-- ****************************************************** template sub-routines from Jay added below **************************************************************  -->
  <xsl:template match="*" mode="standard-address">
    <xsl:param name="use" />
    <xsl:choose>
      <xsl:when test="boolean(Address)">
        <addr use="{$use}">
          <xsl:if test="boolean(Address/Street)">
            <streetAddressLine>
              <xsl:value-of select="Address/Street/text()" />
            </streetAddressLine>
          </xsl:if>
          <xsl:if test="boolean(Address/City/Code)">
            <city>
              <xsl:value-of select="Address/City/Code/text()" />
            </city>
          </xsl:if>
          <xsl:if test="boolean(Address/State/Code)">
            <state>
              <xsl:value-of select="Address/State/Code/text()" />
            </state>
          </xsl:if>
          <xsl:if test="boolean(Address/Zip/Code)">
            <postalCode>
              <xsl:value-of select="Address/Zip/Code/text()" />
            </postalCode>
          </xsl:if>
        </addr>
      </xsl:when>
      <xsl:otherwise>
        <addr nullFlavor="NI" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="standard-contact-info">
    <xsl:choose>
      <xsl:when test="boolean(ContactInfo) and (boolean(ContactInfo/HomePhoneNumber) or boolean(ContactInfo/WorkPhoneNumber) or boolean(ContactInfo/MobilePhoneNumber) or boolean(ContactInfo/EmailAddress))">
        <xsl:if test="boolean(ContactInfo/HomePhoneNumber)">
          <telecom use="HP" value="{concat('tel:',ContactInfo/HomePhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/WorkPhoneNumber)">
          <telecom use="WP" value="{concat('tel:',ContactInfo/WorkPhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/MobilePhoneNumber)">
          <telecom use="MC" value="{concat('tel:',ContactInfo/MobilePhoneNumber)}" />
        </xsl:if>
        <xsl:if test="boolean(ContactInfo/EmailAddress)">
          <telecom value="{concat('mailto:',ContactInfo/EmailAddress)}" />
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <telecom nullFlavor="NI" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="Name" mode="standard-name">
    <xsl:param name="use" />
    <xsl:choose>
      <xsl:when test="boolean(FamilyName) or boolean(GivenName) or boolean(MiddleName)">
        <name>
          <xsl:if test="boolean($use)">
            <xsl:attribute name="use">
              <xsl:value-of select="$use" />
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="boolean(FamilyName)">
            <family>
              <xsl:value-of select="FamilyName/text()" />
            </family>
          </xsl:if>
          <xsl:if test="boolean(GivenName)">
            <given>
              <xsl:value-of select="GivenName/text()" />
            </given>
          </xsl:if>
          <xsl:if test="boolean(MiddleName)">
            <given>
              <xsl:value-of select="MiddleName/text()" />
            </given>
          </xsl:if>
        </name>
      </xsl:when>
      <xsl:otherwise>
        <name>
          <xsl:if test="boolean($use)">
            <xsl:attribute name="use">
              <xsl:value-of select="$use" />
            </xsl:attribute>
          </xsl:if>
        </name>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="SupportContact" mode="header-participant">
    <participant typeCode="IND">
      <xsl:comment> participant block repeated for NOK and ECON </xsl:comment>
      <templateId root="2.16.840.1.113883.3.88.11.32.3"/>
      <xsl:comment> HITSP C32 V2.5:    IHE Support Template </xsl:comment>
      <templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.4"/>
      <xsl:comment> 3.01 DATE, REQUIRED </xsl:comment>
      <xsl:comment>
        3.01 DATE date as nullFlavor b/c data not yet available via VA VistA RPCs
      </xsl:comment>
      <time nullFlavor="UNK" />
      <xsl:comment> 3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value in contactType </xsl:comment>
      <associatedEntity classCode="{ContactType/Code/text()}">
        <xsl:comment>  3.03 CONTACT RELATIONSHIP as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
        <code codeSystem='2.16.840.1.113883.5.111' codeSystemName='{isc:evaluate("getCodeForOID","2.16.840.1.113883.5.111","","2.16.840.1.113883.5.111")}' nullFlavor='NA'>
          <originalText nullFlavor="NA">
            <xsl:value-of select='Relationship/Code/text()' />
          </originalText>
        </code>
        <xsl:comment> 3.04 CONTACT Addresss, Home Permanent, Optional-R2 </xsl:comment>
        <xsl:apply-templates select='.' mode='standard-address'>
          <xsl:with-param name='use'>HP</xsl:with-param>
        </xsl:apply-templates>
        <xsl:comment>
          3.05 CONTACT PHONE/EMAIL/URL, Optional-R2, Removed b/c data not yet
          available via VA VistA RPCs
        </xsl:comment>
        <xsl:apply-templates select='.' mode='standard-contact-info' />
        <associatedPerson>
          <xsl:comment> 3.06 CONTACT NAME, REQUIRED </xsl:comment>
          <xsl:apply-templates select='Name' mode='standard-name' />
        </associatedPerson>
      </associatedEntity>
    </participant>
  </xsl:template>
  <xsl:template match='CareTeamMember' mode='header-careteammembers' >
    <xsl:param name="number" />
    <performer typeCode="PRF">
      <xsl:comment> ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* </xsl:comment>
      <xsl:comment>  Provider Template Id  </xsl:comment>
      <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
      <xsl:comment> 4.02 PROVIDER ROLE CODED, optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
      <xsl:choose>
        <xsl:when test="$number=1">
          <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="{isc:evaluate('getCodeForOID','2.16.840.1.113883.5.88','CodeSystem','ParticipationFunction')}" displayName="{Description/text()}">
            <originalText>
              <xsl:value-of select="Description/text()" />
            </originalText>
          </functionCode>
        </xsl:when>
        <xsl:otherwise>
          <functionCode nullFlavor="NI">
            <originalText>
              <xsl:value-of select="concat('Care Team:  ', ../../CareTeamName/text())" />
            </originalText>
          </functionCode>
        </xsl:otherwise>
      </xsl:choose>
      <time>
        <high nullFlavor="UNK" />
      </time>
      <assignedEntity>
        <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
        <!-- <id extension="providerN" root="2.16.840.1.113883.4.349" /> -->
        <id nullFlavor="NI"/>
        <xsl:comment>4.04 PROVIDER TYPE, optional, NUCC </xsl:comment>
        <xsl:choose>
          <xsl:when test="boolean(CareProviderType)">
            <code code="{CareProviderType/Code/text()}" codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" displayName="{CareProviderType/Description/text()}">
              <originalText>
                <xsl:value-of select="CareProviderType/Description/text()" />
              </originalText>
            </code>
          </xsl:when>
          <xsl:otherwise>
            <code codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" nullFlavor="UNK">
              <originalText>
                <xsl:value-of select="Description/text()" />
              </originalText>
            </code>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:comment> Address Required for assignedEntity </xsl:comment>
        <xsl:apply-templates select="." mode="standard-address">
          <xsl:with-param name="use">WP</xsl:with-param>
        </xsl:apply-templates>
        <xsl:comment> Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
        <xsl:apply-templates select="." mode="standard-contact-info" />
        <xsl:comment> 4.07-PROVIDER NAME, REQUIRED </xsl:comment>
        <assignedPerson>
          <xsl:apply-templates select="Name" mode="standard-name" />
        </assignedPerson>
        <representedOrganization>
          <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
          <id nullFlavor="UNK" />
          <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
          <name nullFlavor="UNK" />
          <xsl:comment> Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <telecom nullFlavor="UNK" />
          <xsl:comment> Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <addr nullFlavor="UNK" />
        </representedOrganization>
      </assignedEntity>
    </performer>
  </xsl:template>
  <xsl:template match="Document" name="standard-documentCategoryToLoinc">
    <xsl:param name="doc" select="." />
    <xsl:choose>
      <xsl:when test="DocumentType/Code/text() = 'PN'">
        <LOINC>11506-3</LOINC>
        <Display>Subsequent Evaluation Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'DS'">
        <LOINC>18842-5</LOINC>
        <Display>Discharge Summarization Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'CR'">
        <LOINC>11488-4</LOINC>
        <Display>Consultation Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'CP'">
        <LOINC>28570-0</LOINC>
        <Display>Procedure Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'SR'">
        <LOINC>29752-3</LOINC>
        <Display>Perioperative Records</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'RA'">
        <LOINC>18726-0</LOINC>
        <Display>Radiology Studies</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'LR'">
        <LOINC>27898-6</LOINC>
        <Display>Pathology Studies</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'C'">
        <LOINC>34904-3</LOINC>
        <Display>Progress Note - Mental Health</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'W'">
        <LOINC>71282-4</LOINC>
        <Display>Risk Assessment Document</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'A'">
        <LOINC>68629-5</LOINC>
        <Display>Allergy and Immunology Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'D'">
        <LOINC>42348-3</LOINC>
        <Display>Advance Directives</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'D'">
        <LOINC>42348-3</LOINC>
        <Display>Advance Directives</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'HP'">
        <LOINC>34117-2</LOINC>
        <Display>History and Physical Note</Display>
      </xsl:when>
      <xsl:when test="DocumentType/Code/text() = 'CM'">
        <LOINC>38954-4</LOINC>
        <Display>Compensation and Pension Exam</Display>
      </xsl:when>
      <xsl:otherwise>
        <LOINC>34109-9</LOINC>
        <Display>UNKNOWN NOTE</Display>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text()" name="standard-insertBreaks">
    <xsl:param name="pText" select="."/>
    <xsl:choose>
      <xsl:when test="not(contains($pText, '&#xA;'))">
        <xsl:copy-of select="$pText"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($pText, '&#xA;')"/>
        <br />
        <xsl:call-template name="standard-insertBreaks">
          <xsl:with-param name="pText" select=
           "substring-after($pText, '&#xA;')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="Observation" name="standard-vitalsStink">
    <xsl:param name="isBMI" select="false" />
    <xsl:param name="pressureIndex" select="false" />
    <xsl:param name="grp" />
    <xsl:param name="ob" />
    <component>
      <observation classCode="OBS" moodCode="EVN">
        <xsl:comment> Result observation template </xsl:comment>
        <templateId root="2.16.840.1.113883.10.20.1.31"/>
        <xsl:comment> HITSP C32 V2.5:  Vital Sign Module/Entry Templates </xsl:comment>
        <templateId root="2.16.840.1.113883.3.88.11.83.14"/>
        <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
        <xsl:comment> HITSP C32 V2.5:  ASTM/HL7 CCD Specification for Vital Signs, parent templates </xsl:comment>
        <templateId root="2.16.840.1.113883.10.20.1.31"/>
        <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
        <xsl:comment> HITSP C32 V2.5:  14.01-VITAL SIGN RESULT ID, REQUIRED  </xsl:comment>
        <xsl:comment> 14.01-VITAL SIGN RESULT ID  </xsl:comment>
        <id root="2.16.840.1.113883.4.349" extension="{concat('.8716-3.',$ob/EnteredBy/Code/text(),$grp)}"/>
        <xsl:comment> HITSP C32 V2.5:  14.03-VITAL SIGN RESULT TYPE, REQUIRED, LOINC  </xsl:comment>
        <xsl:choose>
          <xsl:when test="$isBMI = 'true'">
            <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="39156-5" displayName="BMI">
              <originalText>BMI</originalText>
            </code>
          </xsl:when>
          <xsl:when test="$ob/ObservationCode/Code/text() = '4500635'">
            <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="72514-3" displayName="Pain Severity 0-10 Reported">
              <originalText>
                <xsl:value-of select="$ob/ObservationCode/Description" />
              </originalText>
            </code>
          </xsl:when>
          <xsl:when test="$pressureIndex = '1'">
            <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="8480-6" displayName="BP sys">
              <originalText>SYSTOLIC BLOOD PRESSURE</originalText>
              <translation code="4500634~1" displayName="SYSTOLIC BLOOD PRESSURE" codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
            </code>
          </xsl:when>
          <xsl:when test="$pressureIndex = '2'">
            <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="8462-4" displayName="BP dias">
              <originalText>DIASTOLIC BLOOD PRESSURE</originalText>
              <translation code="4500634~2" displayName="DIASTOLIC BLOOD PRESSURE" codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
            </code>
          </xsl:when>
          <xsl:otherwise>
            <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
              <originalText>
                <!-- TODO Vetsies -->
                <xsl:value-of select="$ob/ObservationCode/Description" />
              </originalText>
              <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
            </code>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:comment> CDA based uses of Simple Observations Text element Required </xsl:comment>
        <text>
          <reference value="#vital1"/>
        </text>
        <xsl:comment> 14.04-VITAL SIGN RESULT STATUS, REQUIRED, Static value of completed </xsl:comment>
        <statusCode code="completed" />
        <xsl:comment> 14.02-VITAL SIGN RESULT DATE/TIME, REQURIED </xsl:comment>
        <xsl:comment> HITSP C32 V2.5: if blank, then effectiveTime nullFlavor="UNK" </xsl:comment>
        <xsl:choose>
          <xsl:when test="$ob/ObservationTime">
            <effectiveTime value="{translate($ob/ObservationTime/text(), 'TZ:- ','')}" />
          </xsl:when>
          <xsl:otherwise>
            <effectiveTime nullFlavor="UNK" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:comment> HITSP C32 V2.5:  14.05-VITAL SIGN RESULT VALUE, CONDITIONAL REQUIRED when moodCode=EVN  </xsl:comment>
        <xsl:comment> 14.05-VITAL SIGN RESULT VALUE with Unit of Measure </xsl:comment>
        <xsl:choose>
          <xsl:when test="$isBMI = 'true'">
            <value xsi:type="PQ" unit="kg/m2" value="{$ob/Extension/BMI/text()}"/>
          </xsl:when>
          <xsl:when test="$ob/ObservationCode/Code/text() = '4500637'">
            <value xsi:type="PQ" unit="%" value="{$ob/ObservationValue}" >
              <translation code="%" displayName="%" codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" />
            </value>
          </xsl:when>
          <xsl:when test="$ob/ObservationCode/Code/text() = '4500635'">
            <value xsi:type="PQ" nullFlavor="NA" value="{$ob/ObservationValue}" >
              <translation nullFlavor="UNK" codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" />
            </value>
          </xsl:when>
          <xsl:when test="$pressureIndex = '1'">
            <value xsi:type="PQ" unit="{$ob/ObservationCode/ObservationValueUnits/Code/text()}" value="{isc:evaluate('piece', $ob/ObservationValue/text(), '/', 1)}" >
              <translation code="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}" codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" displayName="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}"/>
            </value>
          </xsl:when>
          <xsl:when test="$pressureIndex = '2'">
            <value xsi:type="PQ" unit="{$ob/ObservationCode/ObservationValueUnits/Code/text()}" value="{isc:evaluate('piece', $ob/ObservationValue/text(), '/', 2)}" >
              <translation code="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}" codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" displayName="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}"/>
            </value>
          </xsl:when>
          <xsl:otherwise>
            <value xsi:type="PQ" value="{$ob/ObservationValue/text()}" unit="{$ob/ObservationCode/ObservationValueUnits/Code/text()}">
              <translation code="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}" codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" displayName="{$ob/ObservationCode/ObservationValueUnits/OriginalText/text()}"/>
            </value>
          </xsl:otherwise>
        </xsl:choose>
        <interpretationCode nullFlavor="NI" />
        <xsl:comment> 14.05-VITAL SIGN RESULT VALUE when Unit of Measure is blank then omit unit attribute</xsl:comment>
        <xsl:comment> value xsi:type="PQ" value="" </xsl:comment>
        <xsl:comment> HITSP C32 V2.5:  14.06-VITAL SIGN RESULT INTERPRETATION, Optional, HL7 Result Normalcy Status Value Set </xsl:comment>
        <xsl:comment>  HITSP C32 V2.5:  14.06-VITAL SIGN RESULT INTERPRETATION, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
        <xsl:comment> HITSP C32 V2.5:  14.07-VITAL SIGN RESULT REFERENCE RANGE, Optional, </xsl:comment>
        <xsl:comment>   HITSP C32 V2.5:  14.07-VITAL SIGN RESULT REFERENCE RANGE, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
      </observation>
    </component>
  </xsl:template>
  <xsl:template name="tmpDateTemplate">
    <xsl:param name="date-time" />
    <xsl:param name="pattern" />
    <xsl:value-of select="$date-time" /> formatted like <xsl:value-of select="$pattern" />
  </xsl:template>
</xsl:stylesheet>