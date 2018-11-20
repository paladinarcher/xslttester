<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Extra entry module used. AlsoInclude: FamilyHistory.xsl Comment.xsl -->
	
	<xsl:template match="*" mode="sFH-familyHistory">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<xsl:variable name="hasData" select="count(FamilyHistories)"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/familyHistory/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasData > 0) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="($hasData = 0)"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sFH-templatedIds-familyHistorySection"/>
					
					<code code="10157-6" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
					<title>Family History</title>
					
					<xsl:choose>
						<xsl:when test="$hasData > 0">
							<xsl:apply-templates select="FamilyHistories" mode="eFH-familyHistory-Narrative"/>
							<xsl:apply-templates select="FamilyHistories" mode="eFH-familyHistory-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="eFH-familyHistory-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sFH-templatedIds-familyHistorySection">
		<templateId root="{$ccda-FamilyHistorySection}"/>
		<templateId root="{$ccda-FamilyHistorySection}" extension="2015-08-01"/>
	</xsl:template>
	
</xsl:stylesheet>