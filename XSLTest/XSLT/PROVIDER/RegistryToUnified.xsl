<?xml version="1.0"?>
<!-- Copy registry information into HSPD Unified for sending to SOAP -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" exclude-result-prefixes="isc" version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:variable name="IndividualRegistryID" select="/Unified/Individual/RegistryID"/>
<xsl:variable name="OrganizationRegistryID" select="/Unified/Organization/RegistryID"/>

<!-- default verbatim copy -->
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates/>
</xsl:copy>
</xsl:template>

<!-- include the source in the datagram -->
<xsl:template match="/">
<Unified>
<_sourceName>HSREGISTRY</_sourceName>
<xsl:apply-templates select="Unified"/>
</Unified>
</xsl:template>

<!-- add the individual/org and location(s) -->
<xsl:template match="Unified">
<xsl:apply-templates select="Individual|Organziation"/>
</xsl:template>

<xsl:template match="Individual">
<Providers>
<Individual>
<xsl:apply-templates />
<xsl:apply-templates select="../Locations"/>
</Individual>
</Providers>
</xsl:template>

<xsl:template match="Organziation">
<Providers>
<Organization>
<xsl:apply-templates />
<xsl:apply-templates select="../Locations"/>
</Organization>
</Providers>
</xsl:template>

<xsl:template match="Locations">
<Locations>
<xsl:apply-templates />
</Locations>
</xsl:template>

<xsl:template match="Location">
<xsl:variable name="pos" select="position()"/>
<LocationSerial>
<xsl:apply-templates />
<xsl:if test="string-length($IndividualRegistryID)>0">
<IndividualID><xsl:value-of select="$IndividualRegistryID"/></IndividualID>
</xsl:if>
<xsl:if test="string-length($OrganizationRegistryID)>0">
<OrganizationID><xsl:value-of select="$OrganizationRegistryID"/></OrganizationID>
</xsl:if>
<xsl:apply-templates select="/Unified/Addresses/Address[$pos]"/>
</LocationSerial>
</xsl:template>

<!-- Rename RegistryID to SourceID -->
<xsl:template match="RegistryID">
<SourceID><xsl:value-of select="text()"/></SourceID>
</xsl:template>	

<!-- Put code mappings into @Code and specify the scheme -->
<xsl:template match="node()[contains(local-name(),'CodedValue')]">
<xsl:element name="{local-name()}">
<xsl:choose>
<xsl:when test="Code">
<xsl:for-each select="Code">
<CodeItem Code="{text()}" Scheme="HSREGISTRY"/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="Code"><xsl:value-of select="text()"/></xsl:attribute>
<xsl:attribute name="Scheme">HSREGISTRY</xsl:attribute>
</xsl:otherwise>
</xsl:choose>
</xsl:element>
</xsl:template>

<xsl:template match="_Active|_LastSync|_NextSync|_AddressID|_Domains|_LookupKeys|EnterpriseID|SourceKeys|IndividualEID|OrganizationEID|AddressEID"/>
</xsl:stylesheet>