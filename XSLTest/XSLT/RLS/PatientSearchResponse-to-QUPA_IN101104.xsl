<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="PatientSearchMatch">
		<subject xmlns="urn:hl7-org:v3">
			<target>
				<!-- Specify the patient's MRN and the assigning authority -->
				<id root="2.16.840.1.113883.3.86.3.1.21"
					extension="{MRN}"
					assigningAuthorityName="{Facility}"/>
					
				<rankOrScore value="{RankOrScore}"/>

				<addr>
					<street><xsl:value-of select="Street"/></street>
					<city><xsl:value-of select="City"/></city>
					<state><xsl:value-of select="State"/></state>
					<postalCode><xsl:value-of select="Zip"/></postalCode>
				</addr>

				<identifiedPerson>
					<name>
						<given><xsl:value-of select="FirstName"/></given>
						<family><xsl:value-of select="LastName"/></family>
					</name>
					<administrativeGenderCode codeSystem="2.16.840.1.113883.5.1"
											  code="{Sex}"/>
					<birthTime value="{DOB}"/>
				</identifiedPerson>

				<assigningOrganization>
					<!-- ADT System Assigned Identity -->
					<id root="2.16.840.1.999999.1.1.101" extension="{MPIID}"/>
					<contactParty>
						<telecom value="{Gateway}"/>
					</contactParty>
				</assigningOrganization>

				<subjectOf>
					<observationEvent>
						<code displayName="{isc:evaluate('encode',Consent)}"/>
					</observationEvent>
				</subjectOf>
				
			</target>
		</subject>
	</xsl:template>

	<xsl:template match="/PatientSearchResponse">

		<QUPA_IN101104 xmlns:hl7="urn:hl7-org:v3"
					   xmlns="urn:hl7-org:v3"
					   xmlns:mif="urn:hl7-org:v3/mif"
					   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					   xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd">
			<id root="F9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
			<creationTime value="{isc:evaluate('timestamp')}"/>
			<versionCode code="V3PR1"/>
			<interactionId root="2.16.840.1.113883" extension="QUPA_IN101104" displayable="true"/>
			<processingCode code="P"/>
			<processingModeCode code="T"/>
			<acceptAckCode code="NE"/>
			<receiver>
				<device>
					<id root="2.16.840.1.113883.3.86.3"/>
					<name use="L">HealthShare</name>
				</device>
			</receiver>
			<sender>
				<device>
					<id root="2.16.840.1.113883.3.86.3"/>
					<name use="L">HealthShare</name>
				</device>
			</sender>
			
			<!-- ControlAct starts here -->
			<controlActProcess moodCode="EVN">
				<!-- Multiple subject elements containing matching records for queried patient parameters -->
				<informationRecipient typeCode="PRCP">
					<!--Primary Information Recepient -->
					<assignedPerson>
						<id root="2.16.840.1.113883.3.86.3.1.21" extension="EMP101"/>
						<telecom value="tel:+1-955-555-1005" use="MC"/>
						<telecom value="mailto:ed@stew.net"/>
						<telecom value="{ConsentApplied}" use="CA"/>
						<assignedPerson>
							<name use="L">
								<given>Eric</given>
								<family>Emergency</family>
							</name>
						</assignedPerson>
					</assignedPerson>
				</informationRecipient>

				<xsl:for-each select="Results">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				
			</controlActProcess>
		</QUPA_IN101104>
		
	</xsl:template>

</xsl:stylesheet>
