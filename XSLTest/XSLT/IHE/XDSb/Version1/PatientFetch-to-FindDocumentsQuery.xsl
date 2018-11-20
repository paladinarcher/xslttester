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
<xsl:include href="Variables.xsl"/>

<!-- By default, we will assume the registry supports ITI-61: Register On-Demand Document -->
<xsl:variable name="onlyStable" select="isc:evaluate('getConfigValue','\IHE\Registry\StableOnly')"/>

<xsl:template match="/PatientFetchRequestAsync">
<!-- The MRN in the request is either the affinity domain ID OR the MRN from an XCA connected affinity domain 
		 The assigning authority is the name of affinity domain -->
<xsl:variable name="oid" select="isc:evaluate('getOIDForCode',AssigningAuthority,'AssigningAuthority',AssigningAuthority)"/>
<xsl:variable name="id" select="MRN"/>

<query:AdhocQueryRequest>
<query:ResponseOption returnComposedObjects="true" returnType="LeafClass"/>
<rim:AdhocQuery id="urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d">
<rim:Slot name="$XDSDocumentEntryPatientId">
<rim:ValueList>
<rim:Value>'<xsl:value-of select="concat($id,'^^^&amp;',$oid,'&amp;ISO')"/>'</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="$XDSDocumentEntryStatus">
<rim:ValueList>
<rim:Value>('urn:oasis:names:tc:ebxml-regrep:StatusType:Approved')</rim:Value>
</rim:ValueList>
</rim:Slot>
<xsl:if test="not($onlyStable)">
<rim:Slot name="$XDSDocumentEntryType">
<rim:ValueList>
<rim:Value>('<xsl:value-of select="$xdsbStableDocument"/>')</rim:Value>
<rim:Value>('<xsl:value-of select="$xdsbOnDemandDocument"/>')</rim:Value>
</rim:ValueList>
</rim:Slot>
</xsl:if>
</rim:AdhocQuery>
</query:AdhocQueryRequest>
</xsl:template>

</xsl:stylesheet>