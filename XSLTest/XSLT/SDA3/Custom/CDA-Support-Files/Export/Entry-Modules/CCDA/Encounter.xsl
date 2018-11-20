<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:variable name="encompassingEncNum"><xsl:apply-templates select="." mode="encompassingEncounterNumber"/></xsl:variable>
	<xsl:variable name="encompassingEncOrg"><xsl:apply-templates select="." mode="encompassingEncounterOrganization"/></xsl:variable>
	<xsl:variable name="encompassingEncToEncounters"><xsl:apply-templates select="." mode="encompassingEncounterToEncounters"/></xsl:variable>
	
	<xsl:template match="*" mode="encounters-Narrative">
		<text>
			<!-- VA Encounter Business Rules for Medical Content -->
        	<paragraph>
      			This section contains a list of completed VA Outpatient Encounters for 
          		the patient and a list of Encounter Notes, Consult Notes, History &amp; 
       			Physical Notes, and Discharge Summaries for the patient. The data comes 
               	from all VA treatment facilities.
             	<br/>
            	<br/>
  			</paragraph>
			
      		<paragraph ID="opEncTitle">
      		<xsl:choose>
                <xsl:when test="$flavor = 'MHV'">
                    This section includes a list of VA Outpatient Encounters from the last 18 months and includes a 
                    maximum of the 10 most recent encounters. Follow-up visits related to the VA encounter are not 
                    included. The data comes from all VA treatment facilities. 
                </xsl:when>
                <xsl:otherwise>
                  The list of VA Outpatient Encounters shows all Encounter dates within the requested date range. If 
                  no date range was provided, the list of VA Outpatient Encounters shows all Encounter dates within 
                  the last 18 months. Follow-up visits related to the VA Encounter are not included. The data comes 
                  from all VA treatment facilities. 
                </xsl:otherwise>
            </xsl:choose>
  		</paragraph>
  			<table ID="encounterNarrative">
  			<!--
  			</table>
			<table border="1" width="100%">
			-->
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
					<xsl:apply-templates select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|'))) and not(EncounterNumber/text()=$encompassingEncNum and HealthCareFacility/Organization/Code/text()=$encompassingEncOrg and not($encompassingEncToEncounters='1'))]" mode="encounters-NarrativeDetail"/>
				</tbody>
			</table>
				<paragraph>
					<br/>
            		<br/>
					<xsl:choose>
                		<xsl:when test="$flavor = 'MHV'">
                			The included Outpatient Encounter Notes are available 3 calendar days after completion and
                			include a maximum of the 5 most recent notes associated with each Outpatient Encounter. The data
                			comes from all VA treatment facilities.  Note that Compensation and Pension Notes are available 30
                			days after completion. 
                		</xsl:when>
                		<xsl:otherwise>
                    		The list of Encounter Notes shows the 5 most recent notes associated to the 10 most recent
                    		Outpatient Encounters. The data comes from all VA treatment facilities.
                		</xsl:otherwise>
            		</xsl:choose>
				</paragraph> 
			<table ID="encounterNotes">
			<!--
  			</table>
			<table border="1" width="100%">
			-->
				<thead>
					<tr>
						<th>Date/Time</th>
						<th>Encounter Note</th>
						<th>Provider</th>
						<th>Source</th>	
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|'))) and not(EncounterNumber/text()=$encompassingEncNum and HealthCareFacility/Organization/Code/text()=$encompassingEncOrg and not($encompassingEncToEncounters='1'))]" mode="encounters-NotesDetail"/>
				</tbody>
			</table>
		
		<xsl:call-template name="documents-Narrative">
			<xsl:with-param name="documentTypes" select="'Consult Notes'"/>
			<xsl:with-param name="documentType" select="'Consult Note'"/>
			<xsl:with-param name="documentCode" select="'CR'"/>
			<xsl:with-param name="documentN" select="'5'"/>
		</xsl:call-template>
		
		<xsl:call-template name="documents-Narrative">
			<xsl:with-param name="documentTypes" select="'H and P Notes'"/>
			<xsl:with-param name="documentType" select="'H and P Note'"/>
			<xsl:with-param name="documentCode" select="'HP'"/>
			<xsl:with-param name="documentN" select="'2'"/>
		</xsl:call-template>		
		
		<xsl:call-template name="documents-Narrative">
			<xsl:with-param name="documentTypes" select="'Discharge Summaries'"/>
			<xsl:with-param name="documentType" select="'Discharge Summary'"/>
			<xsl:with-param name="documentCode" select="'DS'"/>
			<xsl:with-param name="documentN" select="'2'"/>
		</xsl:call-template>
	</text>	
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<tr ID="{concat($exportConfiguration/encounters/narrativeLinkPrefixes/encounterNarrative/text(), $narrativeLinkSuffix)}">
			<td><xsl:apply-templates select="FromTime" mode="formatDateTime"/><xsl:apply-templates select="FromTime" mode="formatTime"/></td>
			<td ID="{concat('encounterType-', position())}"><xsl:value-of select="EncounterCodedType/Description/text()"/></td>
			<td ID="{concat('encounterDescription-', position())}"><xsl:value-of select="HealthCareFacility/Extension/CreditStopCode/Description/text()"/></td>
			<td>
				<xsl:apply-templates select="." mode="encounters-NarrativeDetail-diagnoses">
					<xsl:with-param name="encounterPosition" select="position()"/>
					<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
				</xsl:apply-templates>
			</td>
			<td><xsl:apply-templates select="ConsultingClinicians/CareProvider" mode="encounters-NarrativeDetail-AttendingClinician"/></td>

			<td>
				<xsl:variable name="facilityName"><xsl:apply-templates select="HealthCareFacility/Organization" mode="descriptionOrCode"/></xsl:variable>
				<xsl:variable name="facilityAddress"><xsl:apply-templates select="HealthCareFacility/Organization/Address" mode="addressSingleLine"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($facilityName) and string-length($facilityAddress)">
						<xsl:value-of select="concat($facilityName,', ',$facilityAddress)"/>
					</xsl:when>
					<xsl:when test="string-length($facilityName) and not(string-length($facilityAddress))">
						<xsl:value-of select="$facilityName"/>
					</xsl:when>
					<xsl:when test="not(string-length($facilityName)) and string-length($facilityAddress)">
						<xsl:value-of select="$facilityAddress"/>
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NotesDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>	
		<!--no matter what date range the user enters, always only show the 1st 5 documents associated with the 10 most recent encounters
		-->
		<xsl:if test="position() &lt;= 10">
		<!--
		<tr ID="{concat('encounterNote-', $narrativeLinkSuffix)}">
			<td><xsl:apply-templates select="FromTime" mode="formatDateTime"/></td>
			-->
			<xsl:call-template name="encounters-NarrativeDetail-notes">
				
				<xsl:with-param name="encounterPosition" select="position()"/>
				<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
				<xsl:with-param name="encounterDate" select="FromTime"/>
			
			</xsl:call-template>
		<!--	
		</tr>
		-->
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="encounters-NarrativeDetail-notes">
		<xsl:param name="encounterPosition"/>
		<xsl:param name="encounterNumber"/>
		<xsl:param name="encounterDate"/>

		<xsl:apply-templates select="/Container/Documents/Document[EncounterNumber=$encounterNumber]" mode="encounters-NarrativeDetail-note">
			<xsl:with-param name="encounterPosition" select="$encounterPosition"/>
			<xsl:with-param name="encounterDate" select="$encounterDate"/>		
		</xsl:apply-templates>	
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail-note">
		<xsl:param name="encounterPosition"/>
		<xsl:param name="encounterDate"/>
		
		<xsl:variable name="narrativeLinkCategory" select="'encounterNotes'"/>
		<xsl:variable name="narrativeLinkSuffix" select="concat($encounterPosition,'-',position())"/>
	
		<xsl:if test="position() &lt;= 5">
			<tr ID="{concat('encounterNote-', $narrativeLinkSuffix)}">
			<td><xsl:apply-templates select="FromTime" mode="formatDateTime"/><xsl:apply-templates select="FromTime" mode="formatTime"/></td>
			<td>
			<content ID="{concat('encounterNoteDescription-',$exportConfiguration/encounterNotes/narrativeLinkPrefixes/NoteText/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Extension/NationalTitle/Description/text()"/>:  <xsl:value-of select="NoteText/text()"/></content>
			<!--
			<content ID="{concat('encounterNoteDescription-',$exportConfiguration/encounterNotes/narrativeLinkPrefixes/NoteText/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="NoteText" mode="formatNoteText"/></content>
			-->
			</td>
			<td ID="{concat('encounterNoteProvider-', $narrativeLinkSuffix)}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>
			<td ID="{concat('encounterNoteSource-', $narrativeLinkSuffix)}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="formatNoteText">
	<value-of select="{concat(Extension/nationalTitleService/Description/text(), ':')}"/><br/>
	<xsl:choose>
	<xsl:when test="NoteText=''">
	No text available.
	</xsl:when>
	<xsl:otherwise>
	<value-of select="NoteText"/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail-AttendingClinician">
		<xsl:if test="position()>1"><br/></xsl:if>
		<xsl:apply-templates select="." mode="name-Person-Narrative"/>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail-diagnoses">
		<xsl:param name="encounterPosition"/>
		<xsl:param name="encounterNumber"/>
		
		<xsl:apply-templates select="/Container/Diagnoses/Diagnosis[EncounterNumber=$encounterNumber and string-length(Diagnosis/Description/text())]" mode="encounters-NarrativeDetail-diagnosis">
			<xsl:with-param name="encounterPosition" select="$encounterPosition"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-NarrativeDetail-diagnosis">
		<xsl:param name="encounterPosition"/>
		
		<xsl:variable name="narrativeLinkCategory" select="'encounterDiagnoses'"/>
		<xsl:variable name="narrativeLinkSuffix" select="concat($encounterPosition,'-',position())"/>
		
		<xsl:if test="position()>1"><br/></xsl:if>
		<!--
		<content ID="{concat($exportConfiguration/encounterDiagnoses/narrativeLinkPrefixes/diagnosisDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="Diagnosis" mode="descriptionOrCode"/></content>
		-->
		<xsl:variable name="codingDesc">
			<xsl:choose>
			<xsl:when test="Diagnosis/SDACodingStandard = '10D'"> ICD10 </xsl:when>
			 <!--  default the rest to be ICD9 -->
			<xsl:otherwise> ICD9 </xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
		<xsl:variable name="ProvCom">
		<xsl:variable name="OrigText" select="translate(Diagnosis/OriginalText/text(),$lowerCase,$upperCase)"/>
		<xsl:variable name="Desc" select="translate(Diagnosis/Description/text(),$lowerCase,$upperCase)"/>
			<xsl:choose>
			<xsl:when test="$OrigText=$Desc"></xsl:when>
			<xsl:otherwise> with Provider Comments:  <xsl:value-of select="Diagnosis/OriginalText/text()"/></xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
		<content ID="{concat($exportConfiguration/encounterDiagnoses/narrativeLinkPrefixes/diagnosisDescription/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Diagnosis/Description/text()"/><xsl:value-of select="$codingDesc"/><xsl:value-of select="Diagnosis/Code/text()"/><xsl:value-of select="$ProvCom"/></content>
	</xsl:template>
	
	<xsl:template name="documents-Narrative">
	<xsl:param name="documentTypes"/>
	<xsl:param name="documentType"/>
	<xsl:param name="documentCode"/>
	<xsl:param name="documentN"/>
			
				<!-- VA Encounter Document Business Rules for Medical Content -->
				<paragraph>
					<br/>
            		<br/>
					<xsl:choose>
                		<xsl:when test="$flavor = 'MHV'">
                			The included <xsl:value-of select="$documentTypes"/> are from the last 18 months, are available 3 calendar days 
                			after completion, and include a maximum of the <xsl:value-of select="$documentN"/> most recent notes. The data comes from 
                			all VA treatment facilities. 
                		</xsl:when>
                		<xsl:otherwise>
                			The list of <xsl:value-of select="$documentTypes"/> with complete text includes all notes within the requested date range. 
                			If no date range was provided, the list of <xsl:value-of select="$documentTypes"/> with complete text includes the <xsl:value-of select="$documentN"/> most 
                			recent notes within the last 18 months. The data comes from all VA treatment facilities. 
                		</xsl:otherwise>
            		</xsl:choose>
				</paragraph>
				<table>
				<thead>
					<tr>
						<th>Date/Time</th>
						<th>Encounter Note</th>
						<th>Provider</th>
						<th>Source</th>	
					</tr>
				</thead>
					<!--if the non-MHV user entered custom query dates, there is no number limit-->
					<tbody>
					<xsl:for-each select="/Container/Documents/Document[DocumentType/Code=$documentCode]">
	 				<xsl:if test="position() &lt;= $documentN">
						<xsl:call-template name="Document-NotesDetail">
							<xsl:with-param name="N" select="$documentN"/>
							<xsl:with-param name="Code" select="$documentCode"/>
						</xsl:call-template>
					</xsl:if>
					</xsl:for-each>
					</tbody>
				</table>	
			
		
				<!--if the non-MHV user entered custom query dates, do not display this section-->
				<xsl:if test="$titles='1'">
				<paragraph>
					<br/>
            		<br/>
					<xsl:choose>
                		<xsl:when test="$flavor = 'MHV'">
                			This section includes a list of additional <xsl:value-of select="$documentType"/> Titles from the last 18 months. 
                			The data comes from all VA treatment facilities. 
                		</xsl:when>
                		<xsl:otherwise>
                			The list of ADDITIONAL <xsl:value-of select="$documentType"/> TITLES includes all notes signed within the last 18 
                			months. The data comes from all VA treatment facilities. 
                		</xsl:otherwise>
            		</xsl:choose>
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
				<xsl:for-each select="/Container/Documents/Document[DocumentType/Code=$documentCode]">
					<xsl:if test="position() > $documentN">
						<xsl:call-template name="Document-NoteTitles">
						<xsl:with-param name="code" select="$documentCode"/>
						</xsl:call-template>
					</xsl:if>
					</xsl:for-each>			
				</tbody>
				</table>
			</xsl:if>
	</xsl:template>
	
	<xsl:template name="Document-NotesDetail">
		<xsl:param name="Code"/>
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
		<tr ID="{concat($Code,'Note-', $narrativeLinkSuffix)}">
			<td ID="{concat($Code,'NoteTime-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
			<td ID="{concat($Code,'NoteDescription-', position())}"><xsl:value-of select="NoteText/text()"/></td>		
			<td ID="{concat($Code,'NoteProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>
			<td ID="{concat($Code,'NoteSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template name="Document-NoteTitles">
		<xsl:param name="code"/>
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		<tr ID="{concat($code,'Note-', $narrativeLinkSuffix)}">
			<td ID="{concat($code,'NoteTime-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
			<td ID="{concat($code,'NoteDescription-', position())}"><xsl:value-of select="DocumentName/text()"/></td>		
			<td ID="{concat($code,'NoteProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>
			<td ID="{concat($code,'NoteSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="encounters-Entries">
		<xsl:apply-templates select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|'))) and not(EncounterNumber/text()=$encompassingEncNum and HealthCareFacility/Organization/Code/text()=$encompassingEncOrg and not($encompassingEncToEncounters='1'))]" mode="encounters-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="encounters-NoteEntries">
		<xsl:for-each select="Encounter[not(contains('|G|S|', concat('|', EncounterType/text(), '|'))) and not(EncounterNumber/text()=$encompassingEncNum and HealthCareFacility/Organization/Code/text()=$encompassingEncOrg and not($encompassingEncToEncounters='1'))]">
			<xsl:if test="position() &lt;= 10">
			<xsl:variable name="encounterPosition" select="position()"/>
			<xsl:variable name="HealthCareFacility" select="HealthCareFacility"/>
			<xsl:variable name="encounterNumber" select="EncounterNumber/text()"/>
			
			<xsl:for-each select="/Container/Documents/Document[EncounterNumber=$encounterNumber]">
			<xsl:if test="position() &lt;= 5">
			
			<xsl:variable name="type" select="DocumentType/Code"/>
			<xsl:variable name="codeDesc">
			<xsl:choose>
			<xsl:when test="$type = 'CP'">28570-0^Procedure Note</xsl:when>
			<xsl:when test="$type = 'CR'">11488-4^Consultation Note</xsl:when>
			<xsl:when test="$type = 'DS'">18842-5^Discharge Summarization Note</xsl:when>
			<xsl:when test="$type = 'HP'">34117-2^History and Physical</xsl:when>
			<xsl:when test="$type = 'LR'">27898-6^Pathology Studies</xsl:when>
			<xsl:when test="$type = 'RA'">18726-0^Radiology Studies</xsl:when>
			<xsl:when test="$type = 'SR'">29752-3^Perioperative Records</xsl:when>
			<xsl:when test="$type = 'C'">34904-3^Progress Note ? Mental Health</xsl:when>
			<xsl:when test="$type = 'W'">71282-4^Risk Assessment Document</xsl:when>
			<xsl:when test="$type = 'A'">68629-5^Allergy and immunology Note</xsl:when>
			<xsl:when test="$type = 'D'">42348-3^Advance directives</xsl:when>
			 <!--  default the rest to be PN -->
			<xsl:otherwise>11506-3^Subsequent evaluation note</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			
			<xsl:call-template name="encounterNotes-EntryDetail">
				<xsl:with-param name="encounterPosition" select="$encounterPosition"/>
				<xsl:with-param name="HealthCareFacility" select="$HealthCareFacility"/>
				<xsl:with-param name="Loinc" select="substring-before($codeDesc,'^')"/>
				<xsl:with-param name="Display" select="substring-after($codeDesc,'^')"/>
				<xsl:with-param name="Code" select="'encounter'"/>
				
			</xsl:call-template>
			</xsl:if>
			</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
