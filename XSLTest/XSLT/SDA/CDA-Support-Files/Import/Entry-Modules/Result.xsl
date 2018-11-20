<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="*" mode="Result">
		<xsl:variable name="orderRootPath" select="hl7:act | .//hl7:procedure"/>
		<!-- resultOrganizerTemplateId is set up in ImportProfile.xsl, may be customized -->
		<xsl:variable name="resultRootPath" select=".//hl7:organizer[hl7:templateId/@root = $resultOrganizerTemplateId]"/>
		<xsl:variable name="isLabResult"><xsl:apply-templates select="$resultRootPath" mode="IsLabResult"/></xsl:variable>
		<xsl:variable name="isRadResult"><xsl:apply-templates select="$resultRootPath" mode="IsRadResult"><xsl:with-param name="paramIsLabResult" select="$isLabResult"/></xsl:apply-templates></xsl:variable>
 		<xsl:variable name="hasAtomicResults" select="count($resultRootPath/hl7:component/hl7:observation[(hl7:value/@value or string-length(hl7:value/text())) and not(hl7:value/@nullFlavor)]) > 0"/>
		<xsl:variable name="elementName">
			<xsl:choose>
				<xsl:when test="$isLabResult = 1">LabResult</xsl:when>
				<xsl:otherwise>Result</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{$elementName}">
			<InitiatingOrder>
				<!-- EnteredBy -->
				<xsl:apply-templates select="$orderRootPath" mode="EnteredBy"/>
				
				<!-- EnteredAt -->
				<xsl:apply-templates select="$orderRootPath" mode="EnteredAt"/>
				
				<!-- EnteringOrganization -->
				<xsl:apply-templates select="$orderRootPath" mode="EnteringOrganization"/>
				
				<!-- OrderedBy -->
				<xsl:apply-templates select="$orderRootPath/hl7:performer" mode="OrderedBy"/>
				
				<!-- EnteredOn -->
				<xsl:apply-templates select="$orderRootPath/hl7:effectiveTime" mode="EnteredOn"/>
				
				<!-- Override ExternalId with the <id> values from the source CDA -->
				<xsl:apply-templates select="hl7:act | $resultRootPath" mode="ExternalId"/>
				
				<!-- Placer and Filler IDs -->
				<xsl:apply-templates select="$orderRootPath" mode="PlacerId"/>
				<xsl:apply-templates select="$resultRootPath" mode="FillerId"/>
				
				<!-- Order Item -->
				<xsl:variable name="hsOrderCategory"><xsl:apply-templates select="$resultRootPath" mode="order-category-code"/></xsl:variable>
				<xsl:apply-templates select="$orderRootPath/hl7:code" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'OrderItem'"/>
					<xsl:with-param name="hsOrderType">
						<xsl:choose>
							<xsl:when test="$isLabResult = 1">LAB</xsl:when>
							<xsl:when test="$isRadResult = 1">RAD</xsl:when>
							<xsl:otherwise>OTH</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="hsOrderCategory" select="$hsOrderCategory"/>
				</xsl:apply-templates>
				
				<!-- Order status not tracked in CCD, so assume it's been executed -->
				<Status>E</Status>
				
				<!-- Specimen -->
				<xsl:apply-templates select=".//hl7:specimen/hl7:specimenRole/hl7:specimenPlayingEntity/hl7:code" mode="Specimen"/>
				
				<!-- Order Comments -->
				<xsl:apply-templates select="$orderRootPath" mode="Comment"/>
			</InitiatingOrder>
			
			<!-- Result EnteredBy -->
			<xsl:apply-templates select="$resultRootPath" mode="EnteredBy"/>
			
			<!-- Result EnteredAt -->
			<xsl:apply-templates select="$resultRootPath" mode="EnteredAt"/>
			
			<!-- Result PerformedAt -->
			<xsl:apply-templates select="$resultRootPath/hl7:performer" mode="PerformedAt"/>

			<!-- Result Time -->
			<xsl:apply-templates select="$resultRootPath/hl7:effectiveTime" mode="ResultTime"/>
			
			<!-- Result status supported in C37, but not in C32 -->
			<xsl:apply-templates select="$resultRootPath/hl7:component/hl7:observation[code/@code='33999-4']/hl7:value" mode="ResultStatus"/>
			
			<!-- Result Comments -->
			<xsl:apply-templates select="$resultRootPath" mode="Comment"/>
			
			<!-- Result (process text report or atomic results, but not both) -->
			<xsl:choose>
				<xsl:when test="$hasAtomicResults = true()">
					<HL7ResultType>AT</HL7ResultType>
					<ResultItems><xsl:apply-templates select="$resultRootPath/hl7:component/hl7:observation[not(hl7:value/@code)]" mode="LabResultItem"/></ResultItems>
				</xsl:when>
				<xsl:otherwise><ResultText><xsl:apply-templates select="$resultRootPath/hl7:component/hl7:observation/hl7:text" mode="TextValue"/></ResultText></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="Specimen">
		<xsl:variable name="labSpecimenCode">
			<xsl:choose>
				<xsl:when test="string-length(@code)"><xsl:value-of select="@code"/></xsl:when>
				<xsl:when test="string-length(@displayName)"><xsl:value-of select="@displayName"/></xsl:when>
				<xsl:when test="string-length(hl7:originalText/text())"><xsl:value-of select="hl7:originalText/text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="labSpecimenDescription">
			<xsl:choose>
				<xsl:when test="string-length(@displayName)"><xsl:value-of select="@displayName"/></xsl:when>
				<xsl:when test="string-length(hl7:originalText/text())"><xsl:value-of select="hl7:originalText/text()"/></xsl:when>
				<xsl:when test="string-length(@code)"><xsl:value-of select="@code"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="string-length($labSpecimenCode) and string-length($labSpecimenDescription)"><Specimen><xsl:value-of select="concat($labSpecimenCode, '&amp;', $labSpecimenDescription)"/></Specimen></xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultTime">
		<xsl:if test="@value"><ResultTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ResultTime></xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultStatus">
		<xsl:if test="@code">
			<ResultStatus>
				<xsl:choose>
					<xsl:when test="@code = 'active'">R</xsl:when>
					<xsl:when test="@code = 'completed'">F</xsl:when>
					<xsl:when test="@code = 'corrected'">C</xsl:when>
				</xsl:choose>
			</ResultStatus>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="LabResultItem">
		<LabResultItem>
			<xsl:apply-templates select="." mode="TestItemCode"/>			
			<xsl:apply-templates select="hl7:value" mode="ResultValue"/>
			<xsl:apply-templates select="hl7:interpretationCode" mode="ResultInterpretation"/>
			<xsl:apply-templates select="hl7:referenceRange/hl7:observationRange" mode="ResultNormalRange"/>
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="TestItemStatus"/>
			<xsl:choose>
				<xsl:when test="hl7:performer"><xsl:apply-templates select="hl7:performer" mode="PerformedAt" /></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="parent::node()/parent::node()/hl7:performer" mode="PerformedAt" /></xsl:otherwise>
			</xsl:choose>
			<!-- Lab Result Value Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</LabResultItem>
	</xsl:template>
	
	<xsl:template match="*" mode="TestItemCode">
		<xsl:variable name="textReferenceLink" select="hl7:text/hl7:reference/@value"/>
		<xsl:variable name="textReferenceValue" select="normalize-space($narrativeLinks/link[@id = substring-after($textReferenceLink, '#')]/text())"/>
		<xsl:variable name="originalTextReferenceLink" select="hl7:code/hl7:originalText/hl7:reference/@value"/>
		<xsl:variable name="originalTextReferenceValue" select="normalize-space($narrativeLinks/link[@id = substring-after($originalTextReferenceLink, '#')]/text())"/>
		
		<xsl:variable name="testDescription">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space(hl7:code/@displayName))"><xsl:value-of select="normalize-space(hl7:code/@displayName)"/></xsl:when>
				<xsl:when test="string-length($textReferenceValue)"><xsl:value-of select="$textReferenceValue"/></xsl:when>
				<xsl:when test="string-length(normalize-space(hl7:text/text()))"><xsl:value-of select="normalize-space(hl7:text/text())"/></xsl:when>
				<xsl:when test="string-length($originalTextReferenceValue)"><xsl:value-of select="$originalTextReferenceValue"/></xsl:when>
				<xsl:when test="string-length(normalize-space(hl7:code/hl7:originalText/text()))"><xsl:value-of select="normalize-space(hl7:code/hl7:originalText/text())"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<TestItemCode>
			<xsl:apply-templates select="hl7:code" mode="SDACodingStandard"/>
			<Code><xsl:value-of select="hl7:code/@code"/></Code>
			<Description><xsl:value-of select="$testDescription"/></Description>
			<IsNumeric>
				<xsl:choose>
					<xsl:when test="(hl7:value/@xsi:type = 'PQ') or (hl7:value/@xsi:type = 'ST')">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</IsNumeric>

			<!-- Prior Codes -->
			<xsl:apply-templates select="hl7:code" mode="PriorCodes"/>		
		</TestItemCode>
	</xsl:template>
	
	<xsl:template match="*" mode="TestItemStatus">
		<xsl:if test="@code">
			<TestItemStatus>
				<xsl:choose>
					<xsl:when test="@code = 'corrected'">C</xsl:when>
					<xsl:when test="@code = 'final'">F</xsl:when>
					<xsl:when test="@code = 'partial'">A</xsl:when>
					<xsl:when test="@code = 'preliminary'">P</xsl:when>
				</xsl:choose>
			</TestItemStatus>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultValue">
		<xsl:choose>
			<xsl:when test="@xsi:type='PQ'">
				<xsl:if test="@value"><ResultValue><xsl:value-of select="@value"/></ResultValue></xsl:if>
				<xsl:if test="@unit"><ResultValueUnits><xsl:value-of select="translate(@unit, '_', ' ')"/></ResultValueUnits></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length(text())"><ResultValue><xsl:value-of select="text()"/></ResultValue></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultInterpretation">
		<xsl:if test="@code"><ResultInterpretation><xsl:value-of select="@code"/></ResultInterpretation></xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultNormalRange">
		<xsl:if test="hl7:value or hl7:text">
			<ResultNormalRange>
				<xsl:choose>
					<xsl:when test="hl7:value and hl7:value/hl7:low/@value and hl7:value/hl7:high/@value"><xsl:value-of select="concat(hl7:value/hl7:low/@value, ' - ', hl7:value/hl7:high/@value)"/></xsl:when>
					<xsl:when test="hl7:value and hl7:value/hl7:low/@value and hl7:value/hl7:high/@nullFlavor"><xsl:value-of select="concat('>=', hl7:value/hl7:low/@value)"/></xsl:when>
					<xsl:when test="hl7:value and hl7:value/hl7:low/@nullFlavor and hl7:value/hl7:high/@value"><xsl:value-of select="concat('&lt;=', hl7:value/hl7:high/@value)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="hl7:text/text()"/></xsl:otherwise>
				</xsl:choose>						
			</ResultNormalRange>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="IsLabResult">
		<!-- Apply heuristics to determine if this is a lab result.
			
			IsLabResult provides the off-the-shelf criteria for
			determining is/is not a lab result.
			
			You may override the functionality of this template by
			creating the same template in ../../Site/ImportCustom.xsl
			and applying the logic that you desire.  If you create
			the custom template, then the version of the template
			here will not be used at all.
			 
			1. Is this a HITSP C37 / IHE XD-LAB report entry (templateId = 1.3.6.1.4.1.19376.1.3.1)?
			2. Is the observation explicitly marked as an IHE PCC Laboratory Observation (templateId = 1.3.6.1.4.1.19376.1.3.1.6)?
			3. Is there a reference range associated with the lab result?
			4. Is the lab result atomic (a collection of test items with specific values, rather than a text result)?
		-->
		<xsl:choose>
			<xsl:when test="parent::node()/hl7:templateId[@root = $ihe-PCC-LaboratoryReportEntry]">1</xsl:when>
			<xsl:when test="hl7:component/hl7:observation/hl7:templateId[@root = $ihe-PCC-LaboratoryObservation]">1</xsl:when>
			<xsl:when test="hl7:component/hl7:observation/hl7:referenceRange/hl7:observationRange">1</xsl:when>
			<!-- atomic result value has @value when xsi:type=PQ -->
			<xsl:when test="hl7:component/hl7:observation/hl7:value/@value">1</xsl:when>
			<!-- atomic result value has text() when xsi:type=ST -->
			<xsl:when test="string-length(hl7:component/hl7:observation/hl7:value/text())">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="IsRadResult">
		<xsl:param name="paramIsLabResult" select="'0'"/>
		
		<!-- IsRadResult provides the off-the-shelf criteria for
			 determining is/is not a rad result. Basically it is
			 "if it's not a lab result, then it's a rad result".
			 
			 You may override the functionality of this template by
			 creating the same template in ../../Site/ImportCustom.xsl
			 and applying the logic that you desire.  If you create
			 the custom template, then the version of the template
			 here will not be used at all.
		-->
		<xsl:choose>
			<xsl:when test="$paramIsLabResult='0'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
 	<xsl:template match="*" mode="order-category-code">
		<!-- This template will return blank until custom code is
			implemented.  To implement custom code, copy this
			template into ../../Site/ImportCustom.xsl and add the
			desired logic.
			
			When implementing custom code, return a string (case-
			sensitive) indicating the OrderCategory Code. Blank is
			a valid return, and will result in no OrderCategory
			being imported for the OrderItem.
			
			The XPath passed into this template is the .//hl7:organizer
			that uses the template specified by $resultOrganizerTemplateId,
			which is set up in ImportProfile.xsl.
		-->
	</xsl:template>
</xsl:stylesheet>
