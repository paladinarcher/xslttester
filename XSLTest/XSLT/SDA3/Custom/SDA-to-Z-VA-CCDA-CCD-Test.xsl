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
      <xsl:comment> ******************************************************** C-CDA CCD 
    R1.1 HEADER ******************************************************** </xsl:comment>
      <realmCode code="US" />
      <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040" />
      <templateId root="2.16.840.1.113883.10.20.22.1.1" />
      <templateId root="2.16.840.1.113883.10.20.22.1.2" />
      <xsl:comment> CCD Document Identifer, id=VA OID, extension=system-generated </xsl:comment>
      <id root="2.16.840.1.113883.4.349" />
      <xsl:comment> CCD Document Code </xsl:comment>
      <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
      <xsl:comment>CCD Document Title </xsl:comment>
      <title>Department of Veterans Affairs Health Summary</title>
      <xsl:comment> 1.01 DOCUMENT TIMESTAMP, REQUIRED </xsl:comment>
      <effectiveTime />
      <xsl:comment> CCD Confidentiality Code, REQUIRED </xsl:comment>
      <confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"
                                 codeSystemName="ConfidentialityCode" />
      <xsl:comment> CCD DOCUMENT LANGUAGE, REQUIRED </xsl:comment>
      <languageCode code="en-US" />
      <recordTarget>
        <patientRole>
          <xsl:comment> 1.02 PERSON ID, REQUIRED, id=VA OID, extension=GUID </xsl:comment>
          <id root="2.16.840.1.113883.4.349" />
          <xsl:comment> 1.03 PERSON ADDRESS-HOME PERMANENT, REQUIRED </xsl:comment>
          <addr use="HP">
            <streetAddressLine />
            <city />
            <state />
            <postalCode />
          </addr>
          <xsl:comment> 1.04 PERSON PHONE/EMAIL/URL, REQUIRED </xsl:comment>
          <telecom />
          <patient>
            <xsl:comment> 1.05 PERSON NAME LEGAL, REQUIRED </xsl:comment>
            <name use="L">
              <prefix />
              <given />
              <given MAP_ID="middle" />
              <family />
              <suffix />
            </name>
            <xsl:comment> 1.05 PERSON NAME Alias Name, Optional </xsl:comment>
            <name use="A">
              <prefix />
              <given />
              <family />
              <suffix />
            </name>
            <xsl:comment> 1.06 GENDER, REQUIRED, HL7 Administrative Gender </xsl:comment>
            <administrativeGenderCode codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode">
              <originalText>
                <reference />
              </originalText>
            </administrativeGenderCode>
            <xsl:comment> 1.07 PERSON DATE OF BIRTH, REQUIRED </xsl:comment>
            <birthTime />
            <maritalStatusCode code='maritalCode' codeSystem='2.16.840.1.113883.5.2' codeSystemName='MaritalStatusCode' >
              <originalText />
              <xsl:comment> 1.08 MARITAL STATUS, Optional-R2 </xsl:comment>
            </maritalStatusCode>
            <xsl:comment> 1.09 RELIGIOUS AFFILIATION, Optional, Removed b/c data not yet available 
                via VA VIstA RPCs </xsl:comment>
            <religiousAffiliationCode codeSystem='2.16.840.1.113883.5.1076' codeSystemName='HL7 Religious Affiliation' >
              <originalText>religiousAffiliation</originalText>
            </religiousAffiliationCode>
            <xsl:comment> 1.10 RACE, Optional </xsl:comment>
            <raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </raceCode>
            <sdtc:raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </sdtc:raceCode>
            <xsl:comment> 1.11 ETHNICITY, Optional </xsl:comment>
            <ethnicGroupCode
                        codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>ethnicity</originalText>
            </ethnicGroupCode>
            <xsl:comment> ********************************************************** LANGUAGE 
                SPOKEN CONTENT MODULE, R2 ********************************************************** </xsl:comment>
            <languageCommunication MAP_ID="PL">
              <xsl:comment> 2.01 LANGUAGE, REQUIRED, languageCode ISO 639-1 </xsl:comment>
              <languageCode nullFlavor="NA" />
              <modeCode nullFlavor="NA" />
              <proficiencyLevelCode nullFlavor="NA" />
              <preferenceInd value="true" />
            </languageCommunication>
            <languageCommunication MAP_ID="OL">
              <xsl:comment> 2.01 LANGUAGE, REQUIRED, languageCode ISO 639-1 </xsl:comment>
              <languageCode nullFlavor="NA" />
              <modeCode nullFlavor="NA" />
              <proficiencyLevelCode nullFlavor="NA" />
              <preferenceInd value="false" />
            </languageCommunication>
          </patient>
        </patientRole>
      </recordTarget>
      <xsl:comment> ********************************************************************** 
    INFORMATION SOURCE CONTENT MODULE, REQUIRED ********************************************************************** </xsl:comment>
      <xsl:comment> AUTHOR SECTION (REQUIRED) OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
      <author>
        <xsl:comment> 10.01 AUTHOR TIME (=Document Creation Date), REQUIRED </xsl:comment>
        <time value="documentCreatedOn" />
        <assignedAuthor>
          <xsl:comment> 10.02 AUTHOR ID (VA OID) (authorOID), REQUIIRED </xsl:comment>
          <xsl:comment> Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
          <addr nullFlavor="NA" />
          <xsl:comment> Assigned Author Telecom Required, but VA VistA data not yet available </xsl:comment>
          <telecom nullFlavor="NA" />
          <xsl:comment> 10.02 AUTHOR NAME REQUIRED </xsl:comment>
          <xsl:comment> assignedPerson/Author Name REQUIRED but provided as representedOrganization </xsl:comment>
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <xsl:comment> 10.02 AUTHOR NAME REQUIRED as representedOrganization </xsl:comment>
          <representedOrganization>
            <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION OID (VA OID) (deviceOrgOID), 
                REQUIIRED </xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
            <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION NAME (deviceOrgName), REQUIIRED </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> Assigned Author Telecom Required, but VA VistA data not yet available </xsl:comment>
            <telecom nullFlavor="NA" />
            <xsl:comment> Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
            <addr nullFlavor="NA" />
          </representedOrganization>
        </assignedAuthor>
      </author>
      <xsl:comment> ******************************************************************************************* 
    INFORMANT SECTION (AS AN ORGANIZATION), Optional ******************************************************************************************* </xsl:comment>
      <informant>
        <assignedEntity>
          <id nullFlavor="NI" />
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <xsl:comment> Name Required for informant/assignedEntity/assignedPerson </xsl:comment>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <xsl:comment> 10.06 INFORMATION SOURCE ORGANIZATION OID (VA OID) (sourceOrgOID), 
                REQUIRED </xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
            <xsl:comment> 10.06 INFORMATION SOURCE ORGANIZATION NAME (sourceOrgName), REQUIRED </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <telecom nullFlavor="NA" />
            <addr nullFlavor="NA" />
          </representedOrganization>
        </assignedEntity>
      </informant>
      <xsl:comment> ********************************************************************************* 
    CUSTODIAN AS AN ORGANIZATION, REQUIRED ********************************************************************************** </xsl:comment>
      <custodian>
        <assignedCustodian>
          <representedCustodianOrganization>
            <xsl:comment> CUSTODIAN OID (VA OID) </xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
            <xsl:comment> CUSTODIAN NAME </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment> Telecom Required for representedOrganization, but VA VistA data 
                not yet available </xsl:comment>
            <telecom nullFlavor="NA" />
            <xsl:comment> Address Required for representedOrganization, but VA VistA data 
                not yet available </xsl:comment>
            <addr>
              <streetAddressLine>810 Vermont Avenue NW</streetAddressLine>
              <city>Washington</city>
              <state>DC</state>
              <postalCode>20420</postalCode>
            </addr>
          </representedCustodianOrganization>
        </assignedCustodian>
      </custodian>
      <xsl:comment> *************************************************************************** 
    LEGAL AUTHENTICATOR (AS AN ORGANIZATION), Optional *************************************************************************** </xsl:comment>
      <legalAuthenticator>
        <xsl:comment> TIME OF AUTHENTICATION </xsl:comment>
        <time value=" " />
        <signatureCode code="S" />
        <assignedEntity>
          <id nullFlavor="NA" />
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <xsl:comment> LEGAL AUTHENTICATOR OID (VA) </xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
            <name>Department of Veterans Affairs</name>
            <telecom nullFlavor="NA" />
            <addr>810 Vermont Avenue NW Washington, DC 20420</addr>
          </representedOrganization>
        </assignedEntity>
      </legalAuthenticator>
      <xsl:comment> ******************************************************************** 
    SUPPORT INFORMATION CONTENT MODULE, Optional ******************************************************************** </xsl:comment>
      <participant typeCode="IND">
        <xsl:comment> 3.01 DATE, REQUIRED </xsl:comment>
        <xsl:comment> 3.01 DATE date as nullFlavor b/c data not yet available via VA VistA 
        RPCs </xsl:comment>
        <time nullFlavor="UNK" />
        <xsl:comment> 3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value 
        in contactType </xsl:comment>
        <associatedEntity classCode="contactType">
          <code code="UNK" codeSystem='2.16.840.1.113883.5.111'
                                  codeSystemName='RoleCode'>
            <originalText>relationshipType</originalText>
          </code>
          <xsl:comment> 3.04 CONTACT Addresss, Home Permanent, Optional-R2 </xsl:comment>
          <addr use="HP">
            <streetAddressLine>homeAddressLine</streetAddressLine>
            <city>homeCity</city>
            <state>homeState</state>
            <postalCode>homePostal</postalCode>
          </addr>
          <xsl:comment> 3.05 CONTACT PHONE/EMAIL/URL, Optional-R2, Removed b/c data not yet 
            available via VA VistA RPCs </xsl:comment>
          <telecom />
          <associatedPerson>
            <xsl:comment> 3.06 CONTACT NAME, REQUIRED </xsl:comment>
            <name>
              <prefix />
              <given>nameGiven</given>
              <family>nameFamily</family>
              <suffix>nameSuffix</suffix>
            </name>
          </associatedPerson>
        </associatedEntity>
      </participant>
      <xsl:comment> ******************************************************************************* 
    DOCUMENTATION OF MODULE - QUERY META DATA, Optional ******************************************************************************* </xsl:comment>
      <documentationOf>
        <serviceEvent classCode="PCPR">
          <effectiveTime>
            <low value="" />
            <high value="" />
          </effectiveTime>


          <performer typeCode="PRF" MAP_ID="PCP">
            <xsl:comment> ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* </xsl:comment>
            <xsl:comment> 4.02 PROVIDER ROLE CODED, optional </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.6.2.1" />
            <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88"
                                                  codeSystemName="HL7 particiationFunction" displayName="Primary Care Provider">
              <originalText>Primary Care Provider</originalText>
            </functionCode>
            <assignedEntity>
              <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
              <id extension="providerN" root="2.16.840.1.113883.4.349" />
              <xsl:comment>4.04 PROVIDER TYPE, optional, NUCC </xsl:comment>
              <code codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC">
                <originalText />
              </code>
              <xsl:comment> Address Required for assignedEntity </xsl:comment>
              <addr use="WP">
                <streetAddressLine />
                <city />
                <state />
                <postalCode />
              </addr>
              <xsl:comment> Telecom Required for iassignedEntity, but VA VistA data not yet 
                    available </xsl:comment>
              <telecom nullFlavor="NI"/>
              <xsl:comment> 4.07-PROVIDER NAME, REQUIRED </xsl:comment>
              <assignedPerson>
                <name />
              </assignedPerson>
              <representedOrganization>
                <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING 
                        FACILITY NBR </xsl:comment>
                <id root="2.16.840.1.113883.4.349" />
                <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                <name />
                <xsl:comment> Telecom Required for representedOrganization, but VA VistA data 
                        not yet available </xsl:comment>
                <telecom nullFlavor="UNK" />
                <xsl:comment> Address Required for representedOrganization, but VA VistA data 
                        not yet available </xsl:comment>
                <addr nullFlavor="UNK" />
              </representedOrganization>
            </assignedEntity>
          </performer>
          <performer typeCode="PRF" MAP_ID="PC_TEAM">
            <xsl:comment> ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* </xsl:comment>
            <xsl:comment> 4.02 PROVIDER ROLE CODED, optional </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.6.2.1" />
            <functionCode code="PC_TEAM">
              <originalText/>
            </functionCode>
            <assignedEntity>
              <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
              <id extension="providerN" root="2.16.840.1.113883.4.349" />
              <xsl:comment>4.04 PROVIDER TYPE, optional, NUCC </xsl:comment>
              <code codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC">
                <originalText />
              </code>
              <xsl:comment> Address NOT Required for Care team  </xsl:comment>
              <addr nullFlavor="UNK" />

              <xsl:comment> Telecom Required for iassignedEntity, but VA VistA data not yet 
                    available </xsl:comment>
              <telecom nullFlavor="NI"/>
              <xsl:comment> 4.07-PROVIDER NAME, REQUIRED </xsl:comment>
              <assignedPerson>
                <name />
              </assignedPerson>
              <representedOrganization>
                <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING 
                        FACILITY NBR </xsl:comment>
                <id root="2.16.840.1.113883.4.349" />
                <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                <name />
                <xsl:comment> Telecom Required for representedOrganization, but VA VistA data 
                        not yet available </xsl:comment>
                <telecom nullFlavor="UNK" />
                <xsl:comment> Address Required for representedOrganization, but VA VistA data 
                        not yet available <xsl:comment>
                <addr nullFlavor="UNK" />
              </representedOrganization>
            </assignedEntity>
          </performer>
        </serviceEvent>
      </documentationOf>
      <xsl:comment> Per C-CDA R2.1 Companion Guide, componentOf/encompassingEncounter omitted for multiple episode CCD </xsl:comment>
      <xsl:comment> ******************************************************** CDA BODY ******************************************************** </xsl:comment>
      <component>
        <structuredBody>
          <component>
            <xsl:comment> ********************************************************************************** 
                INSURANCE PROVIDERS (PAYERS) SECTION, Optional ********************************************************************************** </xsl:comment>
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.18" />
              <code code="48768-6" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Payers" />
              <title>Insurance Providers (Payers) Section</title>
              <xsl:comment> PAYERS NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VA Insurance Providers Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section includes the names of all active insurance
                  providers for the patient.
                </paragraph>
                <table ID="insuranceNarrative">
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
              <xsl:comment> PAYERS STRUCTURED DATA </xsl:comment>
              <xsl:comment> CCD Coverage Activity </xsl:comment>
              <entry>
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.60" />
                  <id nullFlavor="NA" />
                  <code code="48768-6" codeSystem="2.16.840.1.113883.6.1"
                                                                  codeSystemName="LOINC" displayName="Payment Sources" />
                  <statusCode code="completed" />
                  <xsl:comment> CCD Payment Provider Event Entry </xsl:comment>
                  <entryRelationship typeCode="COMP">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.61" />
                      <xsl:comment> 5.01 GROUP NUMBER, REQUIRED </xsl:comment>
                      <id extension="groupNbr" root="2.16.840.1.113883.4.349" />
                      <xsl:comment> 5.02 HEALTH INSURANCE TYPE, REQURIED </xsl:comment>
                      <code codeSystem="2.16.840.1.113883.6.255.1336" codeSystemName="X12N-1336" >
                        <originalText />
                      </code>
                      <statusCode code="completed" />
                      <xsl:comment> 5.07 - Health Plan Coverage Dates, R2-Optional  </xsl:comment>
                      <effectiveTime>
                        <xsl:comment> 5.07 VistA Policy Effective Date <xsl:comment>
                        <low />
                          <xsl:comment> 5.07 VistA Policy Expiration  Date </xsl:comment>
                        <high />
                      </effectiveTime>
                      <performer typeCode="PRF">
                        <templateId root="2.16.840.1.113883.10.20.22.4.87" />
                        <xsl:comment> CCD Payer Info </xsl:comment>
                        <assignedEntity>
                          <xsl:comment> 5.03 HEALTH PLAN INSURANCE INFO SOURCE ID, REQUIRED </xsl:comment>
                          <id root="2.16.840.1.113883.4.349" />
                          <code />
                          <xsl:comment> 5.04 HEALTH PLAN INSURANCE INFO SOURCE ADDRESS, Optional </xsl:comment>
                          <addr>
                            <streetAddressLine />
                            <streetAddressLine />
                            <city />
                            <state />
                            <postalCode />
                          </addr>
                          <xsl:comment> 5.05 HEALTH PLAN INSURANCE INFO SOURCE PHONE/EMAIL/URL, Optional </xsl:comment>
                          <telecom />
                          <representedOrganization>
                            <xsl:comment> 5.06 HEALTH PLAN INSURANCE INFO SOURCE NAME ( Insurance 
                                                Company Name), R2 </xsl:comment>
                            <name />
                            <addr />
                          </representedOrganization>
                        </assignedEntity>
                      </performer>
                      <author>
                        <time nullFlavor="UNK" />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <representedOrganization>
                            <id root="2.16.840.1.113883.4.349" />
                            <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                            <name />
                            <telecom nullFlavor="NA" />
                            <addr nullFlavor="NA" />
                          </representedOrganization>
                        </assignedAuthor>
                      </author>
                      <participant typeCode="COV">
                        <templateId root="2.16.840.1.113883.10.20.22.4.89" />
                        <participantRole>
                          <id root="2.16.840.1.113883.4.349" />
                          <xsl:comment> 5.09 PATIENT RELATIONSHIP TO SUBSCRIBER, REQUIRED, HL7 Coverage 
                                            Role Type </xsl:comment>
                          <code nullFlavor="UNK" >
                            <originalText>
                              <reference/>
                            </originalText>
                          </code>
                          <playingEntity>
                            <xsl:comment> 5.12 PATIENT NAME, REQUIRED </xsl:comment>
                            <name use="L">
                              <prefix />
                              <given />
                              <family />
                              <suffix />
                            </name>
                            <xsl:comment> 5.13 PATIENT DATE OF BIRTH, R2 </xsl:comment>
                            <sdtc:birthTime nullFlavor="UNK" />
                          </playingEntity>
                        </participantRole>
                      </participant>
                      <participant typeCode="HLD">
                        <templateId root="2.16.840.1.113883.10.20.22.4.90" />
                        <participantRole>
                          <id root="2.16.840.1.113883.4.349" />
                          <playingEntity>
                            <xsl:comment> 5.18 SUBSCRIBER NAME, REQUIRED </xsl:comment>
                            <name />
                            <xsl:comment> 5.19 SUBSCRIBER DATE OF BIRTH, R2 </xsl:comment>
                            <sdtc:birthTime nullFlavor="UNK"/>
                            <xsl:comment> 5.17 SUBSCRIBER PHONE </xsl:comment>
                            <telecom nullFlavor="NA" />
                            <xsl:comment> 5.11 SUBSCRIBER ADDRESS </xsl:comment>
                            <addr use="HP" nullFlavor="NA" />
                          </playingEntity>
                        </participantRole>
                      </participant>
                      <xsl:comment> 5.24 HEALTH PLAN NAME, optional </xsl:comment>
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
            <xsl:comment> ******************************************************** ADVANCED 
                DIRECTIVE SECTION, REQUIRED ******************************************************** </xsl:comment>
            <section>
              <xsl:comment>C-CDA Advanced Directive Section Template Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.21.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.21" />
              <code code="42348-3" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Advance Directives" />
              <title>Advance Directives</title>
              <xsl:comment> ADVANCED DIRECTIVES NARRATIVE BLOCK </xsl:comment>
              <text>
                <paragraph>
                  This section includes a list of a patient's completed, amended, or rescinded VA Advance Directives,
                  but an actual copy is not included.
                </paragraph>
                <table ID="advancedirectivesnarrative">
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
              <xsl:comment> ADVANCED DIRECTIVES STRUCTURED DATA </xsl:comment>
              <entry>
                <xsl:comment> CCD Advanced Directive Observation, R2 </xsl:comment>
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.48" />
                  <id nullFlavor="NA" />
                  <xsl:comment> 12.01 ADVANCED DIRECTIVE TYPE, REQUIRED, SNOMED CT </xsl:comment>
                  <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.96"
                                                                  codeSystemName="SNOMED CT">
                    <originalText>
                      <reference />
                    </originalText>
                  </code>
                  <statusCode code="completed" />
                  <xsl:comment> 12.03 ADVANCED DIRECTIVE EFFECTIVE DATE, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <xsl:comment> ADVANCED DIRECTIVE EFFECTIVE DATE low = starting time, REQUIRED </xsl:comment>
                    <low />
                    <xsl:comment> ADVANCED DIRECTIVE EFFECTIVE DATE high= ending time, REQUIRED </xsl:comment>
                    <high nullFlavor="NA" />
                  </effectiveTime>

                  <author>
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>

                  <participant typeCode="VRF">
                    <time />
                    <participantRole>
                      <addr nullFlavor="NA" />
                      <xsl:comment> VERIFIER PHONE/EMAIL/URL, R2 </xsl:comment>
                      <telecom nullFlavor="NA" />
                      <playingEntity>
                        <xsl:comment> VERIFIER NAME, RQUIRED </xsl:comment>
                        <name>Department of Veterans Affairs</name>
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <xsl:comment> CUSTODIAN OF DOCUMENT, REQUIRED </xsl:comment>
                  <participant typeCode="CST">
                    <participantRole classCode="AGNT">
                      <xsl:comment> CUSTODIAN ADDRESS, R2 </xsl:comment>
                      <addr>810 Vermont Avenue NW Washington, DC 20420</addr>
                      <xsl:comment> CUSTODIAN PHONE?EMAIL/URL, R2 </xsl:comment>
                      <telecom nullFlavor="NA" />
                      <playingEntity>
                        <xsl:comment> CUSTODIAN NAME, REQUIRED </xsl:comment>
                        <name />
                      </playingEntity>
                    </participantRole>
                  </participant>



                  <xsl:comment> ADVANCED DIRECTIVE REFERENCE, R2, not provided by VA </xsl:comment>

                </observation>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ************************************************************* ALLERGY/DRUG 
                SECTION SECTION, REQUIRED ************************************************************* </xsl:comment>
            <section>
              <xsl:comment> ALLERGY/DRUG Section Template Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.6.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.6" />
              <code code="48765-2" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
              <title>Allergies Section</title>
              <xsl:comment> ALLERGIES NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VA Allergies/Drug Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section includes Allergies on record with VA for the
                  patient. The data comes from all VA treatment facilities. It does
                  not list allergies that were removed or entered in error. Some
                  allergies may also be reported in the Immunization section.
                </paragraph>
                <table ID="allergyNarrative">
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
              <xsl:comment> ALLERGIES STRUCTURED DATA </xsl:comment>
              <entry typeCode="DRIV">
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.30" />
                  <xsl:comment> CCD Allergy Act ID as nullflavor </xsl:comment>
                  <id nullFlavor="NA" />
                  <code code="48765-2" codeSystem="2.16.840.1.113883.6.1"
                                                                  codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
                  <statusCode code="active" />
                  <effectiveTime nullFlavor="NA">
                    <low nullFlavor="NA" />
                  </effectiveTime>
                  <xsl:comment> INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR </xsl:comment>
                        <id root="2.16.840.1.113883.4.349" />
                        <xsl:comment>INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode="SUBJ"
                                                                               inversionInd="true">
                    <xsl:comment> Allergy Intolerance Observation Entry </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN"
                                                                                 negationInd="false">
                      <templateId root="2.16.840.1.113883.10.20.22.4.7" />
                      <id nullFlavor="NA" />
                      <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"
                                                                                  codeSystemName="HL7ActCode" />
                      <statusCode code="completed" />
                      <xsl:comment> 6.01 ADVERSE EVENT DATE, REQUIRED </xsl:comment>
                      <effectiveTime>
                        <low />
                      </effectiveTime>
                      <xsl:comment> 6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT </xsl:comment>
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                        <originalText>
                          <reference />
                        </originalText>
                      </value>
                      <participant typeCode="CSM">
                        <participantRole classCode="MANU">
                          <playingEntity classCode="MMAT">
                            <xsl:comment> 6.04 PRODUCT CODED,REQUIRED </xsl:comment>
                            <code codeSystem="2.16.840.1.113883.6.88"
                                                                                                          codeSystemName="RxNorm">
                              <originalText>
                                <reference />
                              </originalText>
                              <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                              <xsl:comment> 6.03 PRODUCT FREE TEXT, R2 </xsl:comment>
                            </code>
                            <name />
                          </playingEntity>
                        </participantRole>
                      </participant>
                      <xsl:comment> REACTION ENTRY RELATIONSHIP BLOCK R2, repeatable </xsl:comment>
                      <entryRelationship typeCode="MFST"
                                                                                               inversionInd="true">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.9" />
                          <id nullFlavor="NA" />
                          <code nullFlavor="NA" />
                          <statusCode code="completed" />

                          <xsl:comment> 6.06 REACTION CODED, REQUIRED </xsl:comment>

                          <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                            <xsl:comment> 6.05 REACTION-FREE TEXT, optional, </xsl:comment>
                            <originalText>
                              <reference />
                            </originalText>
                            <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                          </value>
                        </observation>
                      </entryRelationship>
                      <xsl:comment> SEVERITY ENTRY RELATIONSHIP BLOCK R2, 0 or 1 per Allergy </xsl:comment>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="true">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.8" />
                          <code code="SEV" displayName="Severity Observation"
                                                                                                  codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode" />
                          <statusCode code="completed" />
                          <xsl:comment> 6.08 SEVERITY CODED, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD"
                                                                                                   codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                            <xsl:comment> 6.07 SEVERITY FREE TEXT, Optional-R2 Removed b/c removed 
                                                in template </xsl:comment>
                            <originalText>
                              <reference />
                            </originalText>
                          </value>
                        </observation>
                      </entryRelationship>
                    </observation>
                  </entryRelationship>
                </act>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** ENCOUNTER 
                SECTION, Optional ******************************************************** </xsl:comment>
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.22.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.22" />
              <code code="46240-8" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Encounters" />
              <title>Encounters Section</title>
              <text>
                <xsl:comment> VA Encounter Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section contains a list of completed VA Outpatient Encounters for
                  the patient and a list of Encounter Notes, Consult Notes, History &amp;
                  Physical Notes, and Discharge Summaries for the patient. The data comes
                  from all VA treatment facilities.
                  <br />
                  <br />
                </paragraph>

                <paragraph ID="opEncTitle">
                  The list of VA Outpatient Encounters shows all Encounter dates within
                  the requested date range. If no date range was provided, the list of VA
                  Outpatient Encounters shows all Encounter dates within the last 18 months.
                  Follow-up visits related to the VA Encounter are not included. The data comes
                  from all VA treatment facilities.
                </paragraph>
                <table ID="encounterNarrative">
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
                </table>
                <xsl:comment> Start Associated Notes Narrative </xsl:comment>
                <paragraph ID="anTitle">
                  The list of Encounter Notes shows the 5 most recent notes associated to the 10 most recent
                  Outpatient Encounters. The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="anNoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note</th>
                      <th>Provider</th>
                      <th>Source</th>
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
                      <td>
                        <content ID="anNoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment> Stop Associated Notes Narrative </xsl:comment>
                <xsl:comment> Consult notes begin </xsl:comment>
                <paragraph ID="conTitle">
                  The list of Consult Notes with complete text includes all notes within the requested date range. If no date range was provided, the list of Consult Notes with complete text includes the 5 most recent notes within the last 18 months.
                  The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="NoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note</th>
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
                <xsl:comment> Condensed Consult notes begin title only </xsl:comment>
                <paragraph ID="conTitle2">
                  The list of ADDITIONAL Consult Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="NoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="noteDateTime2" />
                      </td>
                      <td>
                        <content ID="noteEncounterDescription2" />
                      </td>
                      <td>
                        <content ID="noteProvider2" />
                      </td>
                      <td>
                        <content ID="noteSource2" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment> history and physical notes begin </xsl:comment>
                <paragraph ID="hnpTitle">
                  The list of H &amp; P Notes with complete text includes all notes within the requested date range.
                  If no date range was provided, the list of H &amp; P Notes with complete text includes the 2 most recent notes within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="HnPNoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="HnPnoteDateTime" />
                      </td>
                      <td>
                        <content ID="HnPnoteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="HnPnoteProvider" />
                      </td>
                      <td>
                        <content ID="HnPnoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment> history and physical notes titles only begin </xsl:comment>
                <paragraph ID="hnpTitle2">
                  The list of ADDITIONAL H &amp; P Note TITLES includes all notes signed within the last 18 months.
                  The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="HnPNoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="HnPnoteDateTime2" />
                      </td>
                      <td>
                        <content ID="HnPnoteEncounterDescription2" />
                      </td>
                      <td>
                        <content ID="HnPnoteProvider2" />
                      </td>
                      <td>
                        <content ID="HnPnoteSource2" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment> Discharge summary notes begin </xsl:comment>
                <paragraph ID="disTitle">
                  The list of Discharge Summaries with complete text includes all summaries within the requested date range.
                  If no date range was provided, the list of Discharge Summaries includes the 2 most recent summaries within the last 18 months.
                  The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="DisNoteNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="DisnoteDateTime" />
                      </td>
                      <td>
                        <content ID="DisnoteEncounterDescription" />
                      </td>
                      <td>
                        <content ID="DisnoteProvider" />
                      </td>
                      <td>
                        <content ID="DisnoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <xsl:comment> Discharge summary titles only notes begin </xsl:comment>
                <paragraph ID="disTitle2">
                  The list of ADDITIONAL Discharge Summary TITLES includes all summaries signed within the last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="DisNoteNarrative2">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Encounter Note Title</th>
                      <th>Provider</th>
                      <th>Source</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <content ID="DisnoteDateTime2" />
                      </td>
                      <td>
                        <content ID="DisnoteEncounterDescription2" />
                      </td>
                      <td>
                        <content ID="DisnoteProvider2" />
                      </td>
                      <td>
                        <content ID="DisnoteSource2" />
                      </td>
                    </tr>
                  </tbody>
                </table>

                <xsl:comment> CDA Observation Text as a Reference tag </xsl:comment>
                <content ID='encNote-1' revised="delete">
                  IHE Encounter Template
                  Text not used by VA
                </content>
              </text>
              <entry>
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="NI" />
                  <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                  <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation>
                      <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                      <originalText>
                        <reference />
                      </originalText>
                    </translation>

                  </code>
                  <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment> 16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low  />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <playingEntity classCode="PLC" />
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                      <id nullFlavor="NI" />
                      <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                      <code nullFlavor="UNK" />
                      <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional <xsl:comment>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96"
                                                                                   codeSystemName="SNOMED CT" />
                    </observation>
                  </entryRelationship>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT </xsl:comment>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS, Optional </xsl:comment>
                  <entryRelationship typeCode="SUBJ"
                                                                               inversionInd="false">
                    <act classCode="ACT" moodCode="EVN">
                      <xsl:comment>Encounter diagnosis act <xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                      <id nullFlavor="UNK" />
                      <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                      <statusCode code="active" />
                      <effectiveTime nullFlavor="UNK" />

                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN"
                                                                                                 negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                          <xsl:comment> Problem Observation </xsl:comment>
                          <id nullFlavor="UNK" />

                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>

                          <statusCode code="completed" />
                          <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" codeSystemName="SNOMED CT"
                                                                                                   codeSystem="2.16.840.1.113883.6.96">
                            <originalText>
                              <reference />
                            </originalText>
                            <translation codeSystemName="ICD-9-CM"
                                                                                                                 codeSystem="2.16.840.1.113883.6.103" >
                            </translation>

                          </value>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>

                  <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs </xsl:comment>
                </encounter>
              </entry>
              <entry typeCode="DRIV" id="con">
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="UNK" />
                  <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                  <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation/>
                  </code>
                  <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment> 16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low   />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                      <code nullFlavor="UNK"/>
                      <addr nullFlavor="UNK"/>
                      <telecom nullFlavor="UNK"/>
                      <playingEntity classCode="PLC">
                        <name />
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                      <id nullFlavor="NI" />
                      <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                      <code nullFlavor="UNK" />
                      <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional </xsl:comment>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <effectiveTime>
                        <low nullFlavor="UNK" />
                      </effectiveTime>
                      <value xsi:type="CD" />
                    </observation>
                  </entryRelationship>
                  <entryRelationship typeCode="SUBJ"	inversionInd="false">
                    <act classCode="ACT" moodCode="EVN">
                      <xsl:comment>Encounter diagnosis act </xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                      <id nullFlavor="UNK" />
                      <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                      <statusCode code="active" />
                      <effectiveTime nullFlavor="UNK">
                      </effectiveTime>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN"
                                                                                                 negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                          <xsl:comment> Problem Observation </xsl:comment>
                          <id nullFlavor="UNK" />
                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>
                          <statusCode code="completed" />
                          <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" code="UNK" codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'/>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT </xsl:comment>
                  <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs </xsl:comment>
                </encounter>
              </entry>
              <entry typeCode="DRIV" id="hnp">
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="NI" />
                  <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                  <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation/>
                  </code>
                  <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low  />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                      <code nullFlavor="UNK"/>
                      <addr nullFlavor="UNK"/>
                      <telecom nullFlavor="UNK"/>
                      <playingEntity classCode="PLC">
                        <name />
                      </playingEntity>
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                      <id nullFlavor="NI" />
                      <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                      <code nullFlavor="UNK" />
                      <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional </xsl:comment>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <effectiveTime>
                        <low nullFlavor="UNK" />
                      </effectiveTime>
                      <value xsi:type="CD" />
                    </observation>
                  </entryRelationship>
                  <entryRelationship typeCode="SUBJ"	inversionInd="false">
                    <act classCode="ACT" moodCode="EVN">
                      <xsl:comment>Encounter diagnosis act </xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                      <id nullFlavor="UNK" />
                      <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                      <statusCode code="active" />
                      <effectiveTime nullFlavor="UNK">
                      </effectiveTime>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN"
                                                                                                 negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                          <xsl:comment> Problem Observation </xsl:comment>
                          <id nullFlavor="UNK" />
                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>
                          <statusCode code="completed" />
                          <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" code="UNK" codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'/>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT </xsl:comment>
                  <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs </xsl:comment>
                </encounter>
              </entry>
              <entry typeCode="DRIV" id="dis">
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="NI" />
                  <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                  <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation/>
                  </code>

                  <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low  />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <playingEntity classCode="PLC" />
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                      <id nullFlavor="NI" />
                      <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                      <code nullFlavor="UNK" />
                      <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional </xsl:comment>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96"
                                                                                   codeSystemName="SNOMED CT" />
                    </observation>
                  </entryRelationship>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT <xsl:comment>


                  <entryRelationship typeCode="SUBJ"	inversionInd="false">
                    <act classCode="ACT" moodCode="EVN">
                      <xsl:comment>Encounter diagnosis act </xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                      <id nullFlavor="UNK" />
                      <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                      <statusCode code="active" />
                      <effectiveTime nullFlavor="UNK">
                      </effectiveTime>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN"
                                                                                                 negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                          <xsl:comment> Problem Observation </xsl:comment>
                          <id nullFlavor="UNK" />
                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>
                          <statusCode code="completed" />
                            <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" code="UNK" codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'/>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>
                </encounter>
              </entry>


              <entry typeCode="DRIV" id="eds">
                <encounter classCode="ENC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                  <id nullFlavor="NI" />
                  <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                  <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                    <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation/>
                  </code>

                  <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA 
                            VistA </xsl:comment>
                  <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                  <participant typeCode="LOC">
                    <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                    <time>
                      <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                      <low  />
                      <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                      <high  />
                    </time>
                    <participantRole classCode="SDLOC">
                      <playingEntity classCode="PLC" />
                    </participantRole>
                  </participant>
                  <entryRelationship typeCode="RSON">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                      <id nullFlavor="NI" />
                      <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                      <code nullFlavor="UNK" />
                      <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional </xsl:comment>
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96"
                                                                                   codeSystemName="SNOMED CT" />
                    </observation>
                  </entryRelationship>

                  <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT </xsl:comment>


                  <entryRelationship typeCode="SUBJ"	inversionInd="false">
                    <act classCode="ACT" moodCode="EVN">
                      <xsl:comment>Encounter diagnosis act </xsl:comment>
                      <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                      <id nullFlavor="UNK" />
                      <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1"
                                                                                  codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                      <statusCode code="active" />
                      <effectiveTime nullFlavor="UNK">
                      </effectiveTime>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="false">
                        <observation classCode="OBS" moodCode="EVN"
                                                                                                 negationInd="false">
                          <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                          <xsl:comment> Problem Observation </xsl:comment>
                          <id nullFlavor="UNK" />
                          <code nullFlavor="UNK">
                            <originalText>Encounter Diagnosis Type Not Available</originalText>
                          </code>
                          <statusCode code="completed" />
                          <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" code="UNK" codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'/>
                        </observation>
                      </entryRelationship>
                    </act>
                  </entryRelationship>
                </encounter>
              </entry>

            </section>
          </component>
          <xsl:comment> ***** FUNCTIONAL STATUS, Optional ************ </xsl:comment>
          <component>
            <section>
              <templateId root="2.16.840.1.113883.10.20.22.2.14" />
              <code code="47420-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"
                                                  displayName="Functional status assessment note"/>
              <title>Functional Status</title>
              <text>
                <paragraph ID="fimParagraph">
                  This section contains a list of the Functional Independence Measurement (FIM) assessments on record at VA for the patient. It shows the FIM scores that were recorded within the requested date range. If no date range was provided, it shows the 3 most recent assessment scores that were completed within the last 3 years. Data comes from all VA treatment facilities.
                </paragraph>
                <paragraph>
                  <content styleCode='Underline'>FIM Scale</content>: <content styleCode='Underline'>1</content> = Total Assistance (Subject = 0% +),
                  <content styleCode='Underline'>2</content> = Maximal Assistance (Subject = 25% +), <content styleCode='Underline'>3</content> = Moderate Assistance (Subject = 50% +),
                  <content styleCode='Underline'>4</content> = Minimal Assistance (Subject = 75% +), <content styleCode='Underline'>5</content> = Supervision, <content styleCode='Underline'>6</content> = Modified Independence
                  (Device), <content styleCode='Underline'>7</content> = Complete Independence (Timely, Safely).
                </paragraph>
                <table ID="fimNarrative">
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
              <xsl:comment>  FUNCTIONAL STATUS STRUCTURED ENTRIES </xsl:comment>
              <entry typeCode="DRIV">
                <organizer classCode="CLUSTER" moodCode="EVN">
                  <xsl:comment> **** Functional Status Result Organizer template **** </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.4.66"/>
                  <id root="2.16.840.1.113883.4.349"  nullFlavor="UNK"/>
                  <xsl:comment> Functional Status Result Organizer Code, ICF or SNOMED CT,  FIM Assessment Type </xsl:comment>
                  <code nullFlavor="UNK">
                    <originalText>
                      <reference value="#fimAssessment"/>
                    </originalText>
                  </code>
                  <statusCode code="completed"/>
                  <xsl:comment>  Functional Status Result Organizer Date/Time, FIM Assessment Date </xsl:comment>
                  <effectiveTime>
                    <low value="assessTime"/>
                  </effectiveTime>
                  <xsl:comment> * Information Source for Functional Status, VA Facility  </xsl:comment>
                  <author>
                    <time nullFlavor="NA"/>
                    <assignedAuthor>
                      <id nullFlavor="NA"/>
                      <representedOrganization>
                        <id extension="442" root="2.16.840.1.113883.3.1275"/>
                        <name>CHEYENNE VAMC</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <component>
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimEatName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimEat"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimGroomName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimGroom"/>
                        </originalText>
                      </value>
                      <xsl:comment> Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimBathName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimBath"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimDressUpName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimDressUp"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimDressLoName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimDressLo"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimToiletName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimToilet"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimBladderName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimBladder"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimBowelName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimBowel"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimTransChairName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimTransChair"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimTransToiletName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimTransToilet"/>
                        </originalText>
                      </value>
                      <xsl:comment> Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimTransTubName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimTransTub"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimLocomWalkName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimLocomWalk"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimLocomStairName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimLocomStair"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment>Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimComprehendName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimComprehend"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimExpressName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimExpress"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimInteractName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimInteract"/>
                        </originalText>
                      </value>
                      <xsl:comment> Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimProblemName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimProblem"/>
                        </originalText>
                      </value>
                      <xsl:comment> Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimMemoryName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimMemory"/>
                        </originalText>
                      </value>
                      <xsl:comment> Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
                    <xsl:comment> Functional Status Result Observation  </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.67"/>
                      <xsl:comment>Functional Status Result Observation ID  </xsl:comment>
                      <id nullFlavor="UNK" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment> Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill </xsl:comment>
                      <code nullFlavor="UNK"/>
                      <text>
                        <reference value="#fimTotalName"/>
                      </text>
                      <statusCode code="completed"/>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                      <effectiveTime>
                        <low value="skillTime"/>
                      </effectiveTime>
                      <xsl:comment> Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                      <value nullFlavor="NA" xsi:type="CD">
                        <originalText>
                          <reference value="#fimTotal"/>
                        </originalText>
                      </value>
                      <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
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
            <xsl:comment> **************************************************************** 
                MEDICATIONS (RX & Non-RX) SECTION, REQUIRED **************************************************************** </xsl:comment>
            <section>
              <xsl:comment> C-CDA Medications Section Template Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.1.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.1" />
              <code code="10160-0" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="History of medication use" />
              <title>Medications Section</title>
              <xsl:comment> MEDICATIONS NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VA Medication Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section includes:  1) prescriptions processed by a VA pharmacy in the last 15 months, and 2) all
                  medications recorded in the VA medical record as "non-VA medications". Pharmacy terms refer to VA pharmacy's
                  work on prescriptions.  VA patients are advised to take their medications as instructed by their health care
                  team.  Data comes from all VA treatment facilities.
                </paragraph>
                <paragraph>
                  <content styleCode="Underline">Glossary of Pharmacy Terms:</content>
                  <content styleCode="Underline">Active</content> = A prescription that can be filled at
                  the local VA pharmacy. <content styleCode="Underline">Active: On Hold</content> = An active prescription that will not be filled
                  until pharmacy resolves the issue. <content styleCode="Underline">Active: Susp</content> = An active prescription that is not
                  scheduled to be filled yet. <content styleCode="Underline">Clinic Order</content> = A medication received during a visit to a VA
                  clinic or emergency department. <content styleCode="Underline">Discontinued</content> = A prescription stopped by a VA provider. It is no
                  longer available to be filled. <content styleCode="Underline">Expired</content> = A prescription which is too old to fill. This does not
                  refer to the expiration date of the medication in the container. <content styleCode="Underline">Non-VA</content> = A medication
                  that came from someplace other than a VA pharmacy. This may be a prescription from either the VA or other
                  providers that was filled outside the VA. Or, it may be an over the counter (OTC), herbal, dietary supplement
                  or sample medication. <content styleCode="Underline">Pending</content> = This prescription order has been sent to the Pharmacy for review and is not
                  ready yet.
                </paragraph>
                <table ID="medicationNarrative">
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
              <xsl:comment> MEDICATIONS STRUCTURED DATA </xsl:comment>
              <xsl:comment> CCD Medication Activity Entry </xsl:comment>
              <entry>
                <substanceAdministration classCode="SBADM"
                                                                             moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.16" />
                  <id nullFlavor="UNK" />
                  <id assigningAuthorityName="Department of Veterans Affairs"
                                                                extension="nullFlavor" root="2.16.840.1.113883.4.349" />
                  <xsl:comment> 8.12 DELIVERY METHOD, Optional, No value set defined, Not provided 
                            by VA b/c data from VA VistA RPCs not yet available </xsl:comment>
                  <xsl:comment> 8.01 FREE TEXT SIG REFERENCE, Optional </xsl:comment>
                  <text>
                    <reference value="#mndSig" />
                  </text>
                  <statusCode code="completed" />
                  <effectiveTime xsi:type="IVL_TS">
                    <low />
                    <xsl:comment> INDICATE MEDICATION STOPPPED, high=Indicate Medication Stopped, 
                                Optional </xsl:comment>
                    <high />
                  </effectiveTime>
                  <xsl:comment> 8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data 
                            not yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> 8.03 ADMINISTRATION TIMING (xsi:type='EIVL' operator='A'), Optional, 
                            Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> 8.04 FREQUENCY (xsi:type='PIVL_TS institutionSpecified='false' 
                            operator='A''), Optional, Not provided by VA b/c data not yet available via 
                            VA VistA RPCs </xsl:comment>
                  <xsl:comment>8.05 INTERVAL ( xsi:type='PIVL_TS' institutionSpecified='false' 
                            operator='A'), Optional,Not provided by VA b/c data not yet available via 
                            VA VistA RPCs </xsl:comment>
                  <xsl:comment>8.06 DURATION ( xsi:type='PIVL_TS' operator='A'), Optional, Not 
                            provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> 8.08 DOSE, Optional, Not provided by VA b/c data not yet available 
                            via VA VistA RPCs </xsl:comment>
                  <doseQuantity />
                  <consumable>
                    <manufacturedProduct classCode="MANU">
                      <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                      <manufacturedMaterial>
                        <xsl:comment> 8.13 CODED PRODUCT NAME, REQUIRED, UNII, RxNorm, NDF-RT, NDC, 
                                        Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                        <code codeSystem="2.16.840.1.113883.6.88"
                                                                                          codeSystemName="RxNorm"  >
                          <xsl:comment> 8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not 
                                            yet available via VA VistA RPCs </xsl:comment>
                          <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                          <originalText>
                            <reference value="#mndMedication" />
                          </originalText>
                          <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                        </code>
                        <xsl:comment> 8.16 FREE TEXT BRAND NAME, R2, Not provided by VA b/c data 
                                        not yet available via VA VistA RPCs </xsl:comment>
                      </manufacturedMaterial>
                    </manufacturedProduct>
                  </consumable>
                  <xsl:comment> Information Source for Medication Entry, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="NI" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>

                  <xsl:comment>8.20-STATUS OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                  <entryRelationship typeCode="REFR">
                    <xsl:comment>To Identify Status </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.1.47" />
                      <code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                      <value xsi:type="CE">
                        <originalText/>
                      </value>
                    </observation>
                  </entryRelationship>
                  <xsl:comment> CCD Patient Instructions Entry, Optional </xsl:comment>

                  <entryRelationship typeCode='SUBJ'>
                    <observation classCode='OBS' moodCode='EVN'>
                      <xsl:comment> VLER SEG 1B: 8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                      <code codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'>
                        <originalText />
                      </code>
                      <statusCode code='completed' />
                    </observation>
                  </entryRelationship>

                  <entryRelationship inversionInd="true"
                                                                               typeCode='SUBJ'>
                    <act classCode="ACT" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                      <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                      <statusCode code="completed" />
                    </act>
                  </entryRelationship>
                  <xsl:comment> CCD Drug Vehicle Entry, Optional, Not provided by VA b/c data 
                            not yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> 8.24 VEHICLE, Optional, Not provided by VA b/c data not yet available 
                            via VA VistA RPCs </xsl:comment>
                  <xsl:comment> CCD Indication Entry, Optional, Not provided by VA b/c data not 
                            yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> 8.21 INDICATION VALUE, Optional, SNOMED CT, Not provided by VA 
                            b/c data not yet available via VA VistA RPCs </xsl:comment>
                  <xsl:comment> CCD Medication Supply Order Entry, REQUIRED </xsl:comment>
                  <entryRelationship typeCode='REFR'>
                    <supply classCode="SPLY" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.17" />
                      <xsl:comment> VLER SEG 1B: 8.26 ORDER NUMBER, Optional-R2 </xsl:comment>
                      <id root="2.16.840.1.113883.4.349" />
                      <statusCode code="completed" />
                      <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                      <effectiveTime xsi:type="IVL_TS">
                        <high />
                      </effectiveTime>
                      <xsl:comment> VLER SEG 1B: 8.27 FILLS, Optional </xsl:comment>
                      <repeatNumber />
                      <xsl:comment> 8.28 QUANTITY ORDERED, R2, Not provided by VA b/c data not 
                                    yet available via VA VistA RPCs </xsl:comment>
                      <quantity />
                      <product>
                        <manufacturedProduct classCode="MANU">
                          <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                          <manufacturedMaterial>
                            <code codeSystem="2.16.840.1.113883.6.88"
                                                                                                          codeSystemName="RxNorm"  >

                            </code>
                          </manufacturedMaterial>
                        </manufacturedProduct>
                      </product>
                      <author>
                        <xsl:comment> 8.30 ORDER DATE/TIME, Optional </xsl:comment>
                        <time />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <assignedPerson>
                            <xsl:comment> 8.31 ORDERING PROVIDER, Optional </xsl:comment>
                            <name />
                          </assignedPerson>
                        </assignedAuthor>
                      </author>
                    </supply>
                  </entryRelationship>
                  <xsl:comment> FULFILLMENT HISTORY INFORMATION </xsl:comment>
                  <xsl:comment> CCD Medication Dispense Entry, Optional </xsl:comment>
                  <entryRelationship typeCode='REFR'>
                    <supply classCode="SPLY" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.18" />
                      <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                      <id />
                      <statusCode code="completed" />
                      <effectiveTime />
                      <repeatNumber />
                      <product>
                        <manufacturedProduct classCode="MANU">
                          <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                          <manufacturedMaterial>
                            <code codeSystem="2.16.840.1.113883.6.88"
                                                                                                          codeSystemName="RxNorm" nullFlavor="UNK">
                              <originalText />
                            </code>
                          </manufacturedMaterial>
                        </manufacturedProduct>
                      </product>
                      <author>
                        <time />
                        <assignedAuthor>
                          <id nullFlavor="NI" />
                          <assignedPerson>
                            <name />
                          </assignedPerson>
                        </assignedAuthor>
                      </author>
                    </supply>
                  </entryRelationship>
                </substanceAdministration>
                <xsl:comment> 8.23 REACTION OBSERVATION Entry, Optional, Not provided by VA 
                        b/c data not yet available via VA VistA RPCs </xsl:comment>
                <xsl:comment> CCD PRECONDITION FOR SUBSTANCE ADMINISTRATION ENTRY, Optional, 
                        Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                <xsl:comment>8.25 DOSE INDICATOR, Optional, Not provided by VA b/c data not 
                        yet available via VA VistA RPCs </xsl:comment>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** IMMUNIZATIONS 
                SECTION, Optional ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> CCD Results Section Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.2.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.2" />
              <code code="11369-6" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" />
              <title>Immunizations Section</title>
              <text>
                <xsl:comment> VA Immunization Business Rules for Medical Content </xsl:comment>
                <paragraph>This section includes Immunizations on record with VA for the patient. The data comes from all VA treatment facilities. A reaction to an immunization may also be reported in the Allergy section.</paragraph>
                <table ID="immunizationNarrative">
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
              <entry typeCode='DRIV'>
                <xsl:comment> CCD Immunization Activity Entry, REQUIRED </xsl:comment>
                <xsl:comment> 13.01 IMMUNIZATION REFUSAL (negation ind="true"), REQUIRED </xsl:comment>
                <substanceAdministration classCode="SBADM"
                                                                             moodCode="EVN" negationInd="false">
                  <templateId root="2.16.840.1.113883.10.20.22.4.52" />
                  <id nullFlavor="NA" />
                  <text>
                    <reference value="#indComments" />
                  </text>
                  <statusCode code="completed" />
                  <effectiveTime />
                  <repeatNumber />
                  <consumable>
                    <manufacturedProduct classCode="MANU">
                      <templateId root="2.16.840.1.113883.10.20.22.4.54" />
                      <manufacturedMaterial>
                        <xsl:comment> 13.06 CODED IMMUNIZATION PRODUCT NAME </xsl:comment>
                        <code codeSystemName="Vaccine Administered (CVX code)" codeSystem="2.16.840.1.113883.12.292">
                          <originalText>
                            <reference />
                          </originalText>
                          <translation codeSystem='2.16.840.1.113883.6.12'
                                                                                                         codeSystemName='Current Procedural Terminology (CPT) Fourth Edition (CPT-4)' />
                        </code>
                      </manufacturedMaterial>
                    </manufacturedProduct>
                  </consumable>
                  <performer>
                    <assignedEntity>
                      <xsl:comment> CCD Provider ID, extension = VA Provider ID, root=VA OID, REQUIRED </xsl:comment>
                      <id root="2.16.840.1.113883.4.349" />
                      <assignedPerson>
                        <xsl:comment> CCD Provider Name, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment>INFORMATION SOURCE FOR IMMUNIZATION, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING 
                                        FACILITY NBR) </xsl:comment>
                        <id nullFlavor="NA" />
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode="CAUS"
                                                                               inversionInd="true">
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.9" />
                      <id nullFlavor="NA" />
                      <code nullFlavor="UNK" />
                      <text>
                        <reference />
                      </text>
                      <statusCode code="completed" />
                      <value nullFlavor="UNK" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96"
                                                                                   codeSystemName="SNOMED CT" />
                    </observation>
                  </entryRelationship>
                  <xsl:comment> 13.10 REFUSAL REASON ENTRY, Optional, VA provides administered 
                            immunizations only </xsl:comment>
                </substanceAdministration>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** PROCEDURES 
                SECTION ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> CCD Procedures Section Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.7.1" />
              <code code="47519-4" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="History of Procedures" />
              <title>History of Procedures</title>
              <xsl:comment>PROCEDURE NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VA Procedure Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section contains a list of Surgical Procedures performed at the VA for the
                  patient and a list of Surgical Procedure Notes and Clinical Procedure Notes on record at
                  the VA for the patient.
                </paragraph>
                <paragraph>
                  <content styleCode="Bold">Surgical Procedures</content>
                </paragraph>

                <paragraph MAP_ID="procedureNarrativeIntro">
                  The list of Surgical Procedures shows all procedure dates within the requested date range. If no date
                  range was provided, the list of Surgical Procedures shows the 5 most recent procedure dates within the
                  last 18 months. The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="procedureNarrative">
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
                </table>
                <xsl:comment> Surgical notes begin </xsl:comment>
                <br/>
                <content MAP_ID="surgNotesTitle" styleCode="Bold">Surgical Procedure Notes</content>

                <paragraph MAP_ID="SurgicalNotesTopHeader">
                  This section contains the 5 most recent Surgical Procedure Notes associated to each Procedure. Data comes from all VA treatment facilities.
                </paragraph>

                <table MAP_ID="SurgicalNotesNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Surgical Procedure Note</th>
                      <th>Provider</th>
                      <th>Source</th>
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
                      <td>
                        <content ID="surgicalNoteSource" />
                      </td>
                    </tr>
                  </tbody>
                </table>

                <xsl:comment> Surgical End </xsl:comment>
                <xsl:comment> Consult notes begin </xsl:comment>
                <br/>
                <content MAP_ID="cpNotesTitle" styleCode="Bold">Clinical Procedure Notes</content>

                <paragraph MAP_ID="ClinicalNotesTopHeader">
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
                <xsl:comment> clinical notes with titles </xsl:comment>
                <br/>
                <content MAP_ID="cpNotesTitle2" styleCode="Bold">Additional Clinical Procedure Notes</content>

                <paragraph MAP_ID="ClinicalNotesTopHeader2">
                  The list of ADDITIONAL Clinical Procedure Note TITLES includes all notes signed within the last 18 months.
                  The data comes from all VA treatment facilities.
                </paragraph>
                <table ID="ClinicalNotesNarrative2">
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
                        <content ID="clinicalNoteDateTime2" />
                      </td>
                      <td>
                        <content ID="clinicalNoteEncounterDescription2" />
                      </td>
                      <td>
                        <content ID="clinicalNoteProvider2" />
                      </td>
                      <td>
                        <content ID="clinicalNoteSource2" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>

              <xsl:comment> PROCEDURE STRUCTURED </xsl:comment>
              <entry>
                <procedure classCode="PROC" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.14" />
                  <id nullFlavor="UNK" />
                  <xsl:comment> 17.02-PROCEDURE TYPE, REQUIRED, LOINC, SNOMED CT or CPT, 4 </xsl:comment>
                  <code  nullFlavor="UNK">
                    <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                    <originalText>
                      <reference />
                    </originalText>
                    <translation>
                      <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                      <originalText>
                        <reference />
                      </originalText>
                    </translation>
                    <qualifier>
                      <name />
                      <value />
                    </qualifier>
                  </code>
                  <statusCode code="completed" />
                  <effectiveTime>
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id nullFlavor="NA" />
                      <addr nullFlavor="NA" />
                      <telecom nullFlavor="NA" />
                      <assignedPerson>
                        <xsl:comment> 17.05 PROCEDURE PROVIDER NAME, REQUIRED </xsl:comment>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment> INFORMATION SOURCE FOR PROCEDURE ENTRY, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                </procedure>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** PLAN OF 
                CARE SECTION, Optional ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> CCD Plan of Care Section Entries </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.10" />
              <code code="18776-5" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Treatment plan" />
              <title>Treatment Plan</title>
              <text>
                <paragraph>
                  The Plan of Care section contains future care activities for the patient from all VA treatment
                  facilities.  This section includes future appointments and future orders which are active, pending
                  or scheduled.
                </paragraph>
                <paragraph MAP_ID="futureAppointmentsTitle">
                  <content styleCode="Bold">Future Appointments</content>
                </paragraph>
                <paragraph MAP_ID="futureAppointmentsRules">
                  This section includes up to a maximum of 20 appointments scheduled over the next 6 months. Some types of appointments may not be included. Contact the VA health care team if there are questions.
                </paragraph>
                <table ID="futureAppointments">
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
                <table ID="futureScheduledTests">
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
              <xsl:comment> PLAN OF CARE (POC) STRUCTURED DATA </xsl:comment>
              <xsl:comment> CCD Plan of Care (POC) Activity Encounter (Future VA Appointments, 
                    Future Scheduled Tests, Wellness Reminders), Optional </xsl:comment>
              <entry>
                <encounter classCode="ENC" moodCode="INT">
                  <templateId root="2.16.840.1.113883.10.20.22.4.40" />
                  <id root="2.16.840.1.113883.4.349" />
                  <code>
                    <originalText>
                      <reference />
                    </originalText>
                  </code>
                  <text />
                  <statusCode code="ACTIVE"/>
                  <effectiveTime>
                    <center />
                  </effectiveTime>
                  <performer>
                    <assignedEntity>
                      <id root="2.16.840.1.113883.4.349" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <author>
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />

                      <representedOrganization>
                        <id root="2.16.840.1.113883.4.349" />
                        <name/>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>

                  <entryRelationship inversionInd="true"
                                                                               typeCode='SUBJ'>
                    <act classCode="ACT" moodCode="INT">
                      <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                      <code code="409073007" codeSystem="2.16.840.1.113883.6.96"
                                                                                  displayName="Instruction" codeSystemName="SNOMED CT" />
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
            <xsl:comment> ******************************************************** PROBLEM/CONDITION 
                SECTION, REQUIRED ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> C-CDA Problem Section Template. Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.5.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.5" />
              <code code="11450-4" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Problem List" />
              <title>Problem List</title>
              <xsl:comment> PROBLEMS NARRATIVE BLOCK </xsl:comment>
              <text>
                <xsl:comment> VA Problem/Condition Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section contains a list of Problems/Conditions known to VA
                  for the patient. It includes both active and inactive
                  problems/conditions. The data comes from all VA treatment
                  facilities.
                </paragraph>
                <table ID="problemNarrative">
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
              <xsl:comment> PROBLEMS STRUCTURED DATA </xsl:comment>
              <xsl:comment> Problem Concern Activty Entry </xsl:comment>
              <entry>
                <act classCode="ACT" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.3" />
                  <id nullFlavor="NA" />
                  <code code="CONC" codeSystem="2.16.840.1.113883.5.6"
                                                                  codeSystemName="HL7ActClass" displayName="Concern" />
                  <statusCode code="active" />
                  <xsl:comment> 7.01 PROBLEM DATE, R2 </xsl:comment>
                  <effectiveTime>
                    <xsl:comment> cda:low=Date Entered </xsl:comment>
                    <low />
                    <high nullFlavor="UNK" />
                  </effectiveTime>
                  <xsl:comment> TREATING PROVIDER Performer Block, Optional </xsl:comment>
                  <performer>
                    <assignedEntity>
                      <xsl:comment> 7.05 TREATING PROVIDER </xsl:comment>
                      <id nullFlavor="UNK" />
                      <assignedPerson>
                        <name />
                      </assignedPerson>
                    </assignedEntity>
                  </performer>
                  <xsl:comment> INFORMATION SOURCE FOR PROBLEM, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR </xsl:comment>
                        <id root="2.16.840.1.113883.4.349" />
                        <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <entryRelationship typeCode="SUBJ">
                    <xsl:comment> CCD Problem Observation </xsl:comment>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.4" />
                      <id nullFlavor="NA" />
                      <xsl:comment> 7.02 PROBLEM TYPE, REQUIRED, SNOMED CT, provided as nullFalvor 
                                    b/c data not yet available via VA VistA RPCs </xsl:comment>
                      <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"
                                                                                  nullFlavor="UNK">
                        <originalText>Problem Type Not Available</originalText>
                      </code>
                      <xsl:comment> 7.03 PROBLEM NAME, R2 </xsl:comment>
                      <text>
                        <reference value="#pndProblem" />
                      </text>
                      <statusCode code="completed" />
                      <effectiveTime>
                        <xsl:comment> 7.01 PROBLEM DATE, cda:low=Date of Onset </xsl:comment>
                        <low />
                        <xsl:comment> 7.01 PROBLEM DATE, cda:high=Date Resolved </xsl:comment>
                        <high />
                      </effectiveTime>
                      <xsl:comment> 7.04 PROBLEM CODE, Optional, When uncoded only xsi:type="CD" 
                                    allowed, Available as ICD-9, not SNOMED CT, </xsl:comment>
                      <value xsi:type="CD"   codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                        <originalText>
                          <reference />
                        </originalText>
                        <translation codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM' />
                      </value>
                      <xsl:comment> PROBLEM STATUS entryRelationship block, Optional, </xsl:comment>
                      <entryRelationship typeCode="SUBJ">
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.6" />
                          <code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status" />
                          <statusCode code="completed" />
                          <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                            <originalText>
                              <reference />
                            </originalText>
                          </value>
                        </observation>
                      </entryRelationship>
                      <xsl:comment> PROBLEM COMMENT (for SSA) entryRelationship block, Optional, </xsl:comment>
                      <entryRelationship inversionInd="true" typeCode="MFST">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                          <text>
                            <reference value="#pndComment"/>
                          </text>
                        </act>
                      </entryRelationship>
                    </observation>
                  </entryRelationship>
                  <xsl:comment> CCD Problem Age Observation, not provided b/c data not yet available 
                            via VA VistA RPCs </xsl:comment>
                  <xsl:comment> CCD Health Status Observation, not provided b/c data not yet 
                            available via VA VistA RPCs </xsl:comment>
                </act>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** RESULTS 
                SECTION, REQUIRED ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> CCD Results Section Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.3.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.3" />
              <code code="30954-2" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data" />
              <title>Results Section</title>
              <text>
                <xsl:comment> VA Results Business Rules for Medical Content </xsl:comment>
                <paragraph>
                  This section contains the Chemistry and Hematology Lab Results,
                  Radiology Reports, and Pathology Reports on record with VA for
                  the patient. The data comes from all VA treatment facilities.
                </paragraph>

                <content styleCode="Bold">Lab Results</content>

                <paragraph MAP_ID="labRules">
                  This section contains all the Chemistry/Hematology Results
                  collected within the requested date range. If no date range was
                  provided, the included Chemistry/Hematology Results are from
                  the last 24 months and are limited to the 10 most recent sets
                  of tests. The data comes from all VA treatment facilities.
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
                    <tr ID="labTest">
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
                    <tr ID="labValues">
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

                <content ID="microbiologyRules">
                  <paragraph>
                    <content styleCode="Bold">Microbiology Reports</content>
                  </paragraph>
                  <paragraph>
                    The included Microbiology Reports are the 20 most recent reports within the last 24 months. The data comes from all VA paragrapheatment facilities.  ANTIBIOTIC SUSCEPTIBILITY TEST RESULTS KEY: SUSC = Susceptibility Result, S = Susceptible, INTP = Interpretation, I = Intermediate, MIC  = Minimum Inhibitory Concenparagraphation, R = Resistant.
                  </paragraph>
                </content>
                <table ID="microbiologyNarrative">
                  <thead>
                    <tr>
                      <th>Date/Time</th>
                      <th>Result Type</th>
                      <th>Source</th>
                      <th>Report</th>
                      <th>Provider</th>
                      <th>Status</th>
                    </tr>
                  </thead>

                  <tbody>

                    <tr ID="microbiologyTest">
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
                        <content>completed</content>
                      </td>
                    </tr>
                  </tbody>
                </table>

                <br/>
                <content MAP_ID="radNotesTitle" styleCode="Bold">Radiology Reports</content>
                <paragraph MAP_ID="radiologyRules">
                  This section includes all Radiology Reports within the requested date range.
                  If no date range was provided, the included Radiology Reports are the 5 most
                  recent reports within the last 24 months. The data comes from all VA treatment
                  facilities.
                </paragraph>

                <table MAP_ID="radiologyNarrative">
                  <thead>
                    <tr>
                      <th>Result Date/Time</th>
                      <th>Results Type (LOINC)</th>
                      <th>Source</th>
                      <th>Result</th>
                      <th>Provider</th>
                      <th>Status</th>
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
                      <td>
                        <content />
                      </td>
                      <td>
                        <content>completed</content>
                      </td>

                    </tr>
                  </tbody>
                </table>
                <br/>
                <content MAP_ID="pathNotesTitle" styleCode="Bold">Pathology Reports</content>

                <paragraph MAP_ID="pathologyRules">
                  This section includes all Pathology Reports within the requested date range.
                  If no date range was provided, the included Pathology Reports are the 5 most
                  recent reports within the last 24 months. The data comes from all VA treatment
                  facilities.
                </paragraph>
                <table MAP_ID="pathologyNarrative">
                  <thead>
                    <tr>
                      <th>Result Date/Time</th>
                      <th>Results Type (LOINC)</th>
                      <th>Source</th>
                      <th>Result</th>
                      <th>Provider</th>
                      <th>Status</th>

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
                      <td>
                        <content />
                      </td>
                      <td>
                        <content>completed</content>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </text>
              <entry typeCode='DRIV'>
                <xsl:comment> CCD Results Organizer = VA Lab Order Panel , REQUIRED </xsl:comment>
                <organizer classCode="CLUSTER" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.1" />
                  <id nullFlavor="NI" />
                  <code nullFlavor="UNK">
                    <originalText />
                    <translation />
                  </code>
                  <statusCode code="completed" />
                  <effectiveTime>
                    <low />
                  </effectiveTime>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <id root="2.16.840.1.113883.3.1275" />
                        <name />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <component>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.2" />
                      <xsl:comment> 15.01 RESULT ID, REQUIRED </xsl:comment>
                      <id root="2.16.840.1.113883.4.349" />
                      <xsl:comment> 15.03-RESULT TYPE, REQUIRED </xsl:comment>
                      <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
                        <originalText>
                          <reference />
                        </originalText>
                        <translation />
                      </code>

                      <text >
                        <reference/>
                      </text>
                      <statusCode code="completed" />
                      <xsl:comment> 15.02 RESULT DATE/TIME, REQUIRED </xsl:comment>
                      <effectiveTime />
                      <xsl:comment> 15.05 RESULT VALUE, REQUIRED, xsi:type="PQ" </xsl:comment>
                      <value xsi:type="PQ">
                        <reference/>
                      </value>
                      <xsl:comment> 15.06 RESULT INTERPRETATION, R2, </xsl:comment>
                      <interpretationCode>
                        <originalText>
                          <reference />
                        </originalText>
                      </interpretationCode>
                      <entryRelationship typeCode="SUBJ"
                                                                                               inversionInd="true">
                        <act classCode="ACT" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                          <code code="48767-8" codeSystem="2.16.840.1.113883.6.1"
                                                                                                  codeSystemName="LOINC" displayName="Annotation comment" />
                          <text>
                            <reference />
                          </text>
                        </act>
                      </entryRelationship>
                      <xsl:comment> CCD METHOD CODE, Optional, Not provided by VA b/c data not 
                                    yet available via VA VistA RPCs </xsl:comment>
                      <xsl:comment> CCD TARGET SITE CODE, Optional, Not provided by VA b/c data 
                                    not yet available via VA VistA RPCs </xsl:comment>
                      <xsl:comment> 15.07 RESULT REFERENCE RANGE, R2, </xsl:comment>
                      <referenceRange>
                        <observationRange>
                          <text />
                        </observationRange>
                      </referenceRange>
                      <author>
                        <time nullFlavor="NA" />
                        <assignedAuthor>
                          <id nullFlavor="NA" />
                          <assignedPerson>
                            <name />
                          </assignedPerson>
                        </assignedAuthor>
                      </author>
                    </observation>
                  </component>
                </organizer>
              </entry>
            </section>
          </component>
          <component>
            <xsl:comment> ******************************************************** SOCIAL 
                HISTORY SECTION, Optional ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> CCD Social History Section Entries </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.17" />
              <code code="29762-2" codeSystem="2.16.840.1.113883.6.1"
                                        codeSystemName="LOINC" displayName="Social history" />
              <title>Social History Section</title>
              <text>
                <xsl:comment> VA Procedure Business Rules for Medical Content </xsl:comment>
                <paragraph>This section includes the smoking or tobacco-related health factors on record with VA for the patient.</paragraph>

                <paragraph MAP_ID="hfTitle" styleCode="Bold">Current Smoking Status</paragraph>

                <paragraph MAP_ID="hfNarrative" >This section includes the most current smoking, or tobacco-related health factor.</paragraph>
                <table MAP_ID="factorsNarrative" border="1" width="100%">
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

                <paragraph MAP_ID="hf2Title" styleCode="Bold">Tobacco Use History</paragraph>

                <paragraph MAP_ID="hf2Narrative" >This section includes a history of the smoking, or tobacco-related health factors.</paragraph>
                <table MAP_ID="factorsNarrative2" border="1" width="100%">
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
              <entry MAP_ID="hf1">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.78" />
                  <id nullFlavor="NI" />
                  <code code="72166-2" codeSystem="2.16.840.1.113883.6.1" displayName="Tobacco smoking status NHIS" />
                  <statusCode code="completed" />
                  <xsl:comment> CCD Smoking Status Effective Time, R2 </xsl:comment>
                  <effectiveTime />
                  <xsl:comment> CCD Smoking Status Value, REQURIED, SNOMED CT </xsl:comment>
                  <value nullFlavor="UNK" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" >
                    <originalText>
                      <reference />
                    </originalText>
                  </value>
                  <xsl:comment> INFORMATION SOURCE FOR SMOKING STATUS, Optional </xsl:comment>
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING 
                                        FACILITY NBR) </xsl:comment>
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349" />
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                        <name>facilityName</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment> CCD Smoking Status Comment Entry, Optional </xsl:comment>
                  <entryRelationship typeCode="SUBJ" inversionInd="true">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                      <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                      <xsl:comment> CCD Smoking Status Comment, REQUIRED </xsl:comment>
                      <text>
                        <reference />
                      </text>
                    </act>
                  </entryRelationship>
                </observation>
              </entry>
              <entry MAP_ID="hf2">
                <observation classCode="OBS" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.85" />
                  <id nullFlavor="NI" />
                  <code code="11367-0" codeSystem="2.16.840.1.113883.6.1" displayName="History of tobacco use" />
                  <statusCode code="completed" />
                  <xsl:comment> CCD Smoking Status Effective Time, R2 </xsl:comment>
                  <effectiveTime>
                    <low nullFlavor="UNK" />
                    <high nullFlavor="NAV" />
                  </effectiveTime>
                  <xsl:comment> CCD Smoking Status Value, REQURIED, SNOMED CT </xsl:comment>
                  <value xsi:type="CD" nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                    <originalText>
                      <reference />
                    </originalText>
                  </value>
                  <xsl:comment> INFORMATION SOURCE FOR SMOKING STATUS, Optional </xsl:comment>
                  <author>
                    <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                    <time nullFlavor="UNK" />
                    <assignedAuthor>
                      <id nullFlavor="UNK" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING 
                                        FACILITY NBR) </xsl:comment>
                        <id extension="facilityNumber" root="2.16.840.1.113883.4.349" />
                        <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName)</xsl:comment>
                        <name>facilityName</name>
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment> CCD Smoking Status Comment Entry, Optional </xsl:comment>
                  <entryRelationship typeCode="SUBJ" inversionInd="true">
                    <act classCode="ACT" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                      <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                      <xsl:comment> CCD Smoking Status Comment, REQUIRED </xsl:comment>
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
            <xsl:comment> ******************************************************** VITAL SIGNS 
                SECTION, REQUIRED ******************************************************** </xsl:comment>
            <section>
              <xsl:comment> C-CDA CCD VITAL SIGNS Section Template Entries REQUIRED </xsl:comment>
              <templateId root="2.16.840.1.113883.10.20.22.2.4.1" />
              <templateId root="2.16.840.1.113883.10.20.22.2.4" />
              <code code="8716-3" codeSystem="2.16.840.1.113883.6.1"
                                                  codeSystemName="LOINC" displayName="Vital Signs" />
              <title>Vital Signs Section</title>
              <xsl:comment> VITAL SIGNS NARRATIVE BLOCK, REQUIRED </xsl:comment>
              <text>
                <xsl:comment> VA Vital Signs Business Rules for Medical Content </xsl:comment>
                <paragraph ID="vitalsParagraph">
                  This section contains inpatient and outpatient Vital Signs on record at VA for the patient.
                  The data comes from all VA treatment facilities. It includes vital signs collected within
                  the requested date range. If more than one set of vitals was taken on the same date,
                  only the most recent set is populated for that date. If no date range was provided,
                  it includes 12 months of data, with a maximum of the 5 most recent sets of vitals.
                  If more than one set of vitals was taken on the same date, only the most recent set
                  is populated for that date.
                </paragraph>
                <table ID="vitalNarrative">
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
                <xsl:comment> CDA Observation Text as a Reference tag </xsl:comment>
                <content ID="vital1" revised='delete'>
                  Vital Sign Observation Text
                  Not Available
                </content>
              </text>
              <xsl:comment> VITAL SIGNS STRUCTURED DATA </xsl:comment>
              <entry typeCode='DRIV'>
                <xsl:comment> Vital Signs Organizer Template, REQUIRED </xsl:comment>
                <organizer classCode="CLUSTER" moodCode="EVN">
                  <templateId root="2.16.840.1.113883.10.20.22.4.26" />
                  <xsl:comment> Vital Sign Organizer ID as nullFlavor b/c data not yet available 
                            via VA VistA RPCs </xsl:comment>
                  <id nullFlavor="NA" />
                  <code code="46680005" codeSystem="2.16.840.1.113883.6.96"
                                                                  codeSystemName="SNOMED CT" displayName="Vital signs" />
                  <statusCode code="completed" />
                  <effectiveTime />
                  <xsl:comment> INFORMATION SOURCE FOR VITAL SIGN ORGANIZER/PANEL, Optional </xsl:comment>
                  <author>
                    <time nullFlavor="NA" />
                    <assignedAuthor>
                      <id nullFlavor="NA" />
                      <representedOrganization>
                        <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING 
                                        FACILITY NBR </xsl:comment>
                        <id root="2.16.840.1.113883.4.349" />
                        <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                        <name />
                        <telecom nullFlavor="NA" />
                        <addr nullFlavor="NA" />
                      </representedOrganization>
                    </assignedAuthor>
                  </author>
                  <xsl:comment> One component block for each Vital Sign </xsl:comment>
                  <component>
                    <observation classCode="OBS" moodCode="EVN">
                      <templateId root="2.16.840.1.113883.10.20.22.4.27" />
                      <xsl:comment> 14.01-VITAL SIGN RESULT ID, REQUIRED </xsl:comment>
                      <id root="2.16.840.1.113883.4.349" />
                      <xsl:comment> 14.03-VITAL SIGN RESULT TYPE, REQUIRED, LOINC </xsl:comment>
                      <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
                        <originalText>
                          <reference />
                        </originalText>
                        <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                      </code>
                      <xsl:comment> 14.04-VITAL SIGN RESULT STATUS, REQUIRED, Static value of completed </xsl:comment>
                      <statusCode code="completed" />
                      <xsl:comment>14.02-VITAL SIGN RESULT DATE/TIME, REQURIED </xsl:comment>
                      <effectiveTime />
                      <xsl:comment> 14.05-VITAL SIGN RESULT VALUE, CONDITIONALLY REQUIRED when 
                                    moodCode=EVN </xsl:comment>
                      <xsl:comment> 14.05-VITAL SIGN RESULT VALUE with Unit of Measure </xsl:comment>
                      <value xsi:type="PQ" >
                        <translation codeSystem="2.16.840.1.113883.4.349" codeSystemName="Department of Veterans Affairs VistA" />
                      </value>
                      <xsl:comment> 14.06-VITAL SIGN RESULT INTERPRETATION, Optional, HL7 Result 
                                    Normalcy Status Value Set </xsl:comment>
                      <xsl:comment> 14.06-VITAL SIGN RESULT INTERPRETATION, Removed b/c data not 
                                    yet available via VA VistA RPCs </xsl:comment>
                      <xsl:comment> 14.07-VITAL SIGN RESULT REFERENCE RANGE, Optional, </xsl:comment>
                      <xsl:comment> 14.07-VITAL SIGN RESULT REFERENCE RANGE, Removed b/c data not 
                                    yet available via VA VistA RPCs </xsl:comment>
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
        </structuredBody>
      </component>
    </ClinicalDocument>
  