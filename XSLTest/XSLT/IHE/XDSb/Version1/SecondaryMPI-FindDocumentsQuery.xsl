<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="ID"/>
<xsl:param name="AA"/>
<xsl:param name="IncludeOnDemand"/>
<xsl:param name="returnType" select="'ObjectRef'"/>

<xsl:template match="/root">
<query:AdhocQueryRequest>
<query:ResponseOption returnComposedObjects="true" returnType="{$returnType}"/>

<rim:AdhocQuery id="urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d">
<rim:Slot name="$XDSDocumentEntryPatientId">
<rim:ValueList>
<rim:Value>'<xsl:value-of select="concat($ID,'^^^&amp;',$AA,'&amp;ISO')"/>'</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="$XDSDocumentEntryType">
<rim:ValueList>
<xsl:if test="$IncludeOnDemand='1'">
<rim:Value>('urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248')</rim:Value>  <!-- on demand -->
</xsl:if>
<rim:Value>('urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1')</rim:Value>  <!-- stable -->
</rim:ValueList>
</rim:Slot>
<rim:Slot name="$XDSDocumentEntryStatus">
<rim:ValueList>
<rim:Value>('urn:oasis:names:tc:ebxml-regrep:StatusType:Approved')</rim:Value>
</rim:ValueList>
</rim:Slot>

</rim:AdhocQuery>
</query:AdhocQueryRequest>
</xsl:template>

</xsl:stylesheet>