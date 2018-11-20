<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isc="http://extension-functions.intersystems.com" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" exclude-result-prefixes="isc hl7 xsi exsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="*" mode="Medication">
		<xsl:param name="medicationType" select="'MED'"/>

		<Medication>
			<!-- EnteredBy -->
			<xsl:apply-templates select="." mode="EnteredBy"/>
			
			<!-- EnteredAt -->
			<xsl:apply-templates select="." mode="EnteredAt"/>
			
			<!-- EnteredOn -->
			<xsl:apply-templates select="hl7:effectiveTime" mode="EnteredOn"/>
			
			<!-- Override ExternalId with the <id> values from the source CDA -->
			<xsl:apply-templates select="." mode="ExternalId"/>

			<!-- Entering Organization -->
			<xsl:apply-templates select="." mode="EnteringOrganization"/>

			<!-- OrderedBy -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:supply[@moodCode='INT']/hl7:author" mode="OrderedBy-Author"/>

			<!-- Placer and Filler IDs -->
			<xsl:apply-templates select="." mode="PlacerId"/>
			<xsl:apply-templates select="." mode="FillerId"/>

			<!-- Start and End Time -->
			<xsl:choose>
  				<xsl:when test="$medicationType='VXU'">
  					<xsl:apply-templates select="./hl7:effectiveTime[@value] | hl7:effectiveTime/hl7:low" mode="StartTime"/>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:apply-templates select="hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low" mode="StartTime"/>
  				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high" mode="EndTime"/>
			
			<!-- Order Item -->
			<xsl:apply-templates select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'OrderItem'"/>
				<xsl:with-param name="hsOrderType" select="$medicationType"/>
			</xsl:apply-templates>

			<!-- Frequency -->
			<xsl:apply-templates select="hl7:effectiveTime[@xsi:type='PIVL_TS']" mode="Frequency"/>			

			<!-- Duration -->
			<xsl:apply-templates select="hl7:effectiveTime[@xsi:type='IVL_TS']" mode="Duration"/>			

			<!-- Medication Status -->
			<xsl:apply-templates select="." mode="MedicationStatus"><xsl:with-param name="statusMedicationType" select="$medicationType"/></xsl:apply-templates>
			
			<!-- Prescription Number -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:supply[@moodCode='EVN']" mode="PrescriptionNumber"/>

			<!-- Drug Product -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='REFR']/hl7:supply[@moodCode='EVN']" mode="DrugProduct"><xsl:with-param name="medicationType" select="$medicationType"/></xsl:apply-templates>
			
			<!-- Dose Quantity -->
			<xsl:apply-templates select="hl7:doseQuantity" mode="DoseQuantity"/>
			
			<!-- Rate Amount -->
			<xsl:apply-templates select="hl7:rateQuantity" mode="RateAmount"/>				

			<!-- Route -->
			<xsl:apply-templates select="hl7:routeCode" mode="CodeTable">
				<xsl:with-param name="hsElementName" select="'Route'"/>
			</xsl:apply-templates>
			
			<!-- Indication -->
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='RSON']/hl7:observation/hl7:text" mode="Indication"/>
			
			<!-- Free-text SIG -->
			<xsl:apply-templates select="hl7:text" mode="Signature"/>
			
			<!-- Patient Instructions (not yet supported by SDA)
			<xsl:apply-templates select="hl7:entryRelationship[@typeCode='SUBJ']/hl7:act[hl7:templateId/@root=$medicationInstructionsEntryTemplateId]/hl7:text" mode="TextInstruction"/>
 			-->
 
			<!-- Comments -->
			<xsl:apply-templates select="." mode="Comment"/>
		</Medication>
	</xsl:template>

	<xsl:template match="*" mode="DrugProduct">
		<xsl:param name="medicationType"/>
		
		<!-- useFirstTranslation is created and used to provide for importing -->
		<!-- a CDA that was exported as a standards compliant CDA.            -->
		<xsl:variable name="useFirstTranslation">
			<xsl:choose>
				<xsl:when test="hl7:product/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:translation[1]/@codeSystem=$noCodeSystemOID">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<DrugProduct>
			<OrderType><xsl:value-of select="$medicationType"/></OrderType>
			
			<xsl:choose>
				<xsl:when test="$useFirstTranslation='0'">
					<xsl:apply-templates select="hl7:product/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code" mode="CodeTableDetail">
						<xsl:with-param name="hsElementName" select="'DrugProduct'"/>
						<xsl:with-param name="useFirstTranslation" select="false()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:product/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code" mode="CodeTableDetail">
						<xsl:with-param name="hsElementName" select="'DrugProduct'"/>
						<xsl:with-param name="useFirstTranslation" select="true()"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="hl7:quantity[not(@nullFlavor)]" mode="DrugProductQuantity"/>
			
			<ProductName><xsl:value-of select="hl7:product/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:name"/></ProductName>
		</DrugProduct>
	</xsl:template>

	<xsl:template match="*" mode="PrescriptionNumber">
		<PrescriptionNumber>
			<xsl:choose>
				<xsl:when test="hl7:id/@extension"><xsl:value-of select="hl7:id/@extension"/></xsl:when>
				<xsl:when test="hl7:id/@root"><xsl:value-of select="hl7:id/@root"/></xsl:when>
			</xsl:choose>
		</PrescriptionNumber>
	</xsl:template>

	<xsl:template match="*" mode="DrugProductQuantity">
		<BaseQty><xsl:value-of select="@value"/></BaseQty>
		<BaseUnits><Code><xsl:value-of select="@unit"/></Code><Description><xsl:value-of select="@unit"/></Description></BaseUnits>
	</xsl:template>

	<xsl:template match="*" mode="DoseQuantity">
		<!-- Dose Quantity -->
		<xsl:variable name="doseQuantity">
			<xsl:choose>
				<xsl:when test="@value"><xsl:value-of select="@value"/></xsl:when>
				<xsl:when test="hl7:low/@value"><xsl:value-of select="hl7:low/@value"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($doseQuantity)"><DoseQuantity><xsl:value-of select="$doseQuantity"/></DoseQuantity></xsl:if>
		
		<!-- Dose Units -->
		<xsl:variable name="doseUnits">
			<xsl:choose>
				<xsl:when test="@unit"><xsl:value-of select="@unit"/></xsl:when>
				<xsl:when test="hl7:low/@unit"><xsl:value-of select="hl7:low/@unit"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($doseUnits)">
			<DoseUoM>
				<Code><xsl:value-of select="$doseUnits"/></Code>
				<Description><xsl:value-of select="$doseUnits"/></Description>
			</DoseUoM>			
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="RateAmount">
		<!-- Rate Amount -->
		<xsl:variable name="rateAmount">
			<xsl:choose>
				<xsl:when test="@value"><xsl:value-of select="@value"/></xsl:when>
				<xsl:when test="hl7:low/@value"><xsl:value-of select="hl7:low/@value"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($rateAmount)"><RateAmount><xsl:value-of select="$rateAmount"/></RateAmount></xsl:if>
		
		<!-- Rate Units -->
		<xsl:variable name="rateUnits">
			<xsl:choose>
				<xsl:when test="@unit"><xsl:value-of select="@unit"/></xsl:when>
				<xsl:when test="hl7:low/@unit"><xsl:value-of select="hl7:low/@unit"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($rateUnits)">
			<RateUnits>
				<Code><xsl:value-of select="$rateUnits"/></Code>
				<Description><xsl:value-of select="$rateUnits"/></Description>
			</RateUnits>			
		</xsl:if>		
	</xsl:template>
	
	<xsl:template match="*" mode="Frequency">
		<xsl:variable name="frequency">
			<xsl:choose>
				<!-- false means it was an interval-->
				<xsl:when test="hl7:period and not(@institutionSpecified='true')"><xsl:value-of select="normalize-space(concat(hl7:period/@value, ' ', hl7:period/@unit))"/></xsl:when>
				<!-- otherwise it was a frequency -->
				<xsl:when test="hl7:period"><xsl:value-of select="normalize-space(concat(hl7:period/@value, 'x', hl7:period/@unit))"/></xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="string-length($frequency)">
			<Frequency>
				<Code><xsl:value-of select="$frequency"/></Code> 
				<Description><xsl:value-of select="$frequency"/></Description>
			</Frequency>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="MedicationStatus">
		<xsl:param name="statusMedicationType" select="'MED'"/>
		<Status>
			<xsl:choose>
				<xsl:when test="($statusMedicationType='VXU') and (../hl7:substanceAdministration/@negationInd='true')">C</xsl:when>
				<xsl:when test="hl7:entryRelationship[@typeCode='REFR']/hl7:supply[@moodCode = 'EVN']">E</xsl:when>
				<xsl:when test="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value/@code = '421139008'">H</xsl:when>
				<xsl:when test="hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value/@code = '55561003'">IP</xsl:when>
				<xsl:otherwise>I</xsl:otherwise>
			</xsl:choose>
		</Status>
	</xsl:template>
	
	<xsl:template match="*" mode="Indication">
		<Indication><xsl:apply-templates select="." mode="TextValue"/></Indication>
	</xsl:template>
	
	<xsl:template match="*" mode="Signature">
		<TextInstruction><xsl:apply-templates select="." mode="TextValue"/></TextInstruction>
	</xsl:template>

	<xsl:template match="*" mode="PatientInstructions">
		<PatientInstruction><xsl:apply-templates select="." mode="TextValue"/></PatientInstruction>
	</xsl:template>

	<xsl:template match="*" mode="Duration">
		<xsl:variable name="medicationStartDateTime" select="@value | hl7:low/@value"/>
		<xsl:variable name="medicationEndDateTime" select="@value | hl7:high/@value"/>
		<!-- The Duration is the number of days from start date to end date, -->
		<!-- inclusive.  For example a duration of Monday the 1st through    -->
		<!-- Friday the 5th is 5 days, not 5-1=4 days.                       -->
		<xsl:variable name="durationTemp" select="isc:evaluate('dateDiff', 'dd', concat(substring($medicationStartDateTime,5,2), '-', substring($medicationStartDateTime,7,2), '-', substring($medicationStartDateTime,1,4)), concat(substring($medicationEndDateTime,5,2), '-', substring($medicationEndDateTime,7,2), '-', substring($medicationEndDateTime,1,4)))"/>
		<xsl:variable name="durationValueInDays">
			<xsl:choose>
				<xsl:when test="string-length($durationTemp)"><xsl:value-of select="number($durationTemp + 1)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="string-length($durationValueInDays)">
			<Duration>
				<Code><xsl:value-of select="concat($durationValueInDays, 'd')"/></Code>
				<xsl:choose>
					<xsl:when test="$durationValueInDays>1"><Description><xsl:value-of select="concat($durationValueInDays, ' days')"/></Description></xsl:when>
					<xsl:otherwise><Description><xsl:value-of select="concat($durationValueInDays, ' day')"/></Description></xsl:otherwise>
				</xsl:choose>
			</Duration>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
