<?xml version="1.0"?>
<xsl:stylesheet xmlns:tns="urn:bean.initiate.com"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<!-- Dig out the patient's MRN, the assigning authority and the score -->
	<xsl:template match="memHead">
		<MRN><xsl:value-of select="substring-before(memIdnum, &quot;|&quot;)"/></MRN>
		<AssigningAuthority><xsl:value-of select="srcCode"/></AssigningAuthority>
		<MPIID><xsl:value-of select="entRecno"/></MPIID>
		<RankOrScore><xsl:value-of select="matchScore"/></RankOrScore>
	</xsl:template>

	<!-- Facility -->
	<xsl:template match="memAttr/item[attrCode='FACILITY']">
		<Facility><xsl:value-of select="attrVal"/></Facility>
	</xsl:template>

	<!-- Patient Name -->
	<xsl:template match="memName/item[attrCode='LGLNAME']">
		<xsl:if test="string-length(onmFirst) > 0" >
			<FirstName><xsl:value-of select="onmFirst"/></FirstName>
		</xsl:if>
		<xsl:if test="string-length(onmMiddle) > 0" >
			<MiddleName><xsl:value-of select="onmMiddle"/></MiddleName>
		</xsl:if>
		<LastName><xsl:value-of select="onmLast"/></LastName>
	</xsl:template>

	<!-- Patient Gender -->
	<xsl:template match="memAttr/item[attrCode='SEX']">
		<Sex><xsl:value-of select="attrVal"/></Sex>
	</xsl:template>

	<!-- Patient SSN -->
	<xsl:template match="memIdent/item[attrCode='SSN']">
		<SSN><xsl:value-of select="idNumber"/></SSN>
	</xsl:template>

	<!-- Patient DoB -->
	<xsl:template match="memDate/item[attrCode='BIRTHDT']">
		<DOB><xsl:value-of select="substring-before(dateVal,' ')"/></DOB>
	</xsl:template>

	<!-- Address -->
	<xsl:template match="memAddr/item[attrCode='HOMEADDR']">
		<Street><xsl:value-of select="stLine1"/></Street>
		<City><xsl:value-of select="city"/></City>
		<Zip><xsl:value-of select="zipCode"/></Zip>
		<State><xsl:value-of select="state"/></State>
	</xsl:template>

	<!-- Phone -->
	<xsl:template match="memPhone/item[attrCode='HOMEPHON']">
		<Telephone><xsl:value-of select="phNumber"/></Telephone>
	</xsl:template>

	<xsl:template match="item">
		<PatientSearchMatch>
			<xsl:apply-templates select="memHead"/>
			<xsl:apply-templates select="memName/item[attrCode='LGLNAME']"/>
			<xsl:apply-templates select="memIdent/item[attrCode='SSN']"/>
			<xsl:apply-templates select="memDate/item[attrCode='BIRTHDT']"/>
			<xsl:apply-templates select="memAddr/item[attrCode='HOMEADDR']"/>
			<xsl:apply-templates select="memAttr/item[attrCode='SEX']"/>
			<xsl:apply-templates select="memAttr/item[attrCode='FACILITY']"/>
		</PatientSearchMatch>		
	</xsl:template>

</xsl:stylesheet>