<xsl:template match="*" mode="encounters-DocumentEntries">

	<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='CR']">	
	 	<xsl:variable name="encounterNumber" select="EncounterNumber"/>
	 	<xsl:variable name="encounterType" select="/Container/Encounters/Encounter[EncounterNumber=$encounterNumber]/EncounterCodedType/Code/text()"/>
		<xsl:variable name="HealthCareFacility" select="/Container/Encounters/Encounter[EncounterNumber=$encounterNumber]/HealthCareFacility/Description/text()"/>
		
			<xsl:call-template name="encounterNotes-EntryDetail">
				<xsl:with-param name="encounterPosition" select="position()"/>
				<xsl:with-param name="HealthCareFacility" select="$HealthCareFacility"/>
				<xsl:with-param name="Loinc" select="'11488-4'"/>
				<xsl:with-param name="Display" select="'Consultation Note'"/>
				<xsl:with-param name="Code" select="'CR'"/>
			</xsl:call-template>
		
	</xsl:for-each>
	
	<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='HP']">	
	 		<xsl:variable name="encounterNumber" select="EncounterNumber"/>
			
			<xsl:call-template name="encounterNotes-EntryDetail">
				<xsl:with-param name="encounterPosition" select="position()"/>
				<xsl:with-param name="HealthCareFacility" select="/Container/Encounters/Encounter[EncounterNumber=$encounterNumber]/HealthCareFacility"/>
				<xsl:with-param name="Loinc" select="'34117-2'"/>
				<xsl:with-param name="Display" select="'History and Physical'"/>
				<xsl:with-param name="Code" select="'HP'"/>
			</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='DS']">	
	 		<xsl:variable name="encounterNumber" select="EncounterNumber"/>
	 		<xsl:apply-templates mode="displayLOINC" select=".">
				<xsl:with-param name="type" select="'DS'" />
			</xsl:apply-templates>

			<xsl:call-template name="encounterNotes-EntryDetail">
				<xsl:with-param name="encounterPosition" select="position()"/>
				<xsl:with-param name="HealthCareFacility" select="/Container/Encounters/Encounter[EncounterNumber=$encounterNumber]/HealthCareFacility"/>
				<xsl:with-param name="Loinc" select="'18842-5'"/>
				<xsl:with-param name="Display" select="'Discharge Summarization Note'"/>
				<xsl:with-param name="Code" select="'DS'"/>
			</xsl:call-template>
	</xsl:for-each>	
