<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/RLSResponse">

		<MCCI_IN000007 xmlns="urn:hl7-org:v3"
					   xmlns:mif="urn:hl7-org:v3/mif"
					   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					   xsi:schemaLocation="urn:hl7-org:v3 rlsSchemas\MCCI_IN000007.xsd">
			<id root="Q9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
			<creationTime value="{isc:evaluate('timestamp')}"/>
			<versionCode code="V3PR1"/>
			<interactionId root="2.16.840.1.113883" extension="MCCI_IN000007" displayable="true"/>
			<processingCode code="P"/>
			<processingModeCode code="T"/>
			<acceptAckCode code="NE"/>

			<receiver>
				<device>
					<id root="2.16.840.1.999999.1.1"/>
					<name use="L">General Hospital</name>
				</device>
			</receiver>

			<sender>
				<device>
					<id root="2.16.840.1.999999.1"/>
					<name use="L">RLS-MA</name>
				</device>
			</sender>

			<acknowledgement>
				<xsl:choose>
					<xsl:when test="Accepted = 'true'">
						<typeCode code="AA"/>
						<!-- 'App Ack Accept' (from voc: AcknowledgementType) -->
					</xsl:when>
					<xsl:otherwise>
						<typeCode code="AR"/>
						<!-- App Ack Reject (from voc: AcknowledgementType) -->
					</xsl:otherwise>
				</xsl:choose>
				<targetMessage>
					<id root="J9043C85-F6F2-101A-A3C9-08002B2F49FB"/>
				</targetMessage>
				<acknowledgementDetail>
					<typeCode code="{Code}"/>
					<!-- 'Message Accepted' (from voc: MessageCondition) -->
					<text><xsl:value-of select="Text"/></text>
				</acknowledgementDetail>
			</acknowledgement>
		</MCCI_IN000007>

	</xsl:template>

</xsl:stylesheet>
