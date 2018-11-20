<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" exclude-result-prefixes="isc hl7">
  <!-- Entry module has non-parallel name. AlsoInclude: Result.xsl -->

	<xsl:template match="*" mode="sDR-ResultsSection">
		<xsl:variable name="resultsSection" select="key('sectionsByRoot',$ccda-ResultsSectionEntriesOptional) | key('sectionsByRoot',$ccda-ResultsSectionEntriesRequired)"/>	
		<xsl:variable name="resultsNoData"><xsl:apply-templates select="$resultsSection" mode="sDR-IsNoDataSection-Results"/></xsl:variable>
		<xsl:variable name="resultsEntries" select="$resultsSection/hl7:entry[(not(string-length(.//hl7:encounter/hl7:id/@extension)) and not(string-length(.//hl7:encounter/hl7:id/@root))) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@extension,'|')) or contains($encounterIDs,concat('|',.//hl7:encounter/hl7:id/@root,'|'))]"/>
		
		<xsl:choose>
			<xsl:when test="$resultsNoData='1' and $documentActionCode='XFRM'">
				<LabOrders>
					<xsl:apply-templates select="." mode="sDR-LabOrderActionCode"/>
				</LabOrders>
				<RadOrders>
					<xsl:apply-templates select="." mode="sDR-RadOrderActionCode"/>
				</RadOrders>
			</xsl:when>
			<xsl:when test="$resultsEntries and not($resultsNoData='1')">
				<xsl:variable name="filteredEntries" select="$resultsEntries[(.//hl7:organizer)
					                                                       and (string-length(substring-after(.//hl7:procedure/hl7:code/hl7:originalText/hl7:reference/@value, '#'))
					                                                            or not(.//hl7:procedure/hl7:code/@nullFlavor))]"/>
				<!-- Each member of $filteredEntries should be processed in one of the three groups, at most.
				     If it meets the (customizable) criteria for LabOrder, then it goes in that group.
				     Ones that don't qualify as LabOrder will be tested to see if they qualify for the
				     RadOrder group (again, with customizable criteria) and if they don't, then they
				     are put in the OtherOrders group, but only if global variable $enableOtherOrders has
				     been set to 1. See ImportProfile.xsl for further details. -->
				<LabOrders>
					<xsl:if test="isc:evaluate('varSet', 'LabOrderActionCodeDone', '0')"/>
					<xsl:apply-templates select="$filteredEntries" mode="sDR-LabResults"/>
				</LabOrders>
				<RadOrders>
					<xsl:if test="isc:evaluate('varSet', 'RadOrderActionCodeDone', '0')"/>
					<xsl:apply-templates select="$filteredEntries" mode="sDR-RadResults"/>
				</RadOrders>
				<xsl:if test="$enableOtherOrders = 1">
					<OtherOrders>
						<xsl:if test="isc:evaluate('varSet', 'OtherOrderActionCodeDone', '0')"/>
						<xsl:apply-templates select="$filteredEntries" mode="sDR-OtherResults"/>
					</OtherOrders>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="hl7:entry" mode="sDR-LabResults">
		<!-- Insert an order with corresponding Laboratory results-->
		
		<xsl:variable name="resultRootPath" select=".//hl7:organizer[hl7:templateId/@root=$ccda-ResultOrganizer]"/>
		<xsl:variable name="isLabResult"><xsl:apply-templates select="$resultRootPath" mode="sDR-IsLabResult"/></xsl:variable>
		
		<xsl:if test="$isLabResult = 1">
			<xsl:if test="isc:evaluate('varGet', 'LabOrderActionCodeDone')=0">
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'LabOrder'"/>
					<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
					<!--<xsl:with-param name="positionOneRequired" select="'0'"/> not supported by template -->
				</xsl:call-template>
				<xsl:if test="isc:evaluate('varSet', 'LabOrderActionCodeDone', '1')"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="eR-paramName-Result">
				<xsl:with-param name="elementName" select="'LabOrder'"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="hl7:entry" mode="sDR-RadResults">
		<!-- Insert an order with corresponding Radiology results-->
		
		<xsl:variable name="resultRootPath" select=".//hl7:organizer[hl7:templateId/@root=$ccda-ResultOrganizer]"/>
		<xsl:variable name="isRadResult">
			<xsl:apply-templates select="$resultRootPath" mode="sDR-IsRadResult">
				<xsl:with-param name="paramIsLabResult">
					<xsl:apply-templates select="$resultRootPath" mode="sDR-IsLabResult"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
				
		<xsl:if test="$isRadResult = 1">
			<xsl:if test="isc:evaluate('varGet', 'RadOrderActionCodeDone')=0">
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'RadOrder'"/>
					<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
					<!--<xsl:with-param name="positionOneRequired" select="'0'"/> not supported by template -->
				</xsl:call-template>
				<xsl:if test="isc:evaluate('varSet', 'RadOrderActionCodeDone', '1')"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="eR-paramName-Result">
				<xsl:with-param name="elementName" select="'RadOrder'"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="hl7:entry" mode="sDR-OtherResults">
		<!-- Insert an order with corresponding Other results-->
		
		<xsl:variable name="resultRootPath" select=".//hl7:organizer[hl7:templateId/@root=$ccda-ResultOrganizer]"/>
		<xsl:variable name="isLabResult"><xsl:apply-templates select="$resultRootPath" mode="sDR-IsLabResult"/></xsl:variable>
		<xsl:variable name="isRadResult">
			<xsl:apply-templates select="$resultRootPath" mode="sDR-IsRadResult">
				<xsl:with-param name="paramIsLabResult" select="$isLabResult"/>
			</xsl:apply-templates>
		</xsl:variable>
				
		<xsl:if test="$isLabResult = 0 and $isRadResult = 0">
			<xsl:if test="isc:evaluate('varGet', 'OtherOrderActionCodeDone')=0">
				<xsl:call-template name="ActionCode">
					<xsl:with-param name="informationType" select="'OtherOrder'"/>
					<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
					<!--<xsl:with-param name="positionOneRequired" select="'0'"/> not supported by template -->
				</xsl:call-template>
				<xsl:if test="isc:evaluate('varSet', 'OtherOrderActionCodeDone', '1')"></xsl:if>
			</xsl:if>
			<xsl:apply-templates select="." mode="eR-paramName-Result">
				<xsl:with-param name="elementName" select="'OtherOrder'"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="sDR-LabOrderActionCode">
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'LabOrder'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*" mode="sDR-RadOrderActionCode">
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'RadOrder'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*" mode="sDR-OtherOrderActionCode">
		<xsl:call-template name="ActionCode">
			<xsl:with-param name="informationType" select="'OtherOrder'"/>
			<xsl:with-param name="encounterNumber"><xsl:apply-templates select="." mode="fn-EncounterID-Entry"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="hl7:organizer" mode="sDR-IsLabResult">
		<!-- Apply heuristics to determine if this is a lab result.
			
			IsLabResult provides the off-the-shelf criteria for
			determining is/is not a lab result.
			
			You may override the functionality of this template by
			creating the same template in ../../Site/ImportCustom.xsl
			and applying the logic that you desire.  If you create
			the custom template, then the version of the template
			here will not be used at all.
			 
			1. Is the observation explicitly marked as C-CDA result Observation (templateId = 2.16.840.1.113883.10.20.22.4.2)?
			2. Is there a reference range associated with the lab result?
			3. Is the lab result atomic (a collection of test items with specific values, rather than a text result)?
		-->
		<xsl:choose>
			<xsl:when test="hl7:component/hl7:observation/hl7:templateId[@root=$ccda-ResultObservation]">
				<xsl:choose>
					<xsl:when test="hl7:component/hl7:observation/hl7:referenceRange/hl7:observationRange">1</xsl:when>
					<!-- atomic result value has @value when xsi:type=PQ -->
					<xsl:when test="hl7:component/hl7:observation/hl7:value/@value">1</xsl:when>
					<!-- atomic result value has text() when xsi:type=ST -->
					<xsl:when test="string-length(hl7:component/hl7:observation/hl7:value/text())">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:organizer" mode="sDR-IsRadResult">
		<xsl:param name="paramIsLabResult" select="'0'"/>
		
		<!-- IsRadResult provides the off-the-shelf criteria for
			 determining is/is not a rad result. Basically it is
			 "if it's not a lab result, then it's a rad result".
			 
			 You may override the functionality of this template by
			 creating the same template in ../../Site/ImportCustom.xsl
			 and applying the logic that you desire.  If you create
			 the custom template, then the version of the template
			 here will not be used at all.
		-->
		<xsl:choose>
			<xsl:when test="$paramIsLabResult='0'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Determine if a Results section is present but has or indicates no data present.
		This logic is applied only if the section is present.
		The input node spec is $resultsSection.
		Return 1 if the section is present and there is no hl7:entry element.
		Otherwise Return 0 (section is present and appears to include results data).
		
		You may override this template to use custom criteria to determine "No Data" section.
	-->
	<xsl:template match="hl7:section" mode="sDR-IsNoDataSection-Results">
		<xsl:choose>
			<xsl:when test="@nullFlavor">1</xsl:when>
			<xsl:when test="count(hl7:entry)=0">1</xsl:when>
			<xsl:when test="count(hl7:entry)=1 and hl7:entry[1]/hl7:organizer[1]/hl7:id/@nullFlavor and hl7:entry[1]/hl7:organizer[1]/hl7:code/@nullFlavor and not(hl7:entry[1]/hl7:organizer[1]/hl7:code/hl7:originalText) and not(hl7:entry[1]/hl7:organizer[1]/hl7:code/hl7:translation)">1</xsl:when>
			<xsl:when test="count(hl7:entry)=1 and hl7:entry[1]/hl7:organizer[1]/hl7:component/hl7:observation/@negationInd='true' and hl7:entry[1]/hl7:organizer[1]/hl7:component/hl7:observation/hl7:value/@nullFlavor">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>