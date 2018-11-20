<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com" 
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<xsl:include href="Variables.xsl"/>
<!-- TODO: move to XDSb.Types.Query.xxx -->

<!-- home is required only if this is a subsequent query from a patient level query (i.e. FindDocuments) -->
<xsl:param name="home"/>
<xsl:param name="returnType" select="'LeafClass'"/>

<xsl:template match="/Metadata">
<XMLMessage>
<Name><xsl:value-of select="$xdsbQueryRequest"/></Name>
<ContentStream>
<AdhocQueryRequest xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0">
<ResponseOption returnComposedObjects="true" returnType="{$returnType}"/>
<AdhocQuery id="{$xdsbQueryGetDocuments}" xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<xsl:if test="$home">
<xsl:attribute name="home"><xsl:value-of select="$home"/></xsl:attribute>
</xsl:if>

<xsl:if test="Document[@id]">
<Slot name="$XDSDocumentEntryEntryUUID">
<ValueList>
<xsl:for-each select="Document[@id]">
<Value>('<xsl:value-of select="@id"/>')</Value>
</xsl:for-each>
</ValueList>
</Slot>
</xsl:if>

<xsl:if test="Document[not(@id) and UniqueId/text()]">
<Slot name="$XDSDocumentEntryUniqueId">
<ValueList>
<xsl:for-each select="Document[not(@id) and UniqueId/text()]">
<Value>('<xsl:value-of select="UniqueId/text()"/>')</Value>
</xsl:for-each>
</ValueList>
</Slot>
</xsl:if>

</AdhocQuery>
</AdhocQueryRequest>
</ContentStream>
</XMLMessage>
</xsl:template>

</xsl:stylesheet>