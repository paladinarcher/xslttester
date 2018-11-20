<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="sectionName"/>
<xsl:param name="subTypes"/>

<!-- Insert lab tests under the report section -->
<xsl:template match="/">
	<xsl:element name="{$sectionName}">
		<xsl:apply-templates select="/Container/Patients/Patient/Encounters/Encounter/Results/LabResult | /Container/Patients/Patient/Encounters/Encounter/Results/Result[InitiatingOrder/OrderItem/OrderType = 'LAB']">
			<xsl:sort select="InitiatingOrder/SpecimenCollectedTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:element>
</xsl:template>

<!-- Add atomic lab results to summary filter global and record sequence number -->
<xsl:template match="LabResult">
	<xsl:if  test="string-length($subTypes)= 0 or contains(concat(',',$subTypes,','),concat(',',InitiatingOrder/OrderItem/OrderCategory/Code,','))">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="InitiatingOrder/EnteredAt"><xsl:value-of select="InitiatingOrder/EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:variable name="sourceType" select="../../EncounterType"/>
		<xsl:variable name="date" select="InitiatingOrder/SpecimenCollectedTime" />
		<xsl:copy>
				<xsl:apply-templates/>
				<ResultItems>
					<xsl:for-each select="ResultItems/LabResultItem">
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
					</xsl:for-each>
				</ResultItems>
		</xsl:copy>
	</xsl:if> 
</xsl:template> 

<!-- Copy child nodes of LabResult (other then ResultItems, handled above) -->
<xsl:template match="*">
	<xsl:if test="local-name()!='ResultItems'">
		<xsl:copy-of select="."/>
	</xsl:if>
</xsl:template>

<!-- Add textual lab results to summary filter global and record sequence number -->
<xsl:template match="Result">
		<xsl:if  test="string-length($subTypes)= 0 or contains(concat(',',$subTypes,','),concat(',',InitiatingOrder/OrderItem/OrderCategory/Code,','))">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="InitiatingOrder/EnteredAt"><xsl:value-of select="InitiatingOrder/EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="InitiatingOrder/StartTime" />
			<xsl:variable name="testItem" select="InitiatingOrder/OrderItem/Description"/>

			<xsl:copy>
				<xsl:attribute name="sequence">
					<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$testItem,'(textual)')"/>
				</xsl:attribute>
				<xsl:apply-templates />
			</xsl:copy>
	</xsl:if>	
</xsl:template> 

</xsl:stylesheet>
