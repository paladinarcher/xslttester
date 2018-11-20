<?xml version="1.0" encoding="UTF-8"?>
<!-- 
DSUB Subscribe Audit Message (ITI-54) publisher 
-->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:exsl="http://exslt.org/common"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:hl7="urn:hl7-org:v3"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:xdsb="urn:ihe:iti:xds-b:2007" 
xmlns:xop="http://www.w3.org/2004/08/xop/include" 
xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
exclude-result-prefixes="isc exsl hl7 lcm query rim rs xdsb xop xsi wsnt">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>
<xsl:include href="Base.xsl"/>

<!-- Globals used by the base stylesheet -->
<xsl:variable name="eventType" select="'ITI-54,IHE Transactions,Document Metadata Publish'"/>
<xsl:variable name="isSource"  select="($actor='DocumentMetadataPublisher')"/>
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

<!-- audit by publisher process -->
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

<!-- audit by notification broker (from publisher) also audits from registry directly as if it is a publisher -->
<xsl:for-each select="/Root/Request/ContentStream/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject">
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

</Aggregation>
</xsl:template>

</xsl:stylesheet>
