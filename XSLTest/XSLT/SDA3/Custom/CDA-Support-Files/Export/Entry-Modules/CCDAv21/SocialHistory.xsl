<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="xsi exsl">
  <!-- AlsoInclude: AuthorParticipation.xsl Comment.xsl -->
	
	<xsl:template match="SocialHistories" mode="eSH-socialHistory-Narrative">
		<xsl:param name="sdaSmokingCodes"/>
		<xsl:param name="exportUnknownSmokingStatus"/><!-- UNUSED -->
		
		<!-- VA Social History Business Rules for Medical Content -->
		<!--
		<text>
		-->
		<xsl:choose>
        	<xsl:when test="$flavor = 'SES'">
        	<paragraph>
				This section includes the most current, and the historical, smoking and tobacco-related 
				health factors from the VA facility where the Encounter took place.
			</paragraph>
  			<paragraph>
				<content styleCode="Bold">Current Smoking Status</content>
			</paragraph>
			<paragraph>
				This section includes the most current smoking, or tobacco-related health factor, from the 
				VA facility where the Encounter took place.
  			</paragraph>
        	</xsl:when>
        		
        	<xsl:otherwise>
			<paragraph>
				<content ID="socialHistTime">Section Date Range: From patient's date of birth to the date the document was created.</content>
			</paragraph>
        	<paragraph>
				This section includes all smoking or tobacco-related health factors on record at VA for the patient. 
				The data comes from all VA treatment facilities. 
			</paragraph>
			
  			<paragraph>
				<content styleCode="Bold">Current Smoking Status</content>
			</paragraph>
			
			<paragraph ID="socialHistoryNarrativeIntro">
				This section includes the MOST CURRENT smoking, or tobacco-related health factor, on record at VA for 
				the patient.
  			</paragraph>
  			</xsl:otherwise>
  			</xsl:choose>

		<table border="1" width="100%">
			<thead>
				<tr>
					<th>Date/Time</th>
					<th>Current Smoking Status</th>
					<th>Comment</th>
					<th>Facility</th>
				</tr>
			</thead>
			<tbody>
				<xsl:if test="position()= 1">
					<xsl:apply-templates select="SocialHistory" mode="eSH-socialHistory-NarrativeDetail">
						<xsl:with-param name="sdaSmokingCodes" select="$sdaSmokingCodes"/>
					</xsl:apply-templates>
				</xsl:if>
			</tbody>
		</table>
		<!--
		</text>
		-->
		<xsl:call-template name="eSH-socialHistory-Narrative-Smoking"></xsl:call-template>
	</xsl:template>
	
	<xsl:template match="SocialHistory" mode="eSH-socialHistory-NarrativeDetail">
		<xsl:param name="sdaSmokingCodes"/>
		<!-- This template is applied for the 1st SocialHistory entry. -->
		<xsl:if test="position() = 1">
		<tr ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), position())}">
			<td><xsl:apply-templates select="EnteredOn" mode="formatDateTime"/><xsl:apply-templates select="EnteredOn" mode="formatTime"/></td>
			<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), position())}"><xsl:apply-templates select="SocialHabit" mode="fn-descriptionOrCode"/></td>
			<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryComments/text(), position())}">
			<xsl:if test="string-length(Extension/Severity/text())">Severity=<xsl:value-of select="Extension/Severity/text()"/><br/></xsl:if>
			<xsl:value-of select="SocialHabitComments/text()"/>
			</td>
			<td ID="{concat('socialHistoryFacility-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="eSH-socialHistory-Narrative-Smoking">
		<xsl:param name="sdaSmokingCodes"/>
		<xsl:param name="exportUnknownSmokingStatus"/><!-- UNUSED -->
		<!-- This template is applied for prior SocialHistory entries about smoking. -->
		<!--
		<text>
		-->
		<paragraph>
				<content styleCode="Bold">Tobacco Use History</content>
			</paragraph>
			
			<paragraph ID="socialHistoryIntro">
				<xsl:choose>
				<xsl:when test="$flavor = 'SES'">
				This section includes a history of the smoking, or tobacco-related health factors, that were 
				collected on or before the date of the Encounter. The data comes from the VA facility where the 
				Encounter took place.
				</xsl:when>
				<xsl:otherwise>
				This section includes a history of the smoking, or tobacco-related health factors, on record at VA for 
				the patient. 
				</xsl:otherwise>
				 </xsl:choose>
  			</paragraph>
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
				<xsl:apply-templates select="SocialHistory" mode="eSH-socialHistory-NarrativeDetail-Smoking">
					<xsl:with-param name="sdaSmokingCodes" select="$sdaSmokingCodes"/>
				</xsl:apply-templates>
			</tbody>
		</table>
		<!--
		</text>
		-->
	</xsl:template>
	
	<xsl:template match="SocialHistory" mode="eSH-socialHistory-NarrativeDetail-Smoking">
		<xsl:param name="sdaSmokingCodes"/>
		<!-- This template is applied when the subject has some SocialHistory entries about smoking. -->
		
		<xsl:if test="position() > 1">
		<tr ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), position())}">
			<td><xsl:apply-templates select="EnteredOn" mode="formatDateTime"/><xsl:apply-templates select="EnteredOn" mode="formatTime"/></td>
			<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), position())}"><xsl:apply-templates select="SocialHabit" mode="fn-descriptionOrCode"/></td>
			<xsl:choose>
				<xsl:when test="string-length(SocialHabitComments/text())">
					<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryComments/text(), position())}"><xsl:value-of select="SocialHabitComments/text()"/></td>
				</xsl:when>
				<xsl:otherwise><td/></xsl:otherwise>
			</xsl:choose>
			<td ID="{concat('socialHistoryFacility-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
		</xsl:if>	
	</xsl:template>
	
	<xsl:template match="*" mode="eSH-socialHistory-NoData-Smoking-Narrative">
		<xsl:param name="narrativeLinkSuffix"/>
		<!-- There are two ways into this mode:
		     (1) No SocialHistories (or BirthGender) data at all,
		  OR (2) There is some data, but none about smoking.
		  In addition, $exportSmokingStatusWhenNoSmokingStatus must be set to 1/true
		  to indicate that a report of smoking status is explicitly wanted. 
		  Notice that this template makes no reference to the context node. -->
		
		<table border="1" width="100%">
			<thead>
				<tr>
					<th>Smoking Status</th>
					<th>Start Date</th>
					<th>Stop Date</th>
				</tr>
			</thead>
			<tbody>
				<tr ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), $narrativeLinkSuffix)}">
					<td ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}">Unknown if ever smoked</td>
					<td/>
					<td/>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="BirthGender" mode="eSH-BirthSex-Narrative">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<table border="1" width="100%">
			<thead>
				<tr>
					<th>Social History Observation</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody>								
				<tr ID="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), $narrativeLinkSuffix)}">
					<td>Birth Sex</td>
					<td><xsl:value-of select="Description/text()"/></td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	
	<!-- ==================== Narrative material above this line. Entry material below. ==================== -->

	<xsl:template match="SocialHistories" mode="eSH-socialHistory-Entries">
		<xsl:param name="sdaSmokingCodes"/>
		<!-- This template is applied to all SocialHistories data, whether about
		     smoking or other. -->
		
		<xsl:apply-templates select="SocialHistory" mode="eSH-socialHistory-EntryDetail">
			<xsl:with-param name="sdaSmokingCodes" select="$sdaSmokingCodes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="SocialHistory" mode="eSH-socialHistory-EntryDetail">
		<xsl:param name="sdaSmokingCodes"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		<xsl:variable name="isSmokingHabit" select="contains($sdaSmokingCodes,concat('|',SocialHabit/Code/text(),'|'))"/>
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:choose>
					<xsl:when test="not($isSmokingHabit)">
						<xsl:apply-templates select="." mode="eSH-socialHistory-EntryDetail-NonSmoking">
							<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="eSH-socialHistory-EntryDetail-Smoking">
							<xsl:with-param name="sdaSmokingCodes" select="$sdaSmokingCodes"/>
							<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="SocialHistory" mode="eSH-socialHistory-EntryDetail-NonSmoking">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:call-template name="eSH-templateIds-socialHistoryEntry"/>
	
		<!--
			Field : Social History Id
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/id
			Source: HS.SDA3.SocialHistory ExternalId
			Source: /Container/SocialHistories/SocialHistory/ExternalId
			StructuredMappingRef: id-External
		-->
		<xsl:apply-templates select="." mode="fn-id-External"/>
		
		<!--
			Field : Social History Type
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/code
			Source: HS.SDA3.SocialHistory SocialHabit
			Source: /Container/SocialHistories/SocialHistory/SocialHabit
			StructuredMappingRef: generic-Coded
		-->
		<xsl:apply-templates select="SocialHabit" mode="fn-generic-Coded"/>
				
		<text><reference value="{concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}"/></text>
		<statusCode code="completed"/>
		
		<!--
			Field : Social History Start Date
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/effectiveTime/low/@value
			Source: HS.SDA3.SocialHistory FromTime
			Source: /Container/SocialHistories/SocialHistory/FromTime
		-->
		<!--
			Field : Social History End Date
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/effectiveTime/high/@value
			Source: HS.SDA3.SocialHistory ToTime
			Source: /Container/SocialHistories/SocialHistory/ToTime
		-->
		<xsl:apply-templates select="." mode="fn-effectiveTime-FromTo"/>
		
		<!--
			Field : Social History Social Habit Quantity
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/value/text()
			Source: HS.SDA3.SocialHistory SocialHabitQty.Description
			Source: /Container/SocialHistories/SocialHistory/SocialHabitQty/Description
		-->
		<xsl:choose>
			<xsl:when test="string-length(SocialHabitQty/Description)">
				<xsl:apply-templates select="SocialHabitQty/Description" mode="fn-value-ST"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="SocialHabitQty/Code" mode="fn-value-ST"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--
			Field : Social History Author
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/author
			Source: HS.SDA3.SocialHistory EnteredBy
			Source: /Container/SocialHistories/SocialHistory/EnteredBy
			StructuredMappingRef: author-Human
		-->
		<xsl:apply-templates select="EnteredBy" mode="eAP-author-Human"/>
						
		<!--
			Field : Social History Information Source
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/informant
			Source: HS.SDA3.SocialHistory EnteredAt
			Source: /Container/SocialHistories/SocialHistory/EnteredAt
			StructuredMappingRef: informant
		-->
		<xsl:apply-templates select="EnteredAt" mode="fn-informant"/>
		
		<xsl:apply-templates select="Status" mode="eSH-observation-socialHistoryStatus"/>
		
		<!--
			Field : Social History Comments
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/entryRelationship/observation[code/@code='48767-8']/value
			Source: HS.SDA3.SocialHistory SocialHabitComments
			Source: /Container/SocialHistories/SocialHistory/SocialHabitComments
		-->
		<xsl:apply-templates select="SocialHabitComments" mode="eCm-entryRelationship-comments">
			<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryComments/text(), $narrativeLinkSuffix)"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="SocialHistory" mode="eSH-socialHistory-EntryDetail-Smoking">
		<xsl:param name="sdaSmokingCodes"/>
		<xsl:param name="narrativeLinkSuffix"/>
		<xsl:choose>
			<xsl:when test="SocialHabitCategory/Code/text() = $loincTobaccoUse">
				<!-- Tobacco Use Observation CCDA template -->
				<xsl:call-template name="eSH-templateIds-tobaccoUse"/>
				<id nullFlavor="UNK"/>
				<code code="{$loincTobaccoUse}" codeSystem="{$loincOID}" displayName="History of tobacco use" codeSystemName="{$loincName}"/>
				<statusCode code="completed"/>
				<xsl:apply-templates select="." mode="fn-effectiveTime-FromTo"/>
				<value xsi:type="CD" codeSystem="{$snomedOID}">
					<xsl:attribute name="code"><xsl:value-of select="SocialHabit/Code/text()"/></xsl:attribute>
					<xsl:attribute name="displayName">
						<xsl:apply-templates select="SocialHabit" mode="eSH-smokingDescription-Content">
							<xsl:with-param name="lookupCode" select="SocialHabit/Code/text()"/>
						</xsl:apply-templates>
					</xsl:attribute>
					<originalText>
						<reference value="{concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}"/>
					</originalText>
				</value>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="eSH-socialHistory-EntryDetail-SmokingStatus">
					<xsl:with-param name="sdaSmokingCodes" select="$sdaSmokingCodes"/>
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="SocialHistory" mode="eSH-socialHistory-EntryDetail-SmokingStatus">
		<xsl:param name="sdaSmokingCodes"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:call-template name="eSH-templateIds-smokingStatusEntry"/>
	
		<xsl:apply-templates select="." mode="fn-id-External"/>
		<code code="{$loincSmokingStatus}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Smoking Status"/>
