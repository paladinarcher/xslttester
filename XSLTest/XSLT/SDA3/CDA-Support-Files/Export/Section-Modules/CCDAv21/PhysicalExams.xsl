<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="sPE-physicalExams">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<!--<xsl:variable name="hasData" select="PhysicalExams"/>-->
		<xsl:variable name="hasData" select="''"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/physicalExams/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasData) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="not($hasData)"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sPE-templateIds-physicalExamsSection"/>
					
					<code code="29545-1" displayName="Physical Findings" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
					<title>Physical Examination</title>
					
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="." mode="ePE-physicalExams-Narrative"/>
							<xsl:apply-templates select="." mode="ePE-physicalExams-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="ePE-physicalExams-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sPE-templateIds-physicalExamsSection">
		<templateId root="{$ccda-PhysicalExamSection}"/>
		<templateId root="{$ccda-PhysicalExamSection}" extension="2015-08-01"/>
	</xsl:template>
	
</xsl:stylesheet>