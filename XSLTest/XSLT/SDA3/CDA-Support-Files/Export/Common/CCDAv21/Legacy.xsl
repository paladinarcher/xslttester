<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc"
	xmlns:isc="http://extension-functions.intersystems.com" exclude-result-prefixes="isc">
	
	<!-- Keys to encounter data -->
	<xsl:key name="EncNum" match="Encounter" use="EncounterNumber"/>
	
	<xsl:template match="*" mode="code">
		<!-- **The code template is deprecated as of HealthShare Core 13.**  Please use template fn-generic-Coded. -->
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>
		
		<xsl:apply-templates select="." mode="fn-generic-Coded">
			<xsl:with-param name="narrativeLink" select="$narrativeLink"/>
			<xsl:with-param name="xsiType" select="$xsiType"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="participant">
		<participant typeCode="IND">
			<xsl:apply-templates select="." mode="fn-time"/>
			<xsl:apply-templates select="." mode="fn-participantRole"/>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="fn-participantRole">
		<!-- This mode seems to be UNUSED, except by the mode above -->
		<participantRole>
			<xsl:apply-templates select="." mode="fn-id-Clinician"/>
			<xsl:apply-templates select="." mode="fn-address-WorkPrimary"/>
			<xsl:apply-templates select="." mode="fn-telecom"/>
			<xsl:apply-templates select="." mode="fn-playingEntity"/>
		</participantRole>
	</xsl:template>
	
	<xsl:template match="*" mode="fn-playingEntity">
		<!-- This mode seems to be UNUSED, except by the unused mode above -->
		<playingEntity>
			<xsl:apply-templates select="." mode="fn-name-Person"/>
		</playingEntity>
	</xsl:template>
	
	<xsl:template match="Organization" mode="representedCustodianOrganization">
		<xsl:choose>
			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="organizationName">
					<xsl:apply-templates select="Code" mode="fn-code-to-description">
						<xsl:with-param name="identityType" select="'Facility'"/>
						<xsl:with-param name="defaultDescription" select="Description/text()"/>
					</xsl:apply-templates>
				</xsl:variable>
				
				<representedCustodianOrganization>
					<!--
						C-CDA validation on custodian section specifically wants
						only one <id>.  Don't use the id-Facility template here.
					-->
					<xsl:variable name="facilityOID">
						<xsl:apply-templates select="Code" mode="fn-code-to-oid"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="string-length(Code/text())">
							<id>
								<xsl:attribute name="root"><xsl:value-of select="$facilityOID"/></xsl:attribute>
							</id>
						</xsl:when>
						<xsl:otherwise>
							<id nullFlavor="{$idNullFlavor}"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="string-length($organizationName)">
							<name><xsl:value-of select="$organizationName"/></name>
						</xsl:when>
						<xsl:otherwise>
							<name nullFlavor="UNK"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates select="." mode="fn-telecom"/>
					<xsl:apply-templates select="." mode="fn-address-WorkPrimary"/>
				</representedCustodianOrganization>
			</xsl:when>
			<xsl:otherwise>
				<representedCustodianOrganization>
					<id nullFlavor="{$idNullFlavor}"/>
					<name nullFlavor="UNK"/>
					<telecom nullFlavor="UNK"/>
					<addr nullFlavor="{$addrNullFlavor}"/>
				</representedCustodianOrganization>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="id-sdtcPatient">
		<xsl:param name="xpathContext"/>
		
		<xsl:if test="$xpathContext = true()">
			<!-- EncNum key is declared at top of this file. It returns Encounter elements. -->
			<xsl:variable name="encounterContext" select="key('EncNum', $xpathContext/EncounterNumber)[1]"/>
			<xsl:choose>
				<xsl:when test="$encounterContext = true()">
					<xsl:apply-templates select="$encounterContext[string-length(EnteredAt/Code/text()) and string-length(EncounterMRN/text())]" mode="sdtc-Patient"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="fn-id-sdtcPatient">
						<xsl:with-param name="xpathContext" select="$xpathContext/.."/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Encounter" mode="sdtc-Patient">
	  <!-- As you can see, this is just a pass-through to another template -->
	  <sdtc:patient>
			<sdtc:id>
				<xsl:attribute name="root">
				  <xsl:apply-templates select="EnteredAt/Code" mode="code-to-oid"><xsl:with-param name="identityType" select="'Facility'"/></xsl:apply-templates>
				</xsl:attribute>
				<xsl:attribute name="extension"><xsl:value-of select="EncounterMRN/text()"/></xsl:attribute>
			</sdtc:id>
		</sdtc:patient>
	</xsl:template>
	
	<xsl:template match="Interpretation" mode="code-interpretation">
		<!--
			Field : Result Interpretation
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.3.1']/entry/organizer/component/observation/interpretationCode
			Source: HS.SDA3.LabResultItem ResultInterpretation
			Source: /Container/LabOrders/LabOrder/Result/ResultItems/LabResultItem/ResultInterpretation
			StructuredMappingRef: generic-Coded
		-->
		<xsl:apply-templates select="." mode="fn-generic-Coded">
			<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$observationInterpretationOID"/></xsl:with-param>
			<xsl:with-param name="writeOriginalText">0</xsl:with-param>
			<xsl:with-param name="cdaElementName">interpretationCode</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="EncounterType" mode="encounter-IsValid">
		<xsl:choose>
			<xsl:when test="contains('|I|O|E|', concat('|', text(), '|'))">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="narrativeLink-EncounterSuffix">
		<xsl:param name="entryNumber"/>
		<!-- EncNum key is declared at top of this file. It returns Encounter elements. -->
		<xsl:variable name="encounter" select="key('EncNum', EncounterNumber)"/>
		<xsl:variable name="encounterNumber">
			<xsl:apply-templates select="$encounter/EncounterNumber" mode="fn-encounterNumber-converted"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($encounter) > 0">
				<xsl:value-of
					select="concat(translate($encounter/HealthCareFacility/Organization/Code/text(), ' ', '_'), '.', $encounterNumber, '.', $entryNumber)"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$entryNumber"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="fn-time-EnteredOn">
		<!-- This mode isolates a form of fn-time that may have been used in
			   the past, but had no known usages now. -->
		<xsl:choose>
			<xsl:when test="local-name() = 'EnteredOn'">
				<time>
					<xsl:attribute name="value">
						<xsl:apply-templates select="." mode="fn-xmlToHL7TimeStamp"/>
					</xsl:attribute>
				</time>
			</xsl:when>
			<xsl:otherwise>
				<time nullFlavor="UNK"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="effectiveTime-procedure">
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(ProcedureTime)">
					<xsl:attribute name="value">
						<xsl:apply-templates select="ProcedureTime" mode="fn-xmlToHL7TimeStamp"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<!-- ***************************** TEMPLATES FOR SPECIFIC SECTIONS OR ENTRIES BELOW ************************************ -->
	
	<!-- Use fn-effectiveTime-FromTo with appropriate parameters instead of this. -->
	<xsl:template match="AdvanceDirective" mode="eAD-effectiveTime-AdvanceDirective">
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(FromTime/text())">
					<low><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="NA"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(ToTime/text())">
					<high><xsl:attribute name="value"><xsl:apply-templates select="ToTime" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></high>
				</xsl:when>
				<xsl:when test="not(string-length(ToTime/text()))">
					<high nullFlavor="NA"/>
				</xsl:when>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
	<!-- Use fn-effectiveTime-FromTo with appropriate parameters instead of this. -->
	<xsl:template match="*" mode="eIP-effectiveTime-healthPlan">
		<effectiveTime>
			<xsl:choose>
				<xsl:when test="string-length(FromTime)">
					<low>
						<xsl:attribute name="value">
							<xsl:apply-templates select="FromTime" mode="fn-xmlToHL7TimeStamp"/>
						</xsl:attribute>
					</low>
				</xsl:when>
				<xsl:otherwise>
					<low nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length(ToTime)">
					<high>
						<xsl:attribute name="value">
							<xsl:apply-templates select="ToTime" mode="fn-xmlToHL7TimeStamp"/>
						</xsl:attribute>
					</high>
				</xsl:when>
				<xsl:otherwise>
					<high nullFlavor="UNK"/>
				</xsl:otherwise>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>
	
  <xsl:template match="DrugProduct | OrderItem" mode="eM-medication-manufacturedMaterial">
    <xsl:param name="narrativeLink"/>
    
    <manufacturedMaterial classCode="MMAT" determinerCode="KIND">
      <!--
				This field has some unique requirements.  See HITSP/C83 v2.0
				sections 2.2.2.8.10 through 2.2.2.8.14.  <translation> is
				used here differently than <translation> on just about every
				other CDA export coded field.  Plus this field has two code
				systems that are valid for it, instead of just one.
			-->
      <xsl:variable name="sdaCodingStandardOID"><xsl:apply-templates select="." mode="fn-oid-for-code"><xsl:with-param name="Code" select="SDACodingStandard/text()"/></xsl:apply-templates></xsl:variable>			
      <xsl:variable name="description"><xsl:apply-templates select="." mode="fn-descriptionOrCode"/></xsl:variable>
      <!--
				StructuredMapping: medication-manufacturedMaterial
				
				Field
				Path  : manufacturedProduct/manufacturedMaterial/code/@code
				Source: Code
				Source: Code/text()
				Note  : The code element is exported with attributes only when the SDA OrderItem SDACodingStandard indicates RXNORM.
				
				Field
				Path  : manufacturedProduct/manufacturedMaterial/code/@displayName
				Source: Description
				Source: Description/text()
				Note  : The code element is exported with attributes only when the SDA OrderItem SDACodingStandard indicates RXNORM or NDC (National Drug Codes).
				
				Field
				Path  : manufacturedProduct/manufacturedMaterial/code/translation/@code
				Source: Code
				Source: Code/text()
				Note  : The code translation element is exported only when the SDA OrderItem SDACodingStandard indicates RXNORM or NDC (National Drug Codes).
				
				Field
				Path  : manufacturedProduct/manufacturedMaterial/code/translation/@displayName
				Source: Description
				Source: Description/text()
				Note  : The code translation element is exported only when the SDA OrderItem SDACodingStandard indicates RXNORM or NDC (National Drug Codes).
				
				Field
				Path  : manufacturedProduct/manufacturedMaterial/name/text()
				Source: ProductName
				Source: ProductName/text()
				Note  : If ProductName is not present then Description is used.
			-->
      <xsl:choose>
        <xsl:when test="$sdaCodingStandardOID=$rxNormOID or $sdaCodingStandardOID=$ndcOID">
          <code code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{$description}">
            <originalText><reference value="{$narrativeLink}"/></originalText>
            <translation code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{$description}"/>
          </code>
        </xsl:when>
        <xsl:otherwise>
          <code nullFlavor="UNK">
            <originalText><reference value="{$narrativeLink}"/></originalText>
            <translation nullFlavor="UNK"/>
          </code>
        </xsl:otherwise>
      </xsl:choose>
      
      <name>
        <xsl:choose>
          <xsl:when test="string-length(ProductName)"><xsl:value-of select="ProductName/text()"/></xsl:when>
          <xsl:when test="string-length($description)"><xsl:value-of select="$description"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="'Unknown Medication'"/></xsl:otherwise>
        </xsl:choose>
      </name>
    </manufacturedMaterial>
  </xsl:template>
  
  <!-- Use fn-effectiveTime-singleton instead of this. -->
	<xsl:template match="*" mode="eR-effectiveTime-Result">
		<xsl:choose>
			<xsl:when test="string-length(ResultTime)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="ResultTime" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Use fn-effectiveTime-singletonChoice instead of this. -->
	<xsl:template match="Vaccination" mode="eI-effectiveTime-Immunization">
		<!--
			Field : Immunization Administered Date/Time
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.2.1']/entry/substanceAdministration/effectiveTime/@value
			Source: HS.SDA3.AbstractOrder FromTime
			Source: /Container/Vaccinations/Vaccination/FromTime
			Source: /Container/Vaccinations/Vaccination/EnteredOn
			Note  : CDA effectiveTime for Immunization uses only a single time
					value, SDA FromTime or EnteredOn, whichever is found first.
		-->
		<xsl:choose>
			<xsl:when test="string-length(FromTime)">
				<effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="FromTime" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime>
			</xsl:when>
			<xsl:when test="string-length(EnteredOn)">
				<effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="EnteredOn" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime>
			</xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="eCm-comment-entryRelationship">
		<xsl:param name="narrativeLink"/>
		<!-- This has been renamed to eCm-entryRelationship-comments, which does the same thing. -->
		
		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<xsl:apply-templates select="." mode="eCm-act-comment"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="ePOC-observation-PlanStatus">
		<!-- This mode is UNUSED -->
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="ePOC-templateIds-planStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="translate(text(), $lowerCase, $upperCase)"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">55561003</xsl:when>
								<xsl:when test="$statusValue = 'H'">421139008</xsl:when>
								<xsl:otherwise>73425007</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">Active</xsl:when>
								<xsl:when test="$statusValue = 'H'">On Hold</xsl:when>
								<xsl:otherwise>Inactive</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="fn-snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="ePOC-organizationName">
		<xsl:apply-templates select="." mode="fn-descriptionOrCode"/>
	</xsl:template>
	
</xsl:stylesheet>