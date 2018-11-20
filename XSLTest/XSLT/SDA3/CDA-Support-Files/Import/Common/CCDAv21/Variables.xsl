<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com"
  xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="isc hl7 xsi exsl">

  <!--
		documentHeaderItems is a vertical bar-delimited list of CDA
		document header items to import to SDA3 AdditionalDocumentInfo.
	-->
  <xsl:param name="documentHeaderItems" select="''"/>
  
  <xsl:variable name="documentHeaderItemsList">
    <xsl:choose>
      <!--
				If an "all" indicator was passed in, then set $documentHeaderItemsList to
				all items from POCD_MT000040.ClinicalDocument except for realmCode, typeId,
				templateId, code, languageCode, component.
			-->
      <xsl:when test="translate($documentHeaderItems,'al','AL')='ALL' or $documentHeaderItems='*'">
        <xsl:value-of select="'|id|title|effectiveTime|confidentialityCode|setId|versionNumber|copyTime|recordTarget|author|dataEnterer|informant|custodian|informationRecipient|legalAuthenticator|authenticator|participant|inFulfillmentOf|documentationOf|relatedDocument|authorization|componentOf|'"/>
      </xsl:when>
      <xsl:when test="string-length($documentHeaderItems)">
        <xsl:value-of select="concat('|',$documentHeaderItems,'|')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="currentDateTime" select="isc:evaluate('timestamp')"/>
	<xsl:variable name="documentDateTime" select="$input/hl7:effectiveTime/@value"/>
	<xsl:variable name="documentActionCode" select="$input/hl7:relatedDocument/@typeCode"/>
	<xsl:variable name="sdaActionCodesEnabled" select="exsl:node-set($generalImportConfiguration)/sdaActionCodes/enabled/text()"/>
	<xsl:variable name="sdaOverrideExternalId" select="exsl:node-set($generalImportConfiguration)/sdaActionCodes/overrideExternalId/text()"/>
  <xsl:variable name="blockImportCTDCodeFromText" select="exsl:node-set($generalImportConfiguration)/blockImportCTDCodeFromText/text()"/>
  <!-- For repOrgconcatIdRootAndNumericExt the value in ImportProfile.xsl must be '1' or missing altogether in order to enable concat. -->
	<xsl:variable name="repOrgconcatIdRootAndNumericExt">
	  <xsl:variable name="sourceCRANE" select="exsl:node-set($generalImportConfiguration)/representedOrganizationId/concatRootAndNumericExtension/text()"/>
	  <xsl:choose>
	    <xsl:when test="$sourceCRANE='0'">0</xsl:when>
	    <xsl:when test="$sourceCRANE='1'">1</xsl:when>
	    <xsl:when test="not(string-length($sourceCRANE))">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="sectionRootPath" select="$input/hl7:component/hl7:structuredBody/hl7:component/hl7:section"/>
	<xsl:variable name="nonXMLBodyRootPath" select="$input/hl7:component/hl7:nonXMLBody"/>
	<xsl:variable name="defaultAuthorRootPath" select="$input/hl7:author[not(hl7:assignedAuthor/hl7:assignedAuthoringDevice)]"/>
	<xsl:variable name="defaultAuthoringDeviceRootPath" select="$input/hl7:author[hl7:assignedAuthor/hl7:assignedAuthoringDevice]"/>
	<xsl:variable name="defaultInformantRootPath" select="$input/hl7:informant"/>
	
	<xsl:variable name="narrativeImportModeGeneral">
		<xsl:choose>
			<xsl:when test="string-length(exsl:node-set($generalImportConfiguration)/narrativeImportMode/text())">
				<xsl:value-of select="exsl:node-set($generalImportConfiguration)/narrativeImportMode/text()"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="orderItemDefaultCode" select="exsl:node-set($resultsImportConfiguration)/orderItemDefaultCode/text()"/>
	<xsl:variable name="orderItemDefaultDescription" select="exsl:node-set($resultsImportConfiguration)/orderItemDefaultDescription/text()"/>
	
	<!-- Medications PharmacyStatus -->
	<xsl:variable name="dischargeMedicationsPharmacyStatus">
		<xsl:choose>
			<xsl:when test="string-length(exsl:node-set($dischargeMedicationsImportConfiguration)/pharmacyStatus/text())">
				<xsl:value-of select="exsl:node-set($dischargeMedicationsImportConfiguration)/pharmacyStatus/text()"/>
			</xsl:when>
			<xsl:otherwise>DISCHARGE</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="medicationsPharmacyStatus">
		<xsl:choose>
			<xsl:when test="string-length(exsl:node-set($medicationsImportConfiguration)/pharmacyStatus/text())">
				<xsl:value-of select="exsl:node-set($medicationsImportConfiguration)/pharmacyStatus/text()"/>
			</xsl:when>
			<xsl:otherwise>MEDICATIONS</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="medicationsAdministeredPharmacyStatus">
		<xsl:choose>
			<xsl:when test="string-length(exsl:node-set($medicationsAdministeredImportConfiguration)/pharmacyStatus/text())">
				<xsl:value-of select="exsl:node-set($medicationsAdministeredImportConfiguration)/pharmacyStatus/text()"/>
			</xsl:when>
			<xsl:otherwise>ADMINISTERED</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Global variable to hold mapping of CDA encounter codes to SDA EncounterType -->
	<xsl:variable name="encounterTypeMaps" select="exsl:node-set($encountersImportConfiguration)/encounterTypeMaps"/>
	
	<!-- Global variables to hold lower case string and upper case string -->
	<xsl:variable name="lowerCase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="upperCase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="encompassingEncounterID">
	  <!-- encompassingEncounter ID, if any -->
	  <xsl:choose>
			<xsl:when test="string-length($input/hl7:componentOf/hl7:encompassingEncounter/hl7:id/@extension)">
				<xsl:value-of select="$input/hl7:componentOf/hl7:encompassingEncounter/hl7:id/@extension"/>
			</xsl:when>
			<xsl:when test="string-length($input/hl7:componentOf/hl7:encompassingEncounter/hl7:id/@root)">
				<xsl:value-of select="$input/hl7:componentOf/hl7:encompassingEncounter/hl7:id/@root"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="encounterIDs">
	  <!-- encounterIDs is a vertical bar-delimited string of encounter ids. -->
	  <xsl:apply-templates select="$input" mode="cV-getEncounterIDs">
			<xsl:with-param name="encompassingEncounterID" select="$encompassingEncounterID"/>
		</xsl:apply-templates>
	</xsl:variable>
	
	<xsl:variable name="encounterCount">
	  <!-- encounterCount is the number of encounters in this document, based on $encounterIDs. -->
	  <xsl:choose>
			<xsl:when test="(string-length(translate($encounterIDs,translate($encounterIDs,'|',''),''))-1)>0">
				<xsl:value-of select="string-length(translate($encounterIDs,translate($encounterIDs,'|',''),''))-1"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="*" mode="cV-getEncounterIDs">
		<xsl:param name="encompassingEncounterID"/>
	  <!-- Gather all of the Encounter IDs into a vertical bar-delimited string. -->
	  
		<xsl:if test="string-length($encompassingEncounterID)"><xsl:value-of select="concat('|',$encompassingEncounterID)"/></xsl:if>
		<xsl:variable name="encountersSectionEncounterIDs">
			<xsl:apply-templates select="(key('sectionsByRoot',$ccda-EncountersSectionEntriesOptional) | key('sectionsByRoot',$ccda-EncountersSectionEntriesRequired))/hl7:entry" mode="cV-getEncounterIdFromEntry"/>
		</xsl:variable>
		<xsl:if test="string-length($encountersSectionEncounterIDs)"><xsl:value-of select="$encountersSectionEncounterIDs"/></xsl:if>
		<xsl:if test="string-length($encountersSectionEncounterIDs) or string-length($encompassingEncounterID)">|</xsl:if>
	</xsl:template>
	
	<xsl:template match="hl7:entry" mode="cV-getEncounterIdFromEntry">
		<!--
			encounterIDTemp is used as an intermediate so that encounterID
			can be set up such that "000nnn" does NOT match "nnn" when
			comparing encounter numbers.
		-->
		<xsl:variable name="encounterIDTemp">
			<xsl:choose>
				<xsl:when test="string-length(hl7:encounter/hl7:id/@extension)">
					<xsl:value-of select="hl7:encounter/hl7:id/@extension"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="hl7:encounter/hl7:id/@root"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:value-of select="concat('|',string($encounterIDTemp))"/>
	</xsl:template>
	
  <!-- $input is a global variable defined in the top-level transform to be the result of
       a pre-processing phase, if any, or just the top /hl7:ClinicalDocument node of the
       original source document if no pre-processing is needed. Setting a global variable
       allows for easy introduction of pre-processing. -->
  
</xsl:stylesheet>