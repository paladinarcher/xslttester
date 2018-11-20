<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<!-- <xsl:template match="*" mode="comment-component"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="comment-entryRelationship"> SEE BASE TEMPLATE -->
	
	<!-- <xsl:template match="*" mode="comment"> SEE BASE TEMPLATE -->
	
	<xsl:template match="*" mode="comment-medication">
		<entryRelationship typeCode="COMP">
			<act classCode="INFRM" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<code code="103.16044" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Additional Comments"/>
				<text xsi:type="ST"><xsl:value-of select="text()"/></text>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="comment-Result">
		<entryRelationship typeCode="COMP">
			<act classCode="INFRM" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<code code="281296001" codeSystem="{$snomedOID}" codeSystemName="SNOMED CT-AU" codeSystemVersion="20110531" displayName="result comments"/>
				<text xsi:type="ST"><xsl:value-of select="text()"/></text>
			</act>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="comment-Condition">
		<entryRelationship typeCode="COMP">
			<act classCode="INFRM" moodCode="EVN">
				<id root="{isc:evaluate('createUUID')}"/>
				<code code="103.16545" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Problem/Diagnosis Comment"/>
				<text xsi:type="ST"><xsl:value-of select="text()"/></text>
			</act>
		</entryRelationship>
	</xsl:template>
</xsl:stylesheet>
