<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionName"/>
<xsl:param name="subTypes"/>
<xsl:key name="EncNum" match="Encounter" use="EncounterNumber" /> 

<!-- Insert sorted results under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
		<xsl:apply-templates select="/Container/LabOrders/LabOrder[Result]">
			<xsl:sort select="SpecimenCollectedTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<xsl:template match="LabOrder">
	<xsl:if  test="string-length($subTypes)= 0 or contains(concat(',',$subTypes,','),concat(',',OrderItem/OrderCategory/Code,','))">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:if>
</xsl:template> 

<!-- Add result to summary filter global and record sequence number -->
<xsl:template match="Result">
	<xsl:copy>
		<!-- Textual results - one per result-->
		<xsl:if test="not(ResultItems)">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:when test="../EnteredAt"><xsl:value-of select="../EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',../EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',../EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="../SpecimenCollectedTime" />
			<xsl:variable name="type" select="../OrderItem/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$type,'(textual)')"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<!--  Atomic results - one per test -->
<!-- Add lab test to summary filter global and record sequence number -->
<xsl:template match="LabResultItem">
	<xsl:variable name="source">
		<xsl:choose>
			<xsl:when test="EnteredAt"><xsl:value-of select="../../EnteredAt/Code"/></xsl:when>
			<xsl:when test="../EnteredAt"><xsl:value-of select="../../../EnteredAt/Code"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="key('EncNum',../../../EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sourceType" select="key('EncNum',../../../EncounterNumber)/EncounterType"/>
	 <xsl:variable name="date" select="../../../SpecimenCollectedTime" />
	<xsl:variable name="testItem" select="TestItemCode/Description"/>
	<xsl:variable name="result" select="concat(ResultValue,' ',ResultValueUnits)"/>
	<xsl:variable name="range" select="ResultNormalRange"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$testItem,$result,$range)"/>
		</xsl:attribute>
		<xsl:apply-templates />
		<xsl:variable name="resultFlag">
			<xsl:value-of select="isc:evaluate('resultFlag',ResultValue,ResultNormalRange)" />
		</xsl:variable>
		<xsl:element name="ResultAbnormal">	
			<xsl:choose>
				<xsl:when test="ResultInterpretation and contains('AAHHLL',ResultInterpretation)">true</xsl:when>
				<xsl:when test="ResultInterpretation='N'">false</xsl:when>
				<xsl:otherwise><xsl:value-of select="$resultFlag!='' and contains('HL',$resultFlag)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="RangeResult">
			<xsl:value-of select="$resultFlag" />
		</xsl:element>
	</xsl:copy>
</xsl:template>

<!-- Copy child nodes-->
<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
</xsl:template>

</xsl:stylesheet>




