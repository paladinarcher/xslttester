<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:hl7="urn:hl7-org:v3" xmlns:isc="http://extension-functions.intersystems.com" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" version="1.0" xmlns:wrapper="http://wrapper.intersystems.com" xmlns:ihe="urn:ihe:iti:xds-b:2007" exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="queryID"/>
<xsl:param name="assigningAuthorityID"/>
<xsl:param name="patientID"/>

<xsl:template match="/">
<query:AdhocQueryRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:ihe="urn:ihe:iti:xds-b:2007">
<query:ResponseOption returnComposedObjects="true" returnType="LeafClass"/>
<rim:AdhocQuery id="urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d">
<rim:Slot name="$XDSDocumentEntryPatientId">
<rim:ValueList>
<rim:Value>'<xsl:value-of select="$patientID"/>^^^&amp;<xsl:value-of select="$assigningAuthorityID"/>&amp;ISO'</rim:Value>
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
