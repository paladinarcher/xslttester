<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:isc="http://extension-functions.intersystems.com" 
		xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">
<root>
<xsl:apply-templates select="//rim:ExtrinsicObject"/>
</root>
</xsl:template>

<xsl:template match="rim:ExtrinsicObject">
<DocumentCache>
<UUID><xsl:value-of select="substring(@id,10)"/></UUID>
<UniqueId><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/></UniqueId>
<PatientId><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427']/@value"/></PatientId>
<HomeCommunityId><xsl:value-of select="@home"/></HomeCommunityId>
<MimeType><xsl:value-of select="@mimeType"/></MimeType>
<RepositoryUniqueId><xsl:value-of select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value/text()"/></RepositoryUniqueId>
<FormatCode><xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']/@nodeRepresentation"/></FormatCode>
<FormatScheme><xsl:value-of select="rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']/rim:Slot/rim:ValueList/rim:Value/text()"/></FormatScheme>
<Metadata><xsl:copy-of select="."/></Metadata>
<SourcePatientId><xsl:value-of select="rim:Slot[@name='sourcePatientId']/rim:ValueList/rim:Value/text()"/></SourcePatientId>
</DocumentCache>
</xsl:template>
</xsl:stylesheet>
