<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="sHOPreI-presentIllness">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<xsl:variable name="hasData" select="count(IllnessHistories)"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/presentIllness/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasData > 0) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="$hasData = 0"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sHOPreI-templateIds-presentIllnessSection"/>
					
					<code code="10164-2" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="HISTORY OF PRESENT ILLNESS"/>
					<title>History of Present Illness</title>
					
					<xsl:choose>
						<xsl:when test="$hasData > 0">
							<xsl:apply-templates select="IllnessHistories" mode="eHOPI-presentIllness-Narrative"/>
							<xsl:apply-templates select="IllnessHistories" mode="eHOPI-presentIllness-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="eHOPI-presentIllness-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sHOPreI-templateIds-presentIllnessSection">
		<templateId root="{$ccda-HistoryOfPresentIllnessSection}"/>
		<templateId root="{$ccda-HistoryOfPresentIllnessSection}" extension="2015-08-01"/>
	</xsl:template>
</xsl:stylesheet>
