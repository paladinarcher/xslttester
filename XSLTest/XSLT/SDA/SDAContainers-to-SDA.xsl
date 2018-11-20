<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
<Container>
	<!-- this will create the container -->
	<!-- now we create patients, copied from each container -->
	<Patients>
	<xsl:for-each select="//Patient">
		<Patient>
		<xsl:copy-of select="@*|node()" />
		</Patient>
	</xsl:for-each>
    </Patients>
</Container>
</xsl:template>
</xsl:stylesheet>