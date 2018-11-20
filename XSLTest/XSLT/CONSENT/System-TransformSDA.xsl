<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:isc="http://extension-functions.intersystems.com">

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
 
<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>


<!-- past history -->
<xsl:template match="/Container/Patients/Patient/PastHistory/PastHistory">
	<xsl:if test="isc:evaluate(FromTime,'PastHistory')=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- allergies-->
<xsl:template match="/Container/Patients/Patient/Allergies/Allergies">
	<xsl:if test="isc:evaluate(FromTime,'Allergies')=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- encounter Start Date -->
<xsl:template match="/Container/Patients/Patient/Encounters">
	<xsl:copy>
	<xsl:for-each select="Encounter">
		
		<xsl:if test="isc:evaluate(StartTime,'Encounter')=1">
		  <xsl:copy>
		    <xsl:apply-templates select="@* | node()"/>
		  </xsl:copy>
		</xsl:if>
	</xsl:for-each>
	</xsl:copy>
</xsl:template>

<!-- process orders -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Plan/Orders/Order | /Container/Patients/Patient/Encounters/Encounter/Plan/Orders/Medication">
	<xsl:if test="isc:evaluate(EnteredOn,'Plan','OrderCategory',OrderItem/OrderCategory/Code,OrderItem/OrderCategory/SDACodingStandard)=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template> 


<!-- process lab orders -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Results/LabResult">
	<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','ConfidentialityCode',InitiatingOrder/ConfidentialityCode/Code,InitiatingOrder/ConfidentialityCode/SDACodingStandard)=1">
		<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','OrderItem',InitiatingOrder/OrderItem/Code,InitiatingOrder/OrderItem/SDACodingStandard)=1 and
		              isc:evaluate(InitiatingOrder/EnteredOn,'Result','ResultOrderCategory',InitiatingOrder/OrderItem/OrderCategory/Code,InitiatingOrder/OrderItem/OrderCategory/SDACodingStandard)=1">
			<xsl:copy>
			    <xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!-- process lab & rad orders in result section -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Results/Result">
	<xsl:if test="InitiatingOrder/OrderItem/OrderType='LAB'">
		<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','ConfidentialityCode',InitiatingOrder/ConfidentialityCode/Code,InitiatingOrder/ConfidentialityCode/SDACodingStandard)=1">
			<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','OrderItem',InitiatingOrder/OrderItem/Code,InitiatingOrder/OrderItem/SDACodingStandard)=1 and
			              isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','LabResultOrderCategory',InitiatingOrder/OrderItem/OrderCategory/Code,InitiatingOrder/OrderItem/OrderCategory/SDACodingStandard)=1 and
		        	      isc:evaluate(InitiatingOrder/EnteredOn,'Result','ResultOrderCategory',InitiatingOrder/OrderItem/OrderCategory/Code,InitiatingOrder/OrderItem/OrderCategory/SDACodingStandard)=1">
				<xsl:copy>
				    <xsl:apply-templates select="@* | node()"/>
				</xsl:copy>
			</xsl:if>
		</xsl:if>
	</xsl:if>
	<xsl:if test="InitiatingOrder/OrderItem/OrderType='RAD'">
		<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','ConfidentialityCode',InitiatingOrder/ConfidentialityCode/Code,InitiatingOrder/ConfidentialityCode/SDACodingStandard)=1">
			<xsl:if test="isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','OrderItem',InitiatingOrder/OrderItem/Code,InitiatingOrder/OrderItem/SDACodingStandard)=1 and
			              isc:evaluate(InitiatingOrder/EnteredOn,'LabResult','LabResultOrderCategory',InitiatingOrder/OrderItem/OrderCategory/Code,InitiatingOrder/OrderItem/OrderCategory/SDACodingStandard)=1 and
		        	      isc:evaluate(InitiatingOrder/EnteredOn,'Result','ResultOrderCategory',InitiatingOrder/OrderItem/OrderCategory/Code,InitiatingOrder/OrderItem/OrderCategory/SDACodingStandard)=1">
				<xsl:copy>
				    <xsl:apply-templates select="@* | node()"/>
				</xsl:copy>
			</xsl:if>
		</xsl:if>
	</xsl:if>
</xsl:template>


<!-- process lab results -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Results/LabResult/ResultItems/LabResultItem">
	<xsl:if test="isc:evaluate(../../ResultTime,'LabResult','LabResultItem',TestItemCode/Code,TestItemCode/SDACodingStandard)=1">
		<xsl:copy>
		    <xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>


<!-- process diagnoses -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Diagnoses/Diagnosis">
	<xsl:if test="isc:evaluate(EnteredOn,'Diagnosis','DiagnosisCode',Diagnosis/Code,Diagnosis/SDACodingStandard)=1">
	  <xsl:copy>
	    <xsl:apply-templates select="@* | node()"/>
	  </xsl:copy>
	</xsl:if>
</xsl:template>  

<!-- process medications -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Medications/Medication">
	<xsl:if test="isc:evaluate(EnteredOn,'Medication','ConfidentialityCode',ConfidentialityCode/Code,ConfidentialityCode/SDACodingStandard)=1">
		<xsl:if test="isc:evaluate(EnteredOn,'Medication','MedicationCode',DrugProduct/Code,DrugProduct/SDACodingStandard)=1 and
		              isc:evaluate(EnteredOn,'Medication','PharmacyStatus',PharmacyStatus)=1">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:if>

</xsl:template>  


<!-- process observations -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Observations/Observation">
	<xsl:if test="isc:evaluate(ObservationTime,'Observation','ObservationCode',ObservationCode/Code,ObservationCode/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- process physical exams -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/PhysicalExams/PhysicalExam">
	<xsl:if test="isc:evaluate(PhysExamTime,'PhysicalExam','PhysExamCode',PhysExamCode/Code,PhysExamCode/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- process procedures -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Procedures/Procedure">
	<xsl:if test="isc:evaluate(ProcedureTime,'Procedure','ProcedureCode',Procedure/Code,Procedure/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  


<!-- documents -->
<xsl:template match="/Container/Patients/Patient/Encounters/Encounter/Documents/Document">
	<xsl:if test="isc:evaluate(EnteredOn,'Document','DocumentType',DocumentType/Code,DocumentType/SDACodingStandard)=1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>  



<!-- process social history -->
<xsl:template match="/Container/Patients/Patient/SocialHistory/SocialHistory">
	<xsl:if test="isc:evaluate('','SocialHistory','SocialHabitCode',SocialHabit/Code,SocialHabit/SDACodingStandard)=1">
		  <xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		  </xsl:copy>
	  </xsl:if>
</xsl:template>  


</xsl:stylesheet>
