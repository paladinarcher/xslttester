<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:isc="http://extension-functions.intersystems.com" 
		xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
		xmlns:xdsb="urn:ihe:iti:xds-b:2007"
		xmlns:xop="http://www.w3.org/2004/08/xop/include"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="isc">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- If the request was for a single, specific UUID then the response can be cached -->
<xsl:param name="documentUUID"/>

<xsl:template match="/XMLMessage">
<root>
<xsl:apply-templates select="ContentStream/xdsb:RetrieveDocumentSetResponse/xdsb:DocumentResponse"/>
</root>
</xsl:template>

<xsl:template match="xdsb:DocumentResponse">
<DocumentCache>
<xsl:if test="$documentUUID">
<UUID><xsl:value-of select="$documentUUID"/></UUID>
</xsl:if>
<UniqueId><xsl:value-of select="xdsb:DocumentUniqueId/text()"/></UniqueId>
<RepositoryUniqueId><xsl:value-of select="xdsb:RepositoryUniqueId/text()"/></RepositoryUniqueId>
<MimeType><xsl:value-of select="xdsb:mimeType/text()"/></MimeType>

<!-- HomeCommunityId may not be present -->
<xsl:if test="xdsb:HomeCommunityId">
<HomeCommunityId><xsl:value-of select="xdsb:HomeCommunityId/text()"/></HomeCommunityId>
</xsl:if>

<!-- Document body -->
<xsl:choose>
<!-- Get from MIME attachment via XOP - which is base64 encoded since XMLMessage.Body is a binary steam -->
<xsl:when test="xdsb:Document/xop:Include">
<xsl:variable name="cid" select="isc:evaluate('getCID',xdsb:Document/xop:Include/@href)"/>
<contentType><xsl:value-of select="/XMLMessage/StreamCollection/MIMEAttachment[ContentId/text()=$cid]/ContentType/text()"/></contentType>
<contentEncoding><xsl:value-of select="/XMLMessage/StreamCollection/MIMEAttachment[ContentId/text()=$cid]/ContentTransferEncoding/text()"/></contentEncoding>
<Body><xsl:value-of select="/XMLMessage/StreamCollection/MIMEAttachment[ContentId/text()=$cid]/Body/text()"/></Body>
</xsl:when>

<!-- Allow in-line documents (even though not allowed by standard) which must be baset64 encoded -->
<xsl:otherwise>
<Body><xsl:value-of select="xdsb:Document/text()"/></Body>
</xsl:otherwise>
</xsl:choose>
</DocumentCache>
</xsl:template>
</xsl:stylesheet>
