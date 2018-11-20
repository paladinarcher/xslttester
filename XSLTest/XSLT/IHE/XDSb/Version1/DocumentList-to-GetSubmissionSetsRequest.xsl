<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:isc="http://extension-functions.intersystems.com" 
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<!-- TODO: move to XDSb.Types.Query.xxx -->

<!-- home is required only if this is a subsequent query from a patient level query (i.e. FindDocuments) -->
<xsl:param name="home"/>
<xsl:param name="returnType" select="'LeafClass'"/>

<xsl:variable name="queryGetSubmissionSets" select="'urn:uuid:51224314-5390-4169-9b91-b1980040715a'"/>
<xsl:variable name="queryRequest" select="'XDSb_QueryRequest'"/>

<xsl:template match="/Metadata">
<XMLMessage>
<Name><xsl:value-of select="$queryRequest"/></Name>
<ContentStream>
<AdhocQueryRequest xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0">
<ResponseOption returnComposedObjects="true" returnType="{$returnType}"/>
<xsl:element name="AdhocQuery" xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<xsl:attribute name="id"><xsl:value-of select="$queryGetSubmissionSets"/></xsl:attribute>
<xsl:if test="$home">
<xsl:attribute name="home"><xsl:value-of select="$home"/></xsl:attribute>
</xsl:if>

<Slot name="$uuid">
<ValueList>
<xsl:for-each select="Document">
<Value>('<xsl:value-of select="@id"/>')</Value>
</xsl:for-each>
</ValueList>
</Slot>

</xsl:element>
</AdhocQueryRequest>
</ContentStream>
</XMLMessage>
</xsl:template>

</xsl:stylesheet>