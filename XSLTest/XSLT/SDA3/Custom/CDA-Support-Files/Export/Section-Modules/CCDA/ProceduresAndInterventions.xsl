<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="*" mode="procedures">
		<xsl:param name="sectionRequired" select="'1'"/>
		
		<!-- Export Procedures for the current date or earlier, or with no date.  Future Procedures should be exported under Plan of Care. -->
		<xsl:variable name="hasData" select="Procedures/Procedure[(not(string-length(ProcedureTime/text())) and not(string-length(FromTime/text()))) or (string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) >= 0) or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) >= 0)]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/procedures/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasData) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="not($hasData)"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:apply-templates select="." mode="templateIds-proceduresSection"/>
					
					<code code="47519-4" displayName="History of Procedures" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
					<title>History of Procedures</title>
					
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="." mode="procedures-Narrative"/>
							<xsl:apply-templates select="." mode="procedures-Entries"/>
							<xsl:apply-templates select="." mode="procedures-NoteEntries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="procedures-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<!-- If the "entries required" templateId is needed then this template is overridden by *EntriesRequired.xsl -->
	<xsl:template match="*" mode="templateIds-proceduresSection">
		<templateId root="{$ccda-ProceduresSectionEntriesRequired}"/>
		<!--
		<templateId root="{$ccda-ProceduresSectionEntriesOptional}"/>
		-->
	</xsl:template>
</xsl:stylesheet>
