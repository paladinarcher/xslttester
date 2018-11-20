<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="isc hl7 sdtc xsi exsl">

	<xsl:template match="effectiveTime" mode="DocumentTime">
		<!--<DocumentTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></DocumentTime>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'DocumentTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="IdentificationTime">
		<!--
			Field : Diagnosis Identification Date/Time
			Target: HS.SDA3.Diagnosis IdentificationTime
			Target: /Container/Diagnoses/Diagnosis/IdentificationTime
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.43']/entry/act/entryRelationship/observation/effectiveTime/@value
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.24']/entry/act/entryRelationship/observation/effectiveTime/@value
			Note  : If CDA effectiveTime/@value is not present
					then SDA IdentificationTime is imported from
					effectiveTime/low/@value instead.
		-->
		<xsl:choose>
			<xsl:when test="@value">
				<!--<IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></IdentificationTime>-->
				<xsl:apply-templates select="@value" mode="fn-E-paramName-timestamp">
					<xsl:with-param name="emitElementName" select="'IdentificationTime'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="hl7:low/@value">
				<!--<IdentificationTime><xsl:value-of select="isc:evaluate('xmltimestamp', hl7:low/@value)"/></IdentificationTime>-->
				<xsl:apply-templates select="hl7:low/@value" mode="fn-E-paramName-timestamp">
					<xsl:with-param name="emitElementName" select="'IdentificationTime'"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="BirthTime">
		<!-- now UNUSED -->
		<!--
			Field : Patient Date of Birth
			Target: HS.SDA3.Patient BirthTime
			Target: /Container/Patient/BirthTime
			Source: /ClinicalDocument/recordTarget/patientRole/patient/birthTime
		-->
		<!--<BirthTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></BirthTime>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'BirthTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="hl7:effectiveTime" mode="ObservationTime">
		<!--<ObservationTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ObservationTime>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'ObservationTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="hl7:effectiveTime | hl7:high | hl7:low" mode="ProcedureTime">
		<!--<ProcedureTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ProcedureTime>-->
		<xsl:apply-templates select="@value" mode="fn-E-paramName-timestamp">
			<xsl:with-param name="emitElementName" select="'ProcedureTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="ResultTime">
		<!--
			Field : Result Date/Time
			Target: HS.SDA3.Result ResultTime
			Target: /Container/LabOrders/LabOrder/Result/ResultTime
			Target: /Container/RadOrders/RadOrder/Result/ResultTime
			Target: /Container/OtherOrders/OtherOrder/Result/ResultTime
			Source: /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.3.1']/entry/organizer/effectiveTime/@value
		-->
		<!--<xsl:if test="@value"><ResultTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ResultTime></xsl:if>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'ResultTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Retain fn- versions of some modes until they are totally refactored away -->
	<xsl:template match="hl7:effectiveTime | hl7:time" mode="fn-EnteredOn">
		<!--<EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></EnteredOn>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'EnteredOn'"/>
		</xsl:apply-templates>
	</xsl:template>
	
  <xsl:template match="hl7:effectiveTime | hl7:low" mode="fn-FromTime">
    <!--<xsl:if test="@value"><FromTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></FromTime></xsl:if>-->
    <xsl:apply-templates select="." mode="fn-I-timestamp">
      <xsl:with-param name="emitElementName" select="'FromTime'"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="hl7:effectiveTime | hl7:high" mode="fn-ToTime">
    <!--<xsl:if test="@value"><ToTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ToTime></xsl:if>-->
    <xsl:apply-templates select="." mode="fn-I-timestamp">
      <xsl:with-param name="emitElementName" select="'ToTime'"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="hl7:low | hl7:effectiveTime" mode="fn-StartTime">
    <!--<xsl:if test="@value"><FromTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></FromTime></xsl:if>-->
    <xsl:apply-templates select="." mode="fn-I-timestamp">
      <xsl:with-param name="emitElementName" select="'FromTime'"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="hl7:high | hl7:effectiveTime" mode="fn-EndTime">
    <!--<xsl:if test="@value"><ToTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ToTime></xsl:if>-->
    <xsl:apply-templates select="." mode="fn-I-timestamp">
      <xsl:with-param name="emitElementName" select="'ToTime'"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="hl7:effectiveTime | hl7:time" mode="EnteredOn">
    <!--<EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></EnteredOn>-->
    <xsl:apply-templates select="." mode="fn-I-timestamp">
      <xsl:with-param name="emitElementName" select="'EnteredOn'"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="hl7:effectiveTime | hl7:low" mode="FromTime">
		<!--<xsl:if test="@value"><FromTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></FromTime></xsl:if>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'FromTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="hl7:effectiveTime | hl7:high" mode="ToTime">
		<!--<xsl:if test="@value"><ToTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ToTime></xsl:if>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'ToTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="hl7:low | hl7:effectiveTime" mode="StartTime">
		<!--<xsl:if test="@value"><FromTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></FromTime></xsl:if>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'FromTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="hl7:high | hl7:effectiveTime" mode="EndTime">
		<!--<xsl:if test="@value"><ToTime><xsl:value-of select="isc:evaluate('xmltimestamp', @value)"/></ToTime></xsl:if>-->
		<xsl:apply-templates select="." mode="fn-I-timestamp">
			<xsl:with-param name="emitElementName" select="'ToTime'"/>
		</xsl:apply-templates>
	</xsl:template>
	
  <xsl:template match="*" mode="SendingFacility">
    <!-- This mode is currently UNUSED -->
    <xsl:variable name="facilityInformation"><xsl:apply-templates select="hl7:assignedAuthor/hl7:representedOrganization" mode="fn-P-FacilityInformation"/></xsl:variable>
    <xsl:variable name="flags" select="substring-before(substring-after($facilityInformation, 'F0:'), '|')"/>
    
    <SendingFacility>
      <xsl:choose>
        <xsl:when test="$flags > 1">
          <xsl:value-of select="substring-before(substring-after($facilityInformation, 'F2:'), '|')"/>
        </xsl:when>
        <xsl:when test="($flags mod 2) = 1">
          <xsl:value-of select="substring-before(substring-after($facilityInformation, 'F3:'), '|')"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </SendingFacility>
  </xsl:template>
  
  <xsl:template match="*" mode="Informant">
		<!-- This mode is currently UNUSED -->
		<xsl:choose>
			<xsl:when test="node()"><xsl:apply-templates select="." mode="fn-EnteredAt"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="$defaultInformantRootPath" mode="fn-EnteredAt"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="SDACodingStandard">
		<!-- This mode is currently UNUSED -->
		<xsl:if test="(string-length(@codeSystem)) and (not(@codeSystem=$noCodeSystemOID))">
			<SDACodingStandard>
				<xsl:apply-templates select="." mode="fn-code-for-oid"><xsl:with-param name="OID" select="@codeSystem"/></xsl:apply-templates>
			</SDACodingStandard>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="eM-PatientInstructions">
		<!-- This mode is currently UNUSED -->
		<PatientInstruction><xsl:apply-templates select="." mode="fn-TextValue"/></PatientInstruction>
	</xsl:template>
	
</xsl:stylesheet>