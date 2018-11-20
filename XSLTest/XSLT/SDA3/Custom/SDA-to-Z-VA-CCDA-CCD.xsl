<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:include href="SDA-to-Z-BASE-CCDA-CCD.xsl"/>
	
    <xsl:variable name="flavor" select="'VA'"/>
    
    <!--if user entered custom QD's, don't display doc titles (section 4) in Encounters section -->
    <xsl:variable name="titles">
		<xsl:choose>
			<xsl:when test="$startDays=''">
				<xsl:value-of select="1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    
	<xsl:template match="/Container">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
			<!-- Begin CDA Header -->
			<realmCode code="US"/>
			<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040whatever"/>
			<!-- What the heck... yo!-->
			<xsl:apply-templates select="." mode="templateIds-documentHeader"/>
				
			<xsl:apply-templates select="Patient" mode="id-Document"/>
			
			<code code="34133-9" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Summarization of Episode Note"/>
			
			<xsl:apply-templates select="." mode="document-title">
				<xsl:with-param name="title1">Department of Veterans Affairs Health Summary</xsl:with-param>
			</xsl:apply-templates>
			
			<effectiveTime value="{$currentDateTime}"/>
			<xsl:apply-templates mode="document-confidentialityCode" select="."/>
			<languageCode code="en-US"/>
			
			<!-- Person Information module -->
			<xsl:apply-templates select="Patient" mode="personInformation"/>
			
			<!-- Information Source module -->
			<xsl:apply-templates select="Patient" mode="informationSource"/>
			
			<!-- Support module	-->
			<xsl:apply-templates select="Patient" mode="nextOfKin"/>
			
			<!-- Healthcare Providers module -->
			<xsl:apply-templates select="Patient" mode="healthcareProviders"/>
			
			<!--
				Encompassing Encounter module
				
				Export only if requested via $encompassingEncNum and $encompassingEncOrg.
			-->
			<xsl:variable name="encompassingEncNum"><xsl:apply-templates select="." mode="encompassingEncounterNumber"/></xsl:variable>
			<xsl:variable name="encompassingEncOrg"><xsl:apply-templates select="." mode="encompassingEncounterOrganization"/></xsl:variable>
			<xsl:if test="string-length($encompassingEncNum) and string-length($encompassingEncOrg)">
				<xsl:apply-templates select="Encounters/Encounter[(EncounterNumber/text()=$encompassingEncNum) and (HealthCareFacility/Organization/Code/text()=$encompassingEncOrg)]" mode="encompassingEncounter">
					<xsl:with-param name="clinicians" select="'|DIS|ATND|ADM|CON|REF|'"/>
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- End CDA Header -->
			<!-- Begin CCD Body -->
			<component>
				<structuredBody>
					<!-- Allergies -->
					<xsl:apply-templates select="." mode="allergies">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Vital Signs module -->
					<xsl:apply-templates select="." mode="vitalSigns"/>
				
					<!-- Problem List module -->
					<xsl:apply-templates select="." mode="problems">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Payers -->
					<xsl:apply-templates select="." mode="payers"/>
					
					<!-- Advance Directives module -->
					<xsl:apply-templates select="." mode="advanceDirectives"/>
					
					<!-- Medications module -->
					<xsl:apply-templates select="." mode="medications">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Encounters module -->
					<xsl:apply-templates select="." mode="encounters"/>
					
					<!-- Results module -->
					<xsl:apply-templates select="." mode="results">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Immunizations module -->
					<xsl:apply-templates select="." mode="immunizations"/>
					
					<!-- Procedures and Interventions module -->
					<xsl:apply-templates select="." mode="procedures">
						<xsl:with-param name="sectionRequired" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Social History module -->
					<xsl:apply-templates select="." mode="socialHistory"/>
					
					<!-- Plan of Care module -->
					<xsl:apply-templates select="." mode="planOfCare"/>
					
					<!-- Functional Status module -->
					<xsl:apply-templates select="." mode="functionalStatus"/>
					
					<!-- Family History module -->
					<!--
					<xsl:apply-templates select="." mode="familyHistory"/>
					-->
					<!-- Assessment module -->
					<!--
					<xsl:apply-templates select="." mode="assessments"/>
					-->
					<!-- Assessment and Plan module -->
					<!--
					<xsl:apply-templates select="." mode="assessmentAndPlan"/>
					-->
					<!-- Hospital Discharge Instructions module -->
					<!--
					<xsl:apply-templates select="." mode="dischargeInstructions"/>
					-->
					<!-- Custom export -->
					<xsl:apply-templates select="." mode="ExportCustom-ClinicalDocument"/>
				</structuredBody>
			</component>
			<!-- End CCD Body -->
		</ClinicalDocument>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-documentHeader">
		<templateId root="{$ccda-USRealmHeader}"/>
		<templateId root="{$ccda-ContinuityOfCareCCD}"/>
	</xsl:template>
	
	<!-- confidentialityCode may be overriden by stylesheets that import this one -->
	<xsl:template mode="document-confidentialityCode" match="Container">
	<confidentialityCode nullFlavor="{$confidentialityNullFlavor}"/>
	</xsl:template>

	<!-- This empty template may be overridden with custom logic. -->
	<xsl:template match="*" mode="ExportCustom-ClinicalDocument">
	</xsl:template>
</xsl:stylesheet>
