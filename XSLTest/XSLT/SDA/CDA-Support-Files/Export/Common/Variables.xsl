<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<!-- Parameter accepted from HS.UI.Push.SendMessage.  Currently used for "Reason for Referral" only. -->
	<!-- Parameter re-cast to match case-sentisitivity conventions of the existing XSL. -->
	<xsl:param name="EventReason"/>
	<xsl:param name="eventReason" select="$EventReason"/> 

	<!-- Global variable to hold the current date/time -->
	<xsl:variable name="currentDateTime" select="isc:evaluate('timestamp')"/>
	
	<!-- Global variable to hold the configuration found in the site's export profile -->
	<xsl:variable name="exportConfiguration" select="document('../../Site/ExportProfile.xml')/exportConfiguration"/>
		
	<!-- Global variables to hold the code and OID for ISC "no code system" -->
	<xsl:variable name="noCodeSystemName">ISC-NoCodeSystem</xsl:variable>
	<xsl:variable name="noCodeSystemOID" select="isc:evaluate('getOIDForCode', $noCodeSystemName, 'CodeSystem')"/>
	
	<!-- Global variables to hold the code and OID for SNOMED -->
	<xsl:variable name="snomedOID">2.16.840.1.113883.6.96</xsl:variable>
	<xsl:variable name="snomedName" select="isc:evaluate('getCodeForOID', $snomedOID, 'CodeSystem')"/>
</xsl:stylesheet>
