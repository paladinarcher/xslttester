<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<!-- Version: 2.0.3 -  EHX: 8.1.0 - Last major update: 6/14/2018   -->
	
        <xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

	<!-- global variable title -->
	<xsl:variable name="title">
		<xsl:choose>
			<xsl:when test="string-length(/n1:ClinicalDocument/n1:title)  >= 1">
				<xsl:value-of select="/n1:ClinicalDocument/n1:title"/>
			</xsl:when>
			<xsl:when test="/n1:ClinicalDocument/n1:code/@displayName">
				<xsl:value-of select="/n1:ClinicalDocument/n1:code/@displayName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Clinical Document</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Test to see if this is a VA document -->
	<xsl:variable name="isVA" select="boolean(/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:representedOrganization/n1:id[@root='2.16.840.1.113883.4.349'])"/>

	<!-- previous code to check file based on LOINC <xsl:variable name="isSES" select="boolean(/n1:ClinicalDocument/n1:code[@code='11506-3'] or /n1:ClinicalDocument/n1:code[@code='34130-5'] or /n1:ClinicalDocument/n1:code[@code='34131-3'] or /n1:ClinicalDocument/n1:code[@code='15507-7'] )"/> 
                -->

        <!-- checks to see if document is R1.1 or R2.1 by looking for inclusion of extension in templateId - R1.1 has no extension, R2.1 Does. -->
        <xsl:variable name="hasExtension" select="boolean(/n1:ClinicalDocument/n1:templateId[string(@extension)])"/>
        <xsl:variable name="isSES" select="boolean(/n1:ClinicalDocument/n1:code/@code='11506-3' or /n1:ClinicalDocument/n1:code/@code='34130-5' or /n1:ClinicalDocument/n1:code/@code='34131-3' or /n1:ClinicalDocument/n1:code/@code='15507-7' )"/>
        
        <xsl:variable name="ccdTemplateIdArray">
		<templateId>2.16.840.1.113883.10.20.22.2.6</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.4</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.3</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.2</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.22</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.7</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.10</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.14</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.15</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.17</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.18</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.21</templateId>
                <templateId>2.16.840.1.113883.10.20.22.2.65</templateId>
	</xsl:variable>

	<xsl:param name="ccdTemplateIdArrayParam" select="document('')/*/xsl:variable[@name='ccdTemplateIdArray']/*"/>

	<xsl:variable name="ccdAdditionalTemplateIdArray">

		<templateId>2.16.840.1.113883.10.20.22.2.25</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.9</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.8</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.13</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.37</templateId>
		<templateId>2.16.840.1.113883.10.20.6.1.1</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.33</templateId>
		<templateId>2.16.840.1.113883.10.20.6.1.2</templateId>
		<templateId>2.16.840.1.113883.10.20.2.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.20</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.4</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.43</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.44</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.42</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.24</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.41</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.11.1</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.26</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.16</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.45</templateId>
		<templateId>2.16.840.1.113883.10.20.21.2.3</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.23</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.39</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.38</templateId>
		<templateId>2.16.840.1.113883.10.20.21.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.7.12</templateId>
		<templateId>2.16.840.1.113883.10.20.7.14</templateId>
		<templateId>2.16.840.1.113883.10.20.2.10</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.30</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.35</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.36</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.34</templateId>
		<templateId>2.16.840.1.113883.10.20.18.2.12</templateId>
		<templateId>2.16.840.1.113883.10.20.18.2.9</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.28</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.40</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.29</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.31</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.1</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.12</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.18</templateId>
		<templateId>2.16.840.1.113883.10.20.7.13</templateId>
                <templateId>2.16.840.1.113883.10.20.22.2.65</templateId>
	</xsl:variable>

	<xsl:param name="ccdAdditionalTemplateIdArrayParam" select="document('')/*/xsl:variable[@name='ccdAdditionalTemplateIdArray']/*"/>

	<xsl:variable name="progressAdditionalTemplateIdArray">

		<templateId>2.16.840.1.113883.10.20.22.2.25</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.9</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.13</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.37</templateId>
		<templateId>2.16.840.1.113883.10.20.6.1.1</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.33</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.15</templateId>
		<templateId>2.16.840.1.113883.10.20.6.1.2</templateId>
		<templateId>2.16.840.1.113883.10.20.2.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.20</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.4</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.43</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.44</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.42</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.24</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.41</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.11.1</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.26</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.16</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.23</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.39</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.38</templateId>
		<templateId>2.16.840.1.113883.10.20.7.12</templateId>
		<templateId>2.16.840.1.113883.10.20.7.14</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.18</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.30</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.35</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.36</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.34</templateId>
		<templateId>2.16.840.1.113883.10.20.18.2.12</templateId>
		<templateId>2.16.840.1.113883.10.20.18.2.9</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.28</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.40</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.29</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.31</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.1</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.12</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.17</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.2</templateId>
		<templateId>2.16.840.1.113883.10.20.7.13</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.21</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.22</templateId>
                <templateId>2.16.840.1.113883.10.20.22.2.65</templateId>

	</xsl:variable>

	<xsl:param name="progressAdditionalTemplateIdArrayParam" select="document('')/*/xsl:variable[@name='progressAdditionalTemplateIdArray']/*"/>

	<xsl:variable name="progressTemplateIdArray">
		<templateId>2.16.840.1.113883.10.20.22.2.8</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.10</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.6</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.45</templateId>
		<templateId>2.16.840.1.113883.10.20.21.2.3</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.21.2.1</templateId>
		<templateId>2.16.840.1.113883.10.20.2.10</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.5</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.3</templateId>
		<templateId>1.3.6.1.4.1.19376.1.5.3.1.3.18</templateId>
		<templateId>2.16.840.1.113883.10.20.21.2.2</templateId>
		<templateId>2.16.840.1.113883.10.20.22.2.4</templateId>
                <templateId>2.16.840.1.113883.10.20.22.2.65</templateId>
	</xsl:variable>

	<xsl:param name="progressTemplateIdArrayParam" select="document('')/*/xsl:variable[@name='progressTemplateIdArray']/*"/>

	<xsl:variable name="ccdSectionHeader">
		<headerName>Allergies</headerName>
		<headerName>Problems</headerName>
		<headerName>Medications</headerName>
		<headerName>Vital Signs</headerName>
		<headerName>Results</headerName>
		<headerName>Immunizations</headerName>
		<headerName>Encounters</headerName>
		<headerName>Procedures</headerName>
		<headerName>Plan of Care/Treatment</headerName>
		<headerName>Functional Status</headerName>
		<headerName>Family History</headerName>
		<headerName>Social History</headerName>
		<headerName>Insurance Providers</headerName>
		<headerName>Advance Directive</headerName>
                <headerName>Notes</headerName>
	</xsl:variable>

	<xsl:param name="ccdSectionHeaderParam" select="document('')/*/xsl:variable[@name='ccdSectionHeader']/*"/>

	<xsl:variable name="ccdAdditionalSectionHeader">
		<headerName>Anesthesia</headerName>
		<headerName>Assessment And Plan</headerName>
		<headerName>Assessment</headerName>
		<headerName>REASON FOR VISIT/CHIEF COMPLAINT</headerName>
		<headerName>Complications</headerName>
		<headerName>DICOM Object Catalog</headerName>
		<headerName>Discharge Diet</headerName>
		<headerName>Findings</headerName>
		<headerName>General Status</headerName>
		<headerName>Past Medical History</headerName>
		<headerName>History Of Present Illness</headerName>
		<headerName>Hospital Admission Diagnosis</headerName>
		<headerName>Hospital Admission Medications Entries</headerName>
		<headerName>Hospital Consultations</headerName>
		<headerName>Hospital Course</headerName>
		<headerName>Hospital Discharge Diagnosis</headerName>
		<headerName>Hospital Discharge Instructions</headerName>
		<headerName>Hospital Discharge Medications</headerName>
		<headerName>Hospital Discharge Physical</headerName>
		<headerName>Hospital Discharge Studies Summary</headerName>
		<headerName>Instructions</headerName>
		<headerName>Interventions</headerName>
		<headerName>Medical Equipment</headerName>
		<headerName>Medical History</headerName>
		<headerName>Medications Administered</headerName>
		<headerName>Objective</headerName>
		<headerName>Operative Note Fluid</headerName>
		<headerName>Operative Note Surgical Procedure</headerName>
		<headerName>PhysicalExam</headerName>
		<headerName>Planned Procedure</headerName>
		<headerName>Postoperative Diagnosis</headerName>
		<headerName>Postprocedure Diagnosis</headerName>
		<headerName>Preoperative Diagnosis</headerName>
		<headerName>Procedure Disposition</headerName>
		<headerName>Procedure Estimated Blood Loss</headerName>
		<headerName>Procedure Findings</headerName>
		<headerName>Procedure Implants</headerName>
		<headerName>Procedure Indications</headerName>
		<headerName>Procedure Specimens Taken</headerName>
		<headerName>Reason For Referral</headerName>
		<headerName>Reason For Visit</headerName>
		<headerName>Review Of Systems</headerName>
		<headerName>Surgical Drains</headerName>                
	</xsl:variable>

	<xsl:param name="ccdAdditionalSectionHeaderParam" select="document('')/*/xsl:variable[@name='ccdAdditionalSectionHeader']/*"/>

	<xsl:variable name="progressAdditionalSectionHeader">
		<headerName>Anesthesia</headerName>
		<headerName>Assessment And Plan</headerName>
		<headerName>REASON FOR VISIT/CHIEF COMPLAINT</headerName>
		<headerName>Complications</headerName>
		<headerName>DICOM Object Catalog</headerName>
		<headerName>Discharge Diet</headerName>
		<headerName>Family History</headerName>
		<headerName>Findings</headerName>
		<headerName>General Status</headerName>
		<headerName>Past Medical History</headerName>
		<headerName>History Of Present Illness</headerName>
		<headerName>Hospital Admission Diagnosis</headerName>
		<headerName>Hospital Admission Medications Entries</headerName>
		<headerName>Hospital Consultations</headerName>
		<headerName>Hospital Course</headerName>
		<headerName>Hospital Discharge Diagnosis</headerName>
		<headerName>Hospital Discharge Instructions</headerName>
		<headerName>Hospital Discharge Medications</headerName>
		<headerName>Hospital Discharge Physical</headerName>
		<headerName>Hospital Discharge Studies Summary</headerName>
		<headerName>Immunizations</headerName>
		<headerName>Medical Equipment</headerName>
		<headerName>Medical History</headerName>
		<headerName>Medications Administered</headerName>
		<headerName>Operative Note Fluid</headerName>
		<headerName>Operative Note Surgical Procedure</headerName>
		<headerName>Insurance Providers</headerName>
		<headerName>Planned Procedure</headerName>
		<headerName>Postoperative Diagnosis</headerName>
		<headerName>Postprocedure Diagnosis</headerName>
		<headerName>Preoperative Diagnosis</headerName>
		<headerName>Procedure Disposition</headerName>
		<headerName>Procedure Estimated Blood Loss</headerName>
		<headerName>Procedure Findings</headerName>
		<headerName>Procedure Implants</headerName>
		<headerName>Procedure Indications</headerName>
		<headerName>Procedure Specimens Taken</headerName>
		<headerName>Reason For Referral</headerName>
		<headerName>Reason For Visit</headerName>
		<headerName>Social History</headerName>
		<headerName>Immunizations Entries</headerName>
		<headerName>Surgical Drains</headerName>
		<headerName>Advance Directive</headerName>
		<headerName>Encounters</headerName>
                <headerName>Notes</headerName>
	</xsl:variable>

	<xsl:param name="progressAdditionalSectionHeaderParam" select="document('')/*/xsl:variable[@name='progressAdditionalSectionHeader']/*"/>

	<xsl:variable name="ccdSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[1])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[2])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[3])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[4])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[5])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[6])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[7])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[8])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[9])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[10])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[11])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[12])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[13])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[14])"/>
		</titleId>
                <titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[15])"/>
		</titleId>
	</xsl:variable>

	<xsl:param name="ccdSectionHeaderRefParam" select="document('')/*/xsl:variable[@name='ccdSectionHeaderHref']/*"/>

	<xsl:variable name="ccdAdditionalSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[1])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[2])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[3])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[4])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[5])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[6])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[7])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[8])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[9])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[10])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[11])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[12])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[13])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[14])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[15])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[16])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[17])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[18])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[19])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[20])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[21])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[22])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[23])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[24])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[25])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[26])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[27])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[28])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[29])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[30])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[31])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[32])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[33])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[34])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[35])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[36])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[37])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[38])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[39])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[40])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[41])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[42])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdAdditionalSectionHeaderParam/headerName[43])"/>
		</titleId>
        </xsl:variable>

	<xsl:param name="ccdAdditionalSectionHeaderHrefParam" select="document('')/*/xsl:variable[@name='ccdAdditionalSectionHeaderHref']/*"/>

	<xsl:variable name="progressAdditionalSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[1])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[2])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[3])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[4])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[5])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[6])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[7])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[8])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[9])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[10])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[11])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[12])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[13])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[14])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[15])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[16])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[17])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[18])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[19])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[20])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[21])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[22])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[23])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[24])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[25])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[26])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[27])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[28])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[29])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[30])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[31])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[32])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[33])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[34])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[35])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[36])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[37])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[38])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[39])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[40])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[41])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[42])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[43])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[44])"/>
		</titleId>
                <titleId>
			<xsl:value-of select="generate-id($progressAdditionalSectionHeaderParam/headerName[45])"/>
		</titleId>

	</xsl:variable>

	<xsl:param name="progressAdditionalSectionHeaderHrefParam" select="document('')/*/xsl:variable[@name='progressAdditionalSectionHeaderHref']/*"/>
        
	<xsl:variable name="progSectionHeader">
		<headerName>Assesment</headerName>
		<headerName>Plan of Care/Treatment</headerName>
		<headerName>Allergies</headerName>
		<headerName>Chief Complaint</headerName>
		<headerName>Instructions</headerName>
		<headerName>Interventions</headerName>
		<headerName>Medications</headerName>
		<headerName>Objective</headerName>
		<headerName>Physical Exam</headerName>
		<headerName>Problem List</headerName>
		<headerName>Results</headerName>
		<headerName>Review of Systems</headerName>
		<headerName>Subjectives</headerName>
		<headerName>Vital Signs</headerName>
                <headerName>Notes</headerName>
	</xsl:variable>

	<xsl:param name="progSectionHeaderParam" select="document('')/*/xsl:variable[@name='progSectionHeader']/*"/>

	<xsl:variable name="progSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[1])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[2])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[3])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[4])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[5])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[6])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[7])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[8])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[9])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[10])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[11])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[12])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[13])"/>
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[14])"/>
		</titleId>
                <titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[15])"/>
		</titleId>
	</xsl:variable>

	<xsl:param name="progSectionHeaderHrefParam" select="document('')/*/xsl:variable[@name='progSectionHeaderHref']/*"/>

	<xsl:variable name="ccdDocTemplateRoot" select="/n1:ClinicalDocument/n1:templateId[@root='2.16.840.1.113883.10.20.22.1.1']/@root"/>
	<xsl:variable name="progDocTemplateRoot" select="/n1:ClinicalDocument/n1:templateId[@root='2.16.840.1.113883.10.20.22.1.9']/@root"/>

	<xsl:variable name="ccdaDoc">
		<xsl:text>2.16.840.1.113883.10.20.22.1.1</xsl:text>
	</xsl:variable>
	<xsl:variable name="progressDoc">
		<xsl:text>2.16.840.1.113883.10.20.22.1.9</xsl:text>
	</xsl:variable>

	<!-- Main -->
	<xsl:template match="/">
		<xsl:apply-templates select="n1:ClinicalDocument"/>
	</xsl:template>
	<!-- produce browser rendered, human readable clinical document -->
	<xsl:template match="n1:ClinicalDocument">
		<html>
			<head>
				<meta charset="utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
				<title>Veterans Affairs</title>
				<meta name="description" content=""/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>

				<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,300,400,600,700"/>
				<link rel="stylesheet" href="cda_plain.css"/>
                                <xsl:choose>
                                    <xsl:when test="$isSES"> 
                                        <test id="doc_type" content="ses"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <test id="doc_type" content="ccda"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <script LANGUAGE="javascript"><![CDATA[
/*! jQuery v3.3.2-pre -ajax,-ajax/jsonp,-ajax/load,-ajax/parseXML,-ajax/script,-ajax/var/location,-ajax/var/nonce,-ajax/var/rquery,-ajax/xhr,-manipulation/_evalUrl,-event/ajax,-deprecated,-wrap,-effects,-effects/Tween,-effects/animatedSelector,-deferred,-deferred/exceptionHook,-queue,-queue/delay,-core/ready,-exports/amd,-dimensions,-event,-event/alias,-event/focusin,-event/support,-event/trigger,-offset | (c) JS Foundation and other contributors | jquery.org/license */
!function(e,t){"use strict";"object"==typeof module&&"object"==typeof module.exports?module.exports=e.document?t(e,!0):function(e){if(!e.document)throw new Error("jQuery requires a window with a document");return t(e)}:t(e)}("undefined"!=typeof window?window:this,function(e,t){"use strict";var n=[],r=e.document,i=Object.getPrototypeOf,o=n.slice,a=n.concat,u=n.push,l=n.indexOf,s={},c=s.toString,f=s.hasOwnProperty,d=f.toString,p=d.call(Object),h={},g=function(e){return"function"==typeof e&&"number"!=typeof e.nodeType},y=function(e){return null!=e&&e===e.window},v={type:!0,src:!0,noModule:!0};function m(e,t,n){var i,o=(t=t||r).createElement("script");if(o.text=e,n)for(i in v)n[i]&&(o[i]=n[i]);t.head.appendChild(o).parentNode.removeChild(o)}function b(e){return null==e?e+"":"object"==typeof e||"function"==typeof e?s[c.call(e)]||"object":typeof e}var x="3.3.2-pre -ajax,-ajax/jsonp,-ajax/load,-ajax/parseXML,-ajax/script,-ajax/var/location,-ajax/var/nonce,-ajax/var/rquery,-ajax/xhr,-manipulation/_evalUrl,-event/ajax,-deprecated,-wrap,-effects,-effects/Tween,-effects/animatedSelector,-deferred,-deferred/exceptionHook,-queue,-queue/delay,-core/ready,-exports/amd,-dimensions,-event,-event/alias,-event/focusin,-event/support,-event/trigger,-offset",w=function(e,t){return new w.fn.init(e,t)},C=/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;w.fn=w.prototype={jquery:x,constructor:w,length:0,toArray:function(){return o.call(this)},get:function(e){return null==e?o.call(this):e<0?this[e+this.length]:this[e]},pushStack:function(e){var t=w.merge(this.constructor(),e);return t.prevObject=this,t},each:function(e){return w.each(this,e)},map:function(e){return this.pushStack(w.map(this,function(t,n){return e.call(t,n,t)}))},slice:function(){return this.pushStack(o.apply(this,arguments))},first:function(){return this.eq(0)},last:function(){return this.eq(-1)},eq:function(e){var t=this.length,n=+e+(e<0?t:0);return this.pushStack(n>=0&&n<t?[this[n]]:[])},end:function(){return this.prevObject||this.constructor()},push:u,sort:n.sort,splice:n.splice},w.extend=w.fn.extend=function(){var e,t,n,r,i,o,a=arguments[0]||{},u=1,l=arguments.length,s=!1;for("boolean"==typeof a&&(s=a,a=arguments[u]||{},u++),"object"==typeof a||g(a)||(a={}),u===l&&(a=this,u--);u<l;u++)if(null!=(e=arguments[u]))for(t in e)n=a[t],a!==(r=e[t])&&(s&&r&&(w.isPlainObject(r)||(i=Array.isArray(r)))?(i?(i=!1,o=n&&Array.isArray(n)?n:[]):o=n&&w.isPlainObject(n)?n:{},a[t]=w.extend(s,o,r)):void 0!==r&&(a[t]=r));return a},w.extend({expando:"jQuery"+(x+Math.random()).replace(/\D/g,""),isReady:!0,error:function(e){throw new Error(e)},noop:function(){},isPlainObject:function(e){var t,n;return!(!e||"[object Object]"!==c.call(e))&&(!(t=i(e))||"function"==typeof(n=f.call(t,"constructor")&&t.constructor)&&d.call(n)===p)},isEmptyObject:function(e){var t;for(t in e)return!1;return!0},globalEval:function(e){m(e)},each:function(e,t){var n,r=0;if(N(e)){for(n=e.length;r<n;r++)if(!1===t.call(e[r],r,e[r]))break}else for(r in e)if(!1===t.call(e[r],r,e[r]))break;return e},trim:function(e){return null==e?"":(e+"").replace(C,"")},makeArray:function(e,t){var n=t||[];return null!=e&&(N(Object(e))?w.merge(n,"string"==typeof e?[e]:e):u.call(n,e)),n},inArray:function(e,t,n){return null==t?-1:l.call(t,e,n)},merge:function(e,t){for(var n=+t.length,r=0,i=e.length;r<n;r++)e[i++]=t[r];return e.length=i,e},grep:function(e,t,n){for(var r=[],i=0,o=e.length,a=!n;i<o;i++)!t(e[i],i)!==a&&r.push(e[i]);return r},map:function(e,t,n){var r,i,o=0,u=[];if(N(e))for(r=e.length;o<r;o++)null!=(i=t(e[o],o,n))&&u.push(i);else for(o in e)null!=(i=t(e[o],o,n))&&u.push(i);return a.apply([],u)},guid:1,support:h}),"function"==typeof Symbol&&(w.fn[Symbol.iterator]=n[Symbol.iterator]),w.each("Boolean Number String Function Array Date RegExp Object Error Symbol".split(" "),function(e,t){s["[object "+t+"]"]=t.toLowerCase()});function N(e){var t=!!e&&"length"in e&&e.length,n=b(e);return!g(e)&&!y(e)&&("array"===n||0===t||"number"==typeof t&&t>0&&t-1 in e)}var A=function(e){var t,n,r,i,o,a,u,l,s,c,f,d,p,h,g,y,v,m,b,x="sizzle"+1*new Date,w=e.document,C=0,N=0,A=ae(),T=ae(),S=ae(),E=function(e,t){return e===t&&(f=!0),0},k={}.hasOwnProperty,D=[],L=D.pop,j=D.push,q=D.push,H=D.slice,O=function(e,t){for(var n=0,r=e.length;n<r;n++)if(e[n]===t)return n;return-1},I="checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",B="[\\x20\\t\\r\\n\\f]",M="(?:\\\\.|[\\w-]|[^\0-\\xa0])+",R="\\["+B+"*("+M+")(?:"+B+"*([*^$|!~]?=)"+B+"*(?:'((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\"|("+M+"))|)"+B+"*\\]",$=":("+M+")(?:\\((('((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\")|((?:\\\\.|[^\\\\()[\\]]|"+R+")*)|.*)\\)|)",F=new RegExp(B+"+","g"),P=new RegExp("^"+B+"+|((?:^|[^\\\\])(?:\\\\.)*)"+B+"+$","g"),W=new RegExp("^"+B+"*,"+B+"*"),z=new RegExp("^"+B+"*([>+~]|"+B+")"+B+"*"),U=new RegExp("="+B+"*([^\\]'\"]*?)"+B+"*\\]","g"),_=new RegExp($),V=new RegExp("^"+M+"$"),X={ID:new RegExp("^#("+M+")"),CLASS:new RegExp("^\\.("+M+")"),TAG:new RegExp("^("+M+"|[*])"),ATTR:new RegExp("^"+R),PSEUDO:new RegExp("^"+$),CHILD:new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\("+B+"*(even|odd|(([+-]|)(\\d*)n|)"+B+"*(?:([+-]|)"+B+"*(\\d+)|))"+B+"*\\)|)","i"),bool:new RegExp("^(?:"+I+")$","i"),needsContext:new RegExp("^"+B+"*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\("+B+"*((?:-\\d)?\\d*)"+B+"*\\)|)(?=[^-]|$)","i")},Q=/^(?:input|select|textarea|button)$/i,G=/^h\d$/i,J=/^[^{]+\{\s*\[native \w/,Z=/^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,K=/[+~]/,Y=new RegExp("\\\\([\\da-f]{1,6}"+B+"?|("+B+")|.)","ig"),ee=function(e,t,n){var r="0x"+t-65536;return r!==r||n?t:r<0?String.fromCharCode(r+65536):String.fromCharCode(r>>10|55296,1023&r|56320)},te=/([\0-\x1f\x7f]|^-?\d)|^-$|[^\0-\x1f\x7f-\uFFFF\w-]/g,ne=function(e,t){return t?"\0"===e?"\ufffd":e.slice(0,-1)+"\\"+e.charCodeAt(e.length-1).toString(16)+" ":"\\"+e},re=function(){d()},ie=ye(function(e){return!0===e.disabled&&("form"in e||"label"in e)},{dir:"parentNode",next:"legend"});try{q.apply(D=H.call(w.childNodes),w.childNodes),D[w.childNodes.length].nodeType}catch(e){q={apply:D.length?function(e,t){j.apply(e,H.call(t))}:function(e,t){var n=e.length,r=0;while(e[n++]=t[r++]);e.length=n-1}}}function oe(e,t,r,i){var o,u,s,c,f,h,v,m=t&&t.ownerDocument,C=t?t.nodeType:9;if(r=r||[],"string"!=typeof e||!e||1!==C&&9!==C&&11!==C)return r;if(!i&&((t?t.ownerDocument||t:w)!==p&&d(t),t=t||p,g)){if(11!==C&&(f=Z.exec(e)))if(o=f[1]){if(9===C){if(!(s=t.getElementById(o)))return r;if(s.id===o)return r.push(s),r}else if(m&&(s=m.getElementById(o))&&b(t,s)&&s.id===o)return r.push(s),r}else{if(f[2])return q.apply(r,t.getElementsByTagName(e)),r;if((o=f[3])&&n.getElementsByClassName&&t.getElementsByClassName)return q.apply(r,t.getElementsByClassName(o)),r}if(n.qsa&&!S[e+" "]&&(!y||!y.test(e))){if(1!==C)m=t,v=e;else if("object"!==t.nodeName.toLowerCase()){(c=t.getAttribute("id"))?c=c.replace(te,ne):t.setAttribute("id",c=x),u=(h=a(e)).length;while(u--)h[u]="#"+c+" "+ge(h[u]);v=h.join(","),m=K.test(e)&&pe(t.parentNode)||t}if(v)try{return q.apply(r,m.querySelectorAll(v)),r}catch(e){}finally{c===x&&t.removeAttribute("id")}}}return l(e.replace(P,"$1"),t,r,i)}function ae(){var e=[];function t(n,i){return e.push(n+" ")>r.cacheLength&&delete t[e.shift()],t[n+" "]=i}return t}function ue(e){return e[x]=!0,e}function le(e){var t=p.createElement("fieldset");try{return!!e(t)}catch(e){return!1}finally{t.parentNode&&t.parentNode.removeChild(t),t=null}}function se(e,t){var n=e.split("|"),i=n.length;while(i--)r.attrHandle[n[i]]=t}function ce(e,t){var n=t&&e,r=n&&1===e.nodeType&&1===t.nodeType&&e.sourceIndex-t.sourceIndex;if(r)return r;if(n)while(n=n.nextSibling)if(n===t)return-1;return e?1:-1}function fe(e){return function(t){return"form"in t?t.parentNode&&!1===t.disabled?"label"in t?"label"in t.parentNode?t.parentNode.disabled===e:t.disabled===e:t.isDisabled===e||t.isDisabled!==!e&&ie(t)===e:t.disabled===e:"label"in t&&t.disabled===e}}function de(e){return ue(function(t){return t=+t,ue(function(n,r){var i,o=e([],n.length,t),a=o.length;while(a--)n[i=o[a]]&&(n[i]=!(r[i]=n[i]))})})}function pe(e){return e&&"undefined"!=typeof e.getElementsByTagName&&e}n=oe.support={},o=oe.isXML=function(e){var t=e&&(e.ownerDocument||e).documentElement;return!!t&&"HTML"!==t.nodeName},d=oe.setDocument=function(e){var t,i,a=e?e.ownerDocument||e:w;return a!==p&&9===a.nodeType&&a.documentElement?(p=a,h=p.documentElement,g=!o(p),w!==p&&(i=p.defaultView)&&i.top!==i&&(i.addEventListener?i.addEventListener("unload",re,!1):i.attachEvent&&i.attachEvent("onunload",re)),n.attributes=le(function(e){return e.className="i",!e.getAttribute("className")}),n.getElementsByTagName=le(function(e){return e.appendChild(p.createComment("")),!e.getElementsByTagName("*").length}),n.getElementsByClassName=J.test(p.getElementsByClassName),n.getById=le(function(e){return h.appendChild(e).id=x,!p.getElementsByName||!p.getElementsByName(x).length}),n.getById?(r.filter.ID=function(e){var t=e.replace(Y,ee);return function(e){return e.getAttribute("id")===t}},r.find.ID=function(e,t){if("undefined"!=typeof t.getElementById&&g){var n=t.getElementById(e);return n?[n]:[]}}):(r.filter.ID=function(e){var t=e.replace(Y,ee);return function(e){var n="undefined"!=typeof e.getAttributeNode&&e.getAttributeNode("id");return n&&n.value===t}},r.find.ID=function(e,t){if("undefined"!=typeof t.getElementById&&g){var n,r,i,o=t.getElementById(e);if(o){if((n=o.getAttributeNode("id"))&&n.value===e)return[o];i=t.getElementsByName(e),r=0;while(o=i[r++])if((n=o.getAttributeNode("id"))&&n.value===e)return[o]}return[]}}),r.find.TAG=n.getElementsByTagName?function(e,t){return"undefined"!=typeof t.getElementsByTagName?t.getElementsByTagName(e):n.qsa?t.querySelectorAll(e):void 0}:function(e,t){var n,r=[],i=0,o=t.getElementsByTagName(e);if("*"===e){while(n=o[i++])1===n.nodeType&&r.push(n);return r}return o},r.find.CLASS=n.getElementsByClassName&&function(e,t){if("undefined"!=typeof t.getElementsByClassName&&g)return t.getElementsByClassName(e)},v=[],y=[],(n.qsa=J.test(p.querySelectorAll))&&(le(function(e){h.appendChild(e).innerHTML="<a id='"+x+"'></a><select id='"+x+"-\r\\' msallowcapture=''><option selected=''></option></select>",e.querySelectorAll("[msallowcapture^='']").length&&y.push("[*^$]="+B+"*(?:''|\"\")"),e.querySelectorAll("[selected]").length||y.push("\\["+B+"*(?:value|"+I+")"),e.querySelectorAll("[id~="+x+"-]").length||y.push("~="),e.querySelectorAll(":checked").length||y.push(":checked"),e.querySelectorAll("a#"+x+"+*").length||y.push(".#.+[+~]")}),le(function(e){e.innerHTML="<a href='' disabled='disabled'></a><select disabled='disabled'><option/></select>";var t=p.createElement("input");t.setAttribute("type","hidden"),e.appendChild(t).setAttribute("name","D"),e.querySelectorAll("[name=d]").length&&y.push("name"+B+"*[*^$|!~]?="),2!==e.querySelectorAll(":enabled").length&&y.push(":enabled",":disabled"),h.appendChild(e).disabled=!0,2!==e.querySelectorAll(":disabled").length&&y.push(":enabled",":disabled"),e.querySelectorAll("*,:x"),y.push(",.*:")})),(n.matchesSelector=J.test(m=h.matches||h.webkitMatchesSelector||h.mozMatchesSelector||h.oMatchesSelector||h.msMatchesSelector))&&le(function(e){n.disconnectedMatch=m.call(e,"*"),m.call(e,"[s!='']:x"),v.push("!=",$)}),y=y.length&&new RegExp(y.join("|")),v=v.length&&new RegExp(v.join("|")),t=J.test(h.compareDocumentPosition),b=t||J.test(h.contains)?function(e,t){var n=9===e.nodeType?e.documentElement:e,r=t&&t.parentNode;return e===r||!(!r||1!==r.nodeType||!(n.contains?n.contains(r):e.compareDocumentPosition&&16&e.compareDocumentPosition(r)))}:function(e,t){if(t)while(t=t.parentNode)if(t===e)return!0;return!1},E=t?function(e,t){if(e===t)return f=!0,0;var r=!e.compareDocumentPosition-!t.compareDocumentPosition;return r||(1&(r=(e.ownerDocument||e)===(t.ownerDocument||t)?e.compareDocumentPosition(t):1)||!n.sortDetached&&t.compareDocumentPosition(e)===r?e===p||e.ownerDocument===w&&b(w,e)?-1:t===p||t.ownerDocument===w&&b(w,t)?1:c?O(c,e)-O(c,t):0:4&r?-1:1)}:function(e,t){if(e===t)return f=!0,0;var n,r=0,i=e.parentNode,o=t.parentNode,a=[e],u=[t];if(!i||!o)return e===p?-1:t===p?1:i?-1:o?1:c?O(c,e)-O(c,t):0;if(i===o)return ce(e,t);n=e;while(n=n.parentNode)a.unshift(n);n=t;while(n=n.parentNode)u.unshift(n);while(a[r]===u[r])r++;return r?ce(a[r],u[r]):a[r]===w?-1:u[r]===w?1:0},p):p},oe.matches=function(e,t){return oe(e,null,null,t)},oe.matchesSelector=function(e,t){if((e.ownerDocument||e)!==p&&d(e),t=t.replace(U,"='$1']"),n.matchesSelector&&g&&!S[t+" "]&&(!v||!v.test(t))&&(!y||!y.test(t)))try{var r=m.call(e,t);if(r||n.disconnectedMatch||e.document&&11!==e.document.nodeType)return r}catch(e){}return oe(t,p,null,[e]).length>0},oe.contains=function(e,t){return(e.ownerDocument||e)!==p&&d(e),b(e,t)},oe.attr=function(e,t){(e.ownerDocument||e)!==p&&d(e);var i=r.attrHandle[t.toLowerCase()],o=i&&k.call(r.attrHandle,t.toLowerCase())?i(e,t,!g):void 0;return void 0!==o?o:n.attributes||!g?e.getAttribute(t):(o=e.getAttributeNode(t))&&o.specified?o.value:null},oe.escape=function(e){return(e+"").replace(te,ne)},oe.error=function(e){throw new Error("Syntax error, unrecognized expression: "+e)},oe.uniqueSort=function(e){var t,r=[],i=0,o=0;if(f=!n.detectDuplicates,c=!n.sortStable&&e.slice(0),e.sort(E),f){while(t=e[o++])t===e[o]&&(i=r.push(o));while(i--)e.splice(r[i],1)}return c=null,e},i=oe.getText=function(e){var t,n="",r=0,o=e.nodeType;if(o){if(1===o||9===o||11===o){if("string"==typeof e.textContent)return e.textContent;for(e=e.firstChild;e;e=e.nextSibling)n+=i(e)}else if(3===o||4===o)return e.nodeValue}else while(t=e[r++])n+=i(t);return n},(r=oe.selectors={cacheLength:50,createPseudo:ue,match:X,attrHandle:{},find:{},relative:{">":{dir:"parentNode",first:!0}," ":{dir:"parentNode"},"+":{dir:"previousSibling",first:!0},"~":{dir:"previousSibling"}},preFilter:{ATTR:function(e){return e[1]=e[1].replace(Y,ee),e[3]=(e[3]||e[4]||e[5]||"").replace(Y,ee),"~="===e[2]&&(e[3]=" "+e[3]+" "),e.slice(0,4)},CHILD:function(e){return e[1]=e[1].toLowerCase(),"nth"===e[1].slice(0,3)?(e[3]||oe.error(e[0]),e[4]=+(e[4]?e[5]+(e[6]||1):2*("even"===e[3]||"odd"===e[3])),e[5]=+(e[7]+e[8]||"odd"===e[3])):e[3]&&oe.error(e[0]),e},PSEUDO:function(e){var t,n=!e[6]&&e[2];return X.CHILD.test(e[0])?null:(e[3]?e[2]=e[4]||e[5]||"":n&&_.test(n)&&(t=a(n,!0))&&(t=n.indexOf(")",n.length-t)-n.length)&&(e[0]=e[0].slice(0,t),e[2]=n.slice(0,t)),e.slice(0,3))}},filter:{TAG:function(e){var t=e.replace(Y,ee).toLowerCase();return"*"===e?function(){return!0}:function(e){return e.nodeName&&e.nodeName.toLowerCase()===t}},CLASS:function(e){var t=A[e+" "];return t||(t=new RegExp("(^|"+B+")"+e+"("+B+"|$)"))&&A(e,function(e){return t.test("string"==typeof e.className&&e.className||"undefined"!=typeof e.getAttribute&&e.getAttribute("class")||"")})},ATTR:function(e,t,n){return function(r){var i=oe.attr(r,e);return null==i?"!="===t:!t||(i+="","="===t?i===n:"!="===t?i!==n:"^="===t?n&&0===i.indexOf(n):"*="===t?n&&i.indexOf(n)>-1:"$="===t?n&&i.slice(-n.length)===n:"~="===t?(" "+i.replace(F," ")+" ").indexOf(n)>-1:"|="===t&&(i===n||i.slice(0,n.length+1)===n+"-"))}},CHILD:function(e,t,n,r,i){var o="nth"!==e.slice(0,3),a="last"!==e.slice(-4),u="of-type"===t;return 1===r&&0===i?function(e){return!!e.parentNode}:function(t,n,l){var s,c,f,d,p,h,g=o!==a?"nextSibling":"previousSibling",y=t.parentNode,v=u&&t.nodeName.toLowerCase(),m=!l&&!u,b=!1;if(y){if(o){while(g){d=t;while(d=d[g])if(u?d.nodeName.toLowerCase()===v:1===d.nodeType)return!1;h=g="only"===e&&!h&&"nextSibling"}return!0}if(h=[a?y.firstChild:y.lastChild],a&&m){b=(p=(s=(c=(f=(d=y)[x]||(d[x]={}))[d.uniqueID]||(f[d.uniqueID]={}))[e]||[])[0]===C&&s[1])&&s[2],d=p&&y.childNodes[p];while(d=++p&&d&&d[g]||(b=p=0)||h.pop())if(1===d.nodeType&&++b&&d===t){c[e]=[C,p,b];break}}else if(m&&(b=p=(s=(c=(f=(d=t)[x]||(d[x]={}))[d.uniqueID]||(f[d.uniqueID]={}))[e]||[])[0]===C&&s[1]),!1===b)while(d=++p&&d&&d[g]||(b=p=0)||h.pop())if((u?d.nodeName.toLowerCase()===v:1===d.nodeType)&&++b&&(m&&((c=(f=d[x]||(d[x]={}))[d.uniqueID]||(f[d.uniqueID]={}))[e]=[C,b]),d===t))break;return(b-=i)===r||b%r==0&&b/r>=0}}},PSEUDO:function(e,t){var n,i=r.pseudos[e]||r.setFilters[e.toLowerCase()]||oe.error("unsupported pseudo: "+e);return i[x]?i(t):i.length>1?(n=[e,e,"",t],r.setFilters.hasOwnProperty(e.toLowerCase())?ue(function(e,n){var r,o=i(e,t),a=o.length;while(a--)e[r=O(e,o[a])]=!(n[r]=o[a])}):function(e){return i(e,0,n)}):i}},pseudos:{not:ue(function(e){var t=[],n=[],r=u(e.replace(P,"$1"));return r[x]?ue(function(e,t,n,i){var o,a=r(e,null,i,[]),u=e.length;while(u--)(o=a[u])&&(e[u]=!(t[u]=o))}):function(e,i,o){return t[0]=e,r(t,null,o,n),t[0]=null,!n.pop()}}),has:ue(function(e){return function(t){return oe(e,t).length>0}}),contains:ue(function(e){return e=e.replace(Y,ee),function(t){return(t.textContent||t.innerText||i(t)).indexOf(e)>-1}}),lang:ue(function(e){return V.test(e||"")||oe.error("unsupported lang: "+e),e=e.replace(Y,ee).toLowerCase(),function(t){var n;do{if(n=g?t.lang:t.getAttribute("xml:lang")||t.getAttribute("lang"))return(n=n.toLowerCase())===e||0===n.indexOf(e+"-")}while((t=t.parentNode)&&1===t.nodeType);return!1}}),target:function(t){var n=e.location&&e.location.hash;return n&&n.slice(1)===t.id},root:function(e){return e===h},focus:function(e){return e===p.activeElement&&(!p.hasFocus||p.hasFocus())&&!!(e.type||e.href||~e.tabIndex)},enabled:fe(!1),disabled:fe(!0),checked:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&!!e.checked||"option"===t&&!!e.selected},selected:function(e){return e.parentNode&&e.parentNode.selectedIndex,!0===e.selected},empty:function(e){for(e=e.firstChild;e;e=e.nextSibling)if(e.nodeType<6)return!1;return!0},parent:function(e){return!r.pseudos.empty(e)},header:function(e){return G.test(e.nodeName)},input:function(e){return Q.test(e.nodeName)},button:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&"button"===e.type||"button"===t},text:function(e){var t;return"input"===e.nodeName.toLowerCase()&&"text"===e.type&&(null==(t=e.getAttribute("type"))||"text"===t.toLowerCase())},first:de(function(){return[0]}),last:de(function(e,t){return[t-1]}),eq:de(function(e,t,n){return[n<0?n+t:n]}),even:de(function(e,t){for(var n=0;n<t;n+=2)e.push(n);return e}),odd:de(function(e,t){for(var n=1;n<t;n+=2)e.push(n);return e}),lt:de(function(e,t,n){for(var r=n<0?n+t:n;--r>=0;)e.push(r);return e}),gt:de(function(e,t,n){for(var r=n<0?n+t:n;++r<t;)e.push(r);return e})}}).pseudos.nth=r.pseudos.eq;for(t in{radio:!0,checkbox:!0,file:!0,password:!0,image:!0})r.pseudos[t]=function(e){return function(t){return"input"===t.nodeName.toLowerCase()&&t.type===e}}(t);for(t in{submit:!0,reset:!0})r.pseudos[t]=function(e){return function(t){var n=t.nodeName.toLowerCase();return("input"===n||"button"===n)&&t.type===e}}(t);function he(){}he.prototype=r.filters=r.pseudos,r.setFilters=new he,a=oe.tokenize=function(e,t){var n,i,o,a,u,l,s,c=T[e+" "];if(c)return t?0:c.slice(0);u=e,l=[],s=r.preFilter;while(u){n&&!(i=W.exec(u))||(i&&(u=u.slice(i[0].length)||u),l.push(o=[])),n=!1,(i=z.exec(u))&&(n=i.shift(),o.push({value:n,type:i[0].replace(P," ")}),u=u.slice(n.length));for(a in r.filter)!(i=X[a].exec(u))||s[a]&&!(i=s[a](i))||(n=i.shift(),o.push({value:n,type:a,matches:i}),u=u.slice(n.length));if(!n)break}return t?u.length:u?oe.error(e):T(e,l).slice(0)};function ge(e){for(var t=0,n=e.length,r="";t<n;t++)r+=e[t].value;return r}function ye(e,t,n){var r=t.dir,i=t.next,o=i||r,a=n&&"parentNode"===o,u=N++;return t.first?function(t,n,i){while(t=t[r])if(1===t.nodeType||a)return e(t,n,i);return!1}:function(t,n,l){var s,c,f,d=[C,u];if(l){while(t=t[r])if((1===t.nodeType||a)&&e(t,n,l))return!0}else while(t=t[r])if(1===t.nodeType||a)if(f=t[x]||(t[x]={}),c=f[t.uniqueID]||(f[t.uniqueID]={}),i&&i===t.nodeName.toLowerCase())t=t[r]||t;else{if((s=c[o])&&s[0]===C&&s[1]===u)return d[2]=s[2];if(c[o]=d,d[2]=e(t,n,l))return!0}return!1}}function ve(e){return e.length>1?function(t,n,r){var i=e.length;while(i--)if(!e[i](t,n,r))return!1;return!0}:e[0]}function me(e,t,n){for(var r=0,i=t.length;r<i;r++)oe(e,t[r],n);return n}function be(e,t,n,r,i){for(var o,a=[],u=0,l=e.length,s=null!=t;u<l;u++)(o=e[u])&&(n&&!n(o,r,i)||(a.push(o),s&&t.push(u)));return a}function xe(e,t,n,r,i,o){return r&&!r[x]&&(r=xe(r)),i&&!i[x]&&(i=xe(i,o)),ue(function(o,a,u,l){var s,c,f,d=[],p=[],h=a.length,g=o||me(t||"*",u.nodeType?[u]:u,[]),y=!e||!o&&t?g:be(g,d,e,u,l),v=n?i||(o?e:h||r)?[]:a:y;if(n&&n(y,v,u,l),r){s=be(v,p),r(s,[],u,l),c=s.length;while(c--)(f=s[c])&&(v[p[c]]=!(y[p[c]]=f))}if(o){if(i||e){if(i){s=[],c=v.length;while(c--)(f=v[c])&&s.push(y[c]=f);i(null,v=[],s,l)}c=v.length;while(c--)(f=v[c])&&(s=i?O(o,f):d[c])>-1&&(o[s]=!(a[s]=f))}}else v=be(v===a?v.splice(h,v.length):v),i?i(null,a,v,l):q.apply(a,v)})}function we(e){for(var t,n,i,o=e.length,a=r.relative[e[0].type],u=a||r.relative[" "],l=a?1:0,c=ye(function(e){return e===t},u,!0),f=ye(function(e){return O(t,e)>-1},u,!0),d=[function(e,n,r){var i=!a&&(r||n!==s)||((t=n).nodeType?c(e,n,r):f(e,n,r));return t=null,i}];l<o;l++)if(n=r.relative[e[l].type])d=[ye(ve(d),n)];else{if((n=r.filter[e[l].type].apply(null,e[l].matches))[x]){for(i=++l;i<o;i++)if(r.relative[e[i].type])break;return xe(l>1&&ve(d),l>1&&ge(e.slice(0,l-1).concat({value:" "===e[l-2].type?"*":""})).replace(P,"$1"),n,l<i&&we(e.slice(l,i)),i<o&&we(e=e.slice(i)),i<o&&ge(e))}d.push(n)}return ve(d)}function Ce(e,t){var n=t.length>0,i=e.length>0,o=function(o,a,u,l,c){var f,h,y,v=0,m="0",b=o&&[],x=[],w=s,N=o||i&&r.find.TAG("*",c),A=C+=null==w?1:Math.random()||.1,T=N.length;for(c&&(s=a===p||a||c);m!==T&&null!=(f=N[m]);m++){if(i&&f){h=0,a||f.ownerDocument===p||(d(f),u=!g);while(y=e[h++])if(y(f,a||p,u)){l.push(f);break}c&&(C=A)}n&&((f=!y&&f)&&v--,o&&b.push(f))}if(v+=m,n&&m!==v){h=0;while(y=t[h++])y(b,x,a,u);if(o){if(v>0)while(m--)b[m]||x[m]||(x[m]=L.call(l));x=be(x)}q.apply(l,x),c&&!o&&x.length>0&&v+t.length>1&&oe.uniqueSort(l)}return c&&(C=A,s=w),b};return n?ue(o):o}return u=oe.compile=function(e,t){var n,r=[],i=[],o=S[e+" "];if(!o){t||(t=a(e)),n=t.length;while(n--)(o=we(t[n]))[x]?r.push(o):i.push(o);(o=S(e,Ce(i,r))).selector=e}return o},l=oe.select=function(e,t,n,i){var o,l,s,c,f,d="function"==typeof e&&e,p=!i&&a(e=d.selector||e);if(n=n||[],1===p.length){if((l=p[0]=p[0].slice(0)).length>2&&"ID"===(s=l[0]).type&&9===t.nodeType&&g&&r.relative[l[1].type]){if(!(t=(r.find.ID(s.matches[0].replace(Y,ee),t)||[])[0]))return n;d&&(t=t.parentNode),e=e.slice(l.shift().value.length)}o=X.needsContext.test(e)?0:l.length;while(o--){if(s=l[o],r.relative[c=s.type])break;if((f=r.find[c])&&(i=f(s.matches[0].replace(Y,ee),K.test(l[0].type)&&pe(t.parentNode)||t))){if(l.splice(o,1),!(e=i.length&&ge(l)))return q.apply(n,i),n;break}}}return(d||u(e,p))(i,t,!g,n,!t||K.test(e)&&pe(t.parentNode)||t),n},n.sortStable=x.split("").sort(E).join("")===x,n.detectDuplicates=!!f,d(),n.sortDetached=le(function(e){return 1&e.compareDocumentPosition(p.createElement("fieldset"))}),le(function(e){return e.innerHTML="<a href='#'></a>","#"===e.firstChild.getAttribute("href")})||se("type|href|height|width",function(e,t,n){if(!n)return e.getAttribute(t,"type"===t.toLowerCase()?1:2)}),n.attributes&&le(function(e){return e.innerHTML="<input/>",e.firstChild.setAttribute("value",""),""===e.firstChild.getAttribute("value")})||se("value",function(e,t,n){if(!n&&"input"===e.nodeName.toLowerCase())return e.defaultValue}),le(function(e){return null==e.getAttribute("disabled")})||se(I,function(e,t,n){var r;if(!n)return!0===e[t]?t.toLowerCase():(r=e.getAttributeNode(t))&&r.specified?r.value:null}),oe}(e);w.find=A,w.expr=A.selectors,w.expr[":"]=w.expr.pseudos,w.uniqueSort=w.unique=A.uniqueSort,w.text=A.getText,w.isXMLDoc=A.isXML,w.contains=A.contains,w.escapeSelector=A.escape;var T=function(e,t,n){var r=[],i=void 0!==n;while((e=e[t])&&9!==e.nodeType)if(1===e.nodeType){if(i&&w(e).is(n))break;r.push(e)}return r},S=function(e,t){for(var n=[];e;e=e.nextSibling)1===e.nodeType&&e!==t&&n.push(e);return n},E=w.expr.match.needsContext;function k(e,t){return e.nodeName&&e.nodeName.toLowerCase()===t.toLowerCase()}var D=/^<([a-z][^\/\0>:\x20\t\r\n\f]*)[\x20\t\r\n\f]*\/?>(?:<\/\1>|)$/i;function L(e,t,n){return g(t)?w.grep(e,function(e,r){return!!t.call(e,r,e)!==n}):t.nodeType?w.grep(e,function(e){return e===t!==n}):"string"!=typeof t?w.grep(e,function(e){return l.call(t,e)>-1!==n}):w.filter(t,e,n)}w.filter=function(e,t,n){var r=t[0];return n&&(e=":not("+e+")"),1===t.length&&1===r.nodeType?w.find.matchesSelector(r,e)?[r]:[]:w.find.matches(e,w.grep(t,function(e){return 1===e.nodeType}))},w.fn.extend({find:function(e){var t,n,r=this.length,i=this;if("string"!=typeof e)return this.pushStack(w(e).filter(function(){for(t=0;t<r;t++)if(w.contains(i[t],this))return!0}));for(n=this.pushStack([]),t=0;t<r;t++)w.find(e,i[t],n);return r>1?w.uniqueSort(n):n},filter:function(e){return this.pushStack(L(this,e||[],!1))},not:function(e){return this.pushStack(L(this,e||[],!0))},is:function(e){return!!L(this,"string"==typeof e&&E.test(e)?w(e):e||[],!1).length}});var j,q=/^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]+))$/;(w.fn.init=function(e,t,n){var i,o;if(!e)return this;if(n=n||j,"string"==typeof e){if(!(i="<"===e[0]&&">"===e[e.length-1]&&e.length>=3?[null,e,null]:q.exec(e))||!i[1]&&t)return!t||t.jquery?(t||n).find(e):this.constructor(t).find(e);if(i[1]){if(t=t instanceof w?t[0]:t,w.merge(this,w.parseHTML(i[1],t&&t.nodeType?t.ownerDocument||t:r,!0)),D.test(i[1])&&w.isPlainObject(t))for(i in t)g(this[i])?this[i](t[i]):this.attr(i,t[i]);return this}return(o=r.getElementById(i[2]))&&(this[0]=o,this.length=1),this}return e.nodeType?(this[0]=e,this.length=1,this):g(e)?void 0!==n.ready?n.ready(e):e(w):w.makeArray(e,this)}).prototype=w.fn,j=w(r);var H=/^(?:parents|prev(?:Until|All))/,O={children:!0,contents:!0,next:!0,prev:!0};w.fn.extend({has:function(e){var t=w(e,this),n=t.length;return this.filter(function(){for(var e=0;e<n;e++)if(w.contains(this,t[e]))return!0})},closest:function(e,t){var n,r=0,i=this.length,o=[],a="string"!=typeof e&&w(e);if(!E.test(e))for(;r<i;r++)for(n=this[r];n&&n!==t;n=n.parentNode)if(n.nodeType<11&&(a?a.index(n)>-1:1===n.nodeType&&w.find.matchesSelector(n,e))){o.push(n);break}return this.pushStack(o.length>1?w.uniqueSort(o):o)},index:function(e){return e?"string"==typeof e?l.call(w(e),this[0]):l.call(this,e.jquery?e[0]:e):this[0]&&this[0].parentNode?this.first().prevAll().length:-1},add:function(e,t){return this.pushStack(w.uniqueSort(w.merge(this.get(),w(e,t))))},addBack:function(e){return this.add(null==e?this.prevObject:this.prevObject.filter(e))}});function I(e,t){while((e=e[t])&&1!==e.nodeType);return e}w.each({parent:function(e){var t=e.parentNode;return t&&11!==t.nodeType?t:null},parents:function(e){return T(e,"parentNode")},parentsUntil:function(e,t,n){return T(e,"parentNode",n)},next:function(e){return I(e,"nextSibling")},prev:function(e){return I(e,"previousSibling")},nextAll:function(e){return T(e,"nextSibling")},prevAll:function(e){return T(e,"previousSibling")},nextUntil:function(e,t,n){return T(e,"nextSibling",n)},prevUntil:function(e,t,n){return T(e,"previousSibling",n)},siblings:function(e){return S((e.parentNode||{}).firstChild,e)},children:function(e){return S(e.firstChild)},contents:function(e){return"undefined"!=typeof e.contentDocument?e.contentDocument:(k(e,"template")&&(e=e.content||e),w.merge([],e.childNodes))}},function(e,t){w.fn[e]=function(n,r){var i=w.map(this,t,n);return"Until"!==e.slice(-5)&&(r=n),r&&"string"==typeof r&&(i=w.filter(r,i)),this.length>1&&(O[e]||w.uniqueSort(i),H.test(e)&&i.reverse()),this.pushStack(i)}});var B=/[^\x20\t\r\n\f]+/g;function M(e){var t={};return w.each(e.match(B)||[],function(e,n){t[n]=!0}),t}w.Callbacks=function(e){e="string"==typeof e?M(e):w.extend({},e);var t,n,r,i,o=[],a=[],u=-1,l=function(){for(i=i||e.once,r=t=!0;a.length;u=-1){n=a.shift();while(++u<o.length)!1===o[u].apply(n[0],n[1])&&e.stopOnFalse&&(u=o.length,n=!1)}e.memory||(n=!1),t=!1,i&&(o=n?[]:"")},s={add:function(){return o&&(n&&!t&&(u=o.length-1,a.push(n)),function t(n){w.each(n,function(n,r){g(r)?e.unique&&s.has(r)||o.push(r):r&&r.length&&"string"!==b(r)&&t(r)})}(arguments),n&&!t&&l()),this},remove:function(){return w.each(arguments,function(e,t){var n;while((n=w.inArray(t,o,n))>-1)o.splice(n,1),n<=u&&u--}),this},has:function(e){return e?w.inArray(e,o)>-1:o.length>0},empty:function(){return o&&(o=[]),this},disable:function(){return i=a=[],o=n="",this},disabled:function(){return!o},lock:function(){return i=a=[],n||t||(o=n=""),this},locked:function(){return!!i},fireWith:function(e,n){return i||(n=[e,(n=n||[]).slice?n.slice():n],a.push(n),t||l()),this},fire:function(){return s.fireWith(this,arguments),this},fired:function(){return!!r}};return s},w.readyException=function(t){e.setTimeout(function(){throw t})};var R=function(e,t,n,r,i,o,a){var u=0,l=e.length,s=null==n;if("object"===b(n)){i=!0;for(u in n)R(e,t,u,n[u],!0,o,a)}else if(void 0!==r&&(i=!0,g(r)||(a=!0),s&&(a?(t.call(e,r),t=null):(s=t,t=function(e,t,n){return s.call(w(e),n)})),t))for(;u<l;u++)t(e[u],n,a?r:r.call(e[u],u,t(e[u],n)));return i?e:s?t.call(e):l?t(e[0],n):o},$=/^-ms-/,F=/-([a-z])/g;function P(e,t){return t.toUpperCase()}function W(e){return e.replace($,"ms-").replace(F,P)}var z=function(e){return 1===e.nodeType||9===e.nodeType||!+e.nodeType};function U(){this.expando=w.expando+U.uid++}U.uid=1,U.prototype={cache:function(e){var t=e[this.expando];return t||(t={},z(e)&&(e.nodeType?e[this.expando]=t:Object.defineProperty(e,this.expando,{value:t,configurable:!0}))),t},set:function(e,t,n){var r,i=this.cache(e);if("string"==typeof t)i[W(t)]=n;else for(r in t)i[W(r)]=t[r];return i},get:function(e,t){return void 0===t?this.cache(e):e[this.expando]&&e[this.expando][W(t)]},access:function(e,t,n){return void 0===t||t&&"string"==typeof t&&void 0===n?this.get(e,t):(this.set(e,t,n),void 0!==n?n:t)},remove:function(e,t){var n,r=e[this.expando];if(void 0!==r){if(void 0!==t){n=(t=Array.isArray(t)?t.map(W):(t=W(t))in r?[t]:t.match(B)||[]).length;while(n--)delete r[t[n]]}(void 0===t||w.isEmptyObject(r))&&(e.nodeType?e[this.expando]=void 0:delete e[this.expando])}},hasData:function(e){var t=e[this.expando];return void 0!==t&&!w.isEmptyObject(t)}};var _=new U,V=new U,X=/^(?:\{[\w\W]*\}|\[[\w\W]*\])$/,Q=/[A-Z]/g;function G(e){return"true"===e||"false"!==e&&("null"===e?null:e===+e+""?+e:X.test(e)?JSON.parse(e):e)}function J(e,t,n){var r;if(void 0===n&&1===e.nodeType)if(r="data-"+t.replace(Q,"-$&").toLowerCase(),"string"==typeof(n=e.getAttribute(r))){try{n=G(n)}catch(e){}V.set(e,t,n)}else n=void 0;return n}w.extend({hasData:function(e){return V.hasData(e)||_.hasData(e)},data:function(e,t,n){return V.access(e,t,n)},removeData:function(e,t){V.remove(e,t)},_data:function(e,t,n){return _.access(e,t,n)},_removeData:function(e,t){_.remove(e,t)}}),w.fn.extend({data:function(e,t){var n,r,i,o=this[0],a=o&&o.attributes;if(void 0===e){if(this.length&&(i=V.get(o),1===o.nodeType&&!_.get(o,"hasDataAttrs"))){n=a.length;while(n--)a[n]&&0===(r=a[n].name).indexOf("data-")&&(r=W(r.slice(5)),J(o,r,i[r]));_.set(o,"hasDataAttrs",!0)}return i}return"object"==typeof e?this.each(function(){V.set(this,e)}):R(this,function(t){var n;if(o&&void 0===t){if(void 0!==(n=V.get(o,e)))return n;if(void 0!==(n=J(o,e)))return n}else this.each(function(){V.set(this,e,t)})},null,t,arguments.length>1,null,!0)},removeData:function(e){return this.each(function(){V.remove(this,e)})}});var Z=/[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,K=new RegExp("^(?:([+-])=|)("+Z+")([a-z%]*)$","i"),Y=["Top","Right","Bottom","Left"],ee=function(e){return w.contains(e.ownerDocument,e)},te=function(e,t){return"none"===(e=t||e).style.display||""===e.style.display&&ee(e)&&"none"===w.css(e,"display")},ne=function(e,t,n,r){var i,o,a={};for(o in t)a[o]=e.style[o],e.style[o]=t[o];i=n.apply(e,r||[]);for(o in t)e.style[o]=a[o];return i};function re(e,t,n,r){var i,o,a=20,u=r?function(){return r.cur()}:function(){return w.css(e,t,"")},l=u(),s=n&&n[3]||(w.cssNumber[t]?"":"px"),c=e.nodeType&&(w.cssNumber[t]||"px"!==s&&+l)&&K.exec(w.css(e,t));if(c&&c[3]!==s){l/=2,s=s||c[3],c=+l||1;while(a--)w.style(e,t,c+s),(1-o)*(1-(o=u()/l||.5))<=0&&(a=0),c/=o;c*=2,w.style(e,t,c+s),n=n||[]}return n&&(c=+c||+l||0,i=n[1]?c+(n[1]+1)*n[2]:+n[2],r&&(r.unit=s,r.start=c,r.end=i)),i}var ie={};function oe(e){var t,n=e.ownerDocument,r=e.nodeName,i=ie[r];return i||(t=n.body.appendChild(n.createElement(r)),i=w.css(t,"display"),t.parentNode.removeChild(t),"none"===i&&(i="block"),ie[r]=i,i)}function ae(e,t){for(var n,r,i=[],o=0,a=e.length;o<a;o++)(r=e[o]).style&&(n=r.style.display,t?("none"===n&&(i[o]=_.get(r,"display")||null,i[o]||(r.style.display="")),""===r.style.display&&te(r)&&(i[o]=oe(r))):"none"!==n&&(i[o]="none",_.set(r,"display",n)));for(o=0;o<a;o++)null!=i[o]&&(e[o].style.display=i[o]);return e}w.fn.extend({show:function(){return ae(this,!0)},hide:function(){return ae(this)},toggle:function(e){return"boolean"==typeof e?e?this.show():this.hide():this.each(function(){te(this)?w(this).show():w(this).hide()})}});var ue=/^(?:checkbox|radio)$/i,le=/<([a-z][^\/\0>\x20\t\r\n\f]+)/i,se=/^$|^module$|\/(?:java|ecma)script/i,ce={option:[1,"<select multiple='multiple'>","</select>"],thead:[1,"<table>","</table>"],col:[2,"<table><colgroup>","</colgroup></table>"],tr:[2,"<table><tbody>","</tbody></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],_default:[0,"",""]};ce.optgroup=ce.option,ce.tbody=ce.tfoot=ce.colgroup=ce.caption=ce.thead,ce.th=ce.td;function fe(e,t){var n;return n="undefined"!=typeof e.getElementsByTagName?e.getElementsByTagName(t||"*"):"undefined"!=typeof e.querySelectorAll?e.querySelectorAll(t||"*"):[],void 0===t||t&&k(e,t)?w.merge([e],n):n}function de(e,t){for(var n=0,r=e.length;n<r;n++)_.set(e[n],"globalEval",!t||_.get(t[n],"globalEval"))}var pe=/<|&#?\w+;/;function he(e,t,n,r,i){for(var o,a,u,l,s,c,f=t.createDocumentFragment(),d=[],p=0,h=e.length;p<h;p++)if((o=e[p])||0===o)if("object"===b(o))w.merge(d,o.nodeType?[o]:o);else if(pe.test(o)){a=a||f.appendChild(t.createElement("div")),u=(le.exec(o)||["",""])[1].toLowerCase(),l=ce[u]||ce._default,a.innerHTML=l[1]+w.htmlPrefilter(o)+l[2],c=l[0];while(c--)a=a.lastChild;w.merge(d,a.childNodes),(a=f.firstChild).textContent=""}else d.push(t.createTextNode(o));f.textContent="",p=0;while(o=d[p++])if(r&&w.inArray(o,r)>-1)i&&i.push(o);else if(s=ee(o),a=fe(f.appendChild(o),"script"),s&&de(a),n){c=0;while(o=a[c++])se.test(o.type||"")&&n.push(o)}return f}!function(){var e=r.createDocumentFragment().appendChild(r.createElement("div")),t=r.createElement("input");t.setAttribute("type","radio"),t.setAttribute("checked","checked"),t.setAttribute("name","t"),e.appendChild(t),h.checkClone=e.cloneNode(!0).cloneNode(!0).lastChild.checked,e.innerHTML="<textarea>x</textarea>",h.noCloneChecked=!!e.cloneNode(!0).lastChild.defaultValue}();var ge=r.documentElement,ye=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,ve=/<script|<style|<link/i,me=/checked\s*(?:[^=]|=\s*.checked.)/i,be=/^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g;function xe(e,t){return k(e,"table")&&k(11!==t.nodeType?t:t.firstChild,"tr")?w(e).children("tbody")[0]||e:e}function we(e){return e.type=(null!==e.getAttribute("type"))+"/"+e.type,e}function Ce(e){return"true/"===(e.type||"").slice(0,5)?e.type=e.type.slice(5):e.removeAttribute("type"),e}function Ne(e,t){var n,r,i,o,a,u,l,s;if(1===t.nodeType){if(_.hasData(e)&&(o=_.access(e),a=_.set(t,o),s=o.events)){delete a.handle,a.events={};for(i in s)for(n=0,r=s[i].length;n<r;n++)w.event.add(t,i,s[i][n])}V.hasData(e)&&(u=V.access(e),l=w.extend({},u),V.set(t,l))}}function Ae(e,t){var n=t.nodeName.toLowerCase();"input"===n&&ue.test(e.type)?t.checked=e.checked:"input"!==n&&"textarea"!==n||(t.defaultValue=e.defaultValue)}function Te(e,t,n,r){t=a.apply([],t);var i,o,u,l,s,c,f=0,d=e.length,p=d-1,y=t[0],v=g(y);if(v||d>1&&"string"==typeof y&&!h.checkClone&&me.test(y))return e.each(function(i){var o=e.eq(i);v&&(t[0]=y.call(this,i,o.html())),Te(o,t,n,r)});if(d&&(i=he(t,e[0].ownerDocument,!1,e,r),o=i.firstChild,1===i.childNodes.length&&(i=o),o||r)){for(l=(u=w.map(fe(i,"script"),we)).length;f<d;f++)s=i,f!==p&&(s=w.clone(s,!0,!0),l&&w.merge(u,fe(s,"script"))),n.call(e[f],s,f);if(l)for(c=u[u.length-1].ownerDocument,w.map(u,Ce),f=0;f<l;f++)s=u[f],se.test(s.type||"")&&!_.access(s,"globalEval")&&w.contains(c,s)&&(s.src&&"module"!==(s.type||"").toLowerCase()?w._evalUrl&&w._evalUrl(s.src):m(s.textContent.replace(be,""),c,s))}return e}function Se(e,t,n){for(var r,i=t?w.filter(t,e):e,o=0;null!=(r=i[o]);o++)n||1!==r.nodeType||w.cleanData(fe(r)),r.parentNode&&(n&&ee(r)&&de(fe(r,"script")),r.parentNode.removeChild(r));return e}w.extend({htmlPrefilter:function(e){return e.replace(ye,"<$1></$2>")},clone:function(e,t,n){var r,i,o,a,u=e.cloneNode(!0),l=ee(e);if(!(h.noCloneChecked||1!==e.nodeType&&11!==e.nodeType||w.isXMLDoc(e)))for(a=fe(u),r=0,i=(o=fe(e)).length;r<i;r++)Ae(o[r],a[r]);if(t)if(n)for(o=o||fe(e),a=a||fe(u),r=0,i=o.length;r<i;r++)Ne(o[r],a[r]);else Ne(e,u);return(a=fe(u,"script")).length>0&&de(a,!l&&fe(e,"script")),u},cleanData:function(e){for(var t,n,r,i=w.event.special,o=0;void 0!==(n=e[o]);o++)if(z(n)){if(t=n[_.expando]){if(t.events)for(r in t.events)i[r]?w.event.remove(n,r):w.removeEvent(n,r,t.handle);n[_.expando]=void 0}n[V.expando]&&(n[V.expando]=void 0)}}}),w.fn.extend({detach:function(e){return Se(this,e,!0)},remove:function(e){return Se(this,e)},text:function(e){return R(this,function(e){return void 0===e?w.text(this):this.empty().each(function(){1!==this.nodeType&&11!==this.nodeType&&9!==this.nodeType||(this.textContent=e)})},null,e,arguments.length)},append:function(){return Te(this,arguments,function(e){1!==this.nodeType&&11!==this.nodeType&&9!==this.nodeType||xe(this,e).appendChild(e)})},prepend:function(){return Te(this,arguments,function(e){if(1===this.nodeType||11===this.nodeType||9===this.nodeType){var t=xe(this,e);t.insertBefore(e,t.firstChild)}})},before:function(){return Te(this,arguments,function(e){this.parentNode&&this.parentNode.insertBefore(e,this)})},after:function(){return Te(this,arguments,function(e){this.parentNode&&this.parentNode.insertBefore(e,this.nextSibling)})},empty:function(){for(var e,t=0;null!=(e=this[t]);t++)1===e.nodeType&&(w.cleanData(fe(e,!1)),e.textContent="");return this},clone:function(e,t){return e=null!=e&&e,t=null==t?e:t,this.map(function(){return w.clone(this,e,t)})},html:function(e){return R(this,function(e){var t=this[0]||{},n=0,r=this.length;if(void 0===e&&1===t.nodeType)return t.innerHTML;if("string"==typeof e&&!ve.test(e)&&!ce[(le.exec(e)||["",""])[1].toLowerCase()]){e=w.htmlPrefilter(e);try{for(;n<r;n++)1===(t=this[n]||{}).nodeType&&(w.cleanData(fe(t,!1)),t.innerHTML=e);t=0}catch(e){}}t&&this.empty().append(e)},null,e,arguments.length)},replaceWith:function(){var e=[];return Te(this,arguments,function(t){var n=this.parentNode;w.inArray(this,e)<0&&(w.cleanData(fe(this)),n&&n.replaceChild(t,this))},e)}}),w.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(e,t){w.fn[e]=function(e){for(var n,r=[],i=w(e),o=i.length-1,a=0;a<=o;a++)n=a===o?this:this.clone(!0),w(i[a])[t](n),u.apply(r,n.get());return this.pushStack(r)}});var Ee=new RegExp("^("+Z+")(?!px)[a-z%]+$","i"),ke=function(t){var n=t.ownerDocument.defaultView;return n&&n.opener||(n=e),n.getComputedStyle(t)},De=new RegExp(Y.join("|"),"i");!function(){function t(){if(c){s.style.cssText="position:absolute;left:-11111px;width:60px;margin-top:1px;padding:0;border:0",c.style.cssText="position:relative;display:block;box-sizing:border-box;overflow:scroll;margin:auto;border:1px;padding:1px;width:60%;top:1%",ge.appendChild(s).appendChild(c);var t=e.getComputedStyle(c);i="1%"!==t.top,l=12===n(t.marginLeft),c.style.right="60%",u=36===n(t.right),o=36===n(t.width),c.style.position="absolute",a=12===n(c.offsetWidth/3)||"absolute",ge.removeChild(s),c=null}}function n(e){return Math.round(parseFloat(e))}var i,o,a,u,l,s=r.createElement("div"),c=r.createElement("div");c.style&&(c.style.backgroundClip="content-box",c.cloneNode(!0).style.backgroundClip="",h.clearCloneStyle="content-box"===c.style.backgroundClip,w.extend(h,{boxSizingReliable:function(){return t(),o},pixelBoxStyles:function(){return t(),u},pixelPosition:function(){return t(),i},reliableMarginLeft:function(){return t(),l},scrollboxSize:function(){return t(),a}}))}();function Le(e,t,n){var r,i,o,a,u=e.style;return(n=n||ke(e))&&(""!==(a=n.getPropertyValue(t)||n[t])||ee(e)||(a=w.style(e,t)),!h.pixelBoxStyles()&&Ee.test(a)&&De.test(t)&&(r=u.width,i=u.minWidth,o=u.maxWidth,u.minWidth=u.maxWidth=u.width=a,a=n.width,u.width=r,u.minWidth=i,u.maxWidth=o)),void 0!==a?a+"":a}var je=["Webkit","Moz","ms"],qe=r.createElement("div").style,He={};function Oe(e){var t=e[0].toUpperCase()+e.slice(1),n=je.length;while(n--)if((e=je[n]+t)in qe)return e}function Ie(e){var t=w.cssProps[e]||He[e];return t||(e in qe?e:He[e]=Oe(e)||e)}var Be=/^(none|table(?!-c[ea]).+)/,Me=/^--/,Re={position:"absolute",visibility:"hidden",display:"block"},$e={letterSpacing:"0",fontWeight:"400"};function Fe(e,t,n){var r=K.exec(t);return r?Math.max(0,r[2]-(n||0))+(r[3]||"px"):t}function Pe(e,t,n,r,i,o){var a="width"===t?1:0,u=0,l=0;if(n===(r?"border":"content"))return 0;for(;a<4;a+=2)"margin"===n&&(l+=w.css(e,n+Y[a],!0,i)),r?("content"===n&&(l-=w.css(e,"padding"+Y[a],!0,i)),"margin"!==n&&(l-=w.css(e,"border"+Y[a]+"Width",!0,i))):(l+=w.css(e,"padding"+Y[a],!0,i),"padding"!==n?l+=w.css(e,"border"+Y[a]+"Width",!0,i):u+=w.css(e,"border"+Y[a]+"Width",!0,i));return!r&&o>=0&&(l+=Math.max(0,Math.ceil(e["offset"+t[0].toUpperCase()+t.slice(1)]-o-l-u-.5))),l}function We(e,t,n){var r=ke(e),i=Le(e,t,r),o="border-box"===w.css(e,"boxSizing",!1,r),a=o;if(Ee.test(i)){if(!n)return i;i="auto"}return a=a&&(h.boxSizingReliable()||i===e.style[t]),("auto"===i||!parseFloat(i)&&"inline"===w.css(e,"display",!1,r))&&(i=e["offset"+t[0].toUpperCase()+t.slice(1)],a=!0),(i=parseFloat(i)||0)+Pe(e,t,n||(o?"border":"content"),a,r,i)+"px"}w.extend({cssHooks:{opacity:{get:function(e,t){if(t){var n=Le(e,"opacity");return""===n?"1":n}}}},cssNumber:{animationIterationCount:!0,columnCount:!0,fillOpacity:!0,flexGrow:!0,flexShrink:!0,fontWeight:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,widows:!0,zIndex:!0,zoom:!0},cssProps:{},style:function(e,t,n,r){if(e&&3!==e.nodeType&&8!==e.nodeType&&e.style){var i,o,a,u=W(t),l=Me.test(t),s=e.style;if(l||(t=Ie(u)),a=w.cssHooks[t]||w.cssHooks[u],void 0===n)return a&&"get"in a&&void 0!==(i=a.get(e,!1,r))?i:s[t];"string"==(o=typeof n)&&(i=K.exec(n))&&i[1]&&(n=re(e,t,i),o="number"),null!=n&&n===n&&("number"===o&&(n+=i&&i[3]||(w.cssNumber[u]?"":"px")),h.clearCloneStyle||""!==n||0!==t.indexOf("background")||(s[t]="inherit"),a&&"set"in a&&void 0===(n=a.set(e,n,r))||(l?s.setProperty(t,n):s[t]=n))}},css:function(e,t,n,r){var i,o,a,u=W(t);return Me.test(t)||(t=Ie(u)),(a=w.cssHooks[t]||w.cssHooks[u])&&"get"in a&&(i=a.get(e,!0,n)),void 0===i&&(i=Le(e,t,r)),"normal"===i&&t in $e&&(i=$e[t]),""===n||n?(o=parseFloat(i),!0===n||isFinite(o)?o||0:i):i}}),w.each(["height","width"],function(e,t){w.cssHooks[t]={get:function(e,n,r){if(n)return!Be.test(w.css(e,"display"))||e.getClientRects().length&&e.getBoundingClientRect().width?We(e,t,r):ne(e,Re,function(){return We(e,t,r)})},set:function(e,n,r){var i,o=ke(e),a=h.scrollboxSize()===o.position,u=(a||r)&&"border-box"===w.css(e,"boxSizing",!1,o),l=r?Pe(e,t,r,u,o):0;return u&&a&&(l-=Math.ceil(e["offset"+t[0].toUpperCase()+t.slice(1)]-parseFloat(o[t])-Pe(e,t,"border",!1,o)-.5)),l&&(i=K.exec(n))&&"px"!==(i[3]||"px")&&(e.style[t]=n,n=w.css(e,t)),Fe(0,n,l)}}}),w.cssHooks.marginLeft=function(e,t){return{get:function(){if(!e())return(this.get=t).apply(this,arguments);delete this.get}}}(h.reliableMarginLeft,function(e,t){if(t)return(parseFloat(Le(e,"marginLeft"))||e.getBoundingClientRect().left-ne(e,{marginLeft:0},function(){return e.getBoundingClientRect().left}))+"px"}),w.each({margin:"",padding:"",border:"Width"},function(e,t){w.cssHooks[e+t]={expand:function(n){for(var r=0,i={},o="string"==typeof n?n.split(" "):[n];r<4;r++)i[e+Y[r]+t]=o[r]||o[r-2]||o[0];return i}},"margin"!==e&&(w.cssHooks[e+t].set=Fe)}),w.fn.extend({css:function(e,t){return R(this,function(e,t,n){var r,i,o={},a=0;if(Array.isArray(t)){for(r=ke(e),i=t.length;a<i;a++)o[t[a]]=w.css(e,t[a],!1,r);return o}return void 0!==n?w.style(e,t,n):w.css(e,t)},e,t,arguments.length>1)}}),function(){var e=r.createElement("input"),t=r.createElement("select").appendChild(r.createElement("option"));e.type="checkbox",h.checkOn=""!==e.value,h.optSelected=t.selected,(e=r.createElement("input")).value="t",e.type="radio",h.radioValue="t"===e.value}();var ze,Ue=w.expr.attrHandle;w.fn.extend({attr:function(e,t){return R(this,w.attr,e,t,arguments.length>1)},removeAttr:function(e){return this.each(function(){w.removeAttr(this,e)})}}),w.extend({attr:function(e,t,n){var r,i,o=e.nodeType;if(3!==o&&8!==o&&2!==o)return"undefined"==typeof e.getAttribute?w.prop(e,t,n):(1===o&&w.isXMLDoc(e)||(i=w.attrHooks[t.toLowerCase()]||(w.expr.match.bool.test(t)?ze:void 0)),void 0!==n?null===n?void w.removeAttr(e,t):i&&"set"in i&&void 0!==(r=i.set(e,n,t))?r:(e.setAttribute(t,n+""),n):i&&"get"in i&&null!==(r=i.get(e,t))?r:null==(r=w.find.attr(e,t))?void 0:r)},attrHooks:{type:{set:function(e,t){if(!h.radioValue&&"radio"===t&&k(e,"input")){var n=e.value;return e.setAttribute("type",t),n&&(e.value=n),t}}}},removeAttr:function(e,t){var n,r=0,i=t&&t.match(B);if(i&&1===e.nodeType)while(n=i[r++])e.removeAttribute(n)}}),ze={set:function(e,t,n){return!1===t?w.removeAttr(e,n):e.setAttribute(n,n),n}},w.each(w.expr.match.bool.source.match(/\w+/g),function(e,t){var n=Ue[t]||w.find.attr;Ue[t]=function(e,t,r){var i,o,a=t.toLowerCase();return r||(o=Ue[a],Ue[a]=i,i=null!=n(e,t,r)?a:null,Ue[a]=o),i}});var _e=/^(?:input|select|textarea|button)$/i,Ve=/^(?:a|area)$/i;w.fn.extend({prop:function(e,t){return R(this,w.prop,e,t,arguments.length>1)},removeProp:function(e){return this.each(function(){delete this[w.propFix[e]||e]})}}),w.extend({prop:function(e,t,n){var r,i,o=e.nodeType;if(3!==o&&8!==o&&2!==o)return 1===o&&w.isXMLDoc(e)||(t=w.propFix[t]||t,i=w.propHooks[t]),void 0!==n?i&&"set"in i&&void 0!==(r=i.set(e,n,t))?r:e[t]=n:i&&"get"in i&&null!==(r=i.get(e,t))?r:e[t]},propHooks:{tabIndex:{get:function(e){var t=w.find.attr(e,"tabindex");return t?parseInt(t,10):_e.test(e.nodeName)||Ve.test(e.nodeName)&&e.href?0:-1}}},propFix:{"for":"htmlFor","class":"className"}}),h.optSelected||(w.propHooks.selected={get:function(e){var t=e.parentNode;return t&&t.parentNode&&t.parentNode.selectedIndex,null},set:function(e){var t=e.parentNode;t&&(t.selectedIndex,t.parentNode&&t.parentNode.selectedIndex)}}),w.each(["tabIndex","readOnly","maxLength","cellSpacing","cellPadding","rowSpan","colSpan","useMap","frameBorder","contentEditable"],function(){w.propFix[this.toLowerCase()]=this});function Xe(e){return(e.match(B)||[]).join(" ")}function Qe(e){return e.getAttribute&&e.getAttribute("class")||""}function Ge(e){return Array.isArray(e)?e:"string"==typeof e?e.match(B)||[]:[]}w.fn.extend({addClass:function(e){var t,n,r,i,o,a,u,l=0;if(g(e))return this.each(function(t){w(this).addClass(e.call(this,t,Qe(this)))});if((t=Ge(e)).length)while(n=this[l++])if(i=Qe(n),r=1===n.nodeType&&" "+Xe(i)+" "){a=0;while(o=t[a++])r.indexOf(" "+o+" ")<0&&(r+=o+" ");i!==(u=Xe(r))&&n.setAttribute("class",u)}return this},removeClass:function(e){var t,n,r,i,o,a,u,l=0;if(g(e))return this.each(function(t){w(this).removeClass(e.call(this,t,Qe(this)))});if(!arguments.length)return this.attr("class","");if((t=Ge(e)).length)while(n=this[l++])if(i=Qe(n),r=1===n.nodeType&&" "+Xe(i)+" "){a=0;while(o=t[a++])while(r.indexOf(" "+o+" ")>-1)r=r.replace(" "+o+" "," ");i!==(u=Xe(r))&&n.setAttribute("class",u)}return this},toggleClass:function(e,t){var n=typeof e,r="string"===n||Array.isArray(e);return"boolean"==typeof t&&r?t?this.addClass(e):this.removeClass(e):g(e)?this.each(function(n){w(this).toggleClass(e.call(this,n,Qe(this),t),t)}):this.each(function(){var t,i,o,a;if(r){i=0,o=w(this),a=Ge(e);while(t=a[i++])o.hasClass(t)?o.removeClass(t):o.addClass(t)}else void 0!==e&&"boolean"!==n||((t=Qe(this))&&_.set(this,"__className__",t),this.setAttribute&&this.setAttribute("class",t||!1===e?"":_.get(this,"__className__")||""))})},hasClass:function(e){var t,n,r=0;t=" "+e+" ";while(n=this[r++])if(1===n.nodeType&&(" "+Xe(Qe(n))+" ").indexOf(t)>-1)return!0;return!1}});var Je=/\r/g;w.fn.extend({val:function(e){var t,n,r,i=this[0];{if(arguments.length)return r=g(e),this.each(function(n){var i;1===this.nodeType&&(null==(i=r?e.call(this,n,w(this).val()):e)?i="":"number"==typeof i?i+="":Array.isArray(i)&&(i=w.map(i,function(e){return null==e?"":e+""})),(t=w.valHooks[this.type]||w.valHooks[this.nodeName.toLowerCase()])&&"set"in t&&void 0!==t.set(this,i,"value")||(this.value=i))});if(i)return(t=w.valHooks[i.type]||w.valHooks[i.nodeName.toLowerCase()])&&"get"in t&&void 0!==(n=t.get(i,"value"))?n:"string"==typeof(n=i.value)?n.replace(Je,""):null==n?"":n}}}),w.extend({valHooks:{option:{get:function(e){var t=w.find.attr(e,"value");return null!=t?t:Xe(w.text(e))}},select:{get:function(e){var t,n,r,i=e.options,o=e.selectedIndex,a="select-one"===e.type,u=a?null:[],l=a?o+1:i.length;for(r=o<0?l:a?o:0;r<l;r++)if(((n=i[r]).selected||r===o)&&!n.disabled&&(!n.parentNode.disabled||!k(n.parentNode,"optgroup"))){if(t=w(n).val(),a)return t;u.push(t)}return u},set:function(e,t){var n,r,i=e.options,o=w.makeArray(t),a=i.length;while(a--)((r=i[a]).selected=w.inArray(w.valHooks.option.get(r),o)>-1)&&(n=!0);return n||(e.selectedIndex=-1),o}}}}),w.each(["radio","checkbox"],function(){w.valHooks[this]={set:function(e,t){if(Array.isArray(t))return e.checked=w.inArray(w(e).val(),t)>-1}},h.checkOn||(w.valHooks[this].get=function(e){return null===e.getAttribute("value")?"on":e.value})});var Ze=/\[\]$/,Ke=/\r?\n/g,Ye=/^(?:submit|button|image|reset|file)$/i,et=/^(?:input|select|textarea|keygen)/i;function tt(e,t,n,r){var i;if(Array.isArray(t))w.each(t,function(t,i){n||Ze.test(e)?r(e,i):tt(e+"["+("object"==typeof i&&null!=i?t:"")+"]",i,n,r)});else if(n||"object"!==b(t))r(e,t);else for(i in t)tt(e+"["+i+"]",t[i],n,r)}w.param=function(e,t){var n,r=[],i=function(e,t){var n=g(t)?t():t;r[r.length]=encodeURIComponent(e)+"="+encodeURIComponent(null==n?"":n)};if(Array.isArray(e)||e.jquery&&!w.isPlainObject(e))w.each(e,function(){i(this.name,this.value)});else for(n in e)tt(n,e[n],t,i);return r.join("&")},w.fn.extend({serialize:function(){return w.param(this.serializeArray())},serializeArray:function(){return this.map(function(){var e=w.prop(this,"elements");return e?w.makeArray(e):this}).filter(function(){var e=this.type;return this.name&&!w(this).is(":disabled")&&et.test(this.nodeName)&&!Ye.test(e)&&(this.checked||!ue.test(e))}).map(function(e,t){var n=w(this).val();return null==n?null:Array.isArray(n)?w.map(n,function(e){return{name:t.name,value:e.replace(Ke,"\r\n")}}):{name:t.name,value:n.replace(Ke,"\r\n")}}).get()}}),w.expr.pseudos.hidden=function(e){return!w.expr.pseudos.visible(e)},w.expr.pseudos.visible=function(e){return!!(e.offsetWidth||e.offsetHeight||e.getClientRects().length)},h.createHTMLDocument=function(){var e=r.implementation.createHTMLDocument("").body;return e.innerHTML="<form></form><form></form>",2===e.childNodes.length}(),w.parseHTML=function(e,t,n){if("string"!=typeof e)return[];"boolean"==typeof t&&(n=t,t=!1);var i,o,a;return t||(h.createHTMLDocument?((i=(t=r.implementation.createHTMLDocument("")).createElement("base")).href=r.location.href,t.head.appendChild(i)):t=r),o=D.exec(e),a=!n&&[],o?[t.createElement(o[1])]:(o=he([e],t,a),a&&a.length&&w(a).remove(),w.merge([],o.childNodes))};var nt=e.jQuery,rt=e.$;w.noConflict=function(t){return e.$===w&&(e.$=rt),t&&e.jQuery===w&&(e.jQuery=nt),w},t||(e.jQuery=e.$=w);var it=[],ot=function(e){it.push(e)},at=function(t){e.setTimeout(function(){t.call(r,w)})};w.fn.ready=function(e){return ot(e),this},w.extend({isReady:!1,readyWait:1,ready:function(e){(!0===e?--w.readyWait:w.isReady)||(w.isReady=!0,!0!==e&&--w.readyWait>0||(ot=function(e){it.push(e);while(it.length)e=it.shift(),g(e)&&at(e)})())}}),w.ready.then=w.fn.ready;function ut(){r.removeEventListener("DOMContentLoaded",ut),e.removeEventListener("load",ut),w.ready()}return"complete"===r.readyState||"loading"!==r.readyState&&!r.documentElement.doScroll?e.setTimeout(w.ready):(r.addEventListener("DOMContentLoaded",ut),e.addEventListener("load",ut)),w});
//# sourceMappingURL=jquery.min.map

                                ]]></script>

			</head>
			<body>
				<div id="top" class="episode-note-container">

					<div id="titlebar-container" class="titlebar-container">
						<header id="titlebar" class="titlebar">
							<div class="columns">
								<div class="col-3">
								   <p>
										<xsl:value-of select="n1:title"/>
										<!-- VA Continuity of Care Document <xsl:choose> <xsl:when test="contains($docTemplateRoot, 
											$ccdaDoc)"> (VA CCD) </xsl:when> <xsl:when test="contains($docTemplateRoot, 
											$progressDoc)"> (VA Progress Notes) </xsl:when> <xsl:otherwise> </xsl:otherwise> 
											</xsl:choose> -->
										<br/>
										Creation Date:
										<xsl:call-template name="show-time">
											<xsl:with-param name="datetime" select="n1:effectiveTime"/>
										</xsl:call-template>
									</p>
								</div>

								<div class="col-3" style="text-align: center;word-wrap: break-word;">
								      									<h1>
										<xsl:value-of select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name"/>
									</h1>
								
									  								      </div>

								<div class="col-3" style="text-align: left;word-wrap: break-word;">
								  <p>
								    	Patient:

										<xsl:call-template name="show-name">
											<xsl:with-param name="name" select="n1:recordTarget/n1:patientRole/n1:patient/n1:name"/>
										</xsl:call-template>
									<br/>
										DOB:

											<xsl:call-template name="show-time">
												<xsl:with-param name="datetime" select="n1:recordTarget/n1:patientRole/n1:patient/n1:birthTime"/>
											</xsl:call-template>

										<br/>
										Gender:
											<xsl:for-each select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:administrativeGenderCode">
												<xsl:if test="@nullFlavor">
													<xsl:value-of select="n1:originalText"/>
												</xsl:if>
												<xsl:call-template name="show-gender"/>
											</xsl:for-each>
									</p>
								</div>
								
								
							</div>
							<nav class="toc infobar">
									<p>
                                                                            <label id="plus.TOC" onclick="javascript:toggle('open','TOC')">[+]  </label>
                                                                            <label id="minus.TOC" onclick="javascript:toggle('close','TOC')">[-]  </label>
                                                                            <strong>Table of Contents</strong>
									</p>
									<div id="section.TOC">
                                                                            <xsl:if test="not(//n1:nonXMLBody)">
                                                                                <xsl:if test="count(/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component[n1:section]) > 1">
                                                                                  <xsl:call-template name="make-tableofcontents-dynamic"/>
                                                                                </xsl:if>
                                                                            </xsl:if>
									</div>
								</nav>
								
								<button id="backtotop" class="backtotop">↑ Back To Top</button>
						</header>
					</div>            <!-- START display top portion of clinical document -->
					<div class="sections">

						<section id="Patient Information">
							<header>
								<h2>
									<label id="plus.Patient Information" onclick="javascript:toggle('open','Patient Information')">[+]  </label>
									<label id="minus.Patient Information" onclick="javascript:toggle('close','Patient Information')">[-]  </label>
								Patient &amp; Contact Information</h2>
								<!--<p><strong>Business Rules for Construction of Medical Information:</strong> 
									Business Rules description of the section goes here.</p> -->
							</header>
							<div id="section.Patient Information">
							<div class="columns">
								<div class="col-1">
									<table>
										<thead>
											<tr>
												<th colspan="2">Patient Information</th>
											</tr>
										</thead>
										<tbody>
											<!-- <tr valign="top"> <th width="30%">Name</th> <td width="70%"> 
												<xsl:call-template name="show-name"> <xsl:with-param name="name" select="n1:recordTarget/n1:patientRole/n1:patient/n1:name"/> 
												</xsl:call-template> </td> </tr> <tr valign="top"> <th>Medical Record Number</th> 
												<td> <xsl:value-of select="n1:recordTarget/n1:patientRole/n1:id/@extension" 
												/> </td> </tr> <tr valign="top"> <th>Birthdate</th> <td> <xsl:call-template 
												name="show-time"> <xsl:with-param name="datetime" select="n1:recordTarget/n1:patientRole/n1:patient/n1:birthTime"/> 
												</xsl:call-template> </td> </tr> -->
											<tr valign="top">
												<th>Address</th>
												<td>
													<xsl:for-each select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole">
														<xsl:if test="not(n1:id/@nullFlavor)">
															<xsl:call-template name="show-contactInfo">
																<xsl:with-param name="contact" select="."/>
															</xsl:call-template>
														</xsl:if>
													</xsl:for-each>
												</td>
											</tr>
											<!--<tr valign="top"> <th>Patient Id</th> <td> <xsl:for-each select="n1:recordTarget/n1:patientRole/n1:id"> 
												<xsl:call-template name="show-id"/> <br/> </xsl:for-each> </td> </tr> -->
											<!-- <tr valign="top"> <th>Gender</th> <td> <xsl:for-each select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:administrativeGenderCode"> 
												<xsl:call-template name="show-gender"/> </xsl:for-each> </td> </tr> -->
											<tr valign="top">
												<th>Marital status</th>
												<td>
													<xsl:choose>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/@displayName">
															<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/@displayName"/>
														</xsl:when>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/n1:originalText">
															<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/n1:originalText"/>
														</xsl:when>
													</xsl:choose>
												</td>
											</tr>

											<tr valign="top">
												<th>Religious Affiliation</th>
												<td>
													<xsl:choose>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:religiousAffiliationCode/@displayName">
																<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:religiousAffiliationCode/@displayName"/>
														</xsl:when>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:religiousAffiliationCode/n1:originalText">
																<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:religiousAffiliationCode/n1:originalText"/>
														</xsl:when>
													</xsl:choose>
												</td>
											</tr>
											<tr valign="top">
												<th>Race</th>
												<td>
													<xsl:call-template name="show-race">
														<xsl:with-param name="raceCodeDisplay" select="n1:recordTarget/n1:patientRole/n1:patient/n1:raceCode/@displayName"/>
														<xsl:with-param name="sdtc-raceCodeDisplay" select="n1:recordTarget/n1:patientRole/n1:patient/sdtc:raceCode/@displayName"/>
														<xsl:with-param name="raceCodeText" select="n1:recordTarget/n1:patientRole/n1:patient/n1:raceCode/n1:originalText"/>
														<xsl:with-param name="sdtc-raceCodeText" select="n1:recordTarget/n1:patientRole/n1:patient/sdtc:raceCode/n1:originalText"/>
													</xsl:call-template>
													<!--  
													<xsl:for-each
														select="n1:recordTarget/n1:patientRole/n1:patient/n1:raceCode">
														<xsl:call-template name="show-race-ethnicity" />
													</xsl:for-each>
													-->
														
												</td>
											</tr>

											<tr valign="top">
												<th>Ethnicity</th>
												<td>
													<xsl:choose>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:ethnicGroupCode/@displayName">
																<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:ethnicGroupCode/@displayName"/>
														</xsl:when>
														<xsl:when test="n1:recordTarget/n1:patientRole/n1:patient/n1:ethnicGroupCode/n1:originalText">
																<xsl:value-of select="n1:recordTarget/n1:patientRole/n1:patient/n1:ethnicGroupCode/n1:originalText"/>
														</xsl:when>
													</xsl:choose>
													<!--   
													<xsl:for-each
														select="n1:recordTarget/n1:patientRole/n1:patient/n1:ethnicGroupCode">
														<xsl:call-template name="show-race-ethnicity" />
													</xsl:for-each>
													-->
												</td>
											</tr>

											<tr valign="top">
												<th>Language(s)</th>
												<td>
													<xsl:for-each select="n1:recordTarget/n1:patientRole/n1:patient/n1:languageCommunication">
														<xsl:call-template name="show-language">
															<xsl:with-param name="langCode" select="n1:languageCode"/>
															<xsl:with-param name="modeCode" select="n1:modeCode"/>
														</xsl:call-template>
														<xsl:if test="position()!=last()">
															<xsl:text>, </xsl:text>
														</xsl:if>
													</xsl:for-each>
												</td>
											</tr>
											<tr valign="top">
												<th>Preferred Language</th>
												<td>
													<xsl:for-each select="n1:recordTarget/n1:patientRole/n1:patient/n1:languageCommunication">
														<xsl:call-template name="pref-language">
															<xsl:with-param name="langCode" select="n1:languageCode"/>
															<xsl:with-param name="prefLang" select="n1:preferenceInd"/>
															<xsl:with-param name="modeCode" select="n1:modeCode"/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
											</tr>
											<!-- <xsl:for-each select="n1:author/n1:assignedAuthor"> <tr valign="top"> 
												<th> Author </th> <td> <xsl:choose> <xsl:when test="n1:assignedPerson/n1:name"> 
												<xsl:call-template name="show-name"> <xsl:with-param name="name" select="n1:assignedPerson/n1:name"/> 
												</xsl:call-template> </xsl:when> <xsl:when test="n1:assignedAuthoringDevice/n1:softwareName"> 
												<xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName"/> </xsl:when> 
												<xsl:when test="n1:representedOrganization"> <xsl:call-template name="show-name"> 
												<xsl:with-param name="name" select="n1:representedOrganization/n1:name"/> 
												</xsl:call-template> </xsl:when> <xsl:otherwise> <xsl:for-each select="n1:id"> 
												<xsl:call-template name="show-id"/> <br/> </xsl:for-each> </xsl:otherwise> 
												</xsl:choose> </td> </tr> <xsl:if test="n1:addr | n1:telecom"> <tr valign="top"> 
												<th> Contact info </th> <td> <xsl:call-template name="show-contactInfo"> 
												<xsl:with-param name="contact" select="."/> </xsl:call-template> </td> </tr> 
												</xsl:if> </xsl:for-each> -->
										</tbody>
									</table>
								</div>
							</div>	

                                                        <div class="col-1">
								<div id="section.Contact Information" class="input">
									<xsl:choose>
										<xsl:when test="n1:participant">
										<table>
											<thead>
												<tr>
													<th colspan="2">Contact Information</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="n1:participant">
													<xsl:call-template name="participant"/>
												</xsl:for-each>
											</tbody>
										</table>
											</xsl:when>
										<xsl:otherwise>
											<xsl:text>No data provided for this section.</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</div>								
                                                    </div>
							
						</section>
						<section id="Healthcare Providers">
							<header>
								<h2>
									<label id="plus.Healthcare Providers" onclick="javascript:toggle('open','Healthcare Providers')">[+]</label>
									<label id="minus.Healthcare Providers" onclick="javascript:toggle('close','Healthcare Providers')">[-]</label>
								
								Healthcare Providers</h2>
								<!--<p><strong>Business Rules for Construction of Medical Information:</strong> 
									Business Rules description of the section goes here.</p> -->
							</header>
							<div id="section.Healthcare Providers">
							<xsl:choose>
								<xsl:when test="n1:documentationOf/n1:serviceEvent/n1:performer">
									<xsl:call-template name="documentationOf"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>No data provided for this section.</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							</div>
						</section>
                                                
                                                <xsl:apply-templates select="n1:component/n1:structuredBody|n1:component/n1:nonXMLBody"/>
					</div>
				</div>
				<!--<xsl:call-template name="recordTarget"/> <p/> <xsl:call-template 
					name="documentGeneral"/> <p/> <xsl:call-template name="documentationOf"/> 
					<p/> <xsl:call-template name="author"/> <p/> <xsl:call-template name="componentof"/> 
					<p/> <xsl:call-template name="participant"/> <p/> <xsl:call-template name="dataEnterer"/> 
					<p/> <xsl:call-template name="authenticator"/> <p/> <xsl:call-template name="informant"/> 
					<p/> <xsl:call-template name="informationRecipient"/> <p/> <xsl:call-template 
					name="legalAuthenticator"/> <p/> <xsl:call-template name="custodian"/> <p/> -->
				<!-- END display top portion of clinical document -->
				<!-- produce table of contents <xsl:if test="not(//n1:nonXMLBody)"> <xsl:if 
					test="count(/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component[n1:section]) 
					&gt; 1"> <xsl:call-template name="make-tableofcontents"/> </xsl:if> </xsl:if> 
					<p/> <hr align="left" color="teal" size="2" width="80%"/> <p/> -->
				<!-- produce human readable document content -->
				<script LANGUAGE="javascript" DEFER="true">
					<xsl:comment><![CDATA[
					
                                            document.onreadystatechange = function()
                                            {
                                                    if(document.readyState === 'complete')
                                                    {
                                                            var count = 0;
                                                            var sections = document.getElementsByTagName("section");
                                                            while (count<sections.length)
                                                            {
                                                                    var s = sections[count++].id;
                                                                    toggle("open", s);
                                                            }

                                                            toggle("open","TOC")
                                                    }
                                            };


                                            function toggle(state, elemId) {
                                                    var plus = document.getElementById("plus." + elemId);
                                                    var minus = document.getElementById("minus." + elemId);
                                                    var info = document.getElementById("section." + elemId);
                                                    if (state == "open")
                                                    {
                                                            info.style.display="inline";
                                                            plus.style.display="none";
                                                            minus.style.display="inline";
                                                    }
                                                    else
                                                    {
                                                            info.style.display="none";
                                                            plus.style.display="inline";
                                                            minus.style.display="none";
                                                    }	
													setBodyPadding();
                                            }

                                            var hasClass = function(elem, className){
                                                    return new RegExp(' ' + className + ' ').test(' ' + elem.className + ' ');
                                            }

                                            var addClass = function(elem, className){
                                                    if (!hasClass(elem, className)) {
                                                            elem.className += ' ' + className;
                                                    }
                                            }

                                            var removeClass = function(elem, className){
                                                    var newClass = ' ' + elem.className.replace( /[\t\r\n]/g, ' ') + ' ';
                                                    if (hasClass(elem, className)) {
                                                            while (newClass.indexOf(' ' + className + ' ') >= 0 ) {
                                                                    newClass = newClass.replace(' ' + className + ' ', ' ');
                                                            }
                                                            elem.className = newClass.replace(/^\s+|\s+$/g, '');
                                                    }
                                            }

                                            function getOffset(el) {
                                                    var _x = 0,
                                                            _y = 0;
                                                    while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
                                                            _x += el.offsetLeft - el.scrollLeft;
                                                            _y += el.offsetTop - el.scrollTop;
                                                            el = el.offsetParent;
                                                    }
                                                    return { top: _y, left: _x };
                                            }


                                            var easing = {
                                                    linear: function (t) { return t },
                                                    easeInQuad: function (t) { return t*t },
                                                    easeOutQuad: function (t) { return t*(2-t) },
                                                    easeInOutQuad: function (t) { return t<.5 ? 2*t*t : -1+(4-2*t)*t },
                                                    easeInCubic: function (t) { return t*t*t },
                                                    easeOutCubic: function (t) { return (--t)*t*t+1 },
                                                    easeInOutCubic: function (t) { return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1 },
                                                    easeInQuart: function (t) { return t*t*t*t },
                                                    easeOutQuart: function (t) { return 1-(--t)*t*t*t },
                                                    easeInOutQuart: function (t) { return t<.5 ? 8*t*t*t*t : 1-8*(--t)*t*t*t },
                                                    easeInQuint: function (t) { return t*t*t*t*t },
                                                    easeOutQuint: function (t) { return 1+(--t)*t*t*t*t },
                                                    easeInOutQuint: function (t) { return t<.5 ? 16*t*t*t*t*t : 1+16*(--t)*t*t*t*t }
                                            };
											var titlebar_height = 0;
											var setBodyPadding = function() {
                                                titlebar_height = document.getElementById('titlebar-container').offsetHeight;
												document.body.style.padding = titlebar_height+"px 0 0";
											};

                                            if ('querySelector' in document && 'addEventListener' in window && Array.prototype.forEach){
                                                    window.addEventListener('load', function(){

                                                            var backtotop = document.getElementById('backtotop'),
                                                                    titlebar = document.getElementById('titlebar'),
                                                                    titlebar_container = document.getElementById('titlebar-container');

                                                            // titlebar isn't fixed without javascript
                                                            // we know we have javascript enabled now, so set the titlebar as fixed, and offset the body with padding to match
                                                            addClass(titlebar_container, 'fixed');
                                                            //document.body.style.padding = titlebar_height+"px 0 0";
															setBodyPadding();

                                                            // jumplinks
                                                            var subnavlinks = document.querySelectorAll('.toc a');
                                                            [].forEach.call(subnavlinks, function(l){
                                                                    l.addEventListener('click', function(e){
                                                                            e.preventDefault();
                                                                            var target = l.getAttribute('data-target');
                                                                            goToJumpLink(target);
                                                                    }, false);
                                                            });

                                                            // if the user comes to this screen with a hash in the url, attempt to jump to that section
                                                            var url = location.href;
                                                            var anchorPos = url.indexOf("#");
                                                            if (anchorPos != -1){
                                                                    target = url.substr(anchorPos+1);
                                                                    goToJumpLink(target);
                                                            }

                                                            // back-to-top button
                                                            backtotop.addEventListener('click', function(e){
                                                                    goToJumpLink('top');
                                                            }, false);

                                                            var listener = function () {
                                                                    var y = window.pageYOffset;

                                                                    if (y >= titlebar_height) {
                                                                            addClass(backtotop, 'active');
                                                                    } else {
                                                                            removeClass(backtotop, 'active');
                                                                    }
                                                            };
                                                            window.addEventListener('scroll', listener, false);

                                                            // animate to a particualr anchor on the page
                                                            function goToJumpLink(el){
                                                                    var jump = document.getElementById(el),
                                                                            t = getOffset(jump).top,
                                                                            scrolltop = document.body.scrollTop,
                                                                            newscrolltop = (t-(titlebar_height-2))+scrolltop;

                                                                    window.scroll(0, newscrolltop);
                                                            }
                                                    });
                                                    window.addEventListener("resize", function () { setBodyPadding(); });
                                            }
                                            
                                         
                                        //Sort TOC buttons using element value based on document type
                                        if ($('#doc_type').attr('content')==='ses'){
                                            var $tocWrapper = $('#ses_toc_list');                                            
                                        }else{
                                            var $tocWrapper = $('#ccda_toc_list');
                                        }
                                        
                                        $tocWrapper.children().sort(function (a, b) {
                                            return +a.getAttribute('value') - +b.getAttribute('value');
                                        })
                                        .appendTo( $tocWrapper );

					
                                        
					]]></xsl:comment>
				</script>
			</body>
		</html>
	</xsl:template>
		<!-- generate table of contents   -->
	<xsl:template name="make-tableofcontents">
		<xsl:variable name="compTemplateIdRoots" select="n1:component/n1:structuredBody/n1:component/n1:section/n1:templateId/@root"/>
		<xsl:variable name="sections" select="n1:component/n1:structuredBody/n1:component/n1:section"/>

		<!--<h2> <a name="toc">Table of Contents</a> </h2> <div style="margin-left 
			: 2em;"> -->
		<!-- CCD ToC -->
		<!-- Progress notes ToC -->
		<xsl:choose>
			<xsl:when test="contains($progDocTemplateRoot, $progressDoc)">
				<!--<li> <a href="#{generate-id(Demographics)}"> <xsl:text>Demographics</xsl:text> 
					</a> </li> -->
				<ul>
					<li>
						<a data-target="patient-information" href="#patient-information">
							<xsl:value-of select="'Patient &amp; Contact Information'"/>
						</a>
                                                <xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/n1:performer">
								<a data-target="healthcare-providers" href="#healthcare-providers">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="healthcare-providers" href="#healthcare-providers" class="disabled">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="$progressTemplateIdArrayParam">
							<xsl:variable name="templateId">
								<xsl:value-of select="."/>
							</xsl:variable>

							<!--<xsl:if test="$compTemplateIdRoots = $templateId or $compTemplateIdRoots 
								= concat($templateId,'.1')"> -->
							<xsl:variable name="pos-int" select="position()"/>
							<!--<xsl:value-of select="$pos-int" /> -->
							<xsl:variable name="headerValue">
								<xsl:value-of select="$progSectionHeaderParam[$pos-int]"/>
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text"/>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="contains($headerTxt, 'No Information')">
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:when>
								<xsl:when test="string-length($headerTxt) > 0">
									<a data-target="{$headerValue}" href="#{$headerValue}">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:otherwise>

							</xsl:choose>
						</xsl:for-each>
					</li>
				</ul>
			</xsl:when>
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<!-- <li> <a href="#{generate-id(Demographics)}"> <xsl:text>Demographics</xsl:text> 
					</a> </li> -->
				<ul>
					<li>
						<a data-target="patient-information" href="#patient-information">
							<xsl:value-of select="'Patient &amp; Contact Information'"/>
						</a>
                                                <xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/n1:performer">
								<a data-target="healthcare-providers" href="#healthcare-providers">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="healthcare-providers" href="#healthcare-providers" class="disabled">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>						

						<xsl:for-each select="$ccdTemplateIdArrayParam">
							<xsl:variable name="templateId">
								<xsl:value-of select="."/>
							</xsl:variable>

							<!--<xsl:if test="$compTemplateIdRoots = $templateId or $compTemplateIdRoots 
								= concat($templateId,'.1')"> -->
							<xsl:variable name="pos-int" select="position()"/>
							<!--<xsl:value-of select="$pos-int" /> -->
							<xsl:variable name="headerValue">
								<xsl:value-of select="$ccdSectionHeaderParam[$pos-int]"/>
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text"/>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="contains($headerTxt, 'No Information')">
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:when>
								<xsl:when test="string-length($headerTxt) > 0">
									<a data-target="{$headerValue}" href="#{$headerValue}">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue"/>
									</a>
								</xsl:otherwise>

							</xsl:choose>
						</xsl:for-each>
					</li>
				</ul>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- DYNAMIC VERSION generate table of contents     -->
	<xsl:template name="make-tableofcontents-dynamic">
		<xsl:variable name="compTemplateIdRoots" select="n1:component/n1:structuredBody/n1:component/n1:section/n1:templateId/@root"/>
		<!--  
		<xsl:variable name="sections"
			select="n1:component/n1:structuredBody/n1:component/n1:section" />
		-->
		<xsl:variable name="components" select="n1:component/n1:structuredBody/n1:component"/>

		<!--<h2> <a name="toc">Table of Contents</a> </h2> <div style="margin-left 
			: 2em;"> -->
		<!-- CCD ToC -->
		<!-- Progress notes ToC -->
		<xsl:choose>           
			<xsl:when test="contains($progDocTemplateRoot, $progressDoc)">
				<!--<li> <a href="#{generate-id(Demographics)}"> <xsl:text>Demographics</xsl:text> 
					</a> </li> -->
				<ul>
					<li id="ses_toc_list">
						<a data-target="patient-information" href="#patient-information" value="0">
							<xsl:value-of select="'Patient &amp; Contact Information'"/>
						</a>
                                                <xsl:choose> 
							<xsl:when test="n1:documentationOf/n1:serviceEvent/@classCode='PCPR' and count(n1:documentationOf/n1:serviceEvent/n1:performer) > 0">
								<a data-target="Healthcare Providers" href="#Healthcare Providers" value="1">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Healthcare Providers" href="#Healthcare Providers" class="disabled" value="1">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:otherwise>
                                                        
						</xsl:choose>
                                                <div style="padding:10px;" title="horizontal linebreak1" value="3">
                                                            <hr/>
                                                </div>
                                                <div style="padding:10px;" title="horizontal linebreak1" value="15">
                                                            <hr/>
                                                </div>
						<xsl:for-each select="$components">
                                                    <!-- establishing variables for TOC buttons-->
							<xsl:variable name="templateId">
								<xsl:choose>
									<xsl:when test="n1:section/n1:templateId[2]//@root">
										<xsl:value-of select="n1:section/n1:templateId[2]/@root"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="n1:section/n1:templateId/@root"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="entryCount">
								<xsl:value-of select="count(n1:section/*[not(n1:text) and not(n1:templateId) and not(n1:title) and not(n1:code)])"/>
							</xsl:variable>
                                                        
							<xsl:variable name="loincCode">
                                                            <xsl:value-of select="n1:section/n1:code/@code"/>
                                                        </xsl:variable>
							<xsl:variable name="headerValue">
								<xsl:call-template name="getSectionHeaderText">
									<xsl:with-param name="loincCode" select="$loincCode"/>
								</xsl:call-template> 							
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of select="n1:section/n1:text"/>
							</xsl:variable>
                                                        
                                                        <xsl:variable name="position" select="position()"/>
                                                        <xsl:variable name="value">                                                           
                                                            <xsl:call-template name="getSESTocSectionPosition"> 
                                                                <xsl:with-param name="loincCode" select="$loincCode"/>
                                                                <xsl:with-param name="position" select="$position"/>
                                                            </xsl:call-template>
                                                        </xsl:variable>

							<!-- Decide to display and/or disable buttons -->
							<xsl:if test="string-length($templateId) > 0">
								<xsl:if test="string-length($headerValue) > 0">
									<xsl:choose>
										<xsl:when test="n1:section/n1:text/n1:list/n1:item">
											<a data-target="{$headerValue}" href="#{$headerValue}" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:when test="contains($headerTxt, 'No Data')">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:when test="n1:section/@nullFlavor">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:when test="$entryCount = 0">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
