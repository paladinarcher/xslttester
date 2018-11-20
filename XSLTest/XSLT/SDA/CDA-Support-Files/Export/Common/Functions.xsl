<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="participant">
		<participant typeCode="IND">
			<xsl:apply-templates select="." mode="time"/>
			<xsl:apply-templates select="." mode="participantRole"/>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="participant-healthPlan">
		<participant typeCode="COV">
			<xsl:apply-templates select="." mode="time"/>
			<xsl:apply-templates select="." mode="participantRole-healthPlan"/>
		</participant>
	</xsl:template>

	<xsl:template match="*" mode="participant-healthPlanSubscriber">
		<participant typeCode="HLD">
			<xsl:apply-templates select="." mode="participantRole-healthPlanSubscriber"/>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="participantRole">
		<participantRole>
			<xsl:apply-templates select="." mode="id-Clinician"/>
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			<xsl:apply-templates select="." mode="telecom"/>
			<xsl:apply-templates select="." mode="playingEntity"/>
		</participantRole>
	</xsl:template>
	
	<xsl:template match="*" mode="playingEntity">
		<playingEntity>
			<xsl:apply-templates select="." mode="name-Person"/>
		</playingEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="participantRole-healthPlan">
		<participantRole classCode="PAT">
			<xsl:apply-templates select="." mode="id-PayerMember"/>
			<xsl:apply-templates select="PlanType" mode="code-healthPlanType"/>
			
			<!-- TODO: As of 10/20/2011 HS.SDA.HealthFund:InsuredRelationship -->
			<!-- is not stored in the HSDB. This field is required by an IHE  -->
			<!-- rule, according to the NIST Meaninful Use CDA validation.    -->
			<!-- Hard-code to SELF whenever that property is not available.   -->
			<!-- Valid code values are: FAMDEP, HANDIC, INJ, SELF, SPON STUD, FSTUD, PSTUD -->
			<xsl:choose>
				<xsl:when test="string-length(InsuredRelationship)">
					<code code="{InsuredRelationship/Code/text()}" displayName="{InsuredRelationship/Description/text()}" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode"/>
				</xsl:when>
				<xsl:otherwise>
					<code code="SELF" displayName="Self Pay" codeSystem="2.16.840.1.113883.5.111" codeSystemName="RoleCode"/>
				</xsl:otherwise>
			</xsl:choose>
						
			<addr nullFlavor="UNK"/>
			<telecom nullFlavor="UNK"/>
			
			<xsl:apply-templates select="//Patient[1]" mode="playingEntity-healthPlan"/>
		</participantRole>
	</xsl:template>

	<xsl:template match="*" mode="participantRole-healthPlanSubscriber">
		<participantRole>
			<id nullFlavor="UNK"/>
			<xsl:apply-templates select="." mode="address-HomePrimary"/>
			<xsl:apply-templates select="." mode="telecom"/>
			
			<xsl:variable name="subscriberInformation">
				<Subscriber xmlns="">
					<Name>
						<FamilyName><xsl:value-of select="InsuredName/FamilyName/text()"/></FamilyName>
						<GivenName><xsl:value-of select="InsuredName/GivenName/text()"/></GivenName>
						<MiddleName><xsl:value-of select="InsuredName/MiddleName/text()"/></MiddleName>
					</Name>
				</Subscriber>
			</xsl:variable>
			<xsl:variable name="subscriber" select="exsl:node-set($subscriberInformation)/Subscriber"/>
			
			<xsl:apply-templates select="$subscriber" mode="playingEntity-healthPlan"/>
		</participantRole>
	</xsl:template>
	
	<xsl:template match="*" mode="playingEntity-healthPlan">
		<playingEntity>
			<xsl:apply-templates select="." mode="name-Person"/>

			<xsl:choose>
				<xsl:when test="BirthTime"><sdtc:birthTime><xsl:attribute name="value"><xsl:apply-templates select="BirthTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></sdtc:birthTime></xsl:when>
				<xsl:otherwise><sdtc:birthTime nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
		</playingEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="performer">
		<performer typeCode="PRF">
			<xsl:apply-templates select="parent::node()" mode="time"/>
			<xsl:apply-templates select="." mode="assignedEntity-performer"/>
		</performer>
	</xsl:template>
	
	<xsl:template match="*" mode="performer-healthPlan">
		<performer typeCode="PRF">
			<xsl:apply-templates select="." mode="assignedEntity-healthPlan"/>
		</performer>
	</xsl:template>
	
	<xsl:template match="*" mode="informant">
		<informant>
			<xsl:apply-templates select="." mode="assignedEntity"/>
		</informant>
	</xsl:template>

	<xsl:template match="*" mode="informant-noPatientIdentifier">
		<informant>
			<xsl:apply-templates select="." mode="assignedEntity"><xsl:with-param name="includePatientIdentifier" select="false()"/></xsl:apply-templates>
		</informant>
	</xsl:template>

	<xsl:template match="*" mode="author-Document">
		<author typeCode="AUT">
			<time value="{$currentDateTime}"/>
			<xsl:apply-templates select="." mode="assignedAuthor-Document"/>
		</author>
	</xsl:template>

	<xsl:template match="*" mode="author-Human">
		<author typeCode="AUT">
			<xsl:choose>
				<xsl:when test="string-length(../EnteredOn)">
					<time><xsl:attribute name="value"><xsl:apply-templates select="../EnteredOn" mode="xmlToHL7TimeStamp"/></xsl:attribute></time>
				</xsl:when>
				<xsl:otherwise>
					<time nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="assignedAuthor-Human"/>
		</author>
	</xsl:template>

	<xsl:template match="*" mode="author-Device">
		<author typeCode="AUT">
			<time value="{$currentDateTime}"/>
			<xsl:apply-templates select="." mode="assignedAuthor-Device"/>
		</author>
	</xsl:template>
	
	<xsl:template match="*" mode="author-Code">
		<code nullFlavor="NA">
			<originalText><xsl:value-of select="text()"/></originalText>
		</code>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedEntity">
		<xsl:param name="includePatientIdentifier" select="true()"/>
		
		<assignedEntity>
			<!-- Contact Identifier -->
			<xsl:apply-templates select="." mode="id-Clinician"/>
			
			<!-- Entity Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>
			
			<!-- Assigned Person -->
			<xsl:apply-templates select="." mode="assignedPerson"/>
			
			<!-- Represented Organization -->
			<xsl:apply-templates select="." mode="representedOrganization"/>
			
			<!-- HITSP-specific patient extension, available today only for encountered data -->
			<xsl:if test="($includePatientIdentifier = true())"><xsl:call-template name="id-sdtcPatient"><xsl:with-param name="xpathContext" select="."/></xsl:call-template></xsl:if>
		</assignedEntity>
	</xsl:template>

	<xsl:template match="*" mode="assignedAuthor-Document">
		<assignedAuthor classCode="ASSIGNED">
			<id nullFlavor="UNK"/>
			<addr nullFlavor="UNK"/>
			<telecom nullFlavor="UNK"/>
			<assignedPerson><name nullFlavor="UNK"/></assignedPerson>
			
			<!-- Represented Organization -->
			<xsl:apply-templates select="." mode="representedOrganization-Document"/>
		</assignedAuthor>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedEntity-performer">
		<assignedEntity classCode="ASSIGNED">
			<!-- Contact Identifier -->
			<xsl:apply-templates select="." mode="id-Clinician"/>
			
			<!-- Entity Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>
			
			<!-- Assigned Person -->
			<xsl:apply-templates select="." mode="assignedPerson"/>			
		</assignedEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedEntity-healthPlan">
		<assignedEntity>
			<!-- Health Plan Identifier -->
			<xsl:apply-templates select="HealthFund" mode="id-Facility"/>
			
			<!-- TODO: As of 10/20/2011 it is unclear what SDA field should   -->
			<!-- map to this code element, which is required by IHE according -->
			<!-- to the NIST Meaningful Use CDA validation. Hard-code to GUAR -->
			<!-- for now.                                                     -->
			<code code="GUAR" displayName="Guarantor" codeSystem="2.16.840.1.113883.5.110" codeSystemName="RoleClass"/>
			
			<!-- Entity Address -->
			<xsl:apply-templates select="HealthFund" mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="HealthFund" mode="telecom"/>
			
			<!-- Organization -->
			<xsl:apply-templates select="HealthFund" mode="representedOrganization-HealthPlan"/>
		</assignedEntity>
	</xsl:template>
	
	<xsl:template name="id-sdtcPatient">
		<xsl:param name="xpathContext"/>
		
		<xsl:if test="$xpathContext = true()">
			<xsl:apply-templates select="$xpathContext[local-name() = 'Encounter' and (string-length(EnteredAt/Code/text()) and string-length(EncounterMRN/text()))]" mode="sdtc-Patient"/>

			<xsl:call-template name="id-sdtcPatient">
				<xsl:with-param name="xpathContext" select="$xpathContext/parent::node()"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Encounter" mode="sdtc-Patient">
		<sdtc:patient>
			<sdtc:id>
				<xsl:attribute name="root"><xsl:apply-templates select="EnteredAt/Code" mode="code-to-oid"><xsl:with-param name="identityType" select="'Facility'"></xsl:with-param></xsl:apply-templates></xsl:attribute>
				<xsl:attribute name="extension"><xsl:value-of select="EncounterMRN/text()"/></xsl:attribute>
			</sdtc:id>
		</sdtc:patient>
	</xsl:template>
	
	<xsl:template match="*" mode="associatedEntity">
		<xsl:param name="contactType"/>

		<associatedEntity classCode="{$contactType}">
			<!-- Contact Identifier -->
			<xsl:apply-templates select="." mode="id-Clinician"/>
			
			<!-- Relationship Type -->
			<xsl:apply-templates select="Relationship" mode="generic-Coded">
				<xsl:with-param name="requiredCodeSystemOID" select="'2.16.840.1.113883.5.111'"/>
				<xsl:with-param name="isCodeRequired" select="true()"/>
			</xsl:apply-templates>
		
			<!-- Entity Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>
			
			<!-- Associated Person -->
			<xsl:apply-templates select="." mode="associatedPerson"/>
			
			<!-- Scoping Organization -->
			<xsl:apply-templates select="EnteredAt" mode="scopingOrganization"/>
		</associatedEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedAuthor-Human">
		<assignedAuthor classCode="ASSIGNED">
			<!-- Clinician ID -->
			<xsl:apply-templates select="." mode="id-Clinician"/>

			<!-- HealthShare-specific author types -->
			<xsl:apply-templates select="Description[contains('|PAYER|PAYOR|PATIENT|', isc:evaluate('toUpper', text()))]" mode="author-Code"/>
			
			<!-- Author Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Author Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>

			<!-- Person -->
			<xsl:apply-templates select="." mode="assignedPerson"/>
						
			<!-- Represented Organization -->
			<xsl:apply-templates select="../EnteredAt" mode="representedOrganization"/>
		</assignedAuthor>
	</xsl:template>

	<xsl:template match="*" mode="assignedAuthor-Device">
		<assignedAuthor classCode="ASSIGNED">
			<!-- HealthShare ID -->
			<xsl:apply-templates select="." mode="id-HealthShare"/>
			
			<addr nullFlavor="UNK"/>
			<telecom nullFlavor="UNK"/>
			
			<!-- Software Device -->
			<xsl:apply-templates select="." mode="assignedAuthoringDevice"/>
			
			<!-- Represented Organization -->
			<xsl:apply-templates select="." mode="representedOrganization-Document"/>
		</assignedAuthor>
	</xsl:template>

	<xsl:template match="*" mode="assignedAuthoringDevice">
		<assignedAuthoringDevice>
			<softwareName>InterSystems HealthShare</softwareName>
		</assignedAuthoringDevice>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedPerson">
		<assignedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
		</assignedPerson>
	</xsl:template>

	<xsl:template match="*" mode="associatedPerson">
		<associatedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
		</associatedPerson>
	</xsl:template>
	
	<xsl:template match="*" mode="subject">
		<subject>
			<relatedSubject classCode="PRS">
				<xsl:apply-templates select="." mode="generic-Coded">
					<xsl:with-param name="requiredCodeSystemOID" select="'2.16.840.1.113883.5.111'"/>
					<xsl:with-param name="isCodeRequired" select="true()"/>
				</xsl:apply-templates>

				<subject>
					<name nullFlavor="UNK"/>
					<administrativeGenderCode nullFlavor="UNK"/>
					<birthTime nullFlavor="UNK"/>
				</subject>
			</relatedSubject>
		</subject>						
	</xsl:template>

	<xsl:template match="*" mode="name-Person">
		<xsl:choose>
			<xsl:when test="string-length(normalize-space(Description/text())) or Name">
				<xsl:variable name="contactName" select="normalize-space(Description/text())"/>
				<xsl:variable name="contactPrefix" select="Name/NamePrefix/text()"/>
				<xsl:variable name="contactFirstName" select="Name/GivenName/text()"/>
				<xsl:variable name="contactMiddleName" select="Name/MiddleName/text()"/>
				<xsl:variable name="contactLastName" select="Name/FamilyName/text()"/>
				<xsl:variable name="contactSuffix" select="Name/ProfessionalSuffix/text()"/>
				
				<xsl:choose>
					<xsl:when test="string-length($contactName) or string-length($contactFirstName) or string-length($contactLastName)">
						<name use="L">
							<xsl:if test="string-length($contactName)"><xsl:value-of select="$contactName"/></xsl:if>
							<xsl:if test="string-length($contactLastName)"><family><xsl:value-of select="$contactLastName"/></family></xsl:if>
							<xsl:if test="string-length($contactFirstName)"><given><xsl:value-of select="$contactFirstName"/></given></xsl:if>
							<xsl:if test="string-length($contactMiddleName)"><given><xsl:value-of select="$contactMiddleName"/></given></xsl:if>
							<xsl:if test="string-length($contactPrefix)"><prefix><xsl:value-of select="$contactPrefix"/></prefix></xsl:if>
							<xsl:if test="string-length($contactSuffix)"><suffix><xsl:value-of select="$contactSuffix"/></suffix></xsl:if>
						</name>
					</xsl:when>
					<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="address-Person">
		<xsl:choose>
			<xsl:when test="Address">
				<xsl:apply-templates select="Address[1]" mode="address-HomePrimary"/>
				<xsl:apply-templates select="following::Address[1]" mode="address-Home"/>
			</xsl:when>
			<xsl:otherwise><addr nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="address-WorkPrimary">
		<xsl:apply-templates select="." mode="address">
			<xsl:with-param name="addressUse">WP</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="address-HomePrimary">
		<xsl:apply-templates select="." mode="address">
			<xsl:with-param name="addressUse">HP</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="address-Home">
		<xsl:apply-templates select="." mode="address">
			<xsl:with-param name="addressUse">H</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="address">
		<xsl:param name="addressUse" select="'WP'"/>

		<xsl:choose>
			<xsl:when test="Address | InsuredAddress">
				<xsl:variable name="addressStreet" select="(Address|InsuredAddress)/Street/text()"/>
				<xsl:variable name="addressCity" select="(Address|InsuredAddress)/City/Code/text()"/>
				<xsl:variable name="addressState" select="(Address|InsuredAddress)/State/Code/text()"/>
				<xsl:variable name="addressZip" select="(Address|InsuredAddress)/Zip/Code/text()"/>
				<xsl:variable name="addressCountry" select="(Address|InsuredAddress)/Country/Code/text()"/>
				<xsl:variable name="addressStartDate"><xsl:apply-templates select="(Address|InsuredAddress)[1]/StartDate" mode="xmlToHL7TimeStamp"/></xsl:variable>
				<xsl:variable name="addressEndDate"><xsl:apply-templates select="(Address|InsuredAddress)[1]/EndDate" mode="xmlToHL7TimeStamp"/></xsl:variable>
				
				<xsl:choose>
					<xsl:when test="string-length($addressStreet) or string-length($addressCity) or string-length($addressState) or string-length($addressZip) or string-length($addressCountry)">
						<addr use="{$addressUse}">
							<xsl:if test="string-length($addressStreet)"><streetAddressLine><xsl:value-of select="$addressStreet"/></streetAddressLine></xsl:if>
							<xsl:if test="string-length($addressCity)"><city><xsl:value-of select="$addressCity"/></city></xsl:if>
							<xsl:if test="string-length($addressState)"><state><xsl:value-of select="$addressState"/></state></xsl:if>
							<xsl:if test="string-length($addressZip)"><postalCode><xsl:value-of select="$addressZip"/></postalCode></xsl:if>
							<xsl:if test="string-length($addressCountry)"><country><xsl:value-of select="$addressCountry"/></country></xsl:if>
							<xsl:if test="string-length($addressStartDate) or string-length($addressEndDate)">
								<useablePeriod xsi:type="IVL_TS">
									<xsl:choose>
										<xsl:when test="string-length($addressStartDate)"><low value="{$addressStartDate}"/></xsl:when>
										<xsl:otherwise><low nullFlavor="UNK"/></xsl:otherwise>
									</xsl:choose>
									
									<xsl:choose>
										<xsl:when test="string-length($addressEndDate)"><high value="{$addressEndDate}"/></xsl:when>
										<xsl:otherwise><high nullFlavor="UNK"/></xsl:otherwise>
									</xsl:choose>
								</useablePeriod>
							</xsl:if>
						</addr>
					</xsl:when>
					<xsl:otherwise><addr nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><addr nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="telecom">
		<xsl:choose>
			<xsl:when test="ContactInfo | InsuredContact">
				<xsl:variable name="telecomHomePhone" select="normalize-space((ContactInfo|InsuredContact)/HomePhoneNumber/text())"/>
				<xsl:variable name="telecomWorkPhone" select="normalize-space((ContactInfo|InsuredContact)/WorkPhoneNumber/text())"/>
				<xsl:variable name="telecomMobilePhone" select="normalize-space((ContactInfo|InsuredContact)/MobilePhoneNumber/text())"/>
				<xsl:variable name="telecomEmail" select="normalize-space((ContactInfo|InsuredContact)/EmailAddress/text())"/>
				
				<xsl:choose>
					<xsl:when test="string-length($telecomHomePhone) or string-length($telecomWorkPhone) or string-length($telecomMobilePhone) or string-length($telecomEmail)">
						<xsl:if test="string-length($telecomHomePhone)"><telecom use="HP" value="{concat('tel:', $telecomHomePhone)}"/></xsl:if>
						<xsl:if test="string-length($telecomWorkPhone)"><telecom use="WP" value="{concat('tel:', $telecomWorkPhone)}"/></xsl:if>
						<xsl:if test="string-length($telecomMobilePhone)"><telecom use="MC" value="{concat('tel:', $telecomMobilePhone)}"/></xsl:if>
						<xsl:if test="string-length($telecomEmail)"><telecom value="{concat('mailto:', $telecomEmail)}"/></xsl:if>
					</xsl:when>
					<xsl:otherwise><telecom nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><telecom nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="representedOrganization">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName"><xsl:apply-templates select="Code" mode="code-to-description"><xsl:with-param name="identityType" select="'Facility'"/></xsl:apply-templates></xsl:variable>
				
				<representedOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="telecom"/>
					<xsl:apply-templates select="." mode="address-WorkPrimary"/>					
										
					<xsl:if test="$homeCommunityOID or $homeCommunityCode or $homeCommunityName">
						<asOrganizationPartOf>
							<effectiveTime nullFlavor="UNK"/>
							<wholeOrganization>
								<xsl:apply-templates select="$homeCommunity/Organization" mode="id-Facility"/>

								<xsl:choose>
									<xsl:when test="string-length($homeCommunityName)"><name><xsl:value-of select="$homeCommunityName"/></name></xsl:when>
									<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
								</xsl:choose>
								
								<xsl:apply-templates select="$homeCommunity/Organization" mode="telecom"/>
								<xsl:apply-templates select="$homeCommunity/Organization" mode="address-WorkPrimary"/>
							</wholeOrganization>
						</asOrganizationPartOf>
					</xsl:if>
				</representedOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedOrganization>
					<id nullFlavor="UNK"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="UNK"/>
				</representedOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="representedOrganization-Document">
	
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName"><xsl:apply-templates select="Code" mode="code-to-description"><xsl:with-param name="identityType" select="'HomeCommunity'"/></xsl:apply-templates></xsl:variable>
				
				<representedOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="telecom"/>
					<xsl:apply-templates select="." mode="address-WorkPrimary"/>
					
				</representedOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedOrganization>
					<id nullFlavor="UNK"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="UNK"/>
				</representedOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="representedOrganization-HealthPlan">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName"><xsl:apply-templates select="Code" mode="code-to-description"><xsl:with-param name="identityType" select="'AssigningAuthority'"/></xsl:apply-templates></xsl:variable>
				
				<representedOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length(Description/text())"><name><xsl:value-of select="Description/text()"/></name></xsl:when>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="telecom"/>
					<xsl:apply-templates select="." mode="address-WorkPrimary"/>					
					
				</representedOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedOrganization>
					<id nullFlavor="UNK"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="UNK"/>
				</representedOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="representedCustodianOrganization">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName"><xsl:apply-templates select="Code" mode="code-to-description"><xsl:with-param name="identityType" select="'Facility'"/></xsl:apply-templates></xsl:variable>
				
				<representedCustodianOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="telecom"/>
					<xsl:apply-templates select="." mode="address-WorkPrimary"/>					
				</representedCustodianOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedCustodianOrganization>
					<id nullFlavor="UNK"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="UNK"/>
				</representedCustodianOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="scopingOrganization">
		<xsl:variable name="organizationName"><xsl:apply-templates select="Code" mode="code-to-description"/></xsl:variable>
		
		<scopingOrganization>
			<xsl:choose>			
				<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
				<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="." mode="telecom"/>
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
		</scopingOrganization>
	</xsl:template>
	
	<xsl:template match="*" mode="legalAuthenticator">
		<legalAuthenticator>
			<time value="{$currentDateTime}"/>
			<signatureCode code="S"/>
			
			<xsl:apply-templates select="." mode="assignedEntity"/>
		</legalAuthenticator>
	</xsl:template>
	
	<xsl:template match="*" mode="custodian">
		<custodian>
			<assignedCustodian>
				<xsl:apply-templates select="." mode="representedCustodianOrganization"/>
			</assignedCustodian>
		</custodian>
	</xsl:template>
	
	<xsl:template match="*" mode="code">
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>

		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<code code="{Code/text()}" codeSystem="{isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}">
					<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>

					<originalText>
						<xsl:choose>
							<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
						</xsl:choose>
					</originalText>

					<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
				</code>
			</xsl:when>
			<xsl:otherwise>
				<code nullFlavor="UNK"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="code-CD">
		<xsl:apply-templates select="." mode="code">
			<xsl:with-param name="xsiType">CD</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>

	<xsl:template match="*" mode="code-CE">
		<xsl:apply-templates select="." mode="code">
			<xsl:with-param name="xsiType">CE</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>
	
	<xsl:template match="*" mode="code-administrativeGender">
		<xsl:variable name="genderCode">
			<xsl:choose>
				<xsl:when test="starts-with(Gender/Code/text(),'M')">M</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'F')">F</xsl:when>
				<xsl:otherwise>UN</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="genderDescription">
			<xsl:choose>
				<xsl:when test="starts-with(Gender/Code/text(),'M')">Male</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'F')">Female</xsl:when>
				<xsl:otherwise>Undifferentiated</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Specs for administrativeGenderCode do not allow for <translation>. -->
		<administrativeGenderCode code="{$genderCode}" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="{$genderDescription}"/>
	</xsl:template>

	<xsl:template match="*" mode="code-maritalStatus">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.5.2</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">maritalStatusCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="code-race">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.6.238</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">raceCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="code-religiousAffiliation">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.5.1076</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">religiousAffiliationCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="code-function">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.12.443</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">functionCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="code-interpretation">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.5.83</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">interpretationCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="code-route">
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID">2.16.840.1.113883.3.26.1.1</xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">routeCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="code-healthPlanType">
		<!-- TODO: As of 10/20/2011 HS.SDA.HealthFund:PlanType is not  -->
		<!-- stored in the HSDB.  It is spec'd to be a String, which   -->
		<!-- is why this code converts it into CodeTableDetail format. -->
		<xsl:variable name="healthPlanTypeInformation">
			<PlanType xmlns="">
				<SDACodingStandard><xsl:value-of select="isc:evaluate('getOIDForCode', 'ISC-HealthShare', 'CodeSystem')"/></SDACodingStandard>
				<Code><xsl:value-of select="text()"/></Code>
				<Description><xsl:value-of select="text()"/></Description>
			</PlanType>
		</xsl:variable>
		<xsl:variable name="healthPlanType" select="exsl:node-set($healthPlanTypeInformation)/PlanType"/>
		
		<xsl:apply-templates select="$healthPlanType" mode="code"/>
	</xsl:template>
	
	<xsl:template match="*" mode="value-ST">
		<value xsi:type="ST"><xsl:value-of select="text()"/></value>	
	</xsl:template>
	
	<xsl:template match="*" mode="value-PQ">
		<xsl:param name="units"/>
		
		<!-- Results that are marked IsNumeric may still get exported -->
		<!-- as string. If the item is not actually numeric, or units -->
		<!-- is not specified, then export it as string.              -->
		<xsl:choose>
			<!-- If the item is numeric and units is specified, then export as PQ. -->
			<xsl:when test="(number(text()) and string-length($units))">
				<value xsi:type="PQ" value="{text()}" unit="{$units}"/>
			</xsl:when>
			<!-- If units is not specified then just export as string -->
			<!-- regardless of whether the item is numeric or not.    -->
			<xsl:when test="not(string-length($units))">
				<value xsi:type="ST"><xsl:value-of select="text()"/></value>
			</xsl:when>
			<!-- If the item is not numeric and units is specified -->
			<!-- then export as a string with units combined in.   -->
			<xsl:when test="string-length($units)">
				<value xsi:type="ST"><xsl:value-of select="concat(text(), ' ', $units)"/></value>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="value-Coded">
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>
		<xsl:param name="requiredCodeSystemOID"/>
		<xsl:param name="isCodeRequired"/>
	
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="$narrativeLink"/>
			<xsl:with-param name="xsiType" select="$xsiType"/>
			<xsl:with-param name="requiredCodeSystemOID" select="$requiredCodeSystemOID"/>
			<xsl:with-param name="isCodeRequired" select="$isCodeRequired"/>
			<xsl:with-param name="cdaElementName">value</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>
	
	<xsl:template match="*" mode="value-CD">
		<xsl:apply-templates select="." mode="value-Coded">
			<xsl:with-param name="xsiType">CD</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>

	<xsl:template match="*" mode="value-CE">
		<xsl:apply-templates select="." mode="value-Coded">
			<xsl:with-param name="xsiType">CE</xsl:with-param>
		</xsl:apply-templates>		
	</xsl:template>

	<xsl:template match="*" mode="value-IVL_PQ">
		<xsl:param name="referenceRangeLowValue"/>
		<xsl:param name="referenceRangeHighValue"/>
		<xsl:param name="referenceRangeUnits"/>
		
		<value xsi:type="IVL_PQ">
			<xsl:choose>
				<xsl:when test="string-length($referenceRangeLowValue) and string-length($referenceRangeUnits)"><low value="{$referenceRangeLowValue}" unit="{$referenceRangeUnits}"/></xsl:when>
				<xsl:when test="string-length($referenceRangeLowValue)"><low value="{$referenceRangeLowValue}"/></xsl:when>
				<xsl:otherwise><low nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length($referenceRangeHighValue) and string-length($referenceRangeUnits)"><high value="{$referenceRangeHighValue}" unit="{$referenceRangeUnits}"/></xsl:when>
				<xsl:when test="string-length($referenceRangeHighValue)"><high value="{$referenceRangeHighValue}"/></xsl:when>
				<xsl:otherwise><high nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
		</value>
	</xsl:template>

	<xsl:template match="*" mode="translation">
		<translation code="{Code/text()}" codeSystem="{isc:evaluate('getOIDForCode', CodeSystem/text(), 'CodeSystem')}" codeSystemName="{CodeSystem/text()}" displayName="{Description/text()}"/>
	</xsl:template>

	<xsl:template match="*" mode="id-External">
		<xsl:choose>
			<xsl:when test="string-length(EnteredAt/Code) and string-length(ExternalId)"><id root="{isc:evaluate('getOIDForCode', EnteredAt/Code/text(), 'Facility')}" extension="{ExternalId/text()}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-ExternalId')}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="id-Placer">
		<xsl:choose>
			<xsl:when test="string-length(EnteringOrganization/Organization/Code) and string-length(PlacerId)"><id root="{isc:evaluate('getOIDForCode', EnteringOrganization/Organization/Code/text(), 'Facility')}" extension="{PlacerId/text()}" assigningAuthorityName="{concat(EnteringOrganization/Organization/Code/text(), '-PlacerId')}"/></xsl:when>
			<xsl:when test="string-length(EnteredAt/Code) and string-length(PlacerId)"><id root="{isc:evaluate('getOIDForCode', EnteredAt/Code/text(), 'Facility')}" extension="{PlacerId/text()}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-PlacerId')}"/></xsl:when>
			<xsl:otherwise><id root="{isc:evaluate('createGUID')}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-UnspecifiedPlacerId')}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="id-Filler">
		<xsl:choose>
			<xsl:when test="string-length(EnteringOrganization/Organization/Code) and string-length(FillerId)"><id root="{isc:evaluate('getOIDForCode', EnteringOrganization/Organization/Code/text(), 'Facility')}" extension="{FillerId/text()}" assigningAuthorityName="{concat(EnteringOrganization/Organization/Code/text(), '-FillerId')}"/></xsl:when>
			<xsl:when test="string-length(EnteredAt/Code) and string-length(FillerId)"><id root="{isc:evaluate('getOIDForCode', EnteredAt/Code/text(), 'Facility')}" extension="{FillerId/text()}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-FillerId')}"/></xsl:when>
			<xsl:otherwise><id root="{isc:evaluate('createGUID')}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-UnspecifiedFillerId')}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="id-PrescriptionNumber">
		<xsl:choose>
			<xsl:when test="string-length(EnteredAt/Code) and string-length(PrescriptionNumber)"><id root="{isc:evaluate('getOIDForCode', EnteredAt/Code/text(), 'Facility')}" extension="{PrescriptionNumber/text()}" assigningAuthorityName="{concat(EnteredAt/Code/text(), '-PrescriptionNumber')}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="UNK" extension="{concat(EnteredAt/Code/text(), '-UnspecifiedPrescriptionNumber')}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="id-Facility">
		<xsl:variable name="facilityOID"><xsl:apply-templates select="Code" mode="code-to-oid"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<id>
					<xsl:attribute name="root"><xsl:value-of select="$facilityOID"/></xsl:attribute>
				</id>
				<!-- If code-to-oid yielded the same value as Code/text() then we're -->
				<!-- assuming we found no entry in the OID Registry for Code/text(). -->
				<!-- No point in exporting the extension in that case.               -->
				<xsl:if test="string-length(Code/text()) and string-length($facilityOID) and Code/text()!=$facilityOID">
					<id>
						<xsl:attribute name="root"><xsl:value-of select="$homeCommunityOID"/></xsl:attribute>
						<xsl:attribute name="extension"><xsl:value-of select="Code/text()"/></xsl:attribute>
						<xsl:attribute name="displayable">true</xsl:attribute>
					</id>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><id nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="id-Document">
		<id root="{isc:evaluate('createGUID')}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="id-Encounter">
		<id>
			<xsl:attribute name="root"><xsl:apply-templates select="HealthCareFacility/Organization/Code" mode="code-to-oid"/></xsl:attribute>
			<xsl:attribute name="extension"><xsl:value-of select="VisitNumber/text()"/></xsl:attribute>
			<xsl:attribute name="assigningAuthorityName"><xsl:value-of select="concat(HealthCareFacility/Organization/Code/text(), '-EncounterId')"/></xsl:attribute>
		</id>
	</xsl:template>

	<xsl:template match="*" mode="id-Clinician">
		<xsl:choose>
			<xsl:when test="string-length(SDACodingStandard) and string-length(Code)"><id root="{isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'Facility')}" extension="{Code/text()}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="id-HealthShare">
		<id root="{$healthShareOID}"/>
	</xsl:template>

	<xsl:template match="*" mode="id-PayerGroup">
		<!-- TODO: As of 10/20/2011 we do not store HS.SDA.HealthFund:GroupName -->
		<!-- or GroupNumber in the HSDB. Without those, this field will fail    -->
		<!-- validation based on an IHE rule.                                   -->
		<xsl:choose>
			<xsl:when test="string-length(GroupName) and string-length(GroupNumber)"><id root="{isc:evaluate('getOIDForCode', GroupName/text(), 'AssigningAuthority')}" extension="{GroupNumber/text()}" assigningAuthorityName="{concat(GroupName/text(), '-PayerGroupId')}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="id-PayerMember">
		<xsl:choose>
			<xsl:when test="string-length(HealthFund/Code) and string-length(MembershipNumber)"><id root="{isc:evaluate('getOIDForCode', HealthFund/Code/text(), 'AssigningAuthority')}" extension="{MembershipNumber/text()}" assigningAuthorityName="{concat(HealthFund/Code/text(), '-PayerMemberId')}"/></xsl:when>
			<xsl:when test="string-length(HealthFundPlan/HealthFund/Code) and string-length(MembershipNumber)"><id root="{isc:evaluate('getOIDForCode', HealthFundPlan/HealthFund/Code/text(), 'AssigningAuthority')}" extension="{MembershipNumber/text()}" assigningAuthorityName="{concat(HealthFundPlan/HealthFund/Code/text(), '-PayerMemberId')}"/></xsl:when>
			<xsl:otherwise><id nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="effectiveTime-IVL_TS">
		<xsl:choose>
			<xsl:when test="string-length(StartTime) or string-length(EndTime)">
				<effectiveTime xsi:type="IVL_TS">
					<xsl:apply-templates select="." mode="effectiveTime-low"/>
					<xsl:apply-templates select="." mode="effectiveTime-high"/>
				</effectiveTime>
			</xsl:when>
			<xsl:otherwise><effectiveTime xsi:type="IVL_TS" nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-PIVL_TS">
		<xsl:if test="string-length(normalize-space(Code/text()))">
			<!-- CDA Administration Timing (from SDA Frequency) needs a number (periodValue)   -->
			<!-- and a unit (periodUnit) to comprise an interval.  institutionSpecified serves -->
			<!-- as a breadcrumb when (re-)importing the CDA to indicate whether the database  -->
			<!-- stored data was actually an interval or a frequency.                          -->
			<!-- periodValue must be a number, and periodUnit must be a string without spaces. -->
			<!-- Despite its name, Frequency can be used to store any text, which means it     -->
			<!-- could have text that indicates an interval or a frequency.                    -->

			<xsl:variable name="codeNormal" select="normalize-space(Code/text())"/>
			<xsl:variable name="codeLower" select="isc:evaluate('toLower', $codeNormal)"/>
			<xsl:variable name="codeP1" select="isc:evaluate('piece', $codeLower, ' ', '1')"/>
			<xsl:variable name="codeP2" select="isc:evaluate('piece', $codeLower, ' ', '2')"/>
			<xsl:variable name="codeP3" select="isc:evaluate('piece', $codeLower, ' ', '3')"/>
			<xsl:variable name="singular" select="'|s|sec|second|min|minute|h|hr|hour|d|day|w|week|mon|month|y|yr|year|'"/>
			<xsl:variable name="plural" select="'|s|sec|secs|seconds|min|mins|minutes|h|hr|hrs|hour|hours|d|day|days|w|week|weeks|mon|mons|month|months|y|yr|yrs|year|years|'"/>

			<xsl:choose>
				<!-- ex: "4 hours" (interval) -->
				<xsl:when test="number($codeP1) and contains($plural, concat('|',$codeP2, '|'))">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="false" operator="A">
						<period value="{$codeP1}" unit="{$codeP2}"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- BID means twice a day (frequency) -->
				<xsl:when test="$codeP1='bid'">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="12" unit="h"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- TID means three times a day (frequency) -->
				<xsl:when test="$codeP1='tid'">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="8" unit="h"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- QID means four times a day (frequency) -->
				<xsl:when test="$codeP1='qid'">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="6" unit="h"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- nID means n times a day (frequency) -->
				<xsl:when test="contains($codeP1, 'id') and number(substring-before($codeP1, 'id'))">
					<xsl:variable name="numberOfTimes" select="substring-before($codeP1, 'id')"/>
					<xsl:variable name="periodValue" select="24 div $numberOfTimes"/>
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="{$periodValue}" unit="h"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- QOD means every other day (frequency) -->
				<xsl:when test="$codeP1='qod'">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="2" unit="d"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- every n seconds, minutes, hours, days, or weeks (interval) -->
				<xsl:when test="(starts-with($codeP1, 'qs') or starts-with($codeP1, 'qm') or starts-with($codeP1, 'qh') or starts-with($codeP1, 'qd') or starts-with($codeP1, 'qw')) and (number(substring($codeP1, 3)) or number($codeP2))">
					<xsl:variable name="periodValue">
						<xsl:choose>
							<xsl:when test="number(substring($codeP1, 3))"><xsl:value-of select="substring($codeP1, 3)"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$codeP2"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="false" operator="A">
						<period value="{$periodValue}" unit="{substring($codeP1,2,1)}"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- every n months (interval) -->
				<xsl:when test="starts-with($codeP1, 'ql') and number(substring($codeP1, 3))">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="false" operator="A">
						<period value="{substring($codeP1, 3)}" unit="mon"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- every n months (interval) -->
				<xsl:when test="starts-with($codeP1, 'ql') and number($codeP2)">
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="false" operator="A">
						<period value="{$codeP2}" unit="mon"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- ex: "4 per hour" (frequency) -->
				<xsl:when test="number($codeP1) and contains('|a|an|per|x|', concat('|',$codeP2, '|')) and contains($singular, concat('|',$codeP3, '|'))">
					<xsl:variable name="periodUnit1">
						<xsl:choose>
							<xsl:when test="starts-with($codeP3, 'h')">h</xsl:when>
							<xsl:when test="starts-with($codeP3, 'd')">d</xsl:when>
							<xsl:when test="starts-with($codeP3, 'w')">w</xsl:when>
							<xsl:when test="starts-with($codeP3, 'mon')">mon</xsl:when>
							<xsl:when test="starts-with($codeP3, 'y')">y</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodUnitN">
						<xsl:choose>
							<xsl:when test="starts-with($codeP3, 'h')">min</xsl:when>
							<xsl:when test="starts-with($codeP3, 'd')">h</xsl:when>
							<xsl:when test="starts-with($codeP3, 'w')">d</xsl:when>
							<xsl:when test="starts-with($codeP3, 'mon')">d</xsl:when>
							<xsl:when test="starts-with($codeP3, 'y')">d</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodValue">
						<xsl:choose>
							<xsl:when test="$codeP1='1'">1</xsl:when>
							<xsl:when test="$periodUnit1='h'"><xsl:value-of select="60 div $codeP1"/></xsl:when>
							<xsl:when test="$periodUnit1='d'"><xsl:value-of select="24 div $codeP1"/></xsl:when>
							<xsl:when test="$periodUnit1='w'"><xsl:value-of select="7 div $codeP1"/></xsl:when>
							<xsl:when test="$periodUnit1='mon'"><xsl:value-of select="round(30 div $codeP1)"/></xsl:when>
							<xsl:when test="$periodUnit1='y'"><xsl:value-of select="round(365 div $codeP1)"/></xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodUnit">
						<xsl:choose>
							<xsl:when test="$codeP1='1'"><xsl:value-of select="$periodUnit1"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$periodUnitN"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="{$periodValue}" unit="{$periodUnit}"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- ex: "4xD" (frequency) -->
				<xsl:when test="contains($codeP1, 'x') and not(string-length($codeP2)) and number(substring-before($codeP1, 'x')) and contains($singular, concat('|', substring-after($codeP1,'x'), '|'))">
					<xsl:variable name="tempValue" select="substring-before($codeP1,'x')"/>
					<xsl:variable name="tempUnit" select="substring-after($codeP1,'x')"/>
					<xsl:variable name="periodUnit1">
						<xsl:choose>
							<xsl:when test="starts-with($tempUnit, 'h')">h</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'd')">d</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'w')">w</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'mon')">mon</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'y')">y</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodUnitN">
						<xsl:choose>
							<xsl:when test="starts-with($tempUnit, 'h')">min</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'd')">h</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'w')">d</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'mon')">d</xsl:when>
							<xsl:when test="starts-with($tempUnit, 'y')">d</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodValue">
						<xsl:choose>
							<xsl:when test="$tempValue='1'">1</xsl:when>
							<xsl:when test="$periodUnit1='h'"><xsl:value-of select="60 div $tempValue"/></xsl:when>
							<xsl:when test="$periodUnit1='d'"><xsl:value-of select="24 div $tempValue"/></xsl:when>
							<xsl:when test="$periodUnit1='w'"><xsl:value-of select="7 div $tempValue"/></xsl:when>
							<xsl:when test="$periodUnit1='mon'"><xsl:value-of select="round(30 div $tempValue)"/></xsl:when>
							<xsl:when test="$periodUnit1='y'"><xsl:value-of select="round(365 div $tempValue)"/></xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="periodUnit">
						<xsl:choose>
							<xsl:when test="$tempValue='1'"><xsl:value-of select="$periodUnit1"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$periodUnitN"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
						<period value="{$periodValue}" unit="{$periodUnit}"/>
					</effectiveTime>
				</xsl:when>
				
				<!-- If we're out of scenarios from which we can reasonably deduce    -->
				<!-- the periodValue and periodUnit, then don't export effectiveTime. -->				
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-FromTo">
		<xsl:param name="includeHighTime" select="true()"/>
		
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(FromTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(ToTime/text()) and $includeHighTime = true()">
					<high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
				<xsl:when test="not(string-length(ToTime/text())) and $includeHighTime = true()">
					<high nullFlavor="UNK"/>
				</xsl:when>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-Identification">
		<xsl:param name="includeHighTime" select="true()"/>
		
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(IdentificationTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="IdentificationTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$includeHighTime = true()"><high nullFlavor="UNK"/></xsl:if>
		</effectiveTime>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-StartEnd">
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(StartTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="StartTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(EndTime/text())">
					<high><xsl:attribute name="value"><xsl:apply-templates select="EndTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
				<xsl:otherwise>
					<high nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime">
		<xsl:param name="includeHighTime" select="true()"/>
		
		<xsl:choose>
			<xsl:when test="local-name() = 'EnteredOn'"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="." mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:when test="local-name() = 'ObservationTime'"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="." mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:when test="local-name() = 'IdentificationTime'">
				<effectiveTime>
					<xsl:apply-templates select="." mode="effectiveTime-low"/>
					<xsl:if test="$includeHighTime = true()"><xsl:apply-templates select="." mode="effectiveTime-high"/></xsl:if>
				</effectiveTime>
			</xsl:when>
			<xsl:when test="not(string-length(EnteredOn)) and not(string-length(FromTime)) and not(string-length(StartTime)) and not(string-length(ToTime)) and not(string-length(EndTime))">
				<effectiveTime>
					<low nullFlavor="UNK"/>
					<xsl:if test="$includeHighTime = true()"><high nullFlavor="UNK"/></xsl:if>
				</effectiveTime>
			</xsl:when>
			<xsl:when test="string-length(EnteredOn) or (string-length(FromTime) or string-length(StartTime)) or (string-length(ToTime) or string-length(EndTime))">
				<effectiveTime>
					<xsl:if test="string-length(EnteredOn)"><xsl:attribute name="value"><xsl:apply-templates select="EnteredOn" mode="xmlToHL7TimeStamp"/></xsl:attribute></xsl:if>
					
					<xsl:apply-templates select="." mode="effectiveTime-low"/>
					<xsl:if test="$includeHighTime = true()"><xsl:apply-templates select="." mode="effectiveTime-high"/></xsl:if>
				</effectiveTime>
			</xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="time">
		<xsl:choose>
			<xsl:when test="local-name() = 'EnteredOn'"><time><xsl:attribute name="value"><xsl:apply-templates select="." mode="xmlToHL7TimeStamp"/></xsl:attribute></time></xsl:when>
			<xsl:when test="(string-length(FromTime) or string-length(StartTime) or string-length(EffectiveDate)) or (string-length(ToTime) or string-length(EndTime) or string-length(ExpirationDate))">
				<time>
					<xsl:apply-templates select="." mode="effectiveTime-low"/>
					<xsl:apply-templates select="." mode="effectiveTime-high"/>
				</time>
			</xsl:when>
			<xsl:otherwise><time nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-low">
		<xsl:choose>
			<xsl:when test="string-length(FromTime)"><low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
			<xsl:when test="string-length(StartTime)"><low><xsl:attribute name="value"><xsl:apply-templates select="StartTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
			<xsl:when test="string-length(EffectiveDate)"><low><xsl:attribute name="value"><xsl:apply-templates select="EffectiveDate" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
			<xsl:otherwise><low nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="effectiveTime-high">
		<xsl:choose>
			<xsl:when test="string-length(EndTime)"><high><xsl:attribute name="value"><xsl:apply-templates select="EndTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
			<xsl:when test="string-length(ToTime)"><high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
			<xsl:when test="string-length(ExpirationDate)"><high><xsl:attribute name="value"><xsl:apply-templates select="ExpirationDate" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
			<xsl:otherwise><high nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="xmlToHL7TimeStamp">
		<xsl:value-of select="translate(text(), 'TZ:- ', '')"/>
	</xsl:template>

	<xsl:template match="Encounter" mode="encounterLink-component">
		<xsl:variable name="isValidEncounter"><xsl:apply-templates select="EncounterType" mode="encounter-IsValid"/></xsl:variable>
		
		<xsl:if test="$isValidEncounter = 'true'">
			<component>
				<xsl:apply-templates select="." mode="encounterLink-Detail"/>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Encounter" mode="encounterLink-entryRelationship">
		<xsl:variable name="isValidEncounter"><xsl:apply-templates select="EncounterType" mode="encounter-IsValid"/></xsl:variable>
		
		<xsl:if test="$isValidEncounter = 'true'">
			<entryRelationship typeCode="SUBJ">
				<xsl:apply-templates select="." mode="encounterLink-Detail"/>
			</entryRelationship>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="encounterLink-Detail">
		<encounter classCode="ENC" moodCode="EVN">
			<id root="{isc:evaluate('getOIDForCode', HealthCareFacility/Organization/Code/text(), 'Facility')}" extension="{VisitNumber/text()}"/>
		</encounter>
	</xsl:template>

	<xsl:template match="EncounterType" mode="encounter-IsValid">
		<xsl:choose>
			<xsl:when test="contains('|I|O|E|', concat('|', text(), '|'))">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Encounter" mode="narrativeLink-EncounterSuffix">
		<xsl:param name="entryNumber"/>
		
		<xsl:value-of select="concat(translate(HealthCareFacility/Organization/Code/text(),' ','_'), '.', VisitNumber/text(), '.', $entryNumber)"/>
	</xsl:template>

	<xsl:template match="Code" mode="code-to-oid">
		<xsl:param name="identityType"/>
		
		<xsl:value-of select="isc:evaluate('getOIDForCode', text(), $identityType)"/>
	</xsl:template>	

	<xsl:template match="Code" mode="code-to-description">
		<xsl:param name="identityType"/>
		
		<xsl:value-of select="isc:evaluate('getDescriptionForOID', isc:evaluate('getOIDForCode', text(), $identityType), $identityType)"/>
	</xsl:template>
	
	<!-- snomed-Status is a special case value-Coded for    -->
	<!-- status fields that have to be SNOMED status codes. -->
	<xsl:template match="*" mode="snomed-Status">
		<xsl:param name="narrativeLink"/>
		
		<xsl:variable name="xsiType" select="'CE'"/>
		
		<xsl:variable name="sdaCodingStandardOID" select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/>
		
		<xsl:variable name="snomedStatusCodes">|55561003|73425007|90734009|7087005|255227004|415684004|410516002|413322009|</xsl:variable>
		<xsl:variable name="isValidSnomedCode" select="contains($snomedStatusCodes, concat('|', Code/text(), '|'))"/>
		
		<xsl:variable name="codeSystemOIDForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystemNameForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<!-- If we got SNOMED code system, and a valid SNOMED code, just export the data as is. -->
			<!-- OR -->
			<!-- If we got a valid SNOMED status code but not the SNOMED code system     -->
			<!-- then export with the SNOMED code system inserted, and add a translation -->
			<!-- that has the original data with the code system as received from SDA.   -->
			<xsl:when test="$isValidSnomedCode">
				<value code="{Code/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Description/text()}">
					<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
					
					<originalText><xsl:value-of select="Description/text()"/></originalText>
						
					<xsl:if test="$sdaCodingStandardOID != $snomedOID"><translation code="{Code/text()}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/></xsl:if>
					<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
				</value>
			</xsl:when>
			
			<!-- Otherwise, we did not get a valid SNOMED status code.  Try to find -->
			<!-- the one that is the closest fit, or just default it to Inactive.   -->
			<!-- Export with SNOMED code system, and export the original received   -->
			<!-- Status in a translation. -->
			<xsl:otherwise>
				<xsl:variable name="codeUpper" select="isc:evaluate('toUpper', Code/text())"/>
				<xsl:variable name="descUpper" select="isc:evaluate('toUpper', Description/text())"/>
				
				<xsl:variable name="codeValue">
					<xsl:choose>
						<xsl:when test="$codeUpper = 'A'">55561003</xsl:when>
						<xsl:when test="$codeUpper = 'C'">73425007</xsl:when>
						<xsl:when test="$codeUpper = 'H'">421139008</xsl:when>
						<xsl:when test="$codeUpper = 'IP'">55561003</xsl:when>
						<xsl:when test="$codeUpper = 'INT'">73425007</xsl:when>
						<xsl:when test="$codeUpper = 'D'">73425007</xsl:when>
						<xsl:when test="$codeUpper = 'E'">73425007</xsl:when>
						<xsl:when test="contains($descUpper, 'INACTIVE')">73425007</xsl:when>
						<xsl:when test="contains($descUpper, 'NO LONGER ACTIVE')">73425007</xsl:when>
						<xsl:when test="contains($descUpper, 'ACTIVE')">55561003</xsl:when>
						<xsl:when test="contains($descUpper, 'CHRONIC')">90734009</xsl:when>
						<xsl:when test="contains($descUpper, 'INTERMITTENT')">7087005</xsl:when>
						<xsl:when test="contains($descUpper, 'RECUR')">255227004</xsl:when>
						<xsl:when test="contains($descUpper, 'RULE OUT')">415684004</xsl:when>
						<xsl:when test="contains($descUpper, 'RULED OUT')">410516002</xsl:when>
						<xsl:when test="contains($descUpper, 'FOOD')">414285001</xsl:when>
						<xsl:when test="contains($descUpper, 'RESOLVED')">413322009</xsl:when>
						<xsl:when test="$codeUpper = 'R'">73425007</xsl:when>
						<xsl:otherwise>73425007</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="descValue">
					<xsl:choose>
						<xsl:when test="$codeUpper = 'A'">Active</xsl:when>
						<xsl:when test="$codeUpper = 'C'">No Longer Active</xsl:when>
						<xsl:when test="$codeUpper = 'H'">On Hold</xsl:when>
						<xsl:when test="$codeUpper = 'IP'">Active</xsl:when>
						<xsl:when test="$codeUpper = 'D'">No Longer Active</xsl:when>
						<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<value code="{$codeValue}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Description/text()}">
					<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
				<originalText><xsl:value-of select="Description/text()"/></originalText>
				
				<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/>
				<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
				</value>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	<!-- generic-Coded is intended to handle any coded element field. -->
	<xsl:template match="*" mode="generic-Coded">
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>
		<xsl:param name="requiredCodeSystemOID"/>
		<xsl:param name="isCodeRequired"/>
		<xsl:param name="writeOriginalText" select="'1'"/>
		<xsl:param name="cdaElementName" select="'code'"/>
		
		<!-- requiredCodeSystemOID is the OID of a specifically required codeSystem. -->
		<!-- isCodeRequired indicates whether or not code nullFlavor is allowed.     -->
		<!-- cdaElementName is the element (code, value, maritalStatusCode, etc.)    -->
		
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
			
				<xsl:variable name="sdaCodingStandardOID" select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/>
				<xsl:variable name="requiredCodeSystemName" select="isc:evaluate('getCodeForOID', $requiredCodeSystemOID, 'CodeSystem')"/>
				
				<xsl:variable name="codeSystemOIDForTranslation">
					<xsl:choose>
						<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="codeSystemNameForTranslation">
					<xsl:choose>
						<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="codeSystemOIDPrimary">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and $sdaCodingStandardOID!=$requiredCodeSystemOID"><xsl:value-of select="$requiredCodeSystemOID"/></xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and $isCodeRequired=true() and not(string-length($sdaCodingStandardOID))"><xsl:value-of select="$noCodeSystemOID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$sdaCodingStandardOID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="codeSystemNamePrimary" select="isc:evaluate('getCodeForOID', $codeSystemOIDPrimary, 'CodeSystem')"/>
				<xsl:variable name="addTranslation">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and $sdaCodingStandardOID!=$requiredCodeSystemOID">1</xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and not($isCodeRequired=true()) and not(string-length($sdaCodingStandardOID))">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="makeNullFlavor">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and not($isCodeRequired=true()) and $sdaCodingStandardOID!=$requiredCodeSystemOID">1</xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and not($isCodeRequired=true()) and not(string-length($sdaCodingStandardOID))">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:element name="{$cdaElementName}">
					<xsl:choose>
						<xsl:when test="$makeNullFlavor='1'">
							<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="code"><xsl:value-of select="translate(Code/text(),' ','_')"/></xsl:attribute>
							<xsl:attribute name="codeSystem"><xsl:value-of select="$codeSystemOIDPrimary"/></xsl:attribute>
							<xsl:attribute name="codeSystemName"><xsl:value-of select="$codeSystemNamePrimary"/></xsl:attribute>
							<xsl:if test="string-length(Description/text())"><xsl:attribute name="displayName"><xsl:value-of select="Description/text()"/></xsl:attribute></xsl:if>
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="$writeOriginalText='1'">
						<originalText>
							<xsl:choose>
								<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="Description/text()"/></xsl:otherwise>
							</xsl:choose>
						</originalText>
					</xsl:if>
					
					<xsl:if test="$addTranslation='1'"><translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{Description/text()}"/></xsl:if>
					<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
				</xsl:element>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="{$cdaElementName}">
					<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
					<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
