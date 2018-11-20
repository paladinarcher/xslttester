<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- AlsoInclude: AuthorParticipation.xsl -->
  
	<xsl:template match="*" mode="eP-procedures-Narrative">
		<xsl:param name="procedureList"/>
		<text>
		<!-- VA Procedure Business Rules for Medical Content -->
     		<paragraph>
     		<xsl:choose>
                <xsl:when test="$flavor = 'MHV'">
                	This section contains a list of Surgical Procedures performed at the VA for the patient, with 
                	the associated Surgical Notes, and a list of Clinical Procedure Notes on record at the VA for 
                	the patient. The data comes from all VA treatment facilities. 
                </xsl:when>
               	<xsl:otherwise>
     				This section contains a list of Surgical Procedures performed at the VA for the patient, with the 
     				associated Surgical Notes, and a list of Clinical Procedure Notes on record at the VA for the patient 
     				within the requested date range. If no date range was provided, the lists include data from the last 
     				18 months. The data comes from all VA treatment facilities. 
     			</xsl:otherwise>
            	</xsl:choose>
         	</paragraph>
  			<paragraph>
				<content styleCode="Bold">Surgical Procedures with Notes</content>
			</paragraph>
			
			<paragraph ID="procedureNarrativeIntro">
       			<xsl:choose>
                	<xsl:when test="$flavor = 'MHV'">
                		The included list of Surgical Procedures is from the last 18 months and includes a maximum 
                		of the 5 most recent procedures. The data comes from all VA treatment facilities. 
                	</xsl:when>
                	<xsl:otherwise>
                		The list of Surgical Procedures shows all procedure dates within the requested date range. 
                		If no date range was provided, the list of Surgical Procedures shows the 5 most recent 
                		procedure dates within the last 18 months. The data comes from all VA treatment facilities. 
                	</xsl:otherwise>
            	</xsl:choose>
				
			</paragraph>                            
			<!-- Export Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
			<xsl:apply-templates select="$procedureList" mode="eP-procedures-NarrativeDetail"/>
		
		<xsl:call-template name="documents-Narrative">
			<xsl:with-param name="documentTypes" select="'Clinical Procedure Notes'"/>
			<xsl:with-param name="documentType" select="'Clinical Procedure Note with Text'"/>
			<xsl:with-param name="documentText1" select="'This section contains all Clinical Procedure Notes, with complete text, that have procedure dates'"/>
			<xsl:with-param name="documentText2" select="'section contains'"/> 
			<xsl:with-param name="documentText3" select="'Clinical Procedure Notes, with complete text, that have procedure dates'"/>
			<xsl:with-param name="documentCode" select="'CP'"/>
			<xsl:with-param name="documentN" select="'10'"/>
			<xsl:with-param name="documentM" select="'18'"/>
			<xsl:with-param name="documentD" select="'3'"/>
			<xsl:with-param name="documentTitles" select="'1'"/>
		</xsl:call-template>
		</text>	
	</xsl:template>

	<xsl:template match="Procedure" mode="eP-procedures-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>	
		
		<paragraph>
				<content styleCode="Bold">Surgical Procedure</content>
		</paragraph>
		<table>
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
		<tr ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureNarrative/text(), $narrativeLinkSuffix)}">
			<td><xsl:apply-templates select="ProcedureTime" mode="formatDateTime"/><xsl:apply-templates select="ProcedureTime" mode="formatTime"/></td>
			<td ID="{concat('procedureNote-', position())}"><xsl:value-of select="Procedure/Description/text()"/></td>
			<td ID="{concat('procedureQualifiers-', position())}"><xsl:value-of select="Extension/CptModifiers/CptModifier/Description/text()"/></td>	
			<td ID="{concat($exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="Procedure" mode="fn-originalTextOrDescriptionOrCode"/></td>
			<td><xsl:apply-templates select="Clinician" mode="fn-name-Person-Narrative"/></td>
			<td ID="{concat('procedureSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
		</tr>
		</tbody>
		
		<tbody>
		<tr>
		<td/>
		<td colspan="5">
		<!-- Surgical notes begin -->
		
		<paragraph>
				<content styleCode="Bold">Surgical Notes</content>
		</paragraph>
			<xsl:choose>
			<xsl:when test="string-length(Extension/DocumentNumbers/DocumentNumbersItem)">
			
				<paragraph>
					The included Surgical Procedure Notes are from the last 18 months, are available 3 calendar days 
					after completion, and include a maximum of the 5 most recent notes associated to the Procedure. The 
					data comes from all VA treatment facilities.
				</paragraph> 
	
				<item>
				<table>
			
				<thead>
					<tr>
						<th>Date/Time</th>
						<th>Surgical Procedure Note</th>
						<th>Provider</th>
					</tr>
				</thead>

				<tbody>
				<xsl:variable name="procedureTime" select="ProcedureTime"/>
				<xsl:for-each select="Extension/DocumentNumbers/DocumentNumbersItem">
				<xsl:if test="position() &lt; 5">
					<tr ID="{concat('procedureNote-', position())}">
					<td><xsl:apply-templates select="$procedureTime" mode="formatDateTime"/><xsl:apply-templates select="$procedureTime" mode="formatTime"/></td>
					<!--
					<xsl:variable name="documentNumber" select="concat('TIU;',text())"/>
					-->
					<xsl:variable name="documentNumber" select="text()"/>
					<td>
					<content ID="{concat('procedureNoteNoteText-', position())}"><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$documentNumber]/NoteText/text()"/></content>	
					</td>
					<td><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$documentNumber]/Extension/CareProviders/CareProvider/Description"/></td>
					</tr>
				</xsl:if>
				</xsl:for-each>
				</tbody>
				</table>
				</item>
		
			</xsl:when>
			<xsl:otherwise>
				There are no associated notes for this surgical procedure.
			</xsl:otherwise>
		</xsl:choose>
		</td>
		</tr>
		</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="*" mode="documents-NotesDetail">
	<xsl:param name="encounterDate"/>
	
	<xsl:if test="position() &lt; 5">
		<tr ID="{concat('documentNote-', position())}">
			<!--
			<td><xsl:apply-templates select="ProcedureTime" mode="formatDateTime"/><xsl:apply-templates select="ProcedureTime" mode="formatTime"/></td>
			
			<xsl:variable name="fulldocNumber" select="concat('TIU;',$documentNumber)"/>
		
			<content ID="{concat('NoteText-', position())}"><xsl:value-of select="/Container/Documents/Document[DocumentNumber=$fulldocNumber]/NoteText/text()"/></content>	
			-->
			<td><xsl:apply-templates select="$encounterDate" mode="formatDateTime"/><xsl:apply-templates select="ProcedureTime" mode="formatTime"/></td>
			<content ID="{concat('NoteText-', position())}"><xsl:value-of select="NoteText/text()"/></content>	
			<td><xsl:value-of select="Extension/CareProviders/CareProvider/Description"/></td>
		</tr>
	</xsl:if>
	</xsl:template>
	
	<xsl:template name="documents-Narrative">
		<xsl:param name="documentTypes"/>
		<xsl:param name="documentType"/>
		<xsl:param name="documentText1"/>
		<xsl:param name="documentText2"/>
		<xsl:param name="documentText3"/>
		<xsl:param name="documentCode"/>
		<xsl:param name="documentN"/>
		<xsl:param name="documentM"/>
		<xsl:param name="documentD"/>
		<xsl:param name="documentTitles"/>
		<!--
		<text>
		-->
			<!-- VA Procedure Business Rules for Medical Content -->
     		                                 
       		<paragraph ID="{concat($documentCode,'Intro')}">
       		<content styleCode="Bold"><xsl:value-of select="$documentTypes"/></content>
       		</paragraph>
       		<paragraph>
       			<xsl:choose>
       				<xsl:when test="$flavor = 'SES'">
                		For cases when an order for <xsl:value-of select="substring-before($documentTypes, ' ')"/> services may 
                		have been completed prior to the date of the Encounter, the report list includes 
                		the <xsl:value-of select="$documentTypes"/> that were completed up to 30 days 
                		before date of the Encounter. For cases when an order for 
                		<xsl:value-of select="substring-before($documentTypes, ' ')"/> services may have been completed after the 
                		date of the Encounter, the report list also includes the 
                		<xsl:value-of select="$documentTypes"/> that were completed up to 30 days after 
                		date of the Encounter. The data comes from all VA treatment facilities. 
                	</xsl:when>
                	<xsl:when test="$flavor = 'MHV'">
                		The included <xsl:value-of select="$documentTypes"/> are from the last <xsl:value-of select="$documentM"/> months, are available <xsl:value-of select="$documentD"/> calendar days after 
                		completion, and include a maximum of the <xsl:value-of select="$documentN"/>  most recent notes. The data comes from all VA treatment 
                		facilities. 
                	</xsl:when>
                	<xsl:otherwise>
                    	<xsl:value-of select="$documentText1"/> within the requested date range. If no 
                    	date range was provided, the <xsl:value-of select="$documentText2"/> the 
                    	<xsl:value-of select="$documentN"/> most recent <xsl:value-of select="$documentText3"/> 
                    	within the last <xsl:value-of select="$documentM"/> months. The data comes from all VA 
                    	treatment facilities. 
                	</xsl:otherwise>
            	</xsl:choose>
         	</paragraph>
         	<!--
         	<table ID="{concat($documentCode,'Notes')}">
         	</table>
         	-->
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Date/Time</th>
						<th><xsl:value-of select="$documentType"/></th>
						<th>Provider</th>
						<th>Source</th>
					</tr>
				</thead>
				<tbody>
				<xsl:for-each select="/Container/Documents/Document[DocumentType/Code=$documentCode]">
					<!--if the non-MHV user entered custom query dates, there is no number limit
					-->
	 				<xsl:if test="position() &lt;= $documentN">
						<xsl:call-template name="documents-NarrativeDetail">
						<xsl:with-param name="Code" select="$documentCode"/>
						</xsl:call-template>
					</xsl:if>	
				</xsl:for-each>
				</tbody>
			</table>
            
            <!--titles section prints for all documents except LAB & RAD results section --> 
            <xsl:if test="$documentTitles='1'"> 
            <!--Do not print titles section if user entered custom query dates --> 
              <paragraph>
				<content styleCode="Bold">Additional <xsl:value-of select="$documentTypes"/></content>
			</paragraph>             
       		<paragraph ID="{concat($documentCode,'TitlesIntro')}">
       			<xsl:choose>
                	<xsl:when test="$flavor = 'MHV'">
                		This section includes a list of all additional <xsl:value-of select="$documentTypes"/> Titles from the 
                		last 18 months. The data comes from all VA treatment facilities. 
                	</xsl:when>
                	<xsl:otherwise>
                		The list of ADDITIONAL <xsl:value-of select="$documentTypes"/> TITLES includes all notes signed within 
                		the last 18 months. The data comes from all VA treatment facilities.
                	</xsl:otherwise>
            	</xsl:choose>
         	</paragraph>
         	<!--
         	<table ID="{concat($documentCode,'Titles')}">
         	</table>
         	-->
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Date/Time</th>
						<th><xsl:value-of select="$documentType"/> Title</th>
						<th>Provider</th>
						<th>Source</th>
					</tr>
				</thead>
				<tbody>
				<xsl:for-each select="/Container/Documents/Document[DocumentType/Code=$documentCode]">
					<xsl:if test="position() > $documentN ">
						<xsl:call-template name="documents-Titles">
						<xsl:with-param name="code" select="$documentCode"/>
						</xsl:call-template>
					</xsl:if>		
				</xsl:for-each>
				</tbody>
			</table>
			</xsl:if>
			<!--
		</text>
		-->
	</xsl:template>
	
	<xsl:template name="documents-NarrativeDetail">
	<xsl:param name="Code"/>
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
					<tbody>
					<tr ID="{concat($Code,'Narrative-', $narrativeLinkSuffix)}">
						<td ID="{concat($Code,'Time-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
						<td ID="{concat($Code,'Notes-', position())}"><xsl:value-of select="NoteText/text()"/></td>		
						<td ID="{concat($Code,'Provider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description/text()"/></td>
						<td ID="{concat($Code,'Source-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
					</tr>
					</tbody>
	</xsl:template>
	
	<xsl:template name="documents-Titles">
	<xsl:param name="code"/>
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>
					<tbody>
					<tr ID="{concat($code,'Title-', $narrativeLinkSuffix)}">
						<td ID="{concat($code,'-TitleTime-', position())}"><xsl:apply-templates select="AuthorizationTime" mode="formatDateTime"/><xsl:apply-templates select="AuthorizationTime" mode="formatTime"/></td>
						<td ID="{concat($code,'-TitleNotes-', position())}"><xsl:value-of select="DocumentName/text()"/></td>		
						<td ID="{concat($code,'-TitleProvider-', position())}"><xsl:value-of select="Extension/CareProviders/CareProvider/Description/text()"/></td>
						<td ID="{concat($code,'TitleSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
					</tr>
					</tbody>
	</xsl:template>

	<xsl:template match="*" mode="eP-procedures-Entries">
		<xsl:param name="procedureList"/>
		<!-- Export Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
		<xsl:apply-templates select="$procedureList" mode="eP-procedures-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="Procedure" mode="eP-procedures-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<entry typeCode="DRIV">
			<procedure classCode="PROC" moodCode="EVN">
				<xsl:call-template name="eP-templateIds-procedureEntry"/>

				<!--
					Field : Procedure Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/id
					Source: HS.SDA3.Procedure ExternalId
					Source: /Container/Procedures/Procedure/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="fn-id-External"/>
				
				<!--
					Field : Procedure Type
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/code
					Source: HS.SDA3.Procedure Procedure
					Source: /Container/Procedures/Procedure/Procedure
					StructuredMappingRef: generic-Coded
				-->
				<xsl:apply-templates select="Procedure" mode="fn-generic-Coded">
					<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/procedures/narrativeLinkPrefixes/procedureDescription/text(), $narrativeLinkSuffix)"/>
				</xsl:apply-templates>
				
				<statusCode code="completed"/>
				
				<!--
					Field : Procedure Date/Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/effectiveTime/@value
					Source: HS.SDA3.Procedure ProcedureTime
					Source: /Container/Procedures/Procedure/ProcedureTime
				-->
				<xsl:choose>
					<xsl:when test="string-length(ProcedureTime/text())">
						<xsl:apply-templates select="ProcedureTime" mode="fn-effectiveTime-singleton"/>
					</xsl:when>
					<xsl:otherwise>
						<effectiveTime><xsl:attribute name="nullFlavor">UNK</xsl:attribute></effectiveTime>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--
					Field : Procedure Provider
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/performer
					Source: HS.SDA3.Procedure Clinician
					Source: /Container/Procedures/Procedure/Clinician
					StructuredMappingRef: performer-procedure
				-->
				<xsl:apply-templates select="Clinician" mode="fn-performer-procedure"/>
				
				<!--
					Field : Procedure Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/author
					Source: HS.SDA3.Procedure EnteredBy
					Source: /Container/Procedures/Procedure/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="EnteredBy" mode="eAP-author-Human"/>
				
				<!--
					Field : Procedure Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/informant
					Source: HS.SDA3.Procedure EnteredAt
					Source: /Container/Procedures/Procedure/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="EnteredAt" mode="fn-informant"/>
				
				<xsl:apply-templates select="Devices/Device" mode="eP-participant-productInstance"/>
				<!--
					Field : Procedure Encounter
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/entryRelationship
					Source: HS.SDA3.Procedure EncounterNumber
					Source: /Container/Procedures/Procedure/EncounterNumber
					StructuredMappingRef: encounterLink-entryRelationship
					Note  : This links the Procedure to an encounter in the Encounters section.
				-->
				<xsl:apply-templates select="." mode="fn-encounterLink-entryRelationship"/>
			</procedure>
		</entry>
	</xsl:template>
	
	<xsl:template match="Device" mode="eP-participant-productInstance">
		<participant typeCode="DEV">
			<participantRole classCode="MANU">
				<templateId root="2.16.840.1.113883.10.20.22.4.37"/>
				<!-- ToDo: replace above with normal call-template and global variable -->
				
				<!--
					Field : Procedure Device Root
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/participant/participantRole/id@root
					Source: HS.SDA3.Device UDIRoot
					Source: /Container/Procedures/Procedure/Devices/Device/UDIRoot
				-->
				<!--
					Field : Procedure Device Extension
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/participant/participantRole/id@extension
					Source: HS.SDA3.Device UDIExtension
					Source: /Container/Procedures/Procedure/Devices/Device/UDIExtension
				-->
				<!--
					Field : Procedure Device AssigningAuthorityName
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/participant/participantRole/id@assigningAuthorityName
					Source: HS.SDA3.Device UDIAssigningAuthority
					Source: /Container/Procedures/Procedure/Devices/Device/UDIAssigningAuthority
				-->
				<id>
					<xsl:attribute name="root"><xsl:value-of select="UDIRoot/text()"/></xsl:attribute>
					<xsl:attribute name="extension"><xsl:value-of select="UDIExtension/text()"/></xsl:attribute>
					<xsl:attribute name="assigningAuthorityName"><xsl:value-of select="UDIAssigningAuthority/text()"/></xsl:attribute>
				</id>
				
				<!--
					Field : Procedure Device Code
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/participant/participantRole/playingDevice
					Source: HS.SDA3.Device UDIAssigningAuthority
					Source: /Container/Procedures/Procedure/Devices/Device/Device
					StructuredMappingRef: generic-Coded
				-->
				<playingDevice>
					<xsl:apply-templates select="Device" mode="fn-generic-Coded">
						<xsl:with-param name="isCodeRequired" select="'1'"/>
					</xsl:apply-templates>
				</playingDevice>


				<!--
					Field : Procedure Device Code
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.7.1']/entry/procedure/participant/participantRole/scopingEntity/id
					Source: HS.SDA3.Device UDIAssigningAuthority
					Source: /Container/Procedures/Procedure/Devices/Device/UDIRoot
				-->
				<scopingEntity>
					<id>
						<xsl:attribute name="root"><xsl:value-of select="UDIRoot/text()"/></xsl:attribute>
					</id>
				</scopingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	
	<xsl:template match="*" mode="eP-procedures-NoData">
		<text><xsl:value-of select="$exportConfiguration/procedures/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="eP-templateIds-procedureEntry">
		<templateId root="{$ccda-ProcedureActivityProcedure}"/>
		<templateId root="{$ccda-ProcedureActivityProcedure}" extension="2014-06-09"/>
	</xsl:template>
	
	<xsl:template name="eP-templateIds-productInstance">
		<!-- UNUSED, but available -->
		<templateId root="{$ccda-ProductInstance}"/>
	</xsl:template>

</xsl:stylesheet>