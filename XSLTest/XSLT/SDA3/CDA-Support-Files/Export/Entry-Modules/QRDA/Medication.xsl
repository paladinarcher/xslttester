<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="Medication" mode="medicationAdministered-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationAdministered-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Medication Administered: <xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="Medication" mode="medicationAdministered-Qualifies">1</xsl:template>
		
	<xsl:template match="Medication" mode="medicationActive-Narrative">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationActive-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<tr>
				<td>Medication Active: <xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:value-of select="OrderItem/Description/text()"/></td>
				<td><xsl:apply-templates select="FromTime" mode="narrativeDateFromODBC"/></td>
			</tr>
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="Medication" mode="medicationActive-Qualifies">1</xsl:template>
		
	<xsl:template match="Medication" mode="medicationAdministered-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationAdministered-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Medication Administered </xsl:comment>
			<entry typeCode="DRIV">
				<act classCode="ACT" moodCode="EVN">
					<templateId root="{$qrda-MedicationAdministered}"/>
					<id nullFlavor="UNK"/>
					<code code="416118004" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Administration"/>
					<statusCode code="completed"/>
					<xsl:apply-templates select="." mode="effectiveTime-FromTo"/>
					<entryRelationship typeCode="COMP">
						<xsl:apply-templates select="." mode="medicationAdministered-substanceAdministration"/>
					</entryRelationship>
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
					<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
				</act>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medicationActive-Entry">
		<xsl:variable name="qualifies"><xsl:apply-templates select="." mode="medicationActive-Qualifies"/></xsl:variable>
		<xsl:if test="$qualifies='1'">
			<xsl:comment> QRDA Medication Active </xsl:comment>
			<entry typeCode="DRIV">
				<xsl:apply-templates select="." mode="medicationActive-substanceAdministration"/>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medicationAdministered-substanceAdministration">
		<substanceAdministration classCode="SBADM">
			<xsl:apply-templates select="." mode="substanceAdministration-moodCode"/>
			<templateId root="{$ccda-MedicationActivity}"/>
			<templateId root="{$qrda-MedicationAdministered}"/>
			
			<xsl:apply-templates select="." mode="id-Medication"/>
			
			<code nullFlavor="NA"/>
			<text>Medication Administered: <xsl:value-of select="OrderItem/Description/text()"/></text>
			<statusCode code="completed"/>
			
			<xsl:apply-templates select="." mode="medication-duration"/>
			<xsl:apply-templates select="Frequency" mode="medication-frequency"/>
			<xsl:apply-templates select="Route" mode="code-route"/>
			<xsl:apply-templates select="." mode="medication-doseQuantity"/>
			<xsl:apply-templates select="." mode="medication-rateAmount"/>
			<xsl:apply-templates select="OrderItem" mode="medication-consumable"/>
			
			<xsl:apply-templates select="Status" mode="observation-MedicationOrderStatus"/>
			<xsl:apply-templates select="." mode="medication-indication"/>
			
			<!-- Indicate supply both as ordered item and as filled drug product (if available) -->
			<xsl:apply-templates select="OrderItem" mode="medication-supplyOrder"/>
			<xsl:apply-templates select="DrugProduct" mode="medication-supplyFill"/>
			
			<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		</substanceAdministration>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medicationActive-substanceAdministration">
		<substanceAdministration classCode="SBADM">
			<xsl:apply-templates select="." mode="substanceAdministration-moodCode"/>
			<templateId root="{$ccda-MedicationActivity}"/>
			<templateId root="{$qrda-MedicationActive}"/>
			
			<xsl:apply-templates select="." mode="id-Medication"/>
			
			<code nullFlavor="NA"/>
			<text>Medication Active: <xsl:value-of select="OrderItem/Description/text()"/></text>
			<statusCode code="active"/>
			
			<xsl:apply-templates select="." mode="medication-duration"/>
			<xsl:apply-templates select="Frequency" mode="medication-frequency"/>
			<xsl:apply-templates select="Route" mode="code-route"/>
			<xsl:apply-templates select="." mode="medication-doseQuantity"/>
			<xsl:apply-templates select="." mode="medication-rateAmount"/>
			<xsl:apply-templates select="OrderItem" mode="medication-consumable"/>
			
			<xsl:apply-templates select="Status" mode="observation-MedicationOrderStatus"/>
			<xsl:apply-templates select="." mode="medication-indication"/>
			
			<!-- Indicate supply both as ordered item and as filled drug product (if available) -->
			<xsl:apply-templates select="OrderItem" mode="medication-supplyOrder"/>
			<xsl:apply-templates select="DrugProduct" mode="medication-supplyFill"/>
			
			<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
			<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
			
			<xsl:apply-templates select="." mode="encounterLink-entryRelationship"/>
		</substanceAdministration>
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
	
	<xsl:template match="Medication" mode="medication-duration">
		<xsl:apply-templates select="." mode="effectiveTime-IVL_TS"/>
	</xsl:template>
	
	<xsl:template match="Frequency" mode="medication-frequency">
		<xsl:apply-templates select="." mode="effectiveTime-PIVL_TS"/>
	</xsl:template>

	<xsl:template match="Medication" mode="medication-doseQuantity">
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
			<xsl:when test="string-length(BaseQty)">
				<quantity value="{BaseQty/text()}">
					<xsl:if test="string-length(BaseUnits)">
						<xsl:attribute name="unit"><xsl:value-of select="BaseUnits/Description/text()"/></xsl:attribute>
					</xsl:if>
				</quantity>
			</xsl:when>
			<!-- IHE Supply Entry wants the quantity information or nothing at all (no nullFlavor) -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medication-fills">
		<xsl:choose>
			<xsl:when test="number(NumberOfRefills/text()) or NumberOfRefills/text()='0'">
				<repeatNumber value="{number(NumberOfRefills/text()+1)}"/>
			</xsl:when>
			<xsl:otherwise><repeatNumber nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Medication" mode="medication-rateAmount">
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
		<consumable typeCode="CSM">
			<xsl:apply-templates select="." mode="medication-manufacturedProduct"/>
		</consumable>
	</xsl:template>

	<xsl:template match="*" mode="medication-supplyOrder">
		<entryRelationship typeCode="REFR">
			<supply classCode="SPLY" moodCode="INT">
				<templateId root="{$ccda-MedicationSupplyOrder}"/>
				
				<xsl:apply-templates select="parent::node()" mode="id-Placer"/>
				
				<statusCode code="completed"/>
				
				<!-- QRDA wants an effectiveTime with low and high here. -->
				<effectiveTime xsi:type="IVL_TS">
					<low nullFlavor="UNK"/>
					<high nullFlavor="UNK"/>
				</effectiveTime>
				
				<xsl:apply-templates select="parent::node()" mode="medication-fills"/>
				
				<xsl:apply-templates select="parent::node()" mode="medication-quantity"/>
				
				<product typeCode="PRD">
					<xsl:apply-templates select="." mode="medication-manufacturedProduct"/>
				</product>
			</supply>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="medication-supplyFill">
		<entryRelationship typeCode="REFR">
			<supply classCode="SPLY" moodCode="EVN">
				<templateId root="{$ccda-MedicationDispense}"/>
				<templateId root="{$qrda-MedicationDispensed}"/>
				
				<xsl:apply-templates select="parent::node()" mode="id-PrescriptionNumber"/>
				
				<statusCode code="completed"/>
				
				<!-- QRDA wants an effectiveTime with low and high here. -->
				<effectiveTime xsi:type="IVL_TS">
					<low nullFlavor="UNK"/>
					<high nullFlavor="UNK"/>
				</effectiveTime>
				
				<xsl:apply-templates select="parent::node()" mode="medication-fills"/>
				
				<xsl:apply-templates select="." mode="medication-quantity"/>
				
				<product typeCode="PRD">
					<xsl:apply-templates select="." mode="medication-manufacturedProduct"/>
				</product>
				
				<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='PatientPreferenceCode']]" mode="patientPreference"/>
				
				<xsl:apply-templates select="self::node()[CustomPairs/NVPair[Name='ProviderPreferenceCode']]" mode="providerPreference"/>
			</supply>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="medication-manufacturedProduct">
		<manufacturedProduct classCode="MANU">
			<templateId root="{$ccda-MedicationInformation}"/>
			
			<xsl:apply-templates select="." mode="medication-manufacturedMaterial"/>
		</manufacturedProduct>
	</xsl:template>
	
	<xsl:template match="*" mode="medication-manufacturedMaterial">
		<manufacturedMaterial classCode="MMAT" determinerCode="KIND">
			<!-- This field has some unique requirements.  See HITSP/C83 v2.0 -->
			<!-- sections 2.2.2.8.10 through 2.2.2.8.14.  <translation> is    -->
			<!-- used here differently than <translation> on just about every -->
			<!-- other CDA export coded field.  Plus this field has two code  -->
			<!-- systems that are valid for it, instead of just one.          -->
			<xsl:variable name="sdaCodingStandardOID"><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="SDACodingStandard/text()"/></xsl:apply-templates></xsl:variable>
			<xsl:variable name="description"><xsl:value-of select="Description/text()"/></xsl:variable>
			<xsl:variable name="valueSetOID">
				<xsl:value-of select="substring-before(isc:evaluate('getValueSetOIDs',Code/text(),$sdaCodingStandardOID,$setIds),'|')"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$sdaCodingStandardOID=$rxNormOID or $sdaCodingStandardOID=$ndcOID">
					<code code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{$description}">
						<xsl:if test="string-length($valueSetOID)"><xsl:attribute name="sdtc:valueSet"><xsl:value-of select="$valueSetOID"/></xsl:attribute></xsl:if>
						<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
						<translation code="{Code/text()}" codeSystem="{$sdaCodingStandardOID}" codeSystemName="{SDACodingStandard/text()}" displayName="{$description}"/>
					</code>
				</xsl:when>
				<xsl:otherwise>
					<code nullFlavor="UNK">
						<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
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
		
	<xsl:template match="Medication" mode="medication-indication">
		<!-- Condition being treated -->
		<xsl:if test="string-length(Indication)">
			<entryRelationship typeCode="RSON">
				<observation classCode="OBS" moodCode="EVN">
					<templateId root="{$ccda-Indication}"/>
					
					<id nullFlavor="{$idNullFlavor}"/>
					
					<!-- SDA does not have an Indication Type property.  "Problem" is hard-coded and adequate. -->
					<code code="55607006" displayName="Problem" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}"/>
					
					<statusCode code="completed"/>
					<effectiveTime nullFlavor="UNK"/>
					
					<!--
						In SDA, Indication is a %String property.
												
						C-CDA allows the use of nullFlavor when the Indication
						is not known to be a SNOMED code.  Because Indication
						is %String, this template exports nullFlavor plus a
						a translation element that uses $noCodeSystemOID as
						the codeSystem.
					-->
					<xsl:variable name="indicationInformation">
						<Indication xmlns="">
							<Code><xsl:value-of select="translate(Indication/text(),' ','_')"/></Code>
							<Description><xsl:value-of select="Indication/text()"/></Description>
						</Indication>
					</xsl:variable>
					
					<xsl:variable name="indication" select="exsl:node-set($indicationInformation)/Indication"/>
					
					<xsl:apply-templates select="$indication" mode="value-Coded">
						<xsl:with-param name="xsiType" select="'CD'"/>
						<xsl:with-param name="requiredCodeSystemOID" select="$snomedOID"/>
					</xsl:apply-templates>
				</observation>
			</entryRelationship>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="observation-MedicationOrderStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="{$hl7-CCD-StatusObservation}"/>
				<templateId root="{$hl7-CCD-MedicationStatusObservation}"/>
				
				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
				<statusCode code="completed"/>
				
				<!-- Status Detail:  Medication Order Status in SDA can be one of D, C, R, H, IP, or E -->
				<xsl:variable name="statusValue" select="translate(text(), $lowerCase, $upperCase)"/>
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
								<xsl:otherwise>Inactive</xsl:otherwise>
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
		<xsl:variable name="isWithinCurrentMedicationWindow" select="isc:evaluate('dateDiff', 'dd', translate(translate(FromTime/text(), 'Z', ''), 'T', ' ')) &lt;= $currentMedicationWindowInDays"/>
		<xsl:variable name="isInactiveOrCanceled" select="contains('|I|CA|C|', concat('|', Status/text(), '|'))"/>
		<xsl:variable name="isNotEnded" select="not(ToTime)"/>
		
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
</xsl:stylesheet>
