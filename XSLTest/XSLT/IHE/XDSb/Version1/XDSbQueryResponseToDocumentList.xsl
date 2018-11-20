<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xdsb="urn:ihe:iti:xds-b:2007"
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
version="1.0"  exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
<QueryResponse>
<Documents>
<xsl:for-each select="query:AdhocQueryResponse/rim:RegistryObjectList/rim:ExtrinsicObject">
<RetrieveItem id="{@id}" home="{@home}">
<xsl:if test="@home!=''"><HomeCommunityId><xsl:value-of select="@home"/></HomeCommunityId></xsl:if>
<RepositoryUniqueId><xsl:value-of select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value/text()"/></RepositoryUniqueId> 
<UniqueId><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/></UniqueId> 
</RetrieveItem>
</xsl:for-each>
</Documents>
</QueryResponse>

</xsl:template>

</xsl:stylesheet>
