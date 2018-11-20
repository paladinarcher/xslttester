<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="isc xsi" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	
	<xsl:param name="patientGlobalAssigningAuthority"/>
	<xsl:param name="patientGlobalID"/>
	<xsl:param name="repositoryOID"/>
	
	<xsl:template match="//@* | //node()">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
    <!-- Handle cases when SDA does not have an MRN.  Assumes either PatientNumber list is missing or has a 'MRN' entry -->
    <xsl:template match="/Container/Patient">
        <xsl:apply-templates select="@*"/>
        <xsl:copy>
            <xsl:if test="not(PatientNumbers)">
                <PatientNumbers>
                    <PatientNumber>
                    <NumberType>MRN</NumberType>
                    <Number><xsl:value-of select="$patientGlobalID"/></Number>
                    <Organization>
                        <Code><xsl:value-of select="isc:evaluate('getCodeForOID', $patientGlobalAssigningAuthority, 'AssigningAuthority')"/></Code>
                        <Description><xsl:value-of select="isc:evaluate('getDescriptionForOID', $patientGlobalAssigningAuthority, 'AssigningAuthority')"/></Description>
                    </Organization>
                   </PatientNumber>
                </PatientNumbers>
            </xsl:if>
    
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/Container/Patient/PatientNumbers/PatientNumber[NumberType='MRN']/Number">
        <xsl:apply-templates select="@*"/>
        <xsl:copy>
            <xsl:value-of select="$patientGlobalID"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/Container/Patient/PatientNumbers/PatientNumber[NumberType='MRN']/Organization/Code">
        <xsl:apply-templates select="@*"/>
        <xsl:copy>
            <xsl:value-of select="isc:evaluate('getCodeForOID', $patientGlobalAssigningAuthority, 'AssigningAuthority')"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/Container/Patient/PatientNumbers/PatientNumber[NumberType='MRN']/Organization/Description">
        <xsl:apply-templates select="@*"/>
        <xsl:copy>
            <xsl:value-of select="isc:evaluate('getDescriptionForOID', $patientGlobalAssigningAuthority, 'AssigningAuthority')"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
