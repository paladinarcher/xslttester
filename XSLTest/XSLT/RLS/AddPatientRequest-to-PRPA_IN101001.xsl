<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/AddPatientRequest">

		<PRPA_IN101001 xmlns:hl7="urn:hl7-org:v3"
					   xmlns="urn:hl7-org:v3"
					   xmlns:mif="urn:hl7-org:v3/mif"
					   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					   xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\PRPA_IN101001.xsd">
			<id root="F9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
			<creationTime value="{isc:evaluate('timestamp')}"/>
			<versionCode code="V3PR1"/>
			<interactionId root="2.16.840.1.113883" extension="PRPA_IN101001"/>
			<processingCode code="P"/>
			<processingModeCode code="T"/>
			<acceptAckCode code="AL"/>
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
				<effectiveTime value="{isc:evaluate('timestamp')}"/>
				<priorityCode code="I"/>
				<reasonCode>
					<originalText>MEDNEC</originalText>
				</reasonCode>
				<authorOrPerformer typeCode="AUT">
					<assignedPerson>
						<id root="2.16.840.1.999999.1.1" extension="EMP001" displayable="true"/>
						<telecom value="tel:+1-955-555-1005" use="MC"/>
						<telecom value="mailto:regn@gh.org"/>
						<assignedPerson>
							<name use="L">
								<given>Reggie</given>
								<family>Registrar</family>
							</name>
						</assignedPerson>
					</assignedPerson>
				</authorOrPerformer>

				<subject>
					<registrationEvent>
						<id root="R9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
						<statusCode code="completed"/>
						<subject1>
							<identifiedPerson>
								
								<!-- Specify the patient's MRN and the assigning authority -->
								<id root="2.16.840.1.113883.3.86.3.1.21"
									extension="{MRN}"
									assigningAuthorityName="{Facility}"/>

								<addr>
									<address><xsl:value-of select="Street"/></address>
									<city><xsl:value-of select="City"/></city>
									<state><xsl:value-of select="State"/></state>
									<postalCode><xsl:value-of select="Zip"/></postalCode>
								</addr>

								<statusCode code="normal"/>
								
								<identifiedPerson>
									<name>
										<given><xsl:value-of select="FirstName"/></given>
										<family><xsl:value-of select="LastName"/></family>
									</name>
									<administrativeGenderCode codeSystem="2.16.840.1.113883.5.1"
															  code="{Sex}"/>
									<birthTime value="{DOB}"/>
									<playedOtherIDs>
										<id root="2.16.840.1.113883.4.1"
											extension="{SSN}"
											assigningAuthorityName="SSA"/>
									</playedOtherIDs>
								</identifiedPerson>

								<assigningOrganization>
									<!-- ADT System Assigned Identity -->
									<id root="2.16.840.1.999999.1.1.101"/>
									<contactParty>
										<telecom value="http://www.gh.org/cdx/ptrecs"/>
									</contactParty>
								</assigningOrganization>
							</identifiedPerson>
						</subject1>
						<custodian>
							<assignedEntity>
								<id/>
							</assignedEntity>
						</custodian>
					</registrationEvent>
				</subject>

			</controlActProcess>
		</PRPA_IN101001>
		
	</xsl:template>

</xsl:stylesheet>
