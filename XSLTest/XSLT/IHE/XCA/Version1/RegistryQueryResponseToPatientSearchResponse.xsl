<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:hl7="urn:hl7-org:v3" xmlns:isc="http://extension-functions.intersystems.com" xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" version="1.0" xmlns:wrapper="http://wrapper.intersystems.com" xmlns:ihe="urn:ihe:iti:xds-b:2007" exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!--

		Set tXSLArguments("homeCommunityId")= "'urn:oid:"_pRequest.AdditionalInfo.GetAt("HomeCommunityId")_"'"
		#; documents stored in the MPI will be stored with the document ID in the MRN
		#; documents queried from an external system will have the external patient ID in the MRN
		Set tXSLArguments("documentUniqueId")="'"_pRequest.AdditionalInfo.GetAt("DocumentID")_"'"
		//If tXSLArguments("documentUniqueId")="" Set tXSLArguments("documentUniqueId")="'"_pRequest.MRN_"'"
		Set tXSLArguments("repositoryUniqueId")="'"_pRequest.AdditionalInfo.GetAt("RepositoryUniqueId")_"'"

-->
<xsl:template match="/query:AdhocQueryResponse">
<PatientSearchResponse>
<Results>
<xsl:for-each select="rim:RegistryObjectList/rim:ExtrinsicObject">

<PatientSearchMatch>
<AdditionalInfo>
<AdditionalInfoItem AdditionalInfoKey="HomeCommunityId"><xsl:value-of select="./@home"/></AdditionalInfoItem>
<AdditionalInfoItem AdditionalInfoKey="DocumentID"><xsl:value-of select="rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']/@value"/></AdditionalInfoItem>
<AdditionalInfoItem AdditionalInfoKey="RepositoryUniqueId"><xsl:value-of select="rim:Slot[@name='repositoryUniqueId']/rim:ValueList/rim:Value/text()"/></AdditionalInfoItem>
</AdditionalInfo>

</PatientSearchMatch>

</xsl:for-each>
</Results>
</PatientSearchResponse>
</xsl:template>
</xsl:stylesheet>
