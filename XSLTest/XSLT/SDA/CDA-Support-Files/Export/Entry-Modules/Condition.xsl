<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<!-- Problem Variables -->
	<xsl:variable name="currentConditionStatusCodes" select="$exportConfiguration/problems/currentCondition/codes/text()"/>
	<xsl:variable name="currentConditionWindowInDays" select="$exportConfiguration/problems/currentCondition/windowInDays/text()"/>
	
	<xsl:template match="*" mode="conditions-Narrative">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="currentConditions" select="true()"/>
		
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Condition Name</th>
						<th>Condition Details</th>
						<th>Condition Category</th>
						<th>Status</th>
						<th>Onset Date</th>
						<th>Resolution Date</th>
						<th>Last Treatment Date</th>
						<th>Treating Clinician</th>
						<th>Treatment Method(s)</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Problems/Problem" mode="conditions-NarrativeDetail">
						<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
						<xsl:with-param name="currentConditions" select="$currentConditions"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="conditions-NarrativeDetail">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="currentConditions"/>

		<xsl:variable name="includeInExport"><xsl:apply-templates select="." mode="includeConditionInExport"><xsl:with-param name="currentConditions" select="$currentConditions"></xsl:with-param></xsl:apply-templates></xsl:variable>

		<xsl:if test="($includeInExport = 1)">
			<xsl:variable name="narrativeLinkSuffix">
				<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
					<xsl:with-param name="entryNumber" select="position()"/>
				</xsl:apply-templates>
			</xsl:variable>		
			
			<tr ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionNarrative/text(), $narrativeLinkSuffix)}">
				<td><xsl:value-of select="Problem/Description/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionDescription/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ProblemDetails/text()"/></td>
				<td><xsl:value-of select="Category/Description/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionStatus/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Status/Description/text()"/></td>
				<td><xsl:value-of select="FromTime/text()"/></td>
				<td><xsl:value-of select="ToTime/text()"/></td>
				<td><xsl:value-of select="EnteredOn/text()"/></td>
				<td><xsl:value-of select="Clinician/Description/text()"/></td>
				<td><xsl:value-of select="TreatmentMethods/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="conditions-Entries">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="currentConditions" select="true()"/>

		<xsl:apply-templates select="Encounter/Problems/Problem" mode="conditions-EntryDetail">
			<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
			<xsl:with-param name="currentConditions" select="$currentConditions"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="conditions-EntryDetail">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="currentConditions"/>

		<xsl:variable name="includeInExport"><xsl:apply-templates select="." mode="includeConditionInExport"><xsl:with-param name="currentConditions" select="$currentConditions"></xsl:with-param></xsl:apply-templates></xsl:variable>

		<xsl:if test="($includeInExport = 1)">
			<xsl:variable name="narrativeLinkSuffix">
				<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
					<xsl:with-param name="entryNumber" select="position()"/>
				</xsl:apply-templates>
			</xsl:variable>		
			
			<entry typeCode="DRIV">
				<act classCode="ACT" moodCode="EVN">
					<xsl:call-template name="templateIDs-problemEntry"/>
					<xsl:apply-templates select="." mode="id-External"/>
					
					<code nullFlavor="NA"/>
					<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionNarrative/text(), $narrativeLinkSuffix)}"/></text>

					<xsl:apply-templates select="." mode="statusCode-Problem"/>
					<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
					<xsl:apply-templates select="EnteredAt" mode="informant"/>
					<xsl:apply-templates select="." mode="observation-Problem">
						<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
						<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
					<!-- Link this problem to encounter noted in encounters section -->
					<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
				</act>
			</entry>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="problems-NoData">
		<text><xsl:value-of select="$exportConfiguration/problems/emptySection/narrativeText/text()"/></text>
		 <entry typeCode="DRIV">
	  		<act classCode="ACT" moodCode="EVN">
	  			<templateId root="2.16.840.1.113883.3.88.11.83.7"/> 
	  			<templateId root="2.16.840.1.113883.10.20.1.27"/> 
	 			<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.1"/> 
	  			<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5.2" /> 
	  			<id nullFlavor="NI"/> 
	  			<code nullFlavor="NA"/> 
	  			<text><reference value="#noProblems-1"/></text>
	  			<statusCode code="completed" /> 
	  			<effectiveTime>
	 				<low nullFlavor="UNK"/>
	 				<high nullFlavor="UNK"/>
	 			</effectiveTime>
				<entryRelationship typeCode="SUBJ" inversionInd="false">
					<observation classCode="OBS" moodCode="EVN">
						<templateId root="2.16.840.1.113883.10.20.1.28"/>
						<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
						<id nullFlavor="NI"/>
						<code nullFlavor="NI"/>
						<text><reference value="#noProblems-1"/></text>
						<statusCode code="completed"/> 
						<effectiveTime>
							<low nullFlavor="UNK"/>
							<high nullFlavor="UNK"/>
						</effectiveTime>
						<value nullFlavor="NI" xsi:type="CD"/>
					</observation>
				</entryRelationship>
			</act>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="pastIllness-NoData">
		<text><xsl:value-of select="$exportConfiguration/pastIllness/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="admissionDiagnoses-NoData">
		<text><xsl:value-of select="$exportConfiguration/admissionDiagnoses/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="dischargeDiagnoses-NoData">
		<text><xsl:value-of select="$exportConfiguration/dischargeDiagnoses/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="diagnoses-Narrative">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="diagnosisTypeCodes"/>
		
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Condition Name</th>
						<th>Status</th>
						<th>Diagnosis Date</th>
						<th>Treating Clinician</th>
						<th>Treatment Method(s)</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Diagnoses/Diagnosis[contains(isc:evaluate('toUpper', $diagnosisTypeCodes), concat('|', isc:evaluate('toUpper', DiagnosisType/Code/text()), '|')) = true()]" mode="diagnoses-NarrativeDetail">
						<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="diagnoses-NarrativeDetail">
		<xsl:param name="narrativeLinkCategory"/>
			
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisNarrative/text(), $narrativeLinkSuffix)}">
			<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisDescription/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Diagnosis/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisStatus/text(), $narrativeLinkSuffix)}">
				<xsl:variable name="statusCode"><xsl:value-of select="Status/Code/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$statusCode = 'A'">Active</xsl:when>
					<xsl:when test="$statusCode = 'I'">Inactive</xsl:when>
					<xsl:otherwise>Unknown</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:value-of select="IdentificationTime/text()"/></td>
			<td><xsl:value-of select="DiagnosingClinician/Description/text()"/></td>
			<td><xsl:value-of select="TreatmentMethods/text()"/></td>
			<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="diagnoses-Entries">
		<xsl:param name="narrativeLinkCategory"/>			
		<xsl:param name="diagnosisTypeCodes"/>
		
		<xsl:apply-templates select="Encounter/Diagnoses/Diagnosis[contains(isc:evaluate('toUpper', $diagnosisTypeCodes), concat('|', isc:evaluate('toUpper', DiagnosisType/Code/text()), '|')) = true()]" mode="diagnoses-EntryDetail">
			<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="diagnoses-EntryDetail">
		<xsl:param name="narrativeLinkCategory"/>
			
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="EVN">
				<xsl:call-template name="templateIDs-problemEntry"/>
				<xsl:apply-templates select="." mode="id-External"/>

				<code nullFlavor="NA"/>
				<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisNarrative/text(), $narrativeLinkSuffix)}"/></text>

				<xsl:apply-templates select="." mode="statusCode-Diagnosis"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="." mode="observation-Diagnosis">
					<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<!-- Link this problem to encounter noted in encounters section -->
				<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
			</act>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="observation-Problem">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<entryRelationship typeCode="SUBJ" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-problemObservation"/>
				
				<id nullFlavor="NI"/>
				
				<!-- Condition Type -->
				<xsl:choose>
					<xsl:when test="Category">
						<xsl:apply-templates select="Category" mode="generic-Coded">
							<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$snomedOID"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise><code nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
				
				<!-- Condition Name -->
				<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionDescription/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<!-- Effective Time -->
				<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
				
				<!-- Condition Code -->
				<xsl:apply-templates select="Problem" mode="value-Coded">
					<xsl:with-param name="xsiType">CD</xsl:with-param>
					<xsl:with-param name="requiredCodeSystemOID"><xsl:value-of select="$snomedOID"/></xsl:with-param>
				</xsl:apply-templates>
				
				<!-- Performer Information -->
				<xsl:apply-templates select="Clinician" mode="performer"/>
				
				<!-- Problem Status -->
				<xsl:apply-templates select="Status" mode="observation-ProblemStatus"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/conditionStatus/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Diagnosis">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<entryRelationship typeCode="SUBJ" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-problemObservation"/>
				
				<id nullFlavor="NI"/>
				
				<!-- Diagnosis Type -->
				<code code="282291009" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Diagnosis"/>
				
				<!-- Diagnosis Name -->
				<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisDescription/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<!--
					IHE mandates special handling of "aborted" and "completed" states when building <effectiveTime>:
					The <high> element shall be present for concerns in the completed or aborted state, and shall not be present otherwise.
				-->		
				<xsl:apply-templates select="." mode="effectiveTime-Identification">
					<xsl:with-param name="includeHighTime" select="not(contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|')))"/>
				</xsl:apply-templates>
				
				<!-- Diagnosis Code -->
				<xsl:apply-templates select="Diagnosis" mode="value-CD"/>
				
				<!-- Performer Information -->
				<xsl:apply-templates select="DiagnosingClinician" mode="performer"/>
				
				<!-- Diagnosis Status -->
				<xsl:apply-templates select="Status" mode="observation-ProblemStatus"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/diagnosisStatus/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="statusCode-Problem">
		<statusCode>
			<xsl:attribute name="code">
				<xsl:choose>
					<xsl:when test="contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|'))">active</xsl:when>
					<xsl:otherwise>completed</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</statusCode>

		<!--
			IHE mandates special handling of "aborted" and "completed" states when building <effectiveTime>:
			The <high> element shall be present for concerns in the completed or aborted state, and shall not be present otherwise.
		-->
		<xsl:apply-templates select="." mode="effectiveTime-FromTo">
			<xsl:with-param name="includeHighTime" select="not(contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|')))"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="statusCode-Diagnosis">
		<statusCode>
			<xsl:attribute name="code">
				<xsl:choose>
					<xsl:when test="contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|'))">active</xsl:when>
					<xsl:otherwise>completed</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</statusCode>

		<!--
			IHE mandates special handling of "aborted" and "completed" states when building <effectiveTime>:
			The <high> element shall be present for concerns in the completed or aborted state, and shall not be present otherwise.
		-->		
		<xsl:apply-templates select="." mode="effectiveTime-Identification">
			<xsl:with-param name="includeHighTime" select="not(contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|')))"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="observation-ProblemStatus">
		<xsl:param name="narrativeLink"/>
		
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIDs-problemStatus"></xsl:call-template>
				
				<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status"/>
				<text><reference value="{$narrativeLink}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="includeConditionInExport">
		<xsl:param name="currentConditions"/>
		
		<!-- Should this condition be "promoted" to the active problem list? -->
		<xsl:variable name="isCurrentCondition"><xsl:apply-templates select="." mode="currentCondition"/></xsl:variable>

		<xsl:choose>
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

	<xsl:template name="templateIDs-problemEntry">
		<xsl:if test="string-length($hitsp-CDA-Condition)"><templateId root="{$hitsp-CDA-Condition}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemAct)"><templateId root="{$hl7-CCD-ProblemAct}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ConcernEntry)"><templateId root="{$ihe-PCC-ConcernEntry}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemConcernEntry)"><templateId root="{$ihe-PCC-ProblemConcernEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-problemObservation">
		<xsl:if test="string-length($hl7-CCD-ProblemObservation)"><templateId root="{$hl7-CCD-ProblemObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemEntry)"><templateId root="{$ihe-PCC-ProblemEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-problemStatus">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemStatusObservation)"><templateId root="{$hl7-CCD-ProblemStatusObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProblemStatusObservation)"><templateId root="{$ihe-PCC-ProblemStatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
