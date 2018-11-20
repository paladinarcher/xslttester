<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
<xsl:template name="procedureIntro">
<!--
<paragraph>
		The list of Surgical Procedures shows all procedure dates within the requested date range. If no date range was provided, the list of Surgical Procedures shows the 5 most recent procedure dates within the last 18 months. The data comes from all VA treatment facilities. 
 	</paragraph>
 -->
</xsl:template>

<xsl:template match="*" mode="procedures-Narrative">
	<text>
	<!-- VA Procedure Business Rules for Medical Content -->
     	<paragraph>
       		This section contains a list of Surgical Procedures performed at the VA for the 
       		patient and a list of Surgical Procedure Notes and Clinical Procedure Notes on record at 
       		the VA for the patient.
       	</paragraph>
  		<paragraph>
			<content styleCode="Bold">Surgical Procedures</content>
		</paragraph>
			
		<paragraph ID="procedureNarrativeIntro">
       		<xsl:choose>
                <xsl:when test="$flavor = 'MHV'">
                    This section includes a list of Surgical Procedures from the last 18 months and includes a 
                    maximum of the 5 most recent procedures. The data comes from all VA treatment facilities. 
                </xsl:when>
                <xsl:otherwise>
                    The list of Surgical Procedures shows all procedure dates within the requested date range. 
                    If no date range was provided, the list of Surgical Procedures shows the 5 most recent 
                    procedure dates within the last 18 months. The data comes from all VA treatment facilities.
                </xsl:otherwise>
            </xsl:choose>	
		</paragraph>
			<!--
            <xsl:call-template name="procedureIntro"/>  
            -->                             
         <table ID="procedureNarrative">
         	<!--
         	</table>
			<table border="1" width="100%">
			-->
			<thead>
				<tr>
					<th>Date/Time</th>
					<th>Procedure Type</th>
					<th>Procedure Qualifiers</th>
					<th>Procedure Note</th>
					<th>Provider</th>
					<th>Source</th>
				</tr>
			</thead>
			<tbody>
				<!-- Export Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
				<xsl:apply-templates select="Procedures/Procedure[(Extension/Category/text()='SR') and (not(string-length(ProcedureTime/text())) and not(string-length(FromTime/text()))) or (string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) >= 0) or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) >= 0)]" mode="procedures-NarrativeDetail"/>
			</tbody>
		</table>
			
		<paragraph>
			<content styleCode="Bold">Surgical Procedure Notes</content>
		</paragraph>
                                              
       	<paragraph ID="procedureNotesIntro">
       		<xsl:choose>
                <xsl:when test="$flavor = 'MHV'">
                	The included Surgical Procedure Notes are from the last 18 months, are available 3 calendar 
                	days after completion, and include a maximum of the 5 most recent notes associated with the 
                	procedure. The data comes from all VA treatment facilities.
                </xsl:when>
                <xsl:otherwise>
                    This section contains the 5 most recent Surgical Procedure Notes associated to each Procedure. 
                    Data comes from all VA treatment facilities. 
                </xsl:otherwise>
            </xsl:choose>
            	
         </paragraph>
         <table ID="procedureNotes">
         	<!--
         	</table>
			<table border="1" width="100%">
			-->
			<thead>
				<tr>
					<th>Date/Time</th>
					<th>Surgical Procedure Note</th>
					<th>Provider</th>
					<th>Source</th>
				</tr>
			</thead>
			<tbody>
				<!-- Export Surgical Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
				<xsl:apply-templates select="Procedures/Procedure[(Extension/Category/text()='SR') and (not(string-length(ProcedureTime/text())) and not(string-length(FromTime/text()))) or (string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) >= 0) or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) >= 0)]" mode="procedures-NotesDetail"/>
			</tbody>
		</table>
	</text>
	<xsl:call-template name="clinProc-Narrative"></xsl:call-template>		
</xsl:template>

