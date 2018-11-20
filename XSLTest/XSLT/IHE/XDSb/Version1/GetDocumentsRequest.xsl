<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:ihe="urn:ihe:iti:xds-b:2007" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- Send either UUID or UniqueId. HomeCommunityId only if returned from patient level query -->
<xsl:param name="entryUUID"/>
<xsl:param name="uniqueId"/>
<xsl:param name="home"/>

<xsl:template match="/">
<query:AdhocQueryRequest>
<query:ResponseOption returnComposedObjects="true" returnType="LeafClass"/>
<xsl:element name="rim:AdhocQuery">
<xsl:attribute name="id"><xsl:value-of select="'urn:uuid:5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4'"/></xsl:attribute>
<xsl:if test="$home">
<xsl:attribute name="home">
<xsl:choose>
<xsl:when test="contains($home,'urn:oid:')">
<xsl:value-of select="$home"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="concat('urn:oid:',$home)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
</xsl:if>

<xsl:choose>
<xsl:when test="$entryUUID">
<rim:Slot name="$XDSDocumentEntryEntryUUID">
<rim:ValueList>
<xsl:choose>
<xsl:when test="contains($entryUUID,'urn:uuid:')">
<rim:Value>('<xsl:value-of select="$entryUUID"/>')</rim:Value>
</xsl:when>
<xsl:otherwise>
<rim:Value>('urn:uuid:<xsl:value-of select="$entryUUID"/>')</rim:Value>
</xsl:otherwise>
</xsl:choose>
</rim:ValueList>
</rim:Slot>
</xsl:when>
<xsl:otherwise>
<rim:Slot name="$XDSDocumentEntryUniqueId">
<rim:ValueList>
<rim:Value>('<xsl:value-of select="$uniqueId"/>')</rim:Value>
</rim:ValueList>
</rim:Slot>
</xsl:otherwise>
</xsl:choose>
</xsl:element>
</query:AdhocQueryRequest>
</xsl:template>

</xsl:stylesheet>