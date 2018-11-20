<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="Container" mode="measures">
		<!--
			Variable measuresContainer is an XML container that is
			built from the measuresInfoString that was set up by
			Variables.xsl.  The XML container will be used by
			apply-templates to generate the output of the QRDA
			Measures section.
		-->
		<xsl:variable name="measuresContainerInfo">
			<xsl:apply-templates select="." mode="measures-FromParameter">
				<xsl:with-param name="inStr" select="$measuresInfoString"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="measuresContainer" select="exsl:node-set($measuresContainerInfo)/MeasuresContainer"/>
		<xsl:variable name="hasData" select="string-length($measuresContainer)"/>
		
		<!--
			Variable assertionsContainer is an XML container that is
			built from the SDA CustomObject input for user-provided
			quality measure result assertions.  The XML container
			will be passed to Measure.xsl and used there to output
			any assertions data to the Measures section.
		-->
		<xsl:variable name="assertionsContainerInfo">
			<xsl:apply-templates select="." mode="measure-Assertions-FromSDA"/>
		</xsl:variable>
		<xsl:variable name="assertionsContainer" select="exsl:node-set($assertionsContainerInfo)/AssertionsContainer"/>
		
		<component>
			<section>
				<templateId root="{$qrda-MeasureSection}"/>
				<templateId root="{$qrda-QualityDataModelBasedMeasureSection}"/>
				
				<code code="55186-1" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="QualityMeasure Section"/>
				<title>Measure Section</title>
				
				<xsl:choose>
					<xsl:when test="$hasData">
						<xsl:apply-templates select="$measuresContainer" mode="measures-Narrative"/>
						
						<xsl:apply-templates select="$measuresContainer" mode="measures-Entries">
							<xsl:with-param name="assertionsContainer" select="$assertionsContainer"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="measures-NoData"/>
					</xsl:otherwise>
				</xsl:choose>
			</section>
		</component>
	</xsl:template>
	
	<!--
		measures-FromParameter parses the measuresInfoString variable that
		was set up by Variables.xsl, and creates an XML container from it.
		The format of the string is:
		Code!value^VersionSpecificId!value^NQFNumber!value^Title!value^AuthoringToolIdExtension!value^VersionNeutralId!value^VersionNumber!value^|(repeat the sequence seen before this vertical bar)
	-->
	<xsl:template match="*" mode="measures-FromParameter">
		<xsl:param name="inStr"/>
		
		<MeasuresContainer xmlns="">
			<QualityMeasures xmlns="">
				<xsl:apply-templates select="." mode="measure-FromParameter">
					<xsl:with-param name="inStr" select="$inStr"/>
				</xsl:apply-templates>
			</QualityMeasures>
		</MeasuresContainer>
	</xsl:template>
	
	<xsl:template match="*" mode="measure-FromParameter">
		<xsl:param name="inStr"/>
		
		<xsl:variable name="thisPiece" select="substring-before($inStr,'|')"/>
		<xsl:if test="string-length($thisPiece)">
			<QualityMeasure xmlns="">
				<Code><xsl:value-of select="substring-before(substring-after($thisPiece,'Code!'),'^')"/></Code>
				<VersionSpecificId><xsl:value-of select="substring-before(substring-after($thisPiece,'VersionSpecificId!'),'^')"/></VersionSpecificId>
				<NQFNumber><xsl:value-of select="substring-before(substring-after($thisPiece,'NQFNumber!'),'^')"/></NQFNumber>
				<AuthoringToolIdExtension><xsl:value-of select="substring-before(substring-after($thisPiece,'AuthoringToolIdExtension!'),'^')"/></AuthoringToolIdExtension>
				<Title><xsl:value-of select="substring-before(substring-after($thisPiece,'Title!'),'^')"/></Title>
				<VersionNeutralId><xsl:value-of select="substring-before(substring-after($thisPiece,'VersionNeutralId!'),'^')"/></VersionNeutralId>
				<VersionNumber><xsl:value-of select="substring-before(substring-after($thisPiece,'VersionNumber!'),'^')"/></VersionNumber>
			</QualityMeasure>
			<xsl:apply-templates select="." mode="measure-FromParameter">
				<xsl:with-param name="inStr" select="substring-after($inStr,'|')"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<!--
		measure-Assertions-FromSDA parses the measure result assertions
		that were passed in via SDA CustomObjects and CustomPairs.
		
		SDA Input:
		CustomObject
			CustomType = "QualityMeasureAssertion"
			CustomPairs
				NVPair/Name = "MeasureCode"
				NVPair/Value = External code from Quality Measure Registry
				NVPair/Name = "AssertionCode"
				NVPair/Value = "DENEX", "DENEXCEP", "DENOM", "IPP", "MSRPOPL", "NUMER", or "NUMEX"
				NVPair/Name = "AssertionResult"
				NVPair/Value = 0 or 1
				NVPair/Name = "PopulationId"
				NVPair/Value = Population criteria Id (a GUID) for the relevant population from the HQMF for the measure
				NVPair/Name = "Probability"
				NVPair/Value = Predicted probability that the patient would meet a particular population criteria
	-->
	<xsl:template match="Container" mode="measure-Assertions-FromSDA">
		<xsl:if test="CustomObjects/CustomObject[CustomType='QualityMeasureAssertion']">
			<AssertionsContainer xmlns="">
				<Assertions xmlns="">
					<xsl:apply-templates select="CustomObjects/CustomObject[CustomType='QualityMeasureAssertion']" mode="measure-Assertion"/>
				</Assertions>
			</AssertionsContainer>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="CustomObject" mode="measure-Assertion">
		<Assertion xmlns="">
			<MeasureCode><xsl:value-of select="CustomPairs/NVPair[Name='MeasureCode']/Value/text()"/></MeasureCode>
			<AssertionCode><xsl:value-of select="CustomPairs/NVPair[Name='AssertionCode']/Value/text()"/></AssertionCode>
			<AssertionResult><xsl:value-of select="CustomPairs/NVPair[Name='AssertionResult']/Value/text()"/></AssertionResult>
			<PopulationId><xsl:value-of select="CustomPairs/NVPair[Name='PopulationId']/Value/text()"/></PopulationId>
			<xsl:if test="CustomPairs/NVPair[Name='Probability']">
				<Probability><xsl:value-of select="CustomPairs/NVPair[Name='Probability']/Value/text()"/></Probability>
			</xsl:if>
		</Assertion>
	</xsl:template>
</xsl:stylesheet>
