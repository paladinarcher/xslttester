<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="comment-component">
		<xsl:param name="narrativeLink"/>
		
		<component>
			<xsl:apply-templates select="." mode="comment"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
		</component>
	</xsl:template>

	<xsl:template match="*" mode="comment-entryRelationship">
		<xsl:param name="narrativeLink"/>

		<entryRelationship typeCode="SUBJ" inversionInd="true">
			<xsl:apply-templates select="." mode="comment"><xsl:with-param name="narrativeLink" select="$narrativeLink"/></xsl:apply-templates>
		</entryRelationship>
	</xsl:template>
	
	<xsl:template match="*" mode="comment">
		<xsl:param name="narrativeLink"/>
		
		<act classCode="ACT" moodCode="EVN"> 
			<xsl:call-template name="templateIds-comments"/>
			
			<code code="48767-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Annotation Comment"/> 
			<text><reference value="{$narrativeLink}"/></text>
			<statusCode code="completed"/>
			
			<!-- Author (Human) -->
			<xsl:apply-templates select="parent::node()/Clinician | parent::node()/DiagnosingClinician | parent::node()/OrderedBy | parent::node()/VerifiedBy | parent::node()/parent::node()/VerifiedBy" mode="author-Human"/>
		</act>
	</xsl:template>

	<xsl:template name="templateIds-comments">
		<xsl:if test="string-length($hitsp-CDA-Comments)"><templateId root="{$hitsp-CDA-Comments}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-Comment)"><templateId root="{$hl7-CCD-Comment}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC-Comments)"><templateId root="{$ihe-PCC-Comments}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
