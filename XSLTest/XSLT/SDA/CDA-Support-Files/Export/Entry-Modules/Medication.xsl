<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<!-- Medication Variables -->
	<xsl:variable name="includeHistoricalMedications" select="$exportConfiguration/medications/currentMedication/includeHistoricalMedications/text()"/>
	<xsl:variable name="currentMedicationWindowInDays" select="$exportConfiguration/medications/currentMedication/windowInDays/text()"/>

	<!-- E = Executed, R = Replaced -->
	<xsl:variable name="medicationExecutedStatusCodes">|E|R|</xsl:variable>
	<!-- H = On-Hold, INT = Intended (default, if no status value specified), IP = In-Progress -->
	<xsl:variable name="medicationIntendedStatusCodes">|H|INT|IP|</xsl:variable>
	<!-- C = Cancelled, D = Discontinued -->
	<xsl:variable name="medicationCancelledStatusCodes">|C|D|</xsl:variable>

	<xsl:template match="*" mode="medications-Narrative">
		<xsl:param name="narrativeLinkCategory"/>
			
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Ordered Medication Name</th>
						<th>Filled Medication Name</th>
						<th>Start Date</th>
						<th>Stop Date</th>
						<th>Current Medication?</th>
						<th>Ordering Clinician</th>
						<th>Indication</th>
						<th>Dosage</th>
						<th>Frequency</th>
						<th>Signature (SIG)</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<xsl:choose>
						<xsl:when test="$narrativeLinkCategory = 'administeredMedications'">
							<xsl:apply-templates select="Encounter[contains('E|I|O', EncounterType/text())]/Medications/Medication[(OrderItem/OrderType != 'VXU') and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="medications-NarrativeDetail"><xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/></xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="Encounter/Medications/Medication[(OrderItem/OrderType != 'VXU') and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="medications-NarrativeDetail"><xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/></xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</tbody>
			</table>
		</text>
	</xsl:template>

	<xsl:template match="*" mode="medications-NarrativeDetail">
		<xsl:param name="narrativeLinkCategory"/>

		<xsl:variable name="isCurrentMedication"><xsl:apply-templates select="." mode="currentMedication"/></xsl:variable>
		<xsl:variable name="includeInExport"><xsl:apply-templates select="." mode="includeMedicationInExport"/></xsl:variable>
		
		<xsl:if test="($includeInExport = 1)">
			<xsl:variable name="narrativeLinkSuffix">
				<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
					<xsl:with-param name="entryNumber" select="position()"/>
				</xsl:apply-templates>
			</xsl:variable>		
			
			<tr ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationNarrative/text(), $narrativeLinkSuffix)}">
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationOrderedName/text(), $narrativeLinkSuffix)}"><xsl:value-of select="OrderItem/Description/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationFilledName/text(), $narrativeLinkSuffix)}"><xsl:value-of select="DrugProduct/Description/text()"/></td>
				<td><xsl:value-of select="StartTime/text()"/></td>
				<td><xsl:value-of select="EndTime/text()"/></td>
				<td>
					<xsl:choose>
						<xsl:when test="$isCurrentMedication = 1">Yes</xsl:when>
						<xsl:otherwise>No</xsl:otherwise>
					</xsl:choose>
				</td>
				<td><xsl:value-of select="OrderedBy/Description/text()"/></td>
				<!-- As of 10/14/2011 Indication is still stored in HSDB as String,  -->
				<!-- not as coded item.  The export is now fixed to properly handle  -->
				<!-- String value, and coded value, when that ever gets implemented. -->
				<xsl:choose>
					<xsl:when test="string-length(Indication/Description/text())">
						<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationIndication/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Indication/Description/text()"/></td>
					</xsl:when>
					<xsl:otherwise>
						<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationIndication/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Indication/text()"/></td>
					</xsl:otherwise>
				</xsl:choose>
				<td><xsl:value-of select="concat(DoseQuantity/text(), DoseUoM/Code/text())"/></td>
				<td><xsl:value-of select="Frequency/Description/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationSignature/text(), $narrativeLinkSuffix)}"><xsl:value-of select="TextInstruction/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="medications-Entries">
		<xsl:param name="narrativeLinkCategory"/>

		<xsl:choose>
			<xsl:when test="$narrativeLinkCategory = 'administeredMedications'">
				<xsl:apply-templates select="Encounter[contains('E|I|O', EncounterType/text())]/Medications/Medication[(OrderItem/OrderType != 'VXU') and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="medications-EntryDetail"><xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/></xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="Encounter/Medications/Medication[(OrderItem/OrderType != 'VXU') and not(contains($medicationCancelledStatusCodes, concat('|', Status/text(), '|')))]" mode="medications-EntryDetail"><xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/></xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template match="*" mode="medications-EntryDetail">
		<xsl:param name="narrativeLinkCategory"/>

		<xsl:variable name="includeInExport"><xsl:apply-templates select="." mode="includeMedicationInExport"/></xsl:variable>
		
		<xsl:if test="($includeInExport = 1)">
			<xsl:variable name="narrativeLinkSuffix">
				<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
					<xsl:with-param name="entryNumber" select="position()"/>
				</xsl:apply-templates>
			</xsl:variable>		
			
			<entry typeCode="DRIV">
				<xsl:apply-templates select="." mode="substanceAdministration">
					<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
				</xsl:apply-templates>
			</entry>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="medications-NoData">
		<text><xsl:value-of select="$exportConfiguration/medications/emptySection/narrativeText/text()"/></text>
		<entry typeCode="DRIV">
			<substanceAdministration classCode="SBADM" moodCode="EVN">
				<templateId root="2.16.840.1.113883.3.88.11.83.8"/>
				<templateId root="2.16.840.1.113883.10.20.1.24"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.1"/>
				<id nullFlavor="NI"/>
				<code code="182849000" codeSystem="{$snomedOID}" displayName="No Drug Therapy Prescribed" codeSystemName="{$snomedName}"/>
				<statusCode code="completed"/>							
				<consumable>
					<manufacturedProduct>
						<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.7.2"/>
						<templateId root="2.16.840.1.113883.3.88.11.83.8.2"/>
						<templateId root="2.16.840.1.113883.10.20.1.53"/>
						<manufacturedMaterial>										
							<code>
								<originalText>
									<reference value="#noMedications-1"/>
								</originalText>
							</code>										
						</manufacturedMaterial>
					</manufacturedProduct>
				</consumable>
			</substanceAdministration>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="substanceAdministration">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="narrativeLinkSuffix"/>

		<substanceAdministration classCode="SBADM">
			<xsl:apply-templates select="." mode="substanceAdministration-moodCode"/>			
			<xsl:call-template name="templateIds-medicationAdministration"/>
			
			<!-- External, Placer, and Filler IDs-->
			<xsl:apply-templates select="." mode="id-External"/>
			<xsl:apply-templates select="." mode="id-Placer"/>
			<xsl:apply-templates select="." mode="id-Filler"/>

			<code nullFlavor="NA"/>
			<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationSignature/text(), $narrativeLinkSuffix)}"/></text>
			<statusCode code="completed"/>
			
			<xsl:apply-templates select="." mode="medication-duration"/>
			<xsl:apply-templates select="Frequency" mode="medication-frequency"/>
			<xsl:apply-templates select="Route" mode="code-route"/>
			<xsl:apply-templates select="." mode="medication-doseQuantity"/>
			<xsl:apply-templates select="." mode="medication-rateAmount"/>
			<xsl:apply-templates select="OrderItem" mode="medication-consumable"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationOrderedName/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
			<xsl:apply-templates select="EnteredAt" mode="informant"/>
			<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			<xsl:apply-templates select="Status" mode="observation-MedicationOrderStatus"/>
			<xsl:apply-templates select="." mode="medication-indication">
				<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
				<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
			</xsl:apply-templates>
			
			<!-- Patient Instructions:  Not yet supported by SDA
			<xsl:apply-templates select="PatientInstruction" mode="medication-textInstructions">
				<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
				<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
			</xsl:apply-templates>
			-->
			
			<!-- Indicate supply both as ordered item and as filled drug product (if available) -->
			<xsl:apply-templates select="OrderItem" mode="medication-supplyOrder"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationOrderedName/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			<xsl:apply-templates select="DrugProduct" mode="medication-supplyFill"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationFilledName/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
			<!-- Link this medication to encounter noted in encounters section -->
			<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-entryRelationship"/>
		</substanceAdministration>
	</xsl:template>
	
	<xsl:template match="*" mode="medication-duration">
		<xsl:apply-templates select="." mode="effectiveTime-IVL_TS"/>
	</xsl:template>

	<xsl:template match="*" mode="medication-frequency">
		<xsl:apply-templates select="." mode="effectiveTime-PIVL_TS"/>
	</xsl:template>

	<xsl:template match="*" mode="medication-doseQuantity">
		<xsl:choose>
			<xsl:when test="string-length(DoseQuantity)">
				<doseQuantity value="{DoseQuantity/text()}">
					<xsl:if test="string-length(DoseUoM/Code)"><xsl:attribute name="unit"><xsl:value-of select="DoseUoM/Code/text()"/></xsl:attribute></xsl:if>
				</doseQuantity>
			</xsl:when>
			<xsl:otherwise><doseQuantity nullFlavor="NI"/></xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template match="*" mode="medication-quantity">
		<xsl:choose>
			<xsl:when test="string-length(DoseQuantity)">
				<quantity value="{DoseQuantity/text()}">
					<xsl:if test="string-length(DoseUoM/Code)"><xsl:attribute name="unit"><xsl:value-of select="DoseUoM/Code/text()"/></xsl:attribute></xsl:if>
				</quantity>
			</xsl:when>
			<xsl:when test="string-length(BaseQty)">
				<quantity value="{BaseQty/text()}">
					<xsl:if test="string-length(BaseUnits/Code)"><xsl:attribute name="unit"><xsl:value-of select="BaseUnits/Code/text()"/></xsl:attribute></xsl:if>
				</quantity>
			</xsl:when>
			<xsl:otherwise><quantity nullFlavor="NI"/></xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template match="*" mode="medication-rateAmount">
		<xsl:choose>
			<xsl:when test="string-length(RateAmount)">
				<rateQuantity value="{RateAmount/text()}">
					<xsl:if test="string-length(RateUnits/Code)"><xsl:attribute name="unit"><xsl:value-of select="RateUnits/Code/text()"/></xsl:attribute></xsl:if>
				</rateQuantity>
			</xsl:when>
			<xsl:otherwise><rateQuantity nullFlavor="NI"/></xsl:otherwise>
		</xsl:choose>			
	</xsl:template>
	
	<xsl:template match="*" mode="medication-consumable">
		<xsl:param name="narrativeLink"/>
		
		<consumable typeCode="CSM">
			<xsl:apply-templates select="." mode="medication-manufacturedProduct"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
		</consumable>		
	</xsl:template>

	<xsl:template match="*" mode="medication-supplyOrder">
		<xsl:param name="narrativeLink"/>
		
		<entryRelationship typeCode="REFR">
			<supply classCode="SPLY" moodCode="INT">
				<xsl:apply-templates select="parent::node()" mode="id-Placer"/>
				
				<repeatNumber nullFlavor="UNK"/>
				
				<xsl:apply-templates select="parent::node()" mode="medication-quantity"/>
				
				<product typeCode="PRD">
					<xsl:apply-templates select="." mode="medication-manufacturedProduct"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>					
				</product>

				<xsl:apply-templates select="parent::node()/OrderedBy" mode="author-Human"/>
			</supply>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="medication-supplyFill">
		<xsl:param name="narrativeLink"/>
		
		<entryRelationship typeCode="REFR">
			<supply classCode="SPLY" moodCode="EVN">
				<xsl:apply-templates select="parent::node()" mode="id-PrescriptionNumber"/>
				
				<repeatNumber nullFlavor="UNK"/>
				
				<xsl:apply-templates select="." mode="medication-quantity"/>
				
				<product typeCode="PRD">
					<xsl:apply-templates select="." mode="medication-manufacturedProduct"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>					
				</product>
			</supply>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="medication-manufacturedProduct">
		<xsl:param name="narrativeLink"/>
		
		<manufacturedProduct classCode="MANU">
			<xsl:call-template name="templateIDs-manufacturedProduct"/>
			
			<xsl:apply-templates select="." mode="medication-manufacturedMaterial"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
		</manufacturedProduct>
	</xsl:template>
	
	<xsl:template match="*" mode="medication-manufacturedMaterial">
		<xsl:param name="narrativeLink"/>
		
		<manufacturedMaterial classCode="MMAT" determinerCode="KIND">
			<!-- This field has some unique requirements.  See HITSP/C83 v2.0 -->
			<!-- sections 2.2.2.8.10 through 2.2.2.8.14.  <translation> is    -->
			<!-- used here differently than <translation> on just about every -->
			<!-- other CDA export coded field.  Plus this field has two code  -->
			<!-- systems that are valid for it, instead of just one.          -->
			<xsl:variable name="sdaCodingStandardOID"><xsl:value-of select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'CodeSystem')"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="$sdaCodingStandardOID='2.16.840.1.113883.6.88' or $sdaCodingStandardOID='2.16.840.1.113883.6.69'">
					<code code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{Description/text()}">
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
					<xsl:when test="string-length(ProductName)"><xsl:value-of select="ProductName/text()"/></xsl:when>
					<xsl:when test="string-length(Description)"><xsl:value-of select="Description/text()"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="'Unknown Medication'"/></xsl:otherwise>
				</xsl:choose>
			</name>
		</manufacturedMaterial>
	</xsl:template>
	
	<xsl:template match="*" mode="medication-patientInstructions">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<act classCode="ACT" moodCode="INT">
				<xsl:call-template name="templateIDs-patientInstructions"/>
				
				<code code="PINSTRUCT" codeSystem="1.3.6.1.4.1.19376.1.5.3.2" codeSystemName="IHEActCode"/>
				<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationInstructions/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="medication-indication">
		<xsl:param name="narrativeLinkCategory"/>
		<xsl:param name="narrativeLinkSuffix"/>

		<!-- Condition being treated -->
		<xsl:if test="string-length(Indication)">
			<entryRelationship typeCode="RSON">
				<observation classCode="OBS" moodCode="EVN">				
					<xsl:call-template name="templateIDs-indication"/>
				
					<id nullFlavor="UNK"/>
		
					<xsl:variable name="sdaCodingStandardOID" select="isc:evaluate('getOIDForCode', Indication/SDACodingStandard/text(), 'CodeSystem')"/>

					<!-- As of 10/14/2011 Indication is still stored in HSDB as String,  -->
					<!-- not as coded item.  The export is now fixed to properly handle  -->
					<!-- String value, and coded value, when that ever gets implemented. -->
					<!-- Since export for this field never previously worked, let's go   -->
					<!-- ahead and force the SNOMED OID and code in there for the String -->
					<!-- value export.                                                   -->
					<xsl:choose>
						<xsl:when test="string-length(Indication/Code)">
							<xsl:choose>
								<xsl:when test="$sdaCodingStandardOID=$snomedOID">
									<code code="{Indication/Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{$snomedName}" displayName="{Indication/Description/text()}"/>
								</xsl:when>
								<xsl:when test="string-length($sdaCodingStandardOID)">
									<code code="{Indication/Code/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Indication/Description/text()}">
										<translation code="{Indication/Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{Indication/SDACodingStandard/text()}" displayName="{Indication/Description/text()}"/>
									</code>
								</xsl:when>
								<xsl:otherwise>
									<code code="{Indication/Code/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Indication/Description/text()}">
										<translation code="{Indication/Code/text()}" codeSystem="{$noCodeSystemOID}" codeSystemName="{$noCodeSystemName}" displayName="{Indication/Description/text()}"/>
									</code>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="string-length(Indication)">
							<code code="{Indication/text()}" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="{Indication/text()}">
							</code>
						</xsl:when>
						<xsl:otherwise>
							<code nullFlavor="UNK"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<text><reference value="{concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/medicationIndication/text(), $narrativeLinkSuffix)}"/></text>
					<statusCode code="completed"/>
					<effectiveTime nullFlavor="UNK"/>
				</observation>
			</entryRelationship>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="observation-MedicationOrderStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-medicationOrderStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail:  Medication Order Status in SDA can be one of D, C, R, H, IP, or E -->
				<xsl:variable name="statusValue" select="isc:evaluate('toUpper', text())"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'H'">421139008</xsl:when>
								<xsl:when test="$statusValue = 'IP'">55561003</xsl:when>
								<xsl:otherwise>73425007</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'H'">On Hold</xsl:when>
								<xsl:when test="$statusValue = 'IP'">Active</xsl:when>
								<xsl:otherwise>No Longer Active</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="snomed-Status"/>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="includeMedicationInExport">
		<xsl:variable name="isCurrentMedication"><xsl:apply-templates select="." mode="currentMedication"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="($includeHistoricalMedications = 1)">1</xsl:when>
			<xsl:when test="($includeHistoricalMedications = 0) and ($isCurrentMedication = 1)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="currentMedication">
		<xsl:variable name="isWithinCurrentMedicationWindow" select="isc:evaluate('dateDiff', 'dd', translate(translate(StartTime/text(), 'Z', ''), 'T', ' ')) &lt;= $currentMedicationWindowInDays"/>
		<xsl:variable name="isInactiveOrCanceled" select="contains('|I|CA|C|', concat('|', Status/text(), '|'))"/>
		<xsl:variable name="isNotEnded" select="not(EndTime)"/>
		
		<xsl:choose>
			<xsl:when test="$isWithinCurrentMedicationWindow and not($isInactiveOrCanceled)">1</xsl:when>
			<xsl:when test="(not($isWithinCurrentMedicationWindow) and $isNotEnded) and not($isInactiveOrCanceled)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="substanceAdministration-moodCode">
		<!-- According to CCD specification, moodCode for a substanceAdministration must be either EVN (Event) or INT (Intended, default) -->
		<xsl:attribute name="moodCode">
			<xsl:choose>
				<xsl:when test="string-length(DrugProduct)">EVN</xsl:when>
				<xsl:when test="contains($medicationExecutedStatusCodes, concat('|', Status/text(), '|'))">EVN</xsl:when>
				<xsl:when test="contains($medicationIntendedStatusCodes, concat('|', Status/text(), '|'))">INT</xsl:when>
				<xsl:otherwise>INT</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="templateIds-medicationAdministration">
		<xsl:if test="string-length($hitsp-CDA-Medication)"><templateId root="{$hitsp-CDA-Medication}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-MedicationActivity)"><templateId root="{$hl7-CCD-MedicationActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-MedicationsEntry)"><templateId root="{$ihe-PCC-MedicationsEntry}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SubstanceEntry)"><templateId root="{$ihe-PCC-SubstanceEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-manufacturedProduct">
		<xsl:if test="string-length($hitsp-CDA-MedicationInformation)"><templateId root="{$hitsp-CDA-MedicationInformation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-Product)"><templateId root="{$hl7-CCD-Product}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ProductEntry)"><templateId root="{$ihe-PCC-ProductEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-patientInstructions">
		<xsl:if test="string-length($hl7-CCD-PatientInstruction)"><templateId root="{$hl7-CCD-PatientInstruction}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-PatientMedicationInstructions)"><templateId root="{$ihe-PCC-PatientMedicationInstructions}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIDs-indication">
		<xsl:if test="string-length($hl7-CCD-ProblemObservation)"><templateId root="{$hl7-CCD-ProblemObservation}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-medicationOrderStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-MedicationStatusObservation)"><templateId root="{$hl7-CCD-MedicationStatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
