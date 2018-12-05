<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:sdtc="urn:hl7-org:sdtc" 
  xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:exsl="http://exslt.org/common" 
  xmlns:set="http://exslt.org/sets" 
  xmlns:date="http://exslt.org/dates-and-times" 
  xmlns:str="http://exslt.org/strings"
  exclude-result-prefixes="isc xsi sdtc exsl set date str">

  <xsl:include href="DateFormatter.xsl" />
  
  <xsl:variable name="documentCreatedOn" select="isc:evaluate('timestamp')" />
  <xsl:key name="vitals" match="Observations/Observation" use="GroupId/text()" />

  <xsl:template match="/Container">
    <xsl:variable name="patientBirthDate" select="translate(Patient/BirthTime/text(), 'TZ:- ', '')" />
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
    </xsl:processing-instruction>
    <ClinicalDocument xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc"
                      xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
      <xsl:comment>
        ******************************************************** C-CDA CCD
        R1.1 HEADER VDIF Build 1 ********************************************************
      </xsl:comment>
      <realmCode code="US" />
      <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040" />
      <templateId root="2.16.840.1.113883.10.20.22.1.1"/>
      <templateId root="2.16.840.1.113883.10.20.22.1.2"/>
      <xsl:comment> CCD Document Identifer, id=VA OID, extension=system-generated </xsl:comment>
      <id extension="{isc:evaluate('createUUID')}" root="2.16.840.1.113883.4.349" />
      <xsl:comment>CCD Document Code</xsl:comment>
      <code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="{isc:evaluate('lookup', '34133-9','Summarization of Episode Note')}" />
      <xsl:comment> CCD Document Title </xsl:comment>
      <title>Department of Veterans Affairs Health Summary</title>
      <xsl:comment> 1.01 DOCUMENT TIMESTAMP, REQUIRED </xsl:comment>
      <effectiveTime value="{$documentCreatedOn}" />
      <xsl:comment>CCD Confidentiality Code, REQUIRED </xsl:comment>
      <confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25" />
      <xsl:comment>CCD DOCUMENT LANGUAGE, REQUIRED</xsl:comment>
      <languageCode code="en-US" />
      <recordTarget>
        <patientRole>
          <xsl:comment>1.02 PERSON ID, REQUIRED, id=VA OID, extension=GUID</xsl:comment>
          <id extension="{Patient/MPIID/text()}" root="2.16.840.1.113883.4.349" />

          <xsl:comment> 1.03 PERSON ADDRESS-HOME PERMANENT, REQUIRED </xsl:comment>
          <xsl:apply-templates select="Patient/Addresses" mode="standard-address">
            <xsl:with-param name="use">HP</xsl:with-param>
          </xsl:apply-templates>

          <xsl:comment>1.04 PERSON PHONE/EMAIL/URL, REQUIRED</xsl:comment>
          <xsl:apply-templates select="Patient" mode="standard-contact-info" />

          <patient>
            <xsl:comment>1.05 PERSON NAME LEGAL, REQUIRED</xsl:comment>
            <xsl:apply-templates select="Patient/Name" mode="standard-name">
              <xsl:with-param name="use">L</xsl:with-param>
            </xsl:apply-templates>

            <xsl:comment>1.05 PERSON NAME Alias Name, Optional</xsl:comment>
            <xsl:apply-templates select="Patient/Aliases/Name" mode="standard-name">
              <xsl:with-param name="use">A</xsl:with-param>
            </xsl:apply-templates>
            <xsl:comment> 1.06 GENDER, REQUIRED, HL7 Administrative Gender </xsl:comment>
            <!-- TODO: find SDA mapping post ESR/Terms Integration -->
            <administrativeGenderCode codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode">
              <originalText>
                <reference />
              </originalText>
            </administrativeGenderCode>
            <xsl:comment>1.07 PERSON DATE OF BIRTH, REQUIRED</xsl:comment>
            <birthTime value="{$patientBirthDate}" />
            <!-- TODO: find SDA mapping post ESR/Terms Integration -->
            <maritalStatusCode code='maritalCode' codeSystem='2.16.840.1.113883.5.2' codeSystemName='MaritalStatusCode' >
              <originalText />
              <xsl:comment>1.08 MARITAL STATUS, Optional-R2</xsl:comment>
            </maritalStatusCode>
            <xsl:comment> 1.09 RELIGIOUS AFFILIATION, Optional, Removed b/c data not yet available via VA VIstA RPCs </xsl:comment>
            <!-- TODO: find SDA mapping post ESR/Terms Integration -->
            <religiousAffiliationCode codeSystem='2.16.840.1.113883.5.1076' codeSystemName='HL7 Religious Affiliation' >
              <originalText>religiousAffiliation</originalText>
            </religiousAffiliationCode>
            <xsl:comment>1.10 RACE, Optional</xsl:comment>
            <!-- TODO: find SDA mapping post ESR/Terms Integration -->
            <raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </raceCode>
            <sdtc:raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>race</originalText>
            </sdtc:raceCode>
            <xsl:comment>1.11 ETHNICITY, Optional</xsl:comment>
            <!-- TODO: find SDA mapping post ESR/Terms Integration -->
            <ethnicGroupCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='Race &amp; Ethnicity - CDC'>
              <originalText>ethnicity</originalText>
            </ethnicGroupCode>
            <xsl:comment>********************************************************** LANGUAGE SPOKEN CONTENT MODULE, R2 **********************************************************</xsl:comment>
            <languageCommunication>
              <xsl:comment>2.01 LANGUAGE, REQUIRED, languageCode ISO 639-1</xsl:comment>
              <xsl:choose>
                <xsl:when test="boolean(Patient/PrimaryLanguage/Code)">
                  <languageCode code="{Patient/PrimaryLanguage/Code/text()}" />
                  <modeCode code="ESP" displayName="Expressed spoken" codeSystem="2.16.840.1.113883.5.60" codeSystemName="LanguageAbilityMode" />
                  <proficiencyLevelCode nullFlavor="NA" />
                  <preferenceInd value="true" />
                </xsl:when>
                <xsl:otherwise>
                  <languageCode nullFlavor="UNK" />
                  <modeCode nullFlavor="NA" />
                  <proficiencyLevelCode nullFlavor="NA" />
                  <preferenceInd nullFlavor="NA" />
                </xsl:otherwise>
              </xsl:choose>
            </languageCommunication>
            <!-- TODO: find out if there will be secondary languages in the SDA, not seeing them in test data-->
          </patient>
        </patientRole>
      </recordTarget>
      <xsl:comment>
        **********************************************************************
        INFORMATION SOURCE CONTENT MODULE, REQUIRED **********************************************************************
      </xsl:comment>
      <xsl:comment>AUTHOR SECTION (REQUIRED) OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
      <author>
        <templateId root="2.16.840.1.113883.10.20.22.4.119" />
        <xsl:comment> 10.01 AUTHOR TIME (=Document Creation Date), REQUIRED </xsl:comment>
        <time value="{$documentCreatedOn}" />
        <assignedAuthor>
          <xsl:comment>10.02 AUTHOR ID (VA OID) (authorOID), REQUIIRED </xsl:comment>
          <xsl:comment> Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
          <id nullFlavor="NA"/>
          <code nullFlavor="UNK"/>
          <xsl:comment>Assigned Author Telecom Required, but VA VistA data not yet available </xsl:comment>
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <xsl:comment> 10.02 AUTHOR NAME REQUIRED </xsl:comment>
          <xsl:comment> assignedPerson/Author Name REQUIRED but provided as representedOrganization </xsl:comment>
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <!-- this causes validation errors
          <assignedAuthoringDevice>
            <manufacturerModelName>InterSystems</manufacturerModelName>
            <softwareName>InterSystems HealthShare</softwareName>
          </assignedAuthoringDevice>-->
          <xsl:comment>10.02 AUTHOR NAME REQUIRED as representedOrganization </xsl:comment>
          <representedOrganization>
            <xsl:comment>
              10.02 AUTHORING DEVICE ORGANIZATION OID (VA OID) (deviceOrgOID), REQUIRED
            </xsl:comment>
            <id nullFlavor="NI" />
            <xsl:comment>10.02 AUTHORING DEVICE ORGANIZATION NAME (deviceOrgName), REQUIRED </xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment>Assigned Author Telecom Required, but VA VistA data not yet available</xsl:comment>
            <telecom nullFlavor="NA" />
            <xsl:comment>Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
            <addr use="WP">
              <streetAddressLine>810 Vermont Avenue, NW</streetAddressLine>
              <city>Washington</city>
              <state>DC</state>
              <postalCode>20420</postalCode>
              <country>US</country>
            </addr>
          </representedOrganization>
        </assignedAuthor>
      </author>
      <xsl:comment>
        *******************************************************************************************
        INFORMANT SECTION (AS AN ORGANIZATION), Optional *******************************************************************************************
      </xsl:comment>
      <informant>
        <assignedEntity>
          <id nullFlavor="NI" />
          <addr nullFlavor="NA" />
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <xsl:comment>Name Required for informant/assignedEntity/assignedPerson </xsl:comment>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
        </assignedEntity>
      </informant>
      <xsl:comment>
        *********************************************************************************
        CUSTODIAN AS AN ORGANIZATION, REQUIRED **********************************************************************************
      </xsl:comment>
      <custodian>
        <assignedCustodian>
          <representedCustodianOrganization>
            <xsl:comment>CUSTODIAN OID (VA OID)</xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
            <xsl:comment>CUSTODIAN NAME</xsl:comment>
            <name>Department of Veterans Affairs</name>
            <xsl:comment>Telecom Required for representedOrganization, but VA VistA data not yet available</xsl:comment>
            <telecom nullFlavor="NA" />
            <xsl:comment>Address Required for representedOrganization, but VA VistA data not yet available</xsl:comment>
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
      <xsl:comment>
        ***************************************************************************
        LEGAL AUTHENTICATOR (AS AN ORGANIZATION), Optional ***************************************************************************
      </xsl:comment>
      <legalAuthenticator>
        <xsl:comment>TIME OF AUTHENTICATION </xsl:comment>
        <time value="{$documentCreatedOn}" />
        <signatureCode code="S" />
        <assignedEntity>
          <id nullFlavor="NI" />
          <code nullFlavor="NI" />
          <addr>
            <streetAddressLine>810 Vermont Avenue NW</streetAddressLine>
            <city>Washington</city>
            <state>DC</state>
            <postalCode>20420</postalCode>
            <country>US</country>
          </addr>
          <telecom nullFlavor="NA" />
          <assignedPerson>
            <name>Department of Veterans Affairs</name>
          </assignedPerson>
          <representedOrganization>
            <xsl:comment> LEGAL AUTHENTICATOR OID (VA) </xsl:comment>
            <id root="2.16.840.1.113883.4.349" />
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
      <xsl:comment>
        ********************************************************************
        SUPPORT INFORMATION CONTENT MODULE, Optional ********************************************************************
      </xsl:comment>
      <xsl:apply-templates select="Patient/SupportContacts/SupportContact" mode="header-participant" />

      <xsl:comment>
        *******************************************************************************
        DOCUMENTATION OF MODULE - QUERY META DATA, Optional *******************************************************************************
      </xsl:comment>
      <documentationOf>
        <serviceEvent classCode="PCPR">
          <effectiveTime>
            <low value="{$patientBirthDate}" />
            <high value="{$documentCreatedOn}" />
          </effectiveTime>
          <xsl:apply-templates select="Patient/Extension/CareTeamMembers/CareProvider[Description = 'PRIMARY CARE PROVIDER']" mode="header-careteammembers">
            <xsl:with-param name="number" select="'1'" />
          </xsl:apply-templates>
          <xsl:apply-templates select="Patient/Extension/CareTeamMembers/CareProvider[not(Description = 'PRIMARY CARE PROVIDER')]" mode="header-careteammembers">
            <xsl:with-param name="number" select="'2'" />
          </xsl:apply-templates>
        </serviceEvent>
      </documentationOf>
      <xsl:comment> Per C-CDA R2.1 Companion Guide, componentOf/encompassingEncounter omitted for multiple episode CCD </xsl:comment>
      <xsl:comment> ******************************************************** CDA BODY ******************************************************** </xsl:comment>
      <component>
        <structuredBody>
          <xsl:comment>Insurance Providers </xsl:comment>
          <component>
            <xsl:comment>
              **********************************************************************************
              INSURANCE PROVIDERS (PAYERS) SECTION, Optional **********************************************************************************
            </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(MemberEnrollments/MemberEnrollment))">
                <section nullFlavor="NI">
                  <templateId root="2.16.840.1.113883.10.20.22.2.18"/>
                  <code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Payers" />
                  <title>Payers</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <templateId root="2.16.840.1.113883.10.20.22.2.18"/>
                  <code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Payers" />
                  <title>Payers</title>
                  <xsl:comment>PAYERS NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment> VA Insurance Providers Business Rules for Medical Content </xsl:comment>
                    <paragraph>This section includes the names of all active insurance providers for the patient.</paragraph>
                    <table>
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
                        <xsl:for-each select="MemberEnrollments/MemberEnrollment">
                          <tr>
                            <td>
                              <content ID="{concat('insCompany',position())}">
                                <xsl:value-of select="HealthFund/HealthFund/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('insInsurance',position())}">
                                <xsl:value-of select="InsuranceTypeOrProductCode/Code/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('insGroupName',position())}">
                                <xsl:value-of select="HealthFund/GroupName/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('insEffectiveDate',position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="HealthFund/FromTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                                </xsl:call-template>
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('insExpirationDate',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="HealthFund/ToTime/text()" />
                                <!-- TODO: Need to know where exp date gets mapped into SDA, don't have it in test data-->
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('insGroup',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="HealthFund/GroupNumber/text()" />
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('insMemberId',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="HealthFund/MembershipNumber/text()" />
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:value-of select="HealthFund/HealthFund/ContactInfo/WorkPhoneNumber/text()" />
                                <!-- TODO: remove, just testing -->
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('insMemberName',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="concat(HealthFund/InsuredName/FamilyName/text(), ',', HealthFund/InsuredName/GivenName/text())" />
                              </content>
                            </td>

                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('insRelationship',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="HealthFund/InsuredRelationship/Description/text()" />
                              </content>
                            </td>

                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:comment>PAYERS STRUCTURED DATA</xsl:comment>
                  <xsl:for-each select="MemberEnrollments/MemberEnrollment">
                    <xsl:comment>CCD Coverage Activity</xsl:comment>
                    <entry>
                      <act classCode="ACT" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.60"/>
                        <id nullFlavor="NA" />
                        <code code="48768-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Payment Sources" />
                        <statusCode code="completed" />
                        <xsl:comment>CCD Payment Provider Event Entry</xsl:comment>
                        <entryRelationship typeCode="COMP">
                          <act classCode="ACT" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.61" extension = "2015-08-01" />
                            <xsl:comment>5.01 GROUP NUMBER, REQUIRED</xsl:comment>
                            <id extension="{HealthFund/GroupNumber/text()}" root="2.16.840.1.113883.4.349" />
                            <xsl:comment>5.02 HEALTH INSURANCE TYPE, REQURIED</xsl:comment>
                            <code codeSystem="2.16.840.1.113883.6.255.1336" codeSystemName="X12N-1336" >
                              <!-- TODO: Determine where the VETS translated code goes -->
                              <originalText />
                            </code>
                            <statusCode code="completed" />
                            <xsl:comment>5.07 - Health Plan Coverage Dates, R2-Optional </xsl:comment>
                            <effectiveTime>
                              <xsl:comment>5.07 VistA Policy Effective Date</xsl:comment>
                              <low value="{translate(HealthFund/FromTime/text(), 'TZ:- ', '')}"/>
                              <xsl:comment>5.07 VistA Policy Expiration  Date</xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(HealthFund/ToTime)">
                                  <!-- TODO: Where is the exp date really?  DS: changed to 'ToTime'-->
                                  <high value="{translate(HealthFund/ToTime/text(), 'TZ:- ', '')}" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <high nullFlavor="NA" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </effectiveTime>
                            <performer typeCode="PRF">
                              <templateId root="2.16.840.1.113883.10.20.22.4.87" />
                              <xsl:comment>CCD Payer Info</xsl:comment>
                              <assignedEntity>
                                <id nullFlavor="UNK" />
                                <xsl:comment>5.03 HEALTH PLAN INSURANCE INFO SOURCE ID, REQUIRED </xsl:comment>
                                <xsl:comment>5.04 HEALTH PLAN INSURANCE INFO SOURCE ADDRESS, Optional </xsl:comment>
                                <xsl:apply-templates select="HealthFund/HealthFund" mode="standard-address" >
                                  <xsl:with-param name="use">WP</xsl:with-param>
                                </xsl:apply-templates>
                                <xsl:comment>5.05 HEALTH PLAN INSURANCE INFO SOURCE PHONE/EMAIL/URL, Optional </xsl:comment>
                                <xsl:apply-templates select="HealthFund/HealthFund" mode="standard-contact-info" />
                                <representedOrganization>
                                  <xsl:comment>5.06 HEALTH PLAN INSURANCE INFO SOURCE NAME ( Insurance Company Name), R2 </xsl:comment>
                                  <name>
                                    <xsl:value-of select="HealthFund/HealthFund/Description/text()"/>
                                  </name>
                                </representedOrganization>
                              </assignedEntity>
                            </performer>
                            <author>
                              <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                              <time nullFlavor="NA" />
                              <assignedAuthor>
                                <id nullFlavor="NI" />
                                <representedOrganization>
                                  <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                  <xsl:comment>INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME</xsl:comment>
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description/text()"/>
                                  </name>
                                  <telecom nullFlavor="NA" />
                                  <addr nullFlavor="NA" />
                                </representedOrganization>
                              </assignedAuthor>
                            </author>
                            <participant typeCode="COV">
                              <templateId root="2.16.840.1.113883.10.20.22.4.89" />
                              <participantRole classCode="PAT">
                                <id root="2.16.840.1.113883.4.349" extension="{HealthFund/MembershipNumber/text()}" />
                                <xsl:comment> 5.09 PATIENT RELATIONSHIP TO SUBSCRIBER, REQUIRED, HL7 Coverage Role Type</xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(HealthFund/InsuredRelationship/Code)">
                                    <code code="" displayName="" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode">
                                      <!-- TODO: need VETS translated HL7 code for relationship type -->
                                      <originalText>
                                        <reference value="{concat('#insRelationship',position())}"/>
                                      </originalText>
                                    </code>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode">
                                      <originalText>
                                        <reference value="{concat('#insRelationship',position())}"/>
                                      </originalText>
                                    </code>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </participantRole>
                            </participant>
                            <xsl:if test="not(HealthFund/InsuredRelationship/Code/text() = 'P')" >
                              <participant typeCode="HLD">
                                <templateId root="2.16.840.1.113883.10.20.22.4.90" />
                                <participantRole>
                                  <id root="2.16.840.1.113883.4.349" extension="{HealthFund/MembershipNumber/text()}" />
                                  <xsl:comment>5.16 SUBSCRIBER ADDRESS </xsl:comment>
                                  <addr use="HP" nullFlavor="NA" />
                                  <xsl:comment>5.17 SUBSCRIBER PHONE </xsl:comment>
                                  <telecom nullFlavor="NA" />
                                  <playingEntity>
                                    <xsl:comment>5.18 SUBSCRIBER NAME, REQUIRED </xsl:comment>
                                    <name>
                                      <xsl:value-of select="HealthFund/MembershipNumber/text()" />
                                    </name>
                                    <xsl:comment> 5.19 SUBSCRIBER DATE OF BIRTH, R2 </xsl:comment>
                                    <sdtc:birthTime nullFlavor="UNK"/>
                                  </playingEntity>
                                </participantRole>
                              </participant>
                            </xsl:if>
                            <xsl:comment>5.24 HEALTH PLAN NAME, optional </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <act classCode="ACT" moodCode="DEF">
                                <id root="2.16.840.1.113883.4.349" extension="{InsuredGroupOrPolicyNumber/text()}" />
                                <code nullFlavor="NA" />
                                <text>
                                  <xsl:value-of select="InsuredGroupOrPolicyNumber/text()" />
                                </text>
                              </act>
                            </entryRelationship>
                          </act>
                        </entryRelationship>
                      </act>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
            <xsl:comment>
              ******************************************************** ADVANCED
              DIRECTIVE SECTION, REQUIRED ********************************************************
            </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(AdvanceDirectives/AdvanceDirective))">
                <section nullFlavor="NI">
                  <xsl:comment> C-CDA Advanced Directive Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.21.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.21" />
                  <code code="42348-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Advance Directives" />
                  <title>Advance Directives</title>
                  <xsl:comment>ADVANCED DIRECTIVES NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> C-CDA Advanced Directive Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.21.1"/>
                  <templateId root="2.16.840.1.113883.10.20.22.2.21" />
                  <code code="42348-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Advance Directives" />
                  <title>Advance Directives</title>
                  <xsl:comment> ADVANCED DIRECTIVES NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <paragraph>
                      This section includes a list of a patient's completed, amended, or rescinded VA Advance Directives, but an actual copy is not included.
                    </paragraph>
                    <table>
                      <thead>
                        <tr>
                          <th>Date</th>
                          <th>Advance Directives</th>
                          <th>Provider</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="AdvanceDirectives/AdvanceDirective">
                          <xsl:sort select="FromTime" />
                          <tr>
                            <td>
                              <xsl:call-template name="tmpDateTemplate" >
                                <xsl:with-param name="date-time" select="FromTime/text()" />
                                <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                              </xsl:call-template>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('advanceDirective',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="AlertType/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('advDirProvider',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="EnteredBy/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content>
                                <xsl:attribute name="ID">
                                  <xsl:value-of select="concat('advDirSource',position())" />
                                </xsl:attribute>
                                <xsl:value-of select="EnteredAt/Description/text()" />
                              </content>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:comment> ADVANCED DIRECTIVES STRUCTURED DATA </xsl:comment>
                  <xsl:for-each select="AdvanceDirectives/AdvanceDirective">
                    <xsl:sort select="FromTime" />
                    <entry>
                      <xsl:comment> CCD Advanced Directive Observation, R2 </xsl:comment>
                      <observation classCode="OBS" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.48"/>
                        <id nullFlavor="NI" />
                        <xsl:comment> 12.01 ADVANCED DIRECTIVE TYPE, REQUIRED, SNOMED CT </xsl:comment>
                        <code xsi:type="CD" nullFlavor="UNK">
                          <originalText>
                            <reference value="{concat('#advanceDirective',position())}"/>
                          </originalText>
                        </code>
                        <statusCode code="completed" />
                        <xsl:comment>12.03 ADVANCED DIRECTIVE EFFECTIVE DATE, REQUIRED </xsl:comment>
                        <effectiveTime>
                          <xsl:comment> ADVANCED DIRECTIVE EFFECTIVE DATE low = starting time, REQUIRED </xsl:comment>
                          <low value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                          <xsl:comment> ADVANCED DIRECTIVE EFFECTIVE DATE high= ending time, REQUIRED </xsl:comment>
                          <high nullFlavor="NA" />
                        </effectiveTime>
                        <value xsi:type="CD">
                          <originalText>
                            <reference value="{concat('#advanceDirective',position())}"/>
                          </originalText>
                        </value>
                        <xsl:comment> ADVANCED DIRECTIVE REFERENCE, R2, not provided by VA </xsl:comment>
                        <author>
                          <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                          <time nullFlavor="UNK" />
                          <assignedAuthor>
                            <id nullFlavor="NI" />
                            <representedOrganization>
                              <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <participant typeCode="VRF">
                          <templateId root="2.16.840.1.113883.10.20.1.58"/>
                          <time nullFlavor="UNK"/>
                          <participantRole>
                            <code nullFlavor="NA" />
                            <addr nullFlavor="NA" />
                            <xsl:comment> VERIFIER PHONE/EMAIL/URL, R2 </xsl:comment>
                            <telecom nullFlavor="NA" />
                            <playingEntity>
                              <xsl:comment> VERIFIER NAME, REQUIRED  </xsl:comment>
                              <name>Department of Veterans Affairs</name>
                            </playingEntity>
                          </participantRole>
                        </participant>
                        <xsl:comment> CUSTODIAN OF DOCUMENT, REQUIRED </xsl:comment>
                        <participant typeCode="CST">
                          <participantRole classCode="AGNT">
                            <xsl:comment> CUSTODIAN ADDRESS, R2 </xsl:comment>
                            <addr nullFlavor="NA" />
                            <xsl:comment> CUSTODIAN PHONE?EMAIL/URL, R2 </xsl:comment>
                            <telecom nullFlavor="NA" />
                            <playingEntity>
                              <xsl:comment> CUSTODIAN NAME, REQUIRED </xsl:comment>
                              <name>
                                <xsl:value-of select="EnteredBy/Description/text()"/>
                              </name>
                            </playingEntity>
                          </participantRole>
                        </participant>
                      </observation>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
            <xsl:comment>
              ************************************************************* ALLERGY/DRUG
              SECTION SECTION, REQUIRED *************************************************************
            </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(Allergies/Allergy))">
                <section nullFlavor="NI">
                  <xsl:comment>ALLERGY/DRUG Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.6.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.6" />
                  <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
                  <title>Allergies</title>
                  <xsl:comment> ALLERGIES NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment>ALLERGY/DRUG Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.6.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.6" />
                  <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
                  <title>Allergies</title>
                  <xsl:comment> ALLERGIES NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment>VA Allergies/Drug Business Rules for Medical Content </xsl:comment>
                    <paragraph>
                      This section includes Allergies on record with VA for the
                      patient. The data comes from all VA treatment facilities. It does
                      not list allergies that were removed or entered in error. Some
                      allergies may also be reported in the Immunization section.
                    </paragraph>
                    <table>
                      <thead>
                        <tr>
                          <th>Allergen</th>
                          <th>Date Recorded</th>
                          <th>Event Type</th>
                          <th>Reaction(s)</th>
                          <th>Severity</th>
                          <th>Allergy Details</th> 
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Allergies/Allergy">
                          <xsl:sort select="Allergy/Description" />
                          <xsl:if test="boolean(Allergy/SDACodingStandard) or (count(../Allergy/Allergy/SDACodingStandard) = 0 and ((Allergy/Code/text() = 'NKA' and count(preceding::Allergy[Code/text() = 'NKA']) = 0) or ((Allergy/Code/text() = 'NONE' and count(preceding::Allergy[Code/text() = 'NONE']) = 0))))">
                            <xsl:choose>
                              <xsl:when test="boolean(Allergy/SDACodingStandard)">
                                <xsl:variable name="allergyIndex" select="position()" />
                                <tr>
                                  <td>
                                    <content ID="{concat('andAllergy',position())}">
                                      <xsl:value-of select="Allergy/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="(VerifiedTime | EnteredOn)/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                                    </xsl:call-template>
                                  </td>
                                  <td>
                                    <content ID="{concat('andEventType',position())}">
                                      <xsl:value-of select="AllergyCategory/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <xsl:if test="boolean(Extension/Reactions/Reaction)">
                                      <list>
                                        <xsl:for-each select="Extension/Reactions/Reaction">
                                          <item>
                                            <content ID="{concat('andReaction', $allergyIndex, '-', position())}">
                                              <xsl:value-of select="Description/text()" />
                                            </content>
                                          </item>
                                        </xsl:for-each>
                                      </list>
                                    </xsl:if>
                                  </td>
                                  <td>
                                    <content ID="{concat('andSeverity',position())}">
                                      <xsl:value-of select="Severity/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('andDetails',position())}">
                                      <xsl:value-of select="Extension/Source/text()" />
                                    </content>
                                    <xsl:if test="boolean(Extension/Comments)">
                                      <list>
                                        <xsl:for-each select="Extension/Comments/Comment">
                                          <item>
                                            <xsl:value-of select="CommentText" />
                                          </item>
                                        </xsl:for-each>
                                      </list>
                                    </xsl:if>
                                  </td>
                                  <td>
                                    <content ID="{concat('andSource',position())}">
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
                                    <content ID="{concat('andSource',position())}">
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
                              <templateId root="2.16.840.1.113883.10.20.22.4.30"/>
                              <xsl:comment> CCD Allergy Act ID as nullFlavor </xsl:comment>
                              <id nullFlavor="NA" />
                              <!--<code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" /> -->
                              <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Allergies, adverse reactions, alerts" />
                              <statusCode code="active" />
                              <effectiveTime>
                                <xsl:choose>
                                  <xsl:when test="boolean(VerifiedTime)">
                                    <low value="{translate(VerifiedTime/text(), 'TZ:- ','')}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <low value="{translate(EnteredOn/text(), 'TZ:- ','')}" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </effectiveTime>
                              <xsl:comment> INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional </xsl:comment>
                              <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <time nullFlavor="NA" />
                                <assignedAuthor>
                                  <id nullFlavor="NA" />
                                  <code nullFlavor="NA" />
                                  <representedOrganization>
                                    <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING FACILITY NBR </xsl:comment>
                                    <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                    <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
                                    <telecom nullFlavor="NA" />
                                    <addr nullFlavor="NA" />
                                  </representedOrganization>
                                </assignedAuthor>
                              </author>
                              <entryRelationship typeCode="SUBJ">
                                <xsl:comment> Allergy Intolerance Observation Entry </xsl:comment>
                                <observation classCode="OBS" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.7" />
                                  <id nullFlavor="NA" />
                                  <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode" />
                                  <statusCode code="completed" />
                                  <xsl:comment> 6.01 ADVERSE EVENT DATE, REQUIRED </xsl:comment>
                                  <effectiveTime>
                                    <xsl:choose>
                                      <xsl:when test="boolean(VerifiedTime)">
                                        <low value="{translate(VerifiedTime/text(), 'TZ:- ','')}" />
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <low value="{translate(EnteredOn/text(), 'TZ:- ','')}" />
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </effectiveTime>
                                  <xsl:comment> 6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT </xsl:comment>
                                  <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                    <!-- TODO: Vets Translation here -->
                                    <originalText>
                                      <reference value="{concat('#andEventType',position())}"/>
                                    </originalText>
                                  </value>
                                  <participant typeCode="CSM">
                                    <participantRole classCode="MANU">
                                      <playingEntity classCode="MMAT">
                                        <xsl:comment> 6.04 PRODUCT CODED,REQUIRED </xsl:comment>
                                        <!--DS TODO: Insert translated data from VPR, once NDS patch utility is installed Allergy/Extension/DrugProducts/DrugProduct/Code&Description -->
                                        <code codeSystem="2.16.840.1.113883.6.88"  codeSystemName="RxNorm">
                                          <xsl:comment> 6.03 PRODUCT FREE TEXT, R2 </xsl:comment>
                                          <originalText>
                                            <reference value="{concat('#andAllergy',position())}" />
                                          </originalText>
                                          <!-- TODO: Vets Translation here (RXNORM) Internal or VETS? DS: Is translation still required here if VPR is providing native data?-->
                                          <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                                        </code>
                                      </playingEntity>
                                    </participantRole>
                                  </participant>
                                  <xsl:comment> REACTION ENTRY RELATIONSHIP BLOCK R2, repeatable </xsl:comment>
                                  <xsl:for-each select="Extension/Reactions/Reaction">
                                    <entryRelationship typeCode="MFST" inversionInd="true">
                                      <observation classCode="OBS" moodCode="EVN">
                                        <templateId root="2.16.840.1.113883.10.20.22.4.9" />
                                        <id nullFlavor="NA" />
                                        <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>
                                        <statusCode code="completed" />
                                        <xsl:comment> 6.06 REACTION CODED, REQUIRED </xsl:comment>
                                        <!-- DS TODO: This will be provided by the VPR once NDS patch utility is applied -->
                                        <xsl:choose>
                                          <xsl:when test="boolean(Extension/Reactions/Reaction)">
                                            <value code="{Code/text()}" displayName="{Description/text()}" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                              <xsl:comment> 6.05 REACTION-FREE TEXT, optional, </xsl:comment>
                                              <originalText>
                                                <reference value="{concat('#andReaction', $allergyIndex, '-', position())}" />
                                              </originalText>
                                              <!--DS TODO - do we still need translation if VPR Is providing native data?-->
                                              <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                                            </value>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <value nullFlavor="UNK" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                              <xsl:comment> 6.05 REACTION-FREE TEXT, optional, </xsl:comment>
                                              <originalText>
                                                <reference value="{concat('#andReaction', $allergyIndex, '-', position())}" />
                                              </originalText>
                                            </value>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </observation>
                                    </entryRelationship>
                                  </xsl:for-each>
                                  <xsl:comment> SEVERITY ENTRY RELATIONSHIP BLOCK R2, 0 or 1 per Allergy </xsl:comment>
                                  <entryRelationship typeCode="SUBJ" inversionInd="true">
                                    <observation classCode="OBS" moodCode="EVN">
                                      <templateId root="2.16.840.1.113883.10.20.22.4.8"/>
                                      <code code="SEV" displayName="Severity" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode" />
                                      <xsl:comment> 6.07 SEVERITY FREE TEXT, Optional-R2 Removed b/c removed in template </xsl:comment>
                                      <text>
                                        <reference value="{concat('#andSeverity',position())}" />
                                      </text>
                                      <statusCode code="completed" />
                                      <xsl:comment> 6.08 SEVERITY CODED, REQUIRED, SNOMED CT </xsl:comment>
                                      <!-- TODO: Internal Translation  DS - this is being provided in the VPR-->
                                      <xsl:choose>
                                        <xsl:when test="Allergy/Severity">
                                          <!-- DS check context-->
                                          <value code="{Severity/Code/text()}" displayName="{Severity/Description/text()}" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <value xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" />
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </observation>
                                  </entryRelationship>
                                </observation>
                              </entryRelationship>
                            </act>
                          </entry>
                        </xsl:when>
                        <xsl:otherwise>
                          <entry typeCode="DRIV">
                            <act classCode="ACT" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.30"/>
                              <xsl:comment>CCD Allergy Act ID as nullFlavor</xsl:comment>
                              <id nullFlavor="NA"/>
                              <code code="CONC" codeSystem="2.16.840.1.113883.5.6" displayName="Concern"/>
                              <statusCode code="active"/>
                              <effectiveTime>
                                <low nullFlavor="NA"/>
                              </effectiveTime>
                              <xsl:comment>INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional</xsl:comment>
                              <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119"/>
                                <time nullFlavor="NA"/>
                                <assignedAuthor>
                                  <id nullFlavor="NA"/>
                                  <code nullFlavor="NA"/>
                                  <representedOrganization>
                                    <xsl:comment>INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING FACILITY NBR</xsl:comment>
                                    <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                    <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
                                    <telecom nullFlavor="NA"/>
                                    <addr nullFlavor="NA"/>
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
                                  <templateId root="2.16.840.1.113883.10.20.22.4.7"/>
                                  <id nullFlavor="NA"/>
                                  <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName="HL7ActCode"/>
                                  <statusCode code="completed"/>
                                  <xsl:comment>6.01 ADVERSE EVENT DATE, REQUIRED</xsl:comment>
                                  <effectiveTime>
                                    <low nullFlavor="NA"/>
                                  </effectiveTime>
                                  <xsl:comment>6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT</xsl:comment>
                                  <value code="419199007" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Allergy to substance (disorder)" xsi:type="CD"></value>
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
          <component>
            <xsl:comment>
              ******************************************************** ENCOUNTER SECTION, Optional ********************************************************
            </xsl:comment>
            <xsl:choose>
              <!-- TODO Encounters filterings? -->
              <xsl:when test="not(boolean(Encounters/Encounter))">
                <section nullFlavor="NI">
                  <templateId root="2.16.840.1.113883.10.20.22.2.22.1"/>
                  <templateId root="2.16.840.1.113883.10.20.22.2.22" />
                  <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Encounters" />
                  <title>Encounters</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <templateId root="2.16.840.1.113883.10.20.22.2.22.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.22" />
                  <code code="46240-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Encounters" />
                  <title>Encounters</title>
                  <text>
                    <paragraph>
                      This section contains a list of completed VA Outpatient Encounters for
                      the patient and a list of Encounter Notes, Consult Notes, History &amp;
                      Physical Notes, and Discharge Summaries for the patient. The data comes
                      from all VA treatment facilities.
                      <br />
                      <br />
                    </paragraph>

                    <paragraph>
                      The list of VA Outpatient Encounters shows all Encounter dates within
                      the requested date range. If no date range was provided, the list of VA
                      Outpatient Encounters shows all Encounter dates within the last 18 months.
                      Follow-up visits related to the VA Encounter are not included. The data comes
                      from all VA treatment facilities.
                    </paragraph>

                    <xsl:comment> VA Encounter Business Rules for Medical Content </xsl:comment>
                    <table>
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
                        <xsl:for-each select="Encounters/Encounter[EncounterType = 'O' and not(EncounterCodedType/Code = 'E')]">
                          <xsl:sort select="FromTime" order="descending" />
                          <xsl:variable name="eid" select="EncounterNumber/text()" />
                          <xsl:variable name="procs" select="../../Procedures/Procedure[EncounterNumber = $eid]" />
                          <xsl:variable name="diags" select="../../Diagnoses/Diagnosis[EncounterNumber = $eid]" />
                          <tr>
                            <td>
                              <xsl:call-template name="tmpDateTemplate" >
                                <xsl:with-param name="date-time" select="FromTime/text()" />
                                <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                              </xsl:call-template>
                            </td>
                            <td>
                              <content ID="{concat('endEncounterType',position())}">
                                <xsl:value-of select="$procs/Procedure/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('endEncounterDescription',position())}">
                                <xsl:value-of select="HealthCareFacility/Extension/StopCode/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('endReason',position())}">
                                <!-- TODO: Where da reason comments, yo? -->
                                <xsl:value-of select="concat($diags/Diagnosis/Description/text(), ' ', $diags/Diagnosis/SDACodingStandard/text(), ' ', $diags/Diagnosis/Code/text(), '')" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('endProvider',position())}">
                                <xsl:value-of select="ConsultingClinicians/CareProvider[1]/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('endSource',position())}">
                                <xsl:value-of select="EnteredAt/Description/text()" />
                              </content>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <!-- Start Associated Notes Narrative-->
                    <paragraph>The list of Encounter Notes shows the 5 most recent notes associated to the 10 most recent Outpatient Encounters. The data comes from all VA treatment facilities.</paragraph>
                    <table>
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Encounter Note</th>
                          <th>Provider</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Encounters/Encounter[EncounterType = 'O' and not(EncounterCodedType/Code = 'E')]">
                          <xsl:sort select="FromTime" order="descending" />
                          <xsl:variable name="eid" select="EncounterNumber/text()" />
                          <xsl:variable name="docs" select="../../Documents/Document[EncounterNumber = $eid]" />
                          <xsl:if test="position() &lt; 11">
                            <xsl:for-each select="$docs" >
                              <xsl:sort select="FromTime" order="descending" />
                              <xsl:if test="position() &lt; 6">
                                <tr>
                                  <td>
                                    <content ID="{concat('anNoteDateTime', $eid, '-', position())}">
                                      <xsl:call-template name="tmpDateTemplate" >
                                        <xsl:with-param name="date-time" select="FromTime/text()" />
                                        <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                      </xsl:call-template>
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('anNoteEncounterDescription', $eid, '-', position())}">
                                      <xsl:call-template name="standard-insertBreaks">
                                        <xsl:with-param name="pText" select="NoteText/text()" />
                                      </xsl:call-template>
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('anNoteProvider', $eid, '-', position())}">
                                      <xsl:value-of select="Clinician/Description/text()" />
                                    </content>
                                  </td>
                                  <td>
                                    <content ID="{concat('anNoteSource', $eid, '-', position())}">
                                      <xsl:value-of select="EnteredAt/Description/text()" />
                                    </content>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <!-- Stop Associated Notes Narrative -->
                    <!-- Consult notes begin -->
                    <paragraph>The list of Consult Notes with complete text includes all notes within the requested date range. If no date range was provided, the list of Consult Notes with complete text includes the 5 most recent notes within the last 18 months. The data comes from all VA treatment facilities.</paragraph>
                    <table>
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Encounter Note</th>
                          <th>Provider</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CR' and not(Extension/NationalTitle/Code/text() = 217)]">
                          <xsl:sort select="DocumentTime" order="descending" />
                          <xsl:if test="position() &lt; 6">
                            <tr>
                              <td>
                                <content ID="{concat('noteDateTime',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('noteEncounterDescription',position())}">
                                  <xsl:call-template name="standard-insertBreaks">
                                    <xsl:with-param name="pText" select="NoteText/text()"/>
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('noteProvider',position())}">
                                  <xsl:value-of select="Clinician/Description/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('noteSource',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <xsl:if test="count(Documents/Document[DocumentType/Code/text() = 'CR' and not(Extension/NationalTitle/Code/text() = 217)]) &gt; 5">
                      <!-- Condensed Consult notes begin title only -->
                      <paragraph>
                        The list of ADDITIONAL Consult Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                      </paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Encounter Note Title</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CR' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &gt; 5">
                              <tr>
                                <td>
                                  <content ID="{concat('noteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('noteEncounterDescription',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('noteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('noteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <!-- history and physical notes begin -->
                    <paragraph>The list of H &amp; P Notes with complete text includes all notes within the requested date range. If no date range was provided, the list of H &amp; P Notes with complete text includes the 2 most recent notes within the last 18 months. The data comes from all VA treatment facilities.</paragraph>
                    <table>
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Encounter Note</th>
                          <th>Provider</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'HP' and not(Extension/NationalTitle/Code/text() = 217)]">
                          <xsl:sort select="DocumentTime" order="descending" />
                          <xsl:if test="position() &lt; 3">
                            <tr>
                              <td>
                                <content ID="{concat('hpnoteDateTime',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hpnoteEncounterDescription',position())}">
                                  <xsl:call-template name="standard-insertBreaks">
                                    <xsl:with-param name="pText" select="NoteText/text()"/>
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hpnoteProvider',position())}">
                                  <xsl:value-of select="Clinician/Description/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hpnoteSource',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <!-- history and physical notes titles only begin -->
                    <xsl:if test="count(Documents/Document[DocumentType/Code/text() = 'HP' and not(Extension/NationalTitle/Code/text() = 217)]) &gt; 2">
                      <paragraph > The list of ADDITIONAL H &amp; P Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.</paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Encounter Note Title</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'HP' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &gt; 2">
                              <tr>
                                <td>
                                  <content ID="{concat('hpnoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('hpnoteEncounterDescription',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('hpnoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('hpnoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <!-- Discharge summary notes begin -->
                    <paragraph >The list of Discharge Summaries with complete text includes all summaries within the requested date range. If no date range was provided, the list of Discharge Summaries includes the 2 most recent summaries within the last 18 months. The data comes from all VA treatment facilities.</paragraph>
                    <table >
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Encounter Note</th>
                          <th>Provider</th>
                          <th>Source</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'DS' and not(Extension/NationalTitle/Code/text() = 217)]">
                          <xsl:sort select="DocumentTime" order="descending" />
                          <xsl:if test="position() &lt; 3">
                            <tr>
                              <td>
                                <content ID="{concat('dsnoteDateTime',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('dsnoteEncounterDescription',position())}">
                                  <xsl:call-template name="standard-insertBreaks">
                                    <xsl:with-param name="pText" select="NoteText/text()"/>
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('dsnoteProvider',position())}">
                                  <xsl:value-of select="Clinician/Description/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('dsnoteSource',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <!-- Discharge summary titles only notes begin -->
                    <xsl:if test="count(Documents/Document[DocumentType/Code/text() = 'DS' and not(Extension/NationalTitle/Code/text() = 217)]) &gt; 2">
                      <paragraph >The list of ADDITIONAL Discharge Summary TITLES includes all summaries signed within the last 18 months. The data comes from all VA treatment facilities.</paragraph>
                      <table >
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Encounter Note Title</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'DS' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &gt; 2">
                              <tr>
                                <td>
                                  <content ID="{concat('dsnoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('dsnoteEncounterDescription',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('dsnoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('dsnoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <xsl:comment> CDA Observation Text as a Reference tag </xsl:comment>
                    <content ID='encNote-1' revised="delete">IHE Encounter Template Text not used by VA</content>
                  </text>
                  <xsl:for-each select="Encounters/Encounter[EncounterType = 'O' and not(EncounterCodedType/Code = 'E')]">
                    <xsl:sort select="FromTime" order="descending" />
                    <xsl:variable name="index" select="position()" />
                    <xsl:variable name="eid" select="EncounterNumber/text()" />
                    <xsl:variable name="procs" select="../../Procedures/Procedure[EncounterNumber = $eid]" />
                    <xsl:variable name="docs" select="../../Documents/Document[EncounterNumber = $eid]" />
                    <xsl:variable name="diags" select="../../Diagnoses/Diagnosis[EncounterNumber = $eid]" />
                    <entry>
                      <encounter classCode="ENC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                        <id nullFlavor="NI" />
                        <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                        <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                          <xsl:choose>
                            <xsl:when test="boolean($procs/Procedure)">
                              <xsl:attribute name="code">
                                <xsl:value-of select="$procs/Procedure/Code/text()"/>
                              </xsl:attribute>
                              <xsl:attribute name="displayName">
                                <xsl:value-of select="$procs/Procedure/Description/text()"/>
                              </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="nullFlavor">NI</xsl:attribute>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                          <originalText>
                            <reference value="{concat('#endEncounterType',position())}" />
                          </originalText>
                        </code>
                        <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                        <effectiveTime xsi:type="IVL_TS">
                          <low value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                        </effectiveTime>
                        <xsl:if test="boolean(ConsultingClinicians/CareProvider[1])">
                          <performer>
                            <assignedEntity>
                              <id nullFlavor="NA" />
                              <assignedPerson>
                                <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                                <name>
                                  <xsl:value-of select="ConsultingClinicians/CareProvider[1]/Description/text()" />
                                </name>
                              </assignedPerson>
                            </assignedEntity>
                          </performer>
                        </xsl:if>
                        <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                        <xsl:comment>16.11 - FACILITY LOCATION, Optional </xsl:comment>
                        <participant typeCode="LOC">
                          <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                          <time>
                            <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                            <low  >
                              <xsl:choose>
                                <xsl:when test="boolean(EnteredOn)">
                                  <xsl:attribute name="value">
                                    <xsl:value-of select="translate(EnteredOn/text(), 'TZ:- ','')" />
                                  </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </low>
                            <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                            <high  >
                              <xsl:choose>
                                <xsl:when test="boolean(EndTime)">
                                  <xsl:attribute name="value">
                                    <xsl:value-of select="translate(EndTime/text(), 'TZ:- ','')" />
                                  </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </high>
                          </time>
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="NI"/>
                            <addr nullFlavor="UNK"/>
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name>
                                <xsl:value-of select="EnteredAt/Description"/>
                              </name>
                            </playingEntity>
                          </participantRole>
                        </participant>
                        <xsl:comment> Encounter Reason for Visit </xsl:comment>
                        <entryRelationship typeCode="RSON">
                          <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.19" />
                            <id nullFlavor="NI" />
                            <xsl:comment> CCD Reason for Visit Code, REQUIRED, SNOMED CT </xsl:comment>
                            <code nullFlavor="UNK" />
                            <xsl:comment> 16.13 REASON FOR VISIT TEXT, Optional </xsl:comment>
                            <xsl:comment> Is this for only outpatient? </xsl:comment>
                            <statusCode code="completed" />
                            <value xsi:type="CD" >
                              <originalText>
                                <!-- TODO: Internal translation ICD to Sno -->
                                <reference value="{concat('endReason',position())}" />
                              </originalText>
                              <translation codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM' />
                            </value>
                          </observation>
                        </entryRelationship>
                        <xsl:comment> CCD ENCOUNTER DIAGNOSIS, Optional </xsl:comment>
                        <entryRelationship typeCode="REFR">
                          <act classCode="ACT" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.80" />
                            <code code="29038-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS"/>
                            <statusCode code="active"/>
                            <effectiveTime>
                              <low nullFlavor="UNK"/>
                            </effectiveTime>
                            <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQURIED, SNOMED CT </xsl:comment>
                            <entryRelationship typeCode="SUBJ" inversionInd="false">
                              <observation classCode="OBS" moodCode="EVN" negationInd="false">
                                <templateId root="2.16.840.1.113883.10.20.22.4.4" extension="2015-08-01" />
                                <xsl:comment> Problem Observation </xsl:comment>
                                <id nullFlavor="UNK" />
                                <code nullFlavor="UNK">
                                  <originalText>Encounter Diagnosis Type Not Available</originalText>
                                </code>
                                <statusCode code="completed" />
                                <effectiveTime>
                                  <low nullFlavor="UNK" />
                                  <high nullFlavor="UNK" />
                                </effectiveTime>
                                <xsl:comment> CCD ENCOUNTER DIAGNOSIS PROBLEM CODE, REQUIRED, SNOMED CT </xsl:comment>
                                <value xsi:type="CD" codeSystemName="SNOMED CT" codeSystem="2.16.840.1.113883.6.96">
                                  <originalText>
                                    <!-- TODO: Translation Internal, ICD to Sno -->
                                    <reference value="{concat('endReason',position())}" />
                                  </originalText>
                                  <!-- Mel and Mar are gunn ansr-->
                                  <translation codeSystemName="ICD-9-CM" codeSystem="2.16.840.1.113883.6.103" />
                                </value>
                              </observation>
                            </entryRelationship>
                          </act>
                        </entryRelationship>
                        <xsl:comment>
                          16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA
                          b/c data not yet available via VA VistA RPCs
                        </xsl:comment>
                      </encounter>
                    </entry>
                  </xsl:for-each>
