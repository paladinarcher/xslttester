<?xml version="1.0"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:isc="http://extension-functions.intersystems.com"
        exclude-result-prefixes="isc">




<xsl:import href="SDA-to-XMLSummaryScan-Z-VA-CCDA-CCD.xsl"/>

               <xsl:param name="EncountersMaxAge" select="$_36months"/>
               <xsl:param name="EncountersCount"  select="25"/>

               <xsl:param name="MedicationsMaxAge" select="$_15months"/>
               <xsl:param name="MedicationsMinAge" select="0"/>
               <xsl:param name="MedicationsCount"  select="999999"/>
               <xsl:param name="MedicationsCode"   select="''"/>
               <xsl:param name="MedicationsMaxAgeNonVA" select="999999"/>

               <xsl:param name="ProceduresMaxAge" select="$_36months"/>
               <xsl:param name="ProceduresCount"  select="25"/>

               <xsl:param name="LabOrdersMaxAge" select="$_12months"/>
               <xsl:param name="LabOrdersCount"  select="25"/>

</xsl:stylesheet>
