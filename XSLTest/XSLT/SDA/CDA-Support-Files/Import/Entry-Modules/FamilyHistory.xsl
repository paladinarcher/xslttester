<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="FamilyHistory">
		<xsl:for-each select="hl7:organizer/hl7:component">
			<FamilyHistory>				
				<!-- EnteredBy -->
				<xsl:apply-templates select="hl7:observation" mode="EnteredBy"/>
				
				<!-- EnteredAt -->
				<xsl:apply-templates select="hl7:observation" mode="EnteredAt"/>
				
				<!-- EnteredOn -->
				<xsl:apply-templates select="hl7:observation/hl7:author/hl7:time" mode="EnteredOn"/>
				
				<!-- Override ExternalId with the <id> values from the source CDA -->
				<xsl:apply-templates select="hl7:observation" mode="ExternalId"/>
				
				<!-- From and To Time -->
				<xsl:apply-templates select="hl7:observation/hl7:effectiveTime/hl7:low" mode="FromTime"/>
				<xsl:apply-templates select="hl7:observation/hl7:effectiveTime/hl7:high" mode="ToTime"/>
				
				<!-- Family Member -->
				<xsl:apply-templates select="../hl7:subject/hl7:relatedSubject[@classCode='PRS']/hl7:code" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'FamilyMember'"/>
				</xsl:apply-templates>
				
				<!-- Diagnosis -->
				<xsl:apply-templates select="hl7:observation/hl7:value" mode="CodeTable">
					<xsl:with-param name="hsElementName" select="'Diagnosis'"/>
				</xsl:apply-templates>

				<!-- Family History Status -->
				<Status>
					<xsl:variable name="familyHistoryStatus" select="hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value/@code"/>
					<xsl:choose>
						<xsl:when test="$familyHistoryStatus = '55561003'"><xsl:text>A</xsl:text></xsl:when>
						<xsl:otherwise><xsl:text>I</xsl:text></xsl:otherwise>
					</xsl:choose>
				</Status>
	 						
				<!-- Comments -->
				<xsl:apply-templates select="hl7:observation" mode="Comment">
					<xsl:with-param name="elementName" select="'NoteText'"/>
				</xsl:apply-templates>
			</FamilyHistory>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
