<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

  <xsl:variable name="documentCreatedOn" select="isc:evaluate('xmltimestamp', isc:evaluate('timestamp'))" />

  <xsl:template match="/Container">
    <xsl:variable name="patientBirthDate" select="Patient/BirthTime/text()" />
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:value-of select="'type=&#34;text/xsl&#34; href=&#34;cda.xsl&#34;'"/>
    </xsl:processing-instruction>
    <ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 http://xreg2.nist.gov:11080/hitspValidation/schema/cdar2c32/infrastructure/cda/C32_CDA.xsd">
    <!-- 
    ********************************************************
    CDA Header
    ********************************************************
    -->
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
    <!-- CDA Document Identifer, id=VA OID, extension=system-generated -->
    <id extension="docId" root="2.16.840.1.113883.4.349"/>
      <xsl:comment> CDA Document Code </xsl:comment>
    <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
    <!-- CDA Document Title -->
    <title>Department of Veterans Affairs Summarization of Episode Note</title>
      <xsl:comment> DOCUMENT TIMESTAMP, REQUIRED </xsl:comment>
    <effectiveTime value="docTime"/>
    <!-- CDA Confiedntiality Code -->
    <confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>
    <!-- CDA DOCUMENT LANGUAGE -->
    <languageCode code="en-US"/>
    <!-- 
	********************************************************
	PERSON INFORMATION CONTENT MODULE, REQUIRED
	********************************************************
	-->
    <recordTarget>
      <patientRole>
        <xsl:comment> 1.02 PERSON ID, REQUIRED, id=VA OID, extension=GUID </xsl:comment>
        <id root="2.16.840.1.113883.4.349" extension="personICN"/>
        <xsl:comment>  1.03 PERSON ADDRESS-HOME PERMANENT, REQUIRED </xsl:comment>
        <addr use="HP">
          <streetAddressLine/>
          <city/>
          <state/>
          <postalCode/>
        </addr>
        <xsl:comment> 1.04 PERSON PHONE/EMAIL/URL, REQUIRED </xsl:comment>
        <telecom/>
        <patient>
          <xsl:comment>  1.05 PERSON NAME LEGAL, REQUIRED </xsl:comment>
          <name use="L">
            <prefix/>
            <given/>
            <given MAP_ID="middle" />
            <family/>
            <suffix/>
          </name>
          <xsl:comment>  1.05 PERSON NAME Alias Name, Optional </xsl:comment>
          <name use="P">
            <prefix/>
            <given/>
            <family/>
            <suffix/>
          </name>
          <xsl:comment> HITSP C32 V2.5: 1.06 GENDER, REQUIRED AND REQUIRED Terminology </xsl:comment>
          <xsl:comment> HITSP C32 V2.5: When Vista value is M, F, send as HL7AdminGenderCode  </xsl:comment>
          <xsl:comment> HITSP C32 V2.5: When Vista value is "Unknown", send as genderCode nullFlavor=UNK"  </xsl:comment>
          <administrativeGenderCode codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode">
            <originalText/>
          </administrativeGenderCode>
          <xsl:comment> 1.07 PERSON DATE OF BIRTH, REQUIRED </xsl:comment>
          <birthTime value=""/>
          <xsl:comment>  1.08 MARITAL STATUS, Optional-R2 </xsl:comment>
          <xsl:comment> VLER SEG 1B:  Send as HL7 MaritalStatus  </xsl:comment>
          <maritalStatusCode codeSystem='2.16.840.1.113883.5.2' codeSystemName='MaritalStatusCode' >
            <originalText/>
          </maritalStatusCode>
          <xsl:comment>  1.09 RELIGIOUS AFFILIATION, Optional, Removed b/c data not yet available via VA VIstA RPCs</xsl:comment>
          <xsl:comment>  1.10 RACE, Optional </xsl:comment>
          <xsl:comment>  1.10 RACE as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
          <raceCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='CDC Race and Ethnicity'>
            <originalText/>
          </raceCode>
          <xsl:comment> 1.11 ETHNICITY, Optional </xsl:comment>
          <xsl:comment> 1.11 ETHNICITY as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
          <ethnicGroupCode codeSystem='2.16.840.1.113883.6.238' codeSystemName='CDC Race and Ethnicity'>
            <originalText/>
          </ethnicGroupCode>
          <!-- 
				********************************************************
				LANGUAGE SPOKEN CONTENT MODULE
				********************************************************
				-->
          <languageCommunication>
            <templateId root="2.16.840.1.113883.3.88.11.32.2"/>
            <xsl:comment>  2.01 LANGUAGE, REQUIRED, languageCode as nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
            <languageCode nullFlavor="UNK"/>
          </languageCommunication>
        </patient>
      </patientRole>
    </recordTarget>
    <!-- 
	********************************************************
	INFORMATION SOURCE CONTENT MODULE, REQUIRED
	********************************************************
	-->
      <xsl:comment> AUTHOR SECTION (REQUIRED) OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
    <author>
      <xsl:comment> 10.01 AUTHOR TIME (=Document Creation Date), REQUIRED </xsl:comment>
      <time value="documentCreatedOn"/>
      <assignedAuthor>
        <xsl:comment> 10.02 AUTHOR ID (VA OID) (authorOID), REQUIIRED </xsl:comment>
        <id root="2.16.840.1.113883.4.349"/>
        <xsl:comment> HITSP C32 V2.5:  Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
        <addr></addr>
        <xsl:comment> HITSP C32 V2.5:  Assigned Author  Telecom Required, but VA VistA data not yet available </xsl:comment>
        <telecom></telecom>
        <xsl:comment> 10.02 AUTHOR NAME REQUIRED </xsl:comment>
        <xsl:comment>- HITSP C32 V2.5:  C83  assignedPerson/Author Name REQUIRED but provided as representedOrganization</xsl:comment>
        <assignedPerson>
          <name></name>
        </assignedPerson>
        <xsl:comment> 10.02 AUTHOR NAME REQUIRED as representedOrganization </xsl:comment>
        <representedOrganization>
          <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION OID (VA OID) (deviceOrgOID), REQUIIRED </xsl:comment>
          <id root="2.16.840.1.113883.4.349"/>
          <xsl:comment> 10.02 AUTHORING DEVICE ORGANIZATION NAME (deviceOrgName), REQUIIRED </xsl:comment>
          <name>Department of Veterans Affairs</name>
          <xsl:comment> HITSP C32 V2.5:  Assigned Author  Telecom Required, but VA VistA data not yet available </xsl:comment>
          <telecom></telecom>
          <xsl:comment> HITSP C32 V2.5:  Assigned Author Address Required, but VA VistA data not yet available </xsl:comment>
          <addr></addr>
        </representedOrganization>
      </assignedAuthor>
    </author>
      <xsl:comment> INFORMATION SOURCE SECTION (OPTIONAL)OF INFORMATION SOURCE CONTENT MODULE </xsl:comment>
      <xsl:comment> 10.06 INFORMATION SOURCE AS AN ORGANIZATION, REQUIRED </xsl:comment>
    <informant>
      <assignedEntity>
        <id nullFlavor="NI"/>
        <xsl:comment> HITSP C32 V2.5:   Address Required for informant/assignedEntity, but VA VistA data not yet available </xsl:comment>
        <addr></addr>
        <xsl:comment> HITSP C32 V2.5:    Telecom Required for informant/assignedEntity, but VA VistA data not yet available </xsl:comment>
        <telecom></telecom>
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
          <telecom></telecom>
          <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <addr></addr>
        </representedOrganization>
      </assignedEntity>
    </informant>
    <!-- 
	********************************************************
	CCD CDA R2 CUSTODIAN AS AN ORGANIZATION, REQUIRED
	********************************************************
	-->
    <custodian>
      <assignedCustodian>
        <representedCustodianOrganization>
          <xsl:comment> CCD CDA R2 CUSTODIAN OID (VA) (custodianOID) </xsl:comment>
          <id root="2.16.840.1.113883.4.349"/>
          <xsl:comment> CCD CDA R2 CUSTODIAN NAME (custodianName) </xsl:comment>
          <name>Department of Veterans Affairs</name>
          <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <telecom></telecom>
          <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <addr></addr>
        </representedCustodianOrganization>
      </assignedCustodian>
    </custodian>
    <!-- 
	********************************************************
	CCD CDA R2 LEGAL AUTHENTICATOR AS AN ORGANIZATION, REQUIRED
	********************************************************
	-->
    <legalAuthenticator>
      <xsl:comment> CCD CDA R2 TIME OF AUTHENTICATION </xsl:comment>
      <time value="20100301020302-0500"/>
      <signatureCode code="S"/>
      <assignedEntity>
        <id nullFlavor="NI"/>
        <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
        <addr></addr>
        <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
        <telecom></telecom>
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
          <telecom></telecom>
          <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
          <addr></addr>
        </representedOrganization>
      </assignedEntity>
    </legalAuthenticator>
    <!-- 
    ********************************************************
    SUPPORT CONTENT MODULE, REQUIRED
    ********************************************************
    -->
    <participant typeCode="IND">
      <xsl:comment> participant block repeated for NOK and ECON </xsl:comment>
      <templateId root="2.16.840.1.113883.3.88.11.32.3"/>
      <xsl:comment> HITSP C32 V2.5:    IHE Support Template </xsl:comment>
      <templateId root='1.3.6.1.4.1.19376.1.5.3.1.2.4'/>
      <xsl:comment>  3.01 DATE, REQUIRED </xsl:comment>
      <xsl:comment>  3.01 DATE date as nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
      <time nullFlavor="UNK"/>
      <xsl:comment>  3.02 CONTACT TYPE, REQUIRED, classCode value determined by VistA value in contactType </xsl:comment>
      <associatedEntity classCode="contactType">
        <xsl:comment>  3.03 CONTACT RELATIONSHIP as originalText per NHIN Core Content Specification b/c VA code translation not yet available </xsl:comment>
        <code code="UNK" codeSystem='2.16.840.1.113883.5.111' codeSystemName='RoleCode'>
          <originalText>relationshipType</originalText>
        </code>
        <xsl:comment>  3.04 CONTACT Addresss, Home Permanent, Optional-R2 </xsl:comment>
        <addr use="HP">
          <streetAddressLine>homeAddressLine</streetAddressLine>
          <city>homeCity</city>
          <state>homeState</state>
          <postalCode>homePostal</postalCode>
        </addr>
        <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity  </xsl:comment>
        <xsl:comment>  3.05 CONTACT PHONE/EMAIL/URL, Optional-R2,  Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
        <telecom />
        <associatedPerson>
          <xsl:comment> 3.06 CONTACT NAME, REQUIRED </xsl:comment>
          <name>
            <prefix/>
            <given>nameGiven</given>
            <family>nameFamily</family>
            <suffix>nameSuffix</suffix>
          </name>
        </associatedPerson>
      </associatedEntity>
    </participant>
    <!-- 
	********************************************************
	CCD CDA R2 DOCUMENTATION OF MODULE - QUERY META DATA, Optional 
	********************************************************
	-->
    <documentationOf>
      <serviceEvent classCode="PCPR">
        <effectiveTime>
          <xsl:comment> QUERY META DATA, SERVICE START TIME, Optional </xsl:comment>
          <low value=""/>
          <xsl:comment> QUERY META DATA, SERVICE STOP TIME, Optional </xsl:comment>
          <high value=""/>
        </effectiveTime>
        <!-- 
			********************************************************
			HEALTHCARE PROVIDER MODULE, OPTIONAL
			********************************************************
			-->
        <performer typeCode="PPRF">
          <xsl:comment> Provider Template Id  </xsl:comment>
          <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
          <xsl:comment> 4.02-PROVIDER ROLE CODED, Optional-R2, Removed b/c data not yet available via VA VistA RPCs -->
          <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="HL7 particiationFunction" displayName="Primary Care Provider">
            <originalText>Primary Care Provider</originalText>
          </functionCode>
          <xsl:comment> 4.03-PROVIDER ROLE FREE TEXT, Optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
          <xsl:comment> 4.01-DATE RANGE, Required, nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
          <time>
            <high nullFlavor="UNK"/>
          </time>
          <assignedEntity>
            <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
            <id extension="provider1" root="2.16.840.1.113883.4.349"/>
            <code codeSystem="2.16.840.1.113883.6.101" codeSystemName="NUCC">
              <originalText />
            </code>
          <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity </xsl:comment>
            <addr use="WP">
              <streetAddressLine />
              <city />
              <state />
              <postalCode />
            </addr>
          <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
            <telecom ID="TELEPHONE" use="WP"/>
            <telecom ID="EMAIL" use="WP"/>
            <assignedPerson>
              <name></name>
            </assignedPerson>
            <representedOrganization>
              <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
              <id root="2.16.840.1.113883.4.349" nullFlavor="UNK" />
          <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
              <name></name>
          <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
              <telecom></telecom>
          <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
              <addr></addr>
            </representedOrganization>
          </assignedEntity>
        </performer>

        <performer typeCode="PRF">
          <xsl:comment> Provider Template Id  </xsl:comment>
          <templateId root="2.16.840.1.113883.3.88.11.32.4"/>
          <xsl:comment> 4.02-PROVIDER ROLE CODED, Optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
          <functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88" codeSystemName="HL7 particiationFunction" displayName="Primary Care Provider">
            <originalText>Primary Care Provider</originalText>
          </functionCode>
          </xsl:comment> 4.03-PROVIDER ROLE FREE TEXT, Optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
          </xsl:comment> 4.01-DATE RANGE, Required, nullFlavor b/c data not yet available via VA VistA RPCs </xsl:comment>
          <time>
            <high nullFlavor="UNK"/>
          </time>
          <assignedEntity>
            <xsl:comment> Provider ID from Problems Module (7.05Treating Provider ID) </xsl:comment>
            <id extension="provider1" root="2.16.840.1.113883.4.349"/>
            <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
            <addr></addr>
            <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
            <telecom nullFlavor="UNK" />
            <assignedPerson>
              <name></name>
            </assignedPerson>
            <representedOrganization>
              <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
              <id extension="" root="2.16.840.1.113883.4.349"/>
              <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
              <name></name>
              <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
              <telecom></telecom>
              <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
              <addr></addr>
            </representedOrganization>
          </assignedEntity>
        </performer>
      </serviceEvent>
    </documentationOf>
    <!-- 
	********************************************************
	CDA BODY
	********************************************************
	-->
    <component>
      <structuredBody>
        <!-- 
			********************************************************
			ALLERGY/DRUG SECTION SECTION
			********************************************************
			-->
        <component>
          <section>
            <xsl:comment> CCD Alert Section Template </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.2"/>
            <xsl:comment> HITSP C32 V2.5:  Allergy and Adverse Reaction Section Template </xsl:comment>
            <templateId root="2.16.840.1.113883.3.88.11.83.102"/>
            <xsl:comment> HITSP C32 V2.5:  IHE Allergies and Other Adverse Reactions  Section Template </xsl:comment>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.13"/>
            <xsl:comment> HITSP C32 V2.5:  CCD Section Conformance code value , static </xsl:comment>
            <code code="48765-2" codeSystem="2.16.840.1.113883.6.1" displayName="Allergies, adverse reactions, alerts"/>
            <title>Allergies</title>
            <!--  ALLERGIES NARRATIVE BLOCK -->
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
                    <td>This VA Document contains all allergies for the patient, from all VA treatment facilities, but it does not contain allergies that were deleted or entered in error.</td>
                  </tr>
                </tbody>
              </table>
              <table ID="allergyNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Allergy (Name)</th>
                    <th>Verification Date</th>
                    <th>Event Type</th>
                    <th>Reaction</th>
                    <th>Severity</th>
                    <th>Source</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <content ID="andAllergy"/>
                    </td>
                    <td>
                      <content ID="andCodedAllergyName"/>
                    </td>
                    <td>
                      <content ID="andVerificationDate"/>
                    </td>
                    <td>
                      <content ID="andEventType"/>
                    </td>
                    <td>
                      <list>
                        <item>
                          <content ID="andReaction"/>
                        </item>
                      </list>
                    </td>
                    <td>
                      <content ID="andSeverity"/>
                    </td>
                    <td>
                      <content ID="andSource"/>
                    </td>
                  </tr>
                </tbody>
              </table>
            </text>
            <entry typeCode="DRIV">
              <act classCode="ACT" moodCode="EVN">
                <templateId root="2.16.840.1.113883.10.20.1.27" assigningAuthorityName="CCD" />
                <xsl:comment> HITSP C32 V2.5:  Templates for Allergy/Drug Module/Entry </xsl:comment>
                <templateId root="2.16.840.1.113883.3.88.11.83.6"/>
                <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
                <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.3"/>
                <xsl:comment> CCD Allergy Act ID as nullflavor </xsl:comment>
                <id nullFlavor="UNK"/>
                <code nullFlavor="NA"/>
                <xsl:comment> HITSP C32 V2.5:  IHE Concern Template Requires statusCode and effectiveTime  </xsl:comment>
                <statusCode code="active"/>
                <effectiveTime>
                  <low nullFlavor="UNK"/>
                </effectiveTime>
                <xsl:comment> INFORMATION SOURCE FOR ALLERGIES/DRUG, Optional </xsl:comment>
                <author>
                  <xsl:comment>  ADD TIME TO INFORMATION SOURCE FOR ALLERGIES/DRUG </xsl:comment>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <representedOrganization>
                      <xsl:comment> INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR </xsl:comment>
                      <id extension="" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                      <name></name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available -->
                      <addr></addr</xsl:comment>
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
                    <xsl:comment> 6.02 ADVERSE EVENT TYPE, REQUIRED; SNOMED CT  </xsl:comment>
                    <xsl:comment> HITSP C32 V2.5:  6.02 ADVERSE EVENT TYPE SNOMED CT Terminology Required </xsl:comment>
                    <code code='' codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT' displayName="">
                      <originalText></originalText>
                    </code>
                    <xsl:comment> IHE  Status Code fro Observation </xsl:comment>
                    <statusCode code="completed"/>
                    <xsl:comment> 6.01 ADVERSE EVENT DATE, Optional-R2 </xsl:comment>
                    <effectiveTime>
                      <low value=""/>
                    </effectiveTime>
                    <xsl:comment> HITSP C32 V2.5:  IHE Allergy Concern Template Requires value, When uncoded only xsi:type=CD allowed </xsl:comment>
                    <value xsi:type="CD"/>
                    <xsl:comment> HITSP C32 V2.5: Participant block for 6.04-Product Coded </xsl:comment>
                    <participant typeCode="CSM">
                      <participantRole classCode="MANU">
                        <playingEntity classCode="MMAT">
                          <xsl:comment>  6.04 PRODUCT CODED, Optional-R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                          <code code="UNK" nullFlavor="UNK">
                            <originalText>
                              <reference  value="#codedallergyname"/>
                            </originalText>
                          </code>
                          <xsl:comment> 6.03 PRODUCT FREE TEXT, REQUIRED</xsl:comment>
                          <name></name>
                        </playingEntity>
                      </participantRole>
                    </participant>
                    <xsl:comment>  SEVERITY ENTRY RELATIONSHIP BLOCK optional, 0 or 1 per Allergy </xsl:comment>
                    <entryRelationship typeCode="SUBJ" inversionInd="true">
                      <xsl:comment>Template ID for Problem Entry - Allergy Reaction Uses Same Structure </xsl:comment>
                      <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6.1'/>
                      <observation classCode="OBS" moodCode="EVN">
                        <xsl:comment> SeverityTemplate ID </xsl:comment>
                        <templateId root="2.16.840.1.113883.10.20.1.55"/>
                        <xsl:comment> HITSP C32 V2.5:    Allergy Templates </xsl:comment>
                        <templateId root='2.16.840.1.113883.10.20.1.28'/>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6'/>
                        <xsl:comment> CCD Obs ID as nullFlavor  </xsl:comment>
                        <id nullFlavor="UNK"/>
                        <code code='SEV' displayName='Severity' codeSystem='2.16.840.1.113883.5.4' codeSystemName='HL7ActCode' />
                        <xsl:comment> 6.07 SEVERITY-FREE TEXT, optional, Pointer to Narrative Block </xsl:comment>
                        <text>
                          <reference value="#andSeverity"/>
                        </text>
                        <statusCode code='completed'/>
                        <effectiveTime>
                          <low nullFlavor="UNK"/>
                        </effectiveTime>
                        <xsl:comment> 6.08 SEVERITY CODED, optional, When uncoded only xsi:type="CD" allowed </xsl:comment>
                        <value xsi:type="CD"/>
                      </observation>
                    </entryRelationship>
                    <xsl:comment>  REACTION ENTRYRELATIONSHIP BLOCK optional, repeatable  </xsl:comment>
                    <entryRelationship typeCode="MFST" inversionInd="true">
                      <observation classCode="OBS" moodCode="EVN">
                        <xsl:comment> Reaction Template ID </xsl:comment>
                        <templateId root="2.16.840.1.113883.10.20.1.54"/>
                        <xsl:comment> HITSP C32 V2.5:    Allergy Templates </xsl:comment>
                        <templateId root='2.16.840.1.113883.10.20.1.28'/>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.5'/>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.6'/>
                        <id nullFlavor="UNK"/>
                        <code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4" codeSystemName='HL7ActCode' />
                        <xsl:comment> 6.05 REACTION-FREE TEXT, optional,</xsl:comment>
                        <text>
                          <reference value="#andReaction"/>
                        </text>
                        <statusCode code='completed'/>
                        <effectiveTime>
                          <low nullFlavor="UNK"/>
                        </effectiveTime>
                        <xsl:comment> 6.06 REACTION CODED optional, when uncoded only xsi:type=CD allowed </xsl:comment>
                        <value xsi:type='CD'/>
                      </observation>
                    </entryRelationship>
                  </observation>
                </entryRelationship>
              </act>
            </entry>
          </section>
        </component>
        <!-- 
			********************************************************
			PROBLEM/CONDITION SECTION
			********************************************************
			-->
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
            <!-- templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/
					<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2"/ -->
            <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problems"/>
            <title>Problems/Conditions</title>
            <!--  PROBLEMS NARRATIVE BLOCK, Required -->
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
                    <td>This VA Document contains all problems for the patient (active and inactive), from all VA treatment facilities, but it  does not contain problems that were deleted.</td>
                  </tr>
                </tbody>
              </table>
              <table ID="problemNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Problem (Name)</th>
                    <th>Status</th>
                    <th>Problem Code</th>
                    <th>Date of Onset</th>
                    <th>Provider</th>
                    <th>Source</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <content ID="pndProblem"/>
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
                      <content ID="pndProvider" />
                    </td>
                    <td>
                      <content ID="pndSource" />
                    </td>
                  </tr>
                </tbody>
              </table>
            </text>
            <entry typeCode="DRIV">
              <act classCode="ACT" moodCode="EVN">
                <xsl:comment> CCD Problem Act Template </xsl:comment>
                <templateId root="2.16.840.1.113883.10.20.1.27"/>
                <xsl:comment> HITSP V2.5:  C83 Templates for Problem Module/Entry </xsl:comment>
                <templateId root="2.16.840.1.113883.3.88.11.83.7"/>
                <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/>
                <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2"/>
                <!-- CCD Problem Act ID as nullFlavor  -->
                <id nullFlavor="UNK"/>
                <code nullFlavor="NA"/>
                <xsl:comment> HITSP V2.5 IHE Problem Concern Templates Requires statusCode </xsl:comment>
                <statusCode code="completed"/>
                <xsl:comment>  7.01 PROBLEM DATE (cda:low=Date of Onset, cda:high=Date Resolved), Optional R2 </xsl:comment>
                <effectiveTime>
                  <low value=""/>
                  <high value=""/>
                </effectiveTime>
                <xsl:comment> 7.05 TREATING PROVIDER id link to HealthCare Provider Entry </xsl:comment>
                <performer typeCode="PRF">
                  <assignedEntity>
                    <id extension="provider1" root="2.16.840.1.113883.4.349"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                  </assignedEntity>
                </performer>
                <xsl:comment> INFORMATION SOURCE FOR PROBLEM, Optional </xsl:comment>
                <author>
                  <xsl:comment> HITSP C32 V2.5:    Time as nullFlavor because VA VistA data not yet available </xsl:comment>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <representedOrganization>
                      <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR -->
                      <id extension="" root="2.16.840.1.113883.4.349"/>
                      <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                      <name></name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
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
                      <originalText>Problem Type Not Available</originalText>
                    </code>
                    <xsl:comment> 7.03 PROBLEM NAME, REQUIRED </xsl:comment>
                    <text>
                      <reference value="#pndProblem"/>
                    </text>
                    <statusCode code="completed"/>
                    <xsl:comment> HITSP V2.5:  IHE Problem Templates Require low value entry </xsl:comment>
                    <effectiveTime>
                      <low nullFlavor="UNK"/>
                    </effectiveTime>
                    <xsl:comment>  7.04 PROBLEM CODE, Optional, When uncoded only xsi:type="CD" allowed, Available as ICD-9, not SNOMED CT,  </xsl:comment>
                    <xsl:comment> HITSP V2.5:  IHE Problem Templates Require value entry </xsl:comment>
                    <value xsi:type="CD">
                      <translation code='' codeSystem='2.16.840.1.113883.6.103' codeSystemName='ICD-9-CM'/>
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
          </section>
        </component>
        <!-- 
			********************************************************
			MEDICATIONS (RX & Non-RX)  SECTION
			********************************************************
			-->
        <component>
          <xsl:comment> Component 3 </xsl:comment>
          <section>
            <xsl:comment> CCD Medication Template Id</xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.8"/>
            <xsl:comment> HITSP C32 V2.5:  Medications Section Template </xsl:comment>
            <templateId root="2.16.840.1.113883.3.88.11.83.112"/>
            <xsl:comment> HITSP C32 V2.5:  IHE Medications Section Template </xsl:comment>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.19"/>
            <code code="10160-0" codeSystem="2.16.840.1.113883.6.1"/>
            <title>Medications - Prescription and Non-Prescription</title>
            <!--  MEDICATIONS NARRATIVE BLOCK, REQUIRED -->
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
                    <td>This VA Document contains  all medications (outpatient and self-reported) for the patient, from all VA treatment facilities,  where the dispense date was within the last 15 months.   It only contains medications that have an active Prescription status.</td>
                  </tr>          
                </tbody>
              </table>
              <table ID="medicationNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Medication (Name)</th>
                    <th>Status</th>
                    <th>Quantity</th>
                    <th>Order Expiration (Date)</th>
                    <th>Provider</th>
                    <th>Prescription (Nbr)</th>
                    <th>Dispense Date</th>
                    <th>Sig</th>
                    <th>Source</th>
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
                      <content ID="mndQuantity" />
                    </td>
                    <td>
                      <content ID="mndOrderExpiration" />
                    </td>
                    <td>
                      <content ID="mndProvider" />
                    </td>
                    <td>
                      <content ID="mndPrescription" />
                    </td>
                    <td>
                      <content ID="mndDispenseDate" />
                    </td>
                    <td>
                      <content ID="mndSig" />
                    </td>
                    <td>
                      <content ID="mndSource" />
                    </td>
                  </tr>
                </tbody>
              </table>
            </text>
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
                  <reference value="#mndSig"/>
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
                      <code code="UNK" nullFlavor="UNK">
                        <originalText>
                          <reference value="#mndMedication"/>
                        </originalText>
                      </code>
                      <xsl:comment> 8.16 FREE TEXT BRAND NAME, Optional R2, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                    </manufacturedMaterial>
                  </manufacturedProduct>
                </consumable>
                <xsl:comment> INFORMATION SOURCE FOR MEDICATIONS, Optional </xsl:comment>
                <author>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                      <id extension="" root="2.16.840.1.113883.4.349"/>
                    <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                      <name></name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
                    </representedOrganization>
                  </assignedAuthor>
                </author>
                <entryRelationship typeCode='SUBJ'>
                  <observation classCode='OBS' moodCode='EVN'>
                    <templateId root='2.16.840.1.113883.3.88.11.83.8.1'/>
                    <xsl:comment> VLER SEG 1B:  8.19-TYPE OF MEDICATION, Optional-R2, SNOMED CT </xsl:comment>
                    <code codeSystem='2.16.840.1.113883.6.96' codeSystemName='SNOMED CT'>
                      <originalText/>
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
                      <originalText></originalText>
                    </value>
                  </observation>
                </entryRelationship>
                <xsl:comment> 8.22 PATIENT INSTRUCTIONS, Optional ,  Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                <!-- ORDER INFORMATION -->
                <entryRelationship typeCode="REFR">
                  <supply classCode="SPLY" moodCode="INT">
                    <templateId root="2.16.840.1.113883.10.20.1.34"/>
                    <templateId root='2.16.840.1.113883.3.88.11.83.8.3'/>
                    <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.7.3'/>
                    <xsl:comment> VLER SEG 1B:  8.26 ORDER NUMBER, Optional-R2  </xsl:comment>
                    <id extension="" root="2.16.840.1.113883.4.349"/>
                    <xsl:comment> 8.29 ORDER EXPIRATION DATE/TIME, Optional-R2 </xsl:comment>
                    <effectiveTime value="" xsi:type="SXCM_TS"/>
                    <xsl:comment> VLER SEG 1B:  8.27 FILLS, Optional </xsl:comment>
                    <repeatNumber value=''/>
                    <xsl:comment> VLER SEG 8.28 Quantity Ordered omitted until unit of measure available in VistA </xsl:comment>
                    <xsl:comment>  8.31 ORDERING PROVIDER as author/assignedAuthor</xsl:comment>
                    <author>
                      <xsl:comment>  VLER SEG 1B:  8.30 ORDER DATE/TIME, Optional-R2 </xsl:comment>
                      <time value=""/>
                      <assignedAuthor>
                        <id nullFlavor="UNK"/>
                        <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                        <addr></addr>
                        <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                        <telecom></telecom>
                        <assignedPerson>
                          <xsl:comment>  8.31 ORDERING PROVIDER, Optional </xsl:comment>
                          <name></name>
                        </assignedPerson>
                      </assignedAuthor>
                    </author>
                  </supply>
                </entryRelationship>
                <!-- FULFILLMENT HISTORY INFORMATION -->
                <entryRelationship typeCode="REFR">
                  <supply classCode="SPLY" moodCode="EVN">
                    <templateId root="2.16.840.1.113883.10.20.1.34"/>
                    <xsl:comment> 8.34 PRESCRIPTION NUMBER, Optional-R2 </xsl:comment>
                    <id extension="" root="2.16.840.1.113883.4.349"/>
                    <xsl:comment> 8.37 DISPENSE DATE, Optional-R2 </xsl:comment>
                    <effectiveTime value=""/>
                  </supply>
                </entryRelationship>
              </substanceAdministration>
            </entry>
          </section>
        </component>
        <!-- 
			********************************************************
			VLER SEG 1B:  VITAL SIGNS SECTION
			********************************************************
			-->
        <component>
          </sl:comment> Component 4 </xsl:comment>
          <section>
            <xsl:comment> HITSP C32 V2.5:  HL7 CCD Vital signs section template </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.16"/>
            <xsl:comment> HITSP C32 V2.5:  HITSP CDA Vital Signs Section Template </xsl:comment>
            <templateId root="2.16.840.1.113883.3.88.11.83.119"/>
            <xsl:comment> HITSP C32 V2.5:  IHE Coded Vital Signs Section Templates </xsl:comment>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.25"/>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"/>
            <xsl:comment> HITSP C32 V2.5:  HL7 CCD 8716-3 LOINC Code for Physical Findings/Vital Signs </xsl:comment>
            <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" displayName='VITAL SIGNS'
				/>
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
              <table ID="vitalNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Measurements</th>
                    <th>Source</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <content ID="vndDate" />
                    </td>
                    <td>
                      <list>
                        <item>
                          <content ID="vndMeasurement" />
                        </item>
                      </list>
                    </td>
                    <td>
                      <content ID="vndSource" />
                    </td>
                  </tr>
                </tbody>
              </table>
              <xsl:comment>  CDA Observation Text as a Reference tag </xsl:comment>
              <content ID="vital1" revised='delete' >Vital Sign Observation Text Not Available</content>
            </text>
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
                <effectiveTime value=""/>
                <xsl:comment> INFORMATION SOURCE FOR VITAL SIGN ORGANIZER/PANEL, Optional </xsl:comment>
                <author>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                      <id extension="" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                      <name></name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
                    </representedOrganization>
                  </assignedAuthor>
                </author>
                <xsl:comment> HITSP C32 V2.5:  One component block for each Vital Sign </xsl:comment>
                <component>
                  <xsl:comment> Repeat Component/Organizer block for each vital sign in the panel </xsl:comment>
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
                    <id root="2.16.840.1.113883.4.349" extension=""/>
                  <xsl:comment> HITSP C32 V2.5:  14.03-VITAL SIGN RESULT TYPE, REQUIRED, LOINC  </xsl:comment>
                    <code codeSystem="2.16.840.1.113883.6.1" >
                      <originalText />
                      <translation codeSystem="2.16.840.1.113883.6.233" codeSystemName="VHA Enterprise Reference Terminology" />
                    </code>
                    <xsl:comment> CDA based uses of Simple Observations Text element Required </xsl:comment>
                    <text>
                      <reference value="#vital1"/>
                    </text>
                    <xsl:comment> HITSP C32 V2.5:  14.04-VITAL SIGN RESULT STATUS, REQUIRED, Static value of completed  </xsl:comment>
                    <statusCode code="completed"/>
                    <xsl:comment> HITSP C32 V2.5:  14.02-VITAL SIGN RESULT DATE/TIME, REQURIED  </xsl:comment>
                    <xsl:comment> HITSP C32 V2.5: if blank, then effectiveTime nullFlavor="UNK" </xsl:comment>
                    <effectiveTime value=""/>
                    <xsl:comment> HITSP C32 V2.5:  14.05-VITAL SIGN RESULT VALUE, CONDITIONAL REQUIRED when moodCode=EVN  </xsl:comment>
                    <xsl:comment> 14.05-VITAL SIGN RESULT VALUE with Unit of Measure </xsl:comment>
                    <value xsi:type="PQ" />
                    <xsl:comment> 14.05-VITAL SIGN RESULT VALUE when Unit of Measure is blank then omit unit attribute</xsl:comment>
                    <xsl:comment> value xsi:type="PQ" value="" -->
                    <xsl:comment> HITSP C32 V2.5:  14.06-VITAL SIGN RESULT INTERPRETATION, Optional, HL7 Result Normalcy Status Value Set </xsl:comment>
                    <xsl:comment>  HITSP C32 V2.5:  14.06-VITAL SIGN RESULT INTERPRETATION, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                    <xsl:comment> HITSP C32 V2.5:  14.07-VITAL SIGN RESULT REFERENCE RANGE, Optional, </xsl:comment>
                    <xsl:comment>   HITSP C32 V2.5:  14.07-VITAL SIGN RESULT REFERENCE RANGE, Removed b/c data not yet available via VA VistA RPCs </xsl:comment>
                  </observation>
                </component>
              </organizer>
            </entry>
          </section>
        </component>
        <!-- 
			********************************************************
			VLER SEG 1B:  LAB RESULTS SECTION (Chemistry/Hematology)
			********************************************************
			-->
        <component>
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
              <table ID="labNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Date/Time</th>
                    <th>Result Type</th>
                    <th>Source</th>
                    <th>Result-Unit</th>
                    <th>Interpretation</th>
                    <th>Reference Range</th>
                    <th>Status</th>
                    <th>Comment</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
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
                    <td>
                      <content />
                    </td>
                    <td>
                      <content>completed</content>
                    </td>
                    <td>
                      <content />
                    </td>
                  </tr>
                </tbody>
              </table>
              <xsl:comment>  CDA Observation Text as a Reference tag </xsl:comment>
              <xsl:comment> IHE Simple Observations Text Element Required, For 15.03-LAB RESULT TYPE  Static "Observation Text Not Available" </xsl:comment>
              <content ID="lab-1" revised="delete">Result Observation Text Not Available</content>
              <!-- IHE Procedure Text Element Required,  Static "Procedure Text Not Available" -->
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
            <entry typeCode="DRIV">
              <xsl:comment> VLER 1Bii:  Lab Result Organizer, Reapeats for Each VA Order </xsl:comment>
              <organizer classCode="BATTERY" moodCode="EVN">
                <xsl:comment> HL7 CCD Lab Result Organizer Template, Required  </xsl:comment>
                <templateId root="2.16.840.1.113883.10.20.1.32"/>
                <!-- Lab Result Organizer Id -->
                <id root="2.16.840.1.113883.4.349" extension="labOrgId"/>
                <!-- Lab Result Organizer Code-->
                <code nullFlavor="UNK">
                  <originalText>orderName</originalText>
                </code>
                <!-- Lab Result Organizer Status, static-->
                <statusCode code="completed"/>
                <xsl:comment> Lab Result Organizer  Date/Time </xsl:comment>
                <effectiveTime value="19991114"/>
                <xsl:comment>Collected Date/Time </xsl:comment>
                <!-- INFORMATION SOURCE FOR LAB RESULT ORGANIZER, Optional -->
                <author>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <xsl:comment> INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) </xsl:comment>
                      <id extension="facilityNumber" root="2.16.840.1.113883.4.349"/>
                      <xsl:comment> INFORMATION SOURCE FACILITY NAME (facilityName) </xsl:comment>
                      <name>facilityName</name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
                    </representedOrganization>
                  </assignedAuthor>
                </author>
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
                    <id root="2.16.840.1.113883.4.349" extension=""/>
                    <xsl:comment> HITSP C32 V2.5:  15.03-LAB RESULT TYPE, REQUIRED, LOINC  </xsl:comment>
                    <xsl:comment> 15.03-LAB RESULT TYPE,  Adapter must obtain LOINC Code Long Common Name from LOINC DB  </xsl:comment>
                    <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
                      <originalText />
                    </code>
                    <xsl:comment> IHE Simple Observations Text element Required </xsl:comment>
                    <text>
                      <reference value="#lab-1"/>
                    </text>
                    <xsl:comment> HITSP C32 V2.5:  15.04-RESULT STATUS, REQUIRED, IHE Requires Static value of completed  </xsl:comment>
                    <statusCode code="completed"/>
                    <xsl:comment> HITSP C32 V2.5:  15.02-RESULT DATE/TIME, REQURIED  </xsl:comment>
                    <!-- HITSP C32 V2.5: if blank, then effectiveTime nullFlavor="UNK" -->
                    <effectiveTime value=""/>
                    <xsl:comment> HITSP C32 V2.5:  15.05- RESULT VALUE, CONDITIONAL REQUIRED when moodCode=EVN  </xsl:comment>
                    <xsl:comment> HITSP C32 V2.5:  15.05- RESULT VALUE, Sent as String (not INT) for VistA results that are POS, NEG, pending </xsl:comment>
                    <value xsi:type="ST" representation="TXT"></value>
                    <xsl:comment> HITSP C32 V2.5:  15.06-RESULT INTERPRETATION, Optional, Translation to HL7 Result Normalcy Status Value Set not yet available </xsl:comment>
                    <xsl:comment> If 15.06-RESULT INTERPRETATION is blank, omit XML tags </xsl:comment>
                    <!-- interpretationCode code="H" codeSystem="2.16.840.1.113883.1.11.78" codeSystemName="HL7 Result Normalcy Status Value Set" displayName="High"/ -->
                    <interpretationCode nullFlavor="UNK">
                      <originalText></originalText>
                    </interpretationCode>
                    <xsl:comment> COMMENT FOR LAB RESULT, Optional </xsl:comment>
                    <entryRelationship typeCode='SUBJ' inversionInd='true'>
                      <act classCode='ACT' moodCode='EVN'>
                        <templateId root='2.16.840.1.113883.10.20.1.40'/>
                        <templateId root='1.3.6.1.4.1.19376.1.5.3.1.4.2'/>
                        <code code='48767-8' displayName='Annotation Comment' codeSystem="2.16.840.1.113883.6.1" codeSystemName='LOINC' />
                        <xsl:comment> COMMENT REFERENCE points to Narrative Block </xsl:comment>
                        <text>
                          <reference value="#lndComment"/>
                        </text>
                        <statusCode code='completed' />
                        <author>
                          <time nullFlavor="UNK"/>
                          <assignedAuthor>
                            <id nullFlavor="NI"/>
                            <addr></addr>
                            <telecom></telecom>
                            <assignedPerson>
                              <name></name>
                            </assignedPerson>
                            <representedOrganization>
                              <name></name>
                              <telecom></telecom>
                              <addr></addr>
                            </representedOrganization>
                          </assignedAuthor>
                        </author>
                      </act>
                    </entryRelationship>
                    <xsl:comment> HITSP C32 V2.5: 15.07-RESULT REFERENCE RANGE, Optional, Lo:Hi </xsl:comment>
                    <xsl:comment> If 15.07-RESULT REFERENCE RANGE is blank, omit XML tags </xsl:comment>
                    <referenceRange>
                      <observationRange>
                        <text></text>
                      </observationRange>
                    </referenceRange>
                  </observation>
                </component>
              </organizer>
            </entry>
          </section>
        </component>
        <!-- 
				********************************************************
				VLER SEGMENT 1B:  IMMUNIZATION SECTION
				********************************************************
				-->
        <component>
          <xsl:comment> Component 6 </xsl:comment>
          <section>
            <xsl:comment> Immunizations section template </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.6"/>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.23"/>
            <templateId root="2.16.840.1.113883.3.88.11.83.117"/>

            <code code='11369-6' displayName=' History of immunizations ' codeSystem='2.16.840.1.113883.6.1' codeSystemName='LOINC'/>
            <title>Immunizations</title>
            <!--  IMMUNIZATIONS NARRATIVE BLOCK , REQUIRED -->
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
                    <td>This VA Document contains  all immunizations for the patient, from all VA treatment facilities.</td>
                  </tr>
                </tbody>
              </table>
              <table ID="immunizationNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Immunization (Name)</th>
                    <th>Series (Nbr)</th>
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
                    <!--manufacturedLabeledDrug></manufacturedLabeledDrug -->
                    <manufacturedMaterial>
                      <xsl:comment> 13.06-CODED PRODUCT NAME, Optional, nullFlavor b/c data not yet available thru VistA RPCs </xsl:comment>
                      <xsl:comment> HITSP C32 V2.5:  CODED PRODUCT NAME, Optional, Requires CVX-Vaccines Adminstered , VA provides CPT-4</xsl:comment>
                      <code code="UNK" nullFlavor="UNK" codeSystem="2.16.840.1.113883.6.59" codeSystemName="CVX">
                        <xsl:comment> 13.07-FREE TEXTPRODUCT NAME, REQUIRED, Pointer to Narrative Block  </xsl:comment>
                        <originalText>
                          <reference value="#indImmunization"/>
                        </originalText>
                        <translation code='' displayName='' codeSystem='2.16.840.1.113883.6.12' codeSystemName='Current Procedural Terminology (CPTï¿½) Fourth Edition (CPT-4)'></translation>
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
                    <!-- Provider ID, extension = Provider ID, root=VA OID  -->
                    <id extension="providerID" root="2.16.840.1.113883.4.349"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                  </assignedEntity>
                </performer>
                <xsl:comment> INFORMATION SOURCE FOR IMMUNIZATION, Optional </xsl:comment>
                <author>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedAuthor, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <!-- INFORMATION SOURCE FACILITY OID (ID = VA OID, EXT = TREATING FACILITY NBR) -->
                      <id extension="" root="2.16.840.1.113883.4.349"/>
                      <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                      <name></name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
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
                    <value xsi:type="INT"></value>
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
        <!-- 
			********************************************************
			NHIN_CR_101, CR100
			VLER Segment 1Bii:  ENCOUNTER SECTION 
           	********************************************************
			-->
        <component>
          <xsl:comment> Component 7 </xsl:comment>
          <section>
            <xsl:comment> CCD Encounters Section Conformance Identifier </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.3" />
            <xsl:comment> C83 Encounters Section Conformance Identifier </xsl:comment>
            <templateId root="2.16.840.1.113883.3.88.11.83.127" />
            <xsl:comment> IHE Encounters History Section Conformance Identifier </xsl:comment>
            <templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3" />
            <code code="46240-8" displayName="History of Encounters" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" />
            <title>History of Encounters</title>
            <!--  ENCOUNTER NARRATIVE BLOCK -->
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
              <table ID="encounterNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Date/Time</th>
                    <th>Encounter Type</th>
                    <th>Encounter Description</th>
                    <th>Reason</th>
                    <th>Arrival (date)</th>
                    <th>Departure (date)</th>
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
                <xsl:comment> CCD Encounter Activity </xsl:comment>
                <templateId root="2.16.840.1.113883.10.20.1.21" />
                <xsl:comment> C83 Encounter Entry </xsl:comment>
                <templateId root="2.16.840.1.113883.3.88.11.83.16"></templateId>
                <xsl:comment> IHE Encounter Entry </xsl:comment>
                <templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.14" />
                <xsl:comment> 16.01 - ENCOUNTER ID,  REQUIRED </xsl:comment>
                <id nullFlavor="UNK" />
                <xsl:comment>  <id root="2.16.840.1.113883.4.349" extension="enc1234"/></xsl:comment>
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
                <xsl:comment> 16.04 - ENCOUNTER DATE / TIME, REQUIRED </xsl:comment>
                <effectiveTime>
                  <low value="encTime" />
                </effectiveTime>
                <xsl:comment> 16.07 - ADMISSION TYPE, Optional,  VA VistA Data not yet available </xsl:comment>
                <priorityCode nullFlavor="UNK"/>
                <xsl:comment> 16.05 - ENCOUNTER PROVIDER, R2-Optional </xsl:comment>
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
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
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
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR -->
                      <id extension="facilityNumber" root="2.16.840.1.113883.4.349"/>
                      <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                      <name>facilityName</name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
                    </representedOrganization>
                  </assignedAuthor>
                </author>
                <xsl:comment> 16.06 - ADMISSION SOURCE, Optional, Not Yet Available from VA VistA </xsl:comment>
                <xsl:comment> 16.11 - FACILITY LOCATION, Optional </xsl:comment>
                <participant typeCode="LOC">
                  <templateId root="2.16.840.1.113883.10.20.1.45" />
                  <xsl:comment> 16.20 - IN FACILITY LOCATION DURATION, Optional </xsl:comment>
                  <time>
                    <xsl:comment> 16.12 - ARRIVAL DATE/TIME, Optional </xsl:comment>
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
                    <xsl:comment> 16.13 - REASON FOR VISIT, Optional </xsl:comment>
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
        <!-- 
			********************************************************
			NHIN_CR95, CR94
			VLER Segment 1Bii:  PROCEDURE SECTION 
			********************************************************
			-->
        <component>
          <xsl:comment> Component 8 </xsl:comment>
          <section>
            </xsl:comment> Procedures section template </xsl:comment>
            <templateId root="2.16.840.1.113883.10.20.1.12"/>
            <code code="47519-4" codeSystem="2.16.840.1.113883.6.1"/>
            <title>History of Procedures</title>
            <!-- PROCEDURE NARRATIVE BLOCK -->
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
                    <td>This VA Document contains all historical (completed), surgical and radiological Procedures for the patient, from all VA treatment facilities, where the Procedure Date was within the last 12 months, up to maximum of the most recent 25 procedures.</td>
                  </tr>
                </tbody>
              </table>
              <table ID="procedureNarrative" border="1" width="100%">
                <thead>
                  <tr>
                    <th>Date/Time</th>
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
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for iassignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                  </assignedEntity>
                </performer>
                <!-- INFORMATION SOURCE FOR PROCEDURE, Optional -->
                <author>
                  <time nullFlavor="UNK"/>
                  <assignedAuthor>
                    <id nullFlavor="NI"/>
                    <xsl:comment> HITSP C32 V2.5:   Address Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <addr></addr>
                    <xsl:comment> HITSP C32 V2.5:    Telecom Required for assignedEntity, but VA VistA data not yet available </xsl:comment>
                    <telecom></telecom>
                    <xsl:comment> HITSP C32 V2.5:   C83 author/assignedPerson/Name  Required but VA VistA data not yet available </xsl:comment>
                    <assignedPerson>
                      <name></name>
                    </assignedPerson>
                    <representedOrganization>
                      <!-- INFORMATION SOURCE FOR FACILITY ID=VA OID, EXT= VAMC TREATING FACILITY NBR -->
                      <id extension="facilityNumber" root="2.16.840.1.113883.4.349"/>
                      <!-- INFORMATION SOURCE FACILITY NAME (facilityName) -->
                      <name>facilityName</name>
                      <xsl:comment> HITSP C32 V2.5:    Telecom Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <telecom></telecom>
                      <xsl:comment> HITSP C32 V2.5:   Address Required for representedOrganization, but VA VistA data not yet available </xsl:comment>
                      <addr></addr>
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