<!--
		<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>
	-->
		<statusCode code="completed"/>
		
		<xsl:variable name="cU" select="translate(SocialHabit/Code/text(),$lowerCase,$upperCase)"/>
		<xsl:variable name="dU" select="translate(SocialHabit/Description/text(),$lowerCase,$upperCase)"/>
		
		<xsl:variable name="code">
			<xsl:choose>
				<xsl:when test="$cU='CURRENT EVERY DAY SMOKER' or $dU='CURRENT EVERY DAY SMOKER'">449868002</xsl:when>
				<xsl:when test="$cU='CURRENT SOME DAY SMOKER' or $dU='CURRENT SOME DAY SMOKER'">428041000124106</xsl:when>
				<xsl:when test="$cU='FORMER SMOKER' or $dU='FORMER SMOKER'">8517006</xsl:when>
				<xsl:when test="$cU='NEVER SMOKER' or $dU='NEVER SMOKER'">266919005</xsl:when>
				<xsl:when test="$cU='SMOKER, CURRENT STATUS UNKNOWN' or $dU='SMOKER, CURRENT STATUS UNKNOWN'">77176002</xsl:when>
				<xsl:when test="$cU='UNKNOWN IF EVER SMOKED' or $dU='UNKNOWN IF EVER SMOKED'">266927001</xsl:when>
				<xsl:when test="$cU='HEAVY TOBACCO SMOKER' or $dU='HEAVY TOBACCO SMOKER'">428071000124103</xsl:when>
				<xsl:when test="$cU='LIGHT TOBACCO SMOKER' or $dU='LIGHT TOBACCO SMOKER'">428061000124105</xsl:when>
				<xsl:otherwise><xsl:value-of select="SocialHabit/Code/text()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="description">
			<xsl:apply-templates select="SocialHabit" mode="eSH-smokingDescription-Content">
				<xsl:with-param name="lookupCode" select="$code"/>				
			</xsl:apply-templates>
		</xsl:variable>
		<!-- Per CONF:1098-31928, this is the time of observation, not the duration of smoking -->
		<xsl:choose>
			<xsl:when test="EnteredOn">
				<effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="EnteredOn" mode="fn-xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime>
			</xsl:when>
			<xsl:otherwise>
				<effectiveTime nullFlavor="UNK"/>
			</xsl:otherwise>
		</xsl:choose>
				
		<!-- Because this is already detected to be a SNOMED smoking status, force in SNOMED for the codeSystem. -->
		<value xsi:type="CD" code="{$code}" displayName="{$description}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}">
			<originalText><reference value="{concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}"/></originalText>
		</value>
		
		<xsl:apply-templates select="EnteredBy" mode="eAP-author-Human"/>
		
		<xsl:apply-templates select="EnteredAt" mode="fn-informant"/>
	</xsl:template>
	
	<xsl:template match="Status" mode="eSH-observation-socialHistoryStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="eSH-templateIds-socialHistoryStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="translate(text(), $lowerCase, $upperCase)"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'I'">73425007</xsl:when>
								<xsl:otherwise>55561003</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'I'">Inactive</xsl:when>
								<xsl:otherwise>Active</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
			
				<!--
					Field : Social History Status
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation/entryRelationship/observation[code/@code='33999-4']/value
					Source: HS.SDA3.SocialHistory Status
					Source: /Container/SocialHistories/SocialHistory/Status
					StructuredMappingRef: snomed-Status
					Note  : SDA SocialHistory Status value of I is exported
							as CDA value for Inactive, and all other Status
							values are exported as CDA value for Active.
							Because SDA SocialHistory Status is %String,
							export automatically populates the the SNOMED
							code system in for this value.
				-->
				<xsl:apply-templates select="exsl:node-set($statusInformation)/Status" mode="fn-snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="SocialHabit" mode="eSH-smokingDescription-Content">
		<xsl:param name="lookupCode"/>
		<xsl:choose>
			<xsl:when test="string-length(Description/text())">
				<xsl:value-of select="Description/text()"/>
			</xsl:when>
			<xsl:when test="$lookupCode='449868002'">Current every day smoker</xsl:when>
			<xsl:when test="$lookupCode='428041000124106'">Current some day smoker</xsl:when>
			<xsl:when test="$lookupCode='8517006'">Former smoker</xsl:when>
			<xsl:when test="$lookupCode='266919005'">Never smoker</xsl:when>
			<xsl:when test="$lookupCode='77176002'">Smoker, current status unknown</xsl:when>
			<xsl:when test="$lookupCode='266927001'">Unknown if ever smoked</xsl:when>
			<xsl:when test="$lookupCode='428071000124103'">Heavy tobacco smoker</xsl:when>
			<xsl:when test="$lookupCode='428061000124105'">Light tobacco smoker</xsl:when>
			<xsl:otherwise><xsl:value-of select="SocialHabit/Code/text()"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="BirthGender" mode="eSH-BirthSex-EntryDetail">
		<xsl:param name="narrativeLinkSuffix"/>
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="eSH-templateIds-BirthSexObservation"/>
				<code code="76689-9" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Sex Assigned At Birth"/>
				<text>
					<reference value="{concat($exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistoryNarrative/text(), $narrativeLinkSuffix)}"/>
				</text>
				<statusCode code="completed"/>
				<effectiveTime value="{$currentDateTime}"/>

				<!--
					Field : Patient BirthGender
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.17']/entry/observation[code/@code='76689-9']/value
					Source: HS.SDA3.Patient BirthGender
					Source: /Container/Patient/BirthGender
				-->
				<value codeSystem="2.16.840.1.113883.5.1" xsi:type="CD">
					<xsl:attribute name="code"><xsl:value-of select="Code/text()"/></xsl:attribute>
					<xsl:attribute name="displayName"><xsl:value-of select="Description/text()"/></xsl:attribute>
				</value>
			</observation>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="eSH-socialHistory-NoData-Smoking-EntryDetail">
		<xsl:param name="narrativeLinkSuffix"/>
		<!-- There are two ways into this mode:
		     (1) No SocialHistories (or BirthGender) data at all,
		  OR (2) There is some data, but none about smoking.
		  In addition, $exportSmokingStatusWhenNoSmokingStatus must be set to 1/true
		  to indicate that a report of smoking status is explicitly wanted. 
		  Notice that this template makes no reference to the context node. -->
		
		<entry typeCode="DRIV">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="eSH-templateIds-smokingStatusEntry"/>
				<id nullFlavor="UNK"/>
				<code code="ASSERTION" codeSystem="{$actCodeOID}" codeSystemName="{$actCodeName}"/>
				<statusCode code="completed"/>
				<effectiveTime>
					<low nullFlavor="NASK"/>
				</effectiveTime>
				<value xsi:type="CD" code="266927001" displayName="Unknown if ever smoked" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}">
					<originalText><reference value="{concat('#', $exportConfiguration/socialHistory/narrativeLinkPrefixes/socialHistorySocialHabit/text(), $narrativeLinkSuffix)}"/></originalText>
				</value>
			</observation>
		</entry>
	</xsl:template>
	
	<!-- ==================== Entry material above this line. NoData material below. ==================== -->
	
	<xsl:template match="*" mode="eSH-socialHistory-NoData">
		<text><xsl:value-of select="$exportConfiguration/socialHistory/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="eSH-templateIds-socialHistoryEntry">
		<templateId root="{$ccda-SocialHistoryObservation}"/>
		<templateId root="{$ccda-SocialHistoryObservation}" extension="2015-08-01"/>
	</xsl:template>
	
	<xsl:template name="eSH-templateIds-smokingStatusEntry">
		<templateId root="{$ccda-SmokingStatusObservation}"/>
		<templateId root="{$ccda-SmokingStatusObservation}" extension="2014-06-09"/>
	</xsl:template>
	
	<xsl:template name="eSH-templateIds-tobaccoUse">
		<templateId root="{$ccda-TobaccoUse}"/>
		<templateId root="{$ccda-TobaccoUse}" extension="2014-06-09"/>
	</xsl:template>

	<xsl:template name="eSH-templateIds-BirthSexObservation">
			<templateId root="{$ccda-BirthSexObservation}" extension="2016-06-01"/>
	</xsl:template>
	
	<xsl:template name="eSH-templateIds-socialHistoryStatusObservation">
		<xsl:if test="$hl7-CCD-StatusObservation">
			<templateId root="{$hl7-CCD-StatusObservation}"/>
			<templateId root="{$hl7-CCD-StatusObservation}" extension="2015-08-01"/>
		</xsl:if>
		<xsl:if test="$hl7-CCD-SocialHistoryStatusObservation">
			<templateId root="{$hl7-CCD-SocialHistoryStatusObservation}"/>
			<templateId root="{$hl7-CCD-SocialHistoryStatusObservation}" extension="2015-08-01"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>