<!-- Encounter Notes -->
                  <xsl:for-each select="Encounters/Encounter[EncounterType = 'O' and not(EncounterCodedType/Code = 'E')]">
                    <xsl:sort select="FromTime" order="descending" />
                    <xsl:variable name="eid" select="EncounterNumber/text()" />
                    <xsl:variable name="docs" select="../../Documents/Document[EncounterNumber = $eid]" />
                    <xsl:if test="position() &lt; 11">
                      <xsl:for-each select="$docs" >
                        <xsl:sort select="FromTime" order="descending" />
                        <xsl:if test="position() &lt; 6">
                          <xsl:variable name="loincType">
                            <xsl:call-template name="standard-documentCategoryToLoinc">
                              <xsl:with-param name="doc" select="." />
                            </xsl:call-template>
                          </xsl:variable>
                          <xsl:variable name="code" select="exsl:node-set($loincType)" />
                          <entry typeCode="DRIV">
                            <encounter classCode="ENC" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                              <id nullFlavor="UNK" />
                              <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                              <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" code="99499" displayName="Unlisted Evaluation and Management Service">
                                <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                                <originalText>
                                  <reference value="{concat('#anNoteEncounterDescription', $eid, '-', position())}"/>
                                </originalText>
                                <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="CPT-4" code="{($code)[1]/node()[1]/text()}" displayName="{($code)[1]/node()[2]/text()}" />
                              </code>
                              <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                              <effectiveTime>
                                <low value="{translate(DocumentTime/text(),'TZ:- ','')}"/>
                              </effectiveTime>
                              <performer>
                                <assignedEntity>
                                  <id nullFlavor="NA" />
                                  <assignedPerson>
                                    <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                                    <name>
                                      <xsl:value-of select="Extension/CareProviders/CareProvider[1]/Description"/>
                                    </name>
                                  </assignedPerson>
                                </assignedEntity>
                              </performer>
                              <author>
                                <time nullFlavor="NA" />
                                <assignedAuthor>
                                  <id nullFlavor="NA" />
                                  <representedOrganization>
                                    <id root="2.16.840.1.113883.3.349" extension="{EnteredAt/Code/text()}" />
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
                                  </representedOrganization>
                                </assignedAuthor>
                              </author>
                              <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                              <xsl:comment> 16.11 - FACILITY LOCATION, Optional </xsl:comment>
                              <participant typeCode="LOC">
                                <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                                <!--
                                      <time>
                                        <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                                        <low   />
                                        <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                                        <high  />
                                      </time>
                                      -->
                                <participantRole classCode="SDLOC">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                                  <code nullFlavor="UNK"/>
                                  <addr nullFlavor="UNK"/>
                                  <telecom nullFlavor="UNK"/>
                                  <playingEntity classCode="PLC">
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description/text()"/>
                                    </name>
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
                                    <reference nullFlavor="UNK"/>
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
                                  <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                                  <statusCode code="active" />
                                  <effectiveTime nullFlavor="UNK">
                                    <low nullFlavor="UNK" />
                                  </effectiveTime>
                                  <entryRelationship typeCode="SUBJ" inversionInd="false">
                                    <observation classCode="OBS" moodCode="EVN" negationInd="false">
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
                              <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            </encounter>
                          </entry>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
