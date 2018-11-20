<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="isc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:ihe="urn:ihe:iti:xds-b:2007" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/ihe:RetrieveDocumentSetRequest">
<Messages>
<xsl:for-each select="ihe:DocumentRequest">
<XMLMessage>
<Name>XDSb_RetrieveRequest</Name> 
<ContentStream>
<RetrieveDocumentSetRequest xmlns="urn:ihe:iti:xds-b:2007">
<DocumentRequest>
<HomeCommunityId><xsl:value-of select="ihe:HomeCommunityId/text()"/></HomeCommunityId>
<RepositoryUniqueId><xsl:value-of select="ihe:RepositoryUniqueId/text()"/></RepositoryUniqueId> 
<DocumentUniqueId><xsl:value-of select="ihe:DocumentUniqueId/text()"/></DocumentUniqueId> 
</DocumentRequest>
</RetrieveDocumentSetRequest>
</ContentStream>
</XMLMessage>
</xsl:for-each>
</Messages>
</xsl:template>
</xsl:stylesheet>