<xsl:template match="*" mode="procedures-NarrativeDetail">
	<xsl:variable name="narrativeLinkSuffix" select="position()"/>	
		<tr ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureNarrative/text(), $narrativeLinkSuffix)}">
			<td><xsl:apply-templates select="ProcedureTime" mode="formatDateTime"/><xsl:apply-templates select="ProcedureTime" mode="formatTime"/></td>
			<td ID="{concat('procedureNote-', position())}"><xsl:value-of select="Procedure/Description/text()"/></td>
			<td ID="{concat('procedureQualifiers-', position())}"><xsl:value-of select="Extension/CptModifiers/CptModifier/Description/text()"/></td>	
			<td ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="Procedure" mode="originalTextOrDescriptionOrCode"/></td>
			<td><xsl:apply-templates select="Clinician" mode="name-Person-Narrative"/></td>
			<td ID="{concat('procedureSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
</xsl:template>
			
<xsl:template match="*" mode="procedures-NotesDetail">
	
	<xsl:variable name="narrativeLinkSuffix" select="position()"/>
	<xsl:variable name="procedureTime" select="ProcedureTime"/>
			
	<xsl:for-each select="Extension/DocumentNumbers/DocumentNumbersItem">
		<xsl:if test="position() &lt; 5">
			<tr ID="{concat('procedureNotes-', $narrativeLinkSuffix)}">
				<td><xsl:apply-templates select="$procedureTime" mode="formatDateTime"/><xsl:apply-templates select="$procedureTime" mode="formatTime"/></td>
					
				<xsl:variable name="documentNumber" select="text()"/>
				<td>
					<content ID="{concat('procedureNotesNoteText-', position())}"><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$documentNumber]/NoteText/text()"/></content>	
				</td>
				<td><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$documentNumber]/Extension/CareProviders/CareProvider/Description"/></td>
				<td><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$documentNumber]/EnteredAt/Description/text()"/></td>
			</tr>
		</xsl:if>
	</xsl:for-each>
</xsl:template>
	

<xsl:template name="procedures-NarrativeDetail-notes">
	<xsl:param name="procedurePosition"/>
	<xsl:param name="documentNumber"/>
		
	<xsl:apply-templates select="/Container/Documents/Document[DocumentNumber=$documentNumber]" mode="procedures-NarrativeDetail-note">
		<xsl:with-param name="procedurePosition" select="$procedurePosition"/>
		<xsl:with-param name="docNumber" select="$documentNumber"/>		
	</xsl:apply-templates>
</xsl:template>
	
	
<xsl:template match="*" mode="procedures-NarrativeDetail-note">

	<xsl:param name="procedurePosition"/>
	<xsl:param name="docNumber"/>

	<xsl:variable name="narrativeLinkCategory" select="'procedureNotes'"/>
	<xsl:variable name="narrativeLinkSuffix" select="concat($procedurePosition,'-',position())"/>
		
	<xsl:if test="position() &lt; 5">
		<td>
			<content ID="{concat($exportConfiguration/procedureNotes/narrativeLinkPrefixes/NoteText/text(), $narrativeLinkSuffix)}"><xsl:value-of select="NoteText/text()"/></content>	
		</td>
		<td ID="{concat('procedureNotesProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>				
		<td ID="{concat('procedureNotesSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
	</xsl:if>

</xsl:template>
	
