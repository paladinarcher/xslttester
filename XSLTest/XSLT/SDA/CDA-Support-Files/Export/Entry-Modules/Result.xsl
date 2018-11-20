<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="diagnosticResults-Narrative">
		<xsl:param name="orderType"/>
		
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Test Description</th>
						<th>Test Time</th>
						<th>Test Comments</th>
						<th>Text Results</th>
						<th>Atomic Results</th>
						<th>Result Comments</th>
					</tr>
				</thead>
				<tbody>
					<!-- With HITSP C37, we only export LAB results (not RAD or OTH) -->
					<xsl:choose>
						<xsl:when test="string-length($orderType)"><xsl:apply-templates select="Encounter/Results/LabResult[(InitiatingOrder/OrderItem/OrderType/text() = $orderType) and (string-length(ResultText/text()) or string-length(ResultItems))] | Encounter/Results/Result[(InitiatingOrder/OrderItem/OrderType/text() = $orderType) and (string-length(ResultText/text()) or string-length(ResultItems))]" mode="diagnosticResults-NarrativeDetail"/></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="Encounter/Results/LabResult | Encounter/Results/Result" mode="diagnosticResults-NarrativeDetail"/></xsl:otherwise>
					</xsl:choose>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResults-NarrativeDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<tr ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultNarrative/text(), $narrativeLinkSuffix)}">
			<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)}"><xsl:value-of select="InitiatingOrder/OrderItem/Description/text()"/></td>
			<td><xsl:value-of select="translate(translate(ResultTime/text(), 'T', ' '), 'Z', '')"/></td>
			<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultTestComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="InitiatingOrder/Comments/text()"/></td>
			<!-- Used at RSNA to deal with HTML content: <td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="ResultText" mode="copy"/></td> -->
			<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ResultText/text()"/></td>
			<xsl:if test="string-length(ResultItems)">
				<td>
					<list><item>
						<table border="1" width="100%">
							<thead>
								<tr>
									<th>Test Item</th>
									<th>Value</th>
									<th>Reference Range</th>
									<th>Comments</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="ResultItems/LabResultItem">
									<tr>
										<td><xsl:value-of select="concat(TestItemCode/Description/text(), ' (test code = ', TestItemCode/Code/text(), ')')"/></td>
										<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultValue/text(), $narrativeLinkSuffix, '-', position())}"><xsl:value-of select="concat(ResultValue/text(), ' ', ResultValueUnits/text())"/></td>
										<td><xsl:value-of select="concat(ResultNormalRange/text(), ' (units = ', ResultValueUnits/text(), ')')"/></td>
										<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultValueComments/text(), $narrativeLinkSuffix, '-', position())}"><xsl:value-of select="Comments/text()"/></td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</item></list>
				</td>
			</xsl:if>
			<td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="*" mode="diagnosticResultsC32-Entries">
		<xsl:apply-templates select="Encounter/Results/LabResult[string-length(ResultText/text()) or string-length(ResultItems)] | Encounter/Results/Result[string-length(ResultText/text()) or string-length(ResultItems)]" mode="diagnosticResultsC32-EntryDetail"/>
	</xsl:template>

	<xsl:template match="*" mode="diagnosticResultsC37-Entries">
		<xsl:param name="orderType"/>

		<!-- With HITSP C37, we only export LAB results (not RAD or OTH) -->
		<xsl:apply-templates select="Encounter/Results/LabResult[(InitiatingOrder/OrderItem/OrderType/text() = $orderType) and (string-length(ResultText/text()) or string-length(ResultItems))] | Encounter/Results/Result[(InitiatingOrder/OrderItem/OrderType/text() = $orderType) and (string-length(ResultText/text()) or string-length(ResultItems))]" mode="diagnosticResultsC37-EntryDetail"/>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResults-NoData">
		<text><xsl:value-of select="$exportConfiguration/results/emptySection/narrativeText/text()"/></text>
		<entry>
			<procedure classCode="PROC" moodCode="EVN">
				<templateId root="2.16.840.1.113883.10.20.1.29"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.19"/>
				<templateId root="2.16.840.1.113883.3.88.11.83.17"/>
				
				<id nullFlavor="NI"/>
				<code nullFlavor="NI"><originalText><reference value="#noProcedures-1"/></originalText></code>
				<text><reference nullFlavor="NI"/></text>
				<statusCode code="completed"/>
			</procedure>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<templateId root="2.16.840.1.113883.3.88.11.83.15.1"/>
				<templateId root="2.16.840.1.113883.10.20.1.31"/>
				<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
				
				<id nullFlavor="NI"/>
				<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
				<text><reference value="#noResults-1"/></text>
				<statusCode code="completed"/>
				<effectiveTime nullFlavor="NI"/>
				<value xsi:type="ST">This patient has no known results.</value>
			</observation>
		</entry>		
	</xsl:template>

	<xsl:template match="*" mode="diagnosticResultsC32-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry>
			<!-- Result Battery -->
			<xsl:apply-templates select="." mode="battery-ResultsC32"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="diagnosticResultsC37-EntryDetail">
		<xsl:variable name="narrativeLinkSuffix">
			<xsl:apply-templates select="parent::node()/parent::node()" mode="narrativeLink-EncounterSuffix">
				<xsl:with-param name="entryNumber" select="position()"/>
			</xsl:apply-templates>
		</xsl:variable>		
		
		<entry typeCode="DRIV">
			<xsl:call-template name="templateIds-ResultsC37Entry"/>

			<act classCode="ACT" moodCode="EVN">
				<xsl:apply-templates select="InitiatingOrder" mode="results-InitiatingOrder"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
				
				<!-- Result Battery -->
				<entryRelationship typeCode="COMP">
					<xsl:apply-templates select="." mode="battery-ResultsC37"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>					
				</entryRelationship>
			</act>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="battery-ResultsC32">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<organizer classCode="BATTERY" moodCode="EVN">
			<xsl:call-template name="templateIds-ResultsOrganizer"/>
			
			<xsl:apply-templates select="InitiatingOrder" mode="id-Filler"/>
			<xsl:apply-templates select="InitiatingOrder/OrderItem" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
			<statusCode code="completed"/>
			
			<xsl:apply-templates select="." mode="effectiveTime-Result"/>
			<xsl:apply-templates select="PerformedAt" mode="performer-PerformedAt"/>
			<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
			<xsl:apply-templates select="EnteredAt" mode="informant"/>
			
			<xsl:apply-templates select="InitiatingOrder" mode="procedure-ResultsC32"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			<xsl:apply-templates select="ResultText" mode="results-Text"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			<xsl:apply-templates select="ResultItems/LabResultItem[string-length(ResultValue/text())>0]" mode="results-Atomic"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			<xsl:apply-templates select="Comments" mode="comment-component"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
			<!-- Link this battery to encounter noted in encounters section -->
			<xsl:apply-templates select="parent::node()/parent::node()" mode="encounterLink-component"/>
		</organizer>
	</xsl:template>

	<xsl:template match="*" mode="battery-ResultsC37">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<organizer classCode="BATTERY" moodCode="EVN">
			<xsl:call-template name="templateIds-ResultsOrganizer"/>
			
			<xsl:apply-templates select="InitiatingOrder" mode="id-Filler"/>
			<xsl:apply-templates select="InitiatingOrder/OrderItem" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			
			<statusCode code="completed"/>
			
			<xsl:apply-templates select="." mode="effectiveTime-Result"/>
			<xsl:apply-templates select="PerformedAt" mode="performer-PerformedAt"/>
			<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
			<xsl:apply-templates select="EnteredAt" mode="informant-noPatientIdentifier"/>				
			
			<xsl:apply-templates select="ResultStatus" mode="observation-ResultStatus"/>
			<xsl:apply-templates select="ResultText" mode="results-Text"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			<xsl:apply-templates select="ResultItems/LabResultItem[string-length(ResultValue/text())>0]" mode="results-Atomic"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			<xsl:apply-templates select="Comments" mode="comment-component"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
		</organizer>
	</xsl:template>

	<xsl:template match="*" mode="procedure-ResultsC32">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component>
			<procedure classCode="PROC" moodCode="EVN">
				<!-- This might be the same as a regular procedure:  consider merging two templates into one -->
				<xsl:call-template name="templateIds-ResultsC32Procedure"/>
				
				<xsl:apply-templates select="." mode="results-InitiatingOrder"><xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/></xsl:apply-templates>
			</procedure>
		</component>
	</xsl:template>

	<xsl:template match="InitiatingOrder" mode="results-InitiatingOrder">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:apply-templates select="." mode="id-Placer"/>
		<xsl:apply-templates select="OrderItem" mode="generic-Coded"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
		
		<text><reference value="{concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultNarrative/text(), $narrativeLinkSuffix)}"/></text>
		<statusCode code="completed"/>
		
		<xsl:apply-templates select="EnteredOn" mode="effectiveTime"/>
		<xsl:apply-templates select="Specimen" mode="specimen"/>
		<xsl:apply-templates select="OrderedBy" mode="performer"/>
		<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
		<xsl:apply-templates select="EnteredAt" mode="informant-noPatientIdentifier"/>
		<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultTestComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-Result">
		<xsl:choose>
			<xsl:when test="string-length(ResultTime)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="ResultTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="specimen">
		<specimen typeCode="SPC">
			<specimenRole classCode="SPEC">
				<id nullFlavor="UNK"/>
				<specimenPlayingEntity>
					<!-- Specimen Detail -->
					<xsl:variable name="specimenInformation">
						<Specimen xmlns="">
							<SDACodingStandard>2.16.840.1.113883.5.129</SDACodingStandard>
							<Code><xsl:value-of select="substring-before(text(), '&amp;')"/></Code>
							<Description><xsl:value-of select="substring-after(text(), '&amp;')"/></Description>
						</Specimen>
					</xsl:variable>
					<xsl:variable name="specimen" select="exsl:node-set($specimenInformation)/Specimen"/>
					
					<xsl:apply-templates select="$specimen" mode="code"/>
				</specimenPlayingEntity>
			</specimenRole>
		</specimen>
	</xsl:template>

	<xsl:template match="*" mode="results-Text">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:if test="(parent::node()/InitiatingOrder/OrderItem/OrderType/text() = 'LAB') and string-length($ihe-PCC-LaboratoryObservation)"><templateId root="{$ihe-PCC-LaboratoryObservation}"/></xsl:if>
				<xsl:call-template name="templateIds-ResultsC32TextReport"/>
				
				<xsl:apply-templates select="." mode="id-External"/>
				<code code="18684-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Result Observation"/>
				<text><reference value="{concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				<xsl:apply-templates select="parent::node()" mode="effectiveTime-Result"/>
				<value nullFlavor="NA" xsi:type="CD"/>
			</observation>
		</component>
	</xsl:template>

	<xsl:template match="*" mode="results-Atomic">
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component typeCode="COMP">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-ResultsAtomicValues"></xsl:call-template>
				
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="TestItemCode" mode="generic-Coded">
					<xsl:with-param name="isCodeRequired" select="true()"/>
				</xsl:apply-templates>
				<text><reference value="{concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix, '-', position())}"/></text>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="parent::node()/parent::node()" mode="effectiveTime-Result"/>
				
				<xsl:choose>
					<xsl:when test="TestItemCode/IsNumeric/text() = 'true'"><xsl:apply-templates select="ResultValue" mode="value-PQ"><xsl:with-param name="units" select="translate(ResultValueUnits, ' ', '_')"/></xsl:apply-templates></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="ResultValue" mode="value-ST"/></xsl:otherwise>
				</xsl:choose>
				
				<xsl:apply-templates select="ResultInterpretation" mode="results-Interpretation"/>
				<xsl:apply-templates select="PerformedAt" mode="performer-PerformedAt"/>
				<xsl:apply-templates select="TestItemStatus" mode="observation-TestItemStatus"/>
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/results/narrativeLinkPrefixes/resultValueComments/text(), $narrativeLinkSuffix, '-', position())"/></xsl:apply-templates>
				<xsl:apply-templates select="ResultNormalRange" mode="results-ReferenceRange"/>
			</observation>
		</component>
	</xsl:template>
	
	<xsl:template match="*" mode="results-Interpretation">
		<xsl:variable name="interpretationInformation">
			<Interpretation xmlns="">
				<SDACodingStandard>2.16.840.1.113883.5.83</SDACodingStandard>
				<Code>
					<xsl:choose>
						<xsl:when test="text() = 'A'">A</xsl:when>
						<xsl:when test="text() = 'AA'">A</xsl:when>
						<xsl:when test="text() = 'H'">H</xsl:when>
						<xsl:when test="text() = 'HH'">H</xsl:when>
						<xsl:when test="text() = 'L'">L</xsl:when>
						<xsl:when test="text() = 'LL'">L</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</Code>
				<Description>
					<xsl:choose>
						<xsl:when test="text() = 'A'">Abnormal</xsl:when>
						<xsl:when test="text() = 'AA'">Abnormal</xsl:when>
						<xsl:when test="text() = 'H'">High</xsl:when>
						<xsl:when test="text() = 'HH'">High</xsl:when>
						<xsl:when test="text() = 'L'">Low</xsl:when>
						<xsl:when test="text() = 'LL'">Low</xsl:when>
						<xsl:otherwise>Normal</xsl:otherwise>
					</xsl:choose>
				</Description>
			</Interpretation>
		</xsl:variable>
		<xsl:variable name="interpretation" select="exsl:node-set($interpretationInformation)/Interpretation"/>
		
		<xsl:apply-templates select="$interpretation" mode="code-interpretation"/>
	</xsl:template>

	<xsl:template match="*" mode="observation-ResultStatus">
		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-resultStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="isc:evaluate('toUpper', text())"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard>2.16.840.1.113883.5.14</SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'C'">corrected</xsl:when>
								<xsl:when test="$statusValue = 'F'">completed</xsl:when>
								<xsl:when test="$statusValue = 'R'">active</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="contains('C|COR', $statusValue)">corrected</xsl:when>
								<xsl:when test="contains('F|FIN', $statusValue)">completed</xsl:when>
								<xsl:when test="contains('R|ENT', $statusValue)">active</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="value-CE"/>
			</observation>
		</component>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-TestItemStatus">
		<entryRelationship typeCode="REFR" inversionInd="false">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:call-template name="templateIds-resultStatusObservation"/>
				
				<code code="33999-4" displayName="Status" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="isc:evaluate('toUpper', text())"/>
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<SDACodingStandard><xsl:value-of select="$snomedName"/></SDACodingStandard>
						<Code>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">partial</xsl:when>
								<xsl:when test="$statusValue = 'C'">corrected</xsl:when>
								<xsl:when test="$statusValue = 'F'">final</xsl:when>
								<xsl:when test="$statusValue = 'K'">corrected</xsl:when>
								<xsl:when test="$statusValue = 'P'">preliminary</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValue = 'A'">partial</xsl:when>
								<xsl:when test="$statusValue = 'C'">corrected</xsl:when>
								<xsl:when test="$statusValue = 'F'">final</xsl:when>
								<xsl:when test="$statusValue = 'K'">corrected</xsl:when>
								<xsl:when test="$statusValue = 'P'">preliminary</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="value-CE"/>
			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="results-ReferenceRange">
		<referenceRange typeCode="REFV">
			<observationRange classCode="OBS" moodCode="EVN.CRT">
				<xsl:variable name="textToUse"><xsl:value-of select="translate(text(), '()', '')"/></xsl:variable>
				<xsl:variable name="ltgtNumeric">
					<xsl:choose>
						<xsl:when test="contains($textToUse, '-') or contains($textToUse, ':') or contains($textToUse, '/')">0</xsl:when>
						<xsl:when test="starts-with($textToUse,'>=') and number(substring-after($textToUse,'>='))">1</xsl:when>
						<xsl:when test="starts-with($textToUse,'=>') and number(substring-after($textToUse,'=>'))">2</xsl:when>
						<xsl:when test="starts-with($textToUse,'&lt;=') and number(substring-after($textToUse,'&lt;='))">3</xsl:when>
						<xsl:when test="starts-with($textToUse,'=&lt;') and number(substring-after($textToUse,'=&lt;'))">4</xsl:when>
						<xsl:when test="not(number($textToUse))">5</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="parent::node()/TestItemCode/IsNumeric/text() = 'true' and $ltgtNumeric&lt;5">
						<xsl:apply-templates select="." mode="value-IVL_PQ">
							<xsl:with-param name="referenceRangeLowValue">
								<xsl:choose>
									<xsl:when test="contains($textToUse, '-')"><xsl:value-of select="normalize-space(substring-before($textToUse, '-'))"/></xsl:when>
									<xsl:when test="contains($textToUse, ':')"><xsl:value-of select="normalize-space(substring-before($textToUse, ':'))"/></xsl:when>
									<xsl:when test="contains($textToUse, '/')"><xsl:value-of select="normalize-space(substring-before($textToUse, '/'))"/></xsl:when>
									<xsl:when test="$ltgtNumeric='1'"><xsl:value-of select="normalize-space(substring-after($textToUse,'>='))"/></xsl:when>
									<xsl:when test="$ltgtNumeric='2'"><xsl:value-of select="normalize-space(substring-after($textToUse,'=>'))"/></xsl:when>
									<xsl:when test="$ltgtNumeric='3'"></xsl:when>
									<xsl:when test="$ltgtNumeric='4'"></xsl:when>
									<xsl:otherwise><xsl:value-of select="normalize-space($textToUse)"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="referenceRangeHighValue">
								<xsl:choose>
									<xsl:when test="contains($textToUse, '-')"><xsl:value-of select="normalize-space(substring-after($textToUse, '-'))"/></xsl:when>
									<xsl:when test="contains($textToUse, ':')"><xsl:value-of select="normalize-space(substring-after($textToUse, ':'))"/></xsl:when>
									<xsl:when test="contains($textToUse, '/')"><xsl:value-of select="normalize-space(substring-after($textToUse, '/'))"/></xsl:when>
									<xsl:when test="$ltgtNumeric='1'"></xsl:when>
									<xsl:when test="$ltgtNumeric='2'"></xsl:when>
									<xsl:when test="$ltgtNumeric='3'"><xsl:value-of select="normalize-space(substring-after($textToUse,'&lt;='))"/></xsl:when>
									<xsl:when test="$ltgtNumeric='4'"><xsl:value-of select="normalize-space(substring-after($textToUse,'=&lt;'))"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="normalize-space($textToUse)"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="referenceRangeUnits" select="translate(parent::node()/ResultValueUnits/text(),' ','_')"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<text><xsl:value-of select="$textToUse"/></text>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--  The following line could never have done anything, because the source data  -->
				<!--  for this template (ResultNormalRange) in SDA is a string and it has no      -->
				<!--  ResultInterpretation property.  Also, there is some ambiguity regarding the -->
				<!--  meaning of this field and if it really required here.  Retaining this line  -->
				<!--  here but commented, to note that we had tried to implement it in the past.  -->
				<!--  <xsl:apply-templates select="ResultInterpretation" mode="results-Interpretation"/>  -->
			</observationRange>
		</referenceRange>
	</xsl:template>
	
	<xsl:template match="*" mode="performer-PerformedAt">
		<performer typeCode="PRF">
			<xsl:apply-templates select="parent::node()" mode="time"/>
			<xsl:apply-templates select="." mode="assignedEntity"/>
		</performer>
	</xsl:template>
	
	<xsl:template name="templateIds-ResultsOrganizer">
		<xsl:if test="string-length($hl7-CCD-ResultOrganizer)"><templateId root="{$hl7-CCD-ResultOrganizer}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-ResultsC32Procedure">
		<xsl:if test="string-length($hitsp-CDA-Procedure)"><templateId root="{$hitsp-CDA-Procedure}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProcedureActivity)"><templateId root="{$hl7-CCD-ProcedureActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-ProcedureEntry)"><templateId root="{$ihe-PCC_CDASupplement-ProcedureEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-ResultsC32TextReport">
		<xsl:if test="string-length($hitsp-CDA-Results)"><templateId root="{$hitsp-CDA-Results}"/></xsl:if>
		<xsl:if test="string-length($hitsp-CDA-Results-C83v2)"><templateId root="{$hitsp-CDA-Results-C83v2}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ResultObservation)"><templateId root="{$hl7-CCD-ResultObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>		
	</xsl:template>

	<xsl:template name="templateIds-ResultsAtomicValues">
		<xsl:if test="string-length($hitsp-CDA-Results)"><templateId root="{$hitsp-CDA-Results}"/></xsl:if>
		<xsl:if test="string-length($hitsp-CDA-Results-C83v2)"><templateId root="{$hitsp-CDA-Results-C83v2}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ResultObservation)"><templateId root="{$hl7-CCD-ResultObservation}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-SimpleObservations)"><templateId root="{$ihe-PCC-SimpleObservations}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-LaboratoryObservation)"><templateId root="{$ihe-PCC-LaboratoryObservation}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-ResultsC37Entry">
		<xsl:if test="string-length($hitsp-CDA-Results)"><templateId root="{$hitsp-CDA-Results}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-LaboratoryReportEntry)"><templateId root="{$ihe-PCC-LaboratoryReportEntry}" extension="Lab.Report.Data.Processing.Entry"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-resultStatusObservation">
		<xsl:if test="string-length($hl7-CCD-StatusObservation)"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
