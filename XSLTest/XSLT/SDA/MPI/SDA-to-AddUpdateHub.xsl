<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>
	<xsl:key name="EncType" match="Encounter" use="EncounterType"/> 
	<xsl:key name="Clinician" match="InitiatingOrder/OrderedBy | Medications/Medication/OrderedBy" use="concat('ORD',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="InitiatingOrder/ResultCopiesTo/CareProvider" use="concat('COP',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="AdmittingClinician" use="concat('ADM',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="AttendingClinicians/CareProvider" use="concat('ATT',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="ConsultingClinicians/CareProvider" use="concat('CON',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="FamilyDoctor" use="concat('PCP',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="Clinician" match="ReferringClinician" use="concat('REF',Code,'_',SDACodingStandard)"/> 
	<xsl:key name="InfoTypeList" use="concat('ORD_',OrderType,'_',OrderCategory/Code)" match="Encounters//OrderItem"/>
	<xsl:key name="InfoTypeList" use="concat('MED_',OrderType,'_',OrderCategory/Code)" match="Encounters/Encounter/Medications/Medication/DrugProduct"/>
	<xsl:key name="DocTypeList" use="DocumentType/Code" match="Encounters/Encounter/Documents/Document"/>
	<xsl:template match="Container">
		<AddUpdateHubRequest>
		<Facility>
			<xsl:value-of select="SendingFacility"/>
		</Facility>
		<EventType>
		<xsl:variable name="eventType" select="substring(EventDescription,1,4)"/>
		<xsl:choose>
	  		<xsl:when test="$eventType='ADT_'">ADT</xsl:when>
	  		<xsl:when test="$eventType='ORM_'">ORD</xsl:when>
	  		<xsl:when test="$eventType='OMP_'">ORD</xsl:when>
	  		<xsl:when test="$eventType='VXU_'">RES</xsl:when>
	  		<xsl:when test="$eventType='ORU_'">RES</xsl:when>
	  		<xsl:when test="$eventType='MDM_'">DOC</xsl:when>
	  		<xsl:when test="$eventType='REF_'">REF</xsl:when>  
	  		<xsl:when test="$eventType='BAR_'">BAR</xsl:when> 		
	  		<xsl:otherwise>
	  			<xsl:choose>
	  				<xsl:when test="Patients/Patient/Encounters/Encounter/Results">RES</xsl:when>
	  				<xsl:when test="Patients/Patient/Encounters/Encounter/Plan">ORD</xsl:when>
	  				<xsl:when test="Patients/Patient/Encounters/Encounter/Medications">ORD</xsl:when>
	  				<xsl:when test="Patients/Patient/Encounters">ADT</xsl:when>
	  				<xsl:when test="//Documents">DOC</xsl:when>
	  				<xsl:otherwise>GEN</xsl:otherwise>
	  			</xsl:choose>
	  		</xsl:otherwise>
  		</xsl:choose>

		</EventType>
		<xsl:apply-templates select="Patients/Patient" />
		<xsl:apply-templates select="AdditionalInfo" />
		</AddUpdateHubRequest>
	</xsl:template>
			
	<xsl:template match="AdditionalInfo">
		<xsl:copy-of select = "."/>
	</xsl:template>

	<xsl:template match="Patients/Patient">
		<xsl:if test="ActionCode='R'">
			<AddOrUpdate>F</AddOrUpdate>
		</xsl:if>
		<MRN>
			<xsl:value-of select="PatientNumber/PatientNumber[NumberType = 'MRN']/Number"/>
		</MRN>
		<AssigningAuthority>
			<xsl:value-of
				select="PatientNumber/PatientNumber[NumberType = 'MRN']/Organization/Code"/>
		</AssigningAuthority>
		<FirstName>
			<xsl:value-of select="Name/GivenName"/>
		</FirstName>
		<MiddleName>
			<xsl:value-of select="Name/MiddleName"/>
		</MiddleName>
		<LastName>
			<xsl:value-of select="Name/FamilyName"/>
		</LastName>
		<Sex>
			<xsl:value-of select="Gender/Code"/>
		</Sex>
		<DOB>
			<xsl:value-of select="BirthTime"/>
		</DOB>
		<Street>
			<xsl:value-of select="Address/Address[1]/Street"/>
		</Street>
		<City>
			<xsl:value-of select="Address/Address[1]/City/Code"/>
		</City>
		<Zip>
			<xsl:value-of select="Address/Address[1]/Zip/Code"/>
		</Zip>
		<State>
			<xsl:value-of select="Address/Address[1]/State/Code"/>
		</State>
		<Telephone>
			<xsl:value-of select="ContactInfo/HomePhoneNumber"/>
		</Telephone>
		<BusinessPhone>
			<xsl:value-of select="ContactInfo/WorkPhoneNumber"/>
		</BusinessPhone>
		<SSN>
			<xsl:value-of select="PatientNumber/PatientNumber[NumberType = 'SSN']/Number"/>
		</SSN>
		<DeathStatus>
			<xsl:value-of select="IsDead"/>
		</DeathStatus>
		<EncounterTypes>
			<xsl:apply-templates select="Encounters/Encounter" mode="EncounterTypes"/>
		</EncounterTypes>
		<Identifiers>
			<xsl:apply-templates select="PatientNumber/PatientNumber"/>
			<xsl:apply-templates select="Encounters" mode="HealthFunds"/>
		</Identifiers>
		<IdentifiedClinicians>
			<xsl:apply-templates select="Encounters" mode="Clinicians"/>
			<xsl:apply-templates select="FamilyDoctor"/>
		</IdentifiedClinicians>
		<InfoTypes>
			<xsl:if test="Allergies">
			<InfoTypesItem>ALG</InfoTypesItem>
			</xsl:if>
			<xsl:if test="Alerts">
			<InfoTypesItem>ART</InfoTypesItem>
			</xsl:if>
			<xsl:if test="Encounters/Encounter">
			<InfoTypesItem>ENC</InfoTypesItem>
			</xsl:if>
			<xsl:if test="Encounters/Encounter/Diagnoses">
			<InfoTypesItem>DXG</InfoTypesItem>
			</xsl:if>
			<xsl:if test="PastHistory or SocialHistory or FamilyHistory">
			<InfoTypesItem>HIS</InfoTypesItem>
			</xsl:if>
			<xsl:if test="Encounters/Encounter/Observations/Observation">
			<InfoTypesItem>OBS</InfoTypesItem>
			</xsl:if>
			<xsl:if test="Encounters/Encounter/Problems/Problem">
			<InfoTypesItem>PRB</InfoTypesItem>
			</xsl:if>
			<xsl:for-each select="Encounters//OrderItem">
				<xsl:call-template name="infoTypeList">
				<xsl:with-param name="listType" select="'ORD'"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="Encounters//Document">
				<xsl:call-template name="docTypeList">
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="Encounters/Encounter/Medications/Medication/DrugProduct">
				<xsl:call-template name="infoTypeList">
				<xsl:with-param name="listType" select="'MED'"/>
				</xsl:call-template>
			</xsl:for-each>
		</InfoTypes>
	
	</xsl:template>	
	
	<xsl:template match="Encounter" mode="EncounterTypes">
		<xsl:if test="generate-id(.)=generate-id(key('EncType',EncounterType)[1])"> 
			<EncounterTypesItem>
				<xsl:value-of select="EncounterType"/>
			</EncounterTypesItem>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="PatientNumber/PatientNumber">
		<xsl:if test="(NumberType = 'XX') or (NumberType = 'SN') or (NumberType = 'DL') or (NumberType = 'PPN')">
			<Identifier>
				<xsl:if test="string-length(Organization/Code) > 0" >
					<AssigningAuthorityName>
						<xsl:value-of select="Organization/Code"/>
					</AssigningAuthorityName>
				</xsl:if>
				<Extension>
					<xsl:value-of select="Number"/>
				</Extension>
				<Use>
					<xsl:value-of select="NumberType"/>
				</Use>
			</Identifier>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Encounters" mode="HealthFunds">
		<xsl:for-each select="Encounter/HealthFunds/HealthFund[MembershipNumber!='']">
			<Identifier>
				<AssigningAuthorityName>
					<xsl:value-of select="HealthFundPlan/Code"/>
				</AssigningAuthorityName>
				<Extension>
					<xsl:value-of select="MembershipNumber"/>
				</Extension>
				<Use><xsl:text>SN</xsl:text></Use>
			</Identifier>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="Encounters" mode="Clinicians">	
		<xsl:for-each select="Encounter">
			<xsl:apply-templates select="AttendingClinicians"/>
			<xsl:apply-templates select="ConsultingClinicians"/>
			<xsl:apply-templates select="ReferringClinician"/>
			<xsl:apply-templates select="AdmittingClinician"/>
			<xsl:apply-templates select=".//InitiatingOrder/OrderedBy"/>
			<xsl:apply-templates select=".//Medications/Medication/OrderedBy"/>
			<xsl:apply-templates select=".//InitiatingOrder/ResultCopiesTo/CareProvider"/>
		</xsl:for-each>
	</xsl:template>	
	
	<xsl:template match="FamilyDoctor">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'PCP'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="AttendingClinicians">
		<xsl:for-each select="CareProvider">
			<xsl:call-template name="identifiedClinician">
				<xsl:with-param name="clinicianType" select="'ATT'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="ConsultingClinicians">
		<xsl:for-each select="CareProvider">
			<xsl:call-template name="identifiedClinician">
				<xsl:with-param name="clinicianType" select="'CON'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="ReferringClinician">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'REF'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="AdmittingClinician">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'ADM'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="InitiatingOrder/OrderedBy">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'ORD'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="Medications/Medication/OrderedBy">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'ORD'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="InitiatingOrder/ResultCopiesTo/CareProvider">
		<xsl:call-template name="identifiedClinician">
			<xsl:with-param name="clinicianType" select="'COP'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="identifiedClinician">
		<xsl:param name="clinicianType"/>
		<xsl:if test="generate-id(.)=generate-id(key('Clinician',concat($clinicianType,Code,'_',SDACodingStandard))[1])"> 
			<IdentifiedClinician>
				<ClinicianType><xsl:value-of select="$clinicianType"/></ClinicianType>
				<Number>
					<xsl:value-of select="Code"/>
				</Number>
				<AssigningAuthority>
					<xsl:value-of select="SDACodingStandard"/>
				</AssigningAuthority>
			</IdentifiedClinician>
		</xsl:if>
	</xsl:template>

	<xsl:template name="infoTypeList">
		<xsl:param name="listType"/>
		<xsl:if test="generate-id(.)=generate-id(key('InfoTypeList',concat($listType,'_',OrderType,'_',OrderCategory/Code))[1])"> 
			<InfoTypesItem>
				<xsl:value-of select="OrderType"></xsl:value-of>
				<xsl:if test="OrderCategory/Code!=''">.<xsl:value-of select="isc:evaluate('toUpper',./OrderCategory/Code)"/>
				</xsl:if>
			</InfoTypesItem>
		</xsl:if>
	</xsl:template>

	<xsl:template name="docTypeList">
		<xsl:if test="generate-id(.)=generate-id(key('DocTypeList',DocumentType/Code)[1])"> 
			<InfoTypesItem>
				<xsl:value-of select="concat('DOC.',isc:evaluate('toUpper',DocumentType/Code))"></xsl:value-of>
			</InfoTypesItem>
		</xsl:if>
	</xsl:template>
			
</xsl:stylesheet>
