<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Allergy">
		<Allergies>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation[@classCode='OBS' and @moodCode='EVN']" mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:author/hl7:time" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>
			
			<!-- From and To Time -->
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low" mode="FromTime"/>
			<xsl:apply-templates select="hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:high" mode="ToTime"/>

			<!-- Allergy and Allergy Category -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation" mode="AllergyAndCategory"/>

			<!-- Clinician -->
			<xsl:apply-templates select="hl7:performer" mode="Clinician"/>
			
			<!-- Allergy Reaction -->
			<xsl:apply-templates select = "." mode = "AllergyReaction"/>

			<!-- Allergy Severity -->
			<xsl:apply-templates select = "." mode = "AllergySeverity"/>

			<!-- Allergy Status -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value" mode="AllergyStatus"/>

			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Allergies>
	</xsl:template>
	
	<xsl:template match="*" mode="AllergyAndCategory">
		<xsl:apply-templates select="hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code" mode="CodeTable">
			<xsl:with-param name="hsElementName" select="'Allergy'"/>
			<xsl:with-param name="subCodedElementRootPath" select="hl7:code"/>
			<xsl:with-param name="subElementName" select="'AllergyCategory'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="AllergyStatus">
		<Status>
			<xsl:choose>
				<xsl:when test="@code = '55561003'">A</xsl:when>
				<xsl:otherwise>I</xsl:otherwise>
			</xsl:choose>
		</Status>
	</xsl:template>
	
	<xsl:template match="*" mode="AllergyReaction">
  		<xsl:choose>
    		<xsl:when test="(.//hl7:observation[hl7:templateId/@root=$hl7-CCD-ReactionObservation]/hl7:value/@code) or (.//hl7:observation[hl7:templateId/@root=$hl7-CCD-ReactionObservation]/hl7:value/hl7:translation/@code)">
      			<xsl:apply-templates select=".//hl7:observation[hl7:templateId/@root=$hl7-CCD-ReactionObservation]/hl7:value" mode="CodeTable">
       			 	<xsl:with-param name="hsElementName" select="'Reaction'"/>
     			 </xsl:apply-templates>
    		</xsl:when>
    		<xsl:otherwise>
      			<xsl:apply-templates select=".//hl7:observation[hl7:templateId/@root=$hl7-CCD-ReactionObservation]/hl7:text" mode="CodeTable">
        			<xsl:with-param name="hsElementName" select="'Reaction'"/>
      			</xsl:apply-templates>
    		</xsl:otherwise>
  		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="AllergySeverity">
  		<xsl:choose>
    		<xsl:when test="(.//hl7:observation[hl7:templateId/@root=$hl7-CCD-SeverityObservation]/hl7:value/@code) or (.//hl7:observation[hl7:templateId/@root=$hl7-CCD-SeverityObservation]/hl7:value/hl7:translation/@code)">
      			<xsl:apply-templates select=".//hl7:observation[hl7:templateId/@root=$hl7-CCD-SeverityObservation]/hl7:value" mode = "CodeTable">
        			<xsl:with-param name="hsElementName" select="'Severity'"/>
      			</xsl:apply-templates>
    		</xsl:when>
   			 <xsl:otherwise>
      			<xsl:apply-templates select=".//hl7:observation[hl7:templateId/@root=$hl7-CCD-SeverityObservation]/hl7:text" mode = "CodeTable">
        			<xsl:with-param name="hsElementName" select="'Severity'"/>
      			</xsl:apply-templates>
    		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
