<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<xsl:template match="Container" mode="patientData">
		<component>
			<section>
				<templateId root="{$qrda-PatientDataSection}"/>
				<templateId root="{$qrda-QualityDataModelBasedPatientDataSection}"/>
								
				<code code="55188-7" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Patient Data"/>
				<title>Patient Data</title>
				
				<xsl:apply-templates select="." mode="patientData-Narrative"/>
				<xsl:apply-templates select="." mode="patientData-Entries"/>
			</section>
		</component>
	</xsl:template>
</xsl:stylesheet>