<!--							 <xsl:choose> 
                                                            <xsl:when test="$isSES">
                                                                <xsl:if test="$loincCode='48768-6' or $loincCode='11450-4'"> 
                                                                    <div style="padding:10px;">
                                                                        <hr /> 
                                                                    </div>
                                                                </xsl:if>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:if test="$loincCode='48768-6'"> 
                                                                    <div style="padding:10px;">
                                                                        <hr /> 
                                                                    </div>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>-->
						</xsl:for-each>
					</li>
				</ul>
			</xsl:when>
                    <!-- Start CCD  Dynamic TOC generation -->
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<ul>
					<li id="ccda_toc_list">
						<a data-target="patient-information" href="#patient-information" title="Patient Information" value="0">
							<xsl:value-of select="'Patient &amp; Contact Information'"/>
						</a>
<!--                                            <xsl:choose>
							<xsl:when test="n1:participant">
								<a data-target="Contact Information" href="#Contact Information"  title="Contact Information">
                                                                     <xsl:value-of select="'Contact Information'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Contact Information" href="#Contact Information" class="disabled">
									<xsl:value-of select="'Contact Information'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>-->
						<xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/@classCode='PCPR' and count(n1:documentationOf/n1:serviceEvent/n1:performer) > 0">
								<a data-target="Healthcare Providers" href="#Healthcare Providers" title="Healthcare Providers" value="1">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Healthcare Providers" href="#Healthcare Providers" class="disabled" value="1">
									<xsl:value-of select="'Healthcare Providers'"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
                                                
                                                <div style="padding:10px;" title="horizontal linebreak1" value="3">
                                                            <hr/>
                                                </div>
                                                <div style="padding:10px;" title="horizontal linebreak1" value="16">
                                                            <hr/>
                                                </div>
                                                
						<xsl:for-each select="$components">
                                                    <!-- set TOC variables from template -->
							<xsl:variable name="templateId">
								<xsl:choose>
									<xsl:when test="n1:section/n1:templateId[2]">
										<xsl:value-of select="n1:section/n1:templateId[2]/@root"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="n1:section/n1:templateId/@root"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="entryCount">
								<xsl:value-of select="count(n1:section/*[not(n1:text) and not(n1:templateId) and not(n1:title) and not(n1:code)])"/>
							</xsl:variable>
							<xsl:variable name="loincCode">
                                                            <xsl:value-of select="n1:section/n1:code/@code"/>
                                                        </xsl:variable>
							<xsl:variable name="headerValue">
                                                            <xsl:call-template name="getSectionHeaderText">
									<xsl:with-param name="loincCode" select="$loincCode"/>
                                                                        <xsl:with-param name="templateId" select="$templateId"/>
                                                                        <xsl:with-param name="notesIdNum" select="string('2.16.840.1.113883.10.20.22.2.65')"/>
                                                            </xsl:call-template> 
                                                        </xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of select="n1:section/n1:text"/>
							</xsl:variable>
                                                        
                                                        <xsl:variable name="position" select="position()"/>
                                                        <xsl:variable name="value">                                                           
                                                            <xsl:call-template name="getCCDATocSectionPosition"> 
                                                                <xsl:with-param name="loincCode" select="$loincCode"/>
                                                                <xsl:with-param name="position" select="$position"/>
                                                            </xsl:call-template>
                                                        </xsl:variable>
							
							<!-- Decide to display and/or disable buttons -->
							<xsl:if test="string-length($templateId) > 0">
								<xsl:if test="string-length($headerValue) > 0">
									<xsl:choose>
										<xsl:when test="$entryCount = 0">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:when test="contains($headerTxt, 'No Data')">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:when test="n1:section/@nullFlavor">
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" class="disabled" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a data-target="{$headerValue}" href="#{$headerValue}" id="{$loincCode}" title="{n1:section/n1:title}" value="{$value}">
											<xsl:value-of select="$headerValue"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
                                                        <!-- these are the first two terminal entries in each of the "sections" that need to be de-lineated in the TOC -->
