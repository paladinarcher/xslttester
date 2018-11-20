<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="problems">
		<xsl:variable name="currentConditionStatusCodes" select="$exportConfiguration/problems/currentCondition/codes/text()"/>
		<xsl:variable name="currentConditionWindowInDays" select="$exportConfiguration/problems/currentCondition/windowInDays/text()"/>
		<xsl:variable name="hasData" select="Encounters/Encounter/Problems/Problem[contains($currentConditionStatusCodes, concat('|', Status/Code/text(), '|')) or not(ToTime) or (isc:evaluate('dateDiff', 'dd', translate(translate(FromTime/text(), 'Z', ''), 'T', ' ')) &lt;= $currentConditionWindowInDays)]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/problems/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-problemsSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Problem list"/>
					<title>Problems</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="conditions-Narrative">
								<xsl:with-param name="currentConditions" select="true()"/>
								<xsl:with-param name="narrativeLinkCategory">problems</xsl:with-param>
							</xsl:apply-templates>
							
							<xsl:apply-templates select="Encounters" mode="conditions-Entries">
								<xsl:with-param name="currentConditions" select="true()"/>
								<xsl:with-param name="narrativeLinkCategory">problems</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="problems-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateIds-problemsSection">
		<xsl:if test="string-length($hitsp-CDA-ProblemListSection)"><templateId root="{$hitsp-CDA-ProblemListSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProblemSection)"><templateId root="{$hl7-CCD-ProblemSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ActiveProblems)"><templateId root="{$ihe-PCC-ActiveProblems}"/></xsl:if>		
	</xsl:template>
</xsl:stylesheet>
