<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 sdtc xsi exsl">

	<!-- DefaultEncounter imports the CDA encompassingEncounter. -->
	<xsl:template match="*" mode="DefaultEncounter">
		<!--
			$encounterIDTemp is used as an intermediate so that
			$encounterID can be set such that "000nnn" does NOT
			match "nnn" when comparing encounter numbers.
		-->
		<xsl:variable name="encounterIDTemp"><xsl:apply-templates select="." mode="EncounterId"/></xsl:variable>
		<xsl:variable name="encounterID" select="string($encounterIDTemp)"/>
		
		<Encounters>
			<Encounter>
				<xsl:apply-templates select="." mode="DefaultEncounterDetail"/>
				
				<!-- Process CDA Append/Transform/Replace Directive -->
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'Encounter'"/>
				</xsl:call-template>
				
				<!-- Health Funds -->
				<xsl:variable name="payerEntries" select="$administrativeObservationsSection/ext:coverage2"/>
				<xsl:if test="$payerEntries">
					<HealthFunds>
						<xsl:apply-templates select="$payerEntries" mode="HealthFund"/>
					</HealthFunds>
				</xsl:if>
				
				<!-- Visit Description (NEHTA Clinical Synopsis) -->
				<xsl:apply-templates select="$eventSection/hl7:component/hl7:section[hl7:code/@code='102.15513.4.1.1' and hl7:code/@codeSystem=$nctisOID]/hl7:entry/hl7:act[hl7:code/@code='103.15582' and hl7:code/@codeSystem=$nctisOID]" mode="ClinicalSynopsis"/>
				
				<!-- Specialties -->
				<xsl:variable name="specialtyEntries" select="$administrativeObservationsSection/hl7:entry[hl7:observation/hl7:code/@code='103.16028' and hl7:observation/hl7:code/@codeSystem=$nctisOID]"/>
				<xsl:if test="$specialtyEntries">
					<Specialties>
						<xsl:apply-templates select="$specialtyEntries" mode="Specialties"/>
					</Specialties>
				</xsl:if>

				<!-- Recommendations Provided -->
				<xsl:variable name="recommendationEntries" select="$planSection/hl7:component/hl7:section[hl7:code/@code='101.20016' and hl7:code/@codeSystem=$nctisOID]/hl7:entry/hl7:act[hl7:code/@code='102.20016.4.1.1' and hl7:code/@codeSystem=$nctisOID]"/>
				<xsl:if test="$recommendationEntries">
					<RecommendationsProvided>
						<xsl:apply-templates select="$recommendationEntries" mode="Recommendations"/>
					</RecommendationsProvided>
				</xsl:if>

				<!-- Custom SDA Data-->
				<xsl:apply-templates select="." mode="ImportCustom-Encounter"/>
			</Encounter>
		</Encounters>
	</xsl:template>
	
	<!-- OverriddenEncounter imports an encounter that is found only in the CDA Encounters section. -->
	<xsl:template match="*" mode="OverriddenEncounter">
		<!--
			$encounterIDTemp is used as an intermediate so that
			$encounterID can be set such that "000nnn" does NOT
			match "nnn" when comparing encounter numbers.
		-->
		<xsl:variable name="encounterIDTemp"><xsl:apply-templates select="." mode="EncounterId"/></xsl:variable>
		<xsl:variable name="encounterID" select="string($encounterIDTemp)"/>
		
		<Encounters>
		<Encounter>
			<xsl:apply-templates select="." mode="OverriddenEncounterDetail"/>
			
			<!-- Process CDA Append/Transform/Replace Directive -->
			<xsl:call-template name="ActionCode">
				<xsl:with-param name="informationType" select="'Encounter'"/>
			</xsl:call-template>
			
			<!-- Health Funds -->
			<xsl:variable name="payerEntries" select="$administrativeObservationsSection/ext:coverage2"/>
			<xsl:if test="$payerEntries">
				<HealthFunds>
					<xsl:apply-templates select="$payerEntries" mode="HealthFunds"/>
				</HealthFunds>
			</xsl:if>
			
			<!-- Visit Description (NEHTA Clinical Synopsis) -->
			<xsl:apply-templates select="$eventSection/hl7:component/hl7:section[hl7:code/@code='102.15513.4.1.1' and hl7:code/@codeSystem=$nctisOID]/hl7:entry/hl7:act[hl7:code/@code='103.15582' and hl7:code/@codeSystem=$nctisOID]" mode="ClinicalSynopsis"/>
			
			<!-- Specialties -->
			<xsl:variable name="specialtyEntries" select="$administrativeObservationsSection/hl7:entry[hl7:observation/hl7:code/@code='103.16028' and hl7:observation/hl7:code/@codeSystem=$nctisOID]"/>
			<xsl:if test="$specialtyEntries">
				<Specialties>
					<xsl:apply-templates select="$specialtyEntries" mode="Specialties"/>
				</Specialties>
			</xsl:if>

			<!-- Recommendations Provided -->
			<xsl:variable name="recommendationEntries" select="$planSection/hl7:component/hl7:section[hl7:code/@code='101.20016' and hl7:code/@codeSystem=$nctisOID]/hl7:entry/hl7:act[hl7:code/@code='102.20016.4.1.1' and hl7:code/@codeSystem=$nctisOID]"/>
			<xsl:if test="$recommendationEntries">
				<RecommendationsProvided>
					<xsl:apply-templates select="$recommendationEntries" mode="Recommendations"/>
				</RecommendationsProvided>
			</xsl:if>

			<!-- Custom SDA Data-->
			<xsl:apply-templates select="." mode="ImportCustom-Encounter"/>			
		</Encounter>
		</Encounters>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="DefaultEncounterDetail"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="OverriddenEncounterDetail"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EncounterType"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:code" mode="EncounterCodedType"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="EncounterMRN">
		<!-- The checkPatientIdentifiers template is in PersonalInformation.xsl. -->
		<xsl:variable name="hasPatientMRN">
			<xsl:apply-templates select="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier" mode="checkPatientIdentifiers">
				<xsl:with-param name="identifierType" select="'MRN'"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="hasPatientIHI">
			<xsl:apply-templates select="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier" mode="checkPatientIdentifiers">
				<xsl:with-param name="identifierType" select="'IHI'"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<!-- Use the patient-level MRN or IHI when no encounter-level MRN is found. -->
		<EncounterMRN>
			<xsl:choose>
				<xsl:when test="string-length(hl7:encounterParticipant/hl7:assignedEntity/sdtc:patient/sdtc:id/@extension)">
					<xsl:value-of select="hl7:encounterParticipant/hl7:assignedEntity/sdtc:patient/sdtc:id/@extension"/>
				</xsl:when>
				<xsl:when test="string-length(hl7:informant/hl7:assignedEntity/sdtc:patient/sdtc:id/@extension)">
					<xsl:value-of select="hl7:informant/hl7:assignedEntity/sdtc:patient/sdtc:id/@extension"/>
				</xsl:when>
				<xsl:when test="string-length($hasPatientMRN)">
					<xsl:value-of select="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[@classCode='IDENT' and ext:code/@code='MR' and ext:code/@codeSystem='2.16.840.1.113883.12.203'][1]"/>
				</xsl:when>
				<xsl:when test="string-length($hasPatientIHI)">
					<xsl:choose>
						<xsl:when test="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and string-length(ext:id/@root)=37 and starts-with(ext:id/@root,$hiServiceOID) and substring(ext:id/@root,22,6)=$ihiPrefix][1]">
							<xsl:value-of select="substring(/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier/ext:id/@root,22)"/>
						</xsl:when>
						<xsl:when test="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[@classCode='IDENT' and ext:id/@assigningAuthorityName='IHI' and ext:id/@root=$hiServiceOID and string-length(ext:id/@extension)=16 and starts-with(ext:extension/@root,$ihiPrefix)][1]">
							<xsl:value-of select="/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier/ext:extension/@root"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</EncounterMRN>
	</xsl:template>
	
		
	<!-- <xsl:template match="*" mode="EncounterId"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="AdmissionType"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounter-HealthCareFacility"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounter-HealthCareFacility-LocationCode"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="encounter-HealthCareFacility-OrganizationCode"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode=""ConsultingClinicians-informant"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="ClinicalSynopsis">
		<VisitDescription><xsl:value-of select="hl7:text/text()"/></VisitDescription>
	</xsl:template>
	
	<xsl:template match="*" mode="Specialties">
		<xsl:apply-templates select="hl7:observation/hl7:value" mode="Specialty"/>
	</xsl:template>
	
	<xsl:template match="*" mode="Specialty">
		<xsl:apply-templates select="." mode="CodeTable"><xsl:with-param name="hsElementName" select="'CareProviderType'"/></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="Recommendations">
		<Recommendation>
			<NoteText><xsl:value-of select="hl7:text/text()"/></NoteText>

			<xsl:variable name="recipientPersons" select="hl7:performer[hl7:assignedEntity/hl7:assignedPerson]"/>
			<xsl:variable name="recipientOrganizations" select="hl7:performer[hl7:assignedEntity/hl7:representedOrganization]"/>
			
			<xsl:if test="$recipientPersons">
				<RecipientPersons>
					<xsl:apply-templates select="$recipientPersons" mode="RecipientPersons"/>
				</RecipientPersons>
			</xsl:if>
			<xsl:if test="$recipientOrganizations">
				<RecipientOrganizations>
					<xsl:apply-templates select="$recipientOrganizations" mode="RecipientOrganizations"/>
				</RecipientOrganizations>
			</xsl:if>
		</Recommendation>
	</xsl:template>
	
	<xsl:template match="*" mode="RecipientPersons">
		<xsl:apply-templates select="hl7:assignedEntity" mode="RecipientPerson"/>
	</xsl:template>
	
	<xsl:template match="*" mode="RecipientPerson">
		<CareProvider>
			<Code><xsl:value-of select="hl7:assignedPerson/ext:asEntityIdentifier/ext:id/@root"/></Code>
			<xsl:apply-templates select="hl7:assignedPerson/hl7:name" mode="ContactName"/>
			<xsl:apply-templates select="hl7:addr" mode="Address"/>
			<xsl:apply-templates select="." mode="ContactInfo"/>
			<CareProviderType>
				<Code><xsl:value-of select="hl7:code/@code"/></Code>
				<Description><xsl:value-of select="hl7:code/@displayName"/></Description>
			</CareProviderType>
		</CareProvider>
	</xsl:template>
	
	<xsl:template match="*" mode="RecipientOrganizations">
		<xsl:apply-templates select="hl7:assignedEntity" mode="HealthCareFacility"/>
	</xsl:template>
	
	<!--
		This empty template may be overridden with custom logic.
	
		The input node spec can be either of the following:
		- /hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter
		- $sectionRootPath/hl7:entry/hl7:encounter
	-->
	<xsl:template match="*" mode="ImportCustom-Encounter">
	</xsl:template>
</xsl:stylesheet>
