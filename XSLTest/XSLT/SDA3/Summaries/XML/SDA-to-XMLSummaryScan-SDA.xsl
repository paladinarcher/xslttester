<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" encoding="ISO-8859-1"/>
<xsl:param name="sectionTypes"/>
<xsl:key name="EncNum" match="Encounter" use="EncounterNumber" /> 

<xsl:template match="/Container">
	<xsl:copy>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Add sequence to individual Patient attributes -->
<xsl:template match="Patient/Race | Patient/Religion | Patient/PrimaryLanguage |  Patient/MaritalStatus">
	<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name()='MaritalStatus'">Marital Status</xsl:when>
				<xsl:when test="local-name()='PrimaryLanguage'">Language</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
	</xsl:variable>
	<xsl:copy>
		<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PAT','','','',$type,Description)"/>
		</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

<xsl:template match="Allergies">
	<xsl:copy>
			<xsl:apply-templates>
				<xsl:sort select="string-length(InactiveTime)=0" order="descending"/>
				<xsl:sort select="InactiveTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Allergies/Allergy">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ALG,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="concat(FromTime,'|',InactiveTime)"/>
			<xsl:variable name="category" select="AllergyCategory/Description"/>
			<xsl:variable name="desc" select="Allergy/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','ALG',$source,'',$date,$category,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Alerts">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="string-length(ToTime)=0" order="descending"/>
			<xsl:sort select="ToTime" order="descending"/>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Alerts/Alert">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ART,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
			<xsl:variable name="type" select="AlertType/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','ART',$source,'',$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="AdvanceDirectives">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="string-length(ToTime)=0" order="descending"/>
			<xsl:sort select="ToTime" order="descending"/>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="AdvanceDirectives/AdvanceDirective">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ADV,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
			<xsl:variable name="desc" select="Alert/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','ADV',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Procedures">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="ProcedureTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="Procedures/Procedure">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',PRC,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="ProcedureTime"/>
			<xsl:variable name="desc" select="Procedure/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PRC',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="PhysicalExams">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="PhysExamTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="PhysicalExams/PhysicalExam">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',PEX,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="PhysExamTime"/>
			<xsl:variable name="desc" select="PhysExamCode/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PEX',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Appointments">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="string-length(ToTime)=0" order="descending"/>
				<xsl:sort select="ToTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="Appointments/Appointment">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',APT,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
			<xsl:variable name="desc" select="CareProvider/Name/FamilyName"/>
			<xsl:variable name="loc" select="Location/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','APT',$source,$sourceType,$date,$desc,$loc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="ClinicalRelationships">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="string-length(ExpirationDate)=0" order="descending"/>
				<xsl:sort select="ExpirationDate" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="ClinicalRelationships/ClinicalRelationship">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',CLINREL,')">
			<xsl:variable name="date" select="ExpirationDate"/>
			<xsl:variable name="clin" select="Clinician/Name/FamilyName"/>
			<xsl:variable name="grp" select="ClinicianGroup/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','CLINREL','','',$date,$clin,$grp)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="ProgramMemberships">
	<xsl:copy>
		<xsl:apply-templates>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<!-- Add entity to summary filter global and record sequence number -->
<xsl:template match="ProgramMemberships/ProgramMembership">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',PROGRAM,')">
			<xsl:variable name="desc" select="ProgramName"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PROGRAM','','','',$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="IllnessHistories | FamilyHistories | SocialHistories">
	<xsl:copy>
			<xsl:apply-templates>
				<xsl:sort select="string-length(ToTime)=0" order="descending"/>
				<xsl:sort select="ToTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="IllnessHistory | FamilyHistory | SocialHistory">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',HIS,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
			<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="local-name()='IllnessHistory'">Medical</xsl:when>
			<xsl:when test="local-name()='FamilyHistory'">Family</xsl:when>
			<xsl:when test="local-name()='SocialHistory'">Social</xsl:when>
		</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','HIS',$source,'',$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Encounters">
	<xsl:copy>
			<xsl:apply-templates>
				<xsl:sort select="string-length(EndTime)=0" order="descending"/>
				<xsl:sort select="EndTime" order="descending"/>
				<xsl:sort select="FromTime" order="descending"/>
			</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Encounters/Encounter">
	<xsl:copy>
		<xsl:if test="not(EncounterType = 'S' or EncounterType = 'G')">
			<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ENC,')">
				<xsl:variable name="source" select="HealthCareFacility/Organization/Code"/>
				<xsl:variable name="sourceType" select="EncounterType"/>
				<xsl:variable name="date" select="concat(FromTime,'|',ToTime,'|',EndTime)"/>
				<xsl:variable name="visitNum" select="EncounterNumber"/>
				<xsl:attribute name="sequence">
					<xsl:value-of select="isc:evaluate('addFilterEntity','ENC',$source,$sourceType,$date,$visitNum,$sourceType)"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Diagnoses">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="EnteredOn" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Diagnoses/Diagnosis">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DXG,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="EnteredOn"/>
			<xsl:variable name="code" select="Diagnosis/Code"/>
			<xsl:variable name="desc" select="Diagnosis/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','DXG',$source,$sourceType,$date,$code,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Observations">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="ObservationTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Observations/Observation">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DOC,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="ObservationTime"/>
			<xsl:variable name="type" select="ObservationCode/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','OBS',$source,$sourceType,$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 


