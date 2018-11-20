<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="procedures">
		<xsl:variable name="hasData" select="Encounters/Encounter/Procedures"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/procedures/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-proceduresSection"/>

					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="47519-4" displayName="History of Procedures" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<title>Procedures and Interventions</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="procedures-Narrative"/>
							<xsl:apply-templates select="Encounters" mode="procedures-Entries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="procedures-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-proceduresSection">
		<xsl:if test="string-length($hitsp-CDA-ProceduresAndInterventionsSection)"><templateId root="{$hitsp-CDA-ProceduresAndInterventionsSection}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-ProceduresSection)"><templateId root="{$hl7-CCD-ProceduresSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-ListOfSurgeries)"><templateId root="{$ihe-PCC-ListOfSurgeries}"/></xsl:if>		
	</xsl:template>
</xsl:stylesheet>
