<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:isc="http://extension-functions.intersystems.com" 
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:ihe="urn:ihe:iti:xds-b:2007" 
xmlns:xop="http://www.w3.org/2004/08/xop/include" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2" 
xmlns:wsa="http://www.w3.org/2005/08/addressing" 
xmlns:dsub="urn:ihe:iti:dsub:2009" 
exclude-result-prefixes="isc xsi">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="/">
<SubscriptionResponse>
<CancellationAddress><xsl:value-of select="wsnt:SubscribeResponse/wsnt:SubscriptionReference/wsa:Address/text()"/></CancellationAddress>
<SubscriptionID><xsl:value-of select="wsnt:SubscribeResponse/wsnt:SubscriptionReference/wsa:ReferenceParameters/dsub:SubscriptionId/text()"/></SubscriptionID>
</SubscriptionResponse>
</xsl:template>

</xsl:stylesheet>
