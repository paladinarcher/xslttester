<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="exsl set" exclude-result-prefixes="isc xsi sdtc exsl set">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="healthcareProviders">
	
		<xsl:variable name="hasAttendings">
			<xsl:for-each select="set:distinct(Encounters/Encounter/AttendingClinicians/CareProvider/Code)">1</xsl:for-each>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length(FamilyDoctor) or string-length($hasAttendings)">
				<!-- Primary Care Physician -->
				<xsl:apply-templates select="FamilyDoctor" mode="documentationOf-FamilyDoctor"/>
				<!-- Other Physicians -->
				<xsl:apply-templates select="Encounters" mode="documentationOf-OtherDoctors"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="documentationOf-Unknown"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="documentationOf-FamilyDoctor">
		<documentationOf>
			<serviceEvent classCode="PCPR">
				<!-- Effective Time -->
				<effectiveTime>
					<low nullFlavor="UNK"/>
					<high nullFlavor="UNK"/>
				</effectiveTime>
				
				<!-- Family Doctor = Primary Care Doctor -->
				<xsl:variable name="careProviderType">
					<CareProviderType xmlns="">
						<SDACodingStandard>2.16.840.1.113883.12.443</SDACodingStandard>
						<Code>PP</Code>
						<Description>Primary Care Provider</Description>
					</CareProviderType>
				</xsl:variable>
				
				<performer typeCode="PRF">
					<xsl:variable name="performerIdentifierAssigningAuthority" select="isc:evaluate('getOIDForCode', SDACodingStandard/text(), 'AssigningAuthority')"/>
					
					<xsl:if test="$performerIdentifierAssigningAuthority = $nationalProviderIdentifierOID"><templateId root="{$hitsp-CDA-HealthcareProvider}"/></xsl:if>
					<templateId root="{$ihe-PCC-HealthcareProvidersAndPharmacies}"/>
					
					<xsl:apply-templates select="exsl:node-set($careProviderType)/CareProviderType" mode="code-function"/>
					<time>
						<low nullFlavor="UNK"/>
						<high nullFlavor="UNK"/>
					</time>
					<xsl:apply-templates select="." mode="assignedEntity-performer"/>
				</performer>
			</serviceEvent>
		</documentationOf>
	</xsl:template>
	
	<xsl:template match="*" mode="documentationOf-OtherDoctors">
		<xsl:for-each select="set:distinct(Encounter/AttendingClinicians/CareProvider/Code)">			
			<xsl:variable name="encountersRoot" select="../../../.."/>
			<xsl:variable name="encounterRoot" select="../../.."/>
			<xsl:variable name="careProviderCode" select="text()"/>

			<!-- If the care provider is an attending on multiple encounters  -->
			<!-- and if any of those encounters is missing the end time, then -->
			<!-- effective time high should be unknown (i.e., care provider   -->
			<!-- stil in service for the patient).                            -->
			<xsl:variable name="hasActiveEncounter">
				<xsl:for-each select="$encountersRoot/Encounter[AttendingClinicians/CareProvider/Code/text() = $careProviderCode]">
					<xsl:if test="not(string-length(EndTime/text()))">1</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="earliestStartTime1">
				<xsl:for-each select="$encountersRoot/Encounter[AttendingClinicians/CareProvider/Code/text() = $careProviderCode]">
					<xsl:sort select="StartTime" order="ascending"/>
					<xsl:value-of select="translate(StartTime/text(), 'TZ:- ', '')"/>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="latestEndTime1">
				<xsl:if test="not(string-length($hasActiveEncounter))">
					<xsl:for-each select="$encountersRoot/Encounter[AttendingClinicians/CareProvider/Code/text() = $careProviderCode]">
						<xsl:sort select="EndTime" order="descending"/>
						<xsl:value-of select="translate(EndTime/text(), 'TZ:- ', '')"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>

			<!-- If multiple encounters, then the start or end times could -->
			<!-- contain multiple date values. Just keep the first one.    -->
			<xsl:variable name="earliestStartTime2" select="substring($earliestStartTime1,1,14)"/>
			<xsl:variable name="latestEndTime2" select="substring($latestEndTime1,1,14)"/>
			
			<documentationOf>
				<serviceEvent classCode="PCPR">
					<xsl:variable name="serviceTime">
						<ServiceTime xmlns="">
							<StartTime><xsl:value-of select="$earliestStartTime2"/></StartTime>
							<xsl:if test="string-length($latestEndTime2)"><EndTime><xsl:value-of select="$latestEndTime2"/></EndTime></xsl:if>
						</ServiceTime>
					</xsl:variable>
					
					<!-- Effective Time -->
					<xsl:apply-templates select="exsl:node-set($serviceTime)/ServiceTime" mode="effectiveTime-StartEnd"/>
					
					<performer typeCode="PRF">
						<xsl:variable name="performerIdentifierAssigningAuthority" select="isc:evaluate('getOIDForCode', parent::node()/SDACodingStandard/text(), 'AssigningAuthority')"/>
						
						<xsl:if test="$performerIdentifierAssigningAuthority = $nationalProviderIdentifierOID"><templateId root="{$hitsp-CDA-HealthcareProvider}"/></xsl:if>
						<templateId root="{$ihe-PCC-HealthcareProvidersAndPharmacies}"/>
						
						<xsl:apply-templates select="parent::node()/CareProviderType" mode="code-function"/>
						<xsl:apply-templates select="exsl:node-set($serviceTime)/ServiceTime" mode="time"/>
						<xsl:apply-templates select="parent::node()" mode="assignedEntity-performer"/>
					</performer>
				</serviceEvent>
			</documentationOf>
		</xsl:for-each>
	</xsl:template>
	
	<!-- For a standards-compliant export, this template satisfies -->
	<!-- the HITSP requirement that there be *something* there for -->
	<!-- documentationOf/serviceEvent even when there is no family -->
	<!-- doctor or attending clinician for the patient.            -->
	<xsl:template name="documentationOf-Unknown">
		<documentationOf>
			<serviceEvent classCode="PCPR">
				<effectiveTime>
					<low nullFlavor="UNK"/>
					<high nullFlavor="UNK"/>
				</effectiveTime>
				<performer typeCode="PRF">
					<templateId root="1.3.6.1.4.1.19376.1.5.3.1.2.3"/>
					<time>
						<low nullFlavor="UNK"/>
						<high nullFlavor="UNK"/>
					</time>
					<assignedEntity classCode="ASSIGNED">
						<id nullFlavor="UNK"/>
						<addr nullFlavor="UNK"/>
						<telecom nullFlavor="UNK"/>
						<assignedPerson>
							<name nullFlavor="UNK"/>
						</assignedPerson>
					</assignedEntity>
				</performer>
			</serviceEvent>
		</documentationOf>
	</xsl:template>
</xsl:stylesheet>
