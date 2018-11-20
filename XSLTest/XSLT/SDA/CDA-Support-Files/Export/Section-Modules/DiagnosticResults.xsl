<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="results-C32">
		<xsl:variable name="hasData" select="Encounters/Encounter/Results"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/results/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-diagnosticResultsC32Section"/>
	
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="30954-2" displayName="Relevant diagnostic tests and laboratory data" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Results</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="diagnosticResults-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="diagnosticResultsC32-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="diagnosticResults-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Patient" mode="results-C37">
		<xsl:variable name="hasData" select="Encounters/Encounter/Results[.//InitiatingOrder/OrderItem/OrderType/text() = 'LAB']"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/results/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-diagnosticResultsC37Section"/>
	
					<code code="26436-6" displayName="LABORATORY STUDIES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Results</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="diagnosticResults-Narrative"><xsl:with-param name="orderType">LAB</xsl:with-param></xsl:apply-templates>
							<xsl:apply-templates select="Encounters" mode="diagnosticResultsC37-Entries"><xsl:with-param name="orderType">LAB</xsl:with-param></xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise><xsl:apply-templates select="." mode="diagnosticResults-NoData"/></xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-diagnosticResultsC32Section">
		<xsl:if test="string-length($hitsp-CDA-DiagnosticResultsSection)"><templateId root="{$hitsp-CDA-DiagnosticResultsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ResultsSection)"><templateId root="{$hl7-CCD-ResultsSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-CodedResults)"><templateId root="{$ihe-PCC-CodedResults}"/></xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-diagnosticResultsC37Section">
		<xsl:if test="string-length($hitsp-CDA-DiagnosticResultsSection)"><templateId root="{$hitsp-CDA-DiagnosticResultsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ResultsSection)"><templateId root="{$hl7-CCD-ResultsSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-LaboratorySpecialty)"><templateId root="{$ihe-PCC-LaboratorySpecialty}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