<!-- CONSULT NOTES -->
                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CR' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <xsl:variable name="loincType">
                      <xsl:call-template name="standard-documentCategoryToLoinc">
                        <xsl:with-param name="doc" select="." />
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="code" select="exsl:node-set($loincType)" />
                    <entry typeCode="DRIV">
                      <encounter classCode="ENC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                        <id nullFlavor="UNK" />
                        <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                        <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" code="99499" displayName="Unlisted Evaluation and Management Service">
                          <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                          <originalText>
                            <reference value="{concat('#noteEncounterDescription',position())}"/>
                          </originalText>
                          <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="CPT-4" code="{($code)[1]/node()[1]/text()}" displayName="{($code)[1]/node()[2]/text()}" />
                        </code>
                        <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                        <effectiveTime>
                          <low value="{translate(DocumentTime/text(),'TZ:- ','')}"/>
                        </effectiveTime>
                        <performer>
                          <assignedEntity>
                            <id nullFlavor="NA" />
                            <assignedPerson>
                              <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                              <name>
                                <xsl:value-of select="Extension/CareProviders/CareProvider[1]/Description"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <author>
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <representedOrganization>
                              <id root="2.16.840.1.113883.3.349" extension="{EnteredAt/Code/text()}" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                        <xsl:comment> 16.11 - FACILITY LOCATION, Optional </xsl:comment>
                        <participant typeCode="LOC">
                          <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                          <!--
                                      <time>
                                        <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                                        <low   />
                                        <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                                        <high  />
                                      </time>
                                      -->
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="UNK"/>
                            <addr nullFlavor="UNK"/>
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
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
                              <reference nullFlavor="UNK"/>
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
                            <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                            <statusCode code="active" />
                            <effectiveTime nullFlavor="UNK">
                              <low nullFlavor="UNK" />
                            </effectiveTime>
                            <entryRelationship typeCode="SUBJ" inversionInd="false">
                              <observation classCode="OBS" moodCode="EVN" negationInd="false">
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
                        <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                      </encounter>
                    </entry>
                  </xsl:for-each>
<!-- H and P Notes -->
                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'HP' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <xsl:variable name="loincType">
                      <xsl:call-template name="standard-documentCategoryToLoinc">
                        <xsl:with-param name="doc" select="." />
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="code" select="exsl:node-set($loincType)" />
                    <entry typeCode="DRIV">
                      <encounter classCode="ENC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                        <id nullFlavor="UNK" />
                        <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                        <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" code="99499" displayName="Unlisted Evaluation and Management Service">
                          <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                          <originalText>
                            <reference value="{concat('#hpnoteEncounterDescription',position())}"/>
                          </originalText>
                          <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="CPT-4" code="{($code)[1]/node()[1]/text()}" displayName="{($code)[1]/node()[2]/text()}" />
                        </code>
                        <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                        <effectiveTime>
                          <low value="{translate(DocumentTime/text(),'TZ:- ','')}"/>
                        </effectiveTime>
                        <performer>
                          <assignedEntity>
                            <id nullFlavor="NA" />
                            <assignedPerson>
                              <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                              <name>
                                <xsl:value-of select="Extension/CareProviders/CareProvider[1]/Description"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <author>
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <representedOrganization>
                              <id root="2.16.840.1.113883.3.349" extension="{EnteredAt/Code/text()}" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                        <xsl:comment> 16.11 - FACILITY LOCATION, Optional </xsl:comment>
                        <participant typeCode="LOC">
                          <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                          <!--
                                      <time>
                                        <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                                        <low   />
                                        <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                                        <high  />
                                      </time>
                                      -->
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="UNK"/>
                            <addr nullFlavor="UNK"/>
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
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
                              <reference nullFlavor="UNK"/>
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
                            <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                            <statusCode code="active" />
                            <effectiveTime nullFlavor="UNK">
                              <low nullFlavor="UNK" />
                            </effectiveTime>
                            <entryRelationship typeCode="SUBJ" inversionInd="false">
                              <observation classCode="OBS" moodCode="EVN" negationInd="false">
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
                        <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                      </encounter>
                    </entry>
                  </xsl:for-each>
