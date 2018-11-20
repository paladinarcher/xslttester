<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<!-- Immunization Variables -->
	<!-- E = Executed, R = Replaced -->
	<xsl:variable name="immunizationExecutedStatusCodes">|E|R|</xsl:variable>
	<!-- H = On-Hold, INT = Intended (default, if no status value specified), IP = In-Progress -->
	<xsl:variable name="immunizationIntendedStatusCodes">|H|INT|IP|</xsl:variable>
	<!-- C = Cancelled, D = Discontinued -->
	<xsl:variable name="immunizationCancelledStatusCodes">|C|D|</xsl:variable>

	<xsl:template match="*" mode="immunizations-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Ordered Immunization Name</th>
						<th>Filled Immunization Name</th>
						<th>Date</th>
						<th>Status</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Encounter/Medications/Medication[(OrderItem/OrderType = 'VXU') and not(contains($immunizationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="immunizations-NarrativeDetail"/>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="immunizations-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationNarrative/text(), $narrativeLinkSuffix)}">
			<td ID="{concat($exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationOrderedName/text(), $narrativeLinkSuffix)}"><xsl:value-of select="OrderItem/Description/text()"/></td>
			<td ID="{concat($exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationFilledName/text(), $narrativeLinkSuffix)}"><xsl:value-of select="DrugProduct/Description/text()"/></td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length(StartTime)"><xsl:value-of select="translate(translate(StartTime/text(), 'T', ' '), 'Z', '')"/></xsl:when>
					<xsl:when test="string-length(EnteredOn)"><xsl:value-of select="translate(translate(EnteredOn/text(), 'T', ' '), 'Z', '')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="'Unknown'"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:apply-templates select="Status" mode="immunization-statusDescription"/></td>
			<td ID="{concat($exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="immunizations-Entries">
		<xsl:apply-templates select="Encounter/Medications/Medication[(OrderItem/OrderType = 'VXU') and not(contains($immunizationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="immunizations-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="immunizations-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry typeCode="DRIV">
			<substanceAdministration classCode="SBADM" negationInd="false">
				<!-- The following template is defined in Export/Entry-Modules/Medication.xsl -->
				<xsl:apply-templates select="." mode="substanceAdministration-moodCode"/>			
				<xsl:call-template name="templateIds-immunizationAdministration"/>
				
				<!-- External, Placer, and Filler IDs-->
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="." mode="id-Placer"/>
				<xsl:apply-templates select="." mode="id-Filler"/>
				
				<code code="IMMUNIZ" codeSystem="2.16.840.1.113883.5.4" codeSystemName="ActCode"/>
				<text><reference value="{concat('#', $exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>

				<xsl:apply-templates select="." mode="effectiveTime-Immunization"/>
				<xsl:apply-templates select="OrderItem" mode="immunization-order"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationOrderedName/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				<xsl:apply-templates select="OrderedBy" mode="performer"/>
				<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
				<xsl:apply-templates select="EnteredAt" mode="informant"/>
				<xsl:apply-templates select="." mode="observation-immunizationStatus"/>
				<xsl:apply-templates select="." mode="immunization-seriesNumber"/>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				<xsl:apply-templates select="DrugProduct" mode="immunization-supply"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/immunizations/narrativeLinkPrefixes/immunizationFilledName/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
				
				<!-- Link this medication to encounter noted in encounters section -->
				<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
			</substanceAdministration>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="immunizations-NoData">
		<text><xsl:value-of select="$exportConfiguration/immunizations/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="immunization-order">
		<xsl:param name="narrativeLink"/>
		
		<consumable typeCode="CSM">
			<manufacturedProduct classCode="MANU">
				<xsl:call-template name="templateIDs-manufacturedProduct"/>
				
				<xsl:apply-templates select="." mode="immunization-manufacturedMaterial"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
			</manufacturedProduct>
		</consumable>		
	</xsl:template>
	
	<xsl:template match="*" mode="immunization-supply">
		<xsl:param name="narrativeLink"/>

		<entryRelationship typeCode="REFR">
			<supply classCode="SPLY" moodCode="EVN">
				<xsl:apply-templates select="parent::node()" mode="id-PrescriptionNumber"/>
				
				<repeatNumber nullFlavor="UNK"/>				
				<xsl:apply-templates select="." mode="medication-quantity"/>
				
				<product typeCode="PRD">
					<manufacturedProduct classCode="MANU">
						<xsl:call-template name="templateIDs-manufacturedProduct"/>
						
						<xsl:apply-templates select="." mode="immunization-manufacturedMaterial"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
					</manufacturedProduct>
				</product>
			</supply>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="immunization-manufacturedMaterial">
		<xsl:param name="narrativeLink"/>
		
		<manufacturedMaterial classCode="MMAT" determinerCode="KIND">
			<!-- This field has slightly different requirements than other    -->
			<!-- coded element fields.  Like many coded element fields, it    -->
			<!-- has only one valid codeSystem - in this case, CVX.  However, -->
			<!-- it requires that if there is a <translation> on the code,    -->
			<!-- then the codeSystem on it must be for RxNorm or NDC, or it   -->
			<!-- must be nullFlavor.                                          -->
			<xsl:variable name="sdaCodingStandardOID"><xsl:value-of select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="$sdaCodingStandardOID='2.16.840.1.113883.6.59'">
					<code code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}">
						<originalText><reference value="{$narrativeLink}"/></originalText>
					</code>
				</xsl:when>
				<xsl:when test="$sdaCodingStandardOID='2.16.840.1.113883.6.88' or $sdaCodingStandardOID='2.16.840.1.113883.6.69'">
					<code nullFlavor="UNK">
						<originalText><reference value="{$narrativeLink}"/></originalText>
						<translation code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}"/>
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
					<xsl:when test="string-length(Description/text())"><xsl:value-of select="Description/text()"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="'Unknown Immunization'"/></xsl:otherwise>
				</xsl:choose>
			</name>
		</manufacturedMaterial>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-immunizationStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-immunizationStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail:  Hard-coded to "active" for an immunization -->
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>55561003</Code>
						<Description>Active</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="value-CE"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="immunization-statusDescription">
		<xsl:choose>
			<xsl:when test="text() = 'INT'"><xsl:text>Verified</xsl:text></xsl:when>
			<xsl:when test="text() = 'H'"><xsl:text>On Hold</xsl:text></xsl:when>
			<xsl:when test="text() = 'D'"><xsl:text>Discontinued</xsl:text></xsl:when>
			<xsl:when test="text() = 'IP'"><xsl:text>In Progress</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>Completed</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="immunization-seriesNumber">
		<entryRelationship typeCode="SUBJ">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-immunizationSeriesNumberObservation"/>
				
				<code code="30973-2" codeSystem="2.16.840.1.113883.6.1" displayName="Dose number"/>
				<statusCode code="completed"/>
				<xsl:choose>
					<xsl:when test="Administrations"><value xsi:type="INT" value="{count(Administrations/Administration)}"/></xsl:when>
					<xsl:otherwise><value nullFlavor="UNK" xsi:type="INT"/></xsl:otherwise>
				</xsl:choose>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-Immunization">
		<xsl:choose>
			<xsl:when test="string-length(StartTime)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="StartTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:when test="string-length(EnteredOn)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="EnteredOn" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="templateIds-immunizationAdministration">
		<xsl:if test="string-length($hitsp-CDA-Immunization)"><templateId root="{$hitsp-CDA-Immunization}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-MedicationActivity)"><templateId root="{$hl7-CCD-MedicationActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ImmunizationsEntry)"><templateId root="{$ihe-PCC-ImmunizationsEntry}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-MedicationsEntry)"><templateId root="{$ihe-PCC-MedicationsEntry}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SubstanceEntry)"><templateId root="{$ihe-PCC-SubstanceEntry}"/></xsl:if>		
	</xsl:template>
	
	<xsl:template name="templateIds-immunizationStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-MedicationStatusObservation)"><templateId root="{$hl7-CCD-MedicationStatusObservation}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-immunizationSeriesNumberObservation">
		<xsl:if test="string-length($hl7-CCD-MedicationSeriesNumberObservation)"><templateId root="{$hl7-CCD-MedicationSeriesNumberObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
