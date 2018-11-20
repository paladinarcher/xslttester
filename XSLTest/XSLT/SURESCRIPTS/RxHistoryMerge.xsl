<?xml version="1.0"?>
<xsl:stylesheet xmlns:ssm="http://www.surescripts.com/messaging"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				exclude-result-prefixes=""
				version="1.0">
<xsl:output indent="yes"/>
<xsl:param name="ADDFILE"></xsl:param>
<xsl:template match="/ssm:Message">
	<Message xmlns="http://www.surescripts.com/messaging" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:copy-of select="ssm:Header"></xsl:copy-of>
	<Body>
	<RxHistoryResponse>
	<xsl:copy-of select="//ssm:Response"></xsl:copy-of>
	<xsl:copy-of select="/ssm:Message/ssm:Body/ssm:RxHistoryResponse/ssm:Prescriber"></xsl:copy-of>
	<xsl:copy-of select="//ssm:Patient"></xsl:copy-of>
	<xsl:copy-of select="//ssm:BenefitsCoordination"></xsl:copy-of>
	<xsl:copy-of select="//ssm:MedicationDispensed"></xsl:copy-of>
	<xsl:copy-of select="document($ADDFILE)//ssm:MedicationDispensed"></xsl:copy-of>
	</RxHistoryResponse>
	</Body>
	</Message>
</xsl:template>

</xsl:stylesheet>