<xsl:template match="Problems">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="string-length(ToTime)=0" order="descending"/>
			<xsl:sort select="ToTime" order="descending"/>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Problems/Problem">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',PRB,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="concat(FromTime,'|',ToTime)"/>
			<xsl:variable name="type" select="Problem/Description"/>
			<xsl:variable name="status" select="Status/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PRB',$source,$sourceType,$date,$type,$status)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Documents">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="DocumentTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Documents/Document">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DOC,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="DocumentTime"/>
			<xsl:variable name="type" select="DocumentType/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','DOC',$source,$sourceType,$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template>

<xsl:template match="Medications">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Medications/Medication">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',MED,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="FromTime" />
			<xsl:variable name="desc"> 
				<xsl:choose>
					<xsl:when test="DrugProduct/Description">
						<xsl:value-of select="DrugProduct/Description"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="OrderItem/Description"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','MED',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>	
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Vaccinations">
	<xsl:copy>
		<xsl:apply-templates>
				<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="Vaccinations/Vaccination">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',VXU,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',EncounterNumber)/EncounterType"/>
			<xsl:variable name="date" select="FromTime" />
			<xsl:variable name="desc"> 
				<xsl:choose>
					<xsl:when test="DrugProduct/Description">
						<xsl:value-of select="DrugProduct/Description"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="OrderItem/Description"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','VXU',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="LabOrders">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="SpecimenCollectedTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="RadOrders | OtherOrders | GenomicsOrders">
	<xsl:copy>
		<xsl:apply-templates>
			<xsl:sort select="FromTime" order="descending"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="LabOrder">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',LAB,')">
			<xsl:apply-templates select="*[not(self::Result)]"/>
			<xsl:apply-templates select="Result">
				<xsl:with-param name="sectionName" select="'LAB'"/>
				<xsl:with-param name="date"  select="SpecimenCollectedTime" />
				<xsl:with-param name="result" select="'(textual)'"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:copy>
</xsl:template>

<xsl:template match="RadOrder">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',RAD,')">
			<xsl:apply-templates select="*[not(self::Result)]"/>
			<xsl:apply-templates select="Result">
				<xsl:with-param name="sectionName" select="'RAD'"/>
				<xsl:with-param name="date" select="FromTime"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:copy>
</xsl:template>

<xsl:template match="OtherOrder">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',OTH,')">
			<xsl:apply-templates select="*[not(self::Result)]"/>
			<xsl:apply-templates select="Result">
				<xsl:with-param name="sectionName" select="'OTH'"/>
				<xsl:with-param name="date" select="FromTime"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:copy>
</xsl:template>

<xsl:template match="GenomicsOrder">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',OTH,')">
			<xsl:apply-templates select="*[not(self::Result)]"/>
			<xsl:apply-templates select="Result">
				<xsl:with-param name="sectionName" select="'OTH'"/>
				<xsl:with-param name="date" select="FromTime"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:copy>
</xsl:template>

<!-- Add result to summary filter global and record sequence number -->
<xsl:template match="Result">
	<xsl:param name="sectionName"/>
	<xsl:param name="date"/>
	<xsl:param name="result"/>

	<xsl:copy>
		<!-- Textual results - one per result-->
		<xsl:if test="not(ResultItems)">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:when test="../EnteredAt"><xsl:value-of select="../EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('EncNum',../EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="key('EncNum',../EncounterNumber)/EncounterType"/>
			<xsl:variable name="type" select="../OrderItem/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity',$sectionName,$source,$sourceType,$date,$type,$result)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<!--  Atomic results - one per test -->
<!-- Add lab test to summary filter global and record sequence number -->
<xsl:template match="LabResultItem">
	<xsl:variable name="source">
		<xsl:choose>
			<xsl:when test="EnteredAt"><xsl:value-of select="../../EnteredAt/Code"/></xsl:when>
			<xsl:when test="../EnteredAt"><xsl:value-of select="../../../EnteredAt/Code"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="key('EncNum',../../../EncounterNumber)/EnteredAt/Code"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sourceType" select="key('EncNum',../../../EncounterNumber)/EncounterType"/>
	<xsl:variable name="date" select="../../../SpecimenCollectedTime" />
	<xsl:variable name="testItem" select="TestItemCode/Description"/>
	<xsl:variable name="result" select="concat(ResultValue,' ',ResultValueUnits)"/>
	<xsl:variable name="range" select="ResultNormalRange"/>

	<xsl:copy>
		<xsl:attribute name="sequence">
			<xsl:value-of select="isc:evaluate('addFilterEntity','LAB',$source,$sourceType,$date,$testItem,$result,$range)"/>
		</xsl:attribute>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>

<!-- Copy child nodes  -->
<xsl:template match="node()|@*">
	<xsl:copy> 
 		<xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
 </xsl:template>

</xsl:stylesheet>
