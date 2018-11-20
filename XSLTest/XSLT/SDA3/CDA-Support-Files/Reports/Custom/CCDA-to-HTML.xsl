<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:output method="html" indent="yes" version="4.01"
		encoding="ISO-8859-1" doctype-system="http://www.w3.org/TR/html4/strict.dtd"
		doctype-public="-//W3C//DTD HTML 4.01//EN" />

	<!-- global variable title -->
	<xsl:variable name="title">
		<xsl:choose>
			<xsl:when test="string-length(/n1:ClinicalDocument/n1:title)  &gt;= 1">
				<xsl:value-of select="/n1:ClinicalDocument/n1:title" />
			</xsl:when>
			<xsl:when test="/n1:ClinicalDocument/n1:code/@displayName">
				<xsl:value-of select="/n1:ClinicalDocument/n1:code/@displayName" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Clinical Document</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Test to see if this is a VA document -->
	<xsl:variable name="isVA"
		select="boolean(/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:representedOrganization/n1:id[@root='2.16.840.1.113883.4.349'])" />

	<!-- previous code to check file based on LOINC <xsl:variable name="isSES" select="boolean(/n1:ClinicalDocument/n1:code[@code='11506-3'] or /n1:ClinicalDocument/n1:code[@code='34130-5'] or /n1:ClinicalDocument/n1:code[@code='34131-3'] or /n1:ClinicalDocument/n1:code[@code='15507-7'] )"/>
                -->
        <!-- checks to see if document is R1.1 or R2.1 by looking for inclusion of extension in templateID - R1.1 has no extension, R2.1 Does. -->
        <xsl:variable name ="hasExtension" select="boolean(/n1:ClinicalDocument/n1:templateId[string(@extension)])" />

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
                <templateID>2.16.840.1.113883.10.20.22.2.65</templateID>
	</xsl:variable>

	<xsl:param name="ccdTemplateIdArrayParam"
		select="document('')/*/xsl:variable[@name='ccdTemplateIdArray']/*" />

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

	</xsl:variable>

	<xsl:param name="ccdAdditionalTemplateIdArrayParam"
		select="document('')/*/xsl:variable[@name='ccdAdditionalTemplateIdArray']/*" />

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
                <templateID>2.16.840.1.113883.10.20.22.2.65</templateID>

	</xsl:variable>

	<xsl:param name="progressAdditionalTemplateIdArrayParam"
		select="document('')/*/xsl:variable[@name='progressAdditionalTemplateIdArray']/*" />

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
                <templateID>2.16.840.1.113883.10.20.22.2.65</templateID>
	</xsl:variable>

	<xsl:param name="progressTemplateIdArrayParam"
		select="document('')/*/xsl:variable[@name='progressTemplateIdArray']/*" />

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

	<xsl:param name="ccdSectionHeaderParam"
		select="document('')/*/xsl:variable[@name='ccdSectionHeader']/*" />

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

	<xsl:param name="ccdAdditionalSectionHeaderParam"
		select="document('')/*/xsl:variable[@name='ccdAdditionalSectionHeader']/*" />

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

	<xsl:param name="progressAdditionalSectionHeaderParam"
		select="document('')/*/xsl:variable[@name='progressAdditionalSectionHeader']/*" />

	<xsl:variable name="ccdSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[1])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[2])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[3])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[4])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[5])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[6])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[7])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[8])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[9])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[10])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[11])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[12])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[13])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[14])" />
		</titleId>
                <titleId>
			<xsl:value-of select="generate-id($ccdSectionHeaderParam/headerName[15])" />
		</titleId>
	</xsl:variable>

	<xsl:param name="ccdSectionHeaderRefParam"
		select="document('')/*/xsl:variable[@name='ccdSectionHeaderHref']/*" />

	<xsl:variable name="ccdAdditionalSectionHeaderHref">
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[1])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[2])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[3])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[4])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[5])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[6])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[7])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[8])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[9])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[10])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[11])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[12])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[13])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[14])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[15])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[16])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[17])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[18])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[19])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[20])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[21])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[22])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[23])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[24])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[25])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[26])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[27])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[28])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[29])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[30])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[31])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[32])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[33])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[34])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[35])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[36])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[37])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[38])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[39])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[40])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[41])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[42])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($ccdAdditionalSectionHeaderParam/headerName[43])" />
		</titleId>
        </xsl:variable>

	<xsl:param name="ccdAdditionalSectionHeaderHrefParam"
		select="document('')/*/xsl:variable[@name='ccdAdditionalSectionHeaderHref']/*" />

	<xsl:variable name="progressAdditionalSectionHeaderHref">
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[1])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[2])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[3])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[4])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[5])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[6])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[7])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[8])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[9])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[10])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[11])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[12])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[13])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[14])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[15])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[16])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[17])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[18])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[19])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[20])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[21])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[22])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[23])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[24])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[25])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[26])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[27])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[28])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[29])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[30])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[31])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[32])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[33])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[34])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[35])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[36])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[37])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[38])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[39])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[40])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[41])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[42])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[43])" />
		</titleId>
		<titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[44])" />
		</titleId>
                <titleId>
			<xsl:value-of
				select="generate-id($progressAdditionalSectionHeaderParam/headerName[45])" />
		</titleId>

	</xsl:variable>

	<xsl:param name="progressAdditionalSectionHeaderHrefParam"
		select="document('')/*/xsl:variable[@name='progressAdditionalSectionHeaderHref']/*" />
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

	<xsl:param name="progSectionHeaderParam"
		select="document('')/*/xsl:variable[@name='progSectionHeader']/*" />

	<xsl:variable name="progSectionHeaderHref">
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[1])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[2])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[3])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[4])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[5])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[6])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[7])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[8])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[9])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[10])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[11])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[12])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[13])" />
		</titleId>
		<titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[14])" />
		</titleId>
                <titleId>
			<xsl:value-of select="generate-id($progSectionHeaderParam/headerName[15])" />
		</titleId>
	</xsl:variable>

	<xsl:param name="progSectionHeaderHrefParam"
		select="document('')/*/xsl:variable[@name='progSectionHeaderHref']/*" />

	<xsl:variable name="ccdDocTemplateRoot"
		select="/n1:ClinicalDocument/n1:templateId[@root='2.16.840.1.113883.10.20.22.1.1']/@root" />
	<xsl:variable name="progDocTemplateRoot"
		select="/n1:ClinicalDocument/n1:templateId[@root='2.16.840.1.113883.10.20.22.1.9']/@root" />

	<xsl:variable name="ccdaDoc">
		<xsl:text>2.16.840.1.113883.10.20.22.1.1</xsl:text>
	</xsl:variable>
	<xsl:variable name="progressDoc">
		<xsl:text>2.16.840.1.113883.10.20.22.1.9</xsl:text>
	</xsl:variable>

	<!-- Main -->
	<xsl:template match="/">
		<xsl:apply-templates select="n1:ClinicalDocument" />
	</xsl:template>
	<!-- produce browser rendered, human readable clinical document -->
	<xsl:template match="n1:ClinicalDocument">
		<html>
			<head>
				<meta charset="utf-8" />
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<title>Veterans Affairs</title>
				<meta name="description" content="" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />

				<link rel="stylesheet"
					href="http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,300,400,600,700" />
				<style type="text/css">
/* CDA CSS StyleSheet Version 2.0 */
*,
*::before,
*::after {
	box-sizing: border-box;
}

body {
	background: #fff;
	color: #000;
	font: 14px/1.5 'Open Sans', Helvetica, Arial, Verdana, sans-serif;
	margin: 0;
/*	padding: 140px 0 0;*/
	padding: 0;
}

h1, h2, h3, h4, h5 {
	font-weight: normal;
	font-weight: 400;
}
/*
.clearfix {
	*zoom: 1;
	
	&amp;::before,
	&amp;::after {
		content: " ";
		display: table;
	}
	&amp;::after {
		clear: both;
	}
}

.columns {
	overflow: hidden;
	width: 100%;
}

.col-2 {
	float: left;
	width: 47.45%;
}

.col-2 + .col-2 {
	margin-left: 4.95%;
}

.col-3 {
	float: left;
	width: 29.95%;
}

.col-3 + .col-3 {
	margin-left: 4.95%;
}

.episode-note-container,
.titlebar {
	max-width: 960px;
	margin: 0 auto;
	width: 100%;
}

.titlebar-container.fixed {
	left: 0;
	position: fixed;
	top: 0;
	width: 100%;
}

.titlebar {
	background: #fff;
	border-bottom: 2px solid #222;
	padding: 10px;
}

.titlebar h1,
.titlebar h2 {
	font-size: 2em;
}

.titlebar span.cell {
	display: inline-block;
	text-align: right;
	width: 120px;
}

.titlebar p {
	margin-bottom: 0;
}

.infobar {
	/*padding: 20px;*/
