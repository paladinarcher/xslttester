<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
  <xsl:include href="SDA-to-Z-BASE-CCDAv21-CCD.xsl"/>
	
  <xsl:variable name="flavor" select="'VA'"/>
  
  <xsl:template match="/Container">
    <ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
      <!-- Begin CDA Header -->
      <realmCode code="US"/>
      <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>

      <xsl:apply-templates select="." mode="fn-templateId-USRealmHeader"/>

      <xsl:apply-templates select="." mode="templateId-CCDHeader"/>

      <xsl:apply-templates select="Patient" mode="fn-id-Document"/>

      <code code="34133-9" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Summarization of Episode Note"/>

      <xsl:apply-templates select="." mode="fn-title-forDocument">
        <xsl:with-param name="title1">Department of Veterans Affairs Health Summary</xsl:with-param>
      </xsl:apply-templates>

      <effectiveTime value="{$currentDateTime}"/>
      <xsl:apply-templates mode="document-confidentialityCode" select="."/>
      <languageCode code="en-US"/>

      <!-- Person Information module -->
      <xsl:apply-templates select="Patient" mode="ePI-personInformation"/>

      <!-- Information Source module -->
      <xsl:apply-templates select="Patient" mode="eIS-informationSource"/>

      <!-- Healthcare Providers module -->
      <xsl:apply-templates select="Patient" mode="eHP-healthcareProviders"/>

      <!--
				Encompassing Encounter module
				
				Export only if requested via $encompassingEncNum and $encompassingEncOrg.
			-->
      <xsl:variable name="encompassingEncNum">
        <xsl:apply-templates select="." mode="fn-encompassingEncounterNumber"/>
      </xsl:variable>
      <xsl:variable name="encompassingEncOrg">
        <xsl:apply-templates select="." mode="fn-encompassingEncounterOrganization"/>
      </xsl:variable>
      <xsl:if test="string-length($encompassingEncNum) and string-length($encompassingEncOrg)">
        <xsl:apply-templates
          select="Encounters/Encounter[(EncounterNumber/text() = $encompassingEncNum) and (HealthCareFacility/Organization/Code/text() = $encompassingEncOrg)]"
          mode="eEE-encompassingEncounter">
          <xsl:with-param name="clinicians" select="'|DIS|ATND|ADM|CON|REF|'"/>
        </xsl:apply-templates>
      </xsl:if>

      <!-- End CDA Header -->
      <!-- Begin CCD Body -->
      <component>
        <structuredBody>
          <!-- Allergies -->
          <xsl:apply-templates select="." mode="sAOAR-allergies">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Medications module -->
          <xsl:apply-templates select="." mode="sM-medications">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Problem List module -->
          <xsl:apply-templates select="." mode="sPL-problems">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Procedures and Interventions module -->
          <xsl:apply-templates select="." mode="sPAI-procedures">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Results module -->
          <xsl:apply-templates select="." mode="sDR-results">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Assessment module -->
          <xsl:apply-templates select="." mode="sA-assessments"/>

          <!-- Advance Directives module -->
          <xsl:apply-templates select="." mode="sAD-advanceDirectives"/>

          <!-- Encounters module -->
          <xsl:apply-templates select="." mode="sE-encounters"/>

          <!-- Family History module -->
          <xsl:apply-templates select="." mode="sFH-familyHistory"/>

          <!-- Functional Status module -->
          <xsl:apply-templates select="." mode="sFS-functionalStatus"/>

          <!-- Immunizations module -->
          <xsl:apply-templates select="." mode="sIm-immunizations"/>

          <!-- Payers -->
          <xsl:apply-templates select="." mode="sP-payers"/>

          <!-- Plan of Treatment module -->
          <xsl:apply-templates select="." mode="sPOT-planOfTreatment"/>

          <!-- Assessment and Plan module-->
          <xsl:apply-templates select="." mode="sANP-assessmentAndPlan"/>

          <!-- Social History module -->
          <xsl:apply-templates select="." mode="sSH-socialHistory">
            <xsl:with-param name="sectionRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Vital Signs module -->
          <xsl:apply-templates select="." mode="sVS-vitalSigns">
            <xsl:with-param name="sectionRequired" select="'1'"/>
            <xsl:with-param name="entriesRequired" select="'1'"/>
          </xsl:apply-templates>

          <!-- Hospital Discharge Instructions module -->
          <xsl:apply-templates select="." mode="sHDI-dischargeInstructions"/>

          <!-- Health Concerns module -->
          <xsl:apply-templates select="." mode="sHC-HealthConcerns"/>

          <!-- Custom export -->
          <xsl:apply-templates select="." mode="ExportCustom-ClinicalDocument"/>
        </structuredBody>
      </component>
      <!-- End CCD Body -->
    </ClinicalDocument>
  </xsl:template>

  <xsl:template match="Container" mode="templateId-CCDHeader">
    <templateId root="{$ccda-ContinuityOfCareCCD}"/>
    <templateId root="{$ccda-ContinuityOfCareCCD}" extension="2015-08-01"/>
  </xsl:template>

  <!-- confidentialityCode may be overriden by stylesheets that import this one -->
  <xsl:template match="Container" mode="document-confidentialityCode">
    <confidentialityCode nullFlavor="{$confidentialityNullFlavor}"/>
  </xsl:template>

  <!-- This empty template may be overridden with custom logic. -->
  <xsl:template match="Container" mode="ExportCustom-ClinicalDocument"> </xsl:template>
  
</xsl:stylesheet>
