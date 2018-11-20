<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="sHC-hospitalCourse">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<xsl:variable name="encounterSet" select="Encounters/Encounter[string-length(VisitDescription/text()) and string-length(EncounterNumber/text())]"/>
		<xsl:variable name="hasData" select="count($encounterSet)"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/hospitalCourse/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasData > 0) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="$hasData = 0"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sHC-templateIds-hospitalCourseSection"/>
						
					<code code="8648-8" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="HOSPITAL COURSE"/>
					<title>Hospital Course</title>
					
					<xsl:choose>
						<xsl:when test="$hasData > 0">
							<text>							
								<xsl:for-each select="$encounterSet">									
									<content>
										<xsl:value-of select="VisitDescription/text()"/>
									</content>
								</xsl:for-each>	
							</text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="sHC-hospitalCourse-NoData"/>
						</xsl:otherwise>
					</xsl:choose>

				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="sHC-hospitalCourse-NoData">
		<text><xsl:value-of select="$exportConfiguration/hospitalCourse/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sHC-templateIds-hospitalCourseSection">
		<templateId root="{$ccda-HospitalCourseSection}"/>
		<templateId root="{$ccda-HospitalCourseSection}" extension="2015-08-01"/>
	</xsl:template>
</xsl:stylesheet>
