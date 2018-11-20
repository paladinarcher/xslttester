<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:isc="http://extension-functions.intersystems.com" exclude-result-prefixes="isc">
	<!-- Three extra entry modules used. AlsoInclude: Comment.xsl Encounter.xsl Medication.xsl PlanOfTreatment.xsl -->

	<xsl:template match="*" mode="sPOT-planOfTreatment">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<!-- These status codes disqualify an order from appearing in Plan of Care/Treatment. -->
		<xsl:variable name="notPlanOfTreatmentStatus">|C|D|E|I|R|</xsl:variable>
    <xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/planOfCare/emptySection/exportData/text()"/>

		<xsl:variable name="hasPlanofTreatmentData">
      <xsl:apply-templates select="." mode="sPOT-planOfTreatment-hasData">
        <xsl:with-param name="notPlanOfTreatmentStatus" select="$notPlanOfTreatmentStatus" />
      </xsl:apply-templates>
		</xsl:variable>

		<xsl:if test="($hasPlanofTreatmentData='true') or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="$hasPlanofTreatmentData='false'"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sPOT-templateIds-planOfTreatmentSection"/>
					
					<code code="18776-5" displayName="Treatment Plan" codeSystem="{$loincOID}" codeSystemName="{$loincName}"/>
					<title>Plan of Treatment</title>
					
					<xsl:choose>
						<xsl:when test="$hasPlanofTreatmentData='true'">
							<xsl:apply-templates select="." mode="ePOT-planOfTreatment-Narrative">
								<xsl:with-param name="disqualifyCodes" select="$notPlanOfTreatmentStatus"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="." mode="ePOT-planOfTreatment-Entries">
								<xsl:with-param name="disqualifyCodes" select="$notPlanOfTreatmentStatus"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="ePOT-planOfTreatment-NoData"/>
						</xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="sPOT-planOfTreatment-hasData">
    <xsl:param name="notPlanOfTreatmentStatus" />

		<!-- For orders, look at the Status. For other items, look at whether the pertinent date is in the future (i.e. dateDiff is less than zero). -->
		<xsl:variable name="hasDataLabOrders" select="count(LabOrders/LabOrder[not(Result) and not(contains($notPlanOfTreatmentStatus,concat('|',Status/text(),'|')))])"/>
		<xsl:variable name="hasDataRadOrders" select="count(RadOrders/RadOrder[not(Result) and not(contains($notPlanOfTreatmentStatus,concat('|',Status/text(),'|')))])"/>
		<xsl:variable name="hasDataOtherOrders" select="count(OtherOrders/OtherOrder[not(Result) and not(contains($notPlanOfTreatmentStatus,concat('|',Status/text(),'|')))])"/>
		<xsl:variable name="hasDataAppointments" select="count(Appointments/Appointment[isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) &lt; 0])"/>
		<xsl:variable name="hasDataReferrals" select="count(Referrals/Referral[not(string-length(ToTime/text())) or isc:evaluate('dateDiff', 'dd', translate(ToTime/text(), 'TZ', ' ')) &lt; 0])"/>
		<xsl:variable name="hasDataMedications" select="count(Medications/Medication[isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) &lt;= 0 and not(contains($notPlanOfTreatmentStatus,concat('|',Status/text(),'|')))])"/>
		<!-- for each Procedure, check its ProcedureTime if available, else check its FromTime. -->
		<xsl:variable name="hasDataProcedures" select="count(Procedures/Procedure[(string-length(ProcedureTime/text()) and isc:evaluate('dateDiff', 'dd', translate(ProcedureTime/text(), 'TZ', ' ')) &lt; 0)
			or (not(string-length(ProcedureTime/text())) and string-length(FromTime/text()) and isc:evaluate('dateDiff', 'dd', translate(FromTime/text(), 'TZ', ' ')) &lt; 0)])"/>
		<xsl:variable name="hasDataInstructions" select="count(Documents/Document[DocumentType/Description/text()='PlanOfCareInstruction' or DocumentType/Code/text()='PlanOfCareInstruction'])"/>
		<xsl:variable name="hasDataGoals" select="count(Goals/Goal) &lt; 0"/>		

		<xsl:variable name="hasData" select="$hasDataLabOrders or $hasDataRadOrders or $hasDataOtherOrders or $hasDataAppointments or $hasDataReferrals or $hasDataMedications or $hasDataProcedures or $hasDataInstructions or hasDataGoals"/>

		<xsl:value-of select="$hasData"/>

	</xsl:template>

	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sPOT-templateIds-planOfTreatmentSection">
		<templateId root="{$ccda-PlanOfCareSection}"/>
		<templateId root="{$ccda-PlanOfCareSection}" extension="2014-06-09"/>
	</xsl:template>
	
</xsl:stylesheet>