<!-- Discharge Sums Notes -->
                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'DS' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <xsl:variable name="loincType">
                      <xsl:call-template name="standard-documentCategoryToLoinc">
                        <xsl:with-param name="doc" select="." />
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="code" select="exsl:node-set($loincType)" />
                    <entry typeCode="DRIV">
                      <encounter classCode="ENC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.49" />
                        <id nullFlavor="UNK" />
                        <xsl:comment> 16.02 ENCOUNTER TYPE. R2, CPT-4 </xsl:comment>
                        <code codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" code="99499" displayName="Unlisted Evaluation and Management Service">
                          <xsl:comment> 16.03 ENCOUNTER FREE TEXT TYPE. R2 </xsl:comment>
                          <originalText>
                            <reference value="{concat('#dsnoteEncounterDescription',position())}"/>
                          </originalText>
                          <translation codeSystem="2.16.840.1.113883.6.1" codeSystemName="CPT-4" code="{($code)[1]/node()[1]/text()}" displayName="{($code)[1]/node()[2]/text()}" />
                        </code>
                        <xsl:comment> 16.04 ENCOUNTER DATE/TIME, REQUIRED </xsl:comment>
                        <effectiveTime>
                          <low value="{translate(DocumentTime/text(),'TZ:- ','')}"/>
                        </effectiveTime>
                        <performer>
                          <assignedEntity>
                            <id nullFlavor="NA" />
                            <assignedPerson>
                              <xsl:comment> 16.05 ENCOUNTER PROVIDER NAME, REQUIRED </xsl:comment>
                              <name>
                                <xsl:value-of select="Extension/CareProviders/CareProvider[1]/Description"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <author>
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <representedOrganization>
                              <id root="2.16.840.1.113883.3.349" extension="{EnteredAt/Code/text()}" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <xsl:comment>16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                        <xsl:comment> 16.11 - FACILITY LOCATION, Optional </xsl:comment>
                        <participant typeCode="LOC">
                          <xsl:comment>16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                          <!--
                                      <time>
                                        <xsl:comment>16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
                                        <low   />
                                        <xsl:comment> 16.12 - DEPARTURE DATE/TIME, Optional </xsl:comment>
                                        <high  />
                                      </time>
                                      -->
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="UNK"/>
                            <addr nullFlavor="UNK"/>
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
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
                              <reference nullFlavor="UNK"/>
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
                            <code xsi:type="CE" code="29308-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="ENCOUNTER DIAGNOSIS" />
                            <statusCode code="active" />
                            <effectiveTime nullFlavor="UNK">
                              <low nullFlavor="UNK" />
                            </effectiveTime>
                            <entryRelationship typeCode="SUBJ" inversionInd="false">
                              <observation classCode="OBS" moodCode="EVN" negationInd="false">
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
                        <xsl:comment> 16.09 DISCHARGE DISPOSITION CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                      </encounter>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment> ***** FUNCTIONAL STATUS, Optional ************ </xsl:comment>
          <component>
            <xsl:choose>
              <xsl:when test="not(boolean(Problems/Problem[Problem/Code/text() = '408907016' and count(CustomPairs/NVPair) &gt; 19]))" >
                <section nullFlavor="NI">
                  <templateId root="2.16.840.1.113883.10.20.22.2.14"  />
                  <code code="47420-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Functional Status"/>
                  <title>Functional Status</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <templateId root="2.16.840.1.113883.10.20.22.2.14" />
                  <code code="47420-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Functional Status"/>
                  <title>Functional Status</title>
                  <text>
                    <paragraph >
                      This section includes the 3 most recent Functional Independence Measurement (FIM) assessment scores from the last 3 years. The data comes from all VA treatment facilities.
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
                      <xsl:for-each select="Problems/Problem[Problem/Code/text() = '408907016' and count(CustomPairs/NVPair) &gt; 19]" >
                        <xsl:sort select="FromTime" order="descending" />
                        <xsl:if test="position() &lt; 4">
                          <tbody>
                            <tr>
                              <td>
                                <content ID="{concat('fimAssessmentDate',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="(EnteredOn | FromTime)/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimFacility',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimAssessment',position())}">
                                  <xsl:value-of select="Category/Description/text()" />
                                </content>
                              </td>
                              <td/>
                              <td/>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimEatName',position())}">Eating</content>
                              </td>
                              <td>
                                <content ID="{concat('fimEat',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Eating']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimEatDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimGroomName',position())}">Grooming</content>
                              </td>
                              <td>
                                <content ID="{concat('fimGroom',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Grooming']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimGroomDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimBathName',position())}">Bathing</content>
                              </td>
                              <td>
                                <content ID="{concat('fimBath',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Bathing']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimBathDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimDressUpName',position())}">Dressing - Upper Body</content>
                              </td>
                              <td>
                                <content ID="{concat('fimDressUp',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Dressing - Upper Body']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimDressUpDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimDressLoName',position())}">Dressing - Lower Body</content>
                              </td>
                              <td>
                                <content ID="{concat('fimDressLo',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Dressing - Lower Body']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimDressLoDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimToiletName',position())}">Toileting</content>
                              </td>
                              <td>
                                <content ID="{concat('fimToilet',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Toileting']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimToiletDetail',position())}">Self Care</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimBladderName',position())}">Bladder Management</content>
                              </td>
                              <td>
                                <content ID="{concat('fimBladder',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Bladder Management']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimBladderDetail',position())}">Sphincter Control</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimBowelName',position())}">Bowel Management</content>
                              </td>
                              <td>
                                <content ID="{concat('fimBowel',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Bowel Management']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimBowelDetail',position())}">Sphincter Control</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimTransChairName',position())}">Bed, Chair, Wheelchair</content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransChair',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Bed, Chair, Wheelchair']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransChairDetail',position())}">Transfers</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimTransToiletName',position())}">Toilet</content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransToilet',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Toilet']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransToiletDetail',position())}">Transfers</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimTransTubName',position())}">Tub, Shower</content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransTub',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Tub, Shower']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimTransTubDetail',position())}">Transfers</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimLocomWalkName',position())}">Walk/Wheelchair</content>
                              </td>
                              <td>
                                <content ID="{concat('fimLocomWalk',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Walk/Wheelchair']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimLocomWalkDetail',position())}">Locomotion</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimLocomStairName',position())}">Stairs</content>
                              </td>
                              <td>
                                <content ID="{concat('fimLocomStair',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Stairs']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimLocomStairDetail',position())}">Locomotion</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimComprehendName',position())}">Comprehension</content>
                              </td>
                              <td>
                                <content ID="{concat('fimComprehend',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Comprehension']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimComprehendDetail',position())}">Communication</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimExpressName',position())}">Expression</content>
                              </td>
                              <td>
                                <content ID="{concat('fimExpress',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Expression']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimExpressDetail',position())}">Communication</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimInteractName',position())}">Social Interaction</content>
                              </td>
                              <td>
                                <content ID="{concat('fimInteract',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Social Interaction']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimInteractDetail',position())}">Social Cognition</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimProblemName',position())}">Problem Solving</content>
                              </td>
                              <td>
                                <content ID="{concat('fimProblem',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Problem Solving']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimProblemDetail',position())}">Social Cognition</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimMemoryName',position())}">Memory</content>
                              </td>
                              <td>
                                <content ID="{concat('fimMemory',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'Memory']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimMemoryDetail',position())}">Social Cognition</content>
                              </td>
                            </tr>
                            <tr>
                              <td/>
                              <td/>
                              <td>
                                <content ID="{concat('fimTotalName',position())}">FIM Total</content>
                              </td>
                              <td>
                                <content ID="{concat('fimTotal',position())}">
                                  <xsl:value-of select="CustomPairs/NVPair[Name/text() = 'FIM Total']/Value/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('fimTotalDetail',position())}" />
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
                        </xsl:if>
                      </xsl:for-each>
                    </table>
                  </text>
                  <xsl:comment>  FUNCTIONAL STATUS STRUCTURED ENTRIES </xsl:comment>
                  <xsl:for-each select="Problems/Problem[Problem/Code/text() = '408907016' and count(CustomPairs/NVPair) &gt; 19]" >
                    <xsl:sort select="EnteredOn | FromTime" order="descending" />
                    <xsl:if test="position() &lt; 4">
                      <entry typeCode="DRIV">
                        <organizer classCode="CLUSTER" moodCode="EVN">
                          <xsl:comment> **** Functional Status Result Organizer template **** </xsl:comment>
                          <templateId root="2.16.840.1.113883.10.20.22.4.66"  />
                          <id nullFlavor="NI"/>
                          <xsl:comment> Functional Status Result Organizer Code, ICF or SNOMED CT,  FIM Assessment Type </xsl:comment>
                          <code nullFlavor="UNK">
                            <originalText>
                              <reference value="{concat('#fimAssessment',position())}"/>
                            </originalText>
                          </code>
                          <statusCode code="completed"/>
                          <effectiveTime>
                            <low nullFlavor="UNK"/>
                            <!-- TODO where do we map assessTime from in the SDA?-->
                          </effectiveTime>
                          <xsl:comment> * Information Source for Functional Status, VA Facility  </xsl:comment>
                          <author>
                            <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                            <time nullFlavor="NA"/>
                            <assignedAuthor>
                              <id nullFlavor="NI"/>
                              <addr nullFlavor="NA" />
                              <telecom nullFlavor="NA" />
                              <representedOrganization>
                                <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.3.1275"/>
                                <name>
                                  <xsl:value-of select="EnteredAt/Description/text()"/>
                                </name>
                              </representedOrganization>
                            </assignedAuthor>
                          </author>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67"  />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                              <text>
                                <reference value="{concat('#fimEatName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ','')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimEat',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>   Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimEatDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment>  Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" />
                              <xsl:comment>  Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>   Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimGroomName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>   Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimGroom',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimGroomDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimBathName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimBath',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimBathDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimDressUpName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimDressUp',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimDressUpDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimDressLoName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimDressLo',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimDressLoDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimToiletName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimToilet',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimToiletDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimBladderName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimBladder',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimBladderDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                          <component>
                            <xsl:comment> Functional Status Result Observation  </xsl:comment>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.67" extension="2014-06-09" />
                              <xsl:comment> Functional Status Result Observation ID  </xsl:comment>
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimBowelName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimBowel',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimBowelDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimTransChairName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimTransChair',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimTransChairDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimTransToiletName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimTransToilet',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimTransToiletDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimTransTubName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimTransTub',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimTransTubDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimLocomWalkName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimLocomWalk',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimLocomWalkDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimLocomStairName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimLocomStair',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimLocomStairDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimComprehendName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimComprehend',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimComprehendDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimExpressName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>-  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimExpress',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimExpressDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimInteractName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimInteract',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimInteractDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimProblemName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimProblem',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimProblemDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimMemoryName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimMemory',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimMemoryDetail',position())}"/>
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
                              <id nullFlavor="NI" />
                              <xsl:comment>  Functional Status Result Observation Code, ICF or SNOMED CT, FIM Skill  </xsl:comment>
                              <code code="54522-8" displayName="Functional status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="SNOMED CT" />
                              <text>
                                <reference value="{concat('#fimTotalName',position())}"/>
                              </text>
                              <statusCode code="completed"/>
                              <xsl:comment> Functional Status Result Observation Date/Time, FIM Assessment Date/Time </xsl:comment>
                              <effectiveTime>
                                <low value="{translate((EnteredOn | FromTime)/text(), 'TZ:- ', '')}"/>
                              </effectiveTime>
                              <xsl:comment>  Functional Status Result Observation Date/Time, FIM Skill Score </xsl:comment>
                              <value nullFlavor="NA" xsi:type="CD">
                                <translation nullFlavor="UNK">
                                  <originalText>
                                    <reference value="{concat('#fimTotal',position())}"/>
                                  </originalText>
                                </translation>
                              </value>
                              <xsl:comment>  Functional Status Result Observation Comment, FIM Details </xsl:comment>
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment"/>
                                  <text>
                                    <reference value="{concat('#fimTotalDetail',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </observation>
                          </component>
                        </organizer>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
            <xsl:comment>
              ****************************************************************MEDICATIONS (RX &amp; Non-RX) SECTION, REQUIRED ****************************************************************
            </xsl:comment>
            <xsl:choose>
              <!-- TODO Meds Filtering [((OrderCategory/Code/text() = 'O RX' or OrderCategory/Code/text() = 'O') and isc:evaluate('dateDiff', 'mm', translate((Extension/LastFilled | Extension/Expires)/text(), 'TZ', ' ')) &lt; 16 and not(Status/text() = 'DELETED')) or (OrderCategory/Code/text() = 'NV RX' and not(Status/text() = 'DISCONTINUED'))]-->
              <xsl:when test="not(boolean(Medications/Medication))">
                <section nullFlavor="NI">
                  <xsl:comment> C-CDA Medications Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.1.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.1" />
                  <code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of medication use" />
                  <title>Medications Section</title>
                  <xsl:comment> MEDICATIONS NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> C-CDA Medications Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.1.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.1" />
                  <code code="10160-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of medication use" />
                  <title>Medications Section</title>
                  <xsl:comment> MEDICATIONS NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment> VA Medication Business Rules for Medical Content </xsl:comment>
                    <paragraph>
                        This section includes:  1) prescriptions processed by a VA pharmacy in the last 15 months, and 2) all
                        medications recorded in the VA medical record as "non-VA medications". Pharmacy terms refer to VA pharmacy's
                        work on prescriptions.  VA patients are advised to take their medications as instructed by their health care
                        team. The data comes from all VA treatment facilities.
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
                    <table >
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
                              <content ID="{concat('mndSig', position())}">
                                <xsl:value-of select="Extension/Sig/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndQuantity', position())}">
                                <xsl:value-of select="OrderQuantity/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('mndExpires', position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="Extension/Expires/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                                </xsl:call-template>
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
                              <content ID="{concat('mndLastDispensed', position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="Extension/LastFilled/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
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
                  <xsl:comment> CCD Medication Activity Entry </xsl:comment>
                  <xsl:for-each select="Medications/Medication">
                    <xsl:sort select="(DrugProduct/Description | OrderItem[not(preceding-sibling::DrugProduct/Description) and not(following-sibling::DrugProduct/Description)]/Description)" />
                    <xsl:sort select="PharmacyStatus" />
                    <xsl:choose>
                      <xsl:when test="OrderCategory/Code/text() = 'O RX' or OrderCategory/Code/text() = 'O'">
                        <entry typeCode="DRIV">
                          <substanceAdministration classCode="SBADM" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.16" />
                            <id nullFlavor="NA" />
                            <xsl:comment> 8.12 DELIVERY METHOD, Optional, No value set defined, Not provided by VA b/c data from VA VistA RPCs not yet available </xsl:comment>
                            <xsl:comment> 8.01 FREE TEXT SIG REFERENCE, Optional </xsl:comment>
                            <text>
                              <reference value="{concat('#mndSig',position())}" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime xsi:type="IVL_TS">
                              <low nullFlavor="UNK" />
                            </effectiveTime>
                            <xsl:comment>8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>8.03 ADMINISTRATION TIMING (xsi:type='EIVL' operator='A'), Optional,Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment>8.04 FREQUENCY (xsi:type='PIVL_TS institutionSpecified='false'operator='A''), Optional, Not provided by VA b/c data not yet available viaVA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.05 INTERVAL ( xsi:type='PIVL_TS' institutionSpecified='false' operator='A'), Optional,Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.06 DURATION ( xsi:type='PIVL_TS' operator='A'), Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>8.08 DOSE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <consumable>
                              <manufacturedProduct classCode="MANU">
                                <templateId root="2.16.840.1.113883.10.20.22.4.23" />
                                <manufacturedMaterial>
                                  <xsl:comment> 8.13 CODED PRODUCT NAME, REQUIRED, UNII, RxNorm, NDF-RT, NDC, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                  <xsl:choose>
                                    <xsl:when test="boolean(DrugProduct/Code)">
                                      <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" code="{DrugProduct/Code/text()}" displayName="{DrugProduct/Description/text()}" >
                                        <xsl:comment> 8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                        <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                        <originalText>
                                          <reference value="{concat('#mndMedication', position())}" />
                                        </originalText>
                                        <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" code="{DrugProduct/Generic/Code/text()}" displayName="{DrugProduct/Generic/Description/text()}" />
                                      </code>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" nullFlavor="UNK" >
                                        <xsl:comment> 8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs  </xsl:comment>
                                        <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                        <originalText>
                                          <reference value="{concat('#mndMedication', position())}" />
                                        </originalText>
                                      </code>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:comment> 8.16 FREE TEXT BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                </manufacturedMaterial>
                              </manufacturedProduct>
                            </consumable>
                            <xsl:comment> Information Source for Medication Entry, Optional </xsl:comment>
                            <author>
                              <time nullFlavor="UNK" />
                              <assignedAuthor>
                                <id nullFlavor="NI" />
                                <representedOrganization>
                                  <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description" />
                                  </name>
                                </representedOrganization>
                              </assignedAuthor>
                            </author>

                            <xsl:comment> 8.20-STATUS OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <xsl:comment>To Identify Status </xsl:comment>
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.47" />
                                <code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                                <value xsi:type="CE">
                                  <!-- TODO Vets Translation of status-->
                                  <originalText>
                                    <xsl:value-of select="PharmacyStatus" />
                                  </originalText>
                                </value>
                              </observation>
                            </entryRelationship>

                            <xsl:comment> CCD Patient Instructions Entry, Optional </xsl:comment>
                            <entryRelationship typeCode="SUBJ">
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.3.88.11.32.10" />
                                <xsl:comment> VLER SEG 1B: 8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                  <originalText>
                                    <xsl:value-of select="OrderCategory/OriginalText"/>
                                  </originalText>
                                </code>
                                <!-- TODO Vets Sno Code -->
                              </observation>
                            </entryRelationship>

                            <xsl:comment>CCD Drug Vehicle Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.24 VEHICLE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment>CCD Indication Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.21 INDICATION VALUE, Optional, SNOMED CT, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> CCD Medication Supply Order Entry, REQUIRED </xsl:comment>
                            <xsl:comment> CCD Medication Supply Order Entry, REQUIRED </xsl:comment>
                            <entryRelationship typeCode='REFR'>
                              <supply classCode="SPLY" moodCode="INT">
                                <templateId root="2.16.840.1.113883.10.20.22.4.17" extension="2014-06-09"/>
                                <xsl:comment> VLER SEG 1B: 8.26 ORDER NUMBER, Optional-R2 </xsl:comment>
                                <id extension="{PlacerId/text()}" root="2.16.840.1.113883.4.349" />
                                <statusCode code="completed" />
                                <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                                <effectiveTime xsi:type="IVL_TS">
                                  <low nullFlavor="UNK" />
                                  <high value="{translate(Extension/Expires/text(),'TZ:- ','')}"/>
                                </effectiveTime>
                                <xsl:comment> VLER SEG 1B: 8.27 FILLS, Optional </xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(NumberOfRefills)">
                                    <repeatNumber value="{NumberOfRefills/text()}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <repeatNumber nullFlavor="UNK" />
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:comment> 8.28 QUANTITY ORDERED, R2, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
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
                                  <xsl:comment> 8.30 ORDER DATE/TIME, Optional </xsl:comment>
                                  <time value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                                  <assignedAuthor>
                                    <id nullFlavor="NI" />
                                    <assignedPerson>
                                      <xsl:comment> 8.31 ORDERING PROVIDER, Optional </xsl:comment>
                                      <name>
                                        <xsl:value-of select="OrderedBy/Description/text()" />
                                      </name>
                                    </assignedPerson>
                                  </assignedAuthor>
                                </author>
                              </supply>
                            </entryRelationship>

                            <xsl:comment> FULFILLMENT Instructions </xsl:comment>
                            <entryRelationship inversionInd="true" typeCode='SUBJ'>
                              <act classCode="ACT" moodCode="INT">
                                <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                                <code code="171044003" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Immunization Education"/>
                                <text>
                                  <!-- TODO ask about Sno Code and translation -->
                                  <reference value="{concat('#mndSig', position())}" />
                                </text>
                                <statusCode code="completed" />
                              </act>
                            </entryRelationship>
                            <xsl:comment>FULFILLMENT HISTORY INFORMATION </xsl:comment>
                            <xsl:comment> CCD Medication Dispense Entry, Optional </xsl:comment>
                            <entryRelationship typeCode='REFR'>
                              <supply classCode="SPLY" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.22.4.18" />
                                <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                                <id extension="{PrescriptionNumber/text()}" root="2.16.840.1.113883.4.349"/>
                                <statusCode nullFlavor="UNK" />
                                <xsl:if test="boolean(Extension/LastFilled)">
                                  <effectiveTime value="{translate(Extension/LastFilled/text(),'TZ:- ','')}"/>
                                </xsl:if>
                              </supply>
                            </entryRelationship>
                            <xsl:comment>8.23 REACTION OBSERVATION Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>CCD PRECONDITION FOR SUBSTANCE ADMINISTRATION ENTRY, Optional,Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>8.25 DOSE INDICATOR, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                          </substanceAdministration>
                        </entry>
                      </xsl:when>
                      <xsl:otherwise>
                        <entry typeCode="DRIV">
                          <substanceAdministration classCode="SBADM" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.16" />
                            <id nullFlavor="NA" />
                            <xsl:comment> 8.12 DELIVERY METHOD, Optional, No value set defined, Not provided by VA b/c data from VA VistA RPCs not yet available </xsl:comment>
                            <xsl:comment> 8.01 FREE TEXT SIG REFERENCE, Optional </xsl:comment>
                            <text>
                              <reference value="{concat('#mndSig',position())}" />
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime xsi:type="IVL_TS">
                              <low nullFlavor="UNK" />
                            </effectiveTime>
                            <xsl:comment>8.02 INDICATE MEDICATION STOPPPED, Optional, Removed b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>8.03 ADMINISTRATION TIMING (xsi:type='EIVL' operator='A'), Optional,Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment>8.04 FREQUENCY (xsi:type='PIVL_TS institutionSpecified='false'operator='A''), Optional, Not provided by VA b/c data not yet available viaVA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.05 INTERVAL ( xsi:type='PIVL_TS' institutionSpecified='false' operator='A'), Optional,Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.06 DURATION ( xsi:type='PIVL_TS' operator='A'), Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment>8.08 DOSE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <consumable>
                              <manufacturedProduct classCode="MANU">
                                <templateId root="2.16.840.1.113883.10.20.22.4.23"  />
                                <manufacturedMaterial>
                                  <xsl:comment>8.13 CODED PRODUCT NAME, REQUIRED, UNII, RxNorm, NDF-RT, NDC, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                                  <xsl:choose>
                                    <xsl:when test="boolean(DrugProduct/Code)">
                                      <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" code="{DrugProduct/Code/text()}" displayName="{DrugProduct/Description/text()}" >
                                        <xsl:comment> 8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                        <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                        <originalText>
                                          <reference value="{concat('#mndMedication', position())}" />
                                        </originalText>
                                        <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" code="{DrugProduct/Generic/Code/text()}" displayName="{DrugProduct/Generic/Description/text()}" />
                                      </code>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <code codeSystem="2.16.840.1.113883.3.88.12.80.16" codeSystemName="RxNorm" nullFlavor="UNK" >
                                        <xsl:comment>8.14 CODED BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                                        <xsl:comment> 8.15 FREE TEXT PRODUCT NAME, REQUIRED </xsl:comment>
                                        <originalText>
                                          <reference value="{concat('#mndMedication', position())}" />
                                        </originalText>
                                      </code>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:comment> 8.16 FREE TEXT BRAND NAME, R2, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                </manufacturedMaterial>
                              </manufacturedProduct>
                            </consumable>
                            <xsl:comment> Information Source for Medication Entry, Optional </xsl:comment>
                            <author>
                              <time nullFlavor="UNK" />
                              <assignedAuthor>
                                <id nullFlavor="NI" />
                                <representedOrganization>
                                  <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description" />
                                  </name>
                                </representedOrganization>
                              </assignedAuthor>
                            </author>

                            <xsl:comment> 8.20-STATUS OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                            <entryRelationship typeCode="REFR">
                              <xsl:comment>To Identify Status </xsl:comment>
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.1.47" />
                                <code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
                                <value xsi:type="CE">
                                  <!-- TODO Vets Translation of status-->
                                  <originalText>
                                    <xsl:value-of select="PharmacyStatus" />
                                  </originalText>
                                </value>
                              </observation>
                            </entryRelationship>

                            <xsl:comment> CCD Patient Instructions Entry, Optional </xsl:comment>
                            <entryRelationship typeCode="SUBJ">
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.3.88.11.32.10" />
                                <xsl:comment> VLER SEG 1B: 8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                                <code codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                                  <originalText>
                                    <xsl:value-of select="OrderCategory/OriginalText"/>
                                  </originalText>
                                </code>
                                <!-- TODO Vets Sno Code -->
                              </observation>
                            </entryRelationship>

                            <xsl:comment>CCD Drug Vehicle Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.24 VEHICLE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment>CCD Indication Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.21 INDICATION VALUE, Optional, SNOMED CT, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <xsl:comment> CCD Medication Supply Order Entry, REQUIRED </xsl:comment>
                            <entryRelationship typeCode='REFR'>
                              <supply classCode="SPLY" moodCode="INT">
                                <templateId root="2.16.840.1.113883.10.20.22.4.17" />
                                <xsl:comment> VLER SEG 1B: 8.26 ORDER NUMBER, Optional-R2 </xsl:comment>
                                <id extension="{PlacerId/text()}" root="2.16.840.1.113883.4.349" />
                                <statusCode code="completed" />
                                <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                                <effectiveTime xsi:type="IVL_TS">
                                  <low nullFlavor="UNK" />
                                  <high nullFlavor="UNK" />
                                </effectiveTime>
                                <xsl:comment> VLER SEG 1B: 8.27 FILLS, Optional </xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(NumberOfRefills)">
                                    <repeatNumber value="{NumberOfRefills/text()}" />
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <repeatNumber nullFlavor="UNK" />
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:comment>8.28 QUANTITY ORDERED, R2, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
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
                                  <xsl:comment> 8.30 ORDER DATE/TIME, Optional </xsl:comment>
                                  <time value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                                  <assignedAuthor>
                                    <id nullFlavor="NI" />
                                    <assignedPerson>
                                      <xsl:comment> 8.31 ORDERING PROVIDER, Optional </xsl:comment>
                                      <name>
                                        <xsl:value-of select="OrderedBy/Description/text()" />
                                      </name>
                                    </assignedPerson>
                                  </assignedAuthor>
                                </author>
                              </supply>
                            </entryRelationship>

                            <xsl:comment> FULFILLMENT Instructions </xsl:comment>

                            <xsl:comment>FULFILLMENT HISTORY INFORMATION </xsl:comment>
                            <xsl:comment> CCD Medication Dispense Entry, Optional </xsl:comment>
                            <entryRelationship typeCode='REFR'>
                              <supply classCode="SPLY" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.22.4.18" />
                                <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                                <id nullFlavor="UNK" />
                                <statusCode nullFlavor="UNK" />
                                <xsl:if test="boolean(Extension/LastFilled)">
                                  <effectiveTime value="{translate(Extension/LastFilled/text(),'TZ:- ','')}"/>
                                </xsl:if>
                              </supply>
                            </entryRelationship>
                            <xsl:comment>8.23 REACTION OBSERVATION Entry, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> CCD PRECONDITION FOR SUBSTANCE ADMINISTRATION ENTRY, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs</xsl:comment>
                            <xsl:comment> 8.25 DOSE INDICATOR, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                          </substanceAdministration>
                        </entry>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment> Immunizations section </xsl:comment>
          <component>
            <xsl:comment> ******************************************************** IMMUNIZATIONS SECTION, Optional ******************************************************** </xsl:comment>
            <!-- 
              TODO 
              If same CVX and admin date, most recent by time
              Omit "Unspecified Formulation" 
                -->
            <xsl:choose>
              <xsl:when test="not(boolean(Vaccinations/Vaccination))">
                <section>
                  <xsl:comment> CCD Immunization Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.2.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.2" />
                  <code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Immunizations"/>
                  <title>Immunizations</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Immunization Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.2.1"  />
                  <templateId root="2.16.840.1.113883.10.20.22.2.2" />
                  <code code="11369-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Immunizations"/>
                  <title>Immunizations</title>
                  <text>
                    <xsl:comment> VA Immunization Business Rules for Medical Content </xsl:comment>
                    <paragraph>This section includes Immunizations on record with VA for the patient. The data comes from all VA treatment facilities. A reaction to an immunization may also be reported in the Allergy section.</paragraph>
                    <table >
                      <thead>
                        <tr>
                          <th>Immunization</th>
                          <th>Series</th>
                          <th>Date Issued</th>
                          <th>Reaction</th>
                          <th>Comment(s)</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="Vaccinations/Vaccination" >
                          <xsl:sort select="FromTime" order="descending" />
                          <xsl:sort select="OrderItem/Description" />
                          <xsl:variable name="curImmEnc" select="EncounterNumber" />
                          <tr>
                            <td>
                              <content ID="{concat('indImmunization', position())}" >
                                <xsl:value-of select="OrderItem/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('indSeries', position())}">
                                <xsl:value-of select="Administrations/Administration/AdministrationStatus/Description/text()" />
                              </content>
                            </td>
                            <td >
                              <xsl:call-template name="tmpDateTemplate" >
                                <xsl:with-param name="date-time" select="FromTime/text()" />
                                <xsl:with-param name="pattern" select="'MMM dd, yyyy'" />
                              </xsl:call-template>
                            </td>

                            <td>
                              <content ID="{concat('indReaction', position())}">
                                <xsl:value-of select="Extension/Reaction/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('indComments', position())}" >
                                <xsl:choose>
                                  <xsl:when test="Extension/IsContraindicated/text() = 'false' and boolean(Administrations/Administration/AdministrationNotes/Description)">
                                    <xsl:value-of select="Administrations/Administration/AdministrationNotes/Description/text()" />
                                  </xsl:when>
                                  <xsl:when test="Extension/IsContraindicated/text() = 'true' and boolean(Administrations/Administration/AdministrationNotes/Description)">
                                    <xsl:value-of select="Administrations/Administration/AdministrationNotes/Description/text()" /><br /><br />
                                    CONTRAINDICATION=DO NOT REPEAT THIS VACCINE
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="Comments/text()" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </content>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:for-each select="Vaccinations/Vaccination" >
                    <xsl:sort select="FromTime" order="descending" />
                    <xsl:sort select="OrderItem/Description" />
                    <xsl:variable name="curImmEnc" select="EncounterNumber" />
                    <entry typeCode='DRIV'>
                      <xsl:comment> CCD Immunization Activity Entry, REQUIRED </xsl:comment>
                      <xsl:comment> 13.01 IMMUNIZATION REFUSAL (negation ind="true"), REQUIRED </xsl:comment>
                      <substanceAdministration classCode="SBADM" moodCode="EVN" negationInd="false">
                        <templateId root="2.16.840.1.113883.10.20.22.4.52" />
                        <id nullFlavor="NA" />
                        <text>
                          <reference value="{concat('#indComments', position())}" />
                        </text>
                        <statusCode code="completed" />
                        <effectiveTime value="{translate(FromTime/text(), 'TZ:- ', '')}" />
                        <xsl:comment> Immunization Medication Series Nbr </xsl:comment>
                        <xsl:choose>
                          <xsl:when test="boolean(Administrations/Administration/AdministrationStatus/Description)">
                            <repeatNumber value="{Administrations/Administration/AdministrationStatus/Description/text()}"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <repeatNumber nullFlavor="NI" />
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="boolean(Route/Code)">
                            <routeCode code="{Route/Code/text()}" displayName="{Route/Description/text()}" codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="FDA Route of Administration">
                              <originalText>
                                <xsl:value-of select="Route/OriginalText"/>
                              </originalText>
                            </routeCode>
                          </xsl:when>
                          <xsl:otherwise>
                            <routeCode codeSystem="2.16.840.1.113883.3.26.1.1" codeSystemName="FDA Route of Administration" nullFlavor="UNK">
                              <originalText>
                                <xsl:value-of select="Route/OriginalText"/>
                              </originalText>
                            </routeCode>
                          </xsl:otherwise>
                        </xsl:choose>
                        <approachSiteCode nullFlavor="UNK">
                          <xsl:if test="boolean(Administrations/Administration/AdministrationSite)">
                            <originalText>
                              <xsl:value-of select="Administrations/Administration/AdministrationSite/Description/text()"/>
                            </originalText>
                          </xsl:if>
                        </approachSiteCode>
                        <consumable>
                          <manufacturedProduct classCode="MANU">
                            <templateId root="2.16.840.1.113883.10.20.22.4.54" />
                            <manufacturedMaterial>
                              <xsl:comment> 13.06 CODED IMMUNIZATION PRODUCT NAME </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(OrderItem/Code)">
                                  <code code="{OrderItem/Code/text()}" displayName="{OrderItem/Description/text()}" codeSystemName="Vaccine Administered (CVX code)" codeSystem="2.16.840.1.113883.6.59">
                                    <originalText>
                                      <reference value="{concat('#indImmunization', position())}"/>
                                    </originalText>
                                  </code>
                                </xsl:when>
                                <xsl:otherwise>
                                  <code codeSystemName="Vaccine Administered (CVX code)" codeSystem="2.16.840.1.113883.6.59" nullFlavor="UNK">
                                    <originalText>
                                      <reference value="{concat('#indImmunization', position())}"/>
                                    </originalText>
                                    <translation code="{Extension/CPT/Code/text()}" displayName="{Extension/CPT/Description/text()}" codeSystem='2.16.840.1.113883.6.12' codeSystemName='Current Procedural Terminology (CPT) Fourth Edition (CPT-4)' />
                                  </code>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:choose>
                                <xsl:when test="boolean(Administrations/Administration/LotNumber)">
                                  <lotNumberText>
                                    <xsl:value-of select="Administrations/Administration/LotNumber" />
                                  </lotNumberText>
                                </xsl:when>
                                <xsl:otherwise>
                                  <lotNumberText nullFlavor="UNK"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </manufacturedMaterial>
                            <manufacturerOrganization>
                              <xsl:choose>
                                <xsl:when test="boolean(Administrations/Administration/Manufacturer)">
                                  <name>
                                    <xsl:value-of select="Administrations/Administration/Manufacturer" />
                                  </name>
                                </xsl:when>
                                <xsl:otherwise>
                                  <name nullFlavor="UNK" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </manufacturerOrganization>
                          </manufacturedProduct>
                        </consumable>
                        <performer>
                          <xsl:choose>
                            <xsl:when test="boolean(Administrations/Administration/AdministeringProvider)">
                              <assignedEntity>
                                <xsl:comment> CCD Provider ID, extension = VA Provider ID, root=VA OID, REQUIRED </xsl:comment>
                                <id extension="{Administrations/Administration/AdministeringProvider/Code/text()}" root="2.16.840.1.113883.4.349" />
                                <assignedPerson>
                                  <xsl:comment> CCD Provider Name, REQUIRED </xsl:comment>
                                  <name>
                                    <xsl:value-of select="Administrations/Administration/AdministeringProvider/Description" />
                                  </name>
                                </assignedPerson>
                              </assignedEntity>
                            </xsl:when>
                            <xsl:otherwise>
                              <assignedEntity>
                                <xsl:comment> CCD Provider ID, extension = VA Provider ID, root=VA OID, REQUIRED </xsl:comment>
                                <id nullFlavor="UNK" />
                                <assignedPerson>
                                  <xsl:comment> CCD Provider Name, REQUIRED </xsl:comment>
                                  <name nullFlavor="UNK" />
                                </assignedPerson>
                              </assignedEntity>
                            </xsl:otherwise>
                          </xsl:choose>
                        </performer>
                        <xsl:comment> INFORMATION SOURCE FOR IMMUNIZATION, Optional </xsl:comment>
                        <author>
                          <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <xsl:choose>
                              <xsl:when test="boolean(EnteredAt)">
                                <representedOrganization>
                                  <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                                  <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                  <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                  <name>
                                    <xsl:value-of select="EnteredAt/Description" />
                                  </name>
                                </representedOrganization>
                              </xsl:when>
                              <xsl:otherwise>
                                <representedOrganization>
                                  <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                                  <id nullFlavor="UNK" />
                                  <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                  <name nullFlavor="UNK" />
                                </representedOrganization>
                              </xsl:otherwise>
                            </xsl:choose>
                          </assignedAuthor>
                        </author>
                        <xsl:comment> IMMUNIZATION REACTION </xsl:comment>
                        <entryRelationship typeCode="CAUS" inversionInd="true">
                          <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.9" extension="2014-06-09" />
                            <id nullFlavor="NA" />
                            <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" />
                            <text>
                              <reference value="{concat('#indReaction', position())}"/>
                            </text>
                            <statusCode code="completed" />
                            <effectiveTime>
                              <low nullFlavor="UNK"/>
                            </effectiveTime>
                            <value nullFlavor="UNK" xsi:type="CD"/>
                          </observation>
                        </entryRelationship>
                        <xsl:comment> 13.10 REFUSAL REASON ENTRY, Optional, VA provides administered immunizations only </xsl:comment>
                      </substanceAdministration>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <xsl:comment> Procedures section </xsl:comment>
          <component>
            <xsl:comment>******************************************************** PROCEDURES SECTION ********************************************************
            </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(Procedures/Procedure))">
                <section nullFlavor="NI">
                  <xsl:comment> CCD Procedures Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.7.1" extension="2014-06-09"/>
                  <code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of procedures" />
                  <title>Procedures</title>
                  <xsl:comment> PROCEDURE NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Procedures Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.7.1" extension="2014-06-09"/>
                  <code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of procedures" />
                  <title>Procedures</title>
                  <xsl:comment> PROCEDURE NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment> VA Procedure Business Rules for Medical Content </xsl:comment>
                    <paragraph>This section contains a list of Surgical Procedures performed at the VA for the patient and a list of Surgical Procedure Notes and Clinical Procedure Notes on record at the VA for the patient.</paragraph>
                    <xsl:if test="boolean(Procedures/Procedure)">
                      <paragraph>
                        <content styleCode="Bold">Surgical Procedures</content>
                      </paragraph>

                      <paragraph >The list of Surgical Procedures shows all procedure dates within the requested date range. If no date range was provided, the list of Surgical Procedures shows the 5 most recent procedure dates within the last 18 months. The data comes from all VA treatment facilities.</paragraph>

                      <table>
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
                          <xsl:for-each select="Procedures/Procedure">
                            <xsl:sort select="ProcedureTime" order="descending" />
                            <xsl:variable name="pid" select="position()" />
                            <xsl:if test="position() &lt; 6">
                              <tr>
                                <td>
                                  <content ID="{concat('prndDateTime', position())}"  >
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="ProcedureTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('prndDescription', position())}"  >
                                    <xsl:value-of select="Procedure/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <!-- TODO: where is this for real? -->
                                  <content ID="{concat('prndProcedureType', position())}"  >
                                    <xsl:value-of select="Procedure/OriginalText/text()" />
                                  </content>
                                </td>
                                <td>
                                  <xsl:if test="boolean(Extension/CPTModifiers/Modifier)">
                                    <list>
                                      <!-- TODO where is this, for real? -->
                                      <xsl:for-each select="Extension/CPTModifiers/Modifier">
                                        <item>
                                          <content ID="{concat('prndQualifiers', $pid, '-', position())}"  >
                                            <xsl:value-of select="Description/text()" />
                                          </content>
                                        </item>
                                      </xsl:for-each>
                                    </list>
                                  </xsl:if>
                                </td>
                                <td>
                                  <content ID="{concat('prndProvider', position())}"  >
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('prndSource', position())}"  >
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                      <!-- Surgical notes begin -->
                      <br/>
                    </xsl:if>
                    <xsl:if test="boolean(Procedures/Procedure/Extension/DocumentNumbers/DocumentNumbersItem)">
                      <content styleCode="Bold">Surgical Procedure Notes</content>
                      <paragraph>This section contains the 5 most recent Surgical Procedure Notes associated to each Procedure. Data comes from all VA treatment facilities.</paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Surgical Procedure Note</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Procedures/Procedure">
                            <xsl:sort select="ProcedureTime" order="descending" />
                            <xsl:variable name="pid" select="position()" />
                            <xsl:if test="position() &lt; 6">
                              <xsl:for-each select="Extension/DocumentNumbers/DocumentNumbersItem" >
                                <xsl:variable name="pdoc" select="text()" />
                                <xsl:variable name="docs" select="../../../../../Documents/Document[DocumentNumber=$pdoc]"/>
                                <xsl:if test="position() &lt; 6">
                                  <tr>
                                    <td>
                                      <content ID="{concat('surgicalNoteDateTime', $pid, '-', position())}" >
                                        <xsl:call-template name="tmpDateTemplate" >
                                          <xsl:with-param name="date-time" select="$docs/DocumentTime/text()" />
                                          <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                        </xsl:call-template>
                                      </content>
                                    </td>
                                    <td>
                                      <content ID="{concat('surgicalNoteEncounterDescription', $pid, '-', position())}"  >
                                        <xsl:call-template name="standard-insertBreaks">
                                          <xsl:with-param name="pText" select="$docs/NoteText/text()" />
                                        </xsl:call-template>
                                      </content>
                                    </td>
                                    <td>
                                      <content ID="{concat('surgicalNoteProvider', $pid, '-', position())}"  >
                                        <xsl:value-of select="$docs/Clinician/Description/text()" />
                                      </content>
                                    </td>
                                    <td>
                                      <content ID="{concat('surgicalNoteSource', $pid, '-', position())}"  >
                                        <xsl:value-of select="$docs/EnteredAt/Description/text()" />
                                      </content>
                                    </td>
                                  </tr>
                                </xsl:if>
                              </xsl:for-each>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>

                      <!-- Surgical End -->
                      <br/>
                    </xsl:if>
                    <xsl:if test="boolean(Documents/Document[DocumentType/Code/text() = 'CP' and not(Extension/NationalTitle/Code/text() = 217)])">
                      <!-- Consult notes begin -->
                      <content styleCode="Bold">Clinical Procedure Notes</content>

                      <paragraph>This section contains all Clinical Procedure Notes, with complete text, that have procedure dates within the requested date range. If no date range was provided, the section contains the 10 most recent Clinical Procedure Notes, with complete text, that have procedure dates within the last 18 months. The data comes from all VA treatment facilities.</paragraph>

                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Clinical Procedure Note with Text</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CP' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &lt; 11">
                              <tr>
                                <td>
                                  <content ID="{concat('cpnoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteEncounterDescription',position())}">
                                    <xsl:call-template name="standard-insertBreaks">
                                      <xsl:with-param name="pText" select="NoteText/text()"/>
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                      <br/>
                    </xsl:if>
                    <xsl:if test="count(Documents/Document[DocumentType/Code/text() = 'CP' and not(Extension/NationalTitle/Code/text() = 217)]) &gt; 10">
                      <!-- clinical notes with titles -->
                    <xsl:comment> Additional Clinical Procedure Notes </xsl:comment>
                    
                      <paragraph styleCode="Bold">Additional Clinical Procedure Notes</paragraph>
                      <paragraph>
                        The list of ADDITIONAL Clinical Procedure Note TITLES includes all notes signed within the last 18 months. The data comes from all VA treatment facilities.
                      </paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Clinical Procedure Note Title</th>
                            <th>Provider</th>
                            <th>Source</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CP' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &gt; 10">
                              <tr>
                                <td>
                                  <content ID="{concat('cpnoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteEncounterDescription',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('cpnoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <xsl:comment> Surgical End </xsl:comment>
                  </text>
                  <xsl:comment> PROCEDURE STRUCTURED </xsl:comment>
                  <xsl:for-each select="Procedures/Procedure">
                    <xsl:sort select="ProcedureTime" order="descending" />
                    <xsl:variable name="pid" select="position()" />
                    <entry typeCode="DRIV">
                      <procedure classCode="PROC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.14" extension="2014-06-09"/>
                        <id nullFlavor="NI" />
                        <xsl:comment> 17.02-PROCEDURE TYPE, REQUIRED, LOINC, SNOMED CT or CPT, 4 </xsl:comment>
                        <xsl:choose>
                          <xsl:when test="boolean(Procedure/Code)">
                            <code code="{Procedure/Code/text()}" displayName="{Procedure/Description/text()}" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                              <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                              <originalText>
                                <reference value="{concat('#prndDescription', position())}"/>
                              </originalText>
                            </code>
                          </xsl:when>
                          <xsl:otherwise>
                            <code nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                              <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                              <originalText>
                                <reference value="{concat('#prndDescription', position())}"/>
                              </originalText>
                            </code>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="boolean(Extension/CptModifiers/CptModifier/Code)">
                          <qualifier>
                            <name>Other Procedure CPT Code</name>
                            <value code="{Extension/CptModifiers/CptModifier/Code/text()}" displayName="{Extension/CptModifiers/CptModifier/Description/text()}" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4"/>
                          </qualifier>
                        </xsl:if>
                        <statusCode code="completed" />
                        <effectiveTime value="{translate(ProcedureTime/text(), 'TZ:- ','')}"/>
                        <performer>
                          <assignedEntity>
                            <id nullFlavor="NA" />
                            <addr nullFlavor="NA" />
                            <telecom nullFlavor="NA" />
                            <assignedPerson>
                              <name>
                                <xsl:value-of select="Clinician/Description/text()"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <xsl:comment> INFORMATION SOURCE FOR PROCEDURE ENTRY, Optional </xsl:comment>
                        <author>
                          <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <representedOrganization>
                              <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                      </procedure>
                    </entry>
                  </xsl:for-each>

                  <xsl:for-each select="Procedures/Procedure">
                    <xsl:sort select="ProcedureTime" order="descending" />
                    <xsl:variable name="pid" select="position()" />
                    <xsl:if test="position() &lt; 6">
                      <xsl:for-each select="Extension/DocumentNumbers/DocumentNumbersItem" >
                        <xsl:variable name="pdoc" select="text()" />
                        <xsl:variable name="docs" select="../../../../../Documents/Document[DocumentNumber=$pdoc]"/>
                        <xsl:if test="position() &lt; 6">
                          <entry typeCode="DRIV">
                            <procedure classCode="PROC" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.14" extension="2014-06-09"/>
                              <id nullFlavor="NI" />
                              <xsl:comment> 17.02-PROCEDURE TYPE, REQUIRED, LOINC, SNOMED CT or CPT, 4 </xsl:comment>
                                  <code code="99499" displayName="Unlisted Evaluation and Management Service" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                                    <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                                    <originalText>
                                      <reference value="{concat('#surgicalNoteEncounterDescription', $pid, '-', position())}"/>
                                    </originalText>
                                  <translation code="29752-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Perioperative Records"/>
                                  </code>
                              <statusCode code="completed" />
                              <effectiveTime value="{translate($docs/DocumentTime/text(), 'TZ:- ','')}"/>
                              <performer>
                                <assignedEntity>
                                  <id nullFlavor="NA" />
                                  <addr nullFlavor="NA" />
                                  <telecom nullFlavor="NA" />
                                  <assignedPerson>
                                    <name>
                                      <xsl:value-of select="$docs/Extension/CareProviders/CareProvider[1]/Description/text()"/>
                                    </name>
                                  </assignedPerson>
                                </assignedEntity>
                              </performer>
                              <xsl:comment> INFORMATION SOURCE FOR PROCEDURE ENTRY, Optional </xsl:comment>
                              <author>
                                <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                                <time nullFlavor="NA" />
                                <assignedAuthor>
                                  <id nullFlavor="NA" />
                                  <representedOrganization>
                                    <id extension="{$docs/EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                                    <name>
                                      <xsl:value-of select="$docs/EnteredAt/Description"/>
                                    </name>
                                  </representedOrganization>
                                </assignedAuthor>
                              </author>
                            </procedure>
                          </entry>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>

                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'CP' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <entry typeCode="DRIV">
                      <procedure classCode="PROC" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.14" extension="2014-06-09"/>
                        <id nullFlavor="NI" />
                        <xsl:comment> 17.02-PROCEDURE TYPE, REQUIRED, LOINC, SNOMED CT or CPT, 4 </xsl:comment>
                        <code code="99499" displayName="Unlisted Evaluation and Management Service" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4">
                          <xsl:comment> 17.03 PROCEDURE FREE TEXT TYPE, R2 </xsl:comment>
                          <originalText>
                            <reference value="{concat('#cpnoteEncounterDescription', position())}"/>
                          </originalText>
                          <translation code="28570-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Procedure Note"/>
                        </code>
                        <statusCode code="completed" />
                        <effectiveTime value="{translate(DocumentTime/text(), 'TZ:- ','')}"/>
                        <performer>
                          <assignedEntity>
                            <id nullFlavor="NA" />
                            <addr nullFlavor="NA" />
                            <telecom nullFlavor="NA" />
                            <assignedPerson>
                              <name>
                                <xsl:value-of select="Extension/CareProviders/CareProvider[1]/Description/text()"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <xsl:comment> INFORMATION SOURCE FOR PROCEDURE ENTRY, Optional </xsl:comment>
                        <author>
                          <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NA" />
                            <representedOrganization>
                              <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                              <name>
                                <xsl:value-of select="EnteredAt/Description"/>
                              </name>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                      </procedure>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
