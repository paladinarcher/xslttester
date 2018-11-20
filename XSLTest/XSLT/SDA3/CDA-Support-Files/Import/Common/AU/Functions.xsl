<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 sdtc xsi exsl">

	<!-- <xsl:template match="*" mode="CodeTable"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="CodeTable-CustomPair"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="CodeTableDetail"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="TextValue"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="PriorCodes"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="PriorCode"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="SDACodingStandard"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="SDACodingStandard-text"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="SendingFacility"> SEE BASE TEMPLATE -->
	
	<xsl:template match="*" mode="SendingFacility-AU">
		<xsl:choose>
			<xsl:when test="string-length(@extension)">
				<SendingFacility>
					<xsl:value-of select="@extension"/>
				</SendingFacility>
			</xsl:when>
			<xsl:when test="string-length(@root)">
				<SendingFacility>
					<xsl:apply-templates select="." mode="code-for-oid">
						<xsl:with-param name="OID" select="@root"/>
					</xsl:apply-templates>
				</SendingFacility>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="SendingFacilityValue">
		<xsl:choose>
			<xsl:when test="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']/@root">
				<xsl:apply-templates select="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']" mode="SendingFacility-AU"/>
			</xsl:when>
			<xsl:when test="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id/@root">
				<xsl:apply-templates select="hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id" mode="SendingFacility-AU"/>
			</xsl:when>
			<xsl:when test="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']/@root">
				<xsl:apply-templates select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']" mode="SendingFacility-AU"/>
			</xsl:when>
			<xsl:when test="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id/@root">
				<xsl:apply-templates select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id" mode="SendingFacility-AU"/>
			</xsl:when>
			<xsl:when test="string-length(hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name)">
				<xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
			</xsl:when>
			<xsl:when test="string-length(hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:name)">
				<xsl:value-of select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:name"/>
			</xsl:when>
			<xsl:when test="$defaultInformantRootPath"><xsl:apply-templates select="$defaultInformantRootPath" mode="SendingFacility"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="$defaultAuthorRootPath" mode="SendingFacility"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="SendingFacilityFromId">
		<xsl:choose>
			<xsl:when test="string-length(@extension)"><xsl:value-of select="@extension"/></xsl:when>
			<xsl:when test="string-length(@root)">
				<xsl:apply-templates select="." mode="code-for-oid">
					<xsl:with-param name="OID" select="@root"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- <xsl:template match="*" mode="PerformedAt"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EnteredAt"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EnteringOrganization"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="HealthCareFacility"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="HealthCareFacilityDetail">
		<xsl:param name="elementName"/>
		
		<xsl:variable name="organizationInformation"><xsl:apply-templates select=".//hl7:representedOrganization | .//hl7:serviceProviderOrganization | .//ext:employerOrganization" mode="OrganizationInformation"/></xsl:variable>
		
		<xsl:if test="string-length($elementName) and string-length($organizationInformation)">
			<!-- Parse facility information -->
			<xsl:variable name="facilityOID" select="substring-before(substring-after($organizationInformation, 'F1:'), '|')"/>
			<xsl:variable name="facilityCode" select="substring-before(substring-after($organizationInformation, 'F2:'), '|')"/>
			<xsl:variable name="facilityDescription" select="substring-before(substring-after($organizationInformation, 'F3:'), '|')"/>
			
			<!-- Parse community information -->
			<xsl:variable name="communityOID" select="substring-before(substring-after($organizationInformation, 'C1:'), '|')"/>
			<xsl:variable name="communityCode" select="substring-before(substring-after($organizationInformation, 'C2:'), '|')"/>
			<xsl:variable name="communityDescription" select="substring-before(substring-after($organizationInformation, 'C3:'), '|')"/>
			
			<xsl:variable name="codeUpper" select="translate(hl7:code/@code,$lowerCase,$upperCase)"/>
			<xsl:variable name="facilityRole">
				<xsl:choose>
					<xsl:when test="$codeUpper='CLINIC'">CLINIC</xsl:when>
					<xsl:when test="$codeUpper='ER' or starts-with($codeUpper,'EMERGENCY')">ER</xsl:when>
					<xsl:when test="$codeUpper='DEPARTMENT' or $codeUpper='DEPT'">DEPARTMENT</xsl:when>
					<xsl:when test="$codeUpper='WARD' or $codeUpper='DEPT'">WARD</xsl:when>
					<xsl:when test="$codeUpper='OTH' or $codeUpper='OTHER'">OTHER</xsl:when>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:element name="{$elementName}">
				<Code><xsl:value-of select="$facilityCode"/></Code>
				<Description><xsl:value-of select="$facilityDescription"/></Description>
				<xsl:if test="string-length($facilityRole)"><LocationType><xsl:value-of select="$facilityRole"/></LocationType></xsl:if>
				<Organization>
					<Code><xsl:value-of select="$communityCode"/></Code>
					<Description><xsl:value-of select="$communityDescription"/></Description>
					
					<xsl:apply-templates select="hl7:addr" mode="Address"/>
					<xsl:apply-templates select="." mode="ContactInfo"/>
				</Organization>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="OrganizationDetail"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EnteredBy"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="EnteredByDetail">
		<xsl:if test="hl7:assignedAuthor/hl7:assignedPerson and not(hl7:assignedAuthor/hl7:assignedPerson/hl7:name/@nullFlavor)">
			<EnteredBy>
				<xsl:choose>
					<xsl:when test="hl7:assignedAuthor/hl7:assignedPerson/ext:asEntityIdentifier/ext:id">
						<xsl:variable name="authorCode"><xsl:value-of select="hl7:assignedAuthor/hl7:assignedPerson/ext:asEntityIdentifier/ext:id/@root"/></xsl:variable>
						<xsl:variable name="authorDecription">
							<xsl:choose>
								<xsl:when test="string-length(hl7:assignedAuthor/hl7:assignedPerson/hl7:name/text())">
									<xsl:value-of select="hl7:assignedAuthor/hl7:assignedPerson/hl7:name/text()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$authorCode"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<Code><xsl:value-of select="$authorCode"/></Code>
						<Description><xsl:value-of select="$authorDecription"/></Description>
					</xsl:when>
					<xsl:when test="hl7:assignedAuthor/hl7:code and ((not(hl7:assignedAuthor/hl7:code/@nullFlavor)) or (hl7:assignedAuthor/hl7:code/@nullFlavor and string-length(hl7:assignedAuthor/hl7:code/hl7:originalText/text())))">
						<xsl:variable name="authorType">
							<xsl:choose>
								<xsl:when test="string-length(hl7:assignedAuthor/hl7:code/@displayName)"><xsl:value-of select="hl7:assignedAuthor/hl7:code/@displayName"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="hl7:assignedAuthor/hl7:code/hl7:originalText/text()"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
					
						<Code><xsl:value-of select="$authorType"/></Code>
						<Description><xsl:value-of select="$authorType"/></Description>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="contactNameXML"><xsl:apply-templates select="hl7:assignedAuthor/hl7:assignedPerson/hl7:name" mode="ContactName"/></xsl:variable>
						<xsl:variable name="contactName" select="exsl:node-set($contactNameXML)/Name"/>
						<xsl:variable name="contactNameFull" select="normalize-space(concat($contactName/NamePrefix/text(), ' ', $contactName/GivenName/text(), ' ', $contactName/MiddleName/text(), ' ', $contactName/FamilyName/text(), ' ', $contactName/ProfessionalSuffix/text()))"/>
	
						<Code><xsl:value-of select="$contactNameFull"/></Code>
						<Description><xsl:value-of select="$contactNameFull"/></Description>
					</xsl:otherwise>
				</xsl:choose>
			</EnteredBy>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="Informant"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EnteredOn"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="FromTime"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="ToTime"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="StartTime"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EndTime"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="AttendingClinicians">
		<xsl:if test="hl7:encounterParticipant[@typeCode = 'ATND' or @typeCode='DIS'] | hl7:performer[@typeCode = 'PRF']">
			<AttendingClinicians>
				<xsl:apply-templates select="hl7:encounterParticipant[@typeCode = 'ATND' or @typeCode='DIS'] | hl7:performer[@typeCode = 'PRF']" mode="CareProvider"/>
			</AttendingClinicians>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="ConsultingClinicians"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="AdmittingClinician"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="ReferringClinician"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="FamilyDoctor"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="Clinician"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="DiagnosingClinician"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="OrderedBy"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="OrderedBy-Author"> SEE BASE TEMPLATE -->
		
	<!-- <xsl:template match="*" mode="CareProvider"> SEE BASE TEMPLATE -->
	
	<xsl:template match="*" mode="CareProviderDetail">
		<xsl:variable name="entityPath" select="hl7:assignedEntity | hl7:associatedEntity"/>
		
		<xsl:if test="$entityPath = true()">
			<xsl:variable name="personPath" select="$entityPath/hl7:assignedPerson | $entityPath/hl7:associatedPerson"/>
			
			<xsl:if test="$personPath = true() and not($personPath/hl7:name/@nullFlavor)">
				<xsl:variable name="codeOrTranslation">
					<!-- 0 = no data, 1 = use hl7:functionCode, 2 = use hl7:functionCode/hl7:translation[1] -->
					<xsl:choose>
						<xsl:when test="not(hl7:functionCode/@nullFlavor) and hl7:functionCode/hl7:translation[1]/@code and hl7:functionCode/hl7:translation[1]/@codeSystem=$noCodeSystemOID">2</xsl:when>
						<xsl:when test="hl7:functionCode/@nullFlavor and hl7:functionCode/hl7:translation[1]/@code and hl7:functionCode/hl7:translation[1]/@codeSystem">2</xsl:when>
						<xsl:when test="hl7:functionCode/@code and not(hl7:functionCode/@nullFlavor)">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianFunctionCode">
					<xsl:choose>
						<xsl:when test="$codeOrTranslation='1'">
							<xsl:value-of select="hl7:functionCode/@code"/>
						</xsl:when>
						<xsl:when test="$codeOrTranslation='2'">
							<xsl:value-of select="hl7:functionCode/hl7:translation[1]/@code"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianFunctionDesc">
					<xsl:choose>
						<xsl:when test="$codeOrTranslation='1'">
							<xsl:value-of select="hl7:functionCode/@displayName"/>
						</xsl:when>
						<xsl:when test="$codeOrTranslation='2'">
							<xsl:value-of select="hl7:functionCode/hl7:translation[1]/@displayName"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianFunctionCodeSystem">
					<xsl:choose>
						<xsl:when test="$codeOrTranslation='1' and not(hl7:functionCode/@codeSystem=$noCodeSystemOID)">
							<xsl:value-of select="hl7:functionCode/@codeSystem"/>
						</xsl:when>
						<xsl:when test="$codeOrTranslation='2' and not(hl7:functionCode/hl7:translation[1]/@codeSystem=$noCodeSystemOID)">
							<xsl:value-of select="hl7:functionCode/hl7:translation[1]/@codeSystem"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianAssigningAuthority">
					<xsl:choose>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@assigningAuthorityName">
							<xsl:value-of select="$personPath/ext:asEntityIdentifier/ext:id/@assigningAuthorityName"/>
						</xsl:when>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@root and $personPath/ext:asEntityIdentifier/ext:id/@extension">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$personPath/ext:asEntityIdentifier/ext:id/@root"/></xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$entityPath/hl7:id/@root and $entityPath/hl7:id/@extension">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$entityPath/hl7:id/@root"/></xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianID">
					<xsl:choose>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@extension">
							<xsl:value-of select="$personPath/ext:asEntityIdentifier/ext:id/@extension"/>
						</xsl:when>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@root and not($personPath/ext:asEntityIdentifier/ext:id/@extension)">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$personPath/ext:asEntityIdentifier/ext:id/@root"/></xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$entityPath/hl7:id/@root and not($entityPath/hl7:id/@extension)">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$entityPath/hl7:id/@root"/></xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianName"><xsl:apply-templates select="$personPath/hl7:name" mode="ContactNameString"/></xsl:variable>
					
				<xsl:if test="string-length($clinicianAssigningAuthority) and not($clinicianAssigningAuthority=$noCodeSystemOID) and not($clinicianAssigningAuthority=$noCodeSystemName)"><SDACodingStandard><xsl:value-of select="$clinicianAssigningAuthority"/></SDACodingStandard></xsl:if>
				<Code>
					<xsl:choose>
						<xsl:when test="string-length($clinicianID)"><xsl:value-of select="$clinicianID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$clinicianName"/></xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description><xsl:value-of select="$clinicianName"/></Description>
				
				<!-- Contact Name and Contact Information -->
				<xsl:apply-templates select="$personPath/hl7:name" mode="ContactName"/>
				<xsl:apply-templates select="$entityPath/hl7:addr" mode="Address"/>
				<xsl:apply-templates select="$entityPath" mode="ContactInfo"/>
				
				<!-- Contact Type -->
				<xsl:if test="string-length($clinicianFunctionCode)">
					<CareProviderType>
						<xsl:if test="string-length($clinicianFunctionCodeSystem)"><SDACodingStandard><xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$clinicianFunctionCodeSystem"/></xsl:apply-templates></SDACodingStandard></xsl:if>
						<Code><xsl:value-of select="$clinicianFunctionCode"/></Code>
						<Description><xsl:value-of select="$clinicianFunctionDesc"/></Description>
					</CareProviderType>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!--
		DoctorDetail is the same as CareProviderDetail, except
		for functionCode support, which is omitted here due to
		the contents of SDA FamilyDoctor and ReferringClinician.
	-->
	<xsl:template match="*" mode="DoctorDetail">
		<xsl:variable name="entityPath" select="hl7:assignedEntity | hl7:associatedEntity"/>
		
		<xsl:if test="$entityPath = true()">
			<xsl:variable name="personPath" select="$entityPath/hl7:assignedPerson | $entityPath/hl7:associatedPerson"/>
			
			<xsl:if test="$personPath = true() and not($personPath/hl7:name/@nullFlavor)">
				<xsl:variable name="clinicianAssigningAuthority">
					<xsl:choose>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@assigningAuthorityName">
							<xsl:value-of select="$personPath/ext:asEntityIdentifier/ext:id/@assigningAuthorityName"/>
						</xsl:when>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@root and $personPath/ext:asEntityIdentifier/ext:id/@extension">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$personPath/ext:asEntityIdentifier/ext:id/@root"/></xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$entityPath/hl7:id/@root and $entityPath/hl7:id/@extension">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$entityPath/hl7:id/@root"/></xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianID">
					<xsl:choose>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@extension">
							<xsl:value-of select="$personPath/ext:asEntityIdentifier/ext:id/@extension"/>
						</xsl:when>
						<xsl:when test="$personPath/ext:asEntityIdentifier/ext:id/@root and not($personPath/ext:asEntityIdentifier/ext:id/@extension)">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$personPath/ext:asEntityIdentifier/ext:id/@root"/></xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$entityPath/hl7:id/@root and not($entityPath/hl7:id/@extension)">
							<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$entityPath/hl7:id/@root"/></xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="clinicianName"><xsl:apply-templates select="$personPath/hl7:name" mode="ContactNameString"/></xsl:variable>
					
				<xsl:if test="string-length($clinicianAssigningAuthority) and not($clinicianAssigningAuthority=$noCodeSystemOID) and not($clinicianAssigningAuthority=$noCodeSystemName)"><SDACodingStandard><xsl:value-of select="$clinicianAssigningAuthority"/></SDACodingStandard></xsl:if>
				<Code>
					<xsl:choose>
						<xsl:when test="string-length($clinicianID)"><xsl:value-of select="$clinicianID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$clinicianName"/></xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description><xsl:value-of select="$clinicianName"/></Description>
				
				<!-- Contact Name and Contact Information -->
				<xsl:apply-templates select="$personPath/hl7:name" mode="ContactName"/>
				<xsl:apply-templates select="$entityPath/hl7:addr" mode="Address"/>
				<xsl:apply-templates select="$entityPath" mode="ContactInfo"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="ContactName"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="ContactNameString"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="Addresses"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="Address"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:streetAddressLine"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="ContactInfo"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="OrganizationInformation">
		<xsl:variable name="wholeOrganizationRootPath" select="hl7:asOrganizationPartOf/hl7:wholeOrganization"/>
		
		<!-- Get community information -->
		<xsl:variable name="communityOID">
			<xsl:choose>
				<xsl:when test="$wholeOrganizationRootPath/ext:asEntityIdentifier/ext:id/@root"><xsl:value-of select="$wholeOrganizationRootPath/ext:asEntityIdentifier/ext:id/@root"/></xsl:when>
				<xsl:when test="$wholeOrganizationRootPath"><xsl:value-of select="$wholeOrganizationRootPath/hl7:id/@root"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="hl7:id/@root"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communityCode">
		<xsl:choose>
			<xsl:when test="starts-with($communityOID,concat($hiServiceOID,'.',$hpioPrefix))">
				<xsl:value-of select="$communityOID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$communityOID"/></xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communityDescription">
			<xsl:choose>
				<xsl:when test="$wholeOrganizationRootPath"><xsl:value-of select="$wholeOrganizationRootPath/hl7:name/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="hl7:name/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--
			Get facility information from <id> and possibly from the OID Registry.
			
			$repOrgconcatIdRootAndNumericExt is defined in ImportProfile.xsl.
			
			There are several <id> formats that may legally be present here:
			
			1. <id root="<OID>"/> - @root is intended to be the OID of a facility.
			2. <id root="<OID>" extension="<alphanumericvalue>"/> - @extension is intended to be a facility code.
			3. <id root="<OID>" extension="<numericvalue>"/> -
				a. If $repOrgconcatIdRootAndNumericExt'=1 then @extension is intended to be a facility code.
				b. If $repOrgconcatIdRootAndNumericExt=1 then concatenate @root+@extension and use as facility OID.
			4. <id root="<GUID>" extension="<anyvalue>"/> - @extension is intended to be a facility code.
			5. <id nullFlavor="UNK"/> - no id, and so no facility code.
			6. <id root="<GUID>"/> - same effect as nullFlavor.
			
			There may be multiple <id>'s and a mix of the scenarios shown above.
			
			Use the first non-nullFlavor/non-GUID-only <id> for the facility information.
		-->
		
		<xsl:variable name="idRootExt"><xsl:apply-templates select="hl7:id" mode="representedOrganizationId"/></xsl:variable>
		
		<xsl:variable name="facilityOID" select="substring-before(substring-before($idRootExt,'/'),'|')"/>
		<xsl:variable name="facilityCodeFromIds" select="substring-after(substring-before($idRootExt,'/'),'|')"/>
		<xsl:variable name="facilityCodeFromOID"><xsl:apply-templates select="." mode="code-for-oid"><xsl:with-param name="OID" select="$facilityOID"/></xsl:apply-templates></xsl:variable>
		<!--
			If FacilityCode found then use it for FacilityCode.
			If FacilityCode not found but OID found then get FacilityCode from OID.
			If FacilityCode not found from OID then use <name> for FacilityCode.
		-->
		<xsl:variable name="facilityCode">
			<xsl:choose>
				<xsl:when test="string-length($facilityCodeFromIds)">
					<xsl:value-of select="$facilityCodeFromIds"/>
				</xsl:when>
				<xsl:when test="string-length($facilityCodeFromOID)">
					<xsl:value-of select="$facilityCodeFromOID"/>
				</xsl:when>
				<xsl:when test="string-length(hl7:name/text())">
					<xsl:value-of select="hl7:name/text()"/>
				</xsl:when>
				<xsl:when test="string-length($facilityOID)">
					<xsl:value-of select="$facilityOID"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="facilityDescription"><xsl:if test="node()"><xsl:value-of select="hl7:name/text()"/></xsl:if></xsl:variable>
		
		<!-- Reponse format:  |F1:Facility OID|F2:Facility Code|F3:Facility Description|C1:Community OID|C2:Community Code|C3:Community Description| -->
		<xsl:value-of select="concat('|F1:', $facilityOID, '|F2:', $facilityCode, '|F3:', $facilityDescription, '|C1:', $communityOID, '|C2:', $communityCode, '|C3:', $communityDescription, '|')"/>
	</xsl:template>
	
	<!-- <xsl:template match="hl7:id" mode="representedOrganizationId"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="LocationInformation"> SEE BASE TEMPLATE -->
	
	<!--
		ExternalId overrides SDA ExternalId with <id> values from
		the source CDA, if enabled by $sdaOverrideExternalId = 1,
		which is configurable in ImportProfile.xsl.
	-->
	<xsl:template match="*" mode="ExternalId">
		<xsl:if test="($sdaOverrideExternalId = 1)">
			<xsl:variable name="isUUID">
				<xsl:choose>
					<xsl:when test="not(string-length(hl7:id/@extension)) and not(string-length(hl7:id/@assigningAuthorityName)) and string-length(hl7:id/@root)>30 and contains(translate(hl7:id/@root,concat($lowerCase,'0123456789'),''),'---')">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="not($isUUID) and hl7:id[contains(@assigningAuthorityName, 'ExternalId') and not(@nullFlavor)]"><ExternalId><xsl:apply-templates select="hl7:id[contains(@assigningAuthorityName, 'ExternalId')]" mode="Id-External"/></ExternalId></xsl:when>
				<xsl:when test="not($isUUID) and hl7:id[(position() = 1) and not(@nullFlavor)]"><ExternalId><xsl:apply-templates select="hl7:id[1]" mode="Id-External"/></ExternalId></xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- <xsl:template match="*" mode="PlacerId"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="FillerId"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="Id"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="Id-External"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template name="ActionCode"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="EncounterID-Entry"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="code-for-oid"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="oid-for-code"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="importNarrative"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:br"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:table"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:thead"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:tbody"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:tr"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:th"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:td"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:content"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:paragraph"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:list"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:item"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="hl7:caption"> SEE BASE TEMPLATE -->
	
</xsl:stylesheet>
