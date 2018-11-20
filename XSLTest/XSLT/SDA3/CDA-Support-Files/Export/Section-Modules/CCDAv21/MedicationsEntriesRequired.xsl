<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc"
  xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common"
  xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
  <!-- This stylesheet module is obsolete, but is provided in case there
       are other modules with an xsl:include that references it. -->
  
	<xsl:template match="*" mode="sM-templateIds-medicationsSection">
		<templateId root="{$ccda-MedicationsSectionEntriesRequired}"/>
		<templateId root="{$ccda-MedicationsSectionEntriesRequired}" extension="2014-06-09"/>
	</xsl:template>
</xsl:stylesheet>
