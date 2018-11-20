<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<!-- QRDA OVERRIDE of assignedAuthor-Device adds nullFlavor to addr sub-elements, to pass validator check. -->
	<xsl:template match="*" mode="assignedAuthor-Device">
		<assignedAuthor classCode="ASSIGNED">
			<!-- HealthShare ID -->
			<xsl:apply-templates select="." mode="id-HealthShare"/>
			
			<addr nullFlavor="{$addrNullFlavor}">
				<streetAddressLine nullFlavor="{$addrNullFlavor}"/>
				<city nullFlavor="{$addrNullFlavor}"/>
				<state nullFlavor="{$addrNullFlavor}"/>
				<postalCode nullFlavor="{$addrNullFlavor}"/>
			</addr>
			<telecom nullFlavor="UNK"/>
			
			<!-- Software Device -->
			<xsl:apply-templates select="." mode="assignedAuthoringDevice"/>
			
			<!-- Represented Organization -->
			<xsl:apply-templates select="." mode="representedOrganization-Document"/>
		</assignedAuthor>
	</xsl:template>
	
	<!-- QRDA OVERRIDE of effectiveTime-procedure adds high nullFlavor="UNK" -->
	<xsl:template match="*" mode="effectiveTime-procedure">
		<effectiveTime>
			<low>
				<xsl:choose>
					<xsl:when test="string-length(ProcedureTime)">
						<xsl:attribute name="value"><xsl:apply-templates select="ProcedureTime" mode="xmlToHL7TimeStamp"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</low>
			<high nullFlavor="UNK"/>
		</effectiveTime>
	</xsl:template>
	
	<!-- QRDA OVERRIDE of effectiveTime-Identification adds high nullFlavor="UNK" -->
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
			<high nullFlavor="UNK"/>
		</effectiveTime>
	</xsl:template>
	
	<!-- QRDA OVERRIDE of code-ethnicGroup adds hard-coded value set OID. -->
	<xsl:template match="EthnicGroup" mode="code-ethnicGroup">
	
		<xsl:variable name="valueSet">|2135-2!Hispanic or Latino|2186-5!Not Hispanic or Latino|</xsl:variable>
		
		<!-- descriptionFromValueSet is the indicator that Code/text() is in the value set. -->
		<xsl:variable name="descriptionFromValueSet">
			<xsl:value-of select="substring-before(substring-after($valueSet,concat('|',Code/text(),'!')),'|')"/>
		</xsl:variable>
		
		<xsl:variable name="displayName">
			<xsl:choose>
				<xsl:when test="string-length($descriptionFromValueSet)"><xsl:value-of select="$descriptionFromValueSet"/></xsl:when>
				<xsl:when test="string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="originalText">
			<xsl:choose>
				<xsl:when test="string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$displayName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="codeSystem">
			<xsl:choose>
				<xsl:when test="SDACodingStandard/text()=$raceAndEthnicityCDCName or SDACodingStandard/text()=$raceAndEthnicityCDCOID">
					<xsl:value-of select="$raceAndEthnicityCDCOID"/>
				</xsl:when>
				<xsl:when test="string-length(SDACodingStandard/text())">
					<xsl:apply-templates select="." mode="oid-for-code">
						<xsl:with-param name="Code" select="SDACodingStandard/text()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="codeSystemName">
			<xsl:choose>
				<xsl:when test="$codeSystem=$raceAndEthnicityCDCOID">
					<xsl:value-of select="$raceAndEthnicityCDCName"/>
				</xsl:when>
				<xsl:when test="string-length(SDACodingStandard/text())">
					<xsl:value-of select="SDACodingStandard/text()"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($descriptionFromValueSet) and $codeSystem=$raceAndEthnicityCDCOID">
				<ethnicGroupCode code="{Code/text()}" codeSystem="{$codeSystem}" codeSystemName="{$codeSystemName}" sdtc:valueSet="2.16.840.1.114222.4.11.837" displayName="{$displayName}">
					<originalText><xsl:value-of select="$originalText"/></originalText>
				</ethnicGroupCode>
			</xsl:when>
			<xsl:otherwise>
				<ethnicGroupCode nullFlavor="OTH">
					<originalText><xsl:value-of select="$originalText"/></originalText>
					<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystem}" codeSystemName="{$codeSystemName}" displayName="{$displayName}"/>
				</ethnicGroupCode>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- generic-Coded has common logic for handling coded element fields. -->
	<!-- QRDA OVERRIDE of generic-Coded adds handling of value set OID. -->
	<xsl:template match="*" mode="generic-Coded">
		<xsl:param name="narrativeLink"/>
		<xsl:param name="xsiType"/>
		<xsl:param name="requiredCodeSystemOID"/>
		<xsl:param name="isCodeRequired" select="'0'"/>
		<xsl:param name="writeOriginalText" select="'1'"/>
		<xsl:param name="cdaElementName" select="'code'"/>
		<xsl:param name="hsCustomPairElementName"/>
		<xsl:param name="displayText"/>
		<xsl:param name="valueSetOIDIn"/>
				
		<!--
			requiredCodeSystemOID is the OID of a specifically required codeSystem.
			requiredCodeSystemOID may be multiple OIDs, delimited by vertical bar.
			
			isCodeRequired indicates whether or not code nullFlavor is allowed.
			
			cdaElementName is the element (code, value, maritalStatusCode, etc.)
			
			displayText can override the SDA information as the source for displayName.
		-->
		
		<xsl:variable name="code">
			<xsl:choose>
				<xsl:when test="not(string-length($hsCustomPairElementName))"><xsl:value-of select="Code/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'Code')]/Value/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="descriptionFromSDA">
			<xsl:choose>
				<xsl:when test="not(string-length($hsCustomPairElementName)) and string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
				<xsl:when test="string-length($hsCustomPairElementName) and string-length(NVPair[Name/text()=concat($hsCustomPairElementName,'Description')]/Value/text())"><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'Description')]/Value/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$code"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="string-length($displayText)"><xsl:value-of select="$displayText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$descriptionFromSDA"/></xsl:otherwise>
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
			
				<xsl:variable name="sdaCodingStandardOID">
					<xsl:apply-templates select="." mode="oid-for-code">
						<xsl:with-param name="Code" select="$codingStandard"/>
					</xsl:apply-templates>
				</xsl:variable>
				
				<!-- If a value set OID was passed in then use it. Otherwise check for one. Use only the first found. -->
				<xsl:variable name="valueSetOID">
					<xsl:choose>
						<xsl:when test="string-length($valueSetOIDIn)"><xsl:value-of select="$valueSetOIDIn"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="substring-before(isc:evaluate('getValueSetOIDs',$code,$sdaCodingStandardOID,$setIds),'|')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!--
					If we end up building a translation element, the translation
					element will use the input data's SDACodingStandard OID and
					name for codeSystem and codeSystemName.  Otherwise if the
					input data had no SDACodingStandard, then the translation
					will use $noCodeSystemOID and $noCodeSystemName.
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
					If we are forced by requirement to build a <code> element
					that includes @code, we may have to force in the required
					codeSystem or $noCodeSystemOID, depending on whether there
					is a required specific codeSystem or not.
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
					If there is a specified required codeSystem, and our data
					does not have that codeSystem, then we need to put the
					data into a translation element.
					If no particular codeSystem is required, and <code> is not
					required to have a @code, and our data had no codeSystem,
					then we'll need to put our data into a translation.
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
					If there is a specified required codeSystem, and our data
					does not have that codeSystem, and <code> is not required
					to have a @code, it is okay to export nullFlavor.
					If no particular codeSystem is required, and <code> is not
					required to have a @code, and our data had no codeSystem,
					then it is okay to export nullFlavor for the <code>.
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
							<xsl:choose>
								<xsl:when test="$addTranslation='1'">
									<xsl:attribute name="nullFlavor">OTH</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="nullFlavor">UNK</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="string-length($xsiType)"><xsl:attribute name="xsi:type"><xsl:value-of select="$xsiType"/></xsl:attribute></xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="code"><xsl:value-of select="translate($code,' ','_')"/></xsl:attribute>
							<xsl:attribute name="codeSystem"><xsl:value-of select="$codeSystemOIDPrimary"/></xsl:attribute>
							<xsl:attribute name="codeSystemName"><xsl:value-of select="$codeSystemNamePrimary"/></xsl:attribute>
							<xsl:if test="string-length($valueSetOID)"><xsl:attribute name="sdtc:valueSet"><xsl:value-of select="$valueSetOID"/></xsl:attribute></xsl:if>
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
							
					<xsl:if test="$addTranslation='1'"><translation code="{translate($code,' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{$descriptionFromSDA}"/></xsl:if>
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
	
	
	<!-- *********** BEGIN QRDA-SPECIFIC TEMPLATES HERE *********** -->
	
	<xsl:template match="*" mode="patientPreference">
		<!--
			From the QRDA Implementation Guide:
			Preferences are choices made by patients relative to
			options for care or treatment (including scheduling,
			care experience, and meeting of personal health goals)
			and the sharing and disclosure of their health information.
			
			SDA Input:
			CustomPairs
				NVPair/Name PatientPreferenceCodingStandard
				NVPair/Value
				NVPair/Name PatientPreferenceCode
				NVPair/Value
				NVPair/Name PatientPreferenceDescription
				NVPair/Value
		-->
		<xsl:comment> QRDA Patient Preference </xsl:comment>
		<entryRelationship typeCode="RSON">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$qrda-PatientPreference}"/>
				<id nullFlavor="UNK"/>
				<code code="PAT" codeSystem="{$actReasonOID}" codeSystemName="{$actReasonName}" displayName="patient request"/>
				<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="cdaElementName">value</xsl:with-param>
					<xsl:with-param name="hsCustomPairElementName">PatientPreference</xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="providerPreference">
		<!--
			From the QRDA Implementation Guide:
			Provider preferences are choices made by care providers
			relative to options for care or treatment (including
			scheduling, care experience, and meeting of personal
			health goals).
			
			SDA Input:
			CustomPairs
				NVPair/Name ProviderPreferenceCodingStandard
				NVPair/Value
				NVPair/Name ProviderPreferenceCode
				NVPair/Value
				NVPair/Name ProviderPreferenceDescription
				NVPair/Value
		-->
		<xsl:comment> QRDA Provider Preference </xsl:comment>
		<entryRelationship typeCode="RSON">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$qrda-ProviderPreference}"/>
				<id nullFlavor="UNK"/>
				<code code="PHY" codeSystem="{$actReasonOID}" codeSystemName="{$actReasonName}" displayName="physician request"/>
				<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="cdaElementName">value</xsl:with-param>
					<xsl:with-param name="hsCustomPairElementName">ProviderPreference</xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="reason">
		<xsl:param name="hsCustomPairElementName" select="'Reason'"/>
		
		<!--
			From the QRDA Implementation Guide:
			The thought process or justification for an action or
			for not performing an action. Examples include patient,
			system, or medical-related reasons for declining to
			perform specific actions. Note that the parent template
			that calls this template can be asserted to have occurred
			or to not have occurred. Therefore, this template simply
			tacks on a reason to some other (possibly negated) act.
			As such, there is nothing in this template that says
			whether the parent act did or did not occur.
			
			SDA Input:
			CustomPairs
				NVPair/Name ReasonCodingStandard
				NVPair/Value
				NVPair/Name ReasonCode
				NVPair/Value
				NVPair/Name ReasonDescription
				NVPair/Value
		-->
		<xsl:comment> QRDA Reason </xsl:comment>
		<entryRelationship typeCode="RSON">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$qrda-Reason}"/>
				<id nullFlavor="UNK"/>
				<code code="410666004" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="reason"/>
				<statusCode code="completed"/>
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="cdaElementName">value</xsl:with-param>
					<xsl:with-param name="hsCustomPairElementName" select="$hsCustomPairElementName"/>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="procedure-incisionDateTime">
		<!--
			From the QRDA Implementation Guide:
			This template indicates the time the incision was made.
			
			SDA Input:
			CustomPair
				NVPair/Name IncisionDateTime
				NVPair/Value
		-->
		<xsl:comment> QRDA Incision Date and Time </xsl:comment>
		<entryRelationship typeCode="REFR">
			<procedure classCode="PROC" moodCode="EVN">
				<templateId root="{$qrda-IncisionDateTime}"/>
				<code code="34896006" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="incision"/>
				<xsl:choose>
					<xsl:when test="string-length(CustomPairs/NVPair[Name='IncisionDateTime']/Value)">
						<effectiveTime>
							<xsl:attribute name="value"><xsl:apply-templates select="CustomPairs/NVPair[Name='IncisionDateTime']/Value" mode="xmlToHL7TimeStamp"/></xsl:attribute>
						</effectiveTime>
					</xsl:when>
					<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
			</procedure>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-ProblemStatus-Active">
		<xsl:comment> QRDA Problem Status Active </xsl:comment>
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-ProblemStatus}"/>
				<templateId root="{$qrda-ProblemStatusActive}"/>
				<id nullFlavor="NI"/>
				<code code="33999-4" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Status"/>
				<statusCode code="completed"/>
				<value code="55561003" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Active" xsi:type="CD"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-ProblemStatus-Inactive">
		<xsl:comment> QRDA Problem Status Inactive </xsl:comment>
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-ProblemStatus}"/>
				<templateId root="{$qrda-ProblemStatusInactive}"/>
				<id nullFlavor="NI"/>
				<code code="33999-4" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Status"/>
				<statusCode code="completed"/>
				<value code="73425007" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Inactive" xsi:type="CD"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="participant-Device">
		<!--
			From the QRDA Implementation Guide:
			The guide describes a device as "...equipment designed
			to treat, monitor, or diagnose a patient's status is
			in use (e.g., an antithrombotic device has been placed
			on the patient's legs to prevent thromboembolism, or a
			cardiac pacemaker is in place)".
			
			SDA Input:
			CustomPairs
				NVPair/Name DeviceCodingStandard
				NVPair/Value
				NVPair/Name DeviceCode
				NVPair/Value
				NVPair/Name DeviceDescription
				NVPair/Value
		-->
		<participant typeCode="DEV">
			<participantRole classCode="MANU">
				<playingDevice classCode="DEV">
					<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
						<xsl:with-param name="requiredCodeSystemOID" select="$snomedOID"/>
						<xsl:with-param name="cdaElementName">code</xsl:with-param>
						<xsl:with-param name="hsCustomPairElementName">Device</xsl:with-param>
					</xsl:apply-templates>
				</playingDevice>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Severity-CustomPair">
		<!--
			Severity is same concept as is already provided by
			Allergy Severity.  CustomPair support is provided
			here for Problem Severity.
			
			SDA Input:
			CustomPairs
				NVPair/Name SeverityCodingStandard
				NVPair/Value
				NVPair/Name SeverityCode
				NVPair/Value
				NVPair/Name SeverityDescription
				NVPair/Value
		-->
		<xsl:comment> QRDA Problem Severity </xsl:comment>
		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$ccda-SeverityObservation}"/>
				
				<code code="SEV" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}" displayName="Severity observation"/>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="CustomPairs" mode="generic-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="cdaElementName">value</xsl:with-param>
					<xsl:with-param name="hsCustomPairElementName">Severity</xsl:with-param>
				</xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="includeDiagnosisInExport">
		<xsl:param name="currentConditions"/>
		
		<xsl:variable name="isCurrentCondition"><xsl:apply-templates select="." mode="currentCondition"/></xsl:variable>

		<xsl:choose>
			<!-- Must be Diagnosis. -->
			<xsl:when test="not(Category/Code/text()='282291009')">0</xsl:when>
			<xsl:when test="($currentConditions = true()) and ($isCurrentCondition = 1)">1</xsl:when>
			<xsl:when test="($currentConditions = false()) and ($isCurrentCondition = 0)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="currentCondition">
		<xsl:choose>
			<xsl:when test="contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|'))">1</xsl:when>
			<xsl:when test="not(ToTime)">1</xsl:when>
			<xsl:when test="isc:evaluate('dateDiff', 'dd', translate(translate(FromTime/text(), 'Z', ''), 'T', ' ')) &lt;= $currentConditionWindowInDays">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
		getValueSetString returns a vertical bar-delimited string
		of the OID(s) for the value set(s) to which the specified
		Code and SDACodingStandard belong for the quality measures
		specified for the current QRDA export.
	-->
	<xsl:template match="*" mode="getValueSetString">
		<xsl:variable name="codingStandardOID" select="isc:evaluate('getOIDForCode',SDACodingStandard/text())"/>
		<xsl:value-of select="isc:evaluate('getValueSetOIDs',Code/text(),$codingStandardOID,$setIds)"/>
	</xsl:template>
	
	<!--
		getValueSetStringCustomPairs returns a vertical bar-delimited
		string of the OID(s) for the value set(s) to which the CustomPair-
		formatted specified Code and SDACodingStandard belong for the
		quality measures specified for the current QRDA export.
	-->
	<xsl:template match="CustomPairs" mode="getValueSetStringCustomPairs">
		<xsl:param name="hsCustomPairElementName"/>
		
		<xsl:variable name="code"><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'Code')]/Value/text()"/></xsl:variable>
		<xsl:variable name="codingStandard"><xsl:value-of select="NVPair[Name/text()=concat($hsCustomPairElementName,'CodingStandard')]/Value/text()"/></xsl:variable>
		<xsl:variable name="codingStandardOID"><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="$codingStandard"/></xsl:apply-templates></xsl:variable>
		<xsl:value-of select="isc:evaluate('getValueSetOIDs',$code,$codingStandardOID,$setIds)"/>
	</xsl:template>
</xsl:stylesheet>
