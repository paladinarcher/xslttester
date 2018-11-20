<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	<!--
		This AU version of Functions.xsl uses many templates
		that are in the "base" Result.xsl.  Pointer comments for
		these templates are located within the code here.
	-->
	
	<!-- Keys to encounter data -->
	<xsl:key name="EncNum" match="Encounter" use="EncounterNumber"/>
	
	<!-- <xsl:template match="*" mode="participant"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="participant-healthPlan"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="participant-healthPlanSubscriber"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="participantRole"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="playingEntity"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="participantRole-healthPlan"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="participantRole-healthPlanSubscriber"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="playingEntity-healthPlan"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="performer">
		<xsl:if test="$documentExportType='NEHTAeDischargeSummary' or $documentExportType='NEHTASharedHealthSummary'">
			<performer typeCode="PRF">
				<xsl:apply-templates select="parent::node()" mode="time"/>
				<xsl:apply-templates select="." mode="assignedEntity-performer"/>
			</performer>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="performer-healthPlan"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="informant"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="informant-noPatientIdentifier"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="author-Document">
		<!--
			This AU version of author-Document is a copy of
			the standard author-Human, with a change to the
			assignedAuthor template call.
		-->
		<author typeCode="AUT">
			<xsl:choose>
				<xsl:when test="string-length(../EnteredOn)">
					<time><xsl:attribute name="value"><xsl:apply-templates select="../EnteredOn" mode="xmlToHL7TimeStamp"/></xsl:attribute></time>
				</xsl:when>
				<xsl:otherwise>
					<time nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="." mode="assignedAuthor-Document"/>
		</author>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="author-Human"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="author-Device"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="author-Code"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="assignedEntity"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="assignedAuthor-Document">
		<!--
			This AU version of assignedAuthor-Document is a copy
			of the standard assignedAuthor-Human, with some changes.
		-->
		<assignedAuthor classCode="ASSIGNED">
			<!-- Clinician ID -->
			<xsl:apply-templates select="." mode="id-Clinician"/>

			<!--
				For AU, document author comes from /Container/Patient/EnteredBy.
				Therefore it will not have a CareProviderType property, and so will
				get a default value for document author role/occupation code.
				See careProviderType-ANZSCO.
			-->
			<xsl:apply-templates select="." mode="careProviderType-ANZSCO"/>
			
			<!-- Author Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Author Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>

			<!-- Person -->
			<xsl:apply-templates select="." mode="assignedPerson-Document"/>
						
			<!-- Represented Organization -->
			<xsl:apply-templates select="../EnteredAt" mode="representedOrganization"/>
		</assignedAuthor>
	</xsl:template>
	
	
	<xsl:template match="*" mode="assignedEntity-performer">
		<assignedEntity classCode="ASSIGNED">
			<!-- Contact Identifier -->
			<xsl:apply-templates select="." mode="id-Clinician"/>
			
			<!--
				For AU, assignedEntity performer comes from an EnteredBy
				property.  Therefore it will not have a CareProviderType property,
				and so will get a default value for document author role/occupation
				code. See careProviderType-ANZSCO.
			-->
			<xsl:apply-templates select="." mode="careProviderType-ANZSCO"/>
			
			<!-- Entity Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>
			
			<!-- Assigned Person -->
			<xsl:apply-templates select="." mode="assignedPerson"/>
		</assignedEntity>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="assignedEntity-healthPlan"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="assignedEntity-encounterParticipant">
		<assignedEntity classCode="ASSIGNED">
			<!-- Contact Identifier -->
			<xsl:apply-templates select="." mode="id-Clinician"/>
			
			<!--
				Admitting, Attending and Consulting clinicians
				are CareProvider, which includes CareProviderType, which
				enables the specification of valid ANZSCO role/occupation
				data.  However, Referring clinician does not, and will be
				given a default value.  See careProviderType-ANZSCO.
			-->
			<xsl:apply-templates select="." mode="careProviderType-ANZSCO"/>
			
			<!-- Entity Address -->
			<xsl:apply-templates select="." mode="address-WorkPrimary"/>
			
			<!-- Entity Telecom -->
			<xsl:apply-templates select="." mode="telecom"/>
			
			<!-- Assigned Person -->
			<xsl:apply-templates select="." mode="assignedPerson"/>
		</assignedEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedEntity-LegalAuthenticator">
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
			<xsl:apply-templates select="$homeCommunity/Organization" mode="representedOrganization"/>
		</assignedEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="id-sdtcPatient">
		<xsl:param name="xpathContext"/>
		<!-- NEHTA does not allow for exporting sdtc:patient. -->
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="associatedEntity"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="assignedAuthor-Human"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="assignedAuthor-Device"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="assignedAuthoringDevice"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="assignedPerson">
		<assignedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
			<xsl:apply-templates select="." mode="asEntityIdentifier-Person"/>
		</assignedPerson>
	</xsl:template>
	
	<xsl:template match="*" mode="assignedPerson-Document">
		<assignedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
			<xsl:apply-templates select="." mode="asEntityIdentifier-Person"/>
			<!-- ext:asEmployment - Use EnteredAt. -->
			<xsl:if test="$documentExportType='NEHTASharedHealthSummary' or $documentExportType='NEHTAEventSummary' or $documentExportType='NEHTAeReferral'">
				<xsl:apply-templates select="../EnteredAt" mode="employment"/>
			</xsl:if>
		</assignedPerson>
	</xsl:template>
	
	<xsl:template match="*" mode="associatedPerson">
		<associatedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
			<xsl:apply-templates select="." mode="asEntityIdentifier-Person"/>
		</associatedPerson>
	</xsl:template>
	
	<xsl:template match="*" mode="associatedPerson-Referee">
		<associatedPerson>
			<xsl:apply-templates select="." mode="name-Person"/>
			<xsl:apply-templates select="." mode="asEntityIdentifier-Person"/>
			<xsl:apply-templates select="../ReferredToOrganization/Organization" mode="employment"/>
		</associatedPerson>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="subject"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="name-Person">
		<!--
			AU requires that at least family name have a value.
			If Name/FamilyName/text() is not present then try
			to parse it from Description/text().
		-->
		<xsl:variable name="normalizedDescription" select="normalize-space(Description/text())"/>
		<xsl:choose>
			<xsl:when test="string-length($normalizedDescription) or Name">
				<xsl:variable name="contactName" select="$normalizedDescription"/>
				<xsl:variable name="contactPrefix" select="Name/NamePrefix/text()"/>
				<xsl:variable name="contactFirstName">
					<xsl:choose>
						<xsl:when test="string-length(Name/GivenName/text())">
							<xsl:value-of select="Name/GivenName/text()"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,',')">
							<xsl:value-of select="substring-after($normalizedDescription,',')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription)">
							<xsl:value-of select="substring-before($normalizedDescription,' ')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="contactMiddleName" select="Name/MiddleName/text()"/>
				<xsl:variable name="contactLastName">
					<xsl:choose>
						<xsl:when test="string-length(Name/FamilyName/text())">
							<xsl:value-of select="Name/FamilyName/text()"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,',')">
							<xsl:value-of select="substring-before($normalizedDescription,',')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,' ')">
							<xsl:value-of select="substring-after($normalizedDescription,' ')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription)">
							<xsl:value-of select="$normalizedDescription"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>

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
	
	<xsl:template match="*" mode="name-Person-Narrative">
		<!--
			AU requires that person names in the narrative
			be formatted as: Name Title(s), Given Name(s),
			Family Name(s), Name Suffix(es).
		-->
		<xsl:variable name="normalizedDescription" select="normalize-space(Description/text())"/>
		<xsl:choose>
			<xsl:when test="string-length($normalizedDescription) or Name">
				<xsl:variable name="contactName" select="$normalizedDescription"/>
				<xsl:variable name="contactPrefix" select="Name/NamePrefix/text()"/>
				<xsl:variable name="contactFirstName">
					<xsl:choose>
						<xsl:when test="string-length(Name/GivenName/text())">
							<xsl:value-of select="Name/GivenName/text()"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,',')">
							<xsl:value-of select="substring-after($normalizedDescription,',')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription)">
							<xsl:value-of select="substring-before($normalizedDescription,' ')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="contactMiddleName" select="Name/MiddleName/text()"/>
				<xsl:variable name="contactLastName">
					<xsl:choose>
						<xsl:when test="string-length(Name/FamilyName/text())">
							<xsl:value-of select="Name/FamilyName/text()"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,',')">
							<xsl:value-of select="substring-before($normalizedDescription,',')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription) and contains($normalizedDescription,' ')">
							<xsl:value-of select="substring-after($normalizedDescription,' ')"/>
						</xsl:when>
						<xsl:when test="string-length($normalizedDescription)">
							<xsl:value-of select="$normalizedDescription"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="contactSuffix" select="Name/ProfessionalSuffix/text()"/>
				
				<xsl:variable name="displayName">
					<xsl:if test="string-length($contactName) or string-length($contactFirstName) or string-length($contactLastName)">
						<xsl:if test="string-length($contactPrefix)"><xsl:value-of select="concat($contactPrefix,' ')"/></xsl:if>
						<xsl:if test="string-length($contactFirstName)"><xsl:value-of select="concat($contactFirstName,' ')"/></xsl:if>
						<xsl:if test="string-length($contactMiddleName)"><xsl:value-of select="concat($contactMiddleName,' ')"/></xsl:if>
						<xsl:if test="string-length($contactLastName)"><xsl:value-of select="concat($contactLastName,' ')"/></xsl:if>
						<xsl:if test="string-length($contactSuffix)"><xsl:value-of select="$contactSuffix"/></xsl:if>
					</xsl:if>
				</xsl:variable>
				
				<xsl:value-of select="normalize-space($displayName)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="addresses-Patient"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="address-Patient"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="address-Person"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="address-WorkPrimary"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="address-HomePrimary">
		<!-- For AU, there is no address use "HP", only "H". -->
		<xsl:apply-templates select="." mode="address-Home"/>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="address-Home"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="address-Postal">
		<xsl:apply-templates select="." mode="address">
			<xsl:with-param name="addressUse">PST</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="address"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="address-Individual"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="address-streetLine"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="address-country">
		<!-- For AU, country must match a Name (not Code) from ISO3166-1 -->
		<xsl:variable name="addressCountry1" select="text()"/>
		<xsl:variable name="addressCountry2" select="translate($addressCountry1,$lowerCase,$upperCase)"/>
		<xsl:choose>
			<xsl:when test="$addressCountry2 = 'AUSTRALIA'">Australia</xsl:when>
			<xsl:when test="$addressCountry2 = 'AU'">Australia</xsl:when>
			<xsl:when test="$addressCountry2 = 'AUS'">Australia</xsl:when>
			<xsl:when test="$addressCountry2 = 'USA'">United States of America</xsl:when>
			<xsl:when test="$addressCountry2 = 'US'">United States of America</xsl:when>
			<xsl:when test="$addressCountry2 = 'UNITED STATES'">United States of America</xsl:when>
			<xsl:otherwise><xsl:value-of select="$addressCountry1"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="telecom"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="representedOrganization"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="representedOrganization-Document"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="representedOrganization-HealthPlan"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="representedCustodianOrganization"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="scopingOrganization"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="representedOrganization-Recipient">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName">
					<xsl:apply-templates select="Code" mode="code-to-description">
						<xsl:with-param name="identityType" select="'Facility'"/>
						<xsl:with-param name="defaultDescription" select="Description/text()"/>
					</xsl:apply-templates>
				</xsl:variable>
				
				<representedOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="Organization">
						<asOrganizationPartOf>
							<effectiveTime nullFlavor="UNK"/>
							<wholeOrganization>
								<xsl:apply-templates select="Organization/Code" mode="id-Facility"/>

								<xsl:choose>
									<xsl:when test="string-length(Organization/Description/text())"><name><xsl:value-of select="Organization/Description/text()"/></name></xsl:when>
									<xsl:when test="string-length(Organization/Code/text())"><name><xsl:value-of select="Organization/Code/text()"/></name></xsl:when>
									<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
								</xsl:choose>
								
								<xsl:apply-templates select="Organization" mode="asEntityIdentifier-Organization"/>
							</wholeOrganization>
						</asOrganizationPartOf>
					</xsl:if>
				</representedOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedOrganization>
					<id nullFlavor="{$idNullFlavor}"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="{$addrNullFlavor}"/>
				</representedOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="serviceProviderOrganization">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName">
					<xsl:apply-templates select="Code" mode="code-to-description">
						<xsl:with-param name="identityType" select="'Facility'"/>
						<xsl:with-param name="defaultDescription" select="Description/text()"/>
					</xsl:apply-templates>
				</xsl:variable>
				
				<serviceProviderOrganization>
					<xsl:apply-templates select="." mode="id-Facility"/>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)"><name><xsl:value-of select="$organizationName"/></name></xsl:when>
						<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="telecom"/>
					<xsl:apply-templates select="." mode="address-WorkPrimary"/>
										
					<xsl:if test="Organization">
						<asOrganizationPartOf>
							<effectiveTime nullFlavor="UNK"/>
							<wholeOrganization>
								<xsl:apply-templates select="Organization/Code" mode="id-Facility"/>

								<xsl:choose>
									<xsl:when test="string-length(Organization/Description/text())"><name><xsl:value-of select="Organization/Description/text()"/></name></xsl:when>
									<xsl:when test="string-length(Organization/Code/text())"><name><xsl:value-of select="Organization/Code/text()"/></name></xsl:when>
									<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
								</xsl:choose>
								
								<xsl:apply-templates select="Organization" mode="telecom"/>
								<xsl:apply-templates select="Organization" mode="address-WorkPrimary"/>
								<xsl:apply-templates select="Organization" mode="asEntityIdentifier-Organization"/>
							</wholeOrganization>
						</asOrganizationPartOf>
					</xsl:if>
				</serviceProviderOrganization>
			</xsl:when>
			<xsl:otherwise>
				<serviceProviderOrganization>
					<id nullFlavor="{$idNullFlavor}"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="{$addrNullFlavor}"/>
				</serviceProviderOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="legalAuthenticator">
		<legalAuthenticator>
			<time value="{$currentDateTime}"/>
			<signatureCode code="S"/>
			
			<xsl:apply-templates select="." mode="assignedEntity-LegalAuthenticator"/>
		</legalAuthenticator>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="custodian"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-CD"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-CE"> SEE BASE TEMPLATE -->
	

	<xsl:template match="*" mode="code-administrativeGender">
		<xsl:variable name="genderCode">
			<xsl:choose>
				<xsl:when test="starts-with(Gender/Code/text(),'M')">M</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'F')">F</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'I')">I</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="genderDescription">
			<xsl:choose>
				<xsl:when test="starts-with(Gender/Code/text(),'M')">Male</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'F')">Female</xsl:when>
				<xsl:when test="starts-with(Gender/Code/text(),'I')">Intersex or Indeterminate</xsl:when>
				<xsl:otherwise>Not Stated/Inadequately Described</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- administrativeGenderCode does not allow for <translation>. -->
		<administrativeGenderCode code="{$genderCode}" codeSystem="2.16.840.1.113883.13.68" codeSystemName="AS 5017-2006 Health Care Client Identifier Sex" displayName="{$genderDescription}"/>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="code-maritalStatus"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-race"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-religiousAffiliation"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-function"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-interpretation"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-route"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-healthPlanType"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-ST"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-PQ"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-Coded"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-CD"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-CE"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="value-IVL_PQ"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="translation"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-External"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-Placer"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-Filler"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-ExternalPlacerOrFiller"> SEE BASE TEMPLATE -->
	
	<xsl:template match="*" mode="id-Medication">
		<xsl:apply-templates select="." mode="id-ExternalPlacerOrFiller"/>
	</xsl:template>
	
	<!-- <xsl:template match="*" mode="id-PrescriptionNumber"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-Facility"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-Document"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-Encounter"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="id-Clinician">
		<!-- For AU, include special logic for HPI-I information. -->
		<xsl:variable name="sdaCodingStandardOID">
			<xsl:choose>
				<xsl:when test="string-length(SDACodingStandard/text())">
					<xsl:apply-templates select="." mode="oid-for-code">
						<xsl:with-param name="Code" select="SDACodingStandard/text()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length(SDACodingStandard/text()) and string-length(Code/text())">
				<id root="{$sdaCodingStandardOID}" extension="{Code/text()}"/>
			</xsl:when>
			<xsl:when test="starts-with(Code/text(),concat($hiServiceOID,'.',$hpiiPrefix))">
				<id root="{Code/text()}"/>
			</xsl:when>
			<xsl:when test="starts-with($sdaCodingStandardOID,concat($hiServiceOID,'.',$hpiiPrefix))">
				<id root="{$sdaCodingStandardOID}"/>
			</xsl:when>
			<xsl:otherwise><id root="{isc:evaluate('createUUID')}"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="id-HealthShare"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-PayerGroup"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="id-PayerMember"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="effectiveTime-IVL_TS"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="effectiveTime-PIVL_TS"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="effectiveTime-FromTo">
		<xsl:param name="includeHighTime" select="true()"/>
		
		<!-- AU wants a value or nothing at all. No nullFlavor. -->
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(FromTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(ToTime/text()) and $includeHighTime = true()">
					<high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="effectiveTime-Identification"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="effectiveTime-procedure"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="effectiveTime"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="time"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="effectiveTime-low">
		<!-- AU wants a value or nothing at all. No nullFlavor. -->
		<xsl:choose>
			<xsl:when test="string-length(FromTime)"><low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
			<xsl:when test="string-length(StartTime)"><low><xsl:attribute name="value"><xsl:apply-templates select="StartTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="effectiveTime-high">
		<!-- AU wants a value or nothing at all. No nullFlavor. -->
		<xsl:choose>
			<xsl:when test="string-length(EndTime)"><high><xsl:attribute name="value"><xsl:apply-templates select="EndTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
			<xsl:when test="string-length(ToTime)"><high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="xmlToHL7TimeStamp">
		<!--
			AU requires a time zone on a time stamp that is more
			definite than just a date.  xmlToHL7TimeStamp assumes that
			text() is HS.SDA3.TimeStamp and does not have a time zone
			already included.
		-->
		<xsl:variable name="hl7TimeStamp" select="translate(text(), 'TZ:- ', '')"/>
		<xsl:choose>
			<xsl:when test="string-length($hl7TimeStamp)>8"><xsl:value-of select="concat($hl7TimeStamp,$currentTimeZoneOffset)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$hl7TimeStamp"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="encounterLink-component"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounterLink-entryRelationship"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounterLink-Detail"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="EncounterType" mode="encounter-IsValid"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="narrativeLink-EncounterSuffix"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="Code" mode="code-to-oid"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="Code" mode="code-to-description"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="snomed-Status"> SEE BASE TEMPLATE -->
	
	
	<!-- generic-Coded has common logic for handling coded element fields. -->
	<xsl:template match="*" mode="generic-Coded">
		<xsl:param name="xsiType"/>
		<xsl:param name="writeOriginalText" select="'1'"/>
		<xsl:param name="cdaElementName" select="'code'"/>
		<xsl:param name="hsCustomPairElementName"/>
		
		<!--
			requiredCodeSystemOID is the OID of a specifically required codeSystem.
			requiredCodeSystemOID may be multiple OIDs, delimited by vertical bar.
			
			isCodeRequired indicates whether or not code nullFlavor is allowed.
			
			cdaElementName is the element (code, value, maritalStatusCode, etc.)
		-->
		
		<!--
			For AU, narrativeLink, requiredCodeSystemOID, and isCodeRequired are
			hard-coded variables instead of parameters, in order to accomplish the
			following:
			- Write no reference links in originalText
			- Write no translation elements, just use SDACodingStandardOID as is, or $noCodeSystemOID
			- Write no nullFlavor for code elements
		-->
		<xsl:variable name="narrativeLink" select="''"/>
		<xsl:variable name="requiredCodeSystemOID" select="''"/>
		<xsl:variable name="isCodeRequired" select="'1'"/>
		
		<xsl:variable name="code">
			<xsl:choose>
				<xsl:when test="not(string-length($hsCustomPairElementName))"><xsl:value-of select="Code/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'Code')]/Value/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="not(string-length($hsCustomPairElementName))"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:when test="string-length($hsCustomPairElementName) and string-length(NVPair[Name/text()=concat($hsCustomPairElementName,'Description')]/Value/text())"><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'Description')]/Value/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$code"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codingStandard">
			<xsl:choose>
				<xsl:when test="not(string-length($hsCustomPairElementName))"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'CodingStandard')]/Value/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($code)">
			
				<xsl:variable name="sdaCodingStandardOID"><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="$codingStandard"/></xsl:apply-templates></xsl:variable>
				
				<!--
					If a translation element is required for this coded element,
					the translation will use the SDACodingStandard OID from the
					input SDA as the basis for translation codeSystem and
					codeSystemName.
				-->
				<xsl:variable name="codeSystemOIDForTranslation">
					<xsl:choose>
						<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="codeSystemNameForTranslation">
					<xsl:choose>
						<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$codingStandard"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!--
					If the requirements for this coded element require
					a code element to be exported regardless of the
					SDACodingStandard value, $noCodeSystem may need to
					be forced in as the code system.
				-->
				<xsl:variable name="codeSystemOIDPrimary">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and not(contains(concat('|',$requiredCodeSystemOID,'|'),concat('|',$sdaCodingStandardOID,'|')))">
							<xsl:choose>
								<xsl:when test="not(contains($requiredCodeSystemOID,'|'))">
									<xsl:value-of select="$requiredCodeSystemOID"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($requiredCodeSystemOID,'|')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and $isCodeRequired='1' and not(string-length($sdaCodingStandardOID))"><xsl:value-of select="$noCodeSystemOID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$sdaCodingStandardOID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="codeSystemNamePrimary"><xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$codeSystemOIDPrimary"/></xsl:apply-templates></xsl:variable>
				
				<!--
					If the requirements for this coded element specify a
					certain code system and the SDACodingStandard is not
					that code system, then a translation element will need
					to be exported for the original SDA data.
					
					If no particular codeSystem is required, and <code> is
					not required to have a @code, and SDACodingStandard is
					missing from the SDA data, then a translation element
					will need to be exported for the original SDA data,
					with $noCodeSystem as the code system.
					
					For all other cases, no need to build a translation.
				-->
				<xsl:variable name="addTranslation">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and not(contains(concat('|',$requiredCodeSystemOID,'|'),concat('|',$sdaCodingStandardOID,'|')))">1</xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and $isCodeRequired='0' and not(string-length($sdaCodingStandardOID))">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!--
					If the requirements for this coded element specify a
					certain code system, and SDACodingStandard is not that
					code system or is missing, and <code> is not required
					to have @code, then it is okay to export nullFlavor.
					
					For all other cases, export @code for <code> is required.
				-->
				<xsl:variable name="makeNullFlavor">
					<xsl:choose>
						<xsl:when test="string-length($requiredCodeSystemOID) and $isCodeRequired='0' and not(contains(concat('|',$requiredCodeSystemOID,'|'),concat('|',$sdaCodingStandardOID,'|')))">1</xsl:when>
						<xsl:when test="not(string-length($requiredCodeSystemOID)) and $isCodeRequired='0' and not(string-length($sdaCodingStandardOID))">1</xsl:when>
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
							<xsl:attribute name="code"><xsl:value-of select="translate($code,' ','_')"/></xsl:attribute>
							<xsl:attribute name="codeSystem"><xsl:value-of select="$codeSystemOIDPrimary"/></xsl:attribute>
							<xsl:attribute name="codeSystemName"><xsl:value-of select="$codeSystemNamePrimary"/></xsl:attribute>
							<xsl:if test="string-length($description)"><xsl:attribute name="displayName"><xsl:value-of select="$description"/></xsl:attribute></xsl:if>
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
							
					<xsl:if test="$writeOriginalText='1'">
						<originalText>
							<xsl:choose>
								<xsl:when test="string-length($narrativeLink)"><reference value="{$narrativeLink}"/></xsl:when>
								<xsl:when test="string-length(OriginalText)"><xsl:value-of select="OriginalText"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$description"/></xsl:otherwise>
							</xsl:choose>
						</originalText>
					</xsl:if>
							
					<xsl:if test="$addTranslation='1'"><translation code="{translate($code,' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{$description}"/></xsl:if>
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
	
	
	<!-- <xsl:template match="*" mode="code-for-oid"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="oid-for-code"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="telecom-regex"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounterNumber-converted"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="document-title"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encompassingEncounterNumber"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encompassingEncounterOrganization"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encompassingEncounterToEncounters"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="descriptionOrCode"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="codeOrDescription"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="originalTextOrDescriptionOrCode"> SEE BASE TEMPLATE -->
	
	
	<xsl:template name="nehta-globalStatement">
		<xsl:param name="narrativeLink"/>
		<xsl:param name="codeCode"/>
		<xsl:param name="valueCode" select="'01'"/>
		
		<xsl:variable name="codeDisplayName">
			<xsl:choose>
				<xsl:when test="$valueCode='01'">None known</xsl:when>
				<xsl:when test="$valueCode='02'">Not asked</xsl:when>
				<xsl:when test="$valueCode='03'">None supplied</xsl:when>
				<xsl:otherwise>None known</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<text mediaType="text/x-hl7-text+xml">
			<table border="1" width="100%">
				<caption>Exclusion Statements</caption>
				<thead>
					<tr>
						<th>Exclusions</th>
						<th>Values</th>
					</tr>
				</thead>
				<tbody>
					<!-- Narrative link is added here on the small chance that the
						document has no other data that would otherwise cause a
						narrative link to be written.
					-->
					<tr ID="{concat($narrativeLink,'1')}">
						<td>Global Statement</td>
						<td>
							<list>
								<item><xsl:value-of select="$codeDisplayName"/></item>
							</list>
						</td>
					</tr>
				</tbody>
			</table>
		</text>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<code code="{$codeCode}" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Global Statement"/>
				<value xsi:type="CD" code="{$valueCode}" codeSystem="1.2.36.1.2001.1001.101.104.16299" codeSystemName="NCTIS Global Statement Values" displayName="{$codeDisplayName}"/>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="code-ethnicGroup">
		<!--
			AU has specific requirements for ethnic group.
			The Indigenous Status code table is small enough
			for us to coerce some missing values to something.
		-->
		<xsl:variable name="displayNameToUse">
			<xsl:choose>
				<xsl:when test="string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:when test="Code/text()='1'">Aboriginal but not Torres Strait Islander origin</xsl:when>
				<xsl:when test="Code/text()='2'">Torres Strait Islander but not Aboriginal origin</xsl:when>
				<xsl:when test="Code/text()='3'">Both Aboriginal and Torres Strait Islander origin</xsl:when>
				<xsl:when test="Code/text()='4'">Neither Aboriginal nor Torres Strait Islander origin</xsl:when>
				<xsl:when test="Code/text()='9'">Not stated/inadequately described</xsl:when>
				<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="displayNameTemp">
			<xsl:value-of select="normalize-space(translate($displayNameToUse,$lowerCase,$upperCase))"/>
		</xsl:variable>
		
		<xsl:variable name="codeToUse">
			<xsl:choose>
				<xsl:when test="contains('|1|2|3|4|9|',concat('|',Code/text(),'|'))"><xsl:value-of select="Code/text()"/></xsl:when>
				<xsl:when test="$displayNameTemp='ABORIGINAL BUT NOT TORRES STRAIT ISLANDER ORIGIN'">1</xsl:when>
				<xsl:when test="$displayNameTemp='TORRES STRAIT ISLANDER BUT NOT ABORIGINAL ORIGIN'">2</xsl:when>
				<xsl:when test="$displayNameTemp='BOTH ABORIGINAL AND TORRES STRAIT ISLANDER ORIGIN'">3</xsl:when>
				<xsl:when test="$displayNameTemp='NEITHER ABORIGINAL NOR TORRES STRAIT ISLANDER ORIGIN'">4</xsl:when>
				<xsl:when test="$displayNameTemp='NOT STATED/INADEQUATELY DESCRIBED'">9</xsl:when>
				<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="codeSystemToUse">
			<xsl:choose>
				<xsl:when test="translate(SDACodingStandard/text(),$lowerCase,$upperCase)='METEOR INDIGENOUS STATUS'">2.16.840.1.113883.3.879.291036</xsl:when>
				<xsl:when test="string-length(SDACodingStandard/text())"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
				<xsl:when test="contains('|1|2|3|4|9|',concat('|',$codeToUse,'|'))">2.16.840.1.113883.3.879.291036</xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="codeSystemNameToUse">
			<xsl:choose>
				<xsl:when test="$codeSystemToUse='2.16.840.1.113883.3.879.291036'">METeOR Indigenous Status</xsl:when>
				<xsl:when test="$codeSystemToUse=$noCodeSystemOID"><xsl:value-of select="$noCodeSystemName"/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="code-for-oid">
						<xsl:with-param name="OID" select="$codeSystemToUse"/>
					</xsl:apply-templates></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<ethnicGroupCode code="{$codeToUse}" codeSystem="{$codeSystemToUse}" codeSystemName="{$codeSystemNameToUse}" displayName="{$displayNameToUse}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="asEntityIdentifier-Person">
		<!--
			Required HPI-I export format (illustrated Luhn number is just an example):
			<ext:id root="1.2.36.1.2001.1003.0.8003613392003497" assigningAuthorityName="HPI-I"/>
			
			You can get this using any of these SDA formats (in order of preference):
			- <Code>1.2.36.1.2001.1003.0.8003613392003497</Code>
			- <SDACodingStandard>1.2.36.1.2001.1003.0</SDACodingStandard><Code>8003613392003497</Code>
			- <SDACodingStandard>1.2.36.1.2001.1003.0.8003613392003497</SDACodingStandard>
			- <Code>8003613392003497</Code>
			
			Any other format will use SDACodingStandard and Code as is for root and extension, respectively.
		-->
		<xsl:apply-templates select="." mode="asEntityIdentifier">
			<xsl:with-param name="hpiPrefix" select="$hpiiPrefix"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="asEntityIdentifier-Organization">
		<!--
			Required HPI-O export format (illustrated Luhn number is just an example):
			<ext:id root="1.2.36.1.2001.1003.0.8003625140006861" assigningAuthorityName="HPI-O"/>
			
			You can get this using any of these SDA formats (in order of preference):
			- <Code>1.2.36.1.2001.1003.0.8003625140006861</Code>
			- <SDACodingStandard>1.2.36.1.2001.1003.0</SDACodingStandard><Code>8003625140006861</Code>
			- <SDACodingStandard>1.2.36.1.2001.1003.0.8003625140006861</SDACodingStandard>
			- <Code>8003613392003497</Code>
			
			Any other format will use SDACodingStandard and Code as is for root and extension, respectively.
		-->
		<xsl:apply-templates select="." mode="asEntityIdentifier">
			<xsl:with-param name="hpiPrefix" select="$hpioPrefix"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="asEntityIdentifier">
		<xsl:param name="hpiPrefix"/>
		
		<xsl:variable name="sdaCodingStandardOID">
			<xsl:choose>
				<xsl:when test="string-length(SDACodingStandard/text())">
					<xsl:apply-templates select="." mode="oid-for-code">
						<xsl:with-param name="Code" select="SDACodingStandard/text()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="hpiAA">
			<xsl:choose>
				<xsl:when test="$hpiPrefix=$hpiiPrefix">HPI-I</xsl:when>
				<xsl:when test="$hpiPrefix=$hpioPrefix">HPI-O</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="rootToUse">
			<xsl:choose>
				<xsl:when test="starts-with(Code/text(),concat($hiServiceOID,'.',$hpiPrefix))"><xsl:value-of select="Code/text()"/></xsl:when>
				<xsl:when test="$sdaCodingStandardOID=$hiServiceOID and starts-with(Code/text(),$hpiPrefix)"><xsl:value-of select="concat($hiServiceOID,'.',Code/text())"/></xsl:when>
				<xsl:when test="starts-with($SDACodingStandardOID,concat($hiServiceOID,'.',$hpiPrefix))"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
				<xsl:when test="$sdaCodingStandardOID=$noCodeSystemOID and string-length(Code/text())=16 and starts-with(Code/text(),$hpiPrefix)"><xsl:value-of select="concat($hiServiceOID,'.',Code/text())"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$sdaCodingStandardOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="extensionToUse">
			<xsl:choose>
				<xsl:when test="string-length(Code/text()) and not(starts-with($rootToUse,concat($hiServiceOID,'.',$hpiPrefix)))"><xsl:value-of select="Code/text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
				
		<ext:asEntityIdentifier classCode="IDENT">
			<xsl:element name="ext:id">
				<xsl:if test="string-length($rootToUse)"><xsl:attribute name="root"><xsl:value-of select="$rootToUse"/></xsl:attribute></xsl:if>
				<xsl:if test="string-length($extensionToUse)"><xsl:attribute name="extension"><xsl:value-of select="$extensionToUse"/></xsl:attribute></xsl:if>
				<xsl:if test="starts-with($rootToUse,concat($hiServiceOID,'.',$hpiPrefix))"><xsl:attribute name="assigningAuthorityName"><xsl:value-of select="$hpiAA"/></xsl:attribute></xsl:if>
				<xsl:if test="not(string-length($rootToUse))"><xsl:attribute name="nullFlavor"><xsl:value-of select="$idNullFlavor"/></xsl:attribute></xsl:if>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="starts-with($rootToUse,$hiServiceOID)">
					<ext:assigningGeographicArea classCode="PLC">
						<ext:name>National Identifier</ext:name>
					</ext:assigningGeographicArea>
				</xsl:when>
			</xsl:choose>
		</ext:asEntityIdentifier>
	</xsl:template>
	
	<xsl:template match="*" mode="employment">
		<ext:asEmployment classCode="EMP">
			<xsl:choose>
				<xsl:when test="string-length(Code/text())">
					<ext:employerOrganization>
						<asOrganizationPartOf>
							<wholeOrganization>
								<xsl:choose>
									<xsl:when test="string-length(Description/text())"><name><xsl:value-of select="Description/text()"/></name></xsl:when>
									<xsl:when test="string-length(Code/text())"><name><xsl:value-of select="Code/text()"/></name></xsl:when>
									<xsl:otherwise><name nullFlavor="UNK"/></xsl:otherwise>
								</xsl:choose>
								
								<xsl:apply-templates select="." mode="asEntityIdentifier-Organization"/>
							</wholeOrganization>
						</asOrganizationPartOf>
					</ext:employerOrganization>
				</xsl:when>
				<xsl:otherwise>
					<ext:employerOrganization>
						<id nullFlavor="{$idNullFlavor}"/>
						<name nullFlavor="UNK"/>
						<telecom nullFlavor="UNK"/>
						<addr nullFlavor="{$addrNullFlavor}"/>
					</ext:employerOrganization>
				</xsl:otherwise>
			</xsl:choose>
		</ext:asEmployment>
	</xsl:template>
	
	<xsl:template match="*" mode="careProviderType-ANZSCO">
		<!--
			1220.0 ANZSCO is required here, and it is a very large
			set of code/displayName values.  Only in cases where
			CareProviderType is not present will we default in values.
			Otherwise, CareProviderType must specify valid ANZSCO data.
		-->
		<xsl:variable name="code">
			<xsl:choose>
				<xsl:when test="not(CareProviderType)">253111</xsl:when>
				<xsl:otherwise><xsl:value-of select="CareProviderType/Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="not(CareProviderType)">General Medical Practitioner</xsl:when>
				<xsl:when test="string-length(CareProviderType/Description)"><xsl:value-of select="CareProviderType/Description/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="CareProviderType/Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystem">
			<xsl:choose>
				<xsl:when test="not(CareProviderType)">2.16.840.1.113883.13.62</xsl:when>
				<xsl:when test="not(string-length(CareProviderType/SDACodingStandard/text()))"><xsl:value-of select="$noCodeSystemOID"/></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="CareProviderType/SDACodingStandard/text()"/></xsl:apply-templates></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystemName">
			<xsl:choose>
				<xsl:when test="$codeSystem='2.16.840.1.113883.13.62'">1220.0 - ANZSCO - Australian and New Zealand Standard Classification of Occupations, First Edition, 2006</xsl:when>
				<xsl:when test="not(string-length(CareProviderType/SDACodingStandard/text()))"><xsl:value-of select="$noCodeSystemName"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$codeSystem"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<code code="{$code}" codeSystem="{$codeSystem}" codeSystemName="{$codeSystemName}" displayName="{$description}"/>
	</xsl:template>
		
	<xsl:template match="*" mode="narrativeDateFromODBC">
		<!-- The expected date format coming in is "ODBC format" YYYY-MM-DDTHH:MM:SSZ -->
		<xsl:variable name="year" select="substring(text(),1,4)"/>
		<xsl:variable name="month" select="substring(text(),6,2)"/>
		<xsl:variable name="monthText">
			<xsl:choose>
				<xsl:when test="$month='01'">Jan</xsl:when>
				<xsl:when test="$month='02'">Feb</xsl:when>
				<xsl:when test="$month='03'">Mar</xsl:when>
				<xsl:when test="$month='04'">Apr</xsl:when>
				<xsl:when test="$month='05'">May</xsl:when>
				<xsl:when test="$month='06'">Jun</xsl:when>
				<xsl:when test="$month='07'">Jul</xsl:when>
				<xsl:when test="$month='08'">Aug</xsl:when>
				<xsl:when test="$month='09'">Sep</xsl:when>
				<xsl:when test="$month='10'">Oct</xsl:when>
				<xsl:when test="$month='11'">Nov</xsl:when>
				<xsl:when test="$month='12'">Dec</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- Trim leading zero from day. -->
		<xsl:variable name="day">
			<xsl:choose>
				<xsl:when test="substring(text(),9,1)='0'"><xsl:value-of select="substring(text(),10,1)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="substring(text(),9,2)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Trim leading zero from hour. -->
		<xsl:variable name="hour">
			<xsl:choose>
				<xsl:when test="substring(text(),12,1)='0'"><xsl:value-of select="substring(text(),13,1)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="substring(text(),12,2)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="minute" select="substring(text(),15,2)"/>
		<xsl:value-of select="concat($day,' ',$monthText,' ',$year,' ',$hour,':',$minute)"/>
	</xsl:template>
</xsl:stylesheet>
