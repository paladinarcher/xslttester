<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">

	<!-- Used to group observations by encounter -->
	<xsl:key name="ObsEncNum" match="/Container/Observations/Observation" use="EncounterNumber" />
	<xsl:key name="ObsEncNum" match="/Container/Observations/Observation[string-length(EncounterNumber) = 0]" use="''" /> 

	<xsl:variable name="validFields" select="'TEMPERATURE,PULSE,BLOOD PRESSURE,WEIGHT,HEIGHT,RESPIRATION,SP02,PAIN,BMI'"/>	

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


	<xsl:template match="*" mode="vitalSigns-Narrative">
		<xsl:param name="validVitalSigns"/>
		
		<!--
			validVitalSigns contains the ObservationCodes of those
			Observations that are okay to export to Vital Signs.
		-->
		<!-- VITAL SIGNS NARRATIVE BLOCK, REQUIRED -->
		<text>
			<!-- VA Medication Business Rules for Medical Content -->
			<paragraph ID="vitalsParagraph">
				This section contains inpatient and outpatient Vital Signs on record at VA for the patient.
         		The data comes from all VA treatment facilities. It includes vital signs collected within
          		the requested date range. If more than one set of vitals was taken on the same date,
              	only the most recent set is populated for that date. If no date range was provided,
              	it includes 12 months of data, with a maximum of the 5 most recent sets of vitals.
            	If more than one set of vitals was taken on the same date, only the most recent set
   				is populated for that date.
           	</paragraph>
			<table ID="vitalNarrative">
			</table>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Date/Time</th>
        				<th>Temperature</th>
        				<th>Pulse</th>
     					<th>Blood Pressure</th>
    					<th>Respiratory Rate</th>
     					<th>SP02</th>
        				<th>Pain</th>
         				<th>Height</th>
                		<th>Weight</th>
                  		<th>Body Mass Index</th>
                 		<th>Source</th>
					</tr>
				</thead>
				<tbody>
					<!-- Vital signs are grouped by encounter -->
					<xsl:for-each select="/Container/Encounters/Encounter">
						<xsl:call-template name="vitalSigns-Narrative-Encounter">
							<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
							<xsl:with-param name="encounterNumber" select="EncounterNumber"/>
							<xsl:with-param name="narrativeLinkSuffix1" select="position()"/>
						</xsl:call-template>
					</xsl:for-each>

					<!-- And get those with no encounter -->
					<xsl:call-template name="vitalSigns-Narrative-Encounter">
						<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
						<xsl:with-param name="encounterNumber" select="''"/>
						<xsl:with-param name="narrativeLinkSuffix1" select="'0'"/>
					</xsl:call-template>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template name="vitalSigns-Narrative-Encounter">
		<xsl:param name="validVitalSigns"/>
		<xsl:param name="encounterNumber"/>
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<!-- Make sure the encounter has valid vital signs before exporting for the encounter. -->
		<xsl:variable name="encounterHasValidVitals">
			<xsl:apply-templates select="/Container/Observations/Observation" mode="encounterHasValids">
				<xsl:with-param name="encounterNumber" select="$encounterNumber"/>
				<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:if test="string-length($encounterHasValidVitals) and count(key('ObsEncNum',$encounterNumber))>0">
			<xsl:apply-templates select="/Container/Observations" mode="vitalSigns-NarrativeDetail-Encounter">
				<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
				<xsl:with-param name="encounterNumber" select="$encounterNumber"/>
				<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="vitalSigns-NarrativeDetail-Encounter">
		<xsl:param name="validVitalSigns"/>
		<xsl:param name="encounterNumber"/>
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<xsl:choose>
			<xsl:when test="string-length($encounterNumber) > 0">
				<xsl:apply-templates select="Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|')) and (EncounterNumber = $encounterNumber)]" mode="observation-Narrative-vitalSign2">
					<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
				</xsl:apply-templates>
	        </xsl:when>
		    
			<xsl:otherwise>
				<xsl:apply-templates select="Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|')) and (string-length(EncounterNumber) = 0)]" mode="observation-Narrative-vitalSign2">
					<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
				</xsl:apply-templates>		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="observation-Narrative-vitalSign2">
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="concat($narrativeLinkSuffix1,'-',position())"/>		
		<xsl:variable name="observationCode">
			<xsl:apply-templates select="ObservationCode" mode="originalTextOrDescriptionOrCode"/>
		</xsl:variable>
		
		<xsl:variable name="observationCodeForUnit">
			<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
		</xsl:variable>
		
		<xsl:variable name="observationUnit">
			<xsl:choose>
				<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
				<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="observationValue">
			<xsl:choose>
				<xsl:when test="string-length(ObservationValue/text()) and string-length($observationUnit)">
					<xsl:value-of select="concat(ObservationValue/text(),' ',$observationUnit)"/>
				</xsl:when>
				<xsl:when test="string-length(ObservationValue/text())">
					<xsl:value-of select="ObservationValue/text()"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<!--
			The NIST MU2 C-CDA validator logs an error if an @ID
			has no reference/@value pointing to it.  Export @ID 
			for Comments only if it has a value.
		-->
		<!-- Create a row for each date -->
	<xsl:choose>
			
		<xsl:when test="(ObservationTime != following-sibling::Observation[1]/ObservationTime or position() = last())"> 

			<xsl:variable name="obsTime">
            	<xsl:value-of select="ObservationTime"/>
            </xsl:variable>	    
			
			<xsl:if test="contains($validFields, ObservationCode/Description/text())">

				<tr ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignNarrative/text(), $narrativeLinkSuffix)}">
					<td>
						<xsl:apply-templates select="ObservationTime" mode="narrativeDateFromODBC"/> 
					</td>	
					<td>
						<xsl:apply-templates select="../.." mode="addTemperatureCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addPulseCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addBloodPressureCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addRespirationCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addSp02Cell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addPainCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addHeightCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addWeightCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:apply-templates select="../.." mode="addBmiCell">
							<xsl:with-param name="observationTime" select="ObservationTime"/>
						</xsl:apply-templates>
					</td>
					<td>
						<xsl:value-of select="EnteredAt/Description/text()"/>
					</td>							
				</tr>				
			</xsl:if>			
		</xsl:when>
		<xsl:when test="(ObservationTime != following-sibling::Observation[1]/ObservationTime)"> 
		
		
		</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="addTemperatureCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'TEMPERATURE' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>		
							
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addRespirationCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'RESPIRATION' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addSp02Cell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'SP02' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addPainCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'PAIN' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if>  
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>
	
	<xsl:template match="*" mode="addHeightCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'HEIGHT' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8302-2'">in</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addBmiCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="string-length(Extension/BMI/text()) and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>
				
				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addSourceCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">			
			<xsl:if test="ObservationCode/Description/text() = 'TEMPERATURE' and ($observationTime = ObservationTime)">
				<xsl:value-of select="EnteredAt/Description/text()"/>
			</xsl:if> 			
		</xsl:for-each>		
	</xsl:template>
	
	<xsl:template match="*" mode="addPulseCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'PULSE' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>

				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
						
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
				
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>
	
	<xsl:template match="*" mode="addWeightCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="ObservationCode/Description/text() = 'WEIGHT' and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>

				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="$observationCodeForUnit = '3141-9'">lbs</xsl:when>
						
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>
						
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addBloodPressureCell">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="/Container/Observations/Observation">	
		
			<xsl:if test="contains(ObservationCode/Description,'BLOOD PRESSURE') and ($observationTime = ObservationTime)">
				<xsl:variable name="observationCodeForUnit">
					<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
				</xsl:variable>

				<xsl:variable name="observationUnit">
					<xsl:choose>
						<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
						<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
						<xsl:when test="$observationCodeForUnit = '8310-5'">F</xsl:when>
						<xsl:when test="$observationCodeForUnit = '1'">mm[Hg]</xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
						<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
					</xsl:choose>
				</xsl:variable>	
				<xsl:variable name="unavailable">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>

				<xsl:variable name="refused">
					<xsl:value-of select="translate(ObservationValue/text(),$uppercase,$lowercase)"/>			
				</xsl:variable>
				
				<xsl:if test="(ObservationValue/text() != '') and ('unavailable' != $unavailable) and ('refused' != $refused)" >		
					<xsl:value-of select="ObservationValue/text()"/><xsl:text> </xsl:text><xsl:value-of select="$observationUnit"/>
				</xsl:if> 
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="*" mode="addWeightCell0">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="Observation">
			<xsl:choose>
				<xsl:when test="(ObservationCode/Description/text() = 'WEIGHT') and ($observationTime = ObservationTime)">
					<!-- <xsl:value-of select="ObservationValue/text()"/> -->
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*" mode="addBloodPressureCell0">
		<xsl:param name="observationTime"/>
		
		<xsl:for-each select="Observation">
			<xsl:choose>
				<xsl:when test="(ObservationCode/Description/text() = 'BLOOD PRESSURE') and ($observationTime = ObservationTime)">
					<!-- <xsl:value-of select="ObservationValue/text()"/> -->
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	           	
	<xsl:template match="*" mode="observation-Narrative-vitalSign">
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="concat($narrativeLinkSuffix1,'-',position())"/>		
		<xsl:variable name="observationCode">
			<xsl:apply-templates select="ObservationCode" mode="originalTextOrDescriptionOrCode"/>
		</xsl:variable>
		
		<xsl:variable name="observationCodeForUnit">
			<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
		</xsl:variable>
		
		<xsl:variable name="observationUnit">
			<xsl:choose>
				<xsl:when test="$observationCodeForUnit = '9279-1'">/min</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8867-4'">/min</xsl:when>
				<xsl:when test="$observationCodeForUnit = '2710-2'">%</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8480-6'">mm[Hg]</xsl:when>
				<xsl:when test="$observationCodeForUnit = '8462-4'">mm[Hg]</xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="observationValue">
			<xsl:choose>
				<xsl:when test="string-length(ObservationValue/text()) and string-length($observationUnit)">
					<xsl:value-of select="concat(ObservationValue/text(),' ',$observationUnit)"/>
				</xsl:when>
				<xsl:when test="string-length(ObservationValue/text())">
					<xsl:value-of select="ObservationValue/text()"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<!--
			The NIST MU2 C-CDA validator logs an error if an @ID
			has no reference/@value pointing to it.  Export @ID 
			for Comments only if it has a value.
		-->
		<!-- Create a row for each date -->
		<xsl:for-each select="*">
		
			<tr ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignNarrative/text(), $narrativeLinkSuffix)}">
				<td><xsl:apply-templates select="ObservationTime" mode="narrativeDateFromODBC"/></td>
				<xsl:choose>
					<xsl:when test="$observationCodeForUnit = '8310-5'">
						<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignValue/text(), $narrativeLinkSuffix)}"><xsl:value-of select="$observationValue"/></td>
					</xsl:when>
					<xsl:otherwise><td/></xsl:otherwise>
				</xsl:choose>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td ID="{concat('vsSource-', position())}"><xsl:value-of select="EnteredAt/Description/text()"/></td>
				<!--	
				<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignIdentifier/text(), $narrativeLinkSuffix)}"><xsl:value-of select="$observationCode"/></td>
				<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignValue/text(), $narrativeLinkSuffix)}"><xsl:value-of select="$observationValue"/></td>
				<xsl:choose>
					<xsl:when test="string-length(Comments/text())">
						<td ID="{concat($exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignComments/text(), $narrativeLinkSuffix)}"><xsl:value-of select="Comments/text()"/></td>
					</xsl:when>
					<xsl:otherwise><td/></xsl:otherwise>
				</xsl:choose>
				-->
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	              	

	<xsl:template match="*" mode="vitalSigns-Entries">
		<xsl:param name="validVitalSigns"/>
		<!-- Vital signs are grouped by encounter -->
		<xsl:for-each select="/Container/Encounters/Encounter">
			<xsl:call-template name="vitalSigns-EntriesEncounter">
				<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
				<xsl:with-param name="encounterNumber" select="EncounterNumber"/>
				<xsl:with-param name="narrativeLinkSuffix1" select="position()"/>
			</xsl:call-template>
		</xsl:for-each>

		<!-- And get those with no encounter -->
		<xsl:call-template name="vitalSigns-EntriesEncounter">
			<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
			<xsl:with-param name="encounterNumber" select="''"/>
			<xsl:with-param name="narrativeLinkSuffix1" select="'0'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="vitalSigns-EntriesEncounter">
		<xsl:param name="validVitalSigns"/>
		<xsl:param name="encounterNumber"/>
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<!-- Make sure the encounter has valid vital signs before exporting for the encounter. -->
		<xsl:variable name="encounterHasValidVitals">
			<xsl:apply-templates select="/Container/Observations/Observation" mode="encounterHasValids">
				<xsl:with-param name="encounterNumber" select="$encounterNumber"/>
				<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:if test="string-length($encounterHasValidVitals) and count(key('ObsEncNum',$encounterNumber))>0">
			<xsl:apply-templates select="/Container/Observations" mode="vitalSigns-EntryDetail">
				<xsl:with-param name="validVitalSigns" select="$validVitalSigns"/>
				<xsl:with-param name="encounterNumber" select="$encounterNumber"/>
				<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="encounterHasValids">
		<xsl:param name="encounterNumber"/>
		<xsl:param name="validVitalSigns"/>
		
		<xsl:if test="string(EncounterNumber/text())=string($encounterNumber) and contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|'))">1</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-EntryDetail">
		<xsl:param name="validVitalSigns"/>
		<xsl:param name="encounterNumber"/>
		<xsl:param name="narrativeLinkSuffix1"/>

		<xsl:variable name="first" select="key('ObsEncNum',$encounterNumber)[1]"/>
		<!-- validVitalSigns contains the ObservationCodes of those Observations that are okay to export to Vital Signs. -->
		<entry>
			<organizer classCode="CLUSTER" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-vitalSignsEntry"/>

				<xsl:apply-templates select="." mode="id-External"/>
				<code code="46680005" codeSystem="{$snomedOID}" codeSystemName="{$snomedName}" displayName="Vital signs"/>
				<statusCode code="completed"/>
				
				<!--
					Field : Vital Sign Author Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/effectiveTime/@value
					Source: HS.SDA3.Observation EnteredOn
					Source: /Container/Observations/Observation/EnteredOn
				-->
				<xsl:choose>
					<xsl:when test="string-length($first/EnteredOn)">
						<xsl:apply-templates select="$first/EnteredOn" mode="effectiveTime"/>
					</xsl:when>
					<xsl:otherwise><effectiveTime nullFlavor="UNK"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--
					Field : Vital Sign Author
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/author
					Source: HS.SDA3.Observation EnteredBy
					Source: /Container/Observations/Observation/EnteredBy
					StructuredMappingRef: author-Human
				-->
				<xsl:apply-templates select="$first/EnteredBy" mode="author-Human"/>
				
				<!--
					Field : Vital Sign Information Source
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/informant
					Source: HS.SDA3.Observation EnteredAt
					Source: /Container/Observations/Observation/EnteredAt
					StructuredMappingRef: informant
				-->
				<xsl:apply-templates select="$first/EnteredAt" mode="informant"/>
				
				<xsl:choose>
					<xsl:when test="string-length($encounterNumber) > 0">
						<xsl:apply-templates select="Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|')) and (EncounterNumber = $encounterNumber)]" mode="observation-vitalSign">
							<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="Observation[contains(concat('|',$validVitalSigns),concat('|',ObservationCode/Code/text(),'|')) and (string-length(EncounterNumber) = 0)]" mode="observation-vitalSign">
							<xsl:with-param name="narrativeLinkSuffix1" select="$narrativeLinkSuffix1"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!--
					Field : Vital Sign Encounter
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component
					Source: HS.SDA3.Observation EncounterNumber
					Source: /Container/Observations/Observation/EncounterNumber
					StructuredMappingRef: encounterLink-component
					Note  : This links the Vital Sign observation to an encounter in the Encounters section.
				-->
				<xsl:apply-templates select="$first" mode="encounterLink-component"/>
			</organizer>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="vitalSigns-NoData">
		<text><xsl:value-of select="$exportConfiguration/vitalSigns/emptySection/narrativeText/text()"/></text>
	</xsl:template>

	<xsl:template match="*" mode="observation-vitalSign">
		<xsl:param name="narrativeLinkSuffix1"/>
		
		<xsl:variable name="narrativeLinkSuffix" select="concat($narrativeLinkSuffix1,'-',position())"/>		
		
		<component>
			<observation classCode="OBS" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-vitalSignObservation"/>
				
				<!--
					Field : Vital Sign Id
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/id
					Source: HS.SDA3.Observation ExternalId
					Source: /Container/Observations/Observation/ExternalId
					StructuredMappingRef: id-External
				-->
				<xsl:apply-templates select="." mode="id-External"/>
				
				<xsl:apply-templates select="ObservationCode" mode="observation-code"/>
				
				<text><reference value="{concat('#', $exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignNarrative/text(), $narrativeLinkSuffix)}"/></text>
				<statusCode code="completed"/>
				
				<!--
					Field : Vital Sign Observation Time
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/effectiveTime/@value
					Source: HS.SDA3.Observation ObservationTime
					Source: /Container/Observations/Observation/ObservationTime
				-->
				<xsl:choose>
					<xsl:when test="string-length(ObservationTime/text())">
						<xsl:apply-templates select="ObservationTime" mode="effectiveTime"/>
					</xsl:when>
					<xsl:otherwise>
						<effectiveTime nullFlavor="UNK"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:apply-templates select="." mode="observation-value"/>
				
				<!--
					Field : Vital Sign Clinician
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/performer
					Source: HS.SDA3.Observation Clinician
					Source: /Container/Observations/Observation/Clinician
					StructuredMappingRef: performer
				-->
				<xsl:apply-templates select="Clinician" mode="performer"/>
				
				<xsl:apply-templates select="." mode="observation-vitalSignStatus"/>
				
				<!--
					Field : Vital Sign Comments
					Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/entryRelationship/act[code/@code='48767-8']/text
					Source: HS.SDA3.Observation Comments
					Source: /Container/Observations/Observation/Comments
				-->
				<xsl:apply-templates select="Comments" mode="comment-entryRelationship"><xsl:with-param name="narrativeLink" select="concat('#', $exportConfiguration/vitalSigns/narrativeLinkPrefixes/vitalSignComments/text(), $narrativeLinkSuffix)"/></xsl:apply-templates>
			</observation>
		</component>
	</xsl:template>

	<xsl:template match="*" mode="observation-vitalSignStatus">
		<!--
			The Consolidated CDA spec states that Status should be
			hard-coded to "completed" and expresed in statusCode/@code
			as part of the vital sign component/observation.  This
			entryRelationsip for Status is being retained only for
			backward compatibility for consumers who may be using it.
		-->
		<entryRelationship typeCode="REFR">
			<observation classCode="OBS" moodCode="EVN">
				<xsl:apply-templates select="." mode="templateIds-vitalSignObservationStatus"/>
				
				<code code="33999-4" displayName="Status" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
				<statusCode code="completed"/>				
				<value xsi:type="CE" code="completed" codeSystem="{$actStatusOID}" codeSystemName="{$actStatusName}" displayName="completed"/>
			</observation>
		</entryRelationship>
	</xsl:template>

	<xsl:template match="*" mode="observation-value">
		<!--
			Field : Vital Sign Result Value
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/value/@value
			Source: HS.SDA3.Observation ObservationValue
			Source: /Container/Observations/Observation/ObservationValue
		-->
		<!--
			Field : Vital Sign Result Value Units
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/value/@unit
			Source: HS.SDA3.Observation ObservationCode.ObservationValueUnits
			Source: /Container/Observations/Observation/ObservationCode/ObservationValueUnits
		-->
				
		<!--
			ObservationValue is a String that may be just be a
			value, or a value and unit, separated by a space.
		-->
		<xsl:variable name="obsVal">
			<xsl:choose>
				<xsl:when test="string-length(substring-before(ObservationValue/text(), ' '))"><xsl:value-of select="substring-before(ObservationValue/text(), ' ')"/></xsl:when>
				<xsl:when test="string-length(ObservationValue/text()) and not(string-length(substring-before(ObservationValue/text(), ' ')))"><xsl:value-of select="ObservationValue/text()"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="codeValue">
			<xsl:apply-templates select="ObservationCode" mode="getObservationCode"/>
		</xsl:variable>
		
		<!--
			Use the LOINC code to determine the unit. If not able to get it
			from LOINC code, see if it was included in ObservationValue.
		-->
		<xsl:variable name="obsUnit">
			<xsl:choose>
				<xsl:when test="$codeValue = '9279-1'">/min</xsl:when>
				<xsl:when test="$codeValue = '8867-4'">/min</xsl:when>
				<xsl:when test="$codeValue = '2710-2'">%</xsl:when>
				<xsl:when test="$codeValue = '8480-6'">mm[Hg]</xsl:when>
				<xsl:when test="$codeValue = '8462-4'">mm[Hg]</xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Code/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Code/text()"/></xsl:when>
				<xsl:when test="string-length(ObservationCode/ObservationValueUnits/Description/text())"><xsl:value-of select="ObservationCode/ObservationValueUnits/Description/text()"/></xsl:when>
				<xsl:when test="string-length(substring-after(ObservationValue/text(), ' '))"><xsl:value-of select="substring-after(ObservationValue/text(), ' ')"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<value>
			<xsl:choose>
				<xsl:when test="number($obsVal)">
					<xsl:attribute name="xsi:type">PQ</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$obsVal"/></xsl:attribute>
					<xsl:attribute name="unit"><xsl:value-of select="$obsUnit"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xsi:type">ST</xsl:attribute>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</value>
	</xsl:template>

	<xsl:template match="*" mode="observation-code">
		<!--
			Field : Vital Sign Result Type (Vital Sign LOINC Code)
			Target: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.4.1']/entry/organizer/component/observation/id
			Source: HS.SDA3.Observation ObservationCode
			Source: /Container/Observations/Observation/ObservationCode
		-->
		
		<xsl:variable name="sdaCodingStandardOID"><xsl:apply-templates select="." mode="oid-for-code"><xsl:with-param name="Code" select="SDACodingStandard/text()"/></xsl:apply-templates></xsl:variable>
		
		<xsl:variable name="codeSystemOIDForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="$sdaCodingStandardOID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemOID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystemNameForTranslation">
			<xsl:choose>
				<xsl:when test="string-length($sdaCodingStandardOID)"><xsl:value-of select="SDACodingStandard/text()"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$noCodeSystemName"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="description"><xsl:apply-templates select="." mode="descriptionOrCode"/></xsl:variable>

		<xsl:choose>
			<!--
				If there is Code text, then work with it, otherwise code nullFlavor=UNK.
				$loincVitalSignCodes is a global variable set up in Variables.xsl.
			-->

			<xsl:when test="string-length(Code/text())">
				<xsl:variable name="isValidLoincCode" select="contains($loincVitalSignCodes, concat('|', Code/text(), '|'))"/>
				<xsl:choose>
				
					<!--
						If LOINC code system and valid LOINC code then export
						the data as is.
					-->
					<xsl:when test="($sdaCodingStandardOID=$loincOID) and ($isValidLoincCode)">
						<code code="{Code/text()}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{$description}">
							<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>
					
					<!--
						If valid LOINC code but not the LOINC code system then
						export the data with LOINC code system plugged in, and
						export a <translation> with the data and code system
						that was actually received.
					-->
					<xsl:when test="$isValidLoincCode">
						<code code="{Code/text()}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{$description}">
							<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
							<translation code="{Code/text()}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{$description}"/>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:when>
					
					<!-- Otherwise, it's not a LOINC code, try to make it one. -->
					<xsl:otherwise>
						<xsl:variable name="codeValue">
							<xsl:apply-templates select="." mode="getObservationCode"/>
						</xsl:variable>
						<code code="{translate($codeValue,' ','_')}" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="{$description}">
							<originalText><xsl:apply-templates select="." mode="originalTextOrDescriptionOrCode"/></originalText>
							<translation code="{translate(Code/text(),' ','_')}" codeSystem="{$codeSystemOIDForTranslation}" codeSystemName="{$codeSystemNameForTranslation}" displayName="{$description}"/>
							<xsl:apply-templates select="PriorCodes/PriorCode[Type='O']" mode="translation"/>					
						</code>
					</xsl:otherwise>
		
				</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<code nullFlavor="UNK"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="getObservationCode">		
		<!--
			The ObservationCode Code and Description are evaluated
			to determine which LOINC code this Observation is or
			can be construed as.
			
			$loincVitalSignCodes is a global variable set up in Variables.xsl.
		-->
		<xsl:variable name="descUpper" select="translate(Description/text(), $lowerCase, $upperCase)"/>
		<xsl:choose>
			<xsl:when test="contains($loincVitalSignCodes, concat('|', Code/text(), '|'))"><xsl:value-of select="Code/text()"/></xsl:when>
			<xsl:when test="contains($descUpper, 'SYSTOLIC')">8480-6</xsl:when>
			<xsl:when test="contains($descUpper, 'DIASTOLIC')">8462-4</xsl:when>
			<xsl:when test="contains($descUpper, 'TEMP')">8310-5</xsl:when>
			<xsl:when test="contains($descUpper, 'HEIGHT')">8302-2</xsl:when>
			<xsl:when test="contains($descUpper, 'HEART RATE')">8867-4</xsl:when>
			<xsl:when test="contains($descUpper, 'PULSE')">8867-4</xsl:when>
			<xsl:when test="contains($descUpper, 'WEIGHT')">3141-9</xsl:when>
			<xsl:when test="contains($descUpper, 'O2 SAT')">2710-2</xsl:when>
			<xsl:when test="contains($descUpper, 'O2SAT')">2710-2</xsl:when>
			<xsl:when test="contains($descUpper, 'SO2')">2710-2</xsl:when>
			<xsl:when test="contains($descUpper, 'CRANIUM')">8287-5</xsl:when>
			<xsl:when test="contains($descUpper, 'SKULL')">8287-5</xsl:when>
			<xsl:when test="contains($descUpper, 'HEAD')">8287-5</xsl:when>
			<xsl:when test="contains($descUpper, 'RESPIRATORY')">9279-1</xsl:when>
			<xsl:when test="contains($descUpper, 'RESP RATE')">9279-1</xsl:when>
			<xsl:when test="contains($descUpper, 'RESPIRATION')">9279-1</xsl:when>
			<xsl:when test="contains($descUpper, 'BMI')">39156-5</xsl:when>
			<xsl:when test="contains($descUpper, 'BODY MASS')">39156-5</xsl:when>
			<xsl:when test="contains($descUpper, 'BLOOD PRESSURE')">8480-6</xsl:when>
			<xsl:otherwise><xsl:value-of select="Code/text()"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-vitalSignsEntry">
		<templateId root="{$ccda-VitalSignsOrganizer}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-vitalSignObservation">
		<templateId root="{$ccda-VitalSignObservation}"/>
	</xsl:template>
	
	<xsl:template match="*" mode="templateIds-vitalSignObservationStatus">
		<xsl:if test="$hl7-CCD-StatusObservation"><templateId root="{$hl7-CCD-StatusObservation}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
