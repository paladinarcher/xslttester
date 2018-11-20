<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:template match="Patient" mode="admissionDiagnoses">
		<xsl:variable name="admissionDiagnosisTypeCodes" select="$exportConfiguration/admissionDiagnoses/diagnosisType/codes/text()"/>		
		<xsl:variable name="hasData" select="Encounters/Encounter/Diagnoses/Diagnosis[contains(isc:evaluate('toUpper', $admissionDiagnosisTypeCodes), concat('|', isc:evaluate('toUpper', DiagnosisType/Code/text()), '|')) = true()]"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/admissionDiagnoses/emptySection/exportData/text()"/>
		
		<xsl:if test="$hasData or (not($hasData) and ($exportSectionWhenNoData = 1))">
			<component>
				<section>
					<xsl:call-template name="templateIds-admissionDiagnosesSection"/>
					
					<!-- IHE needs unique id for each and every section -->
					<id root="{$homeCommunityOID}" extension="{isc:evaluate('createGUID')}"/>

					<code code="46241-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HOSPITAL ADMISSION DX"/>
					<title>Hospital Admission Diagnoses</title>
					
					<xsl:choose>
						<xsl:when test="$hasData">
							<xsl:apply-templates select="Encounters" mode="diagnoses-Narrative">
								<xsl:with-param name="diagnosisTypeCodes" select="$admissionDiagnosisTypeCodes"/>
								<xsl:with-param name="narrativeLinkCategory">admissionDiagnoses</xsl:with-param>
							</xsl:apply-templates>
							
							<xsl:apply-templates select="Encounters" mode="diagnoses-Entries">
								<xsl:with-param name="diagnosisTypeCodes" select="$admissionDiagnosisTypeCodes"/>
								<xsl:with-param name="narrativeLinkCategory">admissionDiagnoses</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="admissionDiagnoses-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="templateIds-admissionDiagnosesSection">
		<xsl:if test="string-length($hitsp-CDA-HospitalAdmissionDiagnosisSection)"><templateId root="{$hitsp-CDA-HospitalAdmissionDiagnosisSection}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-HospitalAdmissionDiagnosis)"><templateId root="{$ihe-PCC-HospitalAdmissionDiagnosis}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>