<xsl:comment> ******************************************************** PLAN OF CARE SECTION, Optional ******************************************************** </xsl:comment>
            <xsl:variable name="planOfCare" select="Appointments/Appointment[isc:evaluate('dateDiff','mm',translate(FromTime/text(), 'TZ', ' ')) &lt; 1] | LabOrders/LabOrder[isc:evaluate('dateDiff','mm',translate(FromTime/text(), 'TZ', ' ')) &lt; 1] | OtherOrders/OtherOrder[isc:evaluate('dateDiff','mm',translate(FromTime/text(), 'TZ', ' ')) &lt; 1] | RadOrders/RadOrder[isc:evaluate('dateDiff','mm',translate(FromTime/text(), 'TZ', ' ')) &lt; 1]" />
            <xsl:choose>
              <xsl:when test="not(boolean($planOfCare))">
                <section nullFlavor="NI">
                  <xsl:comment> CCD Plan of Care Section Entries </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.10" />
                  <code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Plan of care note" />
                  <title>Plan of Care</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Plan of Care Section Entries </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.10" />
                  <code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Plan of care note" />
                  <title>Plan of Care</title>
                  <text>
                    <xsl:if test="not(count($planOfCare[self::Appointment]) = 0)">
                      <paragraph>
                        <content styleCode="Bold">Future Appointments</content>
                      </paragraph>
                      <paragraph>
                        This section includes up to a maximum of 20 appointments scheduled over the next 6 months. Some types of appointments may not be included. Contact the VA health care team if there are questions.
                      </paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Appointment Date/Time</th>
                            <th>Appointment Type</th>
                            <th>Appointment Facility Name</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="$planOfCare[self::Appointment]">
                            <xsl:sort select="FromTime" order="ascending" />
                            <tr>
                              <td>
                                <content ID="{concat('apptDateTime',position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="FromTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('apptType',position())}" >
                                  <xsl:choose >
                                    <xsl:when test="boolean(Extension/Specialty)">
                                      <xsl:value-of select="Extension/PatientStatus/text()"/> + <xsl:value-of select="Extension/Specialty/text()"/>
                                    </xsl:when>
                                    <xsl:when test="not(boolean(Extension/Specialty))">
                                      <xsl:value-of select="Extension/PatientStatus/text()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      Unknown
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('apptFacility',position())}" >
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <xsl:if test="not(count($planOfCare[not(self::Appointment)]) = 0)">
                      <paragraph>
                        <content styleCode="Bold">Active, Pending, and Scheduled Orders</content>
                      </paragraph>
                      <paragraph>
                        This section includes a listing of several types of active, pending, and scheduled orders, including clinic medication orders, diagnostic test orders, procedure orders, and consult orders; where the start date of the order is 45 days before or after the date this document was created.
                      </paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Test Date/Time</th>
                            <th>Test Type</th>
                            <th>Test Details</th>
                            <th>Facility Name</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="$planOfCare[not(self::Appointment)]">
                            <xsl:sort select="FromTime" order="ascending" />
                            <tr>
                              <td>
                                <content ID="{concat('orderDateTime',position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="FromTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('contentType',position())}">
                                  <xsl:call-template name="standard-FutureOrderTypeCode">
                                    <xsl:with-param name="doc" select="." />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('orderDetails',position())}">
                                  <xsl:value-of select="Extension/Content/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('orderFacilityName',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                  </text>
                  <xsl:comment> PLAN OF CARE (POC) STRUCTURED DATA </xsl:comment>
                  <xsl:comment> CCD Plan of Care (POC) Activity Encounter (Future VA Appointments,  Future Scheduled Tests, Wellness Reminders), Optional </xsl:comment>
                  <xsl:for-each select="$planOfCare[self::Appointment]">
                    <entry>
                      <encounter classCode="ENC" moodCode="INT">
                        <templateId root="2.16.840.1.113883.10.20.22.4.40" extension="2014-06-09"/>
                        <!-- <id root="2.16.840.1.113883.4.349" /> -->
                        <id nullFlavor="UNK"/>
                        <code nullFlavor="UNK">
                          <originalText>
                            <reference value="{concat('#apptType',position())}"/>
                          </originalText>
                        </code>
                        <statusCode code="active"/>
                        <effectiveTime value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                        <participant typeCode="LOC">
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="UNK"/>
                            <addr nullFlavor="UNK" />
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name><xsl:value-of select="EnteredBy/Description/text()"/></name>
                            </playingEntity>
                          </participantRole>
                        </participant>
                        <entryRelationship inversionInd="true" typeCode='SUBJ'>
                          <act classCode="ACT" moodCode="INT">
                            <templateId root="2.16.840.1.113883.10.20.22.4.20" extension="2014-06-09" />
                            <code xsi:type="CE" code="409073007" codeSystem="2.16.840.1.113883.6.96" displayName="Instruction" codeSystemName="SNOMED CT" />
                            <text>
                              <reference value="{concat('#apptType',position())}"/>
                            </text>
                            <statusCode code="completed" />
                          </act>
                        </entryRelationship>
                      </encounter>
                    </entry>
                  </xsl:for-each>
                  <xsl:for-each select="$planOfCare[not(self::Appointment)]">
                    <entry>
                      <encounter classCode="ENC" moodCode="INT">
                        <templateId root="2.16.840.1.113883.10.20.22.4.40" />
                        <!-- <id root="2.16.840.1.113883.4.349" /> -->
                        <id nullFlavor="UNK"/>
                        <code nullFlavor="UNK">
                          <originalText>
                            <reference value="{concat('#contentType',position())}"/>
                          </originalText>
                        </code>
                        <statusCode code="active"/>
                        <effectiveTime value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                        <participant typeCode="LOC">
                          <participantRole classCode="SDLOC">
                            <templateId root="2.16.840.1.113883.10.20.22.4.32"/>
                            <code nullFlavor="UNK"/>
                            <addr nullFlavor="UNK" />
                            <telecom nullFlavor="UNK"/>
                            <playingEntity classCode="PLC">
                              <name><xsl:value-of select="EnteredBy/Description/text()"/></name>
                            </playingEntity>
                          </participantRole>
                        </participant>
                        <entryRelationship inversionInd="true" typeCode='SUBJ'>
                          <act classCode="ACT" moodCode="INT">
                            <templateId root="2.16.840.1.113883.10.20.22.4.20" />
                            <code xsi:type="CE" code="409073007" codeSystem="2.16.840.1.113883.6.96" displayName="Instruction" codeSystemName="SNOMED CT" />
                            <text>
                              <reference value="{concat('#contentType',position())}"/>
                            </text>
                            <statusCode code="completed" />
                          </act>
                        </entryRelationship>
                      </encounter>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
            <xsl:comment> ******************************************************** PROBLEM/CONDITION SECTION, REQUIRED ******************************************************** </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(Problems/Problem[not(Problem/Code/text() = '408907016')]))">
                <section nullFlavor="NI">
                  <xsl:comment> C-CDA Problem Section Template. Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>
                  <templateId root="2.16.840.1.113883.10.20.22.2.5" />
                  <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem List" />
                  <title>Problems/Conditions</title>
                  <xsl:comment> PROBLEMS NARRATIVE BLOCK </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> C-CDA Problem Section Template. Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.5.1"/>
                  <templateId root="2.16.840.1.113883.10.20.22.2.5" />
                  <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem List" />
                  <title>Problems/Conditions</title>
                  <xsl:comment> PROBLEMS NARRATIVE BLOCK </xsl:comment>
                  <text>
                    <xsl:comment> VA Problem/Condition Business Rules for Medical Content </xsl:comment>
                    <paragraph>
                      This section contains a list of Problems/Conditions known to VA for the patient.
                      It includes both active and inactive problems/conditions. The data comes from all VA treatment facilities.
                    </paragraph>
                    <table>
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
                        <xsl:for-each select="Problems/Problem[not(Problem/Code/text() = '408907016')]">
                          <xsl:sort select="Status/Description" />
                          <xsl:sort select="ProblemDetails" />
                          <xsl:variable name="prid" select="position()" />
                          <tr>
                            <td>
                              <content ID="{concat('pndProblem',position())}">
                                <xsl:value-of select="ProblemDetails/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('pndStatus',position())}">
                                <xsl:value-of select="Status/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('pndProblemCode',position())}">
                                <xsl:value-of select="Problem/Description/text()" />
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('pndDateOfOnset',position())}">
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="FromTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                              </content>
                            </td>
                            <td>
                              <content ID="{concat('pndDateOfResolution',position())}">
                                <xsl:value-of select="ToTime/text()" />
                              </content>
                            </td>
                            <td>
                              <xsl:if test="boolean(Extension/Comments/Comment)">
                                <list>
                                  <xsl:for-each select="Extension/Comments/Comment" >
                                    <item>
                                      <content ID="{concat('pndComment',$prid,'-',position())}">
                                        <xsl:value-of select="CommentText/text()" />
                                      </content>
                                    </item>
                                  </xsl:for-each>
                                </list>
                              </xsl:if>
                            </td>
                            <td>
                              <content ID="{concat('pndProvider',position())}">
                                <xsl:value-of select="Clinician/Description/text()" />
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
                  <xsl:comment> PROBLEMS STRUCTURED DATA </xsl:comment>
                  <xsl:comment> Problem Concern Activty Entry </xsl:comment>
                  <xsl:for-each select="Problems/Problem[not(Problem/Code/text() = '408907016')]">
                    <xsl:sort select="Status/Description" />
                    <xsl:sort select="ProblemDetails" />
                    <xsl:variable name="prid" select="position()" />
                    <entry>
                      <act classCode="ACT" moodCode="EVN">
                        <templateId root="2.16.840.1.113883.10.20.22.4.3" />
                        <id nullFlavor="NA" />
                        <code code="CONC" codeSystem="2.16.840.1.113883.5.6" codeSystemName="HL7ActClass" displayName="Concern" />
                        <statusCode code="active" />
                        <xsl:comment> C-CDA R2.1 PROBLEM CONCERN DATE,  Date Recorded/Entered, Required </xsl:comment>
                        <xsl:comment> 7.01 PROBLEM DATE, R2 </xsl:comment>
                        <xsl:choose>
                          <xsl:when test="boolean(EnteredOn)">
                            <effectiveTime>
                              <xsl:comment> 7.01 PROBLEM DATE, cda:low=Date of Entry </xsl:comment>
                              <low value="{translate(EnteredOn/text(), 'TZ:- ', '')}"/>
                              <xsl:comment> 7.01 PROBLEM DATE, cda:high=Date Resolved </xsl:comment>
                              <high nullFlavor="UNK"/>
                            </effectiveTime>
                          </xsl:when>
                          <xsl:otherwise>
                            <effectiveTime>
                              <xsl:comment> 7.01 PROBLEM DATE, cda:low=Date of Entry </xsl:comment>
                              <low nullFlavor="UNK"/>
                              <xsl:comment> 7.01 PROBLEM DATE, cda:high=Date Resolved </xsl:comment>
                              <high nullFlavor="UNK"/>
                            </effectiveTime>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:comment> TREATING PROVIDER Performer Block, Optional </xsl:comment>
                        <performer>
                          <assignedEntity>
                            <xsl:comment> 7.05 TREATING PROVIDER </xsl:comment>
                            <id nullFlavor="NI" />
                            <assignedPerson>
                              <name>
                                <xsl:value-of select="Clinician/Description/text()"/>
                              </name>
                            </assignedPerson>
                          </assignedEntity>
                        </performer>
                        <xsl:comment> INFORMATION SOURCE FOR PROBLEM, Optional </xsl:comment>
                        <author>
                          <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                          <time nullFlavor="NA" />
                          <assignedAuthor>
                            <id nullFlavor="NI" />
                            <code nullFlavor="NA" />
                            <representedOrganization>
                              <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING FACILITY NBR </xsl:comment>
                              <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                              <xsl:comment> INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                              <name>
                                <xsl:value-of select="EnteredAt/Description/text()"/>
                              </name>
                              <telecom nullFlavor="NA" />
                              <addr nullFlavor="NA" />
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                        <entryRelationship typeCode="SUBJ">
                          <xsl:comment> CCD Problem Observation </xsl:comment>
                          <observation classCode="OBS" moodCode="EVN">
                            <templateId root="2.16.840.1.113883.10.20.22.4.4"/>
                            <id nullFlavor="NI" />
                            <xsl:comment> 7.02 PROBLEM TYPE, REQUIRED, SNOMED CT, provided as nullFlavor  b/c data not yet available via VA VistA RPCs </xsl:comment>
                            <code nullFlavor="NA" />
                            <xsl:comment> 7.03 PROBLEM NAME, R2 </xsl:comment>
                            <text>
                              <reference value="{concat('#pndProblem',position())}" />
                            </text>
                            <statusCode code="completed" />
                            <xsl:comment> 7.01 Problem Observation Date </xsl:comment>
                            <effectiveTime>
                              <xsl:comment> Date of onset </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(FromTime)">
                                  <low value="{translate(FromTime/text(), 'TZ:- ', '')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <low nullFlavor="UNK"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:comment> Date of resolution </xsl:comment>
                              <xsl:choose>
                                <xsl:when test="boolean(ToTime)">
                                  <high value="{translate(ToTime/text(), 'TZ:- ','')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <high nullFlavor="UNK"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </effectiveTime>
                            <xsl:comment> 7.04 PROBLEM CODE, Optional, When uncoded only xsi:type="CD" allowed, Available as ICD-9, not SNOMED CT, </xsl:comment>
                            <!-- TODO see how it comes back from VETS -->
                            <value xsi:type="CD" code="{Problem/Code/text()}" displayName="{Problem/Description/text()}" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                              <originalText>
                                <reference value="{concat('#pndProblem',position())}"/>
                              </originalText>
                              <translation codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM' />
                            </value>
                            <xsl:comment> PROBLEM STATUS entryRelationship block, Optional, </xsl:comment>
                            <entryRelationship typeCode="SUBJ">
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.22.4.6" />
                                <code code="33999-4" codeSystem="2.16.840.1.113883.6.1"  codeSystemName="LOINC" displayName="Status" />
                                <statusCode code="completed" />
                                <xsl:comment> PROBLEM STATUS VALUE, Deprecated R2,1 </xsl:comment>
                                <value xsi:type="CE" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" >
                                  <originalText>
                                    <!-- TODO Sno Mappin'-->
                                    <reference value="{concat('#pndStatus',position())}"/>
                                  </originalText>
                                </value>
                              </observation>
                            </entryRelationship>
                            <xsl:comment> PROBLEM COMMENT (for SSA) entryRelationship block, Optional, </xsl:comment>
                            <xsl:for-each select="Extension/Comments/Comment" >
                              <entryRelationship inversionInd="true" typeCode="SUBJ">
                                <act classCode="ACT" moodCode="EVN">
                                  <templateId root="2.16.840.1.113883.10.20.22.4.64"/>
                                  <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/>
                                  <text>
                                    <reference value="{concat('#pndComment',$prid,'-',position())}"/>
                                  </text>
                                </act>
                              </entryRelationship>
                            </xsl:for-each>
                          </observation>
                        </entryRelationship>
                        <xsl:comment>CCD Problem Age Observation, not provided b/c data not yet available via VA VistA RPCs</xsl:comment>
                        <xsl:comment> CCD Health Status Observation, not provided b/c data not yet available via VA VistA RPCs  </xsl:comment>
                      </act>
                    </entry>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
