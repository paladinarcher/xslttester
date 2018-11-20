<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0">
	
	<!-- Additional parameters -->
	<xsl:param name="MessageID">__MESSAGE_ID_NOT_SET__</xsl:param>
	<xsl:param name="Timestamp">__TIMESTAMP_NOT_SET__</xsl:param>
	<xsl:param name="RID">__RID_NOT_SET__</xsl:param>
	<xsl:param name="SPI">__SPI_NOT_SET__</xsl:param>
	<xsl:param name="SPILastName">__SPI_LASTNAME_NOT_SET__</xsl:param>
	<xsl:param name="SPIFirstName">__SPI_FIRSTNAME_NOT_SET__</xsl:param>
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates select="MedicationHistoryRequest" />
	</xsl:template>

	<xsl:template match="MedicationHistoryRequest">
		<Message xmlns="http://www.surescripts.com/messaging"
				 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
				 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<Header>
				<To>mailto:<xsl:value-of select="$RID"/>.dp@surescripts.com</To>
				<From>mailto:<xsl:value-of select="$SPI"/>.spi@surescripts.com</From>
				<MessageID><xsl:value-of select="$MessageID"/></MessageID>
				<SentTime><xsl:value-of select="isc:evaluate('xmltimestamp',$Timestamp)"/></SentTime>
			</Header>
  			<Body>
    			<RxHistoryRequest>
      				<Prescriber>
        				<Identification>
          					<SPI><xsl:value-of select="$SPI"/></SPI>
        				</Identification>
        				<Name>
          					<LastName><xsl:value-of select="$SPILastName"/></LastName>
          					<FirstName><xsl:value-of select="$SPIFirstName"/></FirstName>
        				</Name>
      				</Prescriber>
      				<Patient>
        				<Name>
          					<LastName><xsl:value-of select="LastName"/></LastName>
          					<FirstName><xsl:value-of select="FirstName"/></FirstName>
        				</Name>
        				<Gender><xsl:value-of select="Sex"/></Gender>
        				<DateOfBirth><xsl:value-of select="translate(DOB,'-','')"/></DateOfBirth>
        				<Address>
							<xsl:if test="Street != ''">
          						<AddressLine1><xsl:value-of select="Street"/></AddressLine1>
							</xsl:if>
							<xsl:if test="City != ''">
	          					<City><xsl:value-of select="City"/></City>
							</xsl:if>
							<xsl:if test="State != ''">
	          					<State><xsl:value-of select="State"/></State>
							</xsl:if>
							<xsl:if test="Zip != ''">
	          					<ZipCode><xsl:value-of select="Zip"/></ZipCode>
							</xsl:if>
        				</Address>
					<Email/>
      				</Patient>
      				<BenefitsCoordination>
        				<Consent><xsl:value-of select="HaveConsent"/></Consent>
      				</BenefitsCoordination>
    			</RxHistoryRequest>
  			</Body>
		</Message>
	</xsl:template>
</xsl:stylesheet>
