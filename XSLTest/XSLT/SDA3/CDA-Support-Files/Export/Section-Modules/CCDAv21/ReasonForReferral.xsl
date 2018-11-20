<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="*" mode="sRFR-reasonForReferral">
		<xsl:param name="sectionRequired" select="'0'"/>
		
		<xsl:variable name="hasParameterData" select="string-length($eventReason) > 0"/><!-- checking a global variable; see Variables.xsl -->
		<xsl:variable name="hasSDAData" select="string-length(Referrals/Referral/ReferralReason/text()) > 0"/>
		<xsl:variable name="exportSectionWhenNoData" select="$exportConfiguration/reasonForReferral/emptySection/exportData/text()"/>
		
		<xsl:if test="($hasParameterData) or ($hasSDAData) or ($exportSectionWhenNoData='1') or ($sectionRequired='1')">
			<component>
				<section>
					<xsl:if test="not(($hasParameterData) or ($hasSDAData))"><xsl:attribute name="nullFlavor">NI</xsl:attribute></xsl:if>
					
					<xsl:call-template name="sRFR-templateIds-reasonForReferralSection"/>
					
					<code code="42349-1" codeSystem="{$loincOID}" codeSystemName="{$loincName}" displayName="Reason for Referral"/>
					<title>Reason for Referral</title>
					
					<xsl:choose>
						<xsl:when test="$hasParameterData or $hasSDAData">
							<text>
								<xsl:if test="$hasParameterData">
									<xsl:value-of select="$eventReason" disable-output-escaping="yes"/>
								</xsl:if>
								<xsl:if test="$hasSDAData">
									<xsl:if test="$hasParameterData"><br/></xsl:if>
									<xsl:value-of select="Referrals/Referral/ReferralReason/text()"/>
								</xsl:if>
							</text>
						</xsl:when>
						<xsl:otherwise><xsl:apply-templates select="." mode="sRFR-reasonForReferral-NoData"/></xsl:otherwise>
					</xsl:choose>
				</section>
			</component>
		</xsl:if>
	</xsl:template>
	
	<!-- Following two modes are now unused -->
	<xsl:template match="*" mode="sRFR-reasonForReferral-parameter-Narrative">
		<xsl:value-of select="$eventReason" disable-output-escaping="yes"/>
	</xsl:template>
	
	<xsl:template match="*" mode="sRFR-reasonForReferral-SDA-Narrative">
		<xsl:value-of select="Referrals/Referral/ReferralReason/text()"/>
	</xsl:template>
	
	<xsl:template match="*" mode="sRFR-reasonForReferral-NoData">
		<text><xsl:value-of select="$exportConfiguration/reasonForReferral/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<!-- ***************************** NAMED TEMPLATES ************************************ -->
	
	<xsl:template name="sRFR-templateIds-reasonForReferralSection">
		<templateId root="{$ccda-ReasonForReferralSection}"/>
		<templateId root="{$ccda-ReasonForReferralSection}" extension="2014-06-09"/>
	</xsl:template>
	
</xsl:stylesheet>