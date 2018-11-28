<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

  <xsl:variable name="documentCreatedOn" select="isc:evaluate('xmltimestamp', isc:evaluate('timestamp'))" />
  
  <xsl:template match="/Container">
    <xsl:variable name="patientBirthDate" select="Patient/BirthTime/text()" />
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
    </xsl:processing-instruction>
    <ClinicalDocument xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc"
                      xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
      <xsl:comment>
        *********************** C-CDA R2.1 CONTINUITY OF CARE DOCUMENT (CCD) VDIF Build 1  ************************************************
      </xsl:comment>
      <realmCode code="US" />
      <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040" />

      <templateId root="2.16.840.1.113883.10.20.22.1.1" extension="2015-08-01"/>
      <templateId root="2.16.840.1.113883.10.20.22.1.2" extension="2015-08-01"/>
      <!-- CCD Document Identifer, id=VA OID, extension=system-generated -->
      <id extension="{isc:evaluate('createUUID')}" root="2.16.840.1.113883.4.349" />
      <!-- CCD Document Code -->
      <code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="{isc:evaluate('lookup', '34133-9','Summarization of Episode Note')}" />
      <!-- CCD Document Title -->
      <title>Department of Veterans Affairs Health Summary</title>
      <!-- 1.01 DOCUMENT TIMESTAMP, REQUIRED -->
      <effectiveTime value="{$documentCreatedOn}" />
      <!-- CCD Confidentiality Code, REQUIRED -->
      <confidentialityCode code="R" codeSystem="2.16.840.1.113883.5.25" codeSystemName="ConfidentialityCode" />
      <!-- CCD DOCUMENT LANGUAGE, REQUIRED -->
      <languageCode code="en-US" />
      <versionNumber value="2"/>
      <recordTarget>
        <patientRole>
          <!-- 1.02 PERSON ID, REQUIRED, id=VA OID, extension=GUID -->
          <id root="2.16.840.1.113883.4.349" extension="{Patient/MPIID/text()}" />
          
          <xsl:comment> 1.03 PERSON ADDRESS-HOME PERMANENT, REQUIRED </xsl:comment>
          <xsl:apply-templates select="Patient/Addresses" mode="standard-address">
            <xsl:with-param name="use">HP</xsl:with-param>
          </xsl:apply-templates>
          
          <!-- 1.04 PERSON PHONE/EMAIL/URL, REQUIRED -->
          <telecom />
          
          <patient>
            <!-- 1.05 PERSON NAME LEGAL, REQUIRED -->
            <name use="L">
              <prefix />
              <given />
              <given MAP_ID="middle" />
              <family />
              <suffix />
            </name>
            <!-- 1.05 PERSON NAME Alias Name, Optional -->
            <name use="A">
              <prefix />
              <given />
              <family />
              <suffix />
            </name>
            <!-- 1.06 GENDER, REQUIRED, HL7 Administrative Gender -->
            <administrativeGenderCode codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode">
              <originalText>
                <reference />
              </originalText>
            </administrativeGenderCode>
            <!-- 1.07 PERSON DATE OF BIRTH, REQUIRED -->
            <birthTime value="{$patientBirthDate}" />
            <maritalStatusCode code='maritalCode' codeSystem='2.16.840.1.113883.5.2' codeSystemName='MaritalStatusCode' >
              <originalText />
              <!-- 1.08 MARITAL STATUS, Optional-R2 -->
            </maritalStatusCode>
            <!-- 1.09 RELIGIOUS AFFILIATION, Optional, Removed b/c data not yet available 
                via VA VIstA RPCs -->
            <religiousAffiliationCode codeSystem='2.16.840.1.113883.5.1076' codeSystemName='HL7 Religious Affiliation' >
              <originalText>religiousAffiliation</originalText>
            </religiousAffiliationCode>
            <!-- 1.10 RACE, Optional -->
            <raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </raceCode>
            <sdtc:raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </sdtc:raceCode>
            <!-- 1.11 ETHNICITY, Optional -->
            <ethnicGroupCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>ethnicity</originalText>
            </ethnicGroupCode>
            <!-- ********************************************************** LANGUAGE 
                SPOKEN CONTENT MODULE, R2 ********************************************************** -->
            <languageCommunication MAP_ID="PL">
              <!-- 2.01 LANGUAGE, REQUIRED, languageCode ISO 639-1 -->
              <languageCode nullFlavor="NA" />
              <modeCode nullFlavor="NA" />
              <proficiencyLevelCode nullFlavor="NA" />
              <preferenceInd value="true" />
            </languageCommunication>
            <languageCommunication MAP_ID="OL">
              <!-- 2.01 LANGUAGE, REQUIRED, languageCode ISO 639-1 -->
              <languageCode nullFlavor="NA" />
              <modeCode nullFlavor="NA" />
              <proficiencyLevelCode nullFlavor="NA" />
              <preferenceInd value="false" />
            </languageCommunication>
          </patient>
        </patientRole>
      </recordTarget>
      <!-- ********************************************************************** 
    INFORMATION SOURCE CONTENT MODULE, REQUIRED ********************************************************************** -->
      <!-- AUTHOR SECTION (REQUIRED) OF INFORMATION SOURCE CONTENT MODULE -->
      <author>
        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
        <!-- 10.01 AUTHOR TIME (=Document Creation Date), REQUIRED -->
        <time value="{$documentCreatedOn}" />
        <assignedAuthor>
          <!-- 10.02 AUTHOR ID (VA OID) (authorOID), REQUIIRED -->
          <!--<id root="2.16.840.1.113883.4.349" /> -->
          <id nullFlavor="NA"/>
          <code nullFlavor="UNK"/>
          <!-- Assigned Author Telecom Required, but VA VistA data not yet available -->
          <telecom nullFlavor="NA" />
          <!-- 10.02 AUTHOR NAME REQUIRED -->
          <!-- assignedPerson/Author Name REQUIRED but provided as representedOrganization -->
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <!-- 10.02 AUTHOR NAME REQUIRED as representedOrganization -->
          <representedOrganization>
            <!-- 10.02 AUTHORING DEVICE ORGANIZATION OID (VA OID) (deviceOrgOID), 
                REQUIIRED -->
            <id nullFlavor="NI" />
            <!-- 10.02 AUTHORING DEVICE ORGANIZATION NAME (deviceOrgName), REQUIIRED -->
            <name>Department of Veterans Affairs</name>
            <!-- Assigned Author Telecom Required, but VA VistA data not yet available -->
            <telecom nullFlavor="NA" />
            <!-- Assigned Author Address Required, but VA VistA data not yet available -->
            <addr nullFlavor="NA" />
          </representedOrganization>
        </assignedAuthor>
      </author>
      <!-- ******************************************************************************************* 
    INFORMANT SECTION (AS AN ORGANIZATION), Optional ******************************************************************************************* -->
      <informant>
        <assignedEntity>
          <id nullFlavor="NI" />
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <!-- Name Required for informant/assignedEntity/assignedPerson -->
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
        </assignedEntity>
      </informant>
      <!-- ********************************************************************************* 
    CUSTODIAN AS AN ORGANIZATION, REQUIRED ********************************************************************************** -->
      <custodian>
        <assignedCustodian>
          <representedCustodianOrganization>
            <!-- CUSTODIAN OID (VA OID) -->
            <id root="2.16.840.1.113883.4.349" />
            <!-- CUSTODIAN NAME -->
            <name>Department of Veterans Affairs</name>
            <!-- Telecom Required for representedOrganization, but VA VistA data 
                not yet available -->
            <telecom nullFlavor="NA" />
            <addr>
              <streetAddressLine>810 Vermont Avenue NW</streetAddressLine>
              <city>Washington</city>
              <state>DC</state>
              <postalCode>20420</postalCode>
              <country>US</country>
            </addr>
          </representedCustodianOrganization>
        </assignedCustodian>
      </custodian>
      <!-- *************************************************************************** 
    LEGAL AUTHENTICATOR (AS AN ORGANIZATION), Optional *************************************************************************** -->
      <legalAuthenticator>
        <!-- TIME OF AUTHENTICATION -->
        <time value="{$documentCreatedOn}" />
        <signatureCode code="S" />
        <assignedEntity>
          <id nullFlavor="NI" />
          <code nullFlavor="NI" />
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <id nullFlavor="NI" />
            <name>Department of Veterans Affairs</name>
            <addr>
              <streetAddressLine>810 Vermont Avenue NW</streetAddressLine>
              <city>Washington</city>
              <state>DC</state>
              <postalCode>20420</postalCode>
              <country>US</country>
            </addr>
          </representedOrganization>
        </assignedEntity>
      </legalAuthenticator>
      <!-- ******************************************************************** 
    SUPPORT INFORMATION CONTENT MODULE, Optional ******************************************************************** -->
      <participant typeCode="IND">
        <!-- 3.01 DATE, REQUIRED -->
        <!-- 3.01 DATE date as nullFlavor b/c data not yet available via VA VistA 
        RPCs -->
        <time nullFlavor="UNK" />
        <!-- 3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value 
        in contactType -->
        <associatedEntity classCode="contactType">
          <code codeSystem='2.16.840.1.113883.5.111' codeSystemName='RoleCode'>
            <originalText>relationshipType</originalText>
          </code>
          <!-- 3.04 CONTACT Addresss, Home Permanent, Optional-R2 -->
          <addr use="HP">
            <streetAddressLine>homeAddressLine</streetAddressLine>
            <city>homeCity</city>
            <state>homeState</state>
            <postalCode>homePostal</postalCode>
          </addr>
          <!-- 3.05 CONTACT PHONE/EMAIL/URL, Optional-R2, Removed b/c data not yet 
            available via VA VistA RPCs -->
          <telecom />
          <associatedPerson>
            <!-- 3.06 CONTACT NAME, REQUIRED -->
            <name>
              <prefix />
              <given>nameGiven</given>
              <family>nameFamily</family>
              <suffix>nameSuffix</suffix>
            </name>
          </associatedPerson>
        </associatedEntity>
      </participant>

      <!-- ******************************************************************************* 
    DOCUMENTATION OF MODULE - QUERY META DATA, Optional ******************************************************************************* -->
      <documentationOf>
        <serviceEvent classCode="PCPR">
          <effectiveTime>
            <low value="{$patientBirthDate}" />
            <high value="{$documentCreatedOn}" />
          </effectiveTime>
          <performer typeCode="PRF" MAP_ID="PCP">
            <!-- ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* -->
            <!-- 4.02 PROVIDER ROLE CODED, optional -->
            <templateId root="2.16.840.1.113883.10.20.6.2.1" extension="2014-06-09" />
            <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="HL7 particiationFunction" displayName="Primary Care Provider">
              <originalText>Primary Care Physician</originalText>
            </functionCode>
            <assignedEntity>
              <!-- Provider ID from Problems Module (7.05Treating Provider ID) -->
              <!-- <id extension="providerN" root="2.16.840.1.113883.4.349" /> -->
              <id nullFlavor="NI"/>
              <!--4.04 PROVIDER TYPE, optional, NUCC -->
              <code code="provTypeCode" codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" displayName="provTypeCodeName ">
                <originalText />
              </code>
              <!-- Address Required for assignedEntity -->
              <addr use="WP">
                <streetAddressLine />
                <city />
                <state />
                <postalCode />
              </addr>
              <!-- Telecom Required for iassignedEntity, but VA VistA data not yet 
                    available -->
              <telecom MAP_ID="TELEPHONE" />
              <telecom MAP_ID="EMAIL" />
              <!-- 4.07-PROVIDER NAME, REQUIRED -->
              <assignedPerson>
                <name />
              </assignedPerson>
              <representedOrganization>
                <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING 
						FACILITY NBR -->
                <id root="2.16.840.1.113883.4.349" />
                <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                <name />
                <!-- Telecom Required for representedOrganization, but VA VistA data 
						not yet available -->
                <telecom nullFlavor="UNK" />
                <!-- Address Required for representedOrganization, but VA VistA data 
						not yet available -->
                <addr nullFlavor="UNK" />
              </representedOrganization>
            </assignedEntity>
          </performer>
          <performer typeCode="PRF" MAP_ID="PC_TEAM">
            <!-- ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* -->
            <!-- 4.02 PROVIDER ROLE CODED, optional -->
            <templateId root="2.16.840.1.113883.10.20.6.2.1" extension="2014-06-09" />
            <functionCode nullFlavor="NI">
              <originalText/>
            </functionCode>
            <assignedEntity>
              <!-- Provider ID from Problems Module (7.05Treating Provider ID) -->
              <!-- <id extension="providerN" root="2.16.840.1.113883.4.349" /> -->
              <id nullFlavor = "NI"/>
              <!--4.04 PROVIDER TYPE, optional, NUCC -->
              <code code="provTypeCode" codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" displayName="provTypeCodeName">
                <originalText />
              </code>
              <!-- Address NOT Required for Care team  -->
              <addr nullFlavor="UNK" />

              <!-- Telecom Required for iassignedEntity, but VA VistA data not yet 
                    available -->
              <telecom nullFlavor="NI" />
              <!-- 4.07-PROVIDER NAME, REQUIRED -->
              <assignedPerson>
                <name />
              </assignedPerson>
              <representedOrganization>
                <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING 
                        FACILITY NBR -->
                <id extension="facilityNumber" root="2.16.840.1.113883.4.349" />
                <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                <name />
                <!-- Telecom Required for representedOrganization, but VA VistA data 
                        not yet available -->
                <telecom nullFlavor="UNK" />
                <!-- Address Required for representedOrganization, but VA VistA data 
                        not yet available -->
                <addr nullFlavor="UNK" />
              </representedOrganization>
            </assignedEntity>
          </performer>
        </serviceEvent>
      </documentationOf>
      <!-- ******************************************************** CDA BODY ******************************************************** -->
      <component>
        <structuredBody>
          <!--Insurance Providers -->
          <component>
            <!-- ********************************************************************************** 
                INSURANCE PROVIDERS (PAYERS) SECTION, Optional ********************************************************************************** -->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.18" extension = "2015-08-01"/>
              <code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Payment sources" />
              <title>Insurance Providers: All on record at VA</title>
              <!-- PAYERS NARRATIVE BLOCK -->
              <text>
                <paragraph>
                  <content ID="payersTime">Section Date Range: From patient's date of birth to the date document was created.</content>
                </paragraph>
                <!-- VA Insurance Providers Business Rules for Medical Content -->
                <paragraph>This section includes the names of all active insurance providers for the patient.</paragraph>
                <table MAP_ID="insuranceNarrative">
                  <thead>
                    <tr>
                      <th>Insurance Provider</th>
                      <th>Type of Coverage</th>
                      <th>Plan Name</th>
                      <th>Start of Policy Coverage</th>
                      <th>End of Policy Coverage</th>
                      <th>Group Number</th>
                      <th>Member ID</th>
                      <th>Insurance Provider's Telephone Number</th>
                      <th>Policy Holder's Name</th>
                      <th>Patient's Relationship to Policy Holder</th>
                    </tr>

                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="insCompany" />
                      </td>
                      <td>
                        <content ID="insInsurance" />
                      </td>
                      <td>
                        <content ID="insGroupName" />
                      </td>


                      <td>
                        <content ID="insEffectiveDate" />
                      </td>
                      <td>
                        <content ID="insExpirationDate" />
                      </td>

                      <td>
                        <content ID="insGroup" />
                      </td>
                      <td>
                        <content ID="insMemberId" />
                      </td>
                      <td>
                        <content />
                      </td>
                      <td>
                        <content ID="insMemberName" />
                      </td>

                      <td>
                        <content ID="insRelationship" />
                      </td>

                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#payersTime" />
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry >
              <!-- PAYERS STRUCTURED DATA -->
              <!-- CCD Coverage Activity -->
              <entry typeCode="DRIV">
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.60" extension="2015-08-01"/>
                  <id nullFlavor="NA" />
                  <code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Payment Sources" />
                  <statusCode code="completed" />
                  <!-- CCD Payment Provider Event Entry -->
                  <entryRelationship typeCode="COMP">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.61" extension = "2015-08-01" />
                      <!-- 5.01 GROUP NUMBER, REQUIRED -->
                      <id extension="groupNbr" root="2.16.840.1.113883.4.349" />
                      <!-- 5.02 HEALTH INSURANCE TYPE, REQURIED -->
                      <code codeSystem="2.16.840.1.113883.6.255.1336" codeSystemName="X12N-1336" >
                        <originalText />
                      </code>
                      <statusCode code="completed" />
                      <performer typeCode="PRF">
                        <templateId root="2.16.840.1.113883.10.20.22.4.87" />
                        <!-- 5.07 - Health Plan Coverage Dates, R2-Optional  -->
                        <time>
                          <!-- 5.07 VistA Policy Effective Date -->
                          <low />
                          <!-- 5.07 VistA Policy Expiration  Date -->
                          <high />
                        </time>
                        <!-- CCD Payer Info -->
                        <assignedEntity>
                          <id nullFlavor="NA" />
                          <!-- 5.03 HEALTH PLAN INSURANCE INFO SOURCE ID, REQUIRED -->
                          <!-- 5.04 HEALTH PLAN INSURANCE INFO SOURCE ADDRESS, Optional -->
                          <addr>
                            <streetAddressLine />
                            <streetAddressLine />
                            <city />
                            <state />
                            <postalCode />
                          </addr>
                          <!-- 5.05 HEALTH PLAN INSURANCE INFO SOURCE PHONE/EMAIL/URL, Optional -->
                          <telecom />
                          <representedOrganization>
                            <!-- 5.06 HEALTH PLAN INSURANCE INFO SOURCE NAME ( Insurance 
                                                Company Name), R2 -->
                            <name />
                          </representedOrganization>
                        </assignedEntity>
                      </performer>
                      <author>
                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                        <time nullFlavor="NA" />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <representedOrganization>
                            <id root="2.16.840.1.113883.4.349" />
                            <!-- INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME -->
                            <name />
                            <telecom nullFlavor="NA" />
                            <addr nullFlavor="NA" />
                          </representedOrganization>
                        </assignedAuthor>
                      </author>
                      <participant typeCode="COV">
                        <templateId root="2.16.840.1.113883.10.20.22.4.89" />
                        <participantRole classCode="PAT">
                          <id root="2.16.840.1.113883.4.349" />
                          <!-- 5.09 PATIENT RELATIONSHIP TO SUBSCRIBER, REQUIRED, HL7 Coverage 
                                            Role Type -->
                          <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode">
                            <originalText>
                              <reference/>
                            </originalText>
                          </code>
                        </participantRole>
                      </participant>
                      <participant typeCode="HLD">
                        <templateId root="2.16.840.1.113883.10.20.22.4.90" />
                        <participantRole>
                          <id root="2.16.840.1.113883.4.349" />
                          <!-- 5.11 SUBSCRIBER ADDRESS -->
                          <addr use="HP" nullFlavor="NA" />
                          <!--  5.17 SUBSCRIBER PHONE -->
                          <telecom nullFlavor="NA" />
                          <playingEntity>
                            <!-- 5.18 SUBSCRIBER NAME, REQUIRED -->
                            <name />
                            <!-- 5.19 SUBSCRIBER DATE OF BIRTH, R2 -->
                            <sdtc:birthTime nullFlavor="UNK"/>
                          </playingEntity>
                        </participantRole>
                      </participant>
                      <!-- 5.24 HEALTH PLAN NAME, optional -->
                      <entryRelationship typeCode="REFR">
                        <act classCode="ACT" moodCode="DEF">
                          <id root="2.16.840.1.113883.4.349" />
                          <code nullFlavor="NA" />
                          <text />
                        </act>
                      </entryRelationship>
                    </act>
                  </entryRelationship>
                </act>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** ADVANCED 
                DIRECTIVE SECTION, REQUIRED ******************************************************** -->
            <section>
              <!-- C-CDA Advanced Directive Section Template Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.21.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.21" />
              <code code="42348-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Advance Directives" />
              <title>Advance Directives: All on record at VA</title>
              <!-- ADVANCED DIRECTIVES NARRATIVE BLOCK -->
              <text>
                <paragraph>
                  <content ID="advanceDirectiveTime">Section Date Range: From patient's date of birth to the date document was created.</content>
                </paragraph>
                <paragraph>
                  This section includes a list of a patient's completed, amended, or rescinded VA Advance Directives, but an actual copy is not included.
                </paragraph>
                <table MAP_ID="advancedirectivesnarrative">
                  <thead>
                    <tr>
                      <th>Date</th>
                      <th>Advance Directives</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td />

                      <td>
                        <content ID="advanceDirective" />
                      </td>
                      <td>
                        <content ID="advDirProvider" />
                      </td>
                      <td>
                        <content ID="advDirSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#advanceDirectiveTime" />
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>
              <!-- ADVANCED DIRECTIVES STRUCTURED DATA -->
              <entry typeCode="DRIV">
                <!-- CCD Advanced Directive Observation, R2 -->
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.48" extension="2015-08-01"/>
                  <id nullFlavor="NI" />
                  <!-- 12.01 ADVANCED DIRECTIVE TYPE, REQUIRED, SNOMED CT -->
                  <code xsi:type="CD" nullFlavor="UNK">
                    <originalText>
                      <reference />
                    </originalText>
                    <translation nullFlavor="NA" />
                  </code>
                  <statusCode code="completed" />
                  <!-- 12.03 ADVANCED DIRECTIVE EFFECTIVE DATE, REQUIRED -->
                  <effectiveTime>
                    <!-- ADVANCED DIRECTIVE EFFECTIVE DATE low = starting time, REQUIRED -->
                    <low />
                    <!-- ADVANCED DIRECTIVE EFFECTIVE DATE high= ending time, REQUIRED -->
                    <high nullFlavor="NA" />
                  </effectiveTime>
                  <value xsi:type="CD">
                    <originalText>
                      <reference />
                    </originalText>
                  </value>
                  <!-- ADVANCED DIRECTIVE REFERENCE, R2, not provided by VA -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <participant typeCode="VRF">
                    <templateId root="2.16.840.1.113883.10.20.1.58"/>
                    <time nullFlavor="UNK"/>
                    <participantRole>
                      <code nullFlavor="NA" />
                      <addr nullFlavor="NA" />
                      <!-- VERIFIER PHONE/EMAIL/URL, R2 -->
                      <telecom nullFlavor="NA" />
                      <playingEntity>
                        <!-- VERIFIER NAME, REQUIRED  -->
                        <name>Department of Veterans Affairs</name>
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <!-- CUSTODIAN OF DOCUMENT, REQUIRED -->
                  <participant typeCode="CST">
                    <participantRole classCode="AGNT">
                      <!-- CUSTODIAN ADDRESS, R2 -->
                      <addr nullFlavor="NA" />
                      <!-- CUSTODIAN PHONE?EMAIL/URL, R2 -->
                      <telecom nullFlavor="NA" />
                      <playingEntity>
                        <!-- CUSTODIAN NAME, REQUIRED -->
                        <name />
                      </playingEntity>
                    </participantRole>
                  </participant>
                </observation>
              </entry>
            </section>
          </component>
          <component>
            <!-- ************************************************************* ALLERGY/DRUG 
                SECTION SECTION, REQUIRED ************************************************************* -->
            <section>
              <!-- ALLERGY/DRUG Section Template Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.6.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.6" />
              <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies and/or Adverse Reactions" />
              <title>Allergies and Adverse Reactions (ADRs): All on record at VA</title>
              <!-- ALLERGIES NARRATIVE BLOCK -->
              <text>
                <paragraph>
                  <content ID="allergiesTime">Section Date Range: From patient's date of birth to the date document was created.</content>
                </paragraph>
                <!-- VA Allergies/Drug Business Rules for Medical Content -->
                <paragraph>
                  This section includes Allergies and Adverse Reactions (ADRs) on record with VA for the patient.
                  The data comes from all VA treatment facilities. It does not list Allergies/ADRs that were removed or entered in error.
                  Some allergies/ADRs may be reported in the Immunization section.
                </paragraph>
                <table MAP_ID="allergyNarrative">
                  <thead>
                    <tr>
                      <th>Allergen</th>
                      <th>Event Date</th>
                      <th>Event Type</th>
                      <th>Reaction(s)</th>
                      <th>Severity</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="andAllergy" />
                      </td>
                      <td />


                      <td>
                        <content ID="andEventType" />
                      </td>
                      <td>
                        <list>
                          <item>
                            <content ID="andReaction" />
                          </item>
                        </list>
                      </td>
                      <td>
                        <content ID="andSeverity" />
                      </td>
                      <td>
                        <content ID="andSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value='#allergiesTime' />
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>

              <!-- ALLERGIES STRUCTURED DATA -->
              <entry typeCode="DRIV">
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.30" extension="2015-08-01"/>
                  <!-- CCD Allergy Act ID as nullFlavor -->
                  <id nullFlavor="NA" />
                  <!--<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" /> -->
                  <code code="CONC" codeSystem="2.16.840.1.113883.5.6" displayName="Concern" />
                  <statusCode code="active" />
                  <effectiveTime>
                    <low nullFlavor="NA" />
                  </effectiveTime>
                  <!-- INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <code nullFlavor="NA" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR -->
                        <id root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME -->
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode="SUBJ">
                    <!-- Allergy Intolerance Observation Entry -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.7" extension="2014-06-09"/>
                      <id nullFlavor="NA" />
                      <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode" />
                      <statusCode code="completed" />
                      <!-- 6.01 ADVERSE EVENT DATE, REQUIRED -->
                      <effectiveTime>
                        <low />
                      </effectiveTime>
                      <!-- 6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT -->
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                        <originalText>
                          <reference />
                        </originalText>
                      </value>
                      <participant typeCode="CSM">
                        <participantRole classCode="MANU">
                          <playingEntity classCode="MMAT">
                            <!-- 6.04 PRODUCT CODED,REQUIRED -->
                            <code codeSystem="2.16.840.1.113883.6.88"  codeSystemName="RxNorm">
                              <!-- 6.03 PRODUCT FREE TEXT, R2 -->
                              <originalText>
                                <reference />
                              </originalText>
                              <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                            </code>
                          </playingEntity>
                        </participantRole>
                      </participant>
                      <!-- REACTION ENTRY RELATIONSHIP BLOCK R2, repeatable -->
                      <entryRelationship typeCode="MFST" inversionInd="true">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.9" extension="2014-06-09" />
                          <id nullFlavor="NA" />
                          <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>
                          <statusCode code="completed" />
                          <effectiveTime nullFlavor="UNK" />

                          <!-- 6.06 REACTION CODED, REQUIRED -->

                          <value   xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                            <!-- 6.05 REACTION-FREE TEXT, optional, -->
                            <originalText>
                              <reference />
                            </originalText>
                            <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                          </value>
                        </observation>
                      </entryRelationship>
                      <!-- SEVERITY ENTRY RELATIONSHIP BLOCK R2, 0 or 1 per Allergy -->
                      <entryRelationship typeCode="SUBJ" inversionInd="true">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.8" extension="2014-06-09"/>
                          <code code="SEV" displayName="Severity" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode" />
                          <!-- 6.07 SEVERITY FREE TEXT, Optional-R2 Removed b/c removed in template -->
                          <text>
                            <reference />
                          </text>
                          <statusCode code="completed" />
                          <!-- 6.08 SEVERITY CODED, REQUIRED, SNOMED CT -->
                          <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                        </observation>
                      </entryRelationship>
                    </observation>
                  </entryRelationship>
                </act>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** ENCOUNTER 
                SECTION, Optional ******************************************************** -->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.22.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.22" />
              <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospitalizations and Outpatient Visits" />
              <title>Encounters: Outpatient Encounters with Notes</title>
              <text>
                <paragraph>
                  <content ID="encounterTime">
                    This section contains a list of completed VA Outpatient Encounters for the patient with associated Encounter Notes within the requested date range. If no date range was provided, the lists include data from the last 18 months. The data comes from all VA treatment facilities. Consult Notes, History &amp; Physical Notes, and Discharge Summaries are provided separately, in subsequent sections.
                  </content>
                </paragraph>
                <paragraph>
                  <content styleCode="Bold">Outpatient Encounters with Notes</content>
                </paragraph>
                <paragraph MAP_ID="opEncTitle">
                  The list of VA Outpatient Encounters shows all Encounter dates within the requested date range. If no date range was provided, the list of VA Outpatient Encounters shows all Encounter dates within the last 18 months. Follow-up visits related to the VA Encounter are not included. The data comes from all VA treatment facilities.
                </paragraph>
                <content MAP_ID="encounterStuff" styleCode="Bold">Encounter</content>
                <!-- VA Encounter Business Rules for Medical Content -->
                <table MAP_ID="encounterNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Type</th>
                      <th>Encounter Description</th>
                      <th>Reason</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td />

                      <td>
                        <content ID="endEncounterType" />
                      </td>
                      <td>
                        <content ID="endEncounterDescription" />
                      </td>
                      <td>
                        <content ID="endReason" />
                      </td>
                      <td>
                        <content ID="endProvider" />
                      </td>
                      <td>
                        <content ID="endSource" />
                      </td>
                    </tr>
                  </tbody>
                  <tbody>
                    <tr>
                      <td />
                      <td colspan="5">
                        <content styleCode="Bold">Encounter Notes</content>
                        <!-- Start Associated Notes Narrative-->
                        <paragraph MAP_ID="anTitle">
                          The list of Encounter Notes shows the 5 most recent notes associated to the Outpatient Encounter. The data comes from all VA treatment facilities.
                        </paragraph>
                        <list>
                          <item>
                            <table MAP_ID="anNoteNarrative">
                              <thead>
                                <tr>
                                  <th>Date/Time</th>
                                  <th>Encounter Note</th>
                                  <th>Provider</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <td>
                                    <content ID="anNoteDateTime" />
                                  </td>
                                  <td>
                                    <content ID="anNoteEncounterDescription" />
                                  </td>
                                  <td>
                                    <content ID="anNoteProvider" />
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </item>
                        </list>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- CDA Observation Text as a Reference tag -->
                <content ID='encNote-1' revised="delete">IHE Encounter Template Text not used by VA</content>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#encounterTime"/>
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="$encountersStart" />
                    <high value="$encountersEnd" />
                  </value>
                </observation>
              </entry>
              <entry typeCode="DRIV">
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" extension="2015-08-01"/>
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="NI" />
                  <!-- 16.02 ENCOUNTER TYPE. R2, CPT-4 -->
                  <code code="encCode" displayName="encDisplay" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <!-- 16.03 ENCOUNTER FREE TEXT TYPE. R2 -->
                    <originalText>
                      <reference />
                    </originalText>
                  </code>
                  <!-- 16.04 ENCOUNTER DATE/TIME, REQUIRED -->
                  <effectiveTime xsi:type="IVL_TS">
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <!-- 16.05 ENCOUNTER PROVIDER NAME, REQUIRED -->
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <!--16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA -->
                  <!--16.11 - FACILITY LOCATION, Optional -->
                  <participant typeCode="LOC">
                    <!--16.20 - IN FACILITY LOCATION DURATION, Optional -->
                    <time>
                      <!--16.12 - ARRIVAL DATE/TIME, Optional -->
                      <low  />
                      <!-- 16.12 - DEPARTURE DATE/TIME, Optional -->
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                      <code nullFlavor="NI"/>
                      <addr nullFlavor="UNK"/>
                      <telecom nullFlavor="UNK"/>
                      <playingEntity classCode="PLC">
                        <name/>
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <!-- Encounter Reason for Visit -->
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" extension="2014-06-09" />
                      <id nullFlavor="NI" />
                      <!-- CCD Reason for Visit Code, REQUIRED, SNOMED CT -->
                      <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
                      <!-- 16.13 REASON FOR VISIT TEXT, Optional -->
                      <!-- Is this for only outpatient? -->
                      <statusCode code="completed" />
                      <value xsi:type="CD" >
                        <originalText>
                          <reference />
                        </originalText>
                        <translation codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM' />
                      </value>
                    </observation>
                  </entryRelationship>
                  <!-- CCD ENCOUNTER DIAGNOSIS, Optional -->
                  <entryRelationship typeCode="REFR">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" extension="2015-08-01" />
                      <code code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="DIAGNOSIS"/>
                      <statusCode code="active"/>
                      <effectiveTime>
                        <low nullFlavor="UNK"/>
                      </effectiveTime>

                      <!-- CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT -->
                      <entryRelationship typeCode="SUBJ" inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN" negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" extension="2015-08-01" />
                          <!-- Problem Observation -->
                          <id nullFlavor="UNK" />
                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>
                          <statusCode code="completed" />
                          <effectiveTime>
                            <low nullFlavor="UNK" />
                            <high nullFlavor="UNK" />
                          </effectiveTime>
                          <!-- CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT -->
                          <value xsi:type="CD" codeSystemName="SNOMED CT" codeSystem="2.16.840.1.113883.6.96">
                            <originalText>
                              <reference />
                            </originalText>
                            <translation codeSystemName="ICD-9-CM" codeSystem="2.16.840.1.113883.6.103" />
                          </value>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>
                  <!-- 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs -->
                  <!-- Associated Encounter Notes -->
                  <entryRelationship typeCode="COMP">
                    <!-- CCD Results Organizer = VA Associated Encounter Notes , REQUIRED -->
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                      <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                        <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                      </code>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <!-- Clinically relevant time of the note -->
                      <effectiveTime />
                      <author>
                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                        <!-- Time note was actually written -->
                        <time />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <assignedPerson>
                            <name />
                          </assignedPerson>
                          <representedOrganization>
                            <id root="2.16.840.1.113883.3.349" />
                            <name />
                            <addr nullFlavor="UNK" />
                          </representedOrganization>
                        </assignedAuthor>
                      </author>
                    </act>
                  </entryRelationship>
                </encounter>
              </entry>
            </section>
          </component>
          <!-- ***** FUNCTIONAL STATUS, OMIT from SES ************ -->
          <component>
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.14" extension="2014-06-09" />
              <code code="47420-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Functional Status"/>
              <title>Functional Status: Functional Independence Measurement (FIM) Scores</title>
              <text>
                <paragraph>
                  <content ID="functionalTime">This section contains a list of the Functional Independence Measurement (FIM) assessments on record at VA for the patient. It shows the FIM scores that were recorded within the requested date range. If no date range was provided, it shows the 3 most recent assessment scores that were completed within the last 3 years. The data comes from all VA treatment facilities.</content>
                </paragraph>
                <paragraph>
                  <content styleCode='Underline'>FIM Scale</content>:
                  <content styleCode='Underline'>1</content> = Total Assistance (Subject = 0% +),
                  <content styleCode='Underline'>2</content> = Maximal Assistance (Subject = 25% +),
                  <content styleCode='Underline'>3</content> = Moderate Assistance (Subject = 50% +),
                  <content styleCode='Underline'>4</content> = Minimal Assistance (Subject = 75% +),
                  <content styleCode='Underline'>5</content> = Supervision,
                  <content styleCode='Underline'>6</content> = Modified Independence (Device),
                  <content styleCode='Underline'>7</content> = Complete Independence (Timely, Safely).
                </paragraph>
                <table>
                  <thead>
                    <tr>
                      <th>Assessment Date/Time</th>
                      <th>Source</th>
                      <th>Assessment Type/Skill</th>
                      <th>FIM Score</th>
                      <th>Details</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="fimAssessmentDate" />
                      </td>
                      <td>
                        <content ID="fimFacility" />
                      </td>
                      <td>
                        <content ID="fimAssessment" />
                      </td>
                      <td/>
                      <td/>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimEatName">Eating</content>
                      </td>
                      <td>
                        <content ID="fimEat" />
                      </td>
                      <td>
                        <content ID="fimEatDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimGroomName">Grooming</content>
                      </td>
                      <td>
                        <content ID="fimGroom" />
                      </td>
                      <td>
                        <content ID="fimGroomDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimBathName">Bathing</content>
                      </td>
                      <td>
                        <content ID="fimBath" />
                      </td>
                      <td>
                        <content ID="fimBathDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimDressUpName">Dressing - Upper Body</content>
                      </td>
                      <td>
                        <content ID="fimDressUp" />
                      </td>
                      <td>
                        <content ID="fimDressUpDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimDressLoName">Dressing - Lower Body</content>
                      </td>
                      <td>
                        <content ID="fimDressLo" />
                      </td>
                      <td>
                        <content ID="fimDressLoDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimToiletName">Toileting</content>
                      </td>
                      <td>
                        <content ID="fimToilet" />
                      </td>
                      <td>
                        <content ID="fimToiletDetail">Self Care</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimBladderName">Bladder Management</content>
                      </td>
                      <td>
                        <content ID="fimBladder" />
                      </td>
                      <td>
                        <content ID="fimBladderDetail">Sphincter Control</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimBowelName">Bowel Management</content>
                      </td>
                      <td>
                        <content ID="fimBowel" />
                      </td>
                      <td>
                        <content ID="fimBowelDetail">Sphincter Control</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimTransChairName">Bed, Chair, Wheelchair</content>
                      </td>
                      <td>
                        <content ID="fimTransChair" />
                      </td>
                      <td>
                        <content ID="fimTransChairDetail">Transfers</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimTransToiletName">Toilet</content>
                      </td>
                      <td>
                        <content ID="fimTransToilet" />
                      </td>
                      <td>
                        <content ID="fimTransToiletDetail">Transfers</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimTransTubName">Tub, Shower</content>
                      </td>
                      <td>
                        <content ID="fimTransTub" />
                      </td>
                      <td>
                        <content ID="fimTransTubDetail">Transfers</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimLocomWalkName">Walk/Wheelchair</content>
                      </td>
                      <td>
                        <content ID="fimLocomWalk" />
                      </td>
                      <td>
                        <content ID="fimLocomWalkDetail">Locomotion</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimLocomStairName">Stairs</content>
                      </td>
                      <td>
                        <content ID="fimLocomStair" />
                      </td>
                      <td>
                        <content ID="fimLocomStairDetail">Locomotion</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimComprehendName">Comprehension</content>
                      </td>
                      <td>
                        <content ID="fimComprehend" />
                      </td>
                      <td>
                        <content ID="fimComprehendDetail">Communication</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimExpressName">Expression</content>
                      </td>
                      <td>
                        <content ID="fimExpress" />
                      </td>
                      <td>
                        <content ID="fimExpressDetail">Communication</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimInteractName">Social Interaction</content>
                      </td>
                      <td>
                        <content ID="fimInteract" />
                      </td>
                      <td>
                        <content ID="fimInteractDetail">Social Cognition</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimProblemName">Problem Solving</content>
                      </td>
                      <td>
                        <content ID="fimProblem" />
                      </td>
                      <td>
                        <content ID="fimProblemDetail">Social Cognition</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimMemoryName">Memory</content>
                      </td>
                      <td>
                        <content ID="fimMemory" />
                      </td>
                      <td>
                        <content ID="fimMemoryDetail">Social Cognition</content>
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td>
                        <content ID="fimTotalName">FIM Total</content>
                      </td>
                      <td>
                        <content ID="fimTotal" />
                      </td>
                      <td>
                        <content ID="fimTotalDetail" />
                      </td>
                    </tr>
                    <tr>
                      <td/>
                      <td/>
                      <td/>
                      <td/>
                      <td/>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- Date Range -->
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01" />
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range" />
                  <text>
                    <reference value="#functionalTime" />
                  </text>
                  <statusCode code="completed" />
                  <value xsi:type="IVL_TS">
                    <low value="$fimsStart"/>
                    <high value="$fimsEnd" />
                  </value>
                </observation>
              </entry>
              <!--  FUNCTIONAL STATUS STRUCTURED ENTRIES -->
              <entry typeCode="DRIV">
                <organizer classCode="CLUSTER" moodCode="EVN">
                  <!-- **** Functional Status Result Organizer template **** -->
                  <templateId root="2.16.840.1.113883.10.20.22.4.66" extension="2014-06-09" />
                  <id nullFlavor="NI"/>
                  <!-- Functional Status Result Organizer Code, ICF or SNOMED CT,  FIM Assessment Type -->
                  <code nullFlavor="UNK">
                    <originalText>
                      <reference value="#fimAssessment"/>
                    </originalText>
                  </code>
                  <statusCode code="completed"/>
                  <!-- * Information Source for Functional Status, VA Facility  -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA"/>
                    <assignedAuthor>
                      <id nullFlavor="NI"/>
                      <addr nullFlavor="NA" />
                      <telecom nullFlavor="NA" />
                      <representedOrganization>
                        <id extension="442" root="2.16.840.1.113883.3.1275"/>
                        <name>CHEYENNE VAMC</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimEatName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimEat"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimEatDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimGroomName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimGroom"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimGroomDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimBathName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimBath"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimBathDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimDressUpName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimDressUp"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimDressUpDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimDressLoName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimDressLo"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimDressLoDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimToiletName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimToilet"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimToiletDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimBladderName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimBladder"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimBladderDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimBowelName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimBowel"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimBowelDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimTransChairName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimTransChair"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimTransChairDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimTransToiletName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimTransToilet"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimTransToiletDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimTransTubName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimTransTub"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimTransTubDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimLocomWalkName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimLocomWalk"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimLocomWalkDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimLocomStairName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimLocomStair"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimLocomStairDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimComprehendName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimComprehend"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimComprehendDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimExpressName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimExpress"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimExpressDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimInteractName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimInteract"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimInteractDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimProblemName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimProblem"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimProblemDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimMemoryName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimMemory"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimMemoryDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                  <component>
                    <!-- Functional Status Result Observation  -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <!-- Functional Status Result Observation ID  -->
                      <id nullFlavor="NI" />
                      <!--  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  -->
                      <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                      <text>
                        <reference value="#fimTotalName"/>
                      </text>
                      <statusCode code="completed"/>
                      <!-- Functional Status Result Observation Date/Time, FIM Assessment Date/Time -->
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <!--  Functional Status Result Observation Date/Time, FIM Skill Score -->
                      <value nullFlavor="NA" xsi:type="CD">
                        <translation nullFlavor="UNK">
                          <originalText>
                            <reference value="#fimTotal"/>
                          </originalText>
                        </translation>
                      </value>
                      <!--  Functional Status Result Observation Comment, FIM Details -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#fimTotalDetail"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </component>
                </organizer>
              </entry>
            </section>
          </component>
          <component>
            <!-- **************************************************************** 
                MEDICATIONS (RX & Non-RX) SECTION, REQUIRED **************************************************************** -->
            <section>
              <!-- C-CDA Medications Section Template Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.1.1" extension="2014-06-09"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.1" />
              <code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of medication use" />
              <title>Medications: VA Dispensed and Non-VA Dispensed</title>
              <!-- MEDICATIONS NARRATIVE BLOCK -->
              <text>
                <!-- VA Medication Business Rules for Medical Content -->
                <paragraph>
                  <content ID="medTime">Section Date Range: 1) prescriptions processed by a VA pharmacy in the last 15 months, and 2) all medications recorded in the VA medical record as "non-VA medications". Pharmacy terms refer to VA pharmacy's work on prescriptions. VA patients are advised to take their medications as instructed by their health care team. The data comes from all VA treatment facilities.</content>
                </paragraph>
                <paragraph>
                  <content styleCode='Underline'>Glossary of Pharmacy Terms:</content>
                  <content styleCode='Underline'>Active</content> = A prescription that can be filled at the local VA pharmacy.
                  <content styleCode='Underline'>Active: On Hold</content> = An active prescription that will not be filled until pharmacy resolves the issue.
                  <content styleCode='Underline'>Active: Susp</content> = An active prescription that is not scheduled to be filled yet.
                  <content styleCode='Underline'>Clinic Order</content> = A medication received during a visit to a VA clinic or emergency department.
                  <content styleCode='Underline'>Discontinued</content> = A prescription stopped by a VA provider. It is no longer available to be filled.
                  <content styleCode='Underline'>Expired</content> = A prescription which is too old to fill. This does not refer to the expiration date of the medication in the container.
                  <content styleCode='Underline'>Non-VA</content> = A medication that came from someplace other than a VA pharmacy. This may be a prescription from either the VA or other providers that was filled outside the VA. Or, it may be an over the counter (OTC), herbal, dietary supplement or sample medication.
                  <content styleCode='Underline'>Pending</content> = This prescription order has been sent to the Pharmacy for review and is not ready yet.
                </paragraph>
                <table MAP_ID="medicationNarrative">
                  <thead>
                    <tr>
                      <th>Medication Name and Strength</th>
                      <th>Pharmacy Term</th>
                      <th>Instructions</th>
                      <th>Quantity Ordered</th>
                      <th>Prescription Expires</th>
                      <th>Prescription Number</th>
                      <th>Last Dispense Date</th>
                      <th>Ordering Provider</th>
                      <th>Facility</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="mndMedication" />
                      </td>
                      <td>
                        <content ID="mndStatus" />
                      </td>
                      <td>
                        <content ID="mndSig" />
                      </td>
                      <td>
                        <content ID="mndQuantity" />
                      </td>
                      <td>
                        <content ID="mndExpires" />
                      </td>
                      <td>
                        <content ID="mndPrescription" />
                      </td>
                      <td>
                        <content ID="mndLastDispensed" />
                      </td>
                      <td>
                        <content ID="mndProvider" />
                      </td>
                      <td>
                        <content ID="mndSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#medTime"/>
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>
              <!-- CCD Medication Activity Entry -->
              <entry typeCode="DRIV">
                <substanceAdministration classCode="SBADM" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.16" extension ="2014-06-09"/>
                  <id nullFlavor="NA" />
                  <!-- 8.12 DELIVERY METHOD, Optional, No value set defined, Not provided by VA b/c data from VA VistA RPCs not yet available -->
                  <!-- 8.01 FREE TEXT SIG REFERENCE, Optional -->
                  <text>
                    <reference value="#mndSig" />
                  </text>
                  <statusCode code="completed" />
                  <effectiveTime xsi:type="IVL_TS">
                    <low nullFlavor="UNK" />
                  </effectiveTime>
                  <!-- 8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data 
                            not yet available via VA VistA RPCs -->
                  <!-- 8.03 ADMINISTRATION TIMING (xsi:type='EIVL' operator='A'), Optional, 
                            Not provided by VA b/c data not yet available via VA VistA RPCs -->
                  <!-- 8.04 FREQUENCY (xsi:type='PIVL_TS institutionSpecified='false' 
                            operator='A''), Optional, Not provided by VA b/c data not yet available via 
                            VA VistA RPCs -->
                  <!--8.05 INTERVAL ( xsi:type='PIVL_TS' institutionSpecified='false' 
                            operator='A'), Optional,Not provided by VA b/c data not yet available via 
                            VA VistA RPCs -->
                  <!--8.06 DURATION ( xsi:type='PIVL_TS' operator='A'), Optional, Not 
                            provided by VA b/c data not yet available via VA VistA RPCs -->
                  <!-- 8.08 DOSE, Optional, Not provided by VA b/c data not yet available 
                            via VA VistA RPCs -->
                  <consumable>
                    <manufacturedProduct classCode="MANU">
                      <templateId root="2.16.840.1.113883.10.20.22.4.23" extension="2014-06-09" />
                      <manufacturedMaterial>
                        <!-- 8.13 CODED PRODUCT NAME, REQUIRED, UNII, RxNorm, NDF-RT, NDC, 
                                        Not provided by VA b/c data not yet available via VA VistA RPCs -->
                        <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm"  >
                          <!-- 8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not 
                                            yet available via VA VistA RPCs -->
                          <!-- 8.15 FREE TEXT PRODUCT NAME, REQUIRED -->
                          <originalText>
                            <reference value="#mndMedication" />
                          </originalText>
                          <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                        </code>
                        <!-- 8.16 FREE TEXT BRAND NAME, R2, Not provided by VA b/c data 
                                        not yet available via VA VistA RPCs -->
                      </manufacturedMaterial>
                    </manufacturedProduct>
                  </consumable>
                  <!-- Information Source for Medication Entry, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <representedOrganization>
                        <id extension="" root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>

                  <!-- 8.20-STATUS OF MEDICATION, Optional-R2, SNOMED CT -->
                  <entryRelationship typeCode="REFR">
                    <!--To Identify Status -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.1.47" />
                      <code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                      <value xsi:type="CE">
                        <originalText></originalText>
                      </value>
                    </observation>
                  </entryRelationship>

                  <!-- CCD Patient Instructions Entry, Optional -->

                  <entryRelationship typeCode="SUBJ">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.3.88.11.32.10" />
                      <!-- VLER SEG 1B: 8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT -->
                      <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                        <originalText />
                      </code>
                    </observation>
                  </entryRelationship>

                  <!-- CCD Drug Vehicle Entry, Optional, Not provided by VA b/c data 
                            not yet available via VA VistA RPCs -->
                  <!-- 8.24 VEHICLE, Optional, Not provided by VA b/c data not yet available 
                            via VA VistA RPCs -->
                  <!-- CCD Indication Entry, Optional, Not provided by VA b/c data not 
                            yet available via VA VistA RPCs -->
                  <!-- 8.21 INDICATION VALUE, Optional, SNOMED CT, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs -->
                  <!-- CCD Medication Supply Order Entry, REQUIRED -->
                  <entryRelationship typeCode='REFR'>
                    <supply classCode="SPLY" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.17" extension="2014-06-09"/>
                      <!-- VLER SEG 1B: 8.26 ORDER NUMBER, Optional-R2 -->
                      <id extension="orderNbr" root="2.16.840.1.113883.4.349" />
                      <statusCode code="completed" />
                      <!-- 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 -->
                      <effectiveTime xsi:type="IVL_TS">
                        <low nullFlavor="UNK" />
                        <high />
                      </effectiveTime>
                      <!-- VLER SEG 1B: 8.27 FILLS, Optional -->
                      <repeatNumber />
                      <!-- 8.28 QUANTITY ORDERED, R2, Not provided by VA b/c data not 
                                    yet available via VA VistA RPCs -->
                      <!--<product>
										<manufacturedProduct classCode="MANU">
											<templateId root="2.16.840.1.113883.10.20.22.4.23" />
											<manufacturedMaterial>
												<code codeSystem="2.16.840.1.113883.6.88" codeSystemName="RxNorm" >
													<originalText />
												</code>
											</manufacturedMaterial>
										</manufacturedProduct>
									</product> -->
                      <author>
                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                        <!-- 8.30 ORDER DATE/TIME, Optional -->
                        <time value="20100717"/>
                        <assignedAuthor>
                          <id nullFlavor="NA" />
                          <assignedPerson>
                            <!-- 8.31 ORDERING PROVIDER, Optional -->
                            <name />
                          </assignedPerson>
                        </assignedAuthor>
                      </author>
                    </supply>
                  </entryRelationship>

                  <!-- FULFILLMENT Instructions -->
                  <entryRelationship inversionInd="true" typeCode='SUBJ'>
                    <act classCode="ACT" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                      <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                    </act>
                  </entryRelationship>
                  <!-- FULFILLMENT HISTORY INFORMATION -->
                  <!-- CCD Medication Dispense Entry, Optional -->
                  <entryRelationship typeCode='REFR'>
                    <supply classCode="SPLY" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.18" extension="2014-06-09"/>
                      <!-- 8.34 PRESCRIPTION NUMBER, Optional-R2 -->
                      <id />
                      <statusCode nullFlavor="UNK" />
                      <effectiveTime />
                    </supply>
                  </entryRelationship>
                  <!-- 8.23 REACTION OBSERVATION Entry, Optional, Not provided by VA 
                        b/c data not yet available via VA VistA RPCs -->
                  <!-- CCD PRECONDITION FOR SUBSTANCE ADMINISTRATION ENTRY, Optional, 
                        Not provided by VA b/c data not yet available via VA VistA RPCs -->
                  <!--8.25 DOSE INDICATOR, Optional, Not provided by VA b/c data not 
                        yet available via VA VistA RPCs -->
                </substanceAdministration>
              </entry>
            </section>
          </component>
          <!-- Immunizations section -->
          <component>
            <!-- ******************************************************** IMMUNIZATIONS SECTION, Optional ******************************************************** -->
            <section>
              <!-- CCD Immunization Section Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.2.1" extension="2015-08-01" />
              <templateId root="2.16.840.1.113883.10.20.22.2.2" />
              <code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Immunization"/>
              <title>Immunizations: All on record at VA</title>
              <text>
                <paragraph>
                  <content ID="immsectionTime">Section Date Range: From patient's date of birth to the date document was created.</content>
                </paragraph>
                <!-- VA Immunization Business Rules for Medical Content -->
                <paragraph>This section includes Immunizations on record with VA for the patient. The data comes from all VA treatment facilities. A reaction to an immunization may also be reported in the Allergy section.</paragraph>
                <table MAP_ID="immunizationNarrative">
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
                      <td />

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
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value='#immsectionTime' />
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>
              <entry typeCode='DRIV'>
                <!-- CCD Immunization Activity Entry, REQUIRED -->
                <!-- 13.01 IMMUNIZATION REFUSAL (negation ind="true"), REQUIRED -->
                <substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">
                  <templateId root="2.16.840.1.113883.10.20.22.4.52" extension="2015-08-01"/>
                  <id nullFlavor="NA" />
                  <text>
                    <reference value="#indComments" />
                  </text>
                  <statusCode code="completed" />
                  <effectiveTime />
                  <!-- C-CDA R2.1 Immunization Medication Series Nbr -->
                  <repeatNumber />
                  <routeCode codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="FDA Route of Administration">
                    <originalText />
                  </routeCode>
                  <approachSiteCode>
                    <originalText />
                  </approachSiteCode>
                  <consumable>
                    <manufacturedProduct classCode="MANU">
                      <templateId root="2.16.840.1.113883.10.20.22.4.54" extension="2014-06-09"/>
                      <manufacturedMaterial>
                        <!-- 13.06 CODED IMMUNIZATION PRODUCT NAME -->
                        <code codeSystemName="Vaccine Administered (CVX code)" codeSystem="2.16.840.1.113883.6.59">
                          <originalText>
                            <reference />
                          </originalText>
                          <translation codeSystem='2.16.840.1.113883.6.12' codeSystemName='Current Procedural Terminology (CPT) Fourth Edition (CPT-4)' />
                        </code>
                        <lotNumberText>#immLot</lotNumberText>
                      </manufacturedMaterial>
                      <manufacturerOrganization>
                        <name/>
                      </manufacturerOrganization>
                    </manufacturedProduct>
                  </consumable>
                  <performer>
                    <assignedEntity>
                      <!-- CCD Provider ID, extension = VA Provider ID, root=VA OID, REQUIRED -->
                      <id extension="providerID" root="2.16.840.1.113883.4.349" />
                      <assignedPerson>
                        <!-- CCD Provider Name, REQUIRED -->
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <!-- INFORMATION SOURCE FOR IMMUNIZATION, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) -->
                        <id root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!-- IMMUNIZATION REACTION -->
                  <entryRelationship typeCode="CAUS" inversionInd="true">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.9" extension="2014-06-09" />
                      <id nullFlavor="NA" />
                      <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
                      <text>
                        <reference value="#pndimmunization_rxn_n"/>
                      </text>
                      <statusCode code="completed" />
                      <effectiveTime>
                        <low nullFlavor="UNK"/>
                      </effectiveTime>
                      <value nullFlavor="UNK" xsi:type="CD"/>
                    </observation>
                  </entryRelationship>
                  <!-- 13.10 REFUSAL REASON ENTRY, Optional, VA provides administered immunizations only -->
                </substanceAdministration>
              </entry>
            </section>
          </component>
          <!-- Procedures section -->
          <component>
            <!-- ******************************************************** PROCEDURES 
                SECTION ******************************************************** -->
            <section>
              <!-- CCD Procedures Section Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.7.1" extension="2014-06-09"/>
              <code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of procedures" />
              <title>Procedures: Surgical Procedures with Notes</title>
              <!-- PROCEDURE NARRATIVE BLOCK -->
              <text>
                <!-- VA Procedure Business Rules for Medical Content -->
                <paragraph>
                  <content ID="procedureTime">This section contains a list of Surgical Procedures performed at the VA for the patient, with the associated Surgical Notes on record at the VA for the patient, within the requested date range. If no date range was provided, the lists include data from the last 18 months. The data comes from all VA treatment facilities. Clinical Procedure Notes are provided separately, in a subsequent section.</content>
                </paragraph>
                <paragraph MAP_ID="opSurgTitle">
                  <content styleCode="Bold">Surgical Procedures with Notes</content>
                </paragraph>
                <paragraph MAP_ID="opSurgTitleNote">
                  The list of Surgical Procedures shows all procedure dates within the requested date range. If no date range was provided, the list of Surgical Procedures shows the 5 most recent procedure dates within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <content MAP_ID="procedureTitle" styleCode="Bold">Surgical Procedure</content>
                <table MAP_ID="procedureNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Procedure</th>
                      <th>Procedure Type</th>
                      <th>Procedure Qualifiers</th>
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
                        <content ID="prndDescription" />
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
                        <content ID="prndProvider" />
                      </td>
                      <td>
                        <content ID="prndSource" />
                      </td>
                    </tr>
                  </tbody>
                  <tbody>
                    <tr>
                      <td />
                      <td colspan="5">
                        <!-- Surgical notes begin -->
                        <paragraph>
                          <content styleCode="Bold">Surgical Notes</content>
                        </paragraph>
                        <paragraph MAP_ID="opSurgNotes">
                          This section contains the 5 most recent Surgical Procedure Notes associated to the Procedure. The data comes from all VA treatment facilities.
                        </paragraph>
                        <list>
                          <item>
                            <table MAP_ID="SurgicalNotesNarrative">
                              <thead>
                                <tr>
                                  <th>Date/Time</th>
                                  <th>Surgical Procedure Note</th>
                                  <th>Provider</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <td>
                                    <content ID="surgicalNoteDateTime" />
                                  </td>
                                  <td>
                                    <content ID="surgicalNoteEncounterDescription" />
                                  </td>
                                  <td>
                                    <content ID="surgicalNoteProvider" />
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </item>
                        </list>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- Surgical End -->
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#procedureTime"/>
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="$proceduresStart" />
                    <high value="$proceduresEnd" />
                  </value>
                </observation>
              </entry>

              <!-- PROCEDURE STRUCTURED -->
              <entry typeCode="DRIV">
                <procedure classCode="PROC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.14" extension="2014-06-09"/>
                  <id nullFlavor="NI" />
                  <!-- 17.02-PROCEDURE TYPE, REQUIRED, LOINC, SNOMED CT or CPT, 4 -->
                  <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <!-- 17.03 PROCEDURE FREE TEXT TYPE, R2 -->
                    <originalText>
                      <reference />
                    </originalText>
                    <translation>
                      <!-- 17.03 PROCEDURE FREE TEXT TYPE, R2 -->
                      <originalText>
                        <reference />
                      </originalText>
                    </translation>
                  </code>
                  <qualifier>
                    <name />
                    <value />
                  </qualifier>
                  <statusCode code="completed" />
                  <effectiveTime />
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <addr nullFlavor="NA" />
                      <telecom nullFlavor="NA" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <!-- INFORMATION SOURCE FOR PROCEDURE ENTRY, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name/>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode='COMP'>
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                      <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                        <translation code="29752-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Perioperative Records" />
                      </code>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <!-- Clinically relevant time of the note -->
                      <effectiveTime />
                      <author>
                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                        <!-- Time note was actually written -->
                        <time />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <assignedPerson>
                            <name />
                          </assignedPerson>
                          <representedOrganization>
                            <id root="2.16.840.1.113883.3.349" />
                            <name />
                            <addr nullFlavor="UNK" />
                          </representedOrganization>
                        </assignedAuthor>
                      </author>
                    </act>
                  </entryRelationship>
                </procedure>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** PLAN OF 
                CARE SECTION, Optional ******************************************************** -->
            <section>
              <!-- CCD Plan of Care Section Entries -->
              <templateId root="2.16.840.1.113883.10.20.22.2.10" extension="2014-06-09"/>
              <code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Plan of care note" />
              <title>Plan of Treatment: Future Appointments and Active/Pending Orders</title>
              <text>
                <paragraph>
                  <content ID="treatmentTime">The Plan of Treatment section contains future care activities for the patient from all VA treatment facilities. This section includes future appointments (within the next 6 months) and future orders (within +/- 45 days) which are active, pending or scheduled.</content>
                </paragraph>
                <paragraph MAP_ID="futureAppointmentsTitle">
                  <content styleCode="Bold">Future Appointments</content>
                </paragraph>
                <paragraph MAP_ID="futureAppointmentsRules">
                  This section includes up to a maximum of 20 appointments scheduled over the next 6 months. Some types of appointments may not be included. Contact the VA health care team if there are questions.
                </paragraph>
                <table MAP_ID="futureAppointments">
                  <thead>
                    <tr>
                      <th>Appointment Date/Time</th>
                      <th>Appointment Type</th>
                      <th>Appointment Facility Name</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="apptDateTime" />
                      </td>
                      <td>
                        <content ID="apptType" />
                      </td>
                      <td>
                        <content ID="apptFacility" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <paragraph MAP_ID="futureScheduledTestsTitle">
                  <content styleCode="Bold">Active, Pending, and Scheduled Orders</content>
                </paragraph>
                <paragraph MAP_ID="futureScheduledTestsRules">
                  This section includes a listing of several types of active, pending, and scheduled orders, including clinic medication orders, diagnostic test orders, procedure orders, and consult orders; where the start date of the order is 45 days before or after the date this document was created.
                </paragraph>
                <table MAP_ID="futureScheduledTests">
                  <thead>
                    <tr>
                      <th>Test Date/Time</th>
                      <th>Test Type</th>
                      <th>Test Details</th>
                      <th>Facility Name</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="orderDateTime" />
                      </td>
                      <td>
                        <content ID="contentType" />
                      </td>
                      <td>
                        <content ID="orderDetails" />
                      </td>
                      <td>
                        <content ID="orderFacilityName" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#treatmentTime"/>
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="$planOfCareStart" />
                    <high value="$planOfCareEnd" />
                  </value>
                </observation>
              </entry>
              <!-- PLAN OF CARE (POC) STRUCTURED DATA -->
              <!-- CCD Plan of Care (POC) Activity Encounter (Future VA Appointments, 
                    Future Scheduled Tests, Wellness Reminders), Optional -->
              <entry>
                <encounter classCode="ENC" moodCode="INT">
                  <templateId root="2.16.840.1.113883.10.20.22.4.40" extension="2014-06-09"/>
                  <!-- <id root="2.16.840.1.113883.4.349" /> -->
                  <id nullFlavor="UNK"/>
                  <code nullFlavor="UNK">
                    <originalText>
                      <reference />
                    </originalText>
                  </code>
                  <statusCode code="active"/>
                  <effectiveTime />
                  <participant typeCode="LOC">
                    <participantRole classCode="SDLOC">
                      <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                      <code nullFlavor="UNK"/>
                      <addr nullFlavor="UNK" />
                      <telecom nullFlavor="UNK"/>
                      <playingEntity classCode="PLC">
                        <name />
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <entryRelationship inversionInd="true" typeCode='SUBJ'>
                    <act classCode="ACT" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.20" extension="2014-06-09" />
                      <code xsi:type="CE" code="409073007" codeSystem="2.16.840.1.113883.6.96" displayName="Instruction" codeSystemName="SNOMED CT" />
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                    </act>
                  </entryRelationship>
                </encounter>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** PROBLEM/CONDITION 
                SECTION, REQUIRED ******************************************************** -->
            <section>
              <!-- C-CDA Problem Section Template. Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.5.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.5" />
              <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem List" />
              <title>Problems (Conditions): All on record at VA</title>
              <!-- PROBLEMS NARRATIVE BLOCK -->
              <text>
                <paragraph>
                  <content ID="problemTime" >Section Date Range: From patient's date of birth to the date document was created.</content>
                </paragraph>
                <!-- VA Problem/Condition Business Rules for Medical Content -->
                <paragraph>
                  This section includes a list of Problems (Conditions) known to VA for the patient.
                  It includes both active and inactive problems (conditions). The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="problemNarrative">
                  <thead>
                    <tr>
                      <th>Problem</th>
                      <th>Status</th>
                      <th>Problem Code</th>
                      <th>Date of Onset</th>
                      <th>Date of Resolution</th>
                      <th>Comment(s)</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="pndProblem" />
                      </td>
                      <td>
                        <content ID="pndStatus" />
                      </td>
                      <td>
                        <content ID="pndProblemCode" />
                      </td>
                      <td>
                        <content ID="pndDateOfOnset" />
                      </td>
                      <td>
                        <content ID="pndDateOfResolution" />
                      </td>
                      <td>
                        <list>
                          <item>
                            <content ID="pndComment" />
                          </item>
                        </list>
                      </td>
                      <td>
                        <content ID="pndProvider" />
                      </td>
                      <td>
                        <content ID="pndSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#problemTime"/>
                    <!-- <td ID="adsectionTime">Section Date Range: From patient's date of birth to the date document was created."</td> -->
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>
              <!-- PROBLEMS STRUCTURED DATA -->
              <!-- Problem Concern Activty Entry -->
              <entry>
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.3" extension="2015-08-01" />
                  <id nullFlavor="NA" />
                  <code code="CONC" codeSystem="2.16.840.1.113883.5.6" codeSystemName="HL7ActClass" displayName="Concern" />
                  <statusCode code="active" />
                  <!-- C-CDA R2.1 PROBLEM CONCERN DATE,  Date Recorded/Entered, Required -->
                  <!-- 7.01 PROBLEM DATE, R2 -->
                  <effectiveTime>
                    <!-- 7.01 PROBLEM DATE, cda:low=Date of Entry -->
                    <low />
                    <!-- 7.01 PROBLEM DATE, cda:high=Date Resolved ? YOU WISH! Always nullFlavor -->
                    <high nullFlavor="UNK"/>
                  </effectiveTime>
                  <!-- TREATING PROVIDER Performer Block, Optional -->
                  <performer>
                    <assignedEntity>
                      <!-- 7.05 TREATING PROVIDER -->
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <!-- INFORMATION SOURCE FOR PROBLEM, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <code nullFlavor="NA" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR -->
                        <id root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME -->
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode="SUBJ">
                    <!-- CCD Problem Observation -->
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.4" extension="2015-08-01"/>
                      <id nullFlavor="NI" />
                      <!-- 7.02 PROBLEM TYPE, REQUIRED, SNOMED CT, provided as nullFlavor 
                                    b/c data not yet available via VA VistA RPCs -->
                      <code nullFlavor="NA" />
                      <!-- 7.03 PROBLEM NAME, R2 -->
                      <text>
                        <reference value="#pndProblem" />
                      </text>
                      <statusCode code="completed" />
                      <!-- 7.01 Problem Observation Date -->
                      <effectiveTime>
                        <!-- Date of onset -->
                        <low />
                        <!-- Date of resolution -->
                        <high />
                      </effectiveTime>
                      <!-- 7.04 PROBLEM CODE, Optional, When uncoded only xsi:type="CD" 
                                    allowed, Available as ICD-9, not SNOMED CT, -->
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                        <originalText>
                          <reference />
                        </originalText>
                        <translation codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM' />
                      </value>
                      <!-- PROBLEM STATUS entryRelationship block, Optional, -->
                      <entryRelationship typeCode="SUBJ">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.6" />
                          <code code="33999-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                                  codeSystemName="LOINC" displayName="Status" />
                          <statusCode code="completed" />
                          <!-- PROBLEM STATUS VALUE, Deprecated R2,1 -->
                          <value xsi:type="CE" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" >
                            <originalText>
                              <reference />
                            </originalText>
                          </value>
                        </observation>
                      </entryRelationship>
                      <!-- PROBLEM COMMENT (for SSA) entryRelationship block, Optional, -->
                      <entryRelationship inversionInd="true" typeCode="SUBJ">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/>
                          <text>
                            <reference value="#pndComment"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </entryRelationship>
                  <!-- CCD Problem Age Observation, not provided b/c data not yet available 
                            via VA VistA RPCs -->
                  <!-- CCD Health Status Observation, not provided b/c data not yet 
                            available via VA VistA RPCs -->
                </act>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** RESULTS 
                SECTION, REQUIRED ******************************************************** -->
            <section>
              <!-- CCD Results Section Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.3.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.3" />
              <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data" />
              <title>Results: Chemistry and Hematology</title>
              <text>
                <paragraph>
                  <content ID="resultsTime">
                    This section contains the Chemistry and Hematology Lab Results on record with VA for the patient within the requested date range. If no date range was provided, the lists include data from the last 24 months. The data comes from all VA treatment facilities. Radiology Reports and Pathology Reports are provided separately, in subsequent sections.
                  </content>
                </paragraph>
                <paragraph MAP_ID="labsTitle">
                  <content styleCode="Bold">Lab Results</content>
                </paragraph>
                <paragraph MAP_ID="labsNarrative">
                  This section contains all the Chemistry/Hematology Results collected within the requested date range. If no date range was provided, the included Chemistry/Hematology Results are from the last 24 months and are limited to the 10 most recent sets of tests. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="labNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Source</th>
                      <th>Result Type</th>
                      <th>Result - Unit</th>
                      <th>Interpretation</th>
                      <th>Reference Range</th>
                      <th>Comment</th>
                    </tr>
                  </thead>

                  <tbody>
                    <tr MAP_ID="labTest">
                      <td />

                      <td>
                        <content />
                      </td>
                      <td colspan="4">
                        <content />
                      </td>

                      <td>
                        <content />
                      </td>
                    </tr>
                    <tr MAP_ID="labValues">
                      <td />

                      <td />

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
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <paragraph MAP_ID="microbiologyTitle">
                  <content styleCode="Bold">Microbiology Reports</content>
                </paragraph>
                <paragraph MAP_ID="microbiologyRules">
                  The included Microbiology Reports are the 20 most recent reports within the last 24 months. The data comes from all VA treatment facilities.  ANTIBIOTIC SUSCEPTIBILITY TEST RESULTS KEY: SUSC = Susceptibility Result, S = Susceptible, INTP = Interpretation, I = Intermediate, MIC  = Minimum Inhibitory Concentration, R = Resistant.
                </paragraph>
                <table MAP_ID="microbiologyNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Report</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr MAP_ID="microbiologyTest">
                      <td />

                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01" />
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range" />
                  <text>
                    <reference value="#resultsTime" />
                  </text>
                  <statusCode code="completed" />
                  <value xsi:type="IVL_TS">
                    <low value="$resultsStart"/>
                    <high value="$resultsEnd" />
                  </value>
                </observation>
              </entry>
              <entry typeCode='DRIV1'>
                <!-- CCD Results Organizer = VA Lab Order Panel , REQUIRED -->
                <organizer classCode="BATTERY" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.1" extension="2014-06-09" />
                  <id nullFlavor="NI" />
                  <code nullFlavor="UNK">
                    <originalText>
                      <reference />
                    </originalText>
                  </code>
                  <statusCode code="completed" />
                  <effectiveTime>
                    <low />
                    <high />
                  </effectiveTime>
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <component>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.2" extension="2015-08-01"/>
                      <!-- 15.01 RESULT ID, REQUIRED -->
                      <id root="2.16.840.1.113883.4.349" />
                      <!-- 15.03-RESULT TYPE, REQUIRED -->
                      <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
                        <originalText>
                          <reference />
                        </originalText>
                      </code>

                      <text >
                        <reference/>
                      </text>
                      <statusCode code="completed" />
                      <!-- 15.02 RESULT DATE/TIME, REQUIRED -->
                      <effectiveTime />
                      <!-- 15.05 RESULT VALUE, REQUIRED, xsi:type="PQ" -->
                      <value xsi:type="PQ">
                        <reference/>
                      </value>
                      <!-- 15.06 RESULT INTERPRETATION, R2, -->
                      <interpretationCode nullFlavor="NAV">
                        <originalText>
                          <reference />
                        </originalText>
                      </interpretationCode>
                      <!-- CCD METHOD CODE, Optional, Not provided by VA b/c data not 
                                    yet available via VA VistA RPCs -->
                      <!-- CCD TARGET SITE CODE, Optional, Not provided by VA b/c data 
                                    not yet available via VA VistA RPCs -->
                      <author>
                        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                        <time nullFlavor="NA" />
                        <assignedAuthor>
                          <id nullFlavor="NA" />
                          <assignedPerson>
                            <name />
                          </assignedPerson>
                        </assignedAuthor>
                      </author>
                      <entryRelationship typeCode="SUBJ" inversionInd="true">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                          <text>
                            <reference />
                          </text>
                        </act>
                      </entryRelationship>
                      <!-- 15.07 RESULT REFERENCE RANGE, R2, -->
                      <referenceRange>
                        <observationRange>
                          <text>
                            <reference />
                          </text>
                          <value xsi:type="IVL_PQ">
                            <low />
                            <high />
                          </value>
                        </observationRange>
                      </referenceRange>
                    </observation>
                  </component>
                </organizer>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** SOCIAL 
                HISTORY SECTION, Optional ******************************************************** -->
            <section>
              <!-- CCD Social History Section Entries -->
              <templateId root="2.16.840.1.113883.10.20.22.2.17" extension="2015-08-01" />
              <code code="29762-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Social History" />
              <title>Social History: All on record at VA</title>
              <text>
                <!-- VA Procedure Business Rules for Medical Content -->
                <paragraph>
                  <content ID="socialHistTime">Section Date Range: From patient's date of birth to the date the document was created.</content>
                </paragraph>
                <paragraph>
                  This section includes all smoking or tobacco-related health factors on record at VA for the patient. The data comes from all VA treatment facilities.
                </paragraph>
                <paragraph>
                  <content styleCode="Bold">Current Smoking Status</content>
                </paragraph>
                <paragraph>
                  This section includes the MOST CURRENT smoking, or tobacco-related health factor, on record at VA for the patient.
                </paragraph>
                <table MAP_ID="factorsNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Current Smoking Status</th>
                      <th>Comment</th>
                      <th>Facility</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="hfDate" />
                      </td>
                      <td>
                        <content ID="hfName" />
                      </td>
                      <td>
                        <content ID="hfSeverity"/>
                        <br/>
                        <content ID="hfComment" />
                      </td>
                      <td>
                        <content ID="hfFacility" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <paragraph>
                  <content styleCode="Bold">Tobacco Use History</content>
                </paragraph>
                <paragraph>
                  This section includes a history of the smoking, or tobacco-related health factors, on record at VA for the patient.
                </paragraph>
                <table MAP_ID="factorsNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Smoking Status/Tobacco Use</th>
                      <th>Comment</th>
                      <th>Facility</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="hfDate2" />
                      </td>
                      <td>
                        <content ID="hfName2" />
                      </td>
                      <td>
                        <content ID="hfSeverity2"/>
                        <br/>
                        <content ID="hfComment2" />
                      </td>
                      <td>
                        <content ID="hfFacility2" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <!-- C-CDA R2.1 Section Time Range, Optional -->
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value='#socialHistTime' />
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="{$patientBirthDate}" />
                    <high value="{$documentCreatedOn}" />
                  </value>
                </observation>
              </entry>
              <entry MAP_ID="currentHealthFactors">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.78" extension="2014-06-09" />
                  <id nullFlavor="NI" />
                  <code code="72166-2" codeSystem="2.16.840.1.113883.6.1" displayName="Tobacco smoking status NHIS" />
                  <statusCode code="completed" />
                  <!-- CCD Smoking Status Effective Time, R2 -->
                  <effectiveTime />
                  <!-- CCD Smoking Status Value, REQURIED, SNOMED CT -->
                  <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" nullFlavor="UNK">
                    <originalText>
                      <reference />
                    </originalText>
                  </value>
                  <!-- INFORMATION SOURCE FOR SMOKING STATUS, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING 
                                        FACILITY NBR) -->
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                        <name>facilityName</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!-- CCD Smoking Status Comment Entry, Optional -->
                  <entryRelationship typeCode="SUBJ" inversionInd="true">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                      <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                      <!-- CCD Smoking Status Comment, REQUIRED -->
                      <text>
                        <reference />
                      </text>
                    </act>
                  </entryRelationship>
                </observation>
              </entry>
              <entry MAP_ID="pastHealthFactors">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.85" extension="2014-06-09"/>
                  <id nullFlavor="NI" />
                  <code code="11367-0" codeSystem="2.16.840.1.113883.6.1" displayName="History of tobacco use" />
                  <statusCode code="completed" />
                  <!-- CCD Smoking Status Effective Time, R2 -->
                  <effectiveTime>
                    <low nullFlavor="UNK" />
                    <high nullFlavor="NAV" />
                  </effectiveTime>
                  <!-- CCD Smoking Status Value, REQURIED, SNOMED CT -->
                  <value xsi:type="CD" nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                    <originalText>
                      <reference />
                    </originalText>
                  </value>
                  <!-- INFORMATION SOURCE FOR SMOKING STATUS, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING 
                                        FACILITY NBR) -->
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                        <name>facilityName</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!-- CCD Smoking Status Comment Entry, Optional -->
                  <entryRelationship typeCode="SUBJ" inversionInd="true">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                      <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                      <!-- CCD Smoking Status Comment, REQUIRED -->
                      <text>
                        <reference />
                      </text>
                    </act>
                  </entryRelationship>
                </observation>
              </entry>
            </section>
          </component>
          <component>
            <!-- ******************************************************** VITAL SIGNS 
                SECTION, REQUIRED ******************************************************** -->
            <section>
              <!-- C-CDA CCD VITAL SIGNS Section Template Entries REQUIRED -->
              <templateId root="2.16.840.1.113883.10.20.22.2.4.1" extension="2015-08-01"/>
              <templateId root="2.16.840.1.113883.10.20.22.2.4" />
              <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Vital Signs" />
              <title>Vital Signs</title>
              <!-- VITAL SIGNS NARRATIVE BLOCK, REQUIRED -->
              <text>
                <paragraph>
                  <content ID="vitalsTime">
                    This section contains inpatient and outpatient Vital Signs on record at the VA for the
                    patient. The data comes from all VA treatment facilities. It includes vital signs collected
                    within the requested date range. If more than one set of vitals was taken in the same date,
                    only the most recent set is populated for that date. If no date range was provided, it includes
                    12 months of data, with a maximum of the 5 most recent sets of vitals. If more than one set of
                    vitals was taken on the same date, only the most recent set is populated for that date.
                  </content>
                </paragraph>
                <table MAP_ID="vitalNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Temperature</th>
                      <th>Pulse</th>
                      <th>Blood Pressure</th>
                      <th>Respiratory Rate</th>
                      <th>SP02</th>
                      <th>Pain</th>
                      <th>Height</th>
                      <th>Weight</th>
                      <th>Body Mass Index</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td />

                      <td>
                        <content ID="vndSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- CDA Observation Text as a Reference tag -->
                <content ID="vital1" revised='delete'>Vital Sign Observation Text Not Available</content>
              </text>
              <!-- VITAL SIGNS STRUCTURED DATA -->
              <entry typeCode="DRIV">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01" />
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range" />
                  <text>
                    <reference value="#vitalsTime" />
                  </text>
                  <statusCode code="completed" />
                  <value xsi:type="IVL_TS">
                    <low value="$vitalsStart"/>
                    <high value="$vitalsEnd" />
                  </value>
                </observation>
              </entry>
              <entry typeCode='DRIV'>
                <!-- Vital Signs Organizer Template, REQUIRED -->
                <organizer classCode="CLUSTER" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.26" extension="2015-08-01"/>
                  <!-- Vital Sign Organizer ID as nullFlavor b/c data not yet available 
                            via VA VistA RPCs -->
                  <id nullFlavor="NA" />
                  <code code="46680005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Vital signs" >
                    <translation code="74728-7" codeSystem="2.16.840.1.113883.6.1" />
                  </code>
                  <statusCode code="completed" />
                  <effectiveTime>
                    <low nullFlavor ="UNK"/>
                    <high nullFlavor ="UNK"/>
                  </effectiveTime>
                  <!-- INFORMATION SOURCE FOR VITAL SIGN ORGANIZER/PANEL, Optional -->
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <representedOrganization>
                        <!-- INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR -->
                        <id root="2.16.840.1.113883.4.349" />
                        <!-- INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME -->
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!-- One component block for each Vital Sign -->
                  <component>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
                      <!-- 14.01-VITAL SIGN RESULT ID, REQUIRED -->
                      <id root="2.16.840.1.113883.4.349" extension="vitalID"/>
                      <!-- 14.03-VITAL SIGN RESULT TYPE, REQUIRED, LOINC -->
                      <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
                        <originalText>
                          <reference />
                        </originalText>
                        <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                      </code>
                      <text>
                        <reference />
                      </text>
                      <!-- 14.04-VITAL SIGN RESULT STATUS, REQUIRED, Static value of completed -->
                      <statusCode code="completed" />
                      <!-- 14.02-VITAL SIGN RESULT DATE/TIME, REQURIED -->
                      <effectiveTime nullFlavor="UNK" />
                      <!-- 14.05-VITAL SIGN RESULT VALUE, CONDITIONALLY REQUIRED when 
                                    moodCode=EVN -->
                      <!-- 14.05-VITAL SIGN RESULT VALUE with Unit of Measure -->
                      <value xsi:type="PQ" >
                        <translation code="vaUnit"  codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" displayName="vaUnit"/>
                      </value>
                      <interpretationCode nullFlavor="NI" />
                      <!-- 14.06-VITAL SIGN RESULT INTERPRETATION, Optional, HL7 Result 
                                    Normalcy Status Value Set -->
                      <!-- 14.06-VITAL SIGN RESULT INTERPRETATION, Removed b/c data not 
                                    yet available via VA VistA RPCs -->
                      <!-- 14.07-VITAL SIGN RESULT REFERENCE RANGE, Optional, -->
                      <!-- 14.07-VITAL SIGN RESULT REFERENCE RANGE, Removed b/c data not 
                                    yet available via VA VistA RPCs -->
                      <methodCode nullFlavor="UNK">
                        <originalText/>
                      </methodCode>
                      <targetSiteCode nullFlavor="UNK">
                        <originalText/>
                      </targetSiteCode>
                    </observation>
                  </component>
                </organizer>
              </entry>
            </section>
          </component>

          <!-- ************************* STANDALONE NOTE SECTIONS BELOW *************** -->
          <component>
            <!--Consultation Notes -->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01" />
              <code code="11488-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Consultation Note" />
              <title>Consult Notes</title>
              <text>
                <!-- Start Consult Notes Narrative -->
                <paragraph MAP_ID="ConsultNotesSectionTitle">
                  <content styleCode="Bold">Consult Notes</content>
                </paragraph>
                <!-- Consult notes begin -->
                <paragraph MAP_ID="conTitle">
                  The list of Consult Notes with complete text includes all notes within the requested date range. If no date range was provided, the list of Consult Notes with complete text includes the 5 most recent notes within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="NoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Consult Note with Text</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- Condensed Consult notes begin title only -->
                <paragraph MAP_ID="conTitle2">
                  The list of ADDITIONAL Consult Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="NoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Consult Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- Stop Consult Notes Narrative -->
              </text>
              <entry>
                <!--Note Activity Entry -->
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation code="11488-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Consultation Note"/>
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!--Clinically relevant time of the note -->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!--Time note was actually written-->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
							<entryRelationship typeCode="COMP" inversionInd="true">
								<encounter>
									<id root="2.16.840.1.113883.4.349" />
								</encounter>
							</entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
          <component>
            <!--History and Physical Notes-->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01" />
              <code code="34117-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HandP Note" />
              <title>History and Physical Notes</title>
              <text>
                <!-- Start H&P Notes Narrative-->
                <paragraph MAP_ID="HandPNotesSectionTitle">
                  <content styleCode="Bold">History &amp; Physical Notes</content>
                </paragraph>
                <!-- history and physical notes begin -->
                <paragraph MAP_ID="hnpTitle">
                  The list of H &amp; P Notes with complete text includes all notes within the requested date range. If no date range was provided, the list of H &amp; P Notes with complete text includes the 2 most recent notes within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="HnPNoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>History &amp; Physical Note with Text</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- history and physical notes titles only begin -->
                <paragraph MAP_ID="hnpTitle2">
                  The list of ADDITIONAL H &amp; P Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="HnPNoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>History &amp; Physical Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry>
                <!--Note Activity Entry-->
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation code="34117-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HandP Note"/>
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!--Clinically relevant time of the note-->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!--Time note was actually written-->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
							<entryRelationship typeCode="COMP" inversionInd="true">
								<encounter>
									<id root="2.16.840.1.113883.4.349" />
								</encounter>
							</entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
          <component>
            <!-- Discharge Summaries Section -->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01" />
              <code code="18842-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Discharge Note" />
              <title>Discharge Summaries</title>
              <text>
                <paragraph MAP_ID="DischargeSumSectionTitle">
                  <content styleCode="Bold">Discharge Summaries</content>
                </paragraph>
                <!-- Discharge summary notes begin -->
                <paragraph MAP_ID="disTitle">
                  The list of Discharge Summaries with complete text includes all summaries within the requested date range. If no date range was provided, the list of Discharge Summaries includes the 2 most recent summaries within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="DisNoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Discharge Summary with Text</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- Discharge summary titles only notes begin  -->
                <paragraph MAP_ID="disTitle2">
                  The list of ADDITIONAL Discharge Summary TITLES includes all summaries signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="DisNoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Discharge Summary Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="noteProvider" />
                      </td>
                      <td>
                        <content ID="noteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry>
                <!--Note Activity Entry-->
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!--Clinically relevant time of the note-->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!--Time note was actually written-->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
							<entryRelationship typeCode="COMP" inversionInd="true">
								<encounter>
									<id root="2.16.840.1.113883.4.349" />
								</encounter>
							</entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
          <component MAP_ID="RADPATH">
            <!--Radiology Studies-->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01"/>
              <code code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Reports"/>
              <title>Radiology Reports</title>
              <text>
                <paragraph MAP_ID="radiologyTitle">
                  <content styleCode="Bold">Radiology Reports</content>
                </paragraph>
                <paragraph MAP_ID="radiologyRules">
                  This section includes all Radiology Reports within the requested date range. If no date range was provided, the included Radiology Reports are the 5 most recent reports within the last 24 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="radiologyNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Radiology Report</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td />

                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>

                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode='DRIV'>
                <!--Note Activity Entry-->
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Report" />
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!--Clinically relevant time of the note-->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!--Time note was actually written-->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
							<entryRelationship typeCode="COMP" inversionInd="true">
								<encounter>
									<id root="2.16.840.1.113883.4.349" />
								</encounter>
							</entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
          <component MAP_ID="RADPATH">
            <!--Pathology Studies-->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01"/>
              <code code="27898-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Pathology Reports"/>
              <title>Pathology Reports</title>
              <text>
                <paragraph MAP_ID="pathologyTitle">
                  <content styleCode="Bold">Pathology Reports</content>
                </paragraph>
                <paragraph MAP_ID="pathologyRules">
                  This section includes all Pathology Reports within the requested date range. If no date range was provided, the included Pathology Reports are the 5 most recent reports within the last 24 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="pathologyNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Pathology Report</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td />

                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                      <td>
                        <content />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode='DRIV'>
                <!--Note Activity Entry-->
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation code="27898-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Pathology Note" />
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!--Clinically relevant time of the note-->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!--Time note was actually written-->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
							<entryRelationship typeCode="COMP" inversionInd="true">
								<encounter>
									<id root="2.16.840.1.113883.4.349" />
								</encounter>
							</entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
          <component MAP_ID="ClinProcNotes">
            <!-- Clinical Procedure Notes -->
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.65" extension="2016-11-01" />
              <code code="28570-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Procedure Note" />
              <title>Clinical Procedure Notes</title>
              <text>
                <paragraph MAP_ID="clinPNotesTitle">
                  <content styleCode="Bold">Clinical Procedure Notes</content>
                </paragraph>
                <paragraph MAP_ID="clinPNotesTitleNote">
                  This section contains all Clinical Procedure Notes, with complete text, that have procedure dates within the requested date range. If no date range was provided, the section contains the 10 most recent Clinical Procedure Notes, with complete text, that have procedure dates within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="ClinicalNotesNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Clinical Procedure Note with Text</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="clinicalNoteDateTime" />
                      </td>
                      <td>
                        <content ID="clinicalNoteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="clinicalNoteProvider" />
                      </td>
                      <td>
                        <content ID="clinicalNoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>

                <!-- Additional Clinical Procedure Notes -->
                <paragraph MAP_ID="clinPNotesTitle2" styleCode="Bold">Additional Clinical Procedure Notes</paragraph>
                <paragraph MAP_ID="clinPNotesTitleNote2">
                  The list of ADDITIONAL Clinical Procedure Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table MAP_ID="ClinicalNotesNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Clinical Procedure Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="clinicalNoteDateTime" />
                      </td>
                      <td>
                        <content ID="clinicalNoteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="clinicalNoteProvider" />
                      </td>
                      <td>
                        <content ID="clinicalNoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode="DRIV" >
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.201" extension="2016-06-01"/>
                  <code code="82607-3" codeSystem="2.16.840.1.113883.6.1" displayName="Section Date and Time Range"/>
                  <text>
                    <reference value="#procedureTime"/>
                  </text>
                  <statusCode code="completed"/>
                  <value xsi:type="IVL_TS">
                    <low value="$proceduresStart" />
                    <high value="$proceduresEnd" />
                  </value>
                </observation>
              </entry>
              <!-- Note Entry -->
              <entry>
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.202" extension="2016-11-01" />
                  <code code="34109-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Note">
                    <translation code="28570-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Clinical Procedure Note" />
                  </code>
                  <text>
                    <reference />
                  </text>
                  <statusCode code="completed" />
                  <!-- Clinically relevant time of the note -->
                  <effectiveTime />
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <!-- Time note was actually written -->
                    <time />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <!--Reference to Encounter
                                                <entryRelationship typeCode="COMP" inversionInd="true">
                                                        <encounter>
                                                                <id root="2.16.840.1.113883.4.349" />
                                                        </encounter>
                                                </entryRelationship>-->
                </act>
              </entry>
            </section>
          </component>
        </structuredBody>
      </component>
    </ClinicalDocument>
  </xsl:template>
  <xsl:template match="*" mode="standard-address">
    <xsl:param name="use" />
    <xsl:choose>
      <xsl:when test="boolean(Address)">
        <addr use="{$use}">
          <xsl:if test="boolean(Address/Street)">
            <streetAddressLine><xsl:value-of select="Address/Street/text()" /></streetAddressLine>
          </xsl:if>
          <xsl:if test="boolean(Address/City/Code)">
            <city><xsl:value-of select="Address/City/Code/text()" /></city>
          </xsl:if>
          <xsl:if test="boolean(Address/State/Code)">
            <state><xsl:value-of select="Address/State/Code/text()" /></state>
          </xsl:if>
          <xsl:if test="boolean(Address/Zip/Code)">
            <postalCode><xsl:value-of select="Address/Zip/Code/text()" /></postalCode>
          </xsl:if>
        </addr>
      </xsl:when>
      <xsl:otherwise>
        <addr nullFlavor="NI" />      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
