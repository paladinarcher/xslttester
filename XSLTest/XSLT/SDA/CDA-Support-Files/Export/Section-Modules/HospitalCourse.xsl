<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="Patient" mode="hospitalCourse">
		<xsl:variable name="hasData" select="Encounters/Encounter/HospitalCourse"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/hospitalCourse/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIDs-hospitalCourseSection"/>
	
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HOSPITAL COURSE"/>
					<title>Hospital Course</title>
	
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters/Encounter/HospitalCourse" mode="hospitalCourse-Narrative"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="hospitalCourse-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="hospitalCourse-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Event</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="Event">
						<tr>
							<td><xsl:value-of select="text()"/></td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="hospitalCourse-NoData">
		<text><xsl:value-of select="$exportConfiguration/hospitalCourse/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template name="templateIDs-hospitalCourseSection">
		<xsl:if test="string-length($hitsp-CDA-HospitalCourseSection)"><templateId root="{$hitsp-CDA-HospitalCourseSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-HospitalCourse)"><templateId root="{$ihe-PCC-HospitalCourse}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
