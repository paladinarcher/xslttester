<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:isc="http://extension-functions.intersystems.com">

<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
 
<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>


<!-- past history -->
<xsl:template match="/Container/IllnessHistories/IllnessHistory">
	<xsl:if test="isc:evaluate(EncounterNumber,FromTime,'PastHistory')=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- allergies-->
<xsl:template match="/Container/Allergies/Allergy">
	<xsl:if test="isc:evaluate(EncounterNumber,FromTime,'Allergies')=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- encounter Start Date -->
<xsl:template match="/Container/Encounters">
	<xsl:copy>
	<xsl:for-each select="Encounter">
		<xsl:if test="isc:evaluate(EncounterNumber,FromTime,'Encounter')=1">
		  <xsl:copy>
		    <xsl:apply-templates select="@* | node()"/>
		  </xsl:copy>
		</xsl:if>
	</xsl:for-each>
	</xsl:copy>
</xsl:template>

<!-- process orders with no results-->
<xsl:template match="/Container/LabOrders/LabOrder[not(Result)] | /Container/RadOrders/RadOrder[not(Result)] |/Container/OtherOrders/OtherOrder[not(Result)]">
	<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Plan','OrderCategory',OrderCategory/Code,OrderCategory/SDACodingStandard)=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- process lab orders with results -->
<xsl:template match="/Container/LabOrders/LabOrder[Result]">
	<xsl:if test="isc:evaluate(EnteredOn,'LabResult','ConfidentialityCode',ConfidentialityCode/Code,ConfidentialityCode/SDACodingStandard)=1">
		<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'LabResult','OrderItem',OrderItem/Code,OrderItem/SDACodingStandard)=1 and
		              isc:evaluate(EncounterNumber,EnteredOn,'LabResult','LabResultOrderCategory',OrderCategory/Code,OrderCategory/SDACodingStandard)=1 and
		              isc:evaluate(EncounterNumber,EnteredOn,'Result','ResultOrderCategory',OrderCategory/Code,OrderCategory/SDACodingStandard)=1">
			<xsl:copy>
			    <xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!-- process Radiology orders with results-->
<xsl:template match="/Container/RadOrders/RadOrder[Result]">
	<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Radiology')=1 and
	              isc:evaluate(EncounterNumber,EnteredOn,'Result','ResultOrderCategory',OrderCategory/Code,OrderCategory/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>

<!-- process other orders with results-->
<xsl:template match="/Container/OtherOrders/OtherOrder/Result">
	<xsl:if test="isc:evaluate(../EncounterNumber,../EnteredOn,'Result','ResultOrderCategory',../OrderCategory/Code,../OrderItem/OrderCategory/SDACodingStandard)=1">
		<xsl:copy>
			 <xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>

<!-- process lab results -->
<xsl:template match="/Container/LabOrders/LabOrder/Result/ResultItems/LabResultItem">
	<xsl:if test="isc:evaluate(../../../EncounterNumber,../../ResultTime,'LabResult','LabResultItem',TestItemCode/Code,TestItemCode/SDACodingStandard)=1">
		<xsl:copy>
		    <xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>


<!-- process diagnoses -->
<xsl:template match="/Container/Diagnoses/Diagnosis">
	<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Diagnosis','DiagnosisCode',Diagnosis/Code,Diagnosis/SDACodingStandard)=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template>  

<!-- process medications -->
<xsl:template match="/Container/Medications/Medication">
	<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Medication','ConfidentialityCode',ConfidentialityCode/Code,ConfidentialityCode/SDACodingStandard)=1">
		<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Medication','MedicationCode',DrugProduct/Code,DrugProduct/SDACodingStandard)=1 and
		              isc:evaluate(EncounterNumber,EnteredOn,'Medication','PharmacyStatus',PharmacyStatus)=1">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:if>

</xsl:template>  


<!-- process observations -->
<xsl:template match="/Container/Observations/Observation">
	<xsl:if test="isc:evaluate(EncounterNumber,ObservationTime,'Observation','ObservationCode',ObservationCode/Code,ObservationCode/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- process physical exams -->
<xsl:template match="/Container/PhysicalExams/PhysicalExam">
	<xsl:if test="isc:evaluate(EncounterNumber,PhysExamTime,'PhysicalExam','PhysExamCode',PhysExamCode/Code,PhysExamCode/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- process procedures -->
<xsl:template match="/Container/Procedures/Procedure">
	<xsl:if test="isc:evaluate(EncounterNumber,ProcedureTime,'Procedure','ProcedureCode',Procedure/Code,Procedure/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- documents -->
<xsl:template match="/Container/Documents/Document">
	<xsl:if test="isc:evaluate(EncounterNumber,EnteredOn,'Document','DocumentType',DocumentType/Code,DocumentType/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  



<!-- process social history -->
<xsl:template match="/Container/SocialHistories/SocialHistory">
	<xsl:if test="isc:evaluate(EncounterNumber,'','SocialHistory','SocialHabitCode',SocialHabit/Code,SocialHabit/SDACodingStandard)=1">
		  <xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		  </xsl:copy>
	  </xsl:if>
</xsl:template>  


</xsl:stylesheet>
