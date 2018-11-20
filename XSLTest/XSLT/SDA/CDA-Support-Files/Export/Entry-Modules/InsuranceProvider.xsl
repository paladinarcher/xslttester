<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="payers-Narrative">
		<text>
			<table border="1" width="100%">
				<thead>
					<tr>
						<th>Payer Name</th>
						<th>Policy Type</th>
						<th>Policy Number</th>
						<th>Effective Date</th>
						<th>Expiration Date</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="set:distinct(Encounter/HealthFunds/HealthFund/HealthFund/Code)">
						<xsl:for-each select="set:distinct(../../MembershipNumber)">
							<xsl:apply-templates select=".." mode="payers-NarrativeDetail"/>
						</xsl:for-each>
					</xsl:for-each>
				</tbody>
			</table>
		</text>
	</xsl:template>
	
	<xsl:template match="*" mode="payers-NarrativeDetail">
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="HealthFundPlan/Description"><xsl:value-of select="HealthFundPlan/Description/text()"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="//HealthFund/Description/text()"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:value-of select="PlanType/text()"/></td>
			<td><xsl:value-of select="MembershipNumber/text()"/></td>
			<td><xsl:value-of select="EffectiveDate/text()"/></td>
			<td><xsl:value-of select="ExpirationDate/text()"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="*" mode="payers-Entries">
		<xsl:for-each select="set:distinct(Encounter/HealthFunds/HealthFund/HealthFund/Code)">
			<xsl:for-each select="set:distinct(../../MembershipNumber)">
				<xsl:apply-templates select=".." mode="payers-EntryDetail"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*" mode="payers-EntryDetail">
		<xsl:variable name="membershipNumber" select="MembershipNumber"/>
		
		<entry typeCode="DRIV">
			<act classCode="ACT" moodCode="DEF">
				<xsl:call-template name="templateIDs-payerEntry"/>
				
				<id nullFlavor="UNK"/>
				
				<code code="48768-6" displayName="Payment Sources" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<statusCode code="completed"/>
				
				<xsl:apply-templates select="." mode="effectiveTime-healthPlan"/>

				<!-- Health Plan Detail -->
				<entryRelationship typeCode="COMP">
					<act classCode="ACT" moodCode="EVN">
						<xsl:call-template name="templateIDs-healthPlanPolicy"/>
						
						<xsl:apply-templates select="." mode="id-PayerGroup"/>
						<!-- TODO: As of 10/20/2011 HS.SDA.HealthFund:PlanType -->
						<!-- is not stored in the HSDB.                        -->
						<xsl:choose>
							<xsl:when test="string-length(PlanType)">
								<xsl:apply-templates select="PlanType" mode="code-healthPlanType"/>
							</xsl:when>
							<xsl:otherwise>
								<code nullFlavor="UNK"/>
							</xsl:otherwise>
						</xsl:choose>
						<statusCode code="completed"/>
						<xsl:apply-templates select="." mode="performer-healthPlan"/>
						<xsl:apply-templates select="." mode="participant-healthPlan"/>
						<xsl:apply-templates select="." mode="participant-healthPlanSubscriber"/>
					</act>
				</entryRelationship>
				
				<!-- Link this payer to all related encounters (when/where was this payment used?) noted in encounters section -->
				<xsl:apply-templates select="//Encounter[HealthFunds/HealthFund/MembershipNumber=$membershipNumber]" mode="encounterLink-entryRelationship"/>
			</act>
		</entry>
	</xsl:template>
	
	<xsl:template match="*" mode="payers-NoData">
		<text><xsl:value-of select="$exportConfiguration/payers/emptySection/narrativeText/text()"/></text>
	</xsl:template>
	
	<xsl:template match="*" mode="effectiveTime-healthPlan">
		<effectiveTime>			
			<xsl:choose>
				<xsl:when test="string-length(EffectiveDate)"><low><xsl:attribute name="value"><xsl:apply-templates select="EffectiveDate" mode="xmlToHL7TimeStamp"/></xsl:attribute></low></xsl:when>
				<xsl:otherwise><low nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="string-length(ExpirationDate)"><high><xsl:attribute name="value"><xsl:apply-templates select="ExpirationDate" mode="xmlToHL7TimeStamp"/></xsl:attribute></high></xsl:when>
				<xsl:otherwise><high nullFlavor="UNK"/></xsl:otherwise>
			</xsl:choose>
		</effectiveTime>
	</xsl:template>

	<xsl:template name="templateIDs-payerEntry">
		<xsl:if test="string-length($hl7-CCD-CoverageActivity)"><templateId root="{$hl7-CCD-CoverageActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-CoverageEntry)"><templateId root="{$ihe-PCC_CDASupplement-CoverageEntry}"/></xsl:if>
	</xsl:template>

	<xsl:template name="templateIDs-healthPlanPolicy">
		<xsl:if test="string-length($hitsp-CDA-InsuranceProvider)"><templateId root="{$hitsp-CDA-InsuranceProvider}"/></xsl:if>
		<xsl:if test="string-length($hl7-CCD-PolicyActivity)"><templateId root="{$hl7-CCD-PolicyActivity}"/></xsl:if>
		<xsl:if test="string-length($ihe-PCC_CDASupplement-PayerEntry)"><templateId root="{$ihe-PCC_CDASupplement-PayerEntry}"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