<xsl:template name="clinProc-Narrative">

	<!-- VA Procedure Business Rules for Medical Content -->
     		                                 
    <paragraph ID="clinicalNotesIntro">
       	<xsl:choose>
       		<xsl:when test="$flavor = 'MHV'">
                The included Clinical Procedure Notes are from the last 18 months, are available 3 calendar 
                days after completion, and include a maximum of the 10 most recent notes. The data comes 
                from all VA treatment facilities. 
        	</xsl:when>
        	<xsl:otherwise>
            	This section contains all Clinical Procedure Notes, with complete text, that have procedure 
              	dates within the requested date range. If no date range was provided, the section contains 
              	the 10 most recent Clinical Procedure Notes, with complete text, that have procedure dates 
             	within the last 18 months. The data comes from all VA treatment facilities. 
      		</xsl:otherwise>
		</xsl:choose>
 	</paragraph>
  	<table ID="clinicalNotes">
         	
		<thead>
			<tr>
				<th>Date/Time</th>
				<th>Clinical Procedure Note with Text</th>
				<th>Provider</th>
				<th>Source</th>
			</tr>
		</thead>
		<tbody>
			<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='CP']">
			<!--if the non-MHV user entered custom query dates, there is no number limit-->
	 			<xsl:if test="position() &lt;= 10">
					<xsl:call-template name="Clinprocedures-NarrativeDetail">
					</xsl:call-template>
				</xsl:if>	
			</xsl:for-each>
		</tbody>
	</table>
	<!--if the non-MHV user entered custom query dates, do not display this section-->
	<xsl:if test="$titles='1'">
		<paragraph>
			<content styleCode="Bold">Additional Clinical Procedure Notes</content>
		</paragraph>
                               
       	<paragraph ID="addclinicalNotesIntro">
       		<xsl:choose>
                <xsl:when test="$flavor = 'MHV'">
                	This section includes a list of all additional Clinical Procedure Note Titles from the last 
                    18 months. The data comes from all VA treatment facilities. 	
                </xsl:when>
                <xsl:otherwise>
                    The list of ADDITIONAL Clinical Procedure Note TITLES includes all notes signed within the 
                    last 18 months. The data comes from all VA treatment facilities. 
                </xsl:otherwise>
            </xsl:choose>
         </paragraph>
       	<table ID="addclinicalNotes">
         	
			<thead>
				<tr>
					<th>Date/Time</th>
					<th>Clinical Procedure Note Title</th>
					<th>Provider</th>
					<th>Source</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='CP']">
					<xsl:if test="position() > 10">
						<xsl:call-template name="Clinprocedures-Notes">
						</xsl:call-template>
					</xsl:if>		
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:if>
</xsl:template>
	
	<xsl:template name="Clinprocedures-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
					<tbody>
					<tr ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureNarrative/text(), $narrativeLinkSuffix)}">
						<td ID="{concat('ClinproceduresTime-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
						<td ID="{concat('ClinproceduresNote-', position())}"><xsl:value-of select="NoteText/text()"/></td>
						<td ID="{concat('ClinproceduresProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>		
						<td ID="{concat('ClinproceduresSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
					</tr>
					</tbody>
	</xsl:template>
	
	<xsl:template name="Clinprocedures-Notes">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
					<tbody>
					<tr ID="{concat('clinicalProcedureNote-', $narrativeLinkSuffix)}">
						<td ID="{concat('clinicalProcedureNoteTime-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
						<td ID="{concat('clinicalProcedureNoteNotes-', position())}"><xsl:value-of select="DocumentName/text()"/></td>
						<td ID="{concat('clinicalProcedureNoteProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>		
						<td ID="{concat('clinicalProcedureNoteSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
					</tr>
					</tbody>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-Entries">
		<!-- Export Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
		<xsl:apply-templates select="Procedures/Procedure[(Extension/Category/text()='SR') and (not(string-length(ProcedureTime/text())) and not(string-length(FromTime/text()))) or (string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) >= 0) or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) >= 0)]" mode="procedures-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-NoteEntries">
		<!-- Export Procedure documents for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
		<xsl:for-each select="Procedures/Procedure[(Extension/Category/text()='SR') and (not(string-length(ProcedureTime/text())) and not(string-length(FromTime/text()))) or (string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) >= 0) or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) >= 0)]">
			<xsl:for-each select="Extension/DocumentNumbers/DocumentNumbersItem">
				<xsl:if test="position() &lt; 5">
					<xsl:call-template name="procedureNotes-EntryDetail"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="/Container/Documents/Document[DocumentType/Code='CP']">
			<xsl:call-template name="procedureNotes-EntryDetail"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<entry typeCode="DRIV">
			<procedure classCode="PROC" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-procedureEntry"/>

				<!--
					Field : Procedure Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/id
					Source: HS.SDA3.Procedure ExternalId
					Source: /Container/Procedures/Procedure/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="id-External"/>
				
				<!--
					Field : Procedure Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/code
					Source: HS.SDA3.Procedure Procedure
					Source: /Container/Procedures/Procedure/Procedure
					StructuredMappingRef: generic-Coded
				-->
				<xsl:apply-templates select="Procedure" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<statusCode code="completed"/>
				
				<!--
					Field : Procedure Date/Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/effectiveTime/@value
					Source: HS.SDA3.Procedure ProcedureTime
					Source: /Container/Procedures/Procedure/ProcedureTime
				-->
				<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
				
				<!--
					Field : Procedure Provider
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/performer
					Source: HS.SDA3.Procedure Clinician
					Source: /Container/Procedures/Procedure/Clinician
					StructuredMappingRef: performer-procedure
				-->
				<xsl:apply-templates select="Clinician" mode="performer-procedure"/>
				
				<!--
					Field : Procedure Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/author
					Source: HS.SDA3.Procedure EnteredBy
					Source: /Container/Procedures/Procedure/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				
				<!--
					Field : Procedure Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/informant
					Source: HS.SDA3.Procedure EnteredAt
					Source: /Container/Procedures/Procedure/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<!--
					Field : Procedure Encounter
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/entryRelationship
					Source: HS.SDA3.Procedure EncounterNumber
					Source: /Container/Procedures/Procedure/EncounterNumber
					StructuredMappingRef: encounterLink-entryRelationship
					Note  : This links the Procedure to an encounter in the Encounters section.
				-->
				<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
			</procedure>
		</entry>
	</xsl:template>
	
	<xsl:template name="procedureNotes-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<entry typeCode="DRIV">
			<procedure classCode="PROC" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-procedureEntry"/>

				<!--
					Field : Procedure Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/id
					Source: HS.SDA3.Procedure ExternalId
					Source: /Container/Procedures/Procedure/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="id-External"/>
				
				<!--
					Field : Procedure Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/code
					Source: HS.SDA3.Procedure Procedure
					Source: /Container/Procedures/Procedure/Procedure
					StructuredMappingRef: generic-Coded
				-->
				<!--
				<xsl:apply-templates select="Procedure" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				-->
				<code code="99499" codeSystem="2.16.840.1.113883.6.12" codeSystemName="CPT-4" displayName="Unlisted Evaluation and Management Service">
				<originaltext><reference value="{concat('#','procedureNotesNoteText-',$narrativeLinkSuffix)}"/></originaltext>
				<translation code="28570-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Procedure Note"/>
				</code>
				
				<statusCode code="completed"/>
				
				<!--
					Field : Procedure Date/Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/effectiveTime/@value
					Source: HS.SDA3.Procedure ProcedureTime
					Source: /Container/Procedures/Procedure/ProcedureTime
				-->
				<xsl:apply-templates select="." mode="effectiveTime-procedure"/>
				
				<!--
					Field : Procedure Provider
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/performer
					Source: HS.SDA3.Procedure Clinician
					Source: /Container/Procedures/Procedure/Clinician
					StructuredMappingRef: performer-procedure
				-->
				<xsl:apply-templates select="Clinician" mode="performer-procedure"/>
				
				<!--
					Field : Procedure Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/author
					Source: HS.SDA3.Procedure EnteredBy
					Source: /Container/Procedures/Procedure/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				
				<!--
					Field : Procedure Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/informant
					Source: HS.SDA3.Procedure EnteredAt
					Source: /Container/Procedures/Procedure/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				
				<!--
					Field : Procedure Encounter
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/entryRelationship
					Source: HS.SDA3.Procedure EncounterNumber
					Source: /Container/Procedures/Procedure/EncounterNumber
					StructuredMappingRef: encounterLink-entryRelationship
					Note  : This links the Procedure to an encounter in the Encounters section.
				-->
				<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
			</procedure>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="procedures-NoData">
		<text><xsl:value-of select="$exportConfiguration/procedures/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-procedureEntry">
		<templateId root="{$ccda-ProcedureActivityProcedure}"/>
	</xsl:template>
</xsl:stylesheet>
