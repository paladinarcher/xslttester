<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:isc="http://extension-functions.intersystems.com" xmlns:n1="urn:hl7-org:v3" xmlns:n2="urn:hl7-org:v3/meta/voc" xmlns:n3="http://www.w3.org/1999/xhtml" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" media-type="application/pdf"/>
	<xsl:template match="/n1:ClinicalDocument">
		<xsl:apply-templates mode="b64Body" select="//n1:nonXMLBody/n1:text"/>	
	</xsl:template>
	<xsl:template mode="b64Body" match="*">
		<xsl:value-of select="text()"/>
		
	</xsl:template>
</xsl:stylesheet>
