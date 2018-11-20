<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<!-- Copies the outer report container, then selects portions of the filtered SDA -->
 <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
 <!-- Add SDA for each section, under the specified section names -->
 <xsl:template match="Section">
<xsl:element name="{@name}" >
 
<xsl:apply-templates select="Container/Patients/Patient">
<xsl:with-param name="infotype" select="@infotype"></xsl:with-param>
 <!-- Use an arbitrarly high limit in the calculations if no limit was specified-->
<xsl:with-param name="limit">
<xsl:choose>
<xsl:when test="@limit=''">
9999</xsl:when>
<xsl:otherwise>
<xsl:value-of select="@limit"/></xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:apply-templates>
</xsl:element>
</xsl:template>
 
  <!-- Select and sort entries from the filtered SDA under each section for the patient  -->
 <xsl:template match="Patient">
 <xsl:param name="infotype"></xsl:param>
 <xsl:param name="limit"></xsl:param>

<xsl:choose>
<xsl:when test="$infotype='PAT'">
    <xsl:copy>
      <xsl:apply-templates/>
	<xsl:element name="HealthFunds">
		<xsl:apply-templates select="//Encounter/HealthFunds/HealthFund" />
	 </xsl:element>
      <xsl:element name="HealthCareFacilities">
      	<xsl:apply-templates select="//Encounter/HealthCareFacility" />
     </xsl:element>
    </xsl:copy>
</xsl:when>

<xsl:when test="$infotype='ALG'">
<xsl:for-each select="Allergies/Allergies">
<xsl:sort select="FromTime" order="descending"/>
<xsl:if test="(position() &lt;= $limit)">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='ART'">
<xsl:for-each select="Alerts/Alert">
<xsl:sort select="FromTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='HIS'">
<xsl:for-each select="PastHistory/PastHistory | FamilyHistory/FamilyHistory | SocialHistory/SocialHistory">
<xsl:sort select="FromTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='ENC'">
<xsl:element name="EncounterDates">
<xsl:for-each select="Encounters/Encounter[EncounterType != 'S']">
	<xsl:sort select="StartTime" order="descending"/>
	<xsl:if test="position() &lt;= $limit">
		<xsl:element name="StartDate">
			<xsl:value-of select="substring-before(StartTime, &quot;T&quot;)"/>
		</xsl:element>
		<xsl:element name="EndDate">
			<xsl:choose>
				<xsl:when test="EndTime">
					<xsl:value-of select="substring-before(EndTime, &quot;T&quot;)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="isc:evaluate('currentDate')"/> 
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:if>
</xsl:for-each>
</xsl:element>
<xsl:for-each select="Encounters/Encounter[EncounterType != 'S']">
<xsl:sort select="StartTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='DXG'">
<xsl:for-each select="Encounters/Encounter/Diagnoses/Diagnosis">
<xsl:sort select="EnteredOn" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='OBS'">
<xsl:for-each select="Encounters/Encounter/Observations/Observation">
<xsl:sort select="ObservationTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='DOC'">
<xsl:for-each select="Encounters/Encounter/Documents/Document">
<xsl:sort select="TranscriptionTime" order="descending"/>
<xsl:sort select="EnteredOn" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='PRB'">
<xsl:for-each select="Encounters/Encounter/Problems/Problem">
<xsl:sort select="FromTime" order="descending"/>
<xsl:sort select="ToTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='RAD'">
<xsl:for-each select="Encounters/Encounter/Results/Result">
<xsl:sort select="InitiatingOrder/StartTime" order="descending"/>
<xsl:sort select="ResultTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='LAB'">
<xsl:for-each select="Encounters/Encounter/Results/LabResult">
<xsl:sort select="InitiatingOrder/StartTime" order="descending"/>
<xsl:sort select="ResultTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
    <xsl:copy>
      <xsl:apply-templates />
    </xsl:copy>
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='MED'">
<xsl:for-each select=".//Medications/Medication">
<xsl:sort select="StartTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='VXU'">
<xsl:for-each select=".//Medications/Medication">
<xsl:sort select="StartTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>

<xsl:when test="$infotype='OTH'">
<xsl:for-each select=".//Orders/Order">
<xsl:sort select="StartTime" order="descending"/>
<xsl:if test="position() &lt;= $limit">
<xsl:copy-of select="." /> 
</xsl:if>
</xsl:for-each>
</xsl:when>
</xsl:choose>

</xsl:template>

 <!-- Ignore the first patient address, as the primary address is always(!) repeated in the Address list -->
<xsl:template match="Container/Patients/Patient/Address">
	<xsl:element name="Address"> 
	<xsl:for-each select="Address">
		<xsl:if test="position() &gt; 1">
			<xsl:copy-of select="." /> 
		</xsl:if>
	</xsl:for-each>
	</xsl:element>
</xsl:template>


 <!-- Add calculated Result elements for display -->
<xsl:template match="LabResultItem">
	<xsl:element name="LabResultItem"> 
		<xsl:apply-templates/>
		<xsl:variable name="resultFlag">
			<xsl:value-of select="isc:evaluate('resultFlag',ResultValue,ResultNormalRange)" />
		</xsl:variable>
		<xsl:element name="ResultAbnormal">	
			<xsl:choose>
				<xsl:when test="ResultInterpretation and contains('AAHHLL',ResultInterpretation)">true</xsl:when>
				<xsl:when test="ResultInterpretation='N'">false</xsl:when>
				<xsl:otherwise><xsl:value-of select="$resultFlag!='' and contains('HL',$resultFlag)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="RangeResult">
			<xsl:value-of select="$resultFlag" />
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="HealthFunds/HealthFund">
 <xsl:if test="not(. = preceding::HealthFund)">
    <xsl:copy>
     <xsl:apply-templates select="@*|node()" /> 
  </xsl:copy>
 </xsl:if>
</xsl:template>
 
<xsl:template match="HealthCareFacility">
 <xsl:if test="not(. = preceding::HealthCareFacility)">
    <xsl:copy>
     <xsl:apply-templates select="@*|node()" /> 
  </xsl:copy>
 </xsl:if>
</xsl:template>

</xsl:stylesheet>