</xsl:template>

	<xsl:template match="*" mode="encounters-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<entry>
			<encounter classCode="ENC" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-encounterEntry"/>

				<!--
					Field : Encounter External Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/id[1]
					Source: HS.SDA3.Encounter ExternalId
					Source: /Container/Encounters/Encounter/ExternalId
					StructuredMappingRef: id-External
				-->

				<xsl:apply-templates select="." mode="id-External"/>
		
				<!--
					Field : Encounter Number
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/id[2]
					Source: HS.SDA3.Encounter EncounterNumber
					Source: /Container/Encounters/Encounter/EncounterNumber
					StructuredMappingRef: id-Encounter
				-->
				<!--
				<xsl:apply-templates select="." mode="id-Encounter"/>
				-->
				<!-- Encounter Type -->
				<xsl:apply-templates select="." mode="encounter-type-select">
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					<xsl:with-param name="label" select="$exportConfiguration/encounters/narrativeLinkPrefixes/encounterDescription/text()"/>
				</xsl:apply-templates>
				
				<text><reference value="{concat('#', $exportConfiguration/encounters/narrativeLinkPrefixes/encounterNarrative/text(), $narrativeLinkSuffix)}"/></text>
	
				<!--
					Field : Encounter Start Date/Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/effectiveTime/low/@value
					Source: HS.SDA3.Encounter FromTime
					Source: /Container/Encounters/Encounter/FromTime
				-->
				<!--
					Field : Encounter End Date/Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/effectiveTime/high/@value
					Source: HS.SDA3.Encounter ToTime
					Source: /Container/Encounters/Encounter/ToTime
				-->
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				
				<!-- Admission Type -->
				<xsl:apply-templates select="." mode="admission-type"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"></xsl:with-param></xsl:apply-templates>
				
				<!--
					Field : Encounter Attending Clinicians
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/performer
					Source: HS.SDA3.Encounter AttendingClinicians.CareProvider
					Source: /Container/Encounters/Encounter/AttendingClinicians/CareProvider
					StructuredMappingRef: performer
				-->
				<xsl:apply-templates select="AttendingClinicians/CareProvider" mode="performer"/>
				
				<!--
					Field : Encounter Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/author
					Source: HS.SDA3.Encounter EnteredBy
					Source: /Container/Encounters/Encounter/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				
				<!--
					Field : Encounter Information Source Clinician
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/informant
					Source: HS.SDA3.Encounter ConsultingClinicians.CareProvider
					Source: /Container/Encounters/Encounter/ConsultingClinicians/CareProvider
					StructuredMappingRef: informant-encounterParticipant
				-->
				<xsl:apply-templates select="ConsultingClinicians/CareProvider[string-length(SDACodingStandard) and string-length(Code)]" mode="informant-encounterParticipant"/>

				<!--
					Field : Encounter Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/informant
					Source: HS.SDA3.Encounter EnteredAt
					Source: /Container/Encounters/Encounter/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<!-- Admission Source (to be done later as participant[@typeCode='ORG']/code) -->
				<!-- Specs for CCD admission source are unclear -->
				
				<!-- Encounter location -->
				<xsl:apply-templates select="HealthCareFacility" mode="encounter-location"/>
				
				<!--
				<xsl:if test="$documentPatientSetting='Ambulatory'">
				-->
					<xsl:apply-templates select="." mode="encounter-diagnoses">
						<xsl:with-param name="encounterPosition" select="position()"/>
						<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
					</xsl:apply-templates>
				<!--
				</xsl:if>
				-->
			</encounter>
		</entry>
	</xsl:template>
	
	<xsl:template name="encounterNotes-EntryDetail">
	
		<xsl:param name="encounterPosition"/>
		<xsl:param name="HealthCareFacility"/>
		<xsl:param name="Loinc"/>
		<xsl:param name="Display"/>
		<xsl:param name="Code"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="concat($encounterPosition,'-',position())"/>
		
		<entry typeCode="DRIV">
			<encounter classCode="ENC" moodCode="EVN">
			
				<xsl:apply-templates select="." mode="templateIds-encounterEntry"/>
	
				<!-- Encounter Type hard-coded for encounter notes and documents-->
				
				<code code="99499" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" displayName="Unlisted Evaluation and Management Service">
				<originaltext><reference value="{concat('#', $Code,'NoteDescription-',$narrativeLinkSuffix)}"/></originaltext>
				<translation code="{$Loinc}" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="{$Display}"/>
				</code>	
				
				<text><reference value="{concat('#', $Code,'Note-',$narrativeLinkSuffix)}"/></text>
				
				<!--
					Field : Episode Start Date/Time
					Source: /Container/Documents/Document/FromTime
				-->
				<!--
					Field : Episode End Date/Time
					Source: /Container/Documents/Document/ToTime
				-->
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				
				<!-- Admission Type -->
				<xsl:apply-templates select="." mode="admission-type"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"></xsl:with-param></xsl:apply-templates>
				
				<!--
					Field : Document Clinicians
					Source: /Container/Documents/Document/Extension/CareProviders/CareProvider/Description
				-->
				<xsl:apply-templates select="Extension/CareProviders/CareProvider" mode="performer"/>
				
				<!--
					Field : Document Author
					Source: /Container/Documents/Document/Clinician
				-->
				<xsl:apply-templates select="Clinician" mode="author-Human"/>
				
				<!-- Admission Source (to be done later as participant[@typeCode='ORG']/code) -->
				<!-- Specs for CCD admission source are unclear -->
				
				<!-- Encounter location -->
				<xsl:apply-templates select="$HealthCareFacility" mode="encounter-location"/>
				
				<!--
				<xsl:if test="$documentPatientSetting='Ambulatory'">
				-->
					<xsl:apply-templates select="." mode="encounter-diagnoses">
						<xsl:with-param name="encounterPosition" select="position()"/>
						<xsl:with-param name="encounterNumber" select="EncounterNumber/text()"/>
					</xsl:apply-templates>
				<!--
				</xsl:if>
				-->
			</encounter>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="encounters-NoData">
		<text><xsl:value-of select="$exportConfiguration/encounters/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<!--
		encounter-type-select determines whether to export CDA
		encounter type using SDA EncounterCodedType or EncounterType.
		This template calls encounter-type-coded or encounter-type,
		based on the available SDA data.
	-->
	<xsl:template match="Encounter" mode="encounter-type-select">
		<xsl:param name="narrativeLinkSuffix"/>
		<xsl:param name="label"/>
		
		<xsl:choose>
			<xsl:when test="string-length(EncounterCodedType)">
				<xsl:apply-templates select="EncounterCodedType" mode="encounter-type-coded">
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					<xsl:with-param name="label" select="$label"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="encounter-type">
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					<xsl:with-param name="label" select="$label"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EncounterCodedType" mode="encounter-type-coded">
		<xsl:param name="narrativeLinkSuffix"/>
		<xsl:param name="label"/>
		
		<!--
			Field : Encounter Coded Type
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/code
			Source: HS.SDA3.Encounter EncounterCodedType
			Source: /Container/Encounters/Encounter/EncounterCodedType
			StructuredMappingRef: generic-Coded
		-->
		<xsl:apply-templates select="." mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="concat('#', $label, $narrativeLinkSuffix)"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="encounter-type">
		<xsl:param name="narrativeLinkSuffix"/>
		<xsl:param name="label"/>
		
		<!--
			Field : Encompassing Encounter Type Code
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/code/@code
			Source: HS.SDA3.Encounter EncounterType
			Source: /Container/Encounters/Encounter/EncounterType
			Note  : SDA EncounterType maps to @code in the following manner:
					If EncounterType='I' then @code='IMP'
					If EncounterType='O' then @code='AMB'
					If EncounterType='E' then @code='EMER'
					If EncounterType='P' then @code='IMP'
					If EncounterType is any other non-blank value then @code='IMP'
		-->
		<!--
			Field : Encompassing Encounter Type Description
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/code/@displayName
			Source: HS.SDA3.Encounter EncounterType
			Source: /Container/Encounters/Encounter/EncounterType
			Note  : SDA EncounterType maps to @displayName in the following manner:
					If EncounterType='I' then @displayName='Inpatient'
					If EncounterType='O' then @displayName='Ambulatory'
					If EncounterType='E' then @displayName='Emergency'
					If EncounterType='P' then @displayName='Inpatient'
					If EncounterType is any other non-blank value then @displayName='Inpatient'
		-->
		<xsl:variable name="encounterTypeInformation">
			<EncounterType xmlns="">
				<SDACodingStandard><xsl:value-of select="$cpt4Name"/></SDACodingStandard>
				<Code>
					<xsl:choose>
						<xsl:when test="EncounterType/text() = 'E'">EMER</xsl:when>
						<xsl:when test="EncounterType/text() = 'I'">IMP</xsl:when>
						<xsl:when test="EncounterType/text() = 'O'">AMB</xsl:when>
						<xsl:otherwise>AMB</xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description>
					<xsl:choose>
						<xsl:when test="EncounterType/text() = 'E'">Emergency</xsl:when>
						<xsl:when test="EncounterType/text() = 'I'">Inpatient Encounter</xsl:when>
						<xsl:when test="EncounterType/text() = 'O'">Ambulatory</xsl:when>
						<xsl:otherwise>Ambulatory</xsl:otherwise>
					</xsl:choose>
				</Description>
			</EncounterType>
		</xsl:variable>
		
		<xsl:variable name="encounterType" select="exsl:node-set($encounterTypeInformation)/EncounterType"/>
		
		<xsl:apply-templates select="$encounterType" mode="generic-Coded">
			<xsl:with-param name="narrativeLink" select="concat('#', $label,$exportConfiguration/encounters/narrativeLinkPrefixes/encounterDescription/text(), $narrativeLinkSuffix)"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
		encounter-typeDescription-select determines whether to get the
		encounter type display value from EncounterCodedType or from
		EncounterType.  This template calls encounter-typeDescription-coded
		or encounter-typeDescription, based on the available SDA data.
	-->
	<xsl:template match="Encounter" mode="encounter-typeDescription-select">
		<xsl:choose>
			<xsl:when test="string-length(EncounterCodedType)">
				<xsl:apply-templates select="EncounterCodedType" mode="encounter-typeDescription-coded"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="EncounterType" mode="encounter-typeDescription">
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EncounterCodedType" mode="encounter-typeDescription-coded">
		<xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/>
	</xsl:template>
	
	<xsl:template match="*" mode="encounter-typeDescription">
		<xsl:choose>
			<xsl:when test="text() = 'E'">Emergency</xsl:when>
			<xsl:when test="text() = 'G'">Generated</xsl:when>
			<xsl:when test="text() = 'I'">Inpatient</xsl:when>
			<xsl:when test="text() = 'N'">Neo-natal</xsl:when>
			<xsl:when test="text() = 'O'">Outpatient</xsl:when>
			<xsl:when test="text() = 'S'">Silent</xsl:when>
			<xsl:otherwise>Unknown</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="admission-type">
		<xsl:param name="narrativeLinkSuffix"/>
		
			<!--
				Field : Encounter Admission Type
				Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/priorityCode
				Source: HS.SDA3.Encounter AdmissionType
				Source: /Container/Encounters/Encounter/AdmissionType
				StructuredMappingRef: generic-Coded
			-->
			<xsl:apply-templates select="AdmissionType" mode="generic-Coded">
				<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/encounters/narrativeLinkPrefixes/encounterAdmission/text(), $narrativeLinkSuffix)"/>
				<xsl:with-param name="requiredCodeSystemOID" select="$nubcUB92OID"/>
				<xsl:with-param name="cdaElementName" select="'priorityCode'"/>
			</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="encounter-location">
		<xsl:if test="string-length(Code/text()) or string-length(Organization/Code/text())">
			<participant typeCode="LOC">
				<participantRole classCode="SDLOC">
					<xsl:apply-templates select="." mode="templateIds-encounterLocation"/>
					
					<!--
						Field : Encounter Location ID
						Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/participant/participantRole/id
						Source: HS.SDA3.Encounter HealthCareFacility
						Source: /Container/Encounters/Encounter/HealthCareFacility
						StructuredMappingRef: id-encounterLocation
					-->
					<xsl:apply-templates select="." mode="id-encounterLocation"/>
					
					<xsl:variable name="locationTypeCode">
						<xsl:choose>
							<xsl:when test="LocationType/text()='ER'">1108-0</xsl:when>
							<xsl:when test="LocationType/text()='CLINIC'">1160-1</xsl:when>
							<xsl:when test="LocationType/text()='DEPARTMENT'">1010-8</xsl:when>
							<xsl:when test="LocationType/text()='WARD'">1160-1</xsl:when>
							<xsl:when test="LocationType/text()='OTHER'">1117-1</xsl:when>
							<xsl:when test="../EncounterType/text()='E'">1108-0</xsl:when>
							<xsl:when test="../EncounterType/text()='I'">1160-1</xsl:when>
							<xsl:when test="../EncounterType/text()='O'">1160-1</xsl:when>
							<xsl:when test="../EncounterType/text()='P'">1108-0</xsl:when>
							<xsl:otherwise>1117-1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="locationTypeDesc">
						<xsl:choose>
							<xsl:when test="$locationTypeCode='1108-0'">Emergency Room</xsl:when>
							<xsl:when test="$locationTypeCode='1160-1'">Urgent Care Center</xsl:when>
							<xsl:when test="$locationTypeCode='1117-1'">Family Medicine Clinic</xsl:when>
							<xsl:when test="$locationTypeCode='1010-8'">General Laboratory</xsl:when>
							<xsl:otherwise>Urgent Care Center</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<!--
						Field : Encounter Location Type Code
						Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/participant/participantRole/code/@code
						Source: HS.SDA3.Encounter HealthCareFacility.LocationType
						Source: /Container/Encounters/Encounter/HealthCareFacility/LocationType
					-->
					<!--
						Field : Encounter Location Type Description
						Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/participant/participantRole/code/@displayName
						Source: HS.SDA3.Encounter HealthCareFacility.LocationType
						Source: /Container/Encounters/Encounter/HealthCareFacility/LocationType
					-->
					<code code="{$locationTypeCode}" codeSystem="{$healthcareServiceLocationOID}" codeSystemName="{$healthcareServiceLocationName}" displayName="{$locationTypeDesc}"/>
					
					<!--
						Field : Encounter Location Name
						Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/entry/encounter/participant/participantRole/playingEntity/name/text()
						Source: HS.SDA3.Encounter HealthCareFacility.Organization.Description
						Source: /Container/Encounters/Encounter/HealthCareFacility/Organization/Description
						Note  : If Organization Description is not found, then Location Name
								is taken from the first found of Organization Code,
								HealthCareFacility Description, or HealthCareFacility Code.
					-->
					<playingEntity classCode="PLC">
						<name>
							<xsl:choose>
								<xsl:when test="string-length(Organization/Description/text())">
									<xsl:value-of select="Organization/Description/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Organization/Code/text())">
									<xsl:value-of select="Organization/Code/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Description/text())">
									<xsl:value-of select="Description/text()"/>
								</xsl:when>
								<xsl:when test="string-length(Code/text())">
									<xsl:value-of select="Code/text()"/>
								</xsl:when>
							</xsl:choose>
						</name>
					</playingEntity>
				</participantRole>
			</participant>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="encounter-diagnoses">
		<xsl:param name="encounterPosition"/>
		<xsl:param name="encounterNumber"/>
		
		<xsl:apply-templates select="/Container/Diagnoses/Diagnosis[EncounterNumber=$encounterNumber]" mode="encounter-diagnosis">
			<xsl:with-param name="encounterPosition" select="$encounterPosition"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="encounter-diagnosis">
		<xsl:param name="encounterPosition"/>
				
		<entryRelationship typeCode="SUBJ">
			<act classCode="ACT" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-encounterDiagnosis"/>
				<id nullFlavor="UNK"/>
				<code code="29308-4" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Diagnosis"/>
				<statusCode code="active"/>
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				<!-- Template observation-Diagnosis is located in Condition.xsl -->
				<xsl:apply-templates select="." mode="observation-Diagnosis">
					<xsl:with-param name="narrativeLinkCategory" select="'encounterDiagnoses'"/>
					<xsl:with-param name="narrativeLinkSuffix" select="concat($encounterPosition,'-',position())"/>
				</xsl:apply-templates>
			</act>
		</entryRelationship>
		
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-encounterEntry">
		<templateId root="{$ccda-EncounterActivity}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-encounterDiagnosis">
		<templateId root="{$ccda-EncounterDiagnosis}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-encounterLocation">
		<templateId root="{$ccda-ServiceDeliveryLocation}"/>
	</xsl:template>
</xsl:stylesheet>