<xsl:comment> ******************************************************** RESULTS SECTION, REQUIRED ******************************************************** </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]))">
                <section nullFlavor="NI">
                  <xsl:comment> CCD Results Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.3.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.3" />
                  <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data" />
                  <title>Lab Results - Chemistry and Hematology</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Results Section Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.3.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.3" />
                  <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Relevant diagnostic tests and/or laboratory data" />
                  <title>Lab Results - Chemistry and Hematology</title>
                  <text>
                    <xsl:comment> VA Results Business Rules for Medical Content </xsl:comment>
                    <paragraph>
                      This section contains the Chemistry and Hematology Lab Results,
                      Radiology Reports, and Pathology Reports on record with VA for
                      the patient. The data comes from all VA treatment facilities.
                    </paragraph>
                    <xsl:if test="boolean(LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)])">
                      <content styleCode="Bold">Lab Results</content>

                      <paragraph >
                        This section contains all the Chemistry/Hematology Results
                        collected within the requested date range. If no date range was
                        provided, the included Chemistry/Hematology Results are from
                        the last 24 months and are limited to the 10 most recent sets
                        of tests. The data comes from all VA treatment facilities.
                      </paragraph>
                      <table >
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
                        <xsl:for-each select="LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]">
                          <xsl:sort select="FromTime" order="descending" />
                          <xsl:variable name="lid" select="position()" />
                          <xsl:if test="position() &lt; 11">
                            <tbody>
                              <tr>
                                <td >
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="FromTime/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </td>

                                <td>
                                  <content ID="{concat('lndSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                                <td colspan="4">
                                  <content ID="{concat('lndResultType',position())}">
                                    <xsl:value-of select="OrderItem/Description/text()" />
                                  </content>
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
                                      <xsl:value-of select="translate(ResultNormalRange/text(),'\&quot;','')" />
                                    </content>
                                  </td>
                                  <td/>
                                </tr>
                              </xsl:for-each>
                            </tbody>
                          </xsl:if>
                        </xsl:for-each>
                      </table>
                      <br/>
                    </xsl:if>
                    <xsl:if test="boolean(Documents/Document[DocumentType/Code/text() = 'RA' and not(Extension/NationalTitle/Code/text() = 217)])">
                      <content styleCode="Bold">Radiology Reports</content>
                      <paragraph >This section includes all Radiology Reports within the requested date range. If no date range was provided, the included Radiology Reports are the 5 most recent reports within the last 24 months. The data comes from all VA treatment facilities</paragraph>
                      <table>
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Results Type (LOINC)</th>
                            <th>Source</th>
                            <th>Result</th>
                            <th>Provider</th>
                            <th>Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'RA' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &lt; 6">
                              <tr>
                                <td>
                                  <content ID="{concat('ranoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('ranoteLoinc',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('ranoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('ranoteEncounterDescription',position())}">
                                    <xsl:call-template name="standard-insertBreaks">
                                      <xsl:with-param name="pText" select="NoteText/text()"/>
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('ranoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content>completed</content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    <br/>
                    </xsl:if>
                    <xsl:if test="boolean(Documents/Document[DocumentType/Code/text() = 'LR' and not(Extension/NationalTitle/Code/text() = 217)])">
                      <content styleCode="Bold">Pathology Reports</content>
                      <paragraph >This section includes all Pathology Reports within the requested date range. If no date range was provided, the included Pathology Reports are the 5 most recent reports within the last 24 months. The data comes from all VA treatment facilities. </paragraph>
                      <table >
                        <thead>
                          <tr>
                            <th>Date/Time</th>
                            <th>Results Type (LOINC)</th>
                            <th>Source</th>
                            <th>Result</th>
                            <th>Provider</th>
                            <th>Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'LR' and not(Extension/NationalTitle/Code/text() = 217)]">
                            <xsl:sort select="DocumentTime" order="descending" />
                            <xsl:if test="position() &lt; 6">
                              <tr>
                                <td>
                                  <content ID="{concat('panoteDateTime',position())}">
                                    <xsl:call-template name="tmpDateTemplate" >
                                      <xsl:with-param name="date-time" select="DocumentTime/text()" />
                                      <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('panoteLoinc',position())}">
                                    <xsl:value-of select="Extension/NationalTitle/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('panoteSource',position())}">
                                    <xsl:value-of select="EnteredAt/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('panoteEncounterDescription',position())}">
                                    <xsl:call-template name="standard-insertBreaks">
                                      <xsl:with-param name="pText" select="NoteText/text()"/>
                                    </xsl:call-template>
                                  </content>
                                </td>
                                <td>
                                  <content ID="{concat('panoteProvider',position())}">
                                    <xsl:value-of select="Clinician/Description/text()" />
                                  </content>
                                </td>
                                <td>
                                  <content>completed</content>
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                  </text>
                  <xsl:for-each select="LabOrders/LabOrder[not(isc:evaluate('dateDiff','dd',translate(FromTime/text(), 'TZ', ' ')) &lt; 1)]">
                    <xsl:sort select="FromTime" order="descending" />
                    <xsl:variable name="lid" select="position()" />
                    <xsl:if test="position() &lt; 11">
                      <entry typeCode='DRIV'>
                        <xsl:comment> CCD Results Organizer = VA Lab Order Panel , REQUIRED </xsl:comment>
                        <organizer classCode="CLUSTER" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.1" />
                          <id nullFlavor="NI" />
                          <code nullFlavor="UNK">
                            <originalText>
                              <xsl:value-of select="OrderItem/Description" />
                            </originalText>
                          </code>
                          <statusCode code="completed" />
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
                          <author>
                            <time nullFlavor="NA" />
                            <assignedAuthor>
                              <id nullFlavor="NA" />
                              <representedOrganization>
                                <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                <name>
                                  <xsl:value-of select="EnteredAt/Description"/>
                                </name>
                              </representedOrganization>
                            </assignedAuthor>
                          </author>
                          <xsl:for-each select="Result/ResultItems/LabResultItem">
                            <component>
                              <observation classCode="OBS" moodCode="EVN">
                                <templateId root="2.16.840.1.113883.10.20.22.4.2" />
                                <xsl:comment> 15.01 RESULT ID, REQUIRED </xsl:comment>
                                <id root="2.16.840.1.113883.4.349" extension="{ExternalId/text()}" />
                                <xsl:comment> 15.03-RESULT TYPE, REQUIRED </xsl:comment>
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
                                <text >
                                  <reference value="{concat('#labTest',$lid)}"/>
                                </text>
                                <statusCode code="completed" />
                                <xsl:comment> 15.02 RESULT DATE/TIME, REQUIRED </xsl:comment>
                                <effectiveTime value="{translate(ObservationTime/text(), 'TZ:- ','')}"/>
                                <xsl:comment> 15.05 RESULT VALUE, REQUIRED, xsi:type="PQ" </xsl:comment>
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
                                <xsl:comment> 15.06 RESULT INTERPRETATION, R2, </xsl:comment>
                                <interpretationCode nullFlavor="NAV">
                                  <originalText>
                                    <reference value="{concat('#interpLabValues',$lid,'-',position())}"/>
                                  </originalText>
                                </interpretationCode>
                                <xsl:comment> CCD METHOD CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                <xsl:comment> CCD TARGET SITE CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                                <entryRelationship typeCode="SUBJ" inversionInd="true">
                                  <act classCode="ACT" moodCode="EVN">
                                    <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                                    <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                                    <text>
                                      <reference value="{concat('#lndComment',position())}"/>
                                    </text>
                                  </act>
                                </entryRelationship>
                                <xsl:comment> 15.07 RESULT REFERENCE RANGE, R2, </xsl:comment>
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
                                  </xsl:otherwise>
                                </xsl:choose>
                              </observation>
                            </component>
                          </xsl:for-each>
                        </organizer>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>

                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'RA' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <xsl:if test="position() &lt; 6">
                      <entry typeCode='DRIV'>
                        <xsl:comment> CCD Results Organizer = VA Lab Order Panel , REQUIRED </xsl:comment>
                        <organizer classCode="CLUSTER" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.1" />
                          <id nullFlavor="NI" />
                          <code nullFlavor="UNK">
                            <originalText>
                              <xsl:value-of select="DocumentName" />
                            </originalText>
                            <translation code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Studies"/>
                          </code>
                          <statusCode code="completed" />
                          <effectiveTime>
                            <xsl:choose>
                              <xsl:when test="boolean(DocumentTime)">
                                <xsl:attribute name="value">
                                  <xsl:value-of select="translate(DocumentTime/text(),'TZ:- ','')"/>
                                </xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>
                          </effectiveTime>
                          <author>
                            <time nullFlavor="NA" />
                            <assignedAuthor>
                              <id nullFlavor="NA" />
                              <representedOrganization>
                                <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                <name>
                                  <xsl:value-of select="EnteredAt/Description"/>
                                </name>
                              </representedOrganization>
                            </assignedAuthor>
                          </author>
                          <component>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.2" />
                              <xsl:comment> 15.01 RESULT ID, REQUIRED </xsl:comment>
                              <id nullFlavor="UNK" />
                              <xsl:comment> 15.03-RESULT TYPE, REQUIRED </xsl:comment>
                              <code nullFlavor="UNK">
                                <originalText>
                                  <xsl:value-of select="DocumentName" />
                                </originalText>
                                <translation code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Studies"/>
                              </code>
                              <text >
                                <reference nullFlavor="UNK"/>
                              </text>
                              <statusCode code="completed" />
                              <xsl:comment> 15.02 RESULT DATE/TIME, REQUIRED </xsl:comment>
                              <effectiveTime>
                                <xsl:choose>
                                  <xsl:when test="boolean(DocumentTime)">
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="translate(DocumentTime/text(),'TZ:- ','')"/>
                                    </xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </effectiveTime>
                              <xsl:comment> 15.05 RESULT VALUE, REQUIRED, xsi:type="PQ" </xsl:comment>
                              <value xsi:type="ED">
                                <reference value="{concat('#ranoteEncounterDescription',position())}"/>
                              </value>
                              <xsl:comment> CCD METHOD CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                              <xsl:comment> CCD TARGET SITE CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                              <author>
                                <time nullFlavor="NA" />
                                <assignedAuthor>
                                  <id nullFlavor="NA" />
                                  <assignedPerson>
                                    <name>
                                      <xsl:value-of select="Clinician/Description"/>
                                    </name>
                                  </assignedPerson>
                                </assignedAuthor>
                              </author>
                            </observation>
                          </component>
                        </organizer>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="Documents/Document[DocumentType/Code/text() = 'LR' and not(Extension/NationalTitle/Code/text() = 217)]">
                    <xsl:sort select="DocumentTime" order="descending" />
                    <xsl:if test="position() &lt; 6">
                      <entry typeCode='DRIV'>
                        <xsl:comment> CCD Results Organizer = VA Lab Order Panel , REQUIRED </xsl:comment>
                        <organizer classCode="CLUSTER" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.1" />
                          <id nullFlavor="NI" />
                          <code nullFlavor="UNK">
                            <originalText>
                              <xsl:value-of select="DocumentName" />
                            </originalText>
                            <translation code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Studies"/>
                          </code>
                          <statusCode code="completed" />
                          <effectiveTime>
                            <xsl:choose>
                              <xsl:when test="boolean(DocumentTime)">
                                <xsl:attribute name="value">
                                  <xsl:value-of select="translate(DocumentTime/text(),'TZ:- ','')"/>
                                </xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>
                          </effectiveTime>
                          <author>
                            <time nullFlavor="NA" />
                            <assignedAuthor>
                              <id nullFlavor="NA" />
                              <representedOrganization>
                                <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                <name>
                                  <xsl:value-of select="EnteredAt/Description"/>
                                </name>
                              </representedOrganization>
                            </assignedAuthor>
                          </author>
                          <component>
                            <observation classCode="OBS" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.2" />
                              <xsl:comment> 15.01 RESULT ID, REQUIRED </xsl:comment>
                              <id nullFlavor="UNK" />
                              <xsl:comment> 15.03-RESULT TYPE, REQUIRED </xsl:comment>
                              <code nullFlavor="UNK">
                                <originalText>
                                  <xsl:value-of select="DocumentName" />
                                </originalText>
                                <translation code="18726-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Radiology Studies"/>
                              </code>
                              <text >
                                <reference nullFlavor="UNK"/>
                              </text>
                              <statusCode code="completed" />
                              <xsl:comment> 15.02 RESULT DATE/TIME, REQUIRED </xsl:comment>
                              <effectiveTime>
                                <xsl:choose>
                                  <xsl:when test="boolean(DocumentTime)">
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="translate(DocumentTime/text(),'TZ:- ','')"/>
                                    </xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="nullFlavor">UNK</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </effectiveTime>
                              <xsl:comment> 15.05 RESULT VALUE, REQUIRED, xsi:type="PQ" </xsl:comment>
                              <value xsi:type="ED">
                                <reference value="{concat('#panoteEncounterDescription',position())}"/>
                              </value>
                              <xsl:comment> CCD METHOD CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                              <xsl:comment> CCD TARGET SITE CODE, Optional, Not provided by VA b/c data not yet available via VA VistA RPCs </xsl:comment>
                              <author>
                                <time nullFlavor="NA" />
                                <assignedAuthor>
                                  <id nullFlavor="NA" />
                                  <assignedPerson>
                                    <name>
                                      <xsl:value-of select="Clinician/Description"/>
                                    </name>
                                  </assignedPerson>
                                </assignedAuthor>
                              </author>
                            </observation>
                          </component>
                        </organizer>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
