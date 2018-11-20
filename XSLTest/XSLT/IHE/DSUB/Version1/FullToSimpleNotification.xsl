<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:ihe="urn:ihe:iti:xds-b:2007" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
xmlns:a="http://www.w3.org/2005/08/addressing"
exclude-result-prefixes="lcm query rim rs wsnt a"
>
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">
<ihe:RetrieveDocumentSetRequest>
<xsl:for-each select='/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject'>
<ihe:DocumentRequest>
<xsl:if test='@home'>
<ihe:HomeCommunityId><xsl:value-of select="@home"/></ihe:HomeCommunityId>
</xsl:if>
<ihe:RepositoryUniqueId><xsl:value-of select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value"/></ihe:RepositoryUniqueId>
<ihe:DocumentUniqueId><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/></ihe:DocumentUniqueId>
</ihe:DocumentRequest>
</xsl:for-each>
</ihe:RetrieveDocumentSetRequest>
</xsl:template>

</xsl:stylesheet>