/*
}

.titlebar h1,
.titlebar h2,
.infobar h1,
.infobar h2 {
	margin: 0;
}

.backtotop {
	background: #fff;
	border: 2px solid #222;
	border-top: none;
	border-radius: 0 0 3px 3px;
	color: #222;
	cursor: pointer;
	display: inline-block;
	font-size: 12px;
	left: 50%;
	line-height: 1;
	outline: none;
	margin: 0 0 0 -55px;
	padding: 6px 0;
	position: absolute;
	text-align: center;
	top: -28px;
	width: 110px;
	-webkit-transition: top 500ms cubic-bezier(0.770, 0.000, 0.175, 1.000);
	-moz-transition: top 500ms cubic-bezier(0.770, 0.000, 0.175, 1.000);
	-ms-transition: top 500ms cubic-bezier(0.770, 0.000, 0.175, 1.000);
	-o-transition: top 500ms cubic-bezier(0.770, 0.000, 0.175, 1.000);
	transition: top 500ms cubic-bezier(0.770, 0.000, 0.175, 1.000);
}


.backtotop.active {
	top: 0;
}

.backtotop:hover {
	background: #222;
	color: #fff;
	padding: 12px 0 6px;
}

.toc {
	text-align: center;
}

.toc p {
	margin: 0 auto .5em;
}

.toc ul {
	font-size: 0; /* fix for whitespace bug */
	list-style: none;
	/* margin: 16px 0 0; */
	/*
	padding: 0;
	
}

.toc li {
	display: inline;
}

.toc a {
	background: #fff;
	border-radius: 3px;
	border: 2px solid #222;
	color: #222;
	display: inline-block;
	font-size: 12px;
	margin: 4px 2px 0;
	padding: 6px 12px;
	text-decoration: none;
}

.toc a:hover{
	background: #222;
	color: #fff;
	content: attr(title);
}

.toc a.disabled,
.toc a.disabled:hover {
	background: #fff;
	border-color: #ccc;
	color: #aaa;
}

section {
	padding: 5px 5px 5px 5px;
}

section + section {
	border-top: 2px solid #222;
}

section header p {
	color: #999;
	font-size: .9285714286em;
	line-height: 1.2;
}

section header p strong {
	font-weight: normal;
}

section header h2 {
	margin: 0 auto .5em;
}

section header h2 + p {
	margin-top: 0;
}

section header h2 span {
	color: #ccc;
	color: rgba(0,0,0,.35);
	display: inline-block;
	font-size: .75em;
	padding-left: .5em;
}

span.count {
	background-color: #222;
	border-radius: 5px;
	color: #fff;
	display: inline-block;
	font-weight: normal;
	margin-left: .5em;
	padding: 0 5px;
}

span.badge {
	background-color: #222;
	border-radius: 5px;
	color: #fff;
	display: inline-block;
	font-size: 11px;
	padding: 2px 5px;
}

table {
	background: #fff;
	border-collapse: collapse;
	font-size: 12px;
	text-align: left;
	width: 100%;
}

table td,
table th {
	padding: 8px 6px;
}

table th {
	font-weight: normal;
}

table thead tr th {
	background: #222;
	border-right: 1px solid rgba(255,255,255,.5);
	color: #fff;
}
table thead tr th:last-child {
	border-right: 1px solid #ccc;
}

table tbody tr td,
table tbody tr th {
	border-bottom: 1px solid #ccc;
	border-right: 1px solid #ccc;
	vertical-align: top;
	text-align: left;
}

table tbody em {
	color: rgba(0,0,0,.4);
}

table tbody tr > *:first-child {
	border-left: 1px solid #ccc;
}

table.sectioned tbody tr td,
table.sectioned tbody tr th {
	background: none;
}

table > tbody:nth-child(2) > tr:hover > td,
table > tbody:nth-child(2) > tr:hover > th {
	background: #fffff0 !important;
}

table > tbody:nth-child(2) > tr > td:hover,
table > tbody:nth-child(2) > tr > th:hover {
	background: #fffac7 !important;
}

table > tbody:nth-child(3) > tr > td > ul {
	margin:0;
	padding-left:0;
	list-style:none;
	line-height:1.5em;
}

.narr_tr {
	vertical-align: top;
	text-align: left;
}
*[styleCode~='Bold'] {
	font-weight:bold;
}
*[styleCode~='Italics'] {
	font-style: italic;
}
*[styleCode~='Underline'] {
	text-decoration: underline;
}
/*table.sectioned tbody tr td.empty,
table.sectioned tbody tr th.empty {
	background-color: rgba(0,0,0,.05) !important;
}*/				
				</style>
			</head>
			<body>
				<div id="top" class="episode-note-container">

					<div id="titlebar-container" class="titlebar-container">
						<header id="titlebar" class="titlebar">
							<div class="columns">
								<div class="col-3">
								   <p>
										<xsl:value-of select="n1:title" />
										<!-- VA Continuity of Care Document <xsl:choose> <xsl:when test="contains($docTemplateRoot,
											$ccdaDoc)"> (VA CCD) </xsl:when> <xsl:when test="contains($docTemplateRoot,
											$progressDoc)"> (VA Progress Notes) </xsl:when> <xsl:otherwise> </xsl:otherwise>
											</xsl:choose> -->
										<br />
										Creation Date:
										<xsl:call-template name="show-time">
											<xsl:with-param name="datetime" select="n1:effectiveTime" />
										</xsl:call-template>
									</p>
								</div>

								<div class="col-3" style="text-align: center;word-wrap: break-word;">
								      									<h1>
										<xsl:value-of
											select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name" />
									</h1>

									  								      </div>

								<div class="col-3" style="text-align: left;word-wrap: break-word;">
								  <p>
								    	Patient:

										<xsl:call-template name="show-name">
											<xsl:with-param name="name"
												select="n1:recordTarget/n1:patientRole/n1:patient/n1:name" />
										</xsl:call-template>
									<br />
										DOB:

											<xsl:call-template name="show-time">
												<xsl:with-param name="datetime"
													select="n1:recordTarget/n1:patientRole/n1:patient/n1:birthTime" />
											</xsl:call-template>

										<br />
										Gender:
											<xsl:for-each
												select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:administrativeGenderCode">
												<xsl:if test="@nullFlavor">
													<xsl:value-of select="n1:originalText"/>
												</xsl:if>
												<xsl:call-template name="show-gender" />
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
									  <xsl:if
									      test="count(/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component[n1:section]) &gt; 1">
									    <xsl:call-template name="make-tableofcontents-dynamic" />
									  </xsl:if>
									</xsl:if>
									</div>
								</nav>

								<button id="backtotop" class="backtotop">&#x2191; Back To Top</button>
						</header>
					</div>            <!-- START display top portion of clinical document -->
					<div class="sections">

						<section id="Patient Information">
							<header>
								<h2>
									<label id="plus.Patient Information" onclick="javascript:toggle('open','Patient Information')">[+]  </label>
									<label id="minus.Patient Information" onclick="javascript:toggle('close','Patient Information')">[-]  </label>
								Patient Information</h2>
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
													<xsl:for-each
														select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole">
														<xsl:if test="not(n1:id/@nullFlavor)">
															<xsl:call-template name="show-contactInfo">
																<xsl:with-param name="contact" select="." />
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
														<xsl:when
															test="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/@displayName">
															<xsl:value-of
																select="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/@displayName" />
														</xsl:when>
														<xsl:when
															test="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/n1:originalText">
															<xsl:value-of
																select="n1:recordTarget/n1:patientRole/n1:patient/n1:maritalStatusCode/n1:originalText" />
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
													<xsl:for-each
														select="n1:recordTarget/n1:patientRole/n1:patient/n1:languageCommunication">
														<xsl:call-template name="show-language">
															<xsl:with-param name="langCode" select="n1:languageCode" />
															<xsl:with-param name="modeCode" select="n1:modeCode" />
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
													<xsl:for-each
														select="n1:recordTarget/n1:patientRole/n1:patient/n1:languageCommunication">
														<xsl:call-template name="pref-language">
															<xsl:with-param name="langCode" select="n1:languageCode" />
															<xsl:with-param name="prefLang" select="n1:preferenceInd" />
															<xsl:with-param name="modeCode" select="n1:modeCode" />
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
							</div>

						</section>

						<xsl:apply-templates
							select="n1:component/n1:structuredBody|n1:component/n1:nonXMLBody" />

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
									<xsl:call-template name="documentationOf" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>No data provided for this section.</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							</div>
						</section>

						<section id="Contact Information">
							<header>
								<h2>
									<label id="plus.Contact Information" onclick="javascript:toggle('open','Contact Information')">[+]</label>
									<label id="minus.Contact Information" onclick="javascript:toggle('close','Contact Information')">[-]</label>
								Contact Information</h2>
							</header>
							<div class="col-2">
								<div id="section.Contact Information">
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
													<xsl:call-template name="participant" />
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
						</section>
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
					<![CDATA[
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

			if ('querySelector' in document && 'addEventListener' in window && Array.prototype.forEach){
				window.addEventListener('load', function(){

					var backtotop = document.getElementById('backtotop'),
						titlebar = document.getElementById('titlebar'),
						titlebar_container = document.getElementById('titlebar-container'),
						titlebar_height = titlebar_container.offsetHeight;

					// titlebar isn't fixed without javascript
					// we know we have javascript enabled now, so set the titlebar as fixed, and offset the body with padding to match
					addClass(titlebar_container, 'fixed');
					document.body.style.padding = titlebar_height+"px 0 0";

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
			}
					]]>
				</script>
			</body>
		</html>
	</xsl:template>
		<!-- generate table of contents -->
	<xsl:template name="make-tableofcontents">
		<xsl:variable name="compTemplateIdRoots"
			select="n1:component/n1:structuredBody/n1:component/n1:section/n1:templateId/@root" />
		<xsl:variable name="sections"
			select="n1:component/n1:structuredBody/n1:component/n1:section" />

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
							<xsl:value-of select="'Patient Information'" />
						</a>
						<xsl:for-each select="$progressTemplateIdArrayParam">
							<xsl:variable name="templateId">
								<xsl:value-of select="." />
							</xsl:variable>

							<!--<xsl:if test="$compTemplateIdRoots = $templateId or $compTemplateIdRoots
								= concat($templateId,'.1')"> -->
							<xsl:variable name="pos-int" select="position()" />
							<!--<xsl:value-of select="$pos-int" /> -->
							<xsl:variable name="headerValue">
								<xsl:value-of select="$progSectionHeaderParam[$pos-int]" />
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of
									select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text" />
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="contains($headerTxt, 'No Information')">
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:when>
								<xsl:when test="string-length($headerTxt) &gt; 0">
									<a data-target="{$headerValue}" href="#{$headerValue}">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:otherwise>

							</xsl:choose>
							<!--</xsl:if> -->
						</xsl:for-each>
						<xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/n1:performer">
								<a data-target="healthcare-providers" href="#healthcare-providers">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="healthcare-providers" href="#healthcare-providers"
									class="disabled">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<a data-target="contact-info" href="#contact-info">
							<xsl:value-of select="'Contact Information'" />
						</a>
					</li>
				</ul>
			</xsl:when>
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<!-- <li> <a href="#{generate-id(Demographics)}"> <xsl:text>Demographics</xsl:text>
					</a> </li> -->
				<ul>
					<li>
						<a data-target="patient-information" href="#patient-information">
							<xsl:value-of select="'Patient Information'" />
						</a>

						<xsl:for-each select="$ccdTemplateIdArrayParam">
							<xsl:variable name="templateId">
								<xsl:value-of select="." />
							</xsl:variable>

							<!--<xsl:if test="$compTemplateIdRoots = $templateId or $compTemplateIdRoots
								= concat($templateId,'.1')"> -->
							<xsl:variable name="pos-int" select="position()" />
							<!--<xsl:value-of select="$pos-int" /> -->
							<xsl:variable name="headerValue">
								<xsl:value-of select="$ccdSectionHeaderParam[$pos-int]" />
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of
									select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text" />
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="contains($headerTxt, 'No Information')">
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:when>
								<xsl:when test="string-length($headerTxt) &gt; 0">
									<a data-target="{$headerValue}" href="#{$headerValue}">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
										<xsl:value-of select="$headerValue" />
									</a>
								</xsl:otherwise>

							</xsl:choose>
							<!--</xsl:if> -->
						</xsl:for-each>
						<xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/n1:performer">
								<a data-target="healthcare-providers" href="#healthcare-providers">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="healthcare-providers" href="#healthcare-providers"
									class="disabled">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<a data-target="contact-info" href="#contact-info">
							<xsl:value-of select="'Contact Information'" />
						</a>
					</li>
				</ul>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- DYNAMIC VERSION generate table of contents -->
	<xsl:template name="make-tableofcontents-dynamic">
		<xsl:variable name="compTemplateIdRoots"
			select="n1:component/n1:structuredBody/n1:component/n1:section/n1:templateId/@root" />
		<!--
		<xsl:variable name="sections"
			select="n1:component/n1:structuredBody/n1:component/n1:section" />
		-->
		<xsl:variable name="components"
			select="n1:component/n1:structuredBody/n1:component" />

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
							<xsl:value-of select="'Patient Information'" />
						</a>
						<xsl:for-each select="$components">
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

							<xsl:variable name="loincCode"><xsl:value-of select="n1:section/n1:code/@code"/></xsl:variable>
							<xsl:variable name="headerValue">
								<xsl:call-template name="getSectionHeaderText">
									<xsl:with-param name="loincCode" select="$loincCode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of
									select="n1:section/n1:text" />
							</xsl:variable>

							<!-- Decide to display and/or disable buttons -->
							<xsl:if test="string-length($templateId) &gt; 0">
								<xsl:if test="string-length($headerValue) &gt; 0">
									<xsl:choose>
										<xsl:when test="n1:section/n1:text/n1:list/n1:item">
											<a data-target="{$headerValue}" href="#{$headerValue}">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:when test="contains($headerTxt, 'No Data')">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:when test="n1:section/@nullFlavor">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:when test="$entryCount = 0">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a data-target="{$headerValue}" href="#{$headerValue}">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>

						</xsl:for-each>
						<xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/@classCode='PCPR' and count(n1:documentationOf/n1:serviceEvent/n1:performer) > 0">
								<a data-target="Healthcare Providers" href="#Healthcare Providers">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Healthcare Providers" href="#Healthcare Providers"
									class="disabled">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="n1:participant">
								<a data-target="Contact Information" href="#Contact Information">
									<xsl:value-of select="'Contact Information'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Contact Information" href="#Contact Information" class="disabled">
									<xsl:value-of select="'Contact Information'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</ul>
			</xsl:when>
			<xsl:when test="contains($ccdDocTemplateRoot, $ccdaDoc)">
				<ul>
					<li>
						<a data-target="patient-information" href="#patient-information"  title="Patient Information">
							<xsl:value-of select="'Patient Information'" />
						</a>

						<xsl:for-each select="$components">
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
							<xsl:variable name="loincCode"><xsl:value-of select="n1:section/n1:code/@code"/></xsl:variable>
							<xsl:variable name="headerValue">
								<xsl:call-template name="getSectionHeaderText">
									<xsl:with-param name="loincCode" select="$loincCode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="headerTxt">
								<xsl:value-of
									select="n1:section/n1:text" />
							</xsl:variable>

							<!-- Decide to display and/or disable buttons -->
							<xsl:if test="string-length($templateId) &gt; 0">
								<xsl:if test="string-length($headerValue) &gt; 0">
									<xsl:choose>
										<xsl:when test="$entryCount = 0">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:when test="contains($headerTxt, 'No Data')">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:when test="n1:section/@nullFlavor">
											<a data-target="{$headerValue}" href="#{$headerValue}" class="disabled">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a data-target="{$headerValue}" href="#{$headerValue}"  title="{n1:section/n1:title}">
											<xsl:value-of select="$headerValue" />
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when test="n1:documentationOf/n1:serviceEvent/@classCode='PCPR'">
								<a data-target="Healthcare Providers" href="#Healthcare Providers"  title="Healthcare Providers">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a data-target="Healthcare Providers" href="#Healthcare Providers"
									class="disabled">
									<xsl:value-of select="'Healthcare Providers'" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
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
						</xsl:choose>
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
								<xsl:with-param name="id" select="n1:id" />
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
								<xsl:with-param name="datetime" select="n1:effectiveTime" />
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
						<xsl:when test="n1:confidentialityCode/@code  = &apos;N&apos;">
							<xsl:text>Normal</xsl:text>
						</xsl:when>
						<xsl:when test="n1:confidentialityCode/@code  = &apos;R&apos;">
							<xsl:text>Restricted</xsl:text>
						</xsl:when>
						<xsl:when test="n1:confidentialityCode/@code  = &apos;V&apos;">
							<xsl:text>Very restricted</xsl:text>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="n1:confidentialityCode/n1:originalText">
						<xsl:text> </xsl:text>
						<xsl:value-of select="n1:confidentialityCode/n1:originalText" />
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
													<xsl:with-param name="name"
														select="n1:assignedPerson/n1:name" />
												</xsl:call-template>
												<!--<xsl:if test="n1:representedOrganization"> <xsl:text>, </xsl:text>
													<xsl:call-template name="show-name"> <xsl:with-param name="name" select="n1:representedOrganization/n1:name"/>
													</xsl:call-template> </xsl:if> -->
											</xsl:when>
											<xsl:when test="n1:assignedAuthoringDevice/n1:softwareName">
												<xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName" />
											</xsl:when>
											<xsl:when test="n1:representedOrganization">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name"
														select="n1:representedOrganization/n1:name" />
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="n1:id">
													<xsl:call-template name="show-id" />
													<br />
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
												<xsl:with-param name="contact" select="." />
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
										<xsl:with-param name="name"
											select="n1:assignedEntity/n1:assignedPerson/n1:name" />
									</xsl:call-template>
									<xsl:text> at </xsl:text>
									<xsl:call-template name="show-time">
										<xsl:with-param name="date" select="n1:time" />
									</xsl:call-template>
								</td>
							</tr>
							<xsl:if
								test="n1:assignedEntity/n1:addr | n1:assignedEntity/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact" select="n1:assignedEntity" />
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
									<xsl:with-param name="asgnEntity"
										select="n1:legalAuthenticator/n1:assignedEntity" />
								</xsl:call-template>
								<xsl:text> </xsl:text>
								<xsl:call-template name="show-sig">
									<xsl:with-param name="sig"
										select="n1:legalAuthenticator/n1:signatureCode" />
								</xsl:call-template>
								<xsl:if test="n1:legalAuthenticator/n1:time/@value">
									<xsl:text> at </xsl:text>
									<xsl:call-template name="show-time">
										<xsl:with-param name="datetime"
											select="n1:legalAuthenticator/n1:time" />
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
						<xsl:if
							test="n1:legalAuthenticator/n1:assignedEntity/n1:addr | n1:legalAuthenticator/n1:assignedEntity/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact"
											select="n1:legalAuthenticator/n1:assignedEntity" />
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
									<xsl:with-param name="asgnEntity"
										select="n1:dataEnterer/n1:assignedEntity" />
								</xsl:call-template>
							</td>
						</tr>
						<xsl:if
							test="n1:dataEnterer/n1:assignedEntity/n1:addr | n1:dataEnterer/n1:assignedEntity/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact"
											select="n1:dataEnterer/n1:assignedEntity" />
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
													<xsl:with-param name="id" select="n1:id" />
												</xsl:call-template>
											</td>
											<td>
												<label>
													<b>Encounter Type: </b>
												</label>
											</td>
											<td>
												<xsl:call-template name="show-code">
													<xsl:with-param name="code" select="n1:code" />
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
													<xsl:with-param name="id" select="n1:id" />
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
												<xsl:text>&#160;at&#160;</xsl:text>
												<xsl:call-template name="show-time">
													<xsl:with-param name="datetime" select="n1:effectiveTime" />
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="n1:effectiveTime/n1:low">
												<xsl:text>&#160;From&#160;</xsl:text>
												<xsl:call-template name="show-time">
													<xsl:with-param name="datetime"
														select="n1:effectiveTime/n1:low" />
												</xsl:call-template>
												<xsl:if test="n1:effectiveTime/n1:high">
													<xsl:text> to </xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime"
															select="n1:effectiveTime/n1:high" />
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
											<xsl:when
												test="n1:location/n1:healthCareFacility/n1:location/n1:name">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name"
														select="n1:location/n1:healthCareFacility/n1:location/n1:name" />
												</xsl:call-template>
												<xsl:for-each
													select="n1:location/n1:healthCareFacility/n1:serviceProviderOrganization/n1:name">
													<xsl:text> of </xsl:text>
													<xsl:call-template name="show-name">
														<xsl:with-param name="name"
															select="n1:location/n1:healthCareFacility/n1:serviceProviderOrganization/n1:name" />
													</xsl:call-template>
												</xsl:for-each>
											</xsl:when>
											<xsl:when test="n1:location/n1:healthCareFacility/n1:code">
												<xsl:call-template name="show-code">
													<xsl:with-param name="code"
														select="n1:location/n1:healthCareFacility/n1:code" />
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="n1:location/n1:healthCareFacility/n1:id">
													<xsl:text>id: </xsl:text>
													<xsl:for-each select="n1:location/n1:healthCareFacility/n1:id">
														<xsl:call-template name="show-id">
															<xsl:with-param name="id" select="." />
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
											<xsl:with-param name="asgnEntity"
												select="n1:responsibleParty/n1:assignedEntity" />
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
							<xsl:if
								test="n1:responsibleParty/n1:assignedEntity/n1:addr | n1:responsibleParty/n1:assignedEntity/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact"
												select="n1:responsibleParty/n1:assignedEntity" />
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
									<xsl:when
										test="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name">
										<xsl:call-template name="show-name">
											<xsl:with-param name="name"
												select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name" />
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each
											select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:id">
											<xsl:call-template name="show-id" />
											<xsl:if test="position()!=last()">
												<br />
											</xsl:if>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<xsl:if
							test="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:addr |             n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:telecom">
							<tr>
								<td>
									<label>
										<b>Contact info: </b>
									</label>
								</td>
								<td>
									<xsl:call-template name="show-contactInfo">
										<xsl:with-param name="contact"
											select="n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization" />
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
									<xsl:with-param name="clsCode"
										select="n1:serviceEvent/@classCode" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$displayName">
								<tr valign="top">
									<td>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="n1:serviceEvent/n1:code" />
										</xsl:call-template>
										<xsl:if test="n1:serviceEvent/n1:effectiveTime">
											<xsl:choose>
												<xsl:when test="n1:serviceEvent/n1:effectiveTime/@value">
													<xsl:text>&#160;at&#160;</xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime"
															select="n1:serviceEvent/n1:effectiveTime" />
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="n1:serviceEvent/n1:effectiveTime/n1:low">
													<xsl:text>&#160;from&#160;</xsl:text>
													<xsl:call-template name="show-time">
														<xsl:with-param name="datetime"
															select="n1:serviceEvent/n1:effectiveTime/n1:low" />
													</xsl:call-template>
													<xsl:if test="n1:serviceEvent/n1:effectiveTime/n1:high">
														<xsl:text> to </xsl:text>
														<xsl:call-template name="show-time">
															<xsl:with-param name="datetime"
																select="n1:serviceEvent/n1:effectiveTime/n1:high" />
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
									<xsl:value-of select="n1:functionCode/n1:originalText" />
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
											<xsl:with-param name="asgnEntity" select="n1:assignedEntity" />
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr valign="top">
								<th>
									<xsl:value-of select="$providerName" />
								</th>
								<th>
									<xsl:value-of select="$displayName" />
								</th>
								<th>
									<xsl:if test="not(n1:assignedEntity/n1:addr/@nullFlavor)">
										<xsl:call-template name="show-address">
											<xsl:with-param name="address"
												select="n1:assignedEntity/n1:addr" />
										</xsl:call-template>
									</xsl:if>
								</th>
								<th>
									<xsl:if test="not(n1:assignedEntity/n1:telecom/@nullFlavor)">
										<xsl:call-template name="show-telecom">
											<xsl:with-param name="telecom"
												select="n1:assignedEntity/n1:telecom" />
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
										<xsl:call-template name="show-id" />
									</xsl:for-each>
									<xsl:for-each select="n1:code">
										<xsl:text>&#160;</xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="." />
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="n1:priorityCode">
										<xsl:text>&#160;</xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="." />
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
											<xsl:with-param name="asgnEntity" select="n1:assignedEntity" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="n1:relatedEntity">
										<xsl:call-template name="show-relatedEntity">
											<xsl:with-param name="relatedEntity" select="n1:relatedEntity" />
										</xsl:call-template>
									</xsl:if>
								</td>
							</tr>
							<xsl:choose>
								<xsl:when
									test="n1:assignedEntity/n1:addr | n1:assignedEntity/n1:telecom">
									<tr>
										<td>
											<label>
												<b>Contact info: </b>
											</label>
										</td>
										<td>
											<xsl:if test="n1:assignedEntity">
												<xsl:call-template name="show-contactInfo">
													<xsl:with-param name="contact" select="n1:assignedEntity" />
												</xsl:call-template>
											</xsl:if>
										</td>
									</tr>
								</xsl:when>
								<xsl:when
									test="n1:relatedEntity/n1:addr | n1:relatedEntity/n1:telecom">
									<tr>
										<td>
											<label>
												<b>Contact info: </b>
											</label>
										</td>
										<td>
											<xsl:if test="n1:relatedEntity">
												<xsl:call-template name="show-contactInfo">
													<xsl:with-param name="contact" select="n1:relatedEntity" />
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
										<xsl:when
											test="n1:intendedRecipient/n1:informationRecipient/n1:name">
											<xsl:for-each select="n1:intendedRecipient/n1:informationRecipient">
												<xsl:call-template name="show-name">
													<xsl:with-param name="name" select="n1:name" />
												</xsl:call-template>
												<xsl:if test="position() != last()">
													<br />
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="n1:intendedRecipient">
												<xsl:for-each select="n1:id">
													<xsl:call-template name="show-id" />
												</xsl:for-each>
												<xsl:if test="position() != last()">
													<br />
												</xsl:if>
												<br />
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<xsl:if
								test="n1:intendedRecipient/n1:addr | n1:intendedRecipient/n1:telecom">
								<tr>
									<td>
										<label>
											<b>Contact info: </b>
										</label>
									</td>
									<td>
										<xsl:call-template name="show-contactInfo">
											<xsl:with-param name="contact" select="n1:intendedRecipient" />
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
						<xsl:with-param name="classCode"
							select="n1:associatedEntity/@classCode" />
						<xsl:with-param name="code" select="n1:associatedEntity/n1:code" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$participtRole">
						<xsl:call-template name="firstCharCaseUp">
							<xsl:with-param name="data" select="$participtRole" />
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
						<xsl:with-param name="code" select="n1:functionCode" />
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:call-template name="show-associatedEntity">
					<xsl:with-param name="assoEntity" select="n1:associatedEntity" />
				</xsl:call-template>
				<xsl:if
					test="n1:associatedEntity/n1:addr | n1:associatedEntity/n1:telecom">
					<xsl:call-template name="show-contactInfo">
						<xsl:with-param name="contact" select="n1:associatedEntity" />
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
										<xsl:with-param name="name" select="n1:patient/n1:name" />
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
										<xsl:with-param name="datetime" select="n1:patient/n1:birthTime" />
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
										<xsl:call-template name="show-gender" />
									</xsl:for-each>
								</td>
							</tr>
							<xsl:if
								test="n1:patient/n1:raceCode | (n1:patient/n1:ethnicGroupCode)">
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
													<xsl:call-template name="show-race-ethnicity" />
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
												<xsl:call-template name="show-race-ethnicity" />
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
										<xsl:with-param name="contact" select="." />
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
										<xsl:call-template name="show-id" />
										<br />
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
										<xsl:call-template name="show-id" />
										<br />
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
											<xsl:with-param name="code" select="n1:consent/n1:code" />
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code"
												select="n1:consent/n1:statusCode" />
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
								<br />
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
								<xsl:with-param name="id" select="n1:setId" />
							</xsl:call-template>
							<xsl:text>  Version: </xsl:text>
							<xsl:value-of select="n1:versionNumber/@value" />
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- show StructuredBody -->
	<xsl:template match="n1:component/n1:structuredBody">
		<xsl:for-each select=".">
			<xsl:call-template name="section-dynamic" />
		</xsl:for-each>
	</xsl:template>
	<!-- show nonXMLBody -->
	<xsl:template match='n1:component/n1:nonXMLBody'>
		<xsl:choose>
			<!-- if there is a reference, use that in an IFRAME -->
			<xsl:when test='n1:text/n1:reference'>
				<IFRAME name='nonXMLBody' id='nonXMLBody' WIDTH='80%' HEIGHT='600'
					src='{n1:text/n1:reference/@value}' />
			</xsl:when>
			<xsl:when test='n1:text/@mediaType="text/plain"'>
				<pre>
					<xsl:value-of select='n1:text/text()' />
				</pre>
			</xsl:when>
			<xsl:otherwise>
				<CENTER>Cannot display the text</CENTER>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Templates to act as lookup tables or maps for determining section headers and headings
		based upon LOINC codes -->
	<xsl:template name="getSectionHeaderText">
		<xsl:param name="loincCode" />
			<xsl:choose>
				<xsl:when test="$loincCode='42348-3'"><xsl:copy-of select="string('Advance Directives')"/></xsl:when>
				<xsl:when test="$loincCode='48765-2'"><xsl:copy-of select="string('Allergies')"/></xsl:when>
				<xsl:when test="$loincCode='59774-0'"><xsl:copy-of select="string('Anesthesia')"/></xsl:when>
				<xsl:when test="$loincCode='51848-0'"><xsl:copy-of select="string('Assessment ')"/></xsl:when>
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
				<xsl:when test="$loincCode='11504-8'"><xsl:copy-of select="string('Surgical Operation Note')"/></xsl:when>
				<xsl:when test="$loincCode='28570-0'"><xsl:copy-of select="string('Procedure Note')"/></xsl:when>
				<xsl:when test="$loincCode='34746-8'"><xsl:copy-of select="string('Nurses Note')"/></xsl:when>
				<xsl:when test="$loincCode='11506-3'"><xsl:copy-of select="string('Progress Notes')"/></xsl:when>
				<xsl:when test="$loincCode='34109-9'"><xsl:copy-of select="string('Miscellaneous Notes')"/></xsl:when>
			</xsl:choose>
	</xsl:template>


	<!-- DYNAMIC VERSION top level component/section: display title and text, and process any
		nested component/sections -->
	<xsl:template name="section-dynamic">
		<xsl:variable name="sections" select="n1:component/n1:section" />

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
					<xsl:variable name="currentSection"
						select="n1:text" />
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
                                        <!-- CCM-257 Make headers dynamic based on included <title> parameter. -->
                                                 <xsl:value-of select="n1:title" />
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
                                            <xsl:call-template name="getSectionHeaderText">
                                                    <xsl:with-param name="loincCode" select="$loincCode"/>
                                            </xsl:call-template>
                                            <xsl:value-of select="string('')" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="string-length($currentSection) &gt; 0">
							<!--<xsl:call-template name="section-title"> <xsl:with-param name="title"
								select="$headerValue"/> <xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="sectionCount" select="$sectionsCount"/> </xsl:call-template>
								<xsl:call-template name="section-author"> <xsl:with-param name="templateId"
								select="$templateId"/> </xsl:call-template> -->
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue" />
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
					<xsl:variable name="currentSection"
						select="n1:text" />
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="string('')" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="string-length($currentSection) &gt; 0">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue" />
										<!--<span class="count"><xsl:value-of select="$pos-int"/></span> -->
									</h2>

									No data provided for this section.
								</header>
							</section>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- top level component/section: display title and text, and process any
		nested component/sections -->
	<xsl:template name="section">
		<xsl:variable name="compTemplateIdRoots"
			select="n1:component/n1:section/n1:templateId/@root" />
		<xsl:variable name="sectionsCount" select="count(n1:component/n1:section)" />
		<xsl:variable name="sections" select="n1:component/n1:section" />

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
					<xsl:variable name="currentSection"
						select="n1:text" />
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$ccdSectionHeaderRefParam[$pos-int]" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when
							test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<!--<xsl:call-template name="section-title"> <xsl:with-param name="title"
								select="$headerValue"/> <xsl:with-param name="titleId" select="$headerHrefTitleId"/>
								<xsl:with-param name="sectionCount" select="$sectionsCount"/> </xsl:call-template>
								<xsl:call-template name="section-author"> <xsl:with-param name="templateId"
								select="$templateId"/> </xsl:call-template> -->
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue" />
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
						<xsl:value-of select="." />
					</xsl:variable>
					<xsl:variable name="pos-int" select="position()" />
					<xsl:variable name="currentSection"
						select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text" />
					<xsl:variable name="headerValue">
						<xsl:value-of select="$ccdAdditionalSectionHeaderParam[$pos-int]" />
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$ccdAdditionalSectionHeaderHrefParam[$pos-int]" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when
							test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
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
					<xsl:variable name="currentSection"
						select="n1:text" />
					<xsl:variable name="loincCode"><xsl:value-of select="n1:code/@code"/></xsl:variable>
					<xsl:variable name="headerValue">
						<xsl:call-template name="getSectionHeaderText">
							<xsl:with-param name="loincCode" select="$loincCode"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of select="$progSectionHeaderHrefParam[$pos-int]" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when
							test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<section id="{$headerValue}">
								<header>
									<h2>
										<xsl:value-of select="$headerValue" />
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
						<xsl:value-of select="." />
					</xsl:variable>
					<xsl:variable name="pos-int" select="position()" />
					<xsl:variable name="currentSection"
						select="$sections[n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]]/n1:text" />
					<xsl:variable name="headerValue">
						<xsl:value-of select="$progressAdditionalSectionHeaderParam[$pos-int]" />
					</xsl:variable>
					<xsl:variable name="headerHrefTitleId">
						<xsl:value-of
							select="$progressAdditionalSectionHeaderHrefParam[$pos-int]" />
					</xsl:variable>

					<xsl:choose>
						<xsl:when
							test="$compTemplateIdRoots  = $templateId or $compTemplateIdRoots  = concat($templateId,'.1')">
							<xsl:call-template name="section-text">
								<xsl:with-param name="title" select="$headerValue" />
								<xsl:with-param name="titleId" select="$headerHrefTitleId" />
								<xsl:with-param name="htmlText" select="$currentSection" />
								<xsl:with-param name="sectionPosition" select="$pos-int" />
							</xsl:call-template>
						</xsl:when>

					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- top level section title -->
	<xsl:template name="section-title">
		<xsl:param name="title" />
		<xsl:param name="titleId" />
		<xsl:param name="sectionCount" />

		<xsl:choose>
			<xsl:when test="$sectionCount &gt; 1">
				<h3>
					<a name="{$titleId}" href="#toc">
						<xsl:value-of select="$title" />
					</a>
				</h3>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:value-of select="$title" />
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- section author -->
	<xsl:template name="section-author">
		<xsl:param name="templateId" />

		<xsl:if
			test="count(n1:component/n1:section/n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]/*/n1:author)&gt;0">
			<div style="margin-left : 2em;">
				<b>
					<xsl:text>Section Author: </xsl:text>
				</b>
				<xsl:for-each
					select="n1:component/n1:section/n1:templateId[@root = $templateId or @root = concat($templateId,'.1')]/n1:author/n1:assignedAuthor">
					<xsl:choose>
						<xsl:when test="n1:assignedPerson/n1:name">
							<xsl:call-template name="show-name">
								<xsl:with-param name="name" select="n1:assignedPerson/n1:name" />
							</xsl:call-template>
							<xsl:if test="n1:representedOrganization">
								<xsl:text>, </xsl:text>
								<xsl:call-template name="show-name">
									<xsl:with-param name="name"
										select="n1:representedOrganization/n1:name" />
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:when test="n1:assignedAuthoringDevice/n1:softwareName">
							<xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="n1:id">
								<xsl:call-template name="show-id" />
								<br />
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<br />
			</div>
		</xsl:if>
	</xsl:template>
	<!-- top-level section Text -->
	<xsl:template name="section-text">
		<xsl:param name="htmlText" />
		<xsl:param name="title" />
		<xsl:param name="titleId" />
		<xsl:param name="sectionPosition" />

		<xsl:variable name="alpha" select="$htmlText" />

		<section id="{$titleId}">
			<header>
				<h2>
					<label id="plus.{$titleId}" onclick="javascript:toggle('open','{$titleId}')">[+]  </label>
					<label id="minus.{$titleId}" onclick="javascript:toggle('close','{$titleId}')">[-]  </label>

					<xsl:value-of select="$title" />
					<!--<span class="count"><xsl:value-of select="$sectionPosition"/></span> -->
				</h2>

				<xsl:choose>
					<xsl:when test="$htmlText[contains(., 'No Information')]">
						<xsl:text>No data provided for this section.</xsl:text>
					</xsl:when>
					<xsl:when test="count($htmlText/n1:table) &gt; 1">
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
					<xsl:apply-templates select="$htmlText" />
				</xsl:otherwise>
			</xsl:choose>
			</div>
		</section>
	</xsl:template>

	<!-- paragraph -->
	<xsl:template match="n1:paragraph">
		<p>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</p>
	</xsl:template>
	<!-- pre format -->
	<xsl:template match="n1:pre">
		<pre>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</pre>
	</xsl:template>
	<!-- Content w/ deleted text is hidden -->
	<xsl:template match="n1:content[@revised='delete']" />
	<!-- content -->
	<xsl:template match="n1:content">
		<span>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<!-- line break -->
	<xsl:template match="n1:br">
		<xsl:element name='br'>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<!-- underlining -->
	<xsl:template match="n1:u">
		<u>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</u>
	</xsl:template>

	<!-- list -->
	<xsl:template match="n1:list">
		<xsl:if test="n1:caption">
			<p>
				<xsl:copy-of select="@*" />
				<b>
					<xsl:apply-templates select="n1:caption" />
				</b>
			</p>
		</xsl:if>
		<ul>
			<xsl:copy-of select="@*" />
			<xsl:for-each select="n1:item">
				<li>
					<xsl:apply-templates />
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="n1:list[@listType='ordered']">
		<xsl:if test="n1:caption">
			<span style="font-weight:bold; ">
				<xsl:copy-of select="@*" />
				<xsl:apply-templates select="n1:caption" />
			</span>
		</xsl:if>
		<ol>
			<xsl:copy-of select="@*" />
			<xsl:for-each select="n1:item">
				<li>
					<xsl:apply-templates />
				</li>
			</xsl:for-each>
		</ol>
	</xsl:template>
	<!-- caption -->
	<xsl:template match="n1:caption">
		<xsl:apply-templates />
		<xsl:text>: </xsl:text>
	</xsl:template>
	<!-- Tables -->
	<xsl:template match="n1:table/@*|n1:thead/@*|n1:tfoot/@*|n1:tbody/@*|n1:colgroup/@*|n1:col/@*|n1:tr/@*|n1:th/@*|n1:td/@*">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="n1:table">
		<table class="narr_table">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</table>
	</xsl:template>
	<xsl:template match="n1:thead">
		<thead>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</thead>
	</xsl:template>
	<xsl:template match="n1:tfoot">
		<tfoot>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</tfoot>
	</xsl:template>
	<xsl:template match="n1:tbody">
		<tbody>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</tbody>
	</xsl:template>
	<xsl:template match="n1:colgroup">
		<colgroup>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</colgroup>
	</xsl:template>
	<xsl:template match="n1:col">
		<col>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</col>
	</xsl:template>
	<xsl:template match="n1:tr">
		<tr class="narr_tr">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</tr>
	</xsl:template>
	<xsl:template match="n1:th">
		<th class="narr_th">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</th>
	</xsl:template>
	<xsl:template match="n1:td">
		<td>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</td>
	</xsl:template>
	<xsl:template match="n1:table/n1:caption">
		<span style="font-weight:bold; ">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<!-- RenderMultiMedia this currently only handles GIF's and JPEG's. It could,
		however, be extended by including other image MIME types in the predicate
		and/or by generating <object> or <applet> tag with the correct params depending
		on the media type @ID =$imageRef referencedObject -->
	<xsl:template match="n1:renderMultiMedia">
		<xsl:variable name="imageRef" select="@referencedObject" />
		<xsl:choose>
			<xsl:when test="//n1:regionOfInterest[@ID=$imageRef]">
				<!-- Here is where the Region of Interest image referencing goes -->
				<xsl:if
					test="//n1:regionOfInterest[@ID=$imageRef]//n1:observationMedia/n1:value[@mediaType='image/gif' or @mediaType='image/jpeg']">
					<br clear="all" />
					<xsl:element name="img">
						<xsl:attribute name="src"><xsl:value-of
							select="//n1:regionOfInterest[@ID=$imageRef]//n1:observationMedia/n1:value/n1:reference/@value" /></xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Here is where the direct MultiMedia image referencing goes -->
				<xsl:if
					test="//n1:observationMedia[@ID=$imageRef]/n1:value[@mediaType='image/gif' or @mediaType='image/jpeg']">
					<br clear="all" />
					<xsl:element name="img">
						<xsl:attribute name="src"><xsl:value-of select="//n1:observationMedia[@ID=$imageRef]/n1:value/n1:reference/@value" /></xsl:attribute>
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
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<xsl:template match="n1:sub">
		<xsl:element name="sub">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<!-- show-signature -->
	<xsl:template name="show-sig">
		<xsl:param name="sig" />
		<xsl:choose>
			<xsl:when test="$sig/@code =&apos;S&apos;">
				<xsl:text>signed</xsl:text>
			</xsl:when>
			<xsl:when test="$sig/@code=&apos;I&apos;">
				<xsl:text>intended</xsl:text>
			</xsl:when>
			<xsl:when test="$sig/@code=&apos;X&apos;">
				<xsl:text>signature required</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show-id -->
	<xsl:template name="show-id">
		<xsl:param name="id" />
		<xsl:choose>
			<xsl:when test="not($id)">
				<xsl:if test="not(@nullFlavor)">
					<xsl:if test="@extension">
						<xsl:value-of select="@extension" />
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@root" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($id/@nullFlavor)">
					<xsl:if test="$id/@extension">
						<xsl:value-of select="$id/@extension" />
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$id/@root" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-name -->
	<xsl:template name="show-name">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="$name/n1:family">
				<xsl:if test="$name/n1:prefix">
					<xsl:value-of select="$name/n1:prefix" />
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$name/n1:given" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:family" />
				<xsl:if test="$name/n1:suffix">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$name/n1:suffix" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-gender -->
	<xsl:template name="show-gender">
		<xsl:choose>
			<xsl:when test="@code   = &apos;M&apos;">
				<xsl:text>Male</xsl:text>
			</xsl:when>
			<xsl:when test="@code  = &apos;F&apos;">
				<xsl:text>Female</xsl:text>
			</xsl:when>
			<xsl:when test="@code  = &apos;U&apos;">
				<xsl:text>Undifferentiated</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show-race -->
	<xsl:template name="show-race">
		<xsl:param name="raceCodeDisplay" />
		<xsl:param name="sdtc-raceCodeDisplay" />
		<xsl:param name="raceCodeText" />
		<xsl:param name="sdtc-raceCodeText" />
		<xsl:choose>
			<xsl:when test="$raceCodeDisplay and $sdtc-raceCodeDisplay">
				<xsl:value-of select="concat($raceCodeDisplay,', ',$sdtc-raceCodeDisplay)" />
			</xsl:when>
			<xsl:when test="$raceCodeText and $sdtc-raceCodeDisplay">
				<xsl:value-of select="concat($raceCodeText,', ',$sdtc-raceCodeDisplay)" />
			</xsl:when>
			<xsl:when test="$raceCodeDisplay and $sdtc-raceCodeText">
				<xsl:value-of select="concat($raceCodeDisplay,', ',$sdtc-raceCodeText)" />
			</xsl:when>
			<xsl:when test="$raceCodeText and $sdtc-raceCodeText">
				<xsl:value-of select="concat($raceCodeText,', ',$sdtc-raceCodeText)" />
			</xsl:when>
			<xsl:when test="$raceCodeDisplay">
				<xsl:value-of select="$raceCodeDisplay" />
			</xsl:when>
			<xsl:when test="$raceCodeText">
				<xsl:value-of select="$raceCodeText" />
			</xsl:when>
			<xsl:when test="$sdtc-raceCodeDisplay">
				<xsl:value-of select="$sdtc-raceCodeDisplay" />
			</xsl:when>
			<xsl:when test="sdtc-raceCodeText">
				<xsl:value-of select="sdtc-raceCodeText" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-race-ethnicity -->
	<xsl:template name="show-race-ethnicity">
		<xsl:choose>
			<xsl:when test="@displayName">
				<xsl:value-of select="@displayName" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show-contactInfo -->
	<xsl:template name="show-contactInfo">
		<xsl:param name="contact" />
		<xsl:call-template name="show-address">
			<xsl:with-param name="address" select="$contact/n1:addr" />
		</xsl:call-template>
		<xsl:call-template name="show-telecom">
			<xsl:with-param name="telecom" select="$contact/n1:telecom" />
		</xsl:call-template>
	</xsl:template>
	<!-- show-address -->
	<xsl:template name="show-address">
		<xsl:param name="address" />
		<xsl:choose>
			<xsl:when test="$address">
				<xsl:if test="$address/@use">
					<xsl:text> </xsl:text>
					<xsl:call-template name="translateTelecomCode">
						<xsl:with-param name="code" select="$address/@use" />
					</xsl:call-template>
					<xsl:text>:</xsl:text>
					<br />
				</xsl:if>
				<xsl:for-each select="$address/n1:streetAddressLine">
					<xsl:value-of select="." />
					<br />
				</xsl:for-each>
				<xsl:if test="$address/n1:streetName">
					<xsl:value-of select="$address/n1:streetName" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$address/n1:houseNumber" />
					<br />
				</xsl:if>
				<xsl:if test="string-length($address/n1:city)>0">
					<xsl:value-of select="$address/n1:city" />
				</xsl:if>
				<xsl:if test="string-length($address/n1:state)>0">
					<xsl:text>,&#160;</xsl:text>
					<xsl:value-of select="$address/n1:state" />
				</xsl:if>
				<xsl:if test="string-length($address/n1:postalCode)>0">
					<xsl:text>&#160;</xsl:text>
					<xsl:value-of select="$address/n1:postalCode" />
				</xsl:if>
				<xsl:if test="string-length($address/n1:country)>0">
					<xsl:text>,&#160;</xsl:text>
					<xsl:value-of select="$address/n1:country" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>address not available</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<br />
	</xsl:template>
	<!-- show-telecom -->
	<xsl:template name="show-telecom">
		<xsl:param name="telecom" />
		<xsl:choose>
			<xsl:when test="$telecom">
				<xsl:variable name="type"
					select="substring-before($telecom/@value, ':')" />
				<xsl:variable name="value"
					select="substring-after($telecom/@value, ':')" />
				<xsl:if test="$type">
					<xsl:call-template name="translateTelecomCode">
						<xsl:with-param name="code" select="$type" />
					</xsl:call-template>
					<xsl:if test="@use">
						<xsl:text> (</xsl:text>
						<xsl:call-template name="translateTelecomCode">
							<xsl:with-param name="code" select="@use" />
						</xsl:call-template>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$value" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Telecom information not available</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<br />
	</xsl:template>
	<!-- show-recipientType -->
	<xsl:template name="show-recipientType">
		<xsl:param name="typeCode" />
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
		<xsl:param name="code" />
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
				<xsl:value-of select="$code" />
				<xsl:text>'?}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- convert RoleClassAssociative code to display text -->
	<xsl:template name="showDisplayName">
		<xsl:param name="code" />

		<xsl:if
			test="($code/@code) and ($code/@codeSystem='2.16.840.1.113883.5.111') and ($code/@displayName)">
			<xsl:text> (</xsl:text>
			<xsl:value-of select="$code/@displayName" />
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="translateRoleAssoCode">
		<xsl:param name="classCode" />
		<xsl:param name="code" />
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
				<xsl:value-of select="$classCode" />
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
		<xsl:param name="datetime" />
		<xsl:choose>
			<xsl:when test="not($datetime)">
				<xsl:call-template name="formatDateTime">
					<xsl:with-param name="date" select="@value" />
				</xsl:call-template>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDateTime">
					<xsl:with-param name="date" select="$datetime/@value" />
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
							<xsl:when
								test="count(/n1:ClinicalDocument/n1:participant
                                      [@typeCode='LOC'][@contextControlCode='OP']
                                      /n1:associatedEntity[@classCode='SDLOC']/n1:id)&gt;0">
								<!-- change context node -->
								<xsl:for-each
									select="/n1:ClinicalDocument/n1:participant
                                      [@typeCode='LOC'][@contextControlCode='OP']
                                      /n1:associatedEntity[@classCode='SDLOC']/n1:id">
									<xsl:call-template name="show-id" />
									<!-- change context node again, for the code -->
									<xsl:for-each select="../n1:code">
										<xsl:text> (</xsl:text>
										<xsl:call-template name="show-code">
											<xsl:with-param name="code" select="." />
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
							<xsl:with-param name="datetime"
								select="/n1:ClinicalDocument/n1:documentationOf
                                      /n1:serviceEvent/n1:effectiveTime/n1:low" />
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
							<xsl:with-param name="datetime"
								select="/n1:ClinicalDocument/n1:documentationOf
                                      /n1:serviceEvent/n1:effectiveTime/n1:high" />
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!-- show assignedEntity -->
	<xsl:template name="show-assignedEntity">
		<xsl:param name="asgnEntity" />
		<xsl:choose>
			<xsl:when test="$asgnEntity/n1:assignedPerson/n1:name">
				<xsl:call-template name="show-name">
					<xsl:with-param name="name"
						select="$asgnEntity/n1:assignedPerson/n1:name" />
				</xsl:call-template>
				<xsl:if test="$asgnEntity/n1:representedOrganization/n1:name">
					<xsl:text> of </xsl:text>
					<xsl:value-of select="$asgnEntity/n1:representedOrganization/n1:name" />
				</xsl:if>
			</xsl:when>
			<xsl:when test="$asgnEntity/n1:representedOrganization">
				<xsl:value-of select="$asgnEntity/n1:representedOrganization/n1:name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$asgnEntity/n1:id">
					<xsl:call-template name="show-id" />
					<xsl:choose>
						<xsl:when test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<br />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show relatedEntity -->
	<xsl:template name="show-relatedEntity">
		<xsl:param name="relatedEntity" />
		<xsl:choose>
			<xsl:when test="$relatedEntity/n1:relatedPerson/n1:name">
				<xsl:call-template name="show-name">
					<xsl:with-param name="name"
						select="$relatedEntity/n1:relatedPerson/n1:name" />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show associatedEntity -->
	<xsl:template name="show-associatedEntity">
		<xsl:param name="assoEntity" />
		<xsl:choose>
			<xsl:when test="$assoEntity/n1:associatedPerson">
				<xsl:for-each select="$assoEntity/n1:associatedPerson/n1:name">
					<xsl:call-template name="show-name">
						<xsl:with-param name="name" select="." />
					</xsl:call-template>
					<xsl:call-template name="showDisplayName">
						<xsl:with-param name="code" select="$assoEntity/n1:code" />
					</xsl:call-template>
					<br />
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:scopingOrganization">
				<xsl:for-each select="$assoEntity/n1:scopingOrganization">
					<xsl:if test="n1:name">
						<xsl:call-template name="show-name">
							<xsl:with-param name="name" select="n1:name" />
						</xsl:call-template>
						<br />
					</xsl:if>
					<xsl:if test="n1:standardIndustryClassCode">
						<xsl:value-of select="n1:standardIndustryClassCode/@displayName" />
						<xsl:text> code:</xsl:text>
						<xsl:value-of select="n1:standardIndustryClassCode/@code" />
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:code">
				<xsl:call-template name="show-code">
					<xsl:with-param name="code" select="$assoEntity/n1:code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$assoEntity/n1:id">
				<xsl:value-of select="$assoEntity/n1:id/@extension" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="$assoEntity/n1:id/@root" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- show code if originalText present, return it, otherwise, check and
		return attribute: display name -->
	<xsl:template name="show-code">
		<xsl:param name="code" />
		<xsl:variable name="this-codeSystem">
			<xsl:value-of select="$code/@codeSystem" />
		</xsl:variable>
		<xsl:variable name="this-code">
			<xsl:value-of select="$code/@code" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$code/n1:originalText">
				<xsl:value-of select="$code/n1:originalText" />
			</xsl:when>
			<xsl:when test="$code/@displayName">
				<xsl:value-of select="$code/@displayName" />
			</xsl:when>
			<!-- <xsl:when test="$the-valuesets/*/voc:system[@root=$this-codeSystem]/voc:code[@value=$this-code]/@displayName">
				<xsl:value-of select="$the-valuesets/*/voc:system[@root=$this-codeSystem]/voc:code[@value=$this-code]/@displayName"/>
				</xsl:when> -->
			<xsl:otherwise>
				<xsl:value-of select="$this-code" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- show classCode -->
	<xsl:template name="show-actClassCode">
		<xsl:param name="clsCode" />
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
		<xsl:param name="ptype" />
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
		<xsl:param name="pFunction" />
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
		<xsl:param name="date" />
		<!-- month -->
		<xsl:variable name="month" select="substring ($date, 5, 2)" />
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
			<xsl:when test='substring ($date, 7, 1)="0"'>
				<xsl:value-of select="substring ($date, 8, 1)" />
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring ($date, 7, 2)" />
				<xsl:text>, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!-- year -->
		<xsl:value-of select="substring ($date, 1, 4)" />
		<!-- time and US timezone -->
		<xsl:if test="string-length($date) > 8">
			<xsl:text>, </xsl:text>
			<!-- time -->
			<xsl:variable name="time">
				<xsl:value-of select="substring($date,9,6)" />
			</xsl:variable>
			<xsl:variable name="hh">
				<xsl:value-of select="substring($time,1,2)" />
			</xsl:variable>
			<xsl:variable name="mm">
				<xsl:value-of select="substring($time,3,2)" />
			</xsl:variable>
			<xsl:variable name="ss">
				<xsl:value-of select="substring($time,5,2)" />
			</xsl:variable>
			<xsl:if test="string-length($hh)&gt;1">
				<xsl:value-of select="$hh" />
				<xsl:if
					test="string-length($mm)&gt;1 and not(contains($mm,'-')) and not (contains($mm,'+'))">
					<xsl:text>:</xsl:text>
					<xsl:value-of select="$mm" />
					<xsl:if
						test="string-length($ss)&gt;1 and not(contains($ss,'-')) and not (contains($ss,'+'))">
						<xsl:text>:</xsl:text>
						<xsl:value-of select="$ss" />
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!-- time zone -->
			<xsl:variable name="tzon">
				<xsl:choose>
					<xsl:when test="contains($date,'+')">
						<xsl:text>+</xsl:text>
						<xsl:value-of select="substring-after($date, '+')" />
					</xsl:when>
					<xsl:when test="contains($date,'-')">
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring-after($date, '-')" />
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
					<xsl:value-of select="$tzon" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- convert to lower case -->
	<xsl:template name="caseDown">
		<xsl:param name="data" />
		<xsl:if test="$data">
			<xsl:value-of
				select="translate($data, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
		</xsl:if>
	</xsl:template>
	<!-- convert to upper case -->
	<xsl:template name="caseUp">
		<xsl:param name="data" />
		<xsl:if test="$data">
			<xsl:value-of
				select="translate($data,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
		</xsl:if>
	</xsl:template>
	<!-- convert first character to upper case -->
	<xsl:template name="firstCharCaseUp">
		<xsl:param name="data" />
		<xsl:if test="$data">
			<xsl:call-template name="caseUp">
				<xsl:with-param name="data" select="substring($data,1,1)" />
			</xsl:call-template>
			<xsl:value-of select="substring($data,2)" />
		</xsl:if>
	</xsl:template>
	<!-- show-noneFlavor -->
	<xsl:template name="show-noneFlavor">
		<xsl:param name="nf" />
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
        <xsl:param name="langDisplay" />
        <xsl:param name="modeCode" />
		<xsl:choose>
			<xsl:when test="$modeCode = 'ESGN'">
				<xsl:text>Signs </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
			<xsl:when test="$modeCode = 'ESP'">
				<xsl:text>Speaks </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
			<xsl:when test="$modeCode = 'EWR'">
				<xsl:text>Writes </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
			<xsl:when test="$modeCode = 'RSGN'">
				<xsl:text>Understands signed </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
			<xsl:when test="$modeCode = 'RSP'">
				<xsl:text>Understands spoken </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
			<xsl:when test="$modeCode = 'RWR'">
				<xsl:text>Understands written </xsl:text>
				<xsl:value-of select="$langDisplay" />
			</xsl:when>
		</xsl:choose>
    </xsl:template>
	<xsl:template name="show-language">
		<xsl:param name="langCode" />
		<xsl:param name="modeCode" />
		<xsl:choose>
			<xsl:when test="$langCode/@code = 'sq' or $langCode/@code = 'sqi' or $langCode/@code = 'alb'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Albanian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'apa'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Apache languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ar' or $langCode/@code = 'ara' or $langCode/@code = 'ar-AE' or $langCode/@code = 'ar-SA' or $langCode/@code = 'ar-MA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Arabic'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'hy' or $langCode/@code = 'hye' or $langCode/@code = 'arm'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Armenian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'aus'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Australian languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'bs' or $langCode/@code = 'bos'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bosnian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'bg' or $langCode/@code = 'bul'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bulgarian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'bg' or $langCode/@code = 'bul'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Bulgarian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ce' or $langCode/@code = 'che'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chechen'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ce' or $langCode/@code = 'che'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chechen'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'zh' or $langCode/@code = 'zho' or $langCode/@code = 'chi'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Chinese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'chr'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Cherokee'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'chy'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Cheyenne'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'cs' or $langCode/@code = 'ces' or $langCode/@code = 'cze'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Czech'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'da' or $langCode/@code = 'dan'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Danish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'nl' or $langCode/@code = 'nld' or $langCode/@code = 'dut'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Dutch; Flemish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'egy'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Egyptian (Ancient)'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'en' or $langCode/@code = 'eng' or $langCode/@code = 'en-US' or $langCode/@code = 'en-GB' or $langCode/@code = 'en-CA'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'English'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'et' or $langCode/@code = 'est'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Estonian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'fil'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Filipino; Pilipino'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'fi' or $langCode/@code = 'fin'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Finnish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'fr' or $langCode/@code = 'fra' or $langCode/@code = 'fre' or $langCode/@code = 'fr-CA' or $langCode/@code = 'fr-FR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'French'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'de' or $langCode/@code = 'deu' or $langCode/@code = 'ger'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'German'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ga' or $langCode/@code = 'gle'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Irish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'gl' or $langCode/@code = 'glg'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Galician'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'el' or $langCode/@code = 'ell' or $langCode/@code = 'gre'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Greek, Modern (1453-)'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ht' or $langCode/@code = 'hat'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Haitian; Haitian Creole'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'haw'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hawaiian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'he' or $langCode/@code = 'heb'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hebrew'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'hi' or $langCode/@code = 'hin'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hindi'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'hr' or $langCode/@code = 'hrv'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Croatian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'hu' or $langCode/@code = 'hun'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Hungarian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'is' or $langCode/@code = 'isl' or $langCode/@code = 'ice'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Icelandic'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'id' or $langCode/@code = 'ind'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Indonesian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'id' or $langCode/@code = 'ind'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Indonesian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ira'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Iranian languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'it' or $langCode/@code = 'ita'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Italian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ja' or $langCode/@code = 'jpn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Japanese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ko' or $langCode/@code = 'kor'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Korean'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'la' or $langCode/@code = 'lat'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Latin'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'lv' or $langCode/@code = 'lav'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Latvian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'lb' or $langCode/@code = 'ltz'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Luxembourgish; Letzeburgesch'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'mk' or $langCode/@code = 'mkd' or $langCode/@code = 'mac'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Macedonian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'mt' or $langCode/@code = 'mlt'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Maltese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'mt' or $langCode/@code = 'mlt'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Maltese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'mnc'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Manchu'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'moh'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mohawk'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'mn' or $langCode/@code = 'mon'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mongolian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'myn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Mayan languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'nai'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'North American Indian languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'nn' or $langCode/@code = 'nno'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Norwegian Nynorsk; Nynorsk, Norwegian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'no' or $langCode/@code = 'nor'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Norwegian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ota'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Turkish, Ottoman (1500-1928)'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'fa' or $langCode/@code = 'fas' or $langCode/@code = 'per'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Persian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'phi'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Persian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'pl' or $langCode/@code = 'pol'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Polish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'pl' or $langCode/@code = 'pol'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Polish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'pt' or $langCode/@code = 'por'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Portuguese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ru' or $langCode/@code = 'rus'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Russian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sai'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'South American Indian (Other)'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sa' or $langCode/@code = 'san'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sanskrit'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'scn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sicilian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'scn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sicilian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sgn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sign Languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sgn'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Sign Languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sla'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slavic languages'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sk' or $langCode/@code = 'slk' or $langCode/@code = 'slo'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slovak'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sk' or $langCode/@code = 'slk' or $langCode/@code = 'slo'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slovak'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sl' or $langCode/@code = 'slv'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Slovenian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sm' or $langCode/@code = 'smo'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Samoan'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'so' or $langCode/@code = 'som'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Somali'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'es' or $langCode/@code = 'spa' or $langCode/@code = 'es-ES' or $langCode/@code = 'es-MX' or $langCode/@code = 'es-PR' or $langCode/@code = 'es-AR'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Somali'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sr' or $langCode/@code = 'srp'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Serbian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'sv' or $langCode/@code = 'swe'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Swedish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'ty' or $langCode/@code = 'tah'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Tahitian'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'th' or $langCode/@code = 'tha'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Thai'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'bo' or $langCode/@code = 'bod' or $langCode/@code = 'tib'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Tibetan'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'tr' or $langCode/@code = 'tur'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Turkish'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'vi' or $langCode/@code = 'vie'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Vietnamese'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$langCode/@code = 'cy' or $langCode/@code = 'cym' or $langCode/@code = 'wel'">
				<xsl:call-template name="show-language-with-mode">
					<xsl:with-param name="langDisplay" select="'Welsh'" />
					<xsl:with-param name="modeCode" select="$modeCode/@code" />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="pref-language">
		<xsl:param name="langCode" />
		<xsl:param name="prefLang" />
		<xsl:param name="modeCode" />
		<xsl:choose>
			<xsl:when test="$prefLang/@value='true'">
				<xsl:call-template name="show-language">
					<xsl:with-param name="langCode" select="$langCode" />
					<xsl:with-param name="modeCode" select="$modeCode" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Add spaces in the view of notes. -->
	<xsl:template match="n1:table/n1:tbody/n1:tr/n1:td/n1:content"
		name="insertBreaks">
		<xsl:param name="pText" select="." />
		<xsl:choose>
			<xsl:when test="not(contains($pText, '&#xA;'))  or not($isVA)">
				<xsl:copy-of select="$pText" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($pText, '&#xA;')" />
				<br />
				<xsl:call-template name="insertBreaks">
					<xsl:with-param name="pText"
						select="substring-after($pText, '&#xA;')" />
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