<xsl:comment> ******************************************************** SOCIAL HISTORY SECTION, Optional ******************************************************** </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(SocialHistories/SocialHistory))">
                <section nullFlavor="NI">
                  <xsl:comment> CCD Social History Section Entries </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.17" />
                  <code code="29762-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Social history" />
                  <title>Social History</title>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> CCD Social History Section Entries </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.17" />
                  <code code="29762-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Social history" />
                  <title>Social History</title>
                  <text>
                    <xsl:comment> VA Procedure Business Rules for Medical Content </xsl:comment>
                    <paragraph>This section includes the smoking or tobacco-related health factors on record with VA for the patient.</paragraph>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Smoking Status</th>
                          <th>Comment</th>
                          <th>Facility</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="SocialHistories/SocialHistory">
                          <xsl:sort select="EnteredOn" order="descending" />
                          <xsl:if test="position() = 1">
                            <tr>
                              <td>
                                <content ID="{concat('hfDate',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="EnteredOn/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfName',position())}">
                                  <xsl:value-of select="SocialHabit/Code/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfSeverity',position())}">
                                  <xsl:value-of select="SocialHabitSeverity/text()" />
                                </content>
                                <!-- TODO: I made this one up-->
                                <br/>
                                <content ID="{concat('hfComment',position())}">
                                  <xsl:value-of select="SocialHabitComments/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfFacility',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>

                    <paragraph styleCode="Bold">Tobacco Use History</paragraph>

                    <paragraph >This section includes a history of the smoking, or tobacco-related health factors.</paragraph>
                    <table border="1" width="100%">
                      <thead>
                        <tr>
                          <th>Date/Time</th>
                          <th>Smoking Status/Tobacco Use</th>
                          <th>Comment</th>
                          <th>Facility</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="SocialHistories/SocialHistory">
                          <xsl:sort select="EnteredOn" order="descending" />
                          <xsl:if test="not(position() = 1)">
                            <tr>
                              <td>
                                <content ID="{concat('hfDate',position())}">
                                  <xsl:call-template name="tmpDateTemplate" >
                                    <xsl:with-param name="date-time" select="EnteredOn/text()" />
                                    <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                  </xsl:call-template>
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfName',position())}">
                                  <xsl:value-of select="SocialHabit/Code/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfSeverity',position())}">
                                  <xsl:value-of select="SocialHabitSeverity/text()" />
                                </content>
                                <!-- TODO: I made this one up-->
                                <br/>
                                <content ID="{concat('hfComment',position())}">
                                  <xsl:value-of select="SocialHabitComments/text()" />
                                </content>
                              </td>
                              <td>
                                <content ID="{concat('hfFacility',position())}">
                                  <xsl:value-of select="EnteredAt/Description/text()" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </text>
                  <xsl:for-each select="SocialHistories/SocialHistory">
                    <xsl:sort select="EnteredOn" order="descending" />
                    <xsl:if test="position() = 1">
                      <entry>
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.78" />
                          <!-- <id nullFlavor="NI" /> -->
                          <code code="72166-2" codeSystem="2.16.840.1.113883.6.1" displayName="Tobacco smoking status NHIS" />
                          <statusCode code="completed" />
                          <xsl:comment> CCD Smoking Status Effective Time, R2 </xsl:comment>
                          <xsl:choose>
                            <xsl:when test="boolean(EnteredOn)">
                              <effectiveTime value="{translate(EnteredOn/text(), 'TZ:- ', '')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <effectiveTime nullFlavor="UNK"/>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:comment> CCD Smoking Status Value, REQURIED, SNOMED CT </xsl:comment>
                          <value nullFlavor="UNK" xsi:type="CD" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" >
                            <originalText>
                              <!-- TODO Vetsies -->
                              <reference value="{concat('#hfName',position())}"/>
                            </originalText>
                          </value>
                          <xsl:comment> INFORMATION SOURCE FOR SMOKING STATUS, Optional </xsl:comment>
                          <author>
                            <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                            <time nullFlavor="UNK" />
                            <assignedAuthor>
                              <id nullFlavor="UNK" />
                              <xsl:choose>
                                <xsl:when test="boolean(EnteredAt/Code)">
                                  <representedOrganization>
                                    <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR)  </xsl:comment>
                                    <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description"/>
                                    </name>
                                  </representedOrganization>
                                </xsl:when>
                                <xsl:otherwise>
                                  <representedOrganization>
                                    <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR)  </xsl:comment>
                                    <id nullFlavor="NI" root="2.16.840.1.113883.4.349" />
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                  </representedOrganization>
                                </xsl:otherwise>
                              </xsl:choose>
                            </assignedAuthor>
                          </author>
                          <xsl:comment> CCD Smoking Status Comment Entry, Optional </xsl:comment>
                          <entryRelationship typeCode="SUBJ" inversionInd="true">
                            <act classCode="ACT" moodCode="EVN">
                              <templateId root="2.16.840.1.113883.10.20.22.4.64" />
                              <code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation comment" />
                              <xsl:comment> CCD Smoking Status Comment, REQUIRED </xsl:comment>
                              <text>
                                <reference value="{concat('#hfComment',position())}"/>
                              </text>
                            </act>
                          </entryRelationship>
                        </observation>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="SocialHistories/SocialHistory">
                    <xsl:sort select="EnteredOn" order="descending" />
                    <xsl:if test="not(position() = 1)">
                      <entry>
                        <observation classCode="OBS" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.85" />
                          <id nullFlavor="NI" />
                          <code code="11367-0" codeSystem="2.16.840.1.113883.6.1" displayName="History of tobacco use" />
                          <statusCode code="completed" />
                          <xsl:comment> CCD Smoking Status Effective Time, R2 </xsl:comment>
                          <xsl:choose>
                            <xsl:when test="boolean(EnteredOn)">
                              <effectiveTime>
                                <low value="{translate(EnteredOn/text(), 'TZ:- ', '')}"/>
                                <high nullFlavor="NAV" />
                              </effectiveTime>
                            </xsl:when>
                            <xsl:otherwise>
                              <effectiveTime>
                                <low nullFlavor="UNK"/>
                                <high nullFlavor="NAV" />
                              </effectiveTime>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:comment> CCD Smoking Status Value, REQURIED, SNOMED CT </xsl:comment>
                          <value xsi:type="CD" nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT">
                            <originalText>
                              <!-- Vets is the suck-->
                              <reference value="{concat('#hfName',position())}"/>
                            </originalText>
                          </value>
                          <xsl:comment> INFORMATION SOURCE FOR SMOKING STATUS, Optional </xsl:comment>
                          <author>
                            <templateId root="2.16.840.1.113883.10.20.22.4.119" />
                            <time nullFlavor="UNK" />
                            <assignedAuthor>
                              <id nullFlavor="UNK" />
                              <representedOrganization>
                                <xsl:comment>  INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING  FACILITY NBR) </xsl:comment>
                                <xsl:choose>
                                  <xsl:when test="boolean(EnteredAt)">
                                    <id extension="{EnteredAt/Code/text()}" root="2.16.840.1.113883.4.349" />
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                    <name>
                                      <xsl:value-of select="EnteredAt/Description"/>
                                    </name>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <id nullFlavor="UNK" root="2.16.840.1.113883.4.349" />
                                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                                    <name nullFlavor="UNK" />
                                  </xsl:otherwise>
                                </xsl:choose>
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
                                <reference value="{concat('#hfComment',position())}"/>
                              </text>
                            </act>
                          </entryRelationship>
                        </observation>
                      </entry>
                    </xsl:if>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
          </component>
          <component>
