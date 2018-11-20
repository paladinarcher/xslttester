<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:isc="http://extension-functions.intersystems.com" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
    xmlns="urn:ihe:iti:xds-b:2007"
    exclude-result-prefixes="isc rim">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/Documents">
<RetrieveDocumentSetRequest>
<xsl:apply-templates select="rim:ExtrinsicObject"/>
</RetrieveDocumentSetRequest>
</xsl:template>

<xsl:template match="rim:ExtrinsicObject">
<DocumentRequest>
<xsl:variable name="uniqueId" select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/>
<xsl:variable name="repoId" select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value/text()"/>
<xsl:variable name="home" select="@home"/>

<xsl:if test="string-length($home) > 0">
<HomeCommunityId><xsl:value-of select="$home"/></HomeCommunityId>
</xsl:if>
<RepositoryUniqueId><xsl:value-of select="$repoId"/></RepositoryUniqueId>
<DocumentUniqueId><xsl:value-of select="$uniqueId"/></DocumentUniqueId>
</DocumentRequest>
</xsl:template>
</xsl:stylesheet>
