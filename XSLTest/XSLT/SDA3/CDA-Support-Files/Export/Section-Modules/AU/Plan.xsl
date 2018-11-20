<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc xsi sdtc exsl set">
	
	<xsl:template match="*" mode="plan">
		<component>
			<section>					
				<!-- IHE needs unique id for each and every section -->
				<id root="{$homeCommunityOID}" extension="{isc:evaluate('createUUID')}"/>
				
				<code code="101.16020" codeSystem="{$nctisOID}" codeSystemName="{$nctisName}" displayName="Plan"/>
				<title>Plan</title>
				
				<text mediaType="text/x-hl7-text+xml">
					<paragraph>This section may contain the following subsections Arranged Services and Record Of Recommendations And Information Provided.</paragraph>
				</text>
				
				<xsl:apply-templates select="." mode="recordOfRecommendations"/>
			</section>
		</component>
	</xsl:template>
</xsl:stylesheet>