<!--                                                        <xsl:choose> 
                                                            <xsl:when test="$hasExtension or $isSES">
                                                                <xsl:if test="$loincCode='48768-6' or $loincCode='8716-3'"> 
                                                                    <div style="padding:10px;">
                                                                        <hr /> 
                                                                    </div>
                                                                </xsl:if>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:if test="$loincCode='48768-6'"> 
                                                                    <div style="padding:10px;">
                                                                        <hr /> 
                                                                    </div>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>-->
                                                        
						</xsl:for-each>
					</li>
				</ul>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- header elements -->
	<xsl:template name="documentGeneral">
		<fieldset>
			<legend>
				<b>Document Information</b>
			</legend>
			<table>
				<tbody>
					<tr>
						<td>
							<label>
								<b>Document Id: </b>
							</label>
						</td>
						<td>
							<xsl:call-template name="show-id">
								<xsl:with-param name="id" select="n1:id"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td>
							<label>
								<b>Document Created: </b>
							</label>
						</td>
						<td>
							<xsl:call-template name="show-time">
								<xsl:with-param name="datetime" select="n1:effectiveTime"/>
							</xsl:call-template>
						</td>
					</tr>
				</tbody>
			</table>
		</fieldset>
	</xsl:template>
	<!-- confidentiality -->
	<xsl:template name="confidentiality">
		<table class="header_table">
			<tbody>
				<td width="20%" bgcolor="#3399ff">
					<xsl:text>Confidentiality</xsl:text>
				</td>
				<td width="80%">
					<xsl:choose>
						<xsl:when test="n1:confidentialityCode/@code  = 'N'">
							<xsl:text>Normal</xsl:text>
						</xsl:when>
						<xsl:when test="n1:confidentialityCode/@code  = 'R'">
							<xsl:text>Restricted</xsl:text>
						</xsl:when>
						<xsl:when test="n1:confidentialityCode/@code  = 'V'">
							<xsl:text>Very restricted</xsl:text>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="n1:confidentialityCode/n1:originalText">
						<xsl:text> </xsl:text>
						<xsl:value-of select="n1:confidentialityCode/n1:originalText"/>
					</xsl:if>
				</td>
			</tbody>
		</table>
	</xsl:template>
	<!-- author -->
	<xsl:template name="author">
		<xsl:if test="n1:author">
			<div class="columns">
				<div class="col-2">
					<table>
						<thead>
							<tr>
								<th colspan="2">Author Information</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="n1:author/n1:assignedAuthor">
								<tr valign="top">
									<th>
										Author
									</th>
									<td>
										<xsl:choose>
											<xsl:when test="n1:assignedPerson/n1:name">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name" select="n1:assignedPerson/n1:name"/>
												</xsl:call-template>
												<!--<xsl:if test="n1:representedOrganization"> <xsl:text>, </xsl:text> 
													<xsl:call-template name="show-name"> <xsl:with-param name="name" select="n1:representedOrganization/n1:name"/> 
													</xsl:call-template> </xsl:if> -->
											</xsl:when>
											<xsl:when test="n1:assignedAuthoringDevice/n1:softwareName">
												<xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName"/>
											</xsl:when>
											<xsl:when test="n1:representedOrganization">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name" select="n1:representedOrganization/n1:name"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="n1:id">
													<xsl:call-template name="show-id"/>
													<br/>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<xsl:if test="n1:addr | n1:telecom">
									<tr valign="top">
										<th>
											Contact info
										</th>
										<td>
											<xsl:call-template name="show-contactInfo">
												<xsl:with-param name="contact" select="."/>
											</xsl:call-template>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- authenticator -->
	<xsl:template name="authenticator">
		<xsl:if test="n1:authenticator">
			<fieldset>
				<legend>
					<b>Authenticator Information</b>
				</legend>
				<table>
					<tbody>
						<xsl:for-each select="n1:authenticator">
							<tr>
								<td>
									<label>
										<b>Signed: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-name">
										<xsl:with-param name="name" select="n1:assignedEntity/n1:assignedPerson/n1:name"/>
									</xsl:call-template>
									<xsl:text> at </xsl:text>
									<xsl:call-template name="show-time">
										<xsl:with-param name="date" select="n1:time"/>
									</xsl:call-template>
								</td>
							</tr>
							<xsl:if test="n1:assignedEntity/n1:addr | n1:assignedEntity/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact" select="n1:assignedEntity"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- legalAuthenticator -->
	<xsl:template name="legalAuthenticator">
		<xsl:if test="n1:legalAuthenticator">
			<fieldset>
				<legend>
					<b>Legal Authenticator Information</b>
				</legend>
				<table>
					<tbody>
						<tr>
							<td>
								<label>
									<b>Legal authenticator: </b>
								</label>
							</td>
							<td>
								<xsl:call-template name="show-assignedEntity">
									<xsl:with-param name="asgnEntity" select="n1:legalAuthenticator/n1:assignedEntity"/>
								</xsl:call-template>
								<xsl:text> </xsl:text>
								<xsl:call-template name="show-sig">
									<xsl:with-param name="sig" select="n1:legalAuthenticator/n1:signatureCode"/>
								</xsl:call-template>
								<xsl:if test="n1:legalAuthenticator/n1:time/@value">
									<xsl:text> at </xsl:text>
									<xsl:call-template name="show-time">
										<xsl:with-param name="datetime" select="n1:legalAuthenticator/n1:time"/>
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
						<xsl:if test="n1:legalAuthenticator/n1:assignedEntity/n1:addr | n1:legalAuthenticator/n1:assignedEntity/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact" select="n1:legalAuthenticator/n1:assignedEntity"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- dataEnterer -->
	<xsl:template name="dataEnterer">
		<xsl:if test="n1:dataEnterer">
			<fieldset>
				<legend>
					<b>Data Enterer Information</b>
				</legend>
				<table>
					<tbody>
						<tr>
							<td>
								<label>
									<b>Entered by: </b>
								</label>
							</td>
							<td width="80%">
								<xsl:call-template name="show-assignedEntity">
									<xsl:with-param name="asgnEntity" select="n1:dataEnterer/n1:assignedEntity"/>
								</xsl:call-template>
							</td>
						</tr>
						<xsl:if test="n1:dataEnterer/n1:assignedEntity/n1:addr | n1:dataEnterer/n1:assignedEntity/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact" select="n1:dataEnterer/n1:assignedEntity"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- componentOf -->
	<xsl:template name="componentof">
		<xsl:if test="n1:componentOf">
			<fieldset>
				<legend>
					<b>Component Information</b>
				</legend>
				<table>
					<tbody>
						<xsl:for-each select="n1:componentOf/n1:encompassingEncounter">
							<xsl:if test="n1:id">
								<tr>
									<xsl:choose>
										<xsl:when test="n1:code">
											<td>
												<label>
													<b>Encounter Id: </b>
												</label>
											</td>
											<td>
												<xsl:call-template name="show-id">
													<xsl:with-param name="id" select="n1:id"/>
												</xsl:call-template>
											</td>
											<td>
												<label>
													<b>Encounter Type: </b>
												</label>
											</td>
											<td>
												<xsl:call-template name="show-code">
													<xsl:with-param name="code" select="n1:code"/>
												</xsl:call-template>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<label>
													<b>Encounter Id: </b>
												</label>
											</td>
											<td>
												<xsl:call-template name="show-id">
													<xsl:with-param name="id" select="n1:id"/>
												</xsl:call-template>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
							</xsl:if>
							<tr>
								<td>
									<label>
										<b>Encounter Date: </b>
									</label>
								</td>
								<td>
									<xsl:if test="n1:effectiveTime">
										<xsl:choose>
											<xsl:when test="n1:effectiveTime/@value">
												<xsl:text> at </xsl:text>
												<xsl:call-template name="show-time">
													<xsl:with-param name="datetime" select="n1:effectiveTime"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="n1:effectiveTime/n1:low">
												<xsl:text> From </xsl:text>
												<xsl:call-template name="show-time">
													<xsl:with-param name="datetime" select="n1:effectiveTime/n1:low"/>
												</xsl:call-template>
												<xsl:if test="n1:effectiveTime/n1:high">
													<xsl:text> to </xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime" select="n1:effectiveTime/n1:high"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
								</td>
							</tr>
							<xsl:if test="n1:location/n1:healthCareFacility">
								<tr>
									<td>
										<label>
											<b>Encounter Location: </b>
										</label>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="n1:location/n1:healthCareFacility/n1:location/n1:name">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name" select="n1:location/n1:healthCareFacility/n1:location/n1:name"/>
												</xsl:call-template>
												<xsl:for-each select="n1:location/n1:healthCareFacility/n1:serviceProviderOrganization/n1:name">
													<xsl:text> of </xsl:text>
													<xsl:call-template name="show-name">
														<xsl:with-param name="name" select="n1:location/n1:healthCareFacility/n1:serviceProviderOrganization/n1:name"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:when>
											<xsl:when test="n1:location/n1:healthCareFacility/n1:code">
												<xsl:call-template name="show-code">
													<xsl:with-param name="code" select="n1:location/n1:healthCareFacility/n1:code"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="n1:location/n1:healthCareFacility/n1:id">
													<xsl:text>id: </xsl:text>
													<xsl:for-each select="n1:location/n1:healthCareFacility/n1:id">
														<xsl:call-template name="show-id">
															<xsl:with-param name="id" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="n1:responsibleParty">
								<tr>
									<td>
										<label>
											<b>Responsible party: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-assignedEntity">
											<xsl:with-param name="asgnEntity" select="n1:responsibleParty/n1:assignedEntity"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="n1:responsibleParty/n1:assignedEntity/n1:addr | n1:responsibleParty/n1:assignedEntity/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact" select="n1:responsibleParty/n1:assignedEntity"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>
	<!-- custodian -->
	<xsl:template name="custodian">
		<xsl:if test="n1:custodian">
			<fieldset>
				<legend>
					<b>Legal Authenticator Information</b>
				</legend>
				<table>
					<tbody>
						<tr>
							<td>
								<label>
									<b>Document maintained by: </b>
								</label>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name">
										<xsl:call-template name="show-name">
											<xsl:with-param name="name" select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:id">
											<xsl:call-template name="show-id"/>
											<xsl:if test="position()!=last()">
												<br/>
											</xsl:if>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<xsl:if test="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:addr |             n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact" select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- documentationOf -->
	<xsl:template name="documentationOf">
		<xsl:if test="n1:documentationOf">
			<table>
				<thead>
					<tr>
						<th>Name</th>
						<th>Provider Type</th>
						<th>Address</th>
						<th>Telephone Number</th>
						<th>Facility</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="n1:documentationOf">
						<xsl:if test="n1:serviceEvent/@classCode and n1:serviceEvent/n1:code">
							<xsl:variable name="displayName">
								<xsl:call-template name="show-actClassCode">
									<xsl:with-param name="clsCode" select="n1:serviceEvent/@classCode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$displayName">
								<tr valign="top">
									<td>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="n1:serviceEvent/n1:code"/>
										</xsl:call-template>
										<xsl:if test="n1:serviceEvent/n1:effectiveTime">
											<xsl:choose>
												<xsl:when test="n1:serviceEvent/n1:effectiveTime/@value">
													<xsl:text> at </xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime" select="n1:serviceEvent/n1:effectiveTime"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="n1:serviceEvent/n1:effectiveTime/n1:low">
													<xsl:text> from </xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime" select="n1:serviceEvent/n1:effectiveTime/n1:low"/>
													</xsl:call-template>
													<xsl:if test="n1:serviceEvent/n1:effectiveTime/n1:high">
														<xsl:text> to </xsl:text>
														<xsl:call-template name="show-time">
															<xsl:with-param name="datetime" select="n1:serviceEvent/n1:effectiveTime/n1:high"/>
														</xsl:call-template>
													</xsl:if>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
									</td>
								</tr>
							</xsl:if>
						</xsl:if>
						<xsl:for-each select="n1:serviceEvent/n1:performer">
							<xsl:if test="n1:functionCode/n1:originalText">							
							<xsl:variable name="displayName">
								<!-- DEFECT#177018: Display originalText instead of displayName -->
								<xsl:if test="n1:functionCode/n1:originalText">
									<xsl:value-of select="n1:functionCode/n1:originalText"/>
								</xsl:if>
								<!-- <xsl:call-template name="show-participationType"> <xsl:with-param 
									name="ptype" select="@typeCode"/> </xsl:call-template> <xsl:text> </xsl:text> 
									<xsl:if test="n1:functionCode/@code"> <xsl:call-template name="show-participationFunction"> 
									<xsl:with-param name="pFunction" select="n1:functionCode/@code"/> </xsl:call-template> 
									</xsl:if> -->
							</xsl:variable>
							<!-- CCM-028 remove facility name from provider name -->
							<xsl:variable name="providerName">
								<xsl:choose>
									<xsl:when test="n1:assignedEntity/n1:assignedPerson/n1:name">
										<xsl:value-of select="n1:assignedEntity/n1:assignedPerson/n1:name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="show-assignedEntity">
											<xsl:with-param name="asgnEntity" select="n1:assignedEntity"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr valign="top">
								<th>
									<xsl:value-of select="$providerName"/>
								</th>
								<th>
									<xsl:value-of select="$displayName"/>
								</th>
								<th>
									<xsl:if test="not(n1:assignedEntity/n1:addr/@nullFlavor)">
										<xsl:call-template name="show-address">
											<xsl:with-param name="address" select="n1:assignedEntity/n1:addr"/>
										</xsl:call-template>
									</xsl:if>
								</th>
								<th>
									<xsl:if test="not(n1:assignedEntity/n1:telecom/@nullFlavor)">
										<xsl:call-template name="show-telecom">
											<xsl:with-param name="telecom" select="n1:assignedEntity/n1:telecom"/>
										</xsl:call-template>
									</xsl:if>
								</th>
								<th>
									<xsl:if test="n1:assignedEntity/n1:representedOrganization">
										<xsl:value-of select="n1:assignedEntity/n1:representedOrganization/n1:name"/>
									</xsl:if>
								</th>
							</tr>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>

	<!-- inFulfillmentOf -->
	<xsl:template name="inFulfillmentOf">
		<xsl:if test="n1:infulfillmentOf">
			<table class="header_table">
				<tbody>
					<xsl:for-each select="n1:inFulfillmentOf">
						<tr>
							<td width="20%" bgcolor="#3399ff">
								<span class="td_label">
									<xsl:text>In fulfillment of</xsl:text>
								</span>
							</td>
							<td width="80%">
								<xsl:for-each select="n1:order">
									<xsl:for-each select="n1:id">
										<xsl:call-template name="show-id"/>
									</xsl:for-each>
									<xsl:for-each select="n1:code">
										<xsl:text> </xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="."/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="n1:priorityCode">
										<xsl:text> </xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="."/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- informant -->
	<xsl:template name="informant">
		<xsl:if test="n1:informant">
			<fieldset>
				<legend>
					<b>Informant Information</b>
				</legend>
				<table>
					<tbody>
						<xsl:for-each select="n1:informant">
							<tr>
								<td>
									<label>
										<b>Informant: </b>
									</label>
								</td>
								<td>
									<xsl:if test="n1:assignedEntity">
										<xsl:call-template name="show-assignedEntity">
											<xsl:with-param name="asgnEntity" select="n1:assignedEntity"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="n1:relatedEntity">
										<xsl:call-template name="show-relatedEntity">
											<xsl:with-param name="relatedEntity" select="n1:relatedEntity"/>
										</xsl:call-template>
									</xsl:if>
								</td>
							</tr>
							<xsl:choose>
								<xsl:when test="n1:assignedEntity/n1:addr | n1:assignedEntity/n1:telecom">
									<tr>
										<td>
											<label>
												<b>Contact info: </b>
											</label>
										</td>
										<td>
											<xsl:if test="n1:assignedEntity">
												<xsl:call-template name="show-contactInfo">
													<xsl:with-param name="contact" select="n1:assignedEntity"/>
												</xsl:call-template>
											</xsl:if>
										</td>
									</tr>
								</xsl:when>
								<xsl:when test="n1:relatedEntity/n1:addr | n1:relatedEntity/n1:telecom">
									<tr>
										<td>
											<label>
												<b>Contact info: </b>
											</label>
										</td>
										<td>
											<xsl:if test="n1:relatedEntity">
												<xsl:call-template name="show-contactInfo">
													<xsl:with-param name="contact" select="n1:relatedEntity"/>
												</xsl:call-template>
											</xsl:if>
										</td>
									</tr>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- informantionRecipient -->
	<xsl:template name="informationRecipient">
		<xsl:if test="n1:informationRecipient">
			<fieldset>
				<legend>
					<b>Recipient Information</b>
				</legend>
				<table>
					<tbody>
						<xsl:for-each select="n1:informationRecipient">
							<tr>
								<td>
									<label>
										<b>Information recipient: </b>
									</label>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="n1:intendedRecipient/n1:informationRecipient/n1:name">
											<xsl:for-each select="n1:intendedRecipient/n1:informationRecipient">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name" select="n1:name"/>
												</xsl:call-template>
												<xsl:if test="position() != last()">
													<br/>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="n1:intendedRecipient">
												<xsl:for-each select="n1:id">
													<xsl:call-template name="show-id"/>
												</xsl:for-each>
												<xsl:if test="position() != last()">
													<br/>
												</xsl:if>
												<br/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<xsl:if test="n1:intendedRecipient/n1:addr | n1:intendedRecipient/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact" select="n1:intendedRecipient"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- participant -->
	<xsl:template name="participant">
		<tr valign="top">
			<th>
				<xsl:variable name="participtRole">
					<xsl:call-template name="translateRoleAssoCode">
						<xsl:with-param name="classCode" select="n1:associatedEntity/@classCode"/>
						<xsl:with-param name="code" select="n1:associatedEntity/n1:code"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$participtRole">
						<xsl:call-template name="firstCharCaseUp">
							<xsl:with-param name="data" select="$participtRole"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						Participant
					</xsl:otherwise>
				</xsl:choose>
			</th>
			<td>
				<xsl:if test="n1:functionCode">
					<xsl:call-template name="show-code">
						<xsl:with-param name="code" select="n1:functionCode"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:call-template name="show-associatedEntity">
					<xsl:with-param name="assoEntity" select="n1:associatedEntity"/>
				</xsl:call-template>
				<xsl:if test="n1:associatedEntity/n1:addr | n1:associatedEntity/n1:telecom">
					<xsl:call-template name="show-contactInfo">
						<xsl:with-param name="contact" select="n1:associatedEntity"/>
					</xsl:call-template>
				</xsl:if>
				<!-- <xsl:if test="n1:time"> <xsl:if test="n1:time/n1:low"> <xsl:text> 
					from </xsl:text> <xsl:call-template name="show-time"> <xsl:with-param name="datetime" 
					select="n1:time/n1:low"/> </xsl:call-template> </xsl:if> <xsl:if test="n1:time/n1:high"> 
					<xsl:text> to </xsl:text> <xsl:call-template name="show-time"> <xsl:with-param 
					name="datetime" select="n1:time/n1:high"/> </xsl:call-template> </xsl:if> 
					</xsl:if> -->
			</td>
		</tr>
	</xsl:template>

	<!-- recordTarget -->
	<xsl:template name="recordTarget">
		<fieldset>
			<legend>
				<b>Demographic Information</b>
			</legend>
			<table>
				<tbody>
					<xsl:for-each select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole">
						<xsl:if test="not(n1:id/@nullFlavor)">
							<tr>
								<td>
									<label>
										<b>Patient: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-name">
										<xsl:with-param name="name" select="n1:patient/n1:name"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td>
									<label>
										<b>Date of birth: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-time">
										<xsl:with-param name="datetime" select="n1:patient/n1:birthTime"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td>
									<label>
										<b>Gender: </b>
									</label>
								</td>
								<td>
									<xsl:for-each select="n1:patient/n1:administrativeGenderCode">
										<xsl:call-template name="show-gender"/>
									</xsl:for-each>
								</td>
							</tr>
							<xsl:if test="n1:patient/n1:raceCode | (n1:patient/n1:ethnicGroupCode)">
								<tr>
									<td>
										<label>
											<b>Race: </b>
										</label>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="n1:patient/n1:raceCode">
												<xsl:for-each select="n1:patient/n1:raceCode">
													<xsl:call-template name="show-race-ethnicity"/>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Information not available</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:if>
							<tr>
								<td>
									<label>
										<b>Ethnicity: </b>
									</label>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="n1:patient/n1:ethnicGroupCode">
											<xsl:for-each select="n1:patient/n1:ethnicGroupCode">
												<xsl:call-template name="show-race-ethnicity"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Information not available</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td style="vertical-align: top;">
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact" select="."/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td>
									<label>
										<b>Patient IDs: </b>
									</label>
								</td>
								<td>
									<xsl:for-each select="n1:id">
										<xsl:call-template name="show-id"/>
										<br/>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</tbody>
			</table>
		</fieldset>
	</xsl:template>

	<!-- relatedDocument -->
	<xsl:template name="relatedDocument">
		<xsl:if test="n1:relatedDocument">
			<table class="header_table">
				<tbody>
					<xsl:for-each select="n1:relatedDocument">
						<tr>
							<td width="20%" bgcolor="#3399ff">
								<span class="td_label">
									<xsl:text>Related document</xsl:text>
								</span>
							</td>
							<td width="80%">
								<xsl:for-each select="n1:parentDocument">
									<xsl:for-each select="n1:id">
										<xsl:call-template name="show-id"/>
										<br/>
									</xsl:for-each>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- authorization (consent) -->
	<xsl:template name="authorization">
		<xsl:if test="n1:authorization">
			<table class="header_table">
				<tbody>
					<xsl:for-each select="n1:authorization">
						<tr>
							<td width="20%" bgcolor="#3399ff">
								<span class="td_label">
									<xsl:text>Consent</xsl:text>
								</span>
							</td>
							<td width="80%">
								<xsl:choose>
									<xsl:when test="n1:consent/n1:code">
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="n1:consent/n1:code"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="n1:consent/n1:statusCode"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
								<br/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- setAndVersion -->
	<xsl:template name="setAndVersion">
		<xsl:if test="n1:setId and n1:versionNumber">
			<table class="header_table">
				<tbody>
					<tr>
						<td width="20%">
							<xsl:text>SetId and Version</xsl:text>
						</td>
						<td colspan="3">
							<xsl:text>SetId: </xsl:text>
							<xsl:call-template name="show-id">
								<xsl:with-param name="id" select="n1:setId"/>
							</xsl:call-template>
							<xsl:text>  Version: </xsl:text>
							<xsl:value-of select="n1:versionNumber/@value"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- show StructuredBody -->
	<xsl:template match="n1:component/n1:structuredBody">
		<xsl:for-each select=".">
			<xsl:call-template name="section-dynamic"/>
		</xsl:for-each>
	</xsl:template>
	<!-- show nonXMLBody -->
	<xsl:template match="n1:component/n1:nonXMLBody">
		<xsl:choose>
			<!-- if there is a reference, use that in an IFRAME -->
			<xsl:when test="n1:text/n1:reference">
				<IFRAME name="nonXMLBody" id="nonXMLBody" WIDTH="80%" HEIGHT="600" src="{n1:text/n1:reference/@value}"/>
			</xsl:when>
			<xsl:when test="n1:text/@mediaType=&quot;text/plain&quot;">
				<pre>
					<xsl:value-of select="n1:text/text()"/>
				</pre>
			</xsl:when>
			<xsl:otherwise>
				<CENTER>Cannot display the text</CENTER>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
        
        <!-- Used to make the ToC compatible with older ccda/ses documents that have deprecated layouts --> 
        <xsl:template name="getSESTocSectionPosition">
            <xsl:param name="position"/>
            <xsl:param name="loincCode"/>
            <!-- 0,1,3, and 16 are left blank for the predefined line breaks, patient info, and healthcare -->
            <xsl:choose>
                <xsl:when test="$loincCode='48768-6'"><xsl:copy-of select="string('2')"/></xsl:when>
                <xsl:when test="$loincCode='46240-8'"><xsl:copy-of select="string('3')"/></xsl:when>
                <xsl:when test="$loincCode='51848-0'"><xsl:copy-of select="string('4')"/></xsl:when>
                <xsl:when test="$loincCode='18776-5'"><xsl:copy-of select="string('5')"/></xsl:when>
                <xsl:when test="$loincCode='47519-4'"><xsl:copy-of select="string('6')"/></xsl:when>
                <xsl:when test="$loincCode='30954-2'"><xsl:copy-of select="string('7')"/></xsl:when>
                <xsl:when test="$loincCode='8716-3'"><xsl:copy-of select="string('8')"/></xsl:when>
                <xsl:when test="$loincCode='11369-6'"><xsl:copy-of select="string('9')"/></xsl:when>
                <xsl:when test="$loincCode='29762-2'"><xsl:copy-of select="string('10')"/></xsl:when>
                <xsl:when test="$loincCode='42348-3'"><xsl:copy-of select="string('11')"/></xsl:when>
                <xsl:when test="$loincCode='48765-2'"><xsl:copy-of select="string('12')"/></xsl:when>  
                <xsl:when test="$loincCode='10160-0'"><xsl:copy-of select="string('13')"/></xsl:when>                              
                <xsl:when test="$loincCode='11450-4'"><xsl:copy-of select="string('14')"/></xsl:when>
                <xsl:when test="$loincCode='18726-0'"><xsl:copy-of select="string('16')"/></xsl:when>
                <xsl:when test="$loincCode='27898-6'"><xsl:copy-of select="string('17')"/></xsl:when>
                <xsl:when test="$loincCode='11506-3'"><xsl:copy-of select="string('18')"/></xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$position+20"/>
                </xsl:otherwise>                                       
            </xsl:choose>
        </xsl:template>
        
        <xsl:template name="getCCDATocSectionPosition">
            <xsl:param name="position"/>
            <xsl:param name="loincCode"/>
            <!-- 0,1,3, and 16 are left blank for the predefined line breaks, patient info, and healthcare -->
            <xsl:choose>
                <xsl:when test="$loincCode='48768-6'"><xsl:copy-of select="string('2')"/></xsl:when>
                <xsl:when test="$loincCode='42348-3'"><xsl:copy-of select="string('4')"/></xsl:when>
                <xsl:when test="$loincCode='48765-2'"><xsl:copy-of select="string('5')"/></xsl:when>
                <xsl:when test="$loincCode='46240-8'"><xsl:copy-of select="string('6')"/></xsl:when>
                <xsl:when test="$loincCode='47420-5'"><xsl:copy-of select="string('7')"/></xsl:when>
                <xsl:when test="$loincCode='10160-0'"><xsl:copy-of select="string('8')"/></xsl:when>
                <xsl:when test="$loincCode='11369-6'"><xsl:copy-of select="string('9')"/></xsl:when>
                <xsl:when test="$loincCode='47519-4'"><xsl:copy-of select="string('10')"/></xsl:when>
                <xsl:when test="$loincCode='18776-5'"><xsl:copy-of select="string('11')"/></xsl:when>
                <xsl:when test="$loincCode='11450-4'"><xsl:copy-of select="string('12')"/></xsl:when>
                <xsl:when test="$loincCode='30954-2'"><xsl:copy-of select="string('13')"/></xsl:when>  
                <xsl:when test="$loincCode='29762-2'"><xsl:copy-of select="string('14')"/></xsl:when>                              
                <xsl:when test="$loincCode='8716-3'"><xsl:copy-of select="string('15')"/></xsl:when>
                <xsl:when test="$loincCode='11488-4'"><xsl:copy-of select="string('17')"/></xsl:when>
                <xsl:when test="$loincCode='34117-2'"><xsl:copy-of select="string('18')"/></xsl:when>
                <xsl:when test="$loincCode='18842-5'"><xsl:copy-of select="string('19')"/></xsl:when>
                <xsl:when test="$loincCode='18726-0'"><xsl:copy-of select="string('20')"/></xsl:when>
                <xsl:when test="$loincCode='27898-6'"><xsl:copy-of select="string('21')"/></xsl:when>
                <xsl:when test="$loincCode='28570-0'"><xsl:copy-of select="string('22')"/></xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$position+30"/>
                </xsl:otherwise>                                       
            </xsl:choose>
        </xsl:template>
        
        
	<!-- Templates to act as lookup tables or maps for determining section headers and headings
		based upon LOINC codes             -->
	<xsl:template name="getSectionHeaderText">
		<xsl:param name="loincCode"/>
                <xsl:param name="templateId"/>
                <xsl:param name="notesIdNum"/>
                            <xsl:choose>
        <!-- Default Text for Individual TOC buttons -->
				<xsl:when test="$loincCode='42348-3'"><xsl:copy-of select="string('Advance Directives')"/></xsl:when>
				<xsl:when test="$loincCode='48765-2'"><xsl:copy-of select="string('Allergies')"/></xsl:when>
				<xsl:when test="$loincCode='59774-0'"><xsl:copy-of select="string('Anesthesia')"/></xsl:when>
				<xsl:when test="$loincCode='51848-0'"><xsl:copy-of select="string('Assessment')"/></xsl:when>
				<xsl:when test="$loincCode='51847-2'"><xsl:copy-of select="string('Assessment and Plan')"/></xsl:when>
				<xsl:when test="$loincCode='10154-3'"><xsl:copy-of select="string('Chief Complaint')"/></xsl:when>
				<xsl:when test="$loincCode='46239-0'"><xsl:copy-of select="string('Chief Complaint and Reason for Visit')"/></xsl:when>
				<xsl:when test="$loincCode='55109-3'"><xsl:copy-of select="string('Complications')"/></xsl:when>
				<xsl:when test="$loincCode='121181'"><xsl:copy-of select="string('DICOM Object Catalog')"/></xsl:when>
				<xsl:when test="$loincCode='42344-2'"><xsl:copy-of select="string('Discharge Diet')"/></xsl:when>
				<xsl:when test="$loincCode='46240-8'"><xsl:copy-of select="string('Encounters')"/></xsl:when>
				<xsl:when test="$loincCode='10157-6'"><xsl:copy-of select="string('Family History')"/></xsl:when>
				<xsl:when test="$loincCode='18782-3'"><xsl:copy-of select="string('Findings (Radiology Study - Observation)')"/></xsl:when>
				<xsl:when test="$loincCode='47420-5'"><xsl:copy-of select="string('Functional Status')"/></xsl:when>
				<xsl:when test="$loincCode='10210-3'"><xsl:copy-of select="string('General Status')"/></xsl:when>
				<xsl:when test="$loincCode='11348-0'"><xsl:copy-of select="string('History of Past Illness (Past Medical History)')"/></xsl:when>
				<xsl:when test="$loincCode='10164-2'"><xsl:copy-of select="string('History of Present Illness')"/></xsl:when>
				<xsl:when test="$loincCode='46241-6'"><xsl:copy-of select="string('Hospital Admission Diagnosis')"/></xsl:when>
				<xsl:when test="$loincCode='18841-7'"><xsl:copy-of select="string('Hospital Consultation')"/></xsl:when>
				<xsl:when test="$loincCode='8648-8'"><xsl:copy-of select="string('Discharge Summary')"/></xsl:when>
				<xsl:when test="$loincCode='11535-2'"><xsl:copy-of select="string('Hospital Discharge Diagnosis')"/></xsl:when>
				<xsl:when test="$loincCode='8653-8'"><xsl:copy-of select="string('Hospital Discharge Instructions')"/></xsl:when>
				<xsl:when test="$loincCode='10183-2'"><xsl:copy-of select="string('Hospital Discharge Medications')"/></xsl:when>
				<xsl:when test="$loincCode='10184-0'"><xsl:copy-of select="string('Hospital Discharge Physical')"/></xsl:when>
				<xsl:when test="$loincCode='11493-4'"><xsl:copy-of select="string('Hospital Discharge Studies Summary')"/></xsl:when>
				<xsl:when test="$loincCode='11369-6'"><xsl:copy-of select="string('Immunizations')"/></xsl:when>
				<xsl:when test="$loincCode='69730-0'"><xsl:copy-of select="string('Instructions')"/></xsl:when>
				<xsl:when test="$loincCode='62387-6'"><xsl:copy-of select="string('Interventions')"/></xsl:when>
				<xsl:when test="$loincCode='46264-8'"><xsl:copy-of select="string('Medical Equipment')"/></xsl:when>
				<xsl:when test="$loincCode='11329-0'"><xsl:copy-of select="string('Medical (General) History')"/></xsl:when>
				<xsl:when test="$loincCode='10160-0'"><xsl:copy-of select="string('Medications')"/></xsl:when>
				<xsl:when test="$loincCode='29549-3'"><xsl:copy-of select="string('Medications Administered')"/></xsl:when>
				<xsl:when test="$loincCode='61149-1'"><xsl:copy-of select="string('Objective')"/></xsl:when>
				<xsl:when test="$loincCode='10216-0'"><xsl:copy-of select="string('Operative Note Fluids')"/></xsl:when>
				<xsl:when test="$loincCode='10223-6'"><xsl:copy-of select="string('Operative Note Surgical Procedure')"/></xsl:when>
				<xsl:when test="$loincCode='48768-6'"><xsl:copy-of select="string('Insurance Providers')"/></xsl:when>
				<xsl:when test="$loincCode='29545-1'"><xsl:copy-of select="string('Physical Exam')"/></xsl:when>
				<xsl:when test="$loincCode='18776-5'">
					<xsl:choose>
						<xsl:when test="$hasExtension"><xsl:copy-of select="string('Plan of Care/Treatment')"/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="string('Plan of Care')"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$loincCode='59772-4'"><xsl:copy-of select="string('Planned Procedure')"/></xsl:when>
				<xsl:when test="$loincCode='10218-6'"><xsl:copy-of select="string('Post-operative Diagnosis')"/></xsl:when>
				<xsl:when test="$loincCode='59769-0'"><xsl:copy-of select="string('Post-procedure Diagnosis')"/></xsl:when>
				<xsl:when test="$loincCode='10219-4'"><xsl:copy-of select="string('Preoperative Diagnosis')"/></xsl:when>
				<xsl:when test="$loincCode='11450-4'"><xsl:copy-of select="string('Problems')"/></xsl:when>
				<xsl:when test="$loincCode='29554-3'"><xsl:copy-of select="string('Procedure Description')"/></xsl:when>
				<xsl:when test="$loincCode='59775-7'"><xsl:copy-of select="string('Procedure Disposition')"/></xsl:when>
				<xsl:when test="$loincCode='59770-8'"><xsl:copy-of select="string('Procedure Estimated Blood Loss')"/></xsl:when>
				<xsl:when test="$loincCode='59776-5'"><xsl:copy-of select="string('Procedure Findings')"/></xsl:when>
				<xsl:when test="$loincCode='59771-6'"><xsl:copy-of select="string('Procedure Implants')"/></xsl:when>
				<xsl:when test="$loincCode='59768-2'"><xsl:copy-of select="string('Procedure Indications')"/></xsl:when>
				<xsl:when test="$loincCode='59773-2'"><xsl:copy-of select="string('Procedure Specimens Taken')"/></xsl:when>
				<xsl:when test="$loincCode='47519-4'"><xsl:copy-of select="string('Procedures')"/></xsl:when>
				<xsl:when test="$loincCode='42349-1'"><xsl:copy-of select="string('Reason for Referral')"/></xsl:when>
				<xsl:when test="$loincCode='29299-5'"><xsl:copy-of select="string('Reason for Visit')"/></xsl:when>
				<xsl:when test="$loincCode='55115-0'"><xsl:copy-of select="string('Requested Imaging Studies Information')"/></xsl:when>
				<xsl:when test="$loincCode='30954-2'"><xsl:copy-of select="string('Results')"/></xsl:when>
				<xsl:when test="$loincCode='10187-3'"><xsl:copy-of select="string('Review of Systems')"/></xsl:when>
				<xsl:when test="$loincCode='29762-2'"><xsl:copy-of select="string('Social History')"/></xsl:when>
				<xsl:when test="$loincCode='61150-9'"><xsl:copy-of select="string('Subjective')"/></xsl:when>
				<xsl:when test="$loincCode='11537-8'"><xsl:copy-of select="string('Surgical Drains')"/></xsl:when>
				<xsl:when test="$loincCode='8716-3'"><xsl:copy-of select="string('Vital Signs')"/></xsl:when>
				<xsl:when test="$loincCode='34133-9'"><xsl:copy-of select="string('Summarization of Episode Note')"/></xsl:when>
                                <xsl:when test="$loincCode='11488-4'"><xsl:copy-of select="string('Consultation Notes')"/></xsl:when>
				<xsl:when test="$loincCode='18748-4'"><xsl:copy-of select="string('Diagnostic Imaging Report')"/></xsl:when>
                                <xsl:when test="$loincCode='34117-2'"><xsl:copy-of select="string('History and Physical')"/></xsl:when>
				<xsl:when test="$loincCode='11504-8'"><xsl:copy-of select="string('Surgical Operation Notes')"/></xsl:when>
                                <xsl:when test="$loincCode='28570-0'"><xsl:copy-of select="string('Procedure Notes')"/></xsl:when>
				<xsl:when test="$loincCode='34746-8'"><xsl:copy-of select="string('Nurses Note')"/></xsl:when>
				<xsl:when test="$loincCode='11506-3'"><xsl:copy-of select="string('Progress Notes')"/></xsl:when>
                                <xsl:when test="$loincCode='18726-0'"><xsl:copy-of select="string('Radiology Studies')"/></xsl:when>
                                <xsl:when test="$loincCode='27898-6'"><xsl:copy-of select="string('Pathology Studies')"/></xsl:when>
                                <xsl:when test="$loincCode='18842-5'"><xsl:copy-of select="string('Discharge Summaries')"/></xsl:when>
				<xsl:when test="$loincCode='34109-9'"><xsl:copy-of select="string('Miscellaneous Notes')"/></xsl:when>
                                <xsl:otherwise> 
                                    <xsl:if test="$notesIdNum=$templateId"/>
                                        <xsl:choose>
                                            <xsl:when test="string-length(n1:section/n1:title) &lt; 20">
                                                <xsl:value-of select="n1:section/n1:title"/> 
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="n1:section/n1:code/@displayName"/> 
                                            </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:otherwise>
			</xsl:choose>
	</xsl:template>
        
   
	<!-- DYNAMIC VERSION top level component/section: display title and text, and process any 
		nested component/sections -->
	<xsl:template name="section-dynamic">
		<xsl:variable name="sections" select="n1:component/n1:section"/>

		<xsl:choose>
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<xsl:for-each select="$sections">
					<xsl:variable name="pos-int"><xsl:value-of select="position()"/></xsl:variable>
					<xsl:variable name="templateId">
						<xsl:choose>
							<xsl:when test="n1:templateId[2]">
								<xsl:value-of select="n1:templateId[2]/@root"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="n1:templateId/@root"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="currentSection" select="n1:text"/>
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
                                        <!-- CCM-257 Make headers dynamic based on included <title> parameter. -->
                                                 <xsl:value-of select="n1:title"/>			
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
                                            <xsl:call-template name="getSectionHeaderText">
                                                    <xsl:with-param name="loincCode" select="$loincCode"/>
                                            </xsl:call-template> 	
                                            <xsl:value-of select="string('')"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="string-length($currentSection) > 0">
							<!--<xsl:call-template name="section-title"> <xsl:with-param name="title" 
								select="$headerValue"/> <xsl:with-param name="titleId" select="$headerHrefTitleId"/> 
								<xsl:with-param name="sectionCount" select="$sectionsCount"/> </xsl:call-template> 
								<xsl:call-template name="section-author"> <xsl:with-param name="templateId" 
								select="$templateId"/> </xsl:call-template> -->
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue"/>
										<!--<span class="count"><xsl:value-of select="$pos-int"/></span> -->
									</h2>

									No data provided for this section.
								</header>
							</section>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="contains($progDocTemplateRoot, $progressDoc)">
				<xsl:for-each select="$sections">
					<xsl:variable name="pos-int"><xsl:value-of select="position()"/></xsl:variable>
					<xsl:variable name="templateId">
						<xsl:choose>
							<xsl:when test="n1:templateId[2]">
								<xsl:value-of select="n1:templateId[2]/@root"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="n1:templateId/@root"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="currentSection" select="n1:text"/>
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template> 							
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="string('')"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="string-length($currentSection) > 0">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue"/>
										<!--<span class="count"><xsl:value-of select="$pos-int"/></span> -->
									</h2>

									No data provided for this section.
								</header>
							</section>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- top level component/section: display title and text, and process any 
		nested component/sections -->
	<xsl:template name="section">
		<xsl:variable name="compTemplateIdRoots" select="n1:component/n1:section/n1:templateId/@root"/>
		<xsl:variable name="sectionsCount" select="count(n1:component/n1:section)"/>
		<xsl:variable name="sections" select="n1:component/n1:section"/>

		<xsl:choose>
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<xsl:for-each select="$sections">
					<xsl:variable name="pos-int"><xsl:value-of select="position()"/></xsl:variable>
					<xsl:variable name="templateId">
						<xsl:choose>
							<xsl:when test="n1:templateId[2]">
								<xsl:value-of select="n1:templateId[2]/@root"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="n1:templateId/@root"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="currentSection" select="n1:text"/>
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template> 							
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$ccdSectionHeaderRefParam[$pos-int]"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<!--<xsl:call-template name="section-title"> <xsl:with-param name="title" 
								select="$headerValue"/> <xsl:with-param name="titleId" select="$headerHrefTitleId"/> 
								<xsl:with-param name="sectionCount" select="$sectionsCount"/> </xsl:call-template> 
								<xsl:call-template name="section-author"> <xsl:with-param name="templateId" 
								select="$templateId"/> </xsl:call-template> -->
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue"/>
										<!--<span class="count"><xsl:value-of select="$pos-int"/></span> -->
									</h2>

									No data provided for this section.
								</header>
							</section>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="$ccdAdditionalTemplateIdArrayParam">
					<xsl:variable name="templateId">
						<xsl:value-of select="."/>
					</xsl:variable>
					<xsl:variable name="pos-int" select="position()"/>
					<xsl:variable name="currentSection" select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text"/>
					<xsl:variable name="headerValue">
						<xsl:value-of select="$ccdAdditionalSectionHeaderParam[$pos-int]"/>
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$ccdAdditionalSectionHeaderHrefParam[$pos-int]"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>
						<!-- <xsl:otherwise> <section id="{$headerValue}"> <header> <h2> <xsl:value-of 
							select="$headerValue"/> </h2> No data available within defined date range 
							for this section. </header> </section> </xsl:otherwise> -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="contains($progDocTemplateRoot, $progressDoc)">
				<xsl:for-each select="$sections">
					<xsl:variable name="pos-int"><xsl:value-of select="position()"/></xsl:variable>
					<xsl:variable name="templateId">
						<xsl:choose>
							<xsl:when test="n1:templateId[2]">
								<xsl:value-of select="n1:templateId[2]/@root"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="n1:templateId/@root"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="currentSection" select="n1:text"/>
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template> 							
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$progSectionHeaderHrefParam[$pos-int]"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue"/>
										<!--<span class="count"><xsl:value-of select="$pos-int"/></span> -->
									</h2>

									No data provided for this section.
								</header>
							</section>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="$progressAdditionalTemplateIdArrayParam">
					<xsl:variable name="templateId">
						<xsl:value-of select="."/>
					</xsl:variable>
					<xsl:variable name="pos-int" select="position()"/>
					<xsl:variable name="currentSection" select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text"/>
					<xsl:variable name="headerValue">
						<xsl:value-of select="$progressAdditionalSectionHeaderParam[$pos-int]"/>
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$progressAdditionalSectionHeaderHrefParam[$pos-int]"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue"/>
								<xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="htmlText" select="$currentSection"/>
								<xsl:with-param name="sectionPosition" select="$pos-int"/>
							</xsl:call-template>
						</xsl:when>

					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- top level section title -->
	<xsl:template name="section-title">
		<xsl:param name="title"/>
		<xsl:param name="titleId"/>
		<xsl:param name="sectionCount"/>

		<xsl:choose>
			<xsl:when test="$sectionCount > 1">
				<h3>
					<a name="{$titleId}" href="#toc">
						<xsl:value-of select="$title"/>
					</a>
				</h3>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:value-of select="$title"/>
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- section author -->
	<xsl:template name="section-author">
		<xsl:param name="templateId"/>

		<xsl:if test="count(n1:component/n1:section/n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]/*/n1:author)>0">
			<div style="margin-left : 2em;">
				<b>
					<xsl:text>Section Author: </xsl:text>
				</b>
				<xsl:for-each select="n1:component/n1:section/n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]/n1:author/n1:assignedAuthor">
					<xsl:choose>
						<xsl:when test="n1:assignedPerson/n1:name">
							<xsl:call-template name="show-name">
								<xsl:with-param name="name" select="n1:assignedPerson/n1:name"/>
							</xsl:call-template>
							<xsl:if test="n1:representedOrganization">
								<xsl:text>, </xsl:text>
								<xsl:call-template name="show-name">
									<xsl:with-param name="name" select="n1:representedOrganization/n1:name"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:when test="n1:assignedAuthoringDevice/n1:softwareName">
							<xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="n1:id">
								<xsl:call-template name="show-id"/>
								<br/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<br/>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- top-level section Text -->
	<xsl:template name="section-text">
		<xsl:param name="htmlText"/>
		<xsl:param name="title"/>
		<xsl:param name="titleId"/>
		<xsl:param name="sectionPosition"/>

		<xsl:variable name="alpha" select="$htmlText"/>

		<section id="{$titleId}">
			<header>
				<h2>
					<label id="plus.{$titleId}" onclick="javascript:toggle('open','{$titleId}')">[+]  </label>
					<label id="minus.{$titleId}" onclick="javascript:toggle('close','{$titleId}')">[-]  </label>
					
					<xsl:value-of select="$title"/>
					<!--<span class="count"><xsl:value-of select="$sectionPosition"/></span> -->
				</h2>

				<xsl:choose>
					<xsl:when test="$htmlText[contains(., 'No Information')]">
						<xsl:text>No data provided for this section.</xsl:text>
					</xsl:when>
					<xsl:when test="count($htmlText/n1:table) > 1">
						<!--<p> <strong> Business Rules for Construction of Medical Information: 
							</strong> <xsl:value-of select="$htmlText/n1:table[position() = 1]/n1:tbody/n1:tr/n1:td[position() 
							= 2]"/> </p> -->
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
				
			</header>
			<div id="section.{$titleId}">
			<xsl:choose>
				<xsl:when test="$htmlText[contains(., 'No Information')]">
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$htmlText"/>
				</xsl:otherwise>
			</xsl:choose>
			</div>
		</section>
	</xsl:template>

	<!-- paragraph -->
	<xsl:template match="n1:paragraph">
		<p>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!-- pre format -->
	<xsl:template match="n1:pre">
		<pre>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>
	<!-- Content w/ deleted text is hidden -->
	<xsl:template match="n1:content[@revised='delete']"/>
	<!-- content -->
	<xsl:template match="n1:content">
		<span>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<!-- line break -->
        <!-- JMC this may be useful for CCM-296-->
	<xsl:template match="n1:br">
		<xsl:element name="br">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- underlining -->
	<xsl:template match="n1:u">
		<u>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<!-- list -->
	<xsl:template match="n1:list">
		<xsl:if test="n1:caption">
			<p>
				<xsl:copy-of select="@*"/>
				<b>
					<xsl:apply-templates select="n1:caption"/>
				</b>
			</p>
		</xsl:if>
		<ul>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="n1:item">
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="n1:list[@listType='ordered']">
		<xsl:if test="n1:caption">
			<span style="font-weight:bold; ">
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates select="n1:caption"/>
			</span>
		</xsl:if>
		<ol>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="n1:item">
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ol>
	</xsl:template>
	<!-- caption -->
	<xsl:template match="n1:caption">
		<xsl:apply-templates/>
		<xsl:text>: </xsl:text>
	</xsl:template>
	<!-- Tables -->
	<xsl:template match="n1:table/@*|n1:thead/@*|n1:tfoot/@*|n1:tbody/@*|n1:colgroup/@*|n1:col/@*|n1:tr/@*|n1:th/@*|n1:td/@*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="n1:table">
		<table class="narr_table">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="n1:thead">
		<thead>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</thead>
	</xsl:template>
	<xsl:template match="n1:tfoot">
		<tfoot>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</tfoot>
	</xsl:template>
	<xsl:template match="n1:tbody">
		<tbody>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</tbody>
	</xsl:template>
	<xsl:template match="n1:colgroup">
		<colgroup>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</colgroup>
	</xsl:template>
	<xsl:template match="n1:col">
		<col>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</col>
	</xsl:template>
	<xsl:template match="n1:tr">
		<tr class="narr_tr">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	<xsl:template match="n1:th">
		<th class="narr_th">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	<xsl:template match="n1:td">
		<td>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	<xsl:template match="n1:table/n1:caption">
		<span style="font-weight:bold; ">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<!-- RenderMultiMedia this currently only handles GIF's and JPEG's. It could, 
		however, be extended by including other image MIME types in the predicate 
		and/or by generating <object> or <applet> tag with the correct params depending 
		on the media type @ID =$imageRef referencedObject -->
	<xsl:template match="n1:renderMultiMedia">
		<xsl:variable name="imageRef" select="@referencedObject"/>
		<xsl:choose>
			<xsl:when test="//n1:regionOfInterest[@ID=$imageRef]">
				<!-- Here is where the Region of Interest image referencing goes -->
				<xsl:if test="//n1:regionOfInterest[@ID=$imageRef]//n1:observationMedia/n1:value[@mediaType='image/gif' or @mediaType='image/jpeg']">
					<br clear="all"/>
					<xsl:element name="img">
						<xsl:attribute name="src"><xsl:value-of select="//n1:regionOfInterest[@ID=$imageRef]//n1:observationMedia/n1:value/n1:reference/@value"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Here is where the direct MultiMedia image referencing goes -->
				<xsl:if test="//n1:observationMedia[@ID=$imageRef]/n1:value[@mediaType='image/gif' or @mediaType='image/jpeg']">
					<br clear="all"/>
					<xsl:element name="img">
						<xsl:attribute name="src"><xsl:value-of select="//n1:observationMedia[@ID=$imageRef]/n1:value/n1:reference/@value"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- <xsl:template match="@styleCode">
		<xsl:attribute name="class"><xsl:value-of select="." /></xsl:attribute>
	</xsl:template> -->
	<!-- Stylecode processing Supports Bold, Underline and Italics display CCM-174 -->
	<!--
	<xsl:template match="//n1:*[@styleCode='Bold' or @styleCode='Italics' or @styleCode='Underline']"> 
		<xsl:choose>
			<xsl:when test="@styleCode='Bold'"> 
                            <xsl:copy use-attribute-sets="bold-style">
                                <xsl:apply-templates select="@*[name() != 'styleCode']|node()"/>
                            </xsl:copy>
			</xsl:when> 
			<xsl:when test="@styleCode='Italics'">
                            <xsl:copy use-attribute-sets="italic-style">
                                <xsl:apply-templates select="@*[name() != 'styleCode']|node()"/>
                            </xsl:copy>
			</xsl:when> 
			<xsl:when test="@styleCode='Underline'"> 
                            <xsl:copy use-attribute-sets="underline-style">
                                <xsl:apply-templates select="@*[name() != 'styleCode']|node()"/>
                            </xsl:copy>
			</xsl:when> 
			<xsl:otherwise>
                            <xsl:copy>
                                <xsl:apply-templates select="@*[name() != 'styleCode']|node()"/>
                            </xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	--><!--
	<xsl:attribute-set name="bold-style">
		<xsl:attribute name="style">font-weight: bold;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="italic-style">
		<xsl:attribute name="style">font-style: italic;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="underline-style">
		<xsl:attribute name="style">text-decoration: underline;</xsl:attribute>
	</xsl:attribute-set>
	-->
	<!-- Superscript or Subscript -->
	<xsl:template match="n1:sup">
		<xsl:element name="sup">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="n1:sub">
		<xsl:element name="sub">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!-- show-signature -->
	<xsl:template name="show-sig">
		<xsl:param name="sig"/>
		<xsl:choose>
			<xsl:when test="$sig/@code ='S'">
				<xsl:text>signed</xsl:text>
			</xsl:when>
			<xsl:when test="$sig/@code='I'">
				<xsl:text>intended</xsl:text>
			</xsl:when>
			<xsl:when test="$sig/@code='X'">
				<xsl:text>signature required</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show-id -->
	<xsl:template name="show-id">
		<xsl:param name="id"/>
		<xsl:choose>
			<xsl:when test="not($id)">
				<xsl:if test="not(@nullFlavor)">
					<xsl:if test="@extension">
						<xsl:value-of select="@extension"/>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@root"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($id/@nullFlavor)">
					<xsl:if test="$id/@extension">
						<xsl:value-of select="$id/@extension"/>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$id/@root"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-name -->
	<xsl:template name="show-name">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$name/n1:family">
				<xsl:if test="$name/n1:prefix">
					<xsl:value-of select="$name/n1:prefix"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$name/n1:given"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:family"/>
				<xsl:if test="$name/n1:suffix">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$name/n1:suffix"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-gender -->
	<xsl:template name="show-gender">
		<xsl:choose>
			<xsl:when test="@code   = 'M'">
				<xsl:text>Male</xsl:text>
			</xsl:when>
			<xsl:when test="@code  = 'F'">
				<xsl:text>Female</xsl:text>
			</xsl:when>
			<xsl:when test="@code  = 'U'">
				<xsl:text>Undifferentiated</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show-race -->
	<xsl:template name="show-race">
		<xsl:param name="raceCodeDisplay"/>
		<xsl:param name="sdtc-raceCodeDisplay"/>
		<xsl:param name="raceCodeText"/>
		<xsl:param name="sdtc-raceCodeText"/>
		<xsl:choose>
			<xsl:when test="$raceCodeDisplay and $sdtc-raceCodeDisplay">
				<xsl:value-of select="concat($raceCodeDisplay,', ',$sdtc-raceCodeDisplay)"/>
			</xsl:when>
			<xsl:when test="$raceCodeText and $sdtc-raceCodeDisplay">
				<xsl:value-of select="concat($raceCodeText,', ',$sdtc-raceCodeDisplay)"/>
			</xsl:when>
			<xsl:when test="$raceCodeDisplay and $sdtc-raceCodeText">
				<xsl:value-of select="concat($raceCodeDisplay,', ',$sdtc-raceCodeText)"/>
			</xsl:when>
			<xsl:when test="$raceCodeText and $sdtc-raceCodeText">
				<xsl:value-of select="concat($raceCodeText,', ',$sdtc-raceCodeText)"/>
			</xsl:when>
			<xsl:when test="$raceCodeDisplay">
				<xsl:value-of select="$raceCodeDisplay"/>
			</xsl:when>
			<xsl:when test="$raceCodeText">
				<xsl:value-of select="$raceCodeText"/>
			</xsl:when>
			<xsl:when test="$sdtc-raceCodeDisplay">
				<xsl:value-of select="$sdtc-raceCodeDisplay"/>
			</xsl:when>
			<xsl:when test="sdtc-raceCodeText">
				<xsl:value-of select="sdtc-raceCodeText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-race-ethnicity -->
	<xsl:template name="show-race-ethnicity">
		<xsl:choose>
			<xsl:when test="@displayName">
				<xsl:value-of select="@displayName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-contactInfo -->
	<xsl:template name="show-contactInfo">
		<xsl:param name="contact"/>
		<xsl:call-template name="show-address">
			<xsl:with-param name="address" select="$contact/n1:addr"/>
		</xsl:call-template>
		<xsl:call-template name="show-telecom">
			<xsl:with-param name="telecom" select="$contact/n1:telecom"/>
		</xsl:call-template>
	</xsl:template>
	<!-- show-address -->
	<xsl:template name="show-address">
		<xsl:param name="address"/>
		<xsl:choose>
			<xsl:when test="$address">
				<xsl:if test="$address/@use">
					<xsl:text> </xsl:text>
					<xsl:call-template name="translateTelecomCode">
						<xsl:with-param name="code" select="$address/@use"/>
					</xsl:call-template>
					<xsl:text>:</xsl:text>
					<br/>
				</xsl:if>
				<xsl:for-each select="$address/n1:streetAddressLine">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each>
				<xsl:if test="$address/n1:streetName">
					<xsl:value-of select="$address/n1:streetName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$address/n1:houseNumber"/>
					<br/>
				</xsl:if>
				<xsl:if test="string-length($address/n1:city)>0">
					<xsl:value-of select="$address/n1:city"/>
				</xsl:if>
				<xsl:if test="string-length($address/n1:state)>0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$address/n1:state"/>
				</xsl:if>
				<xsl:if test="string-length($address/n1:postalCode)>0">
					<xsl:text> </xsl:text>
					<xsl:value-of select="$address/n1:postalCode"/>
				</xsl:if>
				<xsl:if test="string-length($address/n1:country)>0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$address/n1:country"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>address not available</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<br/>
	</xsl:template>
	<!-- show-telecom -->
	<xsl:template name="show-telecom">
		<xsl:param name="telecom"/>
		<xsl:choose>
			<xsl:when test="$telecom">
				<xsl:variable name="type" select="substring-before($telecom/@value, ':')"/>
				<xsl:variable name="value" select="substring-after($telecom/@value, ':')"/>
				<xsl:if test="$type">
					<xsl:call-template name="translateTelecomCode">
						<xsl:with-param name="code" select="$type"/>
					</xsl:call-template>
					<xsl:if test="@use">
						<xsl:text> (</xsl:text>
						<xsl:call-template name="translateTelecomCode">
							<xsl:with-param name="code" select="@use"/>
						</xsl:call-template>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$value"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Telecom information not available</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<br/>
	</xsl:template>
	<!-- show-recipientType -->
	<xsl:template name="show-recipientType">
		<xsl:param name="typeCode"/>
		<xsl:choose>
			<xsl:when test="$typeCode='PRCP'">
				Primary Recipient:
			</xsl:when>
			<xsl:when test="$typeCode='TRC'">
				Secondary Recipient:
			</xsl:when>
			<xsl:otherwise>
				Recipient:
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Convert Telecom URL to display text -->
	<xsl:template name="translateTelecomCode">
		<xsl:param name="code"/>
		<!--xsl:value-of select="document('voc.xml')/systems/system[@root=$code/@codeSystem]/code[@value=$code/@code]/@displayName"/ -->
		<!--xsl:value-of select="document('codes.xml')/*/code[@code=$code]/@display"/ -->
		<xsl:choose>
			<!-- lookup table Telecom URI -->
			<xsl:when test="$code='tel'">
				<xsl:text>Tel</xsl:text>
			</xsl:when>
			<xsl:when test="$code='fax'">
				<xsl:text>Fax</xsl:text>
			</xsl:when>
			<xsl:when test="$code='http'">
				<xsl:text>Web</xsl:text>
			</xsl:when>
			<xsl:when test="$code='mailto'">
				<xsl:text>Mail</xsl:text>
			</xsl:when>
			<xsl:when test="$code='H'">
				<xsl:text>Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='HV'">
				<xsl:text>Vacation Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='HP'">
				<xsl:text>Primary Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='WP'">
				<xsl:text>Work Place</xsl:text>
			</xsl:when>
			<xsl:when test="$code='PUB'">
				<xsl:text>Pub</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>{$code='</xsl:text>
				<xsl:value-of select="$code"/>
				<xsl:text>'?}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- convert RoleClassAssociative code to display text -->
	<xsl:template name="showDisplayName">
		<xsl:param name="code"/>

		<xsl:if test="($code/@code) and ($code/@codeSystem='2.16.840.1.113883.5.111') and ($code/@displayName)">
			<xsl:text> (</xsl:text>
			<xsl:value-of select="$code/@displayName"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="translateRoleAssoCode">
		<xsl:param name="classCode"/>
		<xsl:param name="code"/>
		<xsl:choose>
			<xsl:when test="$classCode='AFFL'">
				<xsl:text>affiliate</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='AGNT'">
				<xsl:text>agent</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='ASSIGNED'">
				<xsl:text>assigned entity</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='COMPAR'">
				<xsl:text>commissioning party</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='CON'">
				<xsl:text>contact</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='ECON'">
				<xsl:text>emergency contact</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='NOK'">
				<xsl:text>next of kin</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='SGNOFF'">
				<xsl:text>signing authority</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='GUARD'">
				<xsl:text>guardian</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='GUAR'">
				<xsl:text>guardian</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='CIT'">
				<xsl:text>citizen</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='COVPTY'">
				<xsl:text>covered party</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='PRS'">
				<xsl:text>personal relationship</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='CAREGIVER'">
				<xsl:text>care giver</xsl:text>
			</xsl:when>
			<xsl:when test="$classCode='PROV'">
				<xsl:text>provider</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>{$classCode='</xsl:text>
				<xsl:value-of select="$classCode"/>
				<xsl:text>'?}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:if test="($code/@code) and ($code/@codeSystem='2.16.840.1.113883.5.111')"> 
			<xsl:text> </xsl:text> <xsl:choose> <xsl:when test="$code/@code='FTH'"> <xsl:text>(Father)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='MTH'"> <xsl:text>(Mother)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='NPRN'"> <xsl:text>(Natural parent)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='STPPRN'"> <xsl:text>(Step parent)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='SONC'"> <xsl:text>(Son)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='DAUC'"> <xsl:text>(Daughter)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='CHILD'"> <xsl:text>(Child)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='EXT'"> <xsl:text>(Extended family 
			member)</xsl:text> </xsl:when> <xsl:when test="$code/@code='NBOR'"> <xsl:text>(Neighbor)</xsl:text> 
			</xsl:when> <xsl:when test="$code/@code='SIGOTHR'"> <xsl:text>(Significant 
			other)</xsl:text> </xsl:when> <xsl:otherwise> <xsl:text>{$code/@code='</xsl:text> 
			<xsl:value-of select="$code/@code"/> <xsl:text>'?}</xsl:text> </xsl:otherwise> 
			</xsl:choose> </xsl:if> -->
	</xsl:template>
	<!-- show time -->
	<xsl:template name="show-time">
		<xsl:param name="datetime"/>
		<xsl:choose>
			<xsl:when test="not($datetime)">
				<xsl:call-template name="formatDateTime">
					<xsl:with-param name="date" select="@value"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDateTime">
					<xsl:with-param name="date" select="$datetime/@value"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- paticipant facility and date -->
	<xsl:template name="facilityAndDates">
		<table class="header_table">
			<tbody>
				<!-- facility id -->
				<tr>
					<td width="20%" bgcolor="#3399ff">
						<span class="td_label">
							<xsl:text>Facility ID</xsl:text>
						</span>
					</td>
					<td colspan="3">
						<xsl:choose>
							<xsl:when test="count(/n1:ClinicalDocument/n1:participant                                       [@typeCode='LOC'][@contextControlCode='OP']                                       /n1:associatedEntity[@classCode='SDLOC']/n1:id)>0">
								<!-- change context node -->
								<xsl:for-each select="/n1:ClinicalDocument/n1:participant                                       [@typeCode='LOC'][@contextControlCode='OP']                                       /n1:associatedEntity[@classCode='SDLOC']/n1:id">
									<xsl:call-template name="show-id"/>
									<!-- change context node again, for the code -->
									<xsl:for-each select="../n1:code">
										<xsl:text> (</xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="."/>
										</xsl:call-template>
										<xsl:text>)</xsl:text>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								Not available
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<!-- Period reported -->
				<tr>
					<td width="20%" bgcolor="#3399ff">
						<span class="td_label">
							<xsl:text>First day of period reported</xsl:text>
						</span>
					</td>
					<td colspan="3">
						<xsl:call-template name="show-time">
							<xsl:with-param name="datetime" select="/n1:ClinicalDocument/n1:documentationOf                                       /n1:serviceEvent/n1:effectiveTime/n1:low"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td width="20%" bgcolor="#3399ff">
						<span class="td_label">
							<xsl:text>Last day of period reported</xsl:text>
						</span>
					</td>
					<td colspan="3">
						<xsl:call-template name="show-time">
							<xsl:with-param name="datetime" select="/n1:ClinicalDocument/n1:documentationOf                                       /n1:serviceEvent/n1:effectiveTime/n1:high"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!-- show assignedEntity -->
	<xsl:template name="show-assignedEntity">
		<xsl:param name="asgnEntity"/>
		<xsl:choose>
			<xsl:when test="$asgnEntity/n1:assignedPerson/n1:name">
				<xsl:call-template name="show-name">
					<xsl:with-param name="name" select="$asgnEntity/n1:assignedPerson/n1:name"/>
				</xsl:call-template>
				<xsl:if test="$asgnEntity/n1:representedOrganization/n1:name">
					<xsl:text> of </xsl:text>
					<xsl:value-of select="$asgnEntity/n1:representedOrganization/n1:name"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$asgnEntity/n1:representedOrganization">
				<xsl:value-of select="$asgnEntity/n1:representedOrganization/n1:name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$asgnEntity/n1:id">
					<xsl:call-template name="show-id"/>
					<xsl:choose>
						<xsl:when test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show relatedEntity -->
	<xsl:template name="show-relatedEntity">
		<xsl:param name="relatedEntity"/>
		<xsl:choose>
			<xsl:when test="$relatedEntity/n1:relatedPerson/n1:name">
				<xsl:call-template name="show-name">
					<xsl:with-param name="name" select="$relatedEntity/n1:relatedPerson/n1:name"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show associatedEntity -->
	<xsl:template name="show-associatedEntity">
		<xsl:param name="assoEntity"/>
		<xsl:choose>
			<xsl:when test="$assoEntity/n1:associatedPerson">
				<xsl:for-each select="$assoEntity/n1:associatedPerson/n1:name">
					<xsl:call-template name="show-name">
						<xsl:with-param name="name" select="."/>
					</xsl:call-template>
					<xsl:call-template name="showDisplayName">
						<xsl:with-param name="code" select="$assoEntity/n1:code"/>
					</xsl:call-template>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:scopingOrganization">
				<xsl:for-each select="$assoEntity/n1:scopingOrganization">
					<xsl:if test="n1:name">
						<xsl:call-template name="show-name">
							<xsl:with-param name="name" select="n1:name"/>
						</xsl:call-template>
						<br/>
					</xsl:if>
					<xsl:if test="n1:standardIndustryClassCode">
						<xsl:value-of select="n1:standardIndustryClassCode/@displayName"/>
						<xsl:text> code:</xsl:text>
						<xsl:value-of select="n1:standardIndustryClassCode/@code"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:code">
				<xsl:call-template name="show-code">
					<xsl:with-param name="code" select="$assoEntity/n1:code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:id">
				<xsl:value-of select="$assoEntity/n1:id/@extension"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$assoEntity/n1:id/@root"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show code if originalText present, return it, otherwise, check and 
		return attribute: display name -->
	<xsl:template name="show-code">
		<xsl:param name="code"/>
		<xsl:variable name="this-codeSystem">
			<xsl:value-of select="$code/@codeSystem"/>
		</xsl:variable>
		<xsl:variable name="this-code">
			<xsl:value-of select="$code/@code"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$code/n1:originalText">
				<xsl:value-of select="$code/n1:originalText"/>
			</xsl:when>
			<xsl:when test="$code/@displayName">
				<xsl:value-of select="$code/@displayName"/>
			</xsl:when>
			<!-- <xsl:when test="$the-valuesets/*/voc:system[@root=$this-codeSystem]/voc:code[@value=$this-code]/@displayName"> 
				<xsl:value-of select="$the-valuesets/*/voc:system[@root=$this-codeSystem]/voc:code[@value=$this-code]/@displayName"/> 
				</xsl:when> -->
			<xsl:otherwise>
				<xsl:value-of select="$this-code"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show classCode -->
	<xsl:template name="show-actClassCode">
		<xsl:param name="clsCode"/>
		<xsl:choose>
			<xsl:when test=" $clsCode = 'ACT' ">
				<xsl:text>healthcare service</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'ACCM' ">
				<xsl:text>accommodation</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'ACCT' ">
				<xsl:text>account</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'ACSN' ">
				<xsl:text>accession</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'ADJUD' ">
				<xsl:text>financial adjudication</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'CONS' ">
				<xsl:text>consent</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'CONTREG' ">
				<xsl:text>container registration</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'CTTEVENT' ">
				<xsl:text>clinical trial timepoint event</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'DISPACT' ">
				<xsl:text>disciplinary action</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'ENC' ">
				<xsl:text>encounter</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'INC' ">
				<xsl:text>incident</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'INFRM' ">
				<xsl:text>inform</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'INVE' ">
				<xsl:text>invoice element</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'LIST' ">
				<xsl:text>working list</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'MPROT' ">
				<xsl:text>monitoring program</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'PCPR' ">
				<xsl:text>care provision</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'PROC' ">
				<xsl:text>procedure</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'REG' ">
				<xsl:text>registration</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'REV' ">
				<xsl:text>review</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'SBADM' ">
				<xsl:text>substance administration</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'SPCTRT' ">
				<xsl:text>speciment treatment</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'SUBST' ">
				<xsl:text>substitution</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'TRNS' ">
				<xsl:text>transportation</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'VERIF' ">
				<xsl:text>verification</xsl:text>
			</xsl:when>
			<xsl:when test=" $clsCode = 'XACT' ">
				<xsl:text>financial transaction</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show participationType -->
	<xsl:template name="show-participationType">
		<xsl:param name="ptype"/>
		<xsl:choose>
			<xsl:when test=" $ptype='PPRF' ">
				<xsl:text>primary performer</xsl:text>
			</xsl:when>
			<xsl:when test=" $ptype='PRF' ">
				<xsl:text>performer</xsl:text>
			</xsl:when>
			<xsl:when test=" $ptype='VRF' ">
				<xsl:text>verifier</xsl:text>
			</xsl:when>
			<xsl:when test=" $ptype='SPRF' ">
				<xsl:text>secondary performer</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show participationFunction -->
	<xsl:template name="show-participationFunction">
		<xsl:param name="pFunction"/>
		<xsl:choose>
			<!-- From the HL7 v3 ParticipationFunction code system -->
			<xsl:when test=" $pFunction = 'ADMPHYS' ">
				<xsl:text>(admitting physician)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'ANEST' ">
				<xsl:text>(anesthesist)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'ANRS' ">
				<xsl:text>(anesthesia nurse)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'ATTPHYS' ">
				<xsl:text>(attending physician)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'DISPHYS' ">
				<xsl:text>(discharging physician)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'FASST' ">
				<xsl:text>(first assistant surgeon)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'MDWF' ">
				<xsl:text>(midwife)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'NASST' ">
				<xsl:text>(nurse assistant)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'PCP' ">
				<xsl:text>(primary care physician)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'PRISURG' ">
				<xsl:text>(primary surgeon)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'RNDPHYS' ">
				<xsl:text>(rounding physician)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'SASST' ">
				<xsl:text>(second assistant surgeon)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'SNRS' ">
				<xsl:text>(scrub nurse)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'TASST' ">
				<xsl:text>(third assistant)</xsl:text>
			</xsl:when>
			<!-- From the HL7 v2 Provider Role code system (2.16.840.1.113883.12.443) 
				which is used by HITSP -->
			<xsl:when test=" $pFunction = 'CP' ">
				<xsl:text>(consulting provider)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'PP' ">
				<xsl:text>(primary care provider)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'RP' ">
				<xsl:text>(referring provider)</xsl:text>
			</xsl:when>
			<xsl:when test=" $pFunction = 'MP' ">
				<xsl:text>(medical home provider)</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="formatDateTime">
		<xsl:param name="date"/>
		<!-- month -->
		<xsl:variable name="month" select="substring ($date, 5, 2)"/>
		<xsl:choose>
			<xsl:when test="$month='01'">
				<xsl:text>January </xsl:text>
			</xsl:when>
			<xsl:when test="$month='02'">
				<xsl:text>February </xsl:text>
			</xsl:when>
			<xsl:when test="$month='03'">
				<xsl:text>March </xsl:text>
			</xsl:when>
			<xsl:when test="$month='04'">
				<xsl:text>April </xsl:text>
			</xsl:when>
			<xsl:when test="$month='05'">
				<xsl:text>May </xsl:text>
			</xsl:when>
			<xsl:when test="$month='06'">
				<xsl:text>June </xsl:text>
			</xsl:when>
			<xsl:when test="$month='07'">
				<xsl:text>July </xsl:text>
			</xsl:when>
			<xsl:when test="$month='08'">
				<xsl:text>August </xsl:text>
			</xsl:when>
			<xsl:when test="$month='09'">
				<xsl:text>September </xsl:text>
			</xsl:when>
			<xsl:when test="$month='10'">
				<xsl:text>October </xsl:text>
			</xsl:when>
			<xsl:when test="$month='11'">
				<xsl:text>November </xsl:text>
			</xsl:when>
			<xsl:when test="$month='12'">
				<xsl:text>December </xsl:text>
			</xsl:when>
		</xsl:choose>
		<!-- day -->
		<xsl:choose>
			<xsl:when test="substring ($date, 7, 1)=&quot;0&quot;">
				<xsl:value-of select="substring ($date, 8, 1)"/>
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring ($date, 7, 2)"/>
				<xsl:text>, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!-- year -->
		<xsl:value-of select="substring ($date, 1, 4)"/>
		<!-- time and US timezone -->
		<xsl:if test="string-length($date) > 8">
			<xsl:text>, </xsl:text>
			<!-- time -->
			<xsl:variable name="time">
				<xsl:value-of select="substring($date,9,6)"/>
			</xsl:variable>
			<xsl:variable name="hh">
				<xsl:value-of select="substring($time,1,2)"/>
			</xsl:variable>
			<xsl:variable name="mm">
				<xsl:value-of select="substring($time,3,2)"/>
			</xsl:variable>
			<xsl:variable name="ss">
				<xsl:value-of select="substring($time,5,2)"/>
			</xsl:variable>
			<xsl:if test="string-length($hh)>1">
				<xsl:value-of select="$hh"/>
				<xsl:if test="string-length($mm)>1 and not(contains($mm,'-')) and not (contains($mm,'+'))">
					<xsl:text>:</xsl:text>
					<xsl:value-of select="$mm"/>
					<xsl:if test="string-length($ss)>1 and not(contains($ss,'-')) and not (contains($ss,'+'))">
						<xsl:text>:</xsl:text>
						<xsl:value-of select="$ss"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!-- time zone -->
			<xsl:variable name="tzon">
				<xsl:choose>
					<xsl:when test="contains($date,'+')">
						<xsl:text>+</xsl:text>
						<xsl:value-of select="substring-after($date, '+')"/>
					</xsl:when>
					<xsl:when test="contains($date,'-')">
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring-after($date, '-')"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<!-- reference: http://www.timeanddate.com/library/abbreviations/timezones/na/ -->
				<xsl:when test="$tzon = '-0500' ">
					<xsl:text>, EST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0600' ">
					<xsl:text>, CST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0700' ">
					<xsl:text>, MST</xsl:text>
				</xsl:when>
				<xsl:when test="$tzon = '-0800' ">
					<xsl:text>, PST</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$tzon"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- convert to lower case -->
	<xsl:template name="caseDown">
		<xsl:param name="data"/>
		<xsl:if test="$data">
			<xsl:value-of select="translate($data, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		</xsl:if>
	</xsl:template>
	<!-- convert to upper case -->
	<xsl:template name="caseUp">
		<xsl:param name="data"/>
		<xsl:if test="$data">
			<xsl:value-of select="translate($data,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		</xsl:if>
	</xsl:template>
	<!-- convert first character to upper case -->
	<xsl:template name="firstCharCaseUp">
		<xsl:param name="data"/>
		<xsl:if test="$data">
			<xsl:call-template name="caseUp">
				<xsl:with-param name="data" select="substring($data,1,1)"/>
			</xsl:call-template>
			<xsl:value-of select="substring($data,2)"/>
		</xsl:if>
	</xsl:template>
	<!-- show-noneFlavor -->
	<xsl:template name="show-noneFlavor">
		<xsl:param name="nf"/>
		<xsl:choose>
			<xsl:when test=" $nf = 'NI' ">
				<xsl:text>no information</xsl:text>
			</xsl:when>
			<xsl:when test=" $nf = 'INV' ">
				<xsl:text>invalid</xsl:text>
			</xsl:when>
			<xsl:when test=" $nf = 'MSK' ">
				<xsl:text>masked</xsl:text>
			</xsl:when>
			<xsl:when test=" $nf = 'NA' ">
				<xsl:text>not applicable</xsl:text>
			</xsl:when>
			<xsl:when test=" $nf = 'UNK' ">
				<xsl:text>unknown</xsl:text>
			</xsl:when>
			<xsl:when test=" $nf = 'OTH' ">
				<xsl:text>other</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--Language translation -->
	<xsl:template name="show-language-with-mode">
        <xsl:param name="langDisplay"/>
        <xsl:param name="modeCode"/>
		<xsl:choose>
			<xsl:when test="$modeCode = 'ESGN'">
				<xsl:text>Signs </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when> 
			<xsl:when test="$modeCode = 'ESP'">
				<xsl:text>Speaks </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when> 
			<xsl:when test="$modeCode = 'EWR'">
				<xsl:text>Writes </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when>    
			<xsl:when test="$modeCode = 'RSGN'">
				<xsl:text>Understands signed </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when>    
			<xsl:when test="$modeCode = 'RSP'">
				<xsl:text>Understands spoken </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when>    
			<xsl:when test="$modeCode = 'RWR'">
				<xsl:text>Understands written </xsl:text>
				<xsl:value-of select="$langDisplay"/>
			</xsl:when>   
		</xsl:choose>
    </xsl:template>	
	<xsl:template name="show-language">
		<xsl:param name="langCode"/>
		<xsl:param name="modeCode"/>
		<xsl:choose>
			<xsl:when test="$langCode/@code = 'SQ' or $langCode/@code = 'SQI' or $langCode/@code = 'ALB'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Albanian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'APA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Apache languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'AR' or $langCode/@code = 'ARA' or $langCode/@code = 'ar-AE' or $langCode/@code = 'ar-SA' or $langCode/@code = 'ar-MA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Arabic'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HY' or $langCode/@code = 'HYE' or $langCode/@code = 'ARM'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Armenian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'AUS'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Australian languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'BS' or $langCode/@code = 'BOS'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bosnian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'BG' or $langCode/@code = 'BUL'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bulgarian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'BG' or $langCode/@code = 'BUL'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bulgarian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CE' or $langCode/@code = 'CHE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chechen'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CE' or $langCode/@code = 'CHE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chechen'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ZH' or $langCode/@code = 'ZHO' or $langCode/@code = 'CHI'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chinese'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CHR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Cherokee'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CHY'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Cheyenne'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CS' or $langCode/@code = 'CES' or $langCode/@code = 'CZE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Czech'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'DA' or $langCode/@code = 'DAN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Danish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'NL' or $langCode/@code = 'NLD' or $langCode/@code = 'DUT'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Dutch; Flemish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'EGY'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Egyptian (Ancient)'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'EN' or $langCode/@code = 'ENG' or $langCode/@code = 'en-US' or $langCode/@code = 'en-GB' or $langCode/@code = 'en-CA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'English'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ET' or $langCode/@code = 'EST'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Estonian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'FIL'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Filipino; Pilipino'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'FI' or $langCode/@code = 'FIN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Finnish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'FR' or $langCode/@code = 'FRA' or $langCode/@code = 'FRE' or $langCode/@code = 'fr-CA' or $langCode/@code = 'fr-FR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'French'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'DE' or $langCode/@code = 'DEU' or $langCode/@code = 'GER'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'German'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'GA' or $langCode/@code = 'GLE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Irish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'GL' or $langCode/@code = 'GLG'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Galician'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'EL' or $langCode/@code = 'ELL' or $langCode/@code = 'GRE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Greek, Modern (1453-)'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HT' or $langCode/@code = 'HAT'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Haitian; Haitian Creole'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HAW'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hawaiian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HE' or $langCode/@code = 'HEB'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hebrew'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HI' or $langCode/@code = 'HIN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hindi'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HR' or $langCode/@code = 'HRV'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Croatian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'HU' or $langCode/@code = 'HUN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hungarian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'IS' or $langCode/@code = 'ISL' or $langCode/@code = 'ICE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Icelandic'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ID' or $langCode/@code = 'IND'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Indonesian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'IRA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Iranian languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'IT' or $langCode/@code = 'ITA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Italian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'JA' or $langCode/@code = 'JPN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Japanese'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'KO' or $langCode/@code = 'KOR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Korean'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'LA' or $langCode/@code = 'LAT'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Latin'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'LV' or $langCode/@code = 'LAV'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Latvian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'LB' or $langCode/@code = 'LTZ'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Luxembourgish; Letzeburgesch'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MK' or $langCode/@code = 'MKD' or $langCode/@code = 'MAC'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Macedonian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MT' or $langCode/@code = 'MLT'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Maltese'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MNC'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Manchu'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MOH'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mohawk'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MN' or $langCode/@code = 'MON'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mongolian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'MYN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mayan languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'NAI'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'North American Indian languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'NN' or $langCode/@code = 'NNO'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Norwegian Nynorsk; Nynorsk, Norwegian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'NO' or $langCode/@code = 'NOR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Norwegian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'OTA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Turkish, Ottoman (1500-1928)'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'FA' or $langCode/@code = 'FAS' or $langCode/@code = 'PER'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Persian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'PHI'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Persian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'PL' or $langCode/@code = 'POL'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Polish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'PT' or $langCode/@code = 'POR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Portuguese'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'RU' or $langCode/@code = 'RUS'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Russian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SAI'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'South American Indian (Other)'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SA' or $langCode/@code = 'SAN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sanskrit'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SCN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sicilian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SGN'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sign Languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SLA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slavic languages'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SK' or $langCode/@code = 'SLK' or $langCode/@code = 'SLO'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slovak'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SL' or $langCode/@code = 'SLV'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slovenian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SM' or $langCode/@code = 'SMO'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Samoan'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SO' or $langCode/@code = 'SOM'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Somali'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ES' or $langCode/@code = 'SPA' or $langCode/@code = 'es-ES' or $langCode/@code = 'es-MX' or $langCode/@code = 'es-PR' or $langCode/@code = 'es-AR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Somali'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SR' or $langCode/@code = 'SRP'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Serbian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'SV' or $langCode/@code = 'SWE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Swedish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'TY' or $langCode/@code = 'TAH'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Tahitian'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'TH' or $langCode/@code = 'THA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Thai'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'BO' or $langCode/@code = 'BOD' or $langCode/@code = 'TIB'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Tibetan'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'TR' or $langCode/@code = 'TUR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Turkish'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'VI' or $langCode/@code = 'VIE'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Vietnamese'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'CY' or $langCode/@code = 'CYM' or $langCode/@code = 'WEL'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Welsh'"/>
					<xsl:with-param name="modeCode" select="$modeCode/@code"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="pref-language">
		<xsl:param name="langCode"/>
		<xsl:param name="prefLang"/>
		<xsl:param name="modeCode"/>
		<xsl:choose>
			<xsl:when test="$prefLang/@value='true'">
				<xsl:call-template name="show-language">
					<xsl:with-param name="langCode" select="$langCode"/>
					<xsl:with-param name="modeCode" select="$modeCode"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Add spaces in the view of notes. -->
	<xsl:template match="n1:table/n1:tbody/n1:tr/n1:td/n1:content" name="insertBreaks">
		<xsl:param name="pText" select="."/>
		<xsl:choose>
			<xsl:when test="not(contains($pText, '
'))  or not($isVA)">
				<xsl:copy-of select="$pText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($pText, '
')"/>
				<br/>
				<xsl:call-template name="insertBreaks">
					<xsl:with-param name="pText" select="substring-after($pText, '
')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <!--
        <xsl:template match="*|@*|text()">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:template>
    -->
</xsl:stylesheet>