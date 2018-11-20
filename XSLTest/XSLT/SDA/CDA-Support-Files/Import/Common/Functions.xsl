<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 sdtc xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="NarrativeLinks">
		<link id="{@ID}"><xsl:value-of select="text()"/></link>
	</xsl:template>
	
	<xsl:template match="*" mode="CodeTable">
		<xsl:param name="hsElementName"/>
		<xsl:param name="hsOrderType"/>
		<xsl:param name="subCodedElementRootPath"/>
		<xsl:param name="subElementName"/>
		<xsl:param name="subOrderType"/>
		<xsl:param name="hsOrderCategory"/>
		
		<!-- firstTranslationCodeSystem is the codeSystem attribute on the -->
		<!-- first, if any, <translation> for this code.  If it is the     -->
		<!-- "no code system" OID, then we know that that translation was  -->
		<!-- added by the standards compliant export.                      -->
		<xsl:variable name="firstTranslationCodeSystem"><xsl:value-of select="hl7:translation[1]/@codeSystem"/></xsl:variable>
				
		<xsl:choose>
		
			<xsl:when test="($firstTranslationCodeSystem=$noCodeSystemOID) or ((@nullFlavor) and (hl7:translation[1]/@code))">
				<xsl:element name="{$hsElementName}">
					<xsl:apply-templates select="." mode="CodeTableDetail">
						<xsl:with-param name="hsElementName" select="$hsElementName"/>
						<xsl:with-param name="useFirstTranslation" select="true()"/>
					</xsl:apply-templates>
					
					<xsl:if test="string-length($hsOrderType)"><OrderType><xsl:value-of select="$hsOrderType"/></OrderType></xsl:if>
					<xsl:if test="$subCodedElementRootPath = true()">
						<xsl:apply-templates select="$subCodedElementRootPath" mode="CodeTable">
							<xsl:with-param name="hsElementName" select="$subElementName"/>
							<xsl:with-param name="hsOrderType" select="$subOrderType"/>
						</xsl:apply-templates>
					</xsl:if>
					<xsl:if test="string-length($hsOrderType) and string-length($hsOrderCategory)">
						<OrderCategory><Code><xsl:value-of select="$hsOrderCategory"/></Code><OrderType><xsl:value-of select="$hsOrderType"/></OrderType></OrderCategory>
					</xsl:if>
				</xsl:element>
			</xsl:when>

			<xsl:when test="(string-length(.//hl7:reference/@value) or not(@nullFlavor)) and ($firstTranslationCodeSystem != $noCodeSystemOID)">
				<xsl:element name="{$hsElementName}">
					<xsl:apply-templates select="." mode="CodeTableDetail">
						<xsl:with-param name="hsElementName" select="$hsElementName"/>
						<xsl:with-param name="useFirstTranslation" select="false()"/>
					</xsl:apply-templates>
					
					<xsl:if test="string-length($hsOrderType)"><OrderType><xsl:value-of select="$hsOrderType"/></OrderType></xsl:if>
					<xsl:if test="$subCodedElementRootPath = true()">
						<xsl:apply-templates select="$subCodedElementRootPath" mode="CodeTable">
							<xsl:with-param name="hsElementName" select="$subElementName"/>
							<xsl:with-param name="hsOrderType" select="$subOrderType"/>
						</xsl:apply-templates>
					</xsl:if>
					<xsl:if test="string-length($hsOrderType) and string-length($hsOrderCategory)">
						<OrderCategory><Code><xsl:value-of select="$hsOrderCategory"/></Code><OrderType><xsl:value-of select="$hsOrderType"/></OrderType></OrderCategory>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			
		</xsl:choose>

	</xsl:template>
	
	<xsl:template match="*" mode="CodeTableDetail">
		<xsl:param name="hsElementName"/>
		<xsl:param name="useFirstTranslation"/>
		
		<xsl:variable name="codeSystemToUse">
			<xsl:choose>
				<xsl:when test="not($useFirstTranslation=true())">
					<xsl:choose>
						<xsl:when test="@codeSystem=$noCodeSystemOID"><xsl:value-of select="''"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@codeSystem"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="hl7:translation[1]/@codeSystem=$noCodeSystemOID"><xsl:value-of select="''"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="hl7:translation[1]/@codeSystem"/></xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
				
		<xsl:choose>
			<xsl:when test="not($useFirstTranslation=true())">
				<xsl:apply-templates select="." mode="SDACodingStandard"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:translation[1]" mode="SDACodingStandard"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="referenceLink" select=".//hl7:reference/@value"/>
		<xsl:variable name="referenceValue" select="normalize-space($narrativeLinks/link[@id = substring-after($referenceLink, '#')]/text())"/>
		
		<Code>
			<xsl:choose>
				<xsl:when test="not($useFirstTranslation=true())">
					<xsl:choose>
						<xsl:when test="@xsi:type = 'ST'"><xsl:value-of select="normalize-space(text())"/></xsl:when>
						<xsl:when test="@code"><xsl:value-of select="translate(@code, '_', ' ')"/></xsl:when>
						<xsl:when test="string-length($referenceValue)"><xsl:value-of select="$referenceValue"/></xsl:when>
						<xsl:when test="($hsElementName='OrderItem') and string-length($orderItemDefaultCode)"><xsl:value-of select="$orderItemDefaultCode"/></xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="hl7:translation[1]/@xsi:type = 'ST'"><xsl:value-of select="normalize-space(hl7:translation[1]/text())"/></xsl:when>
						<xsl:when test="hl7:translation[1]/@code"><xsl:value-of select="translate(hl7:translation[1]/@code, '_', ' ')"/></xsl:when>
						<xsl:when test="string-length($referenceValue)"><xsl:value-of select="$referenceValue"/></xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</Code>
		<Description>
			<xsl:choose>
				<xsl:when test="not($useFirstTranslation=true())">
					<xsl:choose>
						<xsl:when test="@xsi:type = 'ST'"><xsl:value-of select="normalize-space(text())"/></xsl:when>
						<xsl:when test="string-length($referenceValue)"><xsl:value-of select="$referenceValue"/></xsl:when>
						<xsl:when test="string-length(normalize-space(@displayName))"><xsl:value-of select="normalize-space(@displayName)"/></xsl:when>
						<xsl:when test="normalize-space(hl7:originalText/text())"><xsl:value-of select="normalize-space(hl7:originalText/text())"/></xsl:when>
						<xsl:when test="($hsElementName='OrderItem') and string-length($orderItemDefaultDescription)"><xsl:value-of select="$orderItemDefaultDescription"/></xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="hl7:translation[1]/@xsi:type = 'ST'"><xsl:value-of select="normalize-space(hl7:translation[1]/text())"/></xsl:when>
						<xsl:when test="string-length($referenceValue)"><xsl:value-of select="$referenceValue"/></xsl:when>
						<xsl:when test="string-length(normalize-space(hl7:translation[1]/@displayName))"><xsl:value-of select="normalize-space(hl7:translation[1]/@displayName)"/></xsl:when>
						<xsl:when test="normalize-space(hl7:originalText/text())"><xsl:value-of select="normalize-space(hl7:originalText/text())"/></xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</Description>
		
		<!-- Prior Codes -->
		<!-- Use property names of translatable types, not class names. So TestItemCode instead of LabTestItem, OrderItem instead of Order -->
		<xsl:if test="contains('|Allergy|Diagnosis|DrugProduct|TestItemCode|OrderItem|Procedure|', concat('|', $hsElementName, '|'))">
			<xsl:apply-templates select="." mode="PriorCodes">
				<xsl:with-param name="useFirstTranslation" select="$useFirstTranslation"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="TextValue">
		<xsl:variable name="referenceLink" select="normalize-space(.//hl7:reference/@value)"/>
		<xsl:variable name="referenceValue" select="$narrativeLinks/link[@id = substring-after($referenceLink, '#')]/text()"/>
		
		<xsl:choose>
			<xsl:when test="string-length($referenceValue)"><xsl:value-of select="$referenceValue"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="PriorCodes">
		<xsl:param name="useFirstTranslation"/>
		<!-- Only build PriorCodes if there is more than one translation, OR  -->
		<!-- there is only one translation and we did not use that one as the -->
		<!-- primary (current) data. -->
		<xsl:if test="(hl7:translation) and (not(count(hl7:translation)=1 or not($useFirstTranslation=true())))">
			<PriorCodes>
				<xsl:apply-templates select="hl7:translation[not(position()=1 and $useFirstTranslation=true())]" mode="PriorCode"/>
			</PriorCodes>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="PriorCode">
		<PriorCode>
			<CodeSystem><xsl:value-of select="isc:evaluate('getCodeForOID', @codeSystem, 'CodeSystem')"/></CodeSystem>
			<Code><xsl:value-of select="@code"/></Code>
			<Description><xsl:value-of select="@displayName"/></Description>
			<Type>A</Type>
		</PriorCode>
	</xsl:template>

	<xsl:template match="*" mode="SDACodingStandard">
		<xsl:if test="(string-length(@codeSystem)) and (not(@codeSystem=$noCodeSystemOID))"><SDACodingStandard><xsl:value-of select="isc:evaluate('getCodeForOID', @codeSystem, 'CodeSystem')"/></SDACodingStandard></xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="SendingFacility">
		<xsl:variable name="organizationInformation"><xsl:apply-templates select=".//hl7:representedOrganization" mode="OrganizationInformation"/></xsl:variable>
		
		<xsl:if test="string-length($organizationInformation)">
			<!-- Parse facility information -->
			<xsl:variable name="facilityOID" select="substring-before(substring-after($organizationInformation, 'F1:'), '|')"/>
			<xsl:variable name="facilityCode" select="substring-before(substring-after($organizationInformation, 'F2:'), '|')"/>
			<xsl:variable name="facilityDescription" select="substring-before(substring-after($organizationInformation, 'F3:'), '|')"/>
			
			<SendingFacility>
				<xsl:choose>
					<xsl:when test="string-length($facilityCode)"><xsl:value-of select="$facilityCode"/></xsl:when>
					<xsl:when test="string-length($facilityDescription)"><xsl:value-of select="$facilityDescription"/></xsl:when>
					<xsl:otherwise>Unknown</xsl:otherwise>
				</xsl:choose>
			</SendingFacility>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="PerformedAt">
		<xsl:apply-templates select="hl7:assignedEntity" mode="OrganizationDetail"><xsl:with-param name="elementName" select="'PerformedAt'"/></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="EnteredAt">
		<xsl:choose>
			<xsl:when test="hl7:informant"><xsl:apply-templates select="hl7:informant" mode="OrganizationDetail"/></xsl:when>
			<xsl:when test="hl7:author"><xsl:apply-templates select="hl7:author" mode="OrganizationDetail"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="$defaultAuthorRootPath" mode="OrganizationDetail"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="EnteringOrganization">
		<xsl:choose>
			<xsl:when test="hl7:informant">
				<xsl:apply-templates select="hl7:informant" mode="HealthCareFacilityDetail"><xsl:with-param name="elementName" select="'EnteringOrganization'"/></xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$defaultInformantRootPath" mode="HealthCareFacilityDetail"><xsl:with-param name="elementName" select="'EnteringOrganization'"/></xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="HealthCareFacility">
		<xsl:apply-templates select="." mode="HealthCareFacilityDetail"><xsl:with-param name="elementName" select="'HealthCareFacility'"/></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="HealthCareFacilityDetail">
		<xsl:param name="elementName"/>
		
		<xsl:variable name="organizationInformation"><xsl:apply-templates select=".//hl7:representedOrganization | .//hl7:serviceProviderOrganization" mode="OrganizationInformation"/></xsl:variable>
		
		<xsl:if test="string-length($elementName) and string-length($organizationInformation)">
			<!-- Parse facility information -->
			<xsl:variable name="facilityOID" select="substring-before(substring-after($organizationInformation, 'F1:'), '|')"/>
			<xsl:variable name="facilityCode" select="substring-before(substring-after($organizationInformation, 'F2:'), '|')"/>
			<xsl:variable name="facilityDescription" select="substring-before(substring-after($organizationInformation, 'F3:'), '|')"/>
			
			<!-- Parse community information -->
			<xsl:variable name="communityOID" select="substring-before(substring-after($organizationInformation, 'C1:'), '|')"/>
			<xsl:variable name="communityCode" select="substring-before(substring-after($organizationInformation, 'C2:'), '|')"/>
			<xsl:variable name="communityDescription" select="substring-before(substring-after($organizationInformation, 'C3:'), '|')"/>
			
			<xsl:element name="{$elementName}">
				<Code><xsl:value-of select="$facilityCode"/></Code>
				<Description><xsl:value-of select="$facilityDescription"/></Description>
				<Organization>
					<Code><xsl:value-of select="$communityCode"/></Code>
					<Description><xsl:value-of select="$communityDescription"/></Description>
					
					<xsl:apply-templates select="hl7:addr" mode="Address"/>
					<xsl:apply-templates select="." mode="ContactInfo"/>
				</Organization>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="OrganizationDetail">
		<xsl:param name="elementName" select="'EnteredAt'"/>
		
		<xsl:variable name="organizationInformation"><xsl:apply-templates select=".//hl7:representedOrganization" mode="OrganizationInformation"/></xsl:variable>
		
		<xsl:if test="string-length($organizationInformation)">
			<!-- Parse facility information -->
			<xsl:variable name="facilityOID" select="substring-before(substring-after($organizationInformation, 'F1:'), '|')"/>
			<xsl:variable name="facilityCode" select="substring-before(substring-after($organizationInformation, 'F2:'), '|')"/>
			<xsl:variable name="facilityDescription" select="substring-before(substring-after($organizationInformation, 'F3:'), '|')"/>
			
			<!-- Parse community information -->
			<xsl:variable name="communityOID" select="substring-before(substring-after($organizationInformation, 'C1:'), '|')"/>
			<xsl:variable name="communityCode" select="substring-before(substring-after($organizationInformation, 'C2:'), '|')"/>
			<xsl:variable name="communityDescription" select="substring-before(substring-after($organizationInformation, 'C3:'), '|')"/>
			
			<xsl:element name="{$elementName}">
				<Code><xsl:value-of select="$facilityCode"/></Code>
				<Description><xsl:value-of select="$facilityDescription"/></Description>
				
				<xsl:apply-templates select=".//hl7:representedOrganization/hl7:addr" mode="Address"/>
				<xsl:apply-templates select=".//hl7:representedOrganization" mode="ContactInfo"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="EnteredBy">
		<xsl:choose>
			<xsl:when test="hl7:author"><xsl:apply-templates select="hl7:author" mode="EnteredByDetail"/></xsl:when>
			<xsl:when test="hl7:assignedAuthor"><xsl:apply-templates select="." mode="EnteredByDetail"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="$defaultAuthorRootPath" mode="EnteredByDetail"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="EnteredByDetail">
		<xsl:if test="hl7:assignedAuthor/hl7:assignedPerson and not(hl7:assignedAuthor/hl7:assignedPerson/hl7:name/@nullFlavor)">
			<EnteredBy>
				<xsl:choose>
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

	<xsl:template match="*" mode="Informant">
		<xsl:choose>
			<xsl:when test="node()"><xsl:apply-templates select="." mode="EnteredAt"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="$defaultInformantRootPath" mode="EnteredAt"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="EnteredOn">
		<xsl:if test="@value"><EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></EnteredOn></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="FromTime">
		<xsl:if test="@value"><FromTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></FromTime></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="ToTime">
		<xsl:if test="@value"><ToTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ToTime></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="StartTime">
		<xsl:if test="@value"><StartTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></StartTime></xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="EndTime">
		<xsl:if test="@value"><EndTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></EndTime></xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="AttendingClinicians">
		<AttendingClinicians>
			<xsl:apply-templates select="." mode="CareProvider"/>
		</AttendingClinicians>
	</xsl:template>

	<xsl:template match="*" mode="ConsultingClinicians">
		<ConsultingClinicians>
			<xsl:apply-templates select="." mode="CareProvider"/>
		</ConsultingClinicians>
	</xsl:template>
	
	<xsl:template match="*" mode="AdmittingClinician">
		<AdmittingClinician>
			<xsl:apply-templates select="." mode="CareProviderDetail"/>
		</AdmittingClinician>
	</xsl:template>

	<xsl:template match="*" mode="ReferringClinician">
		<ReferringClinician>
			<xsl:apply-templates select="." mode="DoctorDetail"/>
		</ReferringClinician>
	</xsl:template>

	<xsl:template match="*" mode="FamilyDoctor">
		<FamilyDoctor>
			<xsl:apply-templates select="." mode="DoctorDetail"/>
		</FamilyDoctor>
	</xsl:template>
	
	<xsl:template match="*" mode="Clinician">
		<Clinician>
			<xsl:apply-templates select="." mode="CareProviderDetail"/>
		</Clinician>
	</xsl:template>

	<xsl:template match="*" mode="DiagnosingClinician">
		<DiagnosingClinician>
			<xsl:apply-templates select="." mode="CareProviderDetail"/>
		</DiagnosingClinician>
	</xsl:template>

	<xsl:template match="*" mode="OrderedBy">
		<OrderedBy>
			<xsl:apply-templates select="." mode="CareProviderDetail"/>
		</OrderedBy>
	</xsl:template>

	<xsl:template match="*" mode="OrderedBy-Author">
		<OrderedBy>
			<xsl:choose>
				<xsl:when test="hl7:assignedAuthor/hl7:code and not(hl7:assignedAuthor/hl7:code/@nullFlavor)">
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
		</OrderedBy>
	</xsl:template>

	<xsl:template match="*" mode="CareProvider">
		<CareProvider>
			<xsl:apply-templates select="." mode="CareProviderDetail"/>
		</CareProvider>
	</xsl:template>
	
	<xsl:template match="*" mode="CareProviderDetail">
		<xsl:variable name="entityPath" select="hl7:assignedEntity | hl7:associatedEntity"/>
		
		<xsl:if test="$entityPath = true()">
			<xsl:variable name="personPath" select="$entityPath/hl7:assignedPerson | $entityPath/hl7:associatedPerson"/>
			
			<xsl:if test="$personPath = true() and not($personPath/hl7:name/@nullFlavor)">
				<xsl:variable name="clinicianFunction" select="hl7:functionCode"/>
				<xsl:variable name="clinicianAssigningAuthority" select="isc:evaluate('getCodeForOID', $entityPath/hl7:id/@root, 'AssigningAuthority')"/>
				<xsl:variable name="clinicianID" select="$entityPath/hl7:id/@extension"/>
				<xsl:variable name="clinicianName"><xsl:apply-templates select="$personPath/hl7:name" mode="ContactNameString"/></xsl:variable>
				
				<xsl:if test="string-length($clinicianAssigningAuthority)"><SDACodingStandard><xsl:value-of select="$clinicianAssigningAuthority"/></SDACodingStandard></xsl:if>
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
				<xsl:if test="$clinicianFunction = true()">
					<CareProviderType>
						<Code><xsl:value-of select="$clinicianFunction/@code"/></Code>
						<Description><xsl:value-of select="$clinicianFunction/@displayName"/></Description>
					</CareProviderType>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- This is the same as CareProviderDetail, except there's no functionCode support due to SDA limitations in FamilyDoctor and ReferringClinician. -->
	<xsl:template match="*" mode="DoctorDetail">
		<xsl:variable name="entityPath" select="hl7:assignedEntity | hl7:associatedEntity"/>
		
		<xsl:if test="$entityPath = true()">
			<xsl:variable name="personPath" select="$entityPath/hl7:assignedPerson | $entityPath/hl7:associatedPerson"/>
			
			<xsl:if test="$personPath = true() and not($personPath/hl7:name/@nullFlavor)">
				<xsl:variable name="clinicianAssigningAuthority" select="isc:evaluate('getCodeForOID', $entityPath/hl7:id/@root, 'AssigningAuthority')"/>
				<xsl:variable name="clinicianID" select="$entityPath/hl7:id/@extension"/>
				<xsl:variable name="clinicianName"><xsl:apply-templates select="$personPath/hl7:name" mode="ContactNameString"/></xsl:variable>
					
				<xsl:if test="string-length($clinicianAssigningAuthority)"><SDACodingStandard><xsl:value-of select="$clinicianAssigningAuthority"/></SDACodingStandard></xsl:if>
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

	<xsl:template match="*" mode="ContactName">
		<xsl:param name="elementName" select="'Name'"/>
		
		<xsl:if test="not(@nullFlavor)">
			<xsl:variable name="contactNamePrefix" select="hl7:prefix/text()"/>
			<xsl:variable name="contactNameGiven">
				<xsl:choose>
					<xsl:when test="string-length(hl7:given[1]/text())"><xsl:value-of select="hl7:given[1]/text()"/></xsl:when>
					<xsl:when test="string-length(normalize-space(text())) and contains(text(), ',')"><xsl:value-of select="normalize-space(substring-after(text(), ','))"/></xsl:when>
					<xsl:when test="string-length(normalize-space(text())) and contains(text(), ' ')"><xsl:value-of select="normalize-space(substring-before(text(), ' '))"/></xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="contactNameMiddle" select="hl7:given[2]/text()"/>
			<xsl:variable name="contactNameLast">
				<xsl:choose>
					<xsl:when test="string-length(hl7:family/text())"><xsl:value-of select="hl7:family/text()"/></xsl:when>
					<xsl:when test="string-length(normalize-space(text())) and contains(text(), ',')"><xsl:value-of select="normalize-space(substring-before(text(), ','))"/></xsl:when>
					<xsl:when test="string-length(normalize-space(text())) and contains(text(), ' ')"><xsl:value-of select="normalize-space(substring-after(text(), ' '))"/></xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="contactNameSuffix" select="hl7:suffix/text()"/>
			
			<xsl:element name="{$elementName}">
				<xsl:if test="string-length($contactNameLast)"><FamilyName><xsl:value-of select="$contactNameLast"/></FamilyName></xsl:if>
				<xsl:if test="string-length($contactNamePrefix)"><NamePrefix><xsl:value-of select="$contactNamePrefix"/></NamePrefix></xsl:if>
				<xsl:if test="string-length($contactNameGiven)"><GivenName><xsl:value-of select="$contactNameGiven"/></GivenName></xsl:if>
				<xsl:if test="string-length($contactNameMiddle)"><MiddleName><xsl:value-of select="$contactNameMiddle"/></MiddleName></xsl:if>
				<xsl:if test="string-length($contactNameSuffix)"><ProfessionalSuffix><xsl:value-of select="$contactNameSuffix"/></ProfessionalSuffix></xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="ContactNameString">
		<xsl:choose>
			<xsl:when test="string-length(normalize-space(text()))"><xsl:value-of select="normalize-space(text())"/></xsl:when>
			<xsl:when test="string-length(hl7:given[1]/text()) and string-length(hl7:family/text())"><xsl:value-of select="concat(hl7:family/text(), ',', hl7:given[1]/text())"/></xsl:when>
			<xsl:when test="string-length(hl7:family/text())"><xsl:value-of select="hl7:family/text()"/></xsl:when>
			<xsl:when test="string-length(hl7:given[1]/text())"><xsl:value-of select="hl7:given[1]/text()"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="Addresses">
		<xsl:if test="hl7:addr[not(@nullFlavor)]">
			<Address>
				<!-- Process CDA Append/Transform/Replace Directive:  Not yet supported in SDA..
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'Address'"/>
				</xsl:call-template>
				-->
				
				<xsl:apply-templates select="hl7:addr" mode="Address"/>
			</Address>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="Address">
		<xsl:param name="elementName" select="'Address'"/>
		
		<xsl:choose>
			<xsl:when test="@nullFlavor"/>
			<xsl:when test="string-length(normalize-space(text()))"><xsl:element name="{$elementName}"><Street><xsl:value-of select="normalize-space(text())"/></Street></xsl:element></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$elementName}">
					<xsl:if test="string-length(hl7:useablePeriod/hl7:low/@value)"><StartDate><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:useablePeriod/hl7:low/@value)"/></StartDate></xsl:if>
					<xsl:if test="string-length(hl7:useablePeriod/hl7:high/@value)"><EndDate><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:useablePeriod/hl7:high/@value)"/></EndDate></xsl:if>
					
					<xsl:if test="hl7:streetAddressLine">
						<Street>
							<xsl:apply-templates select="hl7:streetAddressLine"/>
						</Street>
					</xsl:if>
					<xsl:if test="hl7:city">
						<City>
							<Code><xsl:value-of select="normalize-space(hl7:city/text())"/></Code>
						</City>
					</xsl:if>
					<xsl:if test="hl7:state">
						<State>
							<Code><xsl:value-of select="normalize-space(hl7:state/text())"/></Code>
						</State>
					</xsl:if>
					<xsl:if test="hl7:postalCode">
						<Zip>
							<Code><xsl:value-of select="normalize-space(hl7:postalCode/text())"/></Code>
						</Zip>
					</xsl:if>
					<xsl:if test="hl7:country">
						<Country>
							<Code><xsl:value-of select="normalize-space(hl7:country/text())"/></Code>
						</Country>
					</xsl:if>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="hl7:streetAddressLine">
		<xsl:if test="position()>1">; </xsl:if>
		<xsl:value-of select="normalize-space(text())"/>
	</xsl:template>
	
	<xsl:template match="*" mode="ContactInfo">
		<xsl:param name="elementName" select="'ContactInfo'"/>
		
		<xsl:if test="hl7:telecom[not(@nullFlavor)]">
			<xsl:element name="{$elementName}">
				<xsl:for-each select="hl7:telecom[not(@nullFlavor)]">
					<xsl:variable name="homeTelecomUse">,H,HP,HV,PRN,</xsl:variable>
					<xsl:variable name="workTelecomUse">,W,WP,WPN,</xsl:variable>
					<xsl:variable name="mobileTelecomUse">,MC,</xsl:variable>
					<xsl:variable name="emailTelecomUse">,NET,</xsl:variable>
					<xsl:variable name="telecomUse" select="concat(',', @use, ',')"/>
					<xsl:variable name="telecomValue">
						<xsl:choose>
							<xsl:when test="contains(@value, ':')"><xsl:value-of select="substring-after(@value, ':')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
			
					<xsl:choose>
						<xsl:when test="contains($homeTelecomUse, $telecomUse)"><HomePhoneNumber><xsl:value-of select="$telecomValue"/></HomePhoneNumber></xsl:when>
						<xsl:when test="contains($workTelecomUse, $telecomUse)"><WorkPhoneNumber><xsl:value-of select="$telecomValue"/></WorkPhoneNumber></xsl:when>
						<xsl:when test="contains($mobileTelecomUse, $telecomUse)"><MobilePhoneNumber><xsl:value-of select="$telecomValue"/></MobilePhoneNumber></xsl:when>
						<xsl:when test="contains($emailTelecomUse, $telecomUse)"><EmailAddress><xsl:value-of select="$telecomValue"/></EmailAddress></xsl:when>
						<xsl:when test="not(string-length(@use)) and contains(@value,'mailto:')"><EmailAddress><xsl:value-of select="$telecomValue"/></EmailAddress></xsl:when>
						<xsl:when test="not(string-length(@use))"><HomePhoneNumber><xsl:value-of select="$telecomValue"/></HomePhoneNumber></xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="OrganizationInformation">
		<xsl:variable name="wholeOrganizationRootPath" select="hl7:asOrganizationPartOf/hl7:wholeOrganization"/>
		
		<!-- Get community information -->
		<xsl:variable name="communityOID">
			<xsl:choose>
				<xsl:when test="$wholeOrganizationRootPath"><xsl:value-of select="$wholeOrganizationRootPath/hl7:id/@root"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="hl7:id/@root"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communityCode"><xsl:value-of select="isc:evaluate('getCodeForOID', $communityOID, 'HomeCommunity')"/></xsl:variable>
		<xsl:variable name="communityDescription">
			<xsl:choose>
				<xsl:when test="$wholeOrganizationRootPath"><xsl:value-of select="$wholeOrganizationRootPath/hl7:name/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="hl7:name/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Get facility information. This provides for the -->
		<!-- possibility that there may be a nullFlavor <id> -->
		<!-- before any non-nullFlavor <id>'s that have the  -->
		<!-- facility data.                                  -->
		<xsl:variable name="idRootExt">
			<xsl:for-each select="hl7:id">
				<xsl:choose>
					<xsl:when test="string-length(@root) and not(number(@extension)) and not(@displayable='true')">
						<xsl:value-of select="concat(@root, '/')"/>
					</xsl:when>
					<xsl:when test="string-length(@root) and number(@extension) and not(@displayable='true')">
						<xsl:value-of select="concat(@root, '.', @extension, '/')"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="facilityOID" select="substring-before($idRootExt,'/')"/>
		<xsl:variable name="facilityCode"><xsl:value-of select="isc:evaluate('getCodeForOID', $facilityOID, 'Facility')"/></xsl:variable>
		<xsl:variable name="facilityDescription"><xsl:if test="node()"><xsl:value-of select="hl7:name/text()"/></xsl:if></xsl:variable>
		
		<!-- Reponse format:  |F1:Facility OID|F2:Facility Code|F3:Facility Description|C1:Community OID|C2:Community Code|C3:Community Description| -->
		<xsl:value-of select="concat('|F1:', $facilityOID, '|F2:', $facilityCode, '|F3:', $facilityDescription, '|C1:', $communityOID, '|C2:', $communityCode, '|C3:', $communityDescription, '|')"/>
	</xsl:template>	

	<xsl:template match="*" mode="ExternalId">
		<xsl:if test="($sdaOverrideExternalId = 1)">
			<xsl:choose>
				<xsl:when test="hl7:id[contains(@assigningAuthorityName, 'ExternalId') and not(@nullFlavor)]"><ExternalId><xsl:apply-templates select="hl7:id[contains(@assigningAuthorityName, 'ExternalId')]" mode="Id-External"/></ExternalId></xsl:when>
				<xsl:when test="hl7:id[(position() = 1) and not(@nullFlavor)]"><ExternalId><xsl:apply-templates select="hl7:id[1]" mode="Id-External"/></ExternalId></xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>	

	<xsl:template match="*" mode="PlacerId">
		<xsl:choose>
			<xsl:when test="hl7:id[contains(@assigningAuthorityName, '-PlacerId') and not(@nullFlavor)]"><PlacerId><xsl:apply-templates select="hl7:id[contains(@assigningAuthorityName, '-PlacerId')]" mode="Id"/></PlacerId></xsl:when>
			<xsl:when test="hl7:id[(position() = 2) and not(@nullFlavor)]"><PlacerId><xsl:apply-templates select="hl7:id[2]" mode="Id"/></PlacerId></xsl:when>
			<xsl:otherwise><PlacerId><xsl:value-of select="isc:evaluate('createGUID')"/></PlacerId></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="FillerId">
		<xsl:choose>
			<xsl:when test="hl7:id[contains(@assigningAuthorityName, '-FillerId') and not(@nullFlavor)]"><FillerId><xsl:apply-templates select="hl7:id[contains(@assigningAuthorityName, '-FillerId')]" mode="Id"/></FillerId></xsl:when>
			<xsl:when test="hl7:id[(position() = 3) and not(@nullFlavor)]"><FillerId><xsl:apply-templates select="hl7:id[3]" mode="Id"/></FillerId></xsl:when>
			<xsl:otherwise><FillerId><xsl:value-of select="isc:evaluate('createGUID')"/></FillerId></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="Id">
		<xsl:choose>
			<xsl:when test="@extension"><xsl:value-of select="@extension"/></xsl:when>
			<xsl:when test="@root"><xsl:value-of select="@root"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="isc:evaluate('createGUID')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="Id-External">
		<xsl:choose>
			<xsl:when test="@extension"><xsl:value-of select="concat(isc:evaluate('getCodeForOID', @root, 'Facility'), '|', @extension)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@root"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ActionCode">
		<xsl:param name="informationType"/>
		<xsl:param name="actionScope"/>

		<xsl:if test="($sdaActionCodesEnabled = 1) and string-length($documentActionCode) and string-length($informationType) and (position() = 1)">
			<xsl:choose>
				<xsl:when test="($documentActionCode = 'APND')">
					<xsl:choose>
						<xsl:when test="$informationType = 'Patient'"/>
						<xsl:when test="$informationType = 'Encounter'"><ActionCode>A</ActionCode></xsl:when>
						<xsl:otherwise>
							<xsl:element name="{$informationType}">
								<ActionCode>A</ActionCode>
								<xsl:if test="string-length($actionScope)"><ActionScope><xsl:value-of select="$actionScope"/></ActionScope></xsl:if>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="($documentActionCode = 'RPLC')">
					<xsl:choose>
						<xsl:when test="$informationType = 'Patient'"><ActionCode>R</ActionCode></xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="($documentActionCode = 'XFRM')">
					<xsl:choose>
						<xsl:when test="$informationType = 'Patient'"/>
						<xsl:when test="$informationType = 'Encounter'"><ActionCode>R</ActionCode></xsl:when>
						<xsl:otherwise>
							<xsl:element name="{$informationType}">
								<ActionCode>C</ActionCode>
								<xsl:if test="string-length($actionScope)"><ActionScope><xsl:value-of select="$actionScope"/></ActionScope></xsl:if>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>			
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
