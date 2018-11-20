<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 xsi exsl">
	
	<xsl:template match="*" mode="Result">
		<xsl:param name="elementName"/>
		<xsl:variable name="orderRootPath" select="hl7:observation"/>
		<!-- resultOrganizerTemplateId is set up in ImportProfile.xsl, may be customized -->
		<xsl:variable name="resultRootPath" select=".//hl7:organizer[@classCode='BATTERY' and @moodCode='EVN']"/>
 		<xsl:variable name="hasAtomicResults" select="count($resultRootPath/hl7:component/hl7:observation[(hl7:value/@value or string-length(hl7:value/text())) and not(hl7:value/@nullFlavor)]) > 0"/>
		
		<xsl:element name="{$elementName}">
			<EncounterNumber><xsl:apply-templates select="." mode="EncounterID-Entry"/></EncounterNumber>
			
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
			<xsl:apply-templates select="$orderRootPath/hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'OrderItem'"/>
				<xsl:with-param name="importOriginalText" select="'1'"/>
			</xsl:apply-templates>
			
			<!--
				OrderCategory does not have a direct source from CDA.
				OrderCategory is imported only if custom logic is
				added to template order-category-code.
			-->
			<xsl:variable name="hsOrderCategory"><xsl:apply-templates select="$resultRootPath" mode="order-category-code"/></xsl:variable>
			<xsl:if test="string-length($hsOrderCategory)">
				<OrderCategory>
					<Code>
						<xsl:value-of select="$hsOrderCategory"/>
					</Code>
				</OrderCategory>
			</xsl:if>
			
			<!-- Order status not tracked in CCD, so assume Executed. -->
			<Status>E</Status>
			
			<!-- Test Specimen Details -->
			<xsl:apply-templates select="hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code/@code='102.16156.2.2.1' and hl7:observation/hl7:code/@codeSystem=$nctisOID]/hl7:observation" mode="TestSpecimenDetails"/>
			
			<!-- Order Comments -->
			<xsl:apply-templates select="$orderRootPath" mode="Comment"/>
			
			<!-- Custom SDA Data-->
			<xsl:apply-templates select="$orderRootPath" mode="ImportCustom-Order"/>
			
			<Result>
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
						<ResultType>AT</ResultType>
						<ResultItems><xsl:apply-templates select="$resultRootPath/hl7:component/hl7:observation[not(hl7:value/@code)]" mode="LabResultItem"/></ResultItems>
					</xsl:when>
					<xsl:otherwise><ResultText><xsl:apply-templates select="$resultRootPath/hl7:component/hl7:observation/hl7:text" mode="TextValue"/></ResultText></xsl:otherwise>
				</xsl:choose>
				
				<!-- Custom SDA Data-->
				<xsl:apply-templates select="$resultRootPath" mode="ImportCustom-Result"/>
			</Result>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="TestSpecimenDetails">
		<!-- Specimen -->
		<xsl:apply-templates select="hl7:specimen/hl7:specimenRole/hl7:specimenPlayingEntity/hl7:code" mode="Specimen"/>
		
		<!-- SpecimenCollectedTime -->
		<xsl:apply-templates select="hl7:effectiveTime" mode="SpecimenCollectedTime"/>
		
		<!-- SpecimenReceivedTime -->
		<xsl:apply-templates select="hl7:entryRelationship[hl7:observation/hl7:code/@code='103.11014' and hl7:observation/hl7:code/@codeSystem=$nctisOID]/hl7:observation/hl7:value" mode="SpecimenReceivedTime"/>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="Specimen"> SEE BASE TEMPLATE -->
	
	
	<xsl:template match="*" mode="SpecimenCollectedTime">
		<xsl:if test="string-length(@value)">
			<SpecimenCollectedTime>
				<xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/>
			</SpecimenCollectedTime>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="SpecimenReceivedTime">
		<xsl:if test="string-length(@value)">
			<SpecimenReceivedTime>
				<xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/>
			</SpecimenReceivedTime>
		</xsl:if>
	</xsl:template>
	
	
	<!-- <xsl:template match="*" mode="ResultTime"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ResultStatus"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="LabResultItem"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="TestItemCode"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="TestItemStatus"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ResultValue"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ResultInterpretation"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ResultNormalRange"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="order-category-code"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ImportCustom-Order"> SEE BASE TEMPLATE -->

	<!-- <xsl:template match="*" mode="ImportCustom-Result"> SEE BASE TEMPLATE -->
</xsl:stylesheet>
