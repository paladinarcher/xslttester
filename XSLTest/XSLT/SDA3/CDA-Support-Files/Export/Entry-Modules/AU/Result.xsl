<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<!--
		This AU version of Result.xsl uses several templates that
		are in the "base" Result.xsl.  Pointer comments for these
		templates are located within the code here.
	-->
	<xsl:template match="*" mode="diagnosticResults-Narrative">
		<xsl:param name="orderType"/>
		
		<text>
			<xsl:choose>
				<xsl:when test="$orderType = 'LAB'">
					<xsl:apply-templates select="LabOrders/LabOrder/Result[string-length(ResultText/text()) or string-length(ResultItems)]" mode="diagnosticResults-NarrativeDetail-LabResults">
						<xsl:sort select="ResultTime" order="descending"/>
						<xsl:with-param name="narrativeLinkCategory">results</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$orderType = 'RAD'">
					<table border="1" width="100%">
						<caption>Imaging Examination Result(s)</caption>
						<thead>
							<tr>
								<th>Test Description</th>
								<th>Test Time</th>
								<th>Test Comments</th>
								<th>Text Results</th>
								<th>Result Comments</th>
							</tr>
						</thead>
						<xsl:apply-templates select="RadOrders/RadOrder/Result[string-length(ResultText/text()) or string-length(ResultItems)]" mode="diagnosticResults-ImagingResults-NarrativeDetail">
							<xsl:sort select="ResultTime" order="descending"/>
							<xsl:with-param name="narrativeLinkCategory">imagingExaminationResults</xsl:with-param>
						</xsl:apply-templates>
					</table>
				</xsl:when>
			</xsl:choose>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResults-NarrativeDetail-LabResults">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<table border="1" width="100%">
		
			<xsl:choose>
				<xsl:when test="position()=1">
					<caption>Pathology Test Result(s)</caption>
				</xsl:when>
				<xsl:otherwise>
					<caption>  </caption>
				</xsl:otherwise>
			</xsl:choose>
			
			<thead>
				<tr>
					<th>Test Description</th>
					<th>Test Time</th>
					<th>Test Comments</th>
					<th>Text Results</th>
					<th>Result Comments</th>
				</tr>
			</thead>
			
			<tbody>
				<tr ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultNarrative/text(), $narrativeLinkSuffix)}">
					<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="../OrderItem" mode="originalTextOrDescriptionOrCode"/></td>
					<td><xsl:apply-templates select="ResultTime" mode="narrativeDateFromODBC"/></td>
					<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultTestComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="../Comments/text()"/></td>
					<!-- Used at RSNA to deal with HTML content: <td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="ResultText" mode="copy"/></td> -->
					<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ResultText/text()"/></td>
					<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
				</tr>
			</tbody>
			
			<xsl:if test="string-length(ResultItems)">
				<table border="1" width="100%">
					<caption>Atomic Results</caption>
					<thead>
						<tr>
							<th>Test Item</th>
							<th>Value</th>
							<th>Reference Range</th>
							<th>Comments</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="ResultItems/LabResultItem" mode="diagnosticResults-NarrativeDetail-LabResultItem">
							<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
							<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:if>
			
		</table>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResults-NarrativeDetail-LabResults-LabResultItem">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<xsl:variable name="testItemDescription"><xsl:apply-templates select="TestItemCode" mode="originalTextOrDescriptionOrCode"/></xsl:variable>
		<tr>
			<td><xsl:value-of select="$testItemDescription"/></td>
			<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultValue/text(), $narrativeLinkSuffix, '-', position())}"><xsl:value-of select="concat(ResultValue/text(), ' ', ResultValueUnits/text())"/></td>
			<td><xsl:value-of select="ResultNormalRange/text()"/></td>
			<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultValueComments/text(), $narrativeLinkSuffix, '-', position())}"><xsl:value-of select="Comments/text()"/></td>
		</tr>
	</xsl:template>	
	
	<xsl:template match="*" mode="diagnosticResults-ImagingResults-NarrativeDetail">
		<xsl:param name="narrativeLinkCategory" select="'imagingExaminationResults'"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<tbody>
			<tr ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultNarrative/text(), $narrativeLinkSuffix)}">
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultTestDescription/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="../OrderItem" mode="originalTextOrDescriptionOrCode"/></td>
				<td><xsl:apply-templates select="ResultTime" mode="narrativeDateFromODBC"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultTestComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="../Comments/text()"/></td>
				<!-- Used at RSNA to deal with HTML content: <td ID="{concat($exportConfiguration/results/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:apply-templates select="ResultText" mode="copy"/></td> -->
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultText/text(), $narrativeLinkSuffix)}"><xsl:value-of select="ResultText/text()"/></td>
				<td ID="{concat($exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
			</tr>
		</tbody>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResultsNEHTA-Entries">
		<xsl:param name="orderType"/>
		
		<xsl:choose>
			<xsl:when test="$orderType='LAB'">
				<xsl:apply-templates select="LabOrders/LabOrder/Result[string-length(ResultText/text()) or string-length(ResultItems)]" mode="diagnosticResultsNEHTA-EntryDetail">
					<xsl:sort select="ResultTime" order="descending"/>
					<xsl:with-param name="narrativeLinkCategory" select="'results'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$orderType='RAD'">
				<xsl:apply-templates select="RadOrders/RadOrder/Result[string-length(ResultText/text()) or string-length(ResultItems)]" mode="diagnosticResultsNEHTA-EntryDetail">
					<xsl:sort select="ResultTime" order="descending"/>
					<xsl:with-param name="narrativeLinkCategory" select="'imagingExaminationResults'"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResultsNEHTA-EntryDetail">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="position()"/>		
		
		<entry>
			<!-- Result Battery -->
			<xsl:apply-templates select="." mode="battery-diagnosticResultsNEHTA">
				<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
				<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
			</xsl:apply-templates>
		</entry>
	</xsl:template>

	<xsl:template match="*" mode="battery-diagnosticResultsNEHTA">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<observation classCode="OBS" moodCode="EVN">
			<!-- NEHTA wants only one <id> here. -->
			<xsl:choose>
				<xsl:when test="string-length(../PlacerId/text())">
					<xsl:apply-templates select=".." mode="id-Placer"/>
				</xsl:when>
				<xsl:when test="string-length(../FillerId/text())">
					<xsl:apply-templates select=".." mode="id-Filler"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select=".." mode="id-Placer"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select=".." mode="results-InitiatingOrder">
				<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
				<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates select=".." mode="diagnosticResultsNEHTA-testSpecimenDetails"/>
			
			<xsl:apply-templates select="ResultStatus" mode="observation-ResultStatus"/>
			
		<xsl:if test="$narrativeLinkCategory='imagingExaminationResults'">
			<!-- There is no SDA for Findings, but it is required. -->
			<entryRelationship typeCode="REFR">
				<observation classCode="OBS" moodCode="EVN">
					<id root="{isc:evaluate('createUUID')}"/>
					<code code="103.16503" codeSystem="1.2.36.1.2001.1001.101" codeSystemName="NCTIS Data Components" displayName="Findings"/>
					<text xsi:type="ST">No findings recorded.</text>
				 </observation>
			 </entryRelationship>
		 </xsl:if>

			<!-- Test Result Group -->
			<entryRelationship typeCode="COMP">
				<organizer classCode="BATTERY" moodCode="EVN">
					<xsl:apply-templates select=".." mode="id-Filler"/>
					<xsl:apply-templates select="../OrderItem" mode="generic-Coded"></xsl:apply-templates>
					
					<statusCode code="completed"/>
			
					<xsl:apply-templates select="." mode="effectiveTime-Result"/>
					<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
					<xsl:apply-templates select="EnteredAt" mode="informant"/>
			
					<xsl:apply-templates select="ResultText" mode="results-Text">
						<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
						<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="ResultItems/LabResultItem[string-length(ResultValue/text())>0]" mode="results-Atomic">
						<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
						<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
					</xsl:apply-templates>
				</organizer>
			</entryRelationship>
			
			<xsl:apply-templates select="." mode="effectiveTime-diagnosticResultsNEHTA">
				<xsl:with-param name="narrativeLinkCategory" select="$narrativeLinkCategory"/>
			</xsl:apply-templates>
			
		</observation>
	</xsl:template>

	<xsl:template match="*" mode="procedure-diagnosticResultsNEHTA">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component>
			<procedure classCode="PROC" moodCode="EVN">
				<xsl:apply-templates select="." mode="results-InitiatingOrder">
					<xsl:with-param name="narrativeLinkSuffix" select="$narrativeLinkSuffix"/>
				</xsl:apply-templates>
			</procedure>
		</component>
	</xsl:template>

	<xsl:template match="*" mode="results-InitiatingOrder">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		<xsl:apply-templates select="OrderItem" mode="generic-Coded"></xsl:apply-templates>
		<statusCode code="completed"/>
		<xsl:apply-templates select="EnteredOn" mode="effectiveTime"/>
		<xsl:apply-templates select="OrderedBy" mode="performer"/>
		<xsl:apply-templates select="EnteredBy" mode="author-Human"/>
		<xsl:apply-templates select="EnteredAt" mode="informant-noPatientIdentifier"/>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-Result">
		<xsl:choose>
			<xsl:when test="string-length(ResultTime)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="ResultTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
			<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-diagnosticResultsNEHTA">
		<xsl:param name="narrativeLinkCategory"/>
		
		<entryRelationship typeCode="COMP">
			<observation classCode="OBS" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<xsl:choose>
					<xsl:when test="$narrativeLinkCategory='results'">
						<code code="103.16605" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Pathology Test Result DateTime"/>
					</xsl:when>
					<xsl:otherwise>
						<code code="103.16589" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Imaging Examination Result DateTime"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(ResultTime)"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="ResultTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
					<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="diagnosticResultsNEHTA-testSpecimenDetails">
		<entryRelationship typeCode="SUBJ">
			<observation classCode="OBS" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<code code="102.16156.2.2.1" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Test Specimen Detail"/>
				<xsl:choose>
					<xsl:when test="string-length(SpecimenCollectedTime/text())"><effectiveTime><xsl:attribute name="value"><xsl:apply-templates select="SpecimenCollectedTime" mode="xmlToHL7TimeStamp"/></xsl:attribute></effectiveTime></xsl:when>
					<xsl:otherwise><effectiveTime nullFlavor="UNK"/></xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="Specimen" mode="specimen"/>
				<xsl:variable name="receivedTime"><xsl:apply-templates select="SpecimenReceivedTime" mode="xmlToHL7TimeStamp"/></xsl:variable>
				<xsl:if test="string-length($receivedTime)">
					<entryRelationship typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="103.11014" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="DateTime Received"/>
							<value xsi:type="TS" value="{$receivedTime}"/>
						</observation>
					</entryRelationship>
				</xsl:if>
			</observation>
		</entryRelationship>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="specimen"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="results-Text">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:apply-templates select="." mode="id-External"/>
				<xsl:apply-templates select="../../OrderItem" mode="generic-Coded"><xsl:with-param name="isCodeRequired" select="'1'"/></xsl:apply-templates>
				<text><xsl:value-of select="text()"/></text>
				<statusCode code="completed"/>
				<xsl:apply-templates select="parent::node()" mode="effectiveTime-Result"/>
				<value nullFlavor="NA" xsi:type="CD"/>
					<xsl:apply-templates select="../Comments" mode="comment-Result">
						<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultComments/text(), $narrativeLinkSuffix)"/>
					</xsl:apply-templates>
			</observation>
		</component>
	</xsl:template>	
	
	<xsl:template match="*" mode="results-Atomic">
		<xsl:param name="narrativeLinkCategory" select="'results'"/>
		<xsl:param name="narrativeLinkSuffix"/>
		
		<component typeCode="COMP">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:apply-templates select="." mode="id-results-Atomic"/>
				<xsl:apply-templates select="TestItemCode" mode="generic-Coded">
					<xsl:with-param name="isCodeRequired" select="'1'"/>
				</xsl:apply-templates>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="parent::node()/parent::node()" mode="effectiveTime-Result"/>
				
				<xsl:choose>
					<xsl:when test="TestItemCode/IsNumeric/text() = 'true'"><xsl:apply-templates select="ResultValue" mode="value-PQ"><xsl:with-param name="units" select="translate(ResultValueUnits, ' ', '_')"/></xsl:apply-templates></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="ResultValue" mode="value-ST"/></xsl:otherwise>
				</xsl:choose>
				
				<xsl:apply-templates select="ResultInterpretation" mode="results-Interpretation"/>
				<xsl:apply-templates select="TestItemStatus" mode="observation-TestItemStatus"/>
				<xsl:apply-templates select="Comments" mode="comment-Result">
					<xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/*[local-name() = $narrativeLinkCategory]/narrativeLinkPrefixes/resultValueComments/text(), $narrativeLinkSuffix, '-', position())"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="ResultNormalRange" mode="results-ReferenceRange"/>
			</observation>
		</component>
	</xsl:template>	
	
	<xsl:template match="*" mode="id-results-Atomic">
		<id root="{isc:evaluate('createUUID')}"/>
	</xsl:template>
	
	<!-- <xsl:template match="*" mode="results-Interpretation"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="observation-ResultStatus">
		<xsl:apply-templates select="." mode="nehta-Observation-Status"/>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-TestItemStatus">
		<xsl:apply-templates select="." mode="nehta-Observation-Status"/>
	</xsl:template>
	
	<xsl:template match="*" mode="nehta-Observation-Status">
		<entryRelationship typeCode="COMP">
			<observation classCode="OBS" moodCode="EVN">
				<code code="308552006" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT-AU" codeSystemVersion="20110531" displayName="report status"/>
				<text/>
				<statusCode code="completed"/>
				
				<!-- Status Detail -->
				<xsl:variable name="statusValue" select="concat('|',translate(text(), $lowerCase, $upperCase),'|')"/>
				<xsl:variable name="statusValueCode">
					<xsl:choose>
						<xsl:when test="contains('|3|F|',$statusValue)">3</xsl:when>
						<xsl:when test="contains('|2|R|V|A|P|',$statusValue)">2</xsl:when>
						<xsl:when test="contains('|4|C|K|',$statusValue)">4</xsl:when>
						<xsl:when test="contains('|1|I|O|S|',$statusValue)">1</xsl:when>
						<xsl:when test="contains('|5|X|',$statusValue)">5</xsl:when>
						<xsl:otherwise>unknown</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="statusInformation">
					<Status xmlns="">
						<!-- codeSystemName "NCTIS Result Status Values" is OID 1.2.36.1.2001.1001.101.104.16501 -->
						<SDACodingStandard>NCTIS Result Status Values</SDACodingStandard>
						<Code><xsl:value-of select="$statusValueCode"/></Code>
						<Description>
							<xsl:choose>
								<xsl:when test="$statusValueCode = '1'">Registered</xsl:when>
								<xsl:when test="$statusValueCode = '2'">Interim</xsl:when>
								<xsl:when test="$statusValueCode = '3'">Final</xsl:when>
								<xsl:when test="$statusValueCode = '4'">Amended</xsl:when>
								<xsl:when test="$statusValueCode = '5'">Cancelled</xsl:when>
								<xsl:otherwise>unknown</xsl:otherwise>
							</xsl:choose>
						</Description>
					</Status>
				</xsl:variable>
				<xsl:variable name="status" select="exsl:node-set($statusInformation)/Status"/>
				
				<xsl:apply-templates select="$status" mode="value-CD"/>
			</observation>
		</entryRelationship>
	</xsl:template>
		
	
	<!-- <xsl:template match="*" mode="results-ReferenceRange"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="performer-PerformedAt">
		<!-- NEHTA wants a performing person, not organization. -->
		<xsl:choose>
			<xsl:when test="../EnteredBy">
				<xsl:apply-templates select="../EnteredBy" mode="performer-PerformedBy"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="../../../EnteredBy" mode="performer-PerformedBy"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="performer-PerformedBy">
		<xsl:if test="$documentExportType='NEHTAeDischargeSummary' or $documentExportType='NEHTASharedHealthSummary'">
			<performer typeCode="PRF">
				<xsl:apply-templates select="parent::node()" mode="time"/>
				<xsl:apply-templates select="." mode="assignedEntity"/>
			</performer>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="results-ReferenceRangeCode">
		<code code="260395002" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="normal range"/>
	</xsl:template>
</xsl:stylesheet>
