<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Custom XSLT utilities
-->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:exsl="http://exslt.org/common" 
exclude-result-prefixes="isc exsl">

<xsl:template name="toLOINC">
<xsl:param name="type"/>
<xsl:variable name="codeDesc">
<xsl:choose>

<xsl:when test="$type = 'Patient'">34133-9^Patient Summary</xsl:when>
<xsl:when test="$type = 'Encounter'">11506-3^Encounter Summary</xsl:when>
<xsl:when test="$type = 'CP'">28570-0^Provider-Unspecified Procedure Note</xsl:when>
<xsl:when test="$type = 'CR'">11488-4^Consult Note</xsl:when>
<xsl:when test="$type = 'DS'">18842-5^Discharge Summary</xsl:when>
<xsl:when test="$type = 'HP'">34117-2^History and Physical</xsl:when>
<xsl:when test="$type = 'LR'">27898-6^Pathology Study</xsl:when>
<xsl:when test="$type = 'PN'">18733-6^Progress Note</xsl:when>
<xsl:when test="$type = 'RA'">18726-0^Radiology Study</xsl:when>
<xsl:when test="$type = 'SR'">29752-3^Perioperative Report</xsl:when>

 <!--  prototype only (based on Scenario_*.hl7 files) -->
 <xsl:when test="$type = 'Progress note'">18733-6^Progress Note</xsl:when>
 
 <!--  default all documents missing type to be PN -->
 <xsl:otherwise>18733-6^Progress Note</xsl:otherwise>
 
</xsl:choose>
</xsl:variable>
<xsl:value-of select="concat($codeDesc,'^2.16.840.1.113883.6.1')"/>
</xsl:template>
</xsl:stylesheet>
