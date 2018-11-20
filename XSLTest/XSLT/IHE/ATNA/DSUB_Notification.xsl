<?xml version="1.0" encoding="UTF-8"?>
<!-- 
DSUB Subscribe Audit Message (ITI-53) notification  
-->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:exsl="http://exslt.org/common"
xmlns:hl7="urn:hl7-org:v3"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:xdsb="urn:ihe:iti:xds-b:2007" 
xmlns:xop="http://www.w3.org/2004/08/xop/include" 
xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
xmlns:wsa="http://www.w3.org/2005/08/addressing"
exclude-result-prefixes="isc exsl hl7 lcm query rim rs xdsb xop xsi wsnt wsa">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>
<xsl:include href="Base.xsl"/>

<!-- Globals used by the base stylesheet -->
<xsl:variable name="eventType" select="'ITI-53,IHE Transactions,Document Metadata Notify'"/>
<xsl:variable name="isSource"  select="($actor='DocumentMetadataNotificationBroker')"/>
<xsl:variable name="status" select="'AA'"/>

<xsl:template match="/Root">
<xsl:variable name="patientSelect" select="Request/AdditionalInfo"/>
<xsl:variable name="eventID">
<xsl:choose>
<xsl:when test="$isSource">110106,DCM,Export</xsl:when>
<xsl:otherwise>110107,DCM,Import</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<Aggregation>

<xsl:call-template name="Event">
<xsl:with-param name="EventID" select="$eventID"/>
<xsl:with-param name="EventActionCode">
<xsl:choose>
<xsl:when test="$isSource">R</xsl:when>
<xsl:otherwise>C</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="Source"/>
<xsl:call-template name="HumanRequestor"/>
<xsl:call-template name="Destination"/>
<xsl:call-template name="AuditSource"/>

<xsl:apply-templates mode="Patient" select="$patientSelect"/>

<!-- Document full entry or simple-->
<xsl:choose>
<!-- full notification type -->
<xsl:when test="substring-after(/Root/Request/ContentStream/wsnt:Notify/wsnt:NotificationMessage/wsnt:Topic,':')!='FullDocumentEntry'">
<xsl:for-each select="/Root/Request/ContentStream/wsnt:Notify/wsnt:NotificationMessage/wsnt:Message/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject">
<xsl:call-template name="Document">
<xsl:with-param name="DocumentID" select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/>
<xsl:with-param name="RepositoryID" select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value/text()"/>
<xsl:with-param name="HomeCommunityID">
	<xsl:choose>
		<xsl:when test="@home">
			<xsl:value-of select="@home"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$homeCommunityOID"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<!-- minimal notification type -->
<xsl:for-each select="/Root/Request/ContentStream/wsnt:Notify/wsnt:NotificationMessage/wsnt:Message/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject">
<xsl:call-template name="Document">
<xsl:with-param name="DocumentID" select="xdsb:DocumentUniqueId/text()"/>
<xsl:with-param name="RepositoryID" select="xdsb:RepositoryUniqueId/text()"/>
<xsl:with-param name="HomeCommunityID">
	<xsl:choose>
		<xsl:when test="xdsb:HomeCommunityId">
			<xsl:value-of select="xdsb:HomeCommunityId"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$homeCommunityOID"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</Aggregation>
</xsl:template>

</xsl:stylesheet>