<xsl:comment> ******************************************************** VITAL SIGNS SECTION, REQUIRED ******************************************************** </xsl:comment>
            <xsl:choose>
              <xsl:when test="not(boolean(Observations/Observation))">
                <section nullFlavor="NI">
                  <xsl:comment> C-CDA CCD VITAL SIGNS Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.4.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.4" />
                  <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Vital Signs" />
                  <title>Vital Signs</title>
                  <xsl:comment> VITAL SIGNS NARRATIVE BLOCK, REQUIRED </xsl:comment>
                  <text>No Data Provided for This Section</text>
                </section>
              </xsl:when>
              <xsl:otherwise>
                <section>
                  <xsl:comment> C-CDA CCD VITAL SIGNS Section Template Entries REQUIRED </xsl:comment>
                  <templateId root="2.16.840.1.113883.10.20.22.2.4.1" />
                  <templateId root="2.16.840.1.113883.10.20.22.2.4" />
                  <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Vital Signs" />
                  <title>Vital Signs</title>
                  <xsl:comment> VITAL SIGNS NARRATIVE BLOCK, REQUIRED </xsl:comment>
                  <text>
                    <xsl:comment> VA Vital Signs Business Rules for Medical Content </xsl:comment>
                    <paragraph >
                      This section contains inpatient and outpatient Vital Signs on record at VA for the patient.
                      The data comes from all VA treatment facilities. It includes vital signs collected within
                      the requested date range. If more than one set of vitals was taken on the same date,
                      only the most recent set is populated for that date. If no date range was provided,
                      it includes 12 months of data, with a maximum of the 5 most recent sets of vitals.
                      If more than one set of vitals was taken on the same date, only the most recent set
                      is populated for that date.
                    </paragraph>
                    <table>
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
                        <xsl:for-each select="Observations/Observation[generate-id() = generate-id(key('vitals', GroupId)[1])]">
                          <xsl:sort select="ObservationTime" order="descending" />
                          <xsl:variable name="grp" select="GroupId/text()" />
                          <xsl:if test="position() &lt; 6">
                            <tr>
                              <td>
                                <xsl:call-template name="tmpDateTemplate" >
                                  <xsl:with-param name="date-time" select="ObservationTime/text()" />
                                  <xsl:with-param name="pattern" select="'MMM dd, yyyy hh:mm aa'" />
                                </xsl:call-template>
                              </td>

                              <td>
                                <!-- Temp -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500638]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500638]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- Pulse -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500636]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500636]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- Blood Pressure -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500634]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500634]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- Respiratory -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4688725]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4688725]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- Pulse OX -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500637]/ObservationValue" />
                                <xsl:if test="boolean(../Observation[GroupId = $grp and ObservationCode/Code = 4500637]/ObservationValue)">%</xsl:if>
                              </td>

                              <td>
                                <!-- PAIN -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500635]/ObservationValue" />
                              </td>

                              <td>
                                <!-- Height -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4688724]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4688724]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- Weight -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500639]/ObservationValue" />
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500639]/ObservationCode/ObservationValueUnits/OriginalText" />
                              </td>

                              <td>
                                <!-- BMI -->
                                <xsl:value-of select="../Observation[GroupId = $grp and ObservationCode/Code = 4500639]/Extension/BMI" />
                              </td>

                              <td>
                                <content ID="{concat('vndSource', position())}">
                                  <xsl:value-of select="EnteredAt/Description" />
                                </content>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </tbody>
                    </table>
                    <xsl:comment> CDA Observation Text as a Reference tag </xsl:comment>
                    <content ID="vital1" revised='delete'> Vital Sign Observation Text Not Available </content>
                  </text>
                  <xsl:comment> VITAL SIGNS STRUCTURED DATA </xsl:comment>
                  <xsl:for-each select="Observations/Observation[generate-id() = generate-id(key('vitals', GroupId)[1])]">
                    <xsl:sort select="ObservationTime" order="descending" />
                    <xsl:variable name="grp" select="GroupId/text()" />
                    <xsl:if test="position() &lt; 6">
                      <entry typeCode='DRIV'>
                        <xsl:comment> Vital Signs Organizer Template, REQUIRED </xsl:comment>
                        <organizer classCode="CLUSTER" moodCode="EVN">
                          <templateId root="2.16.840.1.113883.10.20.22.4.26" />
                          <xsl:comment> Vital Sign Organizer ID as nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
                          <id nullFlavor="NA" />
                          <code code="46680005" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT" displayName="Vital signs" />
                          <statusCode code="completed" />
                          <xsl:choose>
                            <xsl:when test="boolean(ObservationTime)">
                              <effectiveTime>
                                <low value="{translate(ObservationTime/text(), 'TZ:- ','')}"/>
                                <high value="{translate(ObservationTime/text(), 'TZ:- ','')}"/>
                              </effectiveTime>
                            </xsl:when>
                            <xsl:otherwise>
                              <effectiveTime>
                                <low nullFlavor="UNK"/>
                                <high nullFlavor="UNK"/>
                              </effectiveTime>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:comment> INFORMATION SOURCE FOR VITAL SIGN ORGANIZER/PANEL, Optional </xsl:comment>
                          <author>
                            <time nullFlavor="NA" />
                            <assignedAuthor>
                              <id nullFlavor="NA" />
                              <representedOrganization>
                                <xsl:comment> INFORMATION SOURCE ID, root=VA OID, extension= VAMC TREATING FACILITY NBR </xsl:comment>
                                <id root="2.16.840.1.113883.4.349" extension="{EnteredAt/Code/text()}" />
                                <xsl:comment>INFORMATION SOURCE NAME, name=VAMC TREATING FACILITY NAME </xsl:comment>
                                <name>
                                  <xsl:value-of select="EnteredAt/Description"/>
                                </name>
                              </representedOrganization>
                            </assignedAuthor>
                          </author>
                          <xsl:comment>One component block for each Vital Sign </xsl:comment>
                          <xsl:for-each select="../Observation[GroupId = $grp]">
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
                    </xsl:if>
                  </xsl:for-each>
                </section>
              </xsl:otherwise>
            </xsl:choose>
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
            <xsl:attribute name="use"><xsl:value-of select="$use" /></xsl:attribute>
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
            <xsl:attribute name="use"><xsl:value-of select="$use" /></xsl:attribute>
          </xsl:if>        
        </name>      
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  <xsl:template match="SupportContact" mode="header-participant">
    <participant typeCode="IND">
      <xsl:comment> 3.01 DATE, REQUIRED </xsl:comment>
      <xsl:comment>3.01 DATE date as nullFlavor b/c data not yet available via VA VistA RPCs
      </xsl:comment>
      <time nullFlavor="UNK" />
      <xsl:comment> 3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value in contactType </xsl:comment>
        <associatedEntity classCode="{ContactType/Code/text()}">
          <code codeSystem='2.16.840.1.113883.5.111' codeSystemName='{isc:evaluate("getCodeForOID","2.16.840.1.113883.5.111","","2.16.840.1.113883.5.111")}' nullFlavor='NA'>
            <originalText><xsl:value-of select='Relationship/Code/text()' /></originalText>
          </code>
          <xsl:comment> 3.04 CONTACT Addresss, Home Permanent, Optional-R2 </xsl:comment>
          <xsl:apply-templates select='.' mode='standard-address'>
            <xsl:with-param name='use'>HP</xsl:with-param>
          </xsl:apply-templates>
          <xsl:comment> 3.05 CONTACT PHONE/EMAIL/URL, Optional-R2, Removed b/c data not yet 
            available via VA VistA RPCs </xsl:comment>
          <xsl:apply-templates select='.' mode='standard-contact-info' />
          <associatedPerson>
            <xsl:comment> 3.06 CONTACT NAME, REQUIRED </xsl:comment>
            <xsl:apply-templates select='Name' mode='standard-name' />
          </associatedPerson>
        </associatedEntity>
      </participant>
  </xsl:template>
  <xsl:template match='*' mode='header-careteammembers' >
    <xsl:param name="number" />
    <performer typeCode="PRF">
      <xsl:comment> ****** PRIMARY HEALTHCARE PROVIDER MODULE, Optional ********* </xsl:comment>
      <xsl:comment> 4.02 PROVIDER ROLE CODED, optional </xsl:comment>
      <templateId root="2.16.840.1.113883.10.20.6.2.1" extension="2014-06-09" />
      <xsl:choose>
        <xsl:when test="$number=1">
          <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="{isc:evaluate('getCodeForOID','2.16.840.1.113883.5.88','CodeSystem','ParticipationFunction')}" displayName="{Description/text()}">
            <originalText><xsl:value-of select="Description/text()" /></originalText>
          </functionCode>
        </xsl:when>
        <xsl:otherwise>
          <functionCode nullFlavor="NI">
            <originalText><xsl:value-of select="concat('Care Team:  ', ../../CareTeamName/text())" /></originalText>
          </functionCode>
        </xsl:otherwise>
      </xsl:choose>
      <assignedEntity>
        <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
        <!-- <id extension="providerN" root="2.16.840.1.113883.4.349" /> -->
        <id nullFlavor="NI"/>
          <xsl:comment>4.04 PROVIDER TYPE, optional, NUCC </xsl:comment>
        <xsl:choose>
          <xsl:when test="boolean(CareProviderType)">
            <code code="{CareProviderType/Code/text()}" codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" displayName="{CareProviderType/Description/text()}">
              <originalText><xsl:value-of select="CareProviderType/Description/text()" /></originalText>
            </code>
          </xsl:when>
          <xsl:otherwise>
            <code codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC" nullFlavor="UNK">
              <originalText><xsl:value-of select="Description/text()" /></originalText>
            </code>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:comment> Address Required for assignedEntity </xsl:comment>
        <xsl:apply-templates select="." mode="standard-address">
          <xsl:with-param name="use">WP</xsl:with-param>
        </xsl:apply-templates>
        <xsl:comment> Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
        <!-- <xsl:apply-templates select="." mode="standard-contact-info" /> -->
        <telecom nullFlavor="NA" />
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
  <xsl:template name="standard-FutureOrderTypeCode">
    <xsl:param name="doc" select="." />
    <xsl:choose>
      <xsl:when test="OrderCategory/Code/text() = 'AP'">
        Laboratory - Anatomic Pathology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'ANI'">
        Imaging - Angiography/Neuroradiology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'BB'">
        Laboratory - Blood Bank Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'VBEC'">
        Laboratory - Blood Product Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CARD'">
        Imaging - Cardiology Study Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CPL'">
        Cardiopulmonary Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CH'">
        Laboratory - Chemistry Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'C RX'">
        Pharmacy - Clinic Medication Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CI RX'">
        Pharmacy - Clinic Infusion Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CSLT'">
        Consult Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CT'">
        Imaging - CT Scan Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'CY'">
        Laboratory - Cytology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'EM'">
        Laboratory - Electron Microscopy Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'RAD'">
        Imaging - General Radiology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'HEMA'">
        Laboratory - Hematology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'MRI'">
        Imaging - Magnetic Resonance Imaging (MRI) Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'MAM'">
        Imaging - Mammography Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'MI'">
        Laboratory - Microbiology Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'NM'">
        Imaging - Nuclear Medicine Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'SUM'">
        Physical, Occupational or Respiratory Therapy (PT/OT/RT) Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'PROC'">
        Procedure Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'SURG'">
        Surgery Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'SP'">
        Laboratory - Surgical Pathology
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'US'">
        Imaging - Ultrasound Order
      </xsl:when>
      <xsl:when test="OrderCategory/Code/text() = 'VAS'">
        Imaging - Vascular Lab Order
      </xsl:when>
      <xsl:otherwise>
        
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
                              <templateId root="2.16.840.1.113883.10.20.22.4.27" extension="2014-06-09"/>
                              <xsl:comment>14.01-VITAL SIGN RESULT ID, REQUIRED </xsl:comment>
                              <id root="2.16.840.1.113883.4.349" extension="{concat('.8716-3.',$ob/EnteredBy/Code/text(),$grp)}"/>
                              <xsl:comment>14.03-VITAL SIGN RESULT TYPE, REQUIRED, LOINC </xsl:comment>
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
                              <text>
                                <reference value="#vital1"/>
                              </text>
                              <xsl:comment> 14.04-VITAL SIGN RESULT STATUS, REQUIRED, Static value of completed </xsl:comment>
                              <statusCode code="completed" />
                              <xsl:comment> 14.02-VITAL SIGN RESULT DATE/TIME, REQURIED </xsl:comment>
                              <xsl:choose><xsl:when test="$ob/ObservationTime"><effectiveTime value="{translate($ob/ObservationTime/text(), 'TZ:- ','')}" /></xsl:when><xsl:otherwise><effectiveTime nullFlavor="UNK" /></xsl:otherwise></xsl:choose>
                              <xsl:comment>
                                14.05-VITAL SIGN RESULT VALUE, CONDITIONALLY REQUIRED when
                                moodCode=EVN
                              </xsl:comment>
                              <xsl:comment> 14.05-VITAL SIGN RESULT VALUE with Unit of Measure </xsl:comment>

                              <xsl:choose>
                                <xsl:when test="$isBMI = 'true'">
                                  <value xsi:type="PQ" unit="kg/m2" value="{$ob/Extension/BMI/text()}"></value>
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
                              <xsl:comment>
                                14.06-VITAL SIGN RESULT INTERPRETATION, Optional, HL7 Result
                                Normalcy Status Value Set
                              </xsl:comment>
                              <xsl:comment>
                                14.06-VITAL SIGN RESULT INTERPRETATION, Removed b/c data not
                                yet available via VA VistA RPCs
                              </xsl:comment>
                              <xsl:comment> 14.07-VITAL SIGN RESULT REFERENCE RANGE, Optional, </xsl:comment>
                              <xsl:comment>
                                14.07-VITAL SIGN RESULT REFERENCE RANGE, Removed b/c data not
                                yet available via VA VistA RPCs
                              </xsl:comment>
                              <methodCode nullFlavor="UNK">
                                <originalText/>
                              </methodCode><!-- VETS cause, yeah-->
                              <targetSiteCode nullFlavor="UNK">
                                <originalText/>
                              </targetSiteCode>
                            </observation>
                          </component>
</xsl:template>
<xsl:template name="tmpDateTemplate">
  <xsl:param name="date-time" />
  <xsl:param name="pattern" />
  <xsl:call-template name="date:format-date">
    <xsl:with-param name="date-time" select="$date-time" />
    <xsl:with-param name="pattern" select="$pattern" />
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>