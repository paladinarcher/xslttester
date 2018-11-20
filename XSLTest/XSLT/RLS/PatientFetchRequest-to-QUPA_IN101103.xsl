<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/PatientFetchRequest">

		<QUPA_IN101103 xmlns:hl7="urn:hl7-org:v3"
					   xmlns="urn:hl7-org:v3"
					   xmlns:mif="urn:hl7-org:v3/mif"
					   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					   xsi:schemaLocation="urn:hl7-org:v3 	rlsSchemas\QUPA_IN101103.xsd">
			<id root="F9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
			<creationTime value="{isc:evaluate('timestamp')}"/>
			<versionCode code="V3PR1"/>
			<interactionId root="2.16.840.1.113883" extension="QUPA_IN101103"/>
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
				<authorOrPerformer typeCode="AUT">
					<assignedPerson>
						<id root="2.16.840.1.999999.1.2" extension="EMP101"/>
						<code codeSystem="2.16.840.1.999999.1" code="ADMIN"/>
						<telecom value="tel:+1-955-555-1005" use="MC"/>
						<telecom value="mailto:ed@stew.net"/>
						<assignedPerson>
							<name use="L">
								<given>Eric</given>
								<family>Emergency</family>
							</name>
						</assignedPerson>
					</assignedPerson>
				</authorOrPerformer>
				<queryByParameter>
					<statusCode code="active"/>
					
					<!-- Payload for Query Patient (QUPA_MT101103) -->
					<queryByParameterPayload>				
						<queryId root="H9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
						<statusCode code="active"/>
						<person.id>
							<!-- Specify the patient's MRN and the assigning authority -->
							<value root="2.16.840.1.113883.3.86.3.1.21"
								   extension="{MRN}"
								   assigningAuthorityName="{Facility}"/>
						</person.id>
					</queryByParameterPayload>
					
				</queryByParameter>
			</controlActProcess>
		</QUPA_IN101103>
		
	</xsl:template>

</xsl:stylesheet>
