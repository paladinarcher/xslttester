<!-- Order and sort SDA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" version="1.0"
				exclude-result-prefixes="isc">
	<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
	<xsl:strip-space elements="*"/>

	<!-- Patient comes first, then Encounter -->
	<xsl:template match="/Container">
    <xsl:variable name="data"
      select="concat(SendingFacility, '^', Patient/PatientNumbers/PatientNumber[NumberType = 'MRN'][1]/Organization/Code, '^', Patient/PatientNumbers/PatientNumber[NumberType = 'MRN'][1]/Number, '||', Action, '||', EventDescription)"/>
    <xsl:value-of select="isc:evaluate('recordSDAData', $data)"/>
		<xsl:copy>
			<xsl:apply-templates select="Patient"/>
			<xsl:apply-templates select="Encounters"/>
      <xsl:apply-templates select="*[not(self::Patient | self::Encounters)]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="/Container/Encounters">
		<xsl:copy>
			<xsl:for-each select="Encounter">
        <xsl:sort select="ActionCode != ''" order="descending"/>
        <xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!--skip AdditionalInfo-->
	<xsl:template match="/Container/AdditionalInfo"/>

	<!--skip AdditionalDocumentInfo-->
  <xsl:template match="/Container/AdditionalDocumentInfo"/>

	<!--Copy all elements not explicitly referenced above-->
  <xsl:template match="@* | node()">
		<xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

  <xsl:template match="comment()"/>

</xsl:stylesheet>