<?xml version="1.0"?>
<xsl:stylesheet xmlns:ssm="http://www.surescripts.com/messaging"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				xmlns:iscssl="http://www.intersystems.com/surescripts/lookup"
				exclude-result-prefixes="ssm xsi iscssl isc"
				version="1.0">

	<xsl:param name="Facility">__FACILITY_NOT_SET__</xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:variable name="quantityTop" select="document('')/*/iscssl:QuantityLookup" />
	<xsl:key name="medQuantityCode" match="iscssl:Quantity" use="iscssl:Code" />
	
	<xsl:template match="ssm:RxHistoryResponse">

	<xsl:variable name="firstDate">
		<xsl:value-of select="//ssm:MedicationDispensed[not(../ssm:MedicationDispensed/ssm:WrittenDate &lt; ssm:WrittenDate)]/ssm:WrittenDate"/>
	</xsl:variable>
	<xsl:variable name="lastDate">
		<xsl:value-of select="//ssm:MedicationDispensed[not(../ssm:MedicationDispensed/ssm:LastFillDate &gt; ssm:LastFillDate)]/ssm:LastFillDate"/>
	</xsl:variable>
		<Container>
			<Patients>
				<Patient>
					<xsl:apply-templates select="ssm:Patient"/>					
					<Encounters>
						<Encounter>
							<VisitNumber>
								<xsl:value-of select="/ssm:Message/ssm:Header/ssm:MessageID"/>-<xsl:value-of select="ssm:WrittenDate"/>-<xsl:value-of select="generate-id(.)"/>
							</VisitNumber>
							<AdmissionSource>
								<Code>EO</Code>
								<Description>EO</Description>
							</AdmissionSource>
							<EnteredAt>
								<Code><xsl:value-of select="$Facility"/></Code>
							</EnteredAt>
							<EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp',$lastDate)"/></EnteredOn>
							<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp',$firstDate)"/></StartTime>
							<EndTime><xsl:value-of select="isc:evaluate('xmltimestamp',$lastDate)"/></EndTime>
							<EncounterType>S</EncounterType>
							<HealthCareFacility>
								<Code><xsl:value-of select="$Facility"/></Code>
								<Organization>
									<Code><xsl:value-of select="$Facility"/></Code>
								</Organization>
							</HealthCareFacility>
							<Medications>
								<xsl:for-each select="ssm:MedicationDispensed">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</Medications>
						</Encounter>
					</Encounters>
				</Patient>
			</Patients>
		</Container>
	</xsl:template>
	
	<xsl:template match="ssm:MedicationDispensed">
			<Medication>
				<DrugProduct>
					<SDACodingStandard><xsl:value-of select="ssm:DrugCoded/ssm:ProductCodeQualifier"/></SDACodingStandard>
					<Code><xsl:value-of select="ssm:DrugCoded/ssm:ProductCode"/></Code>
					<Description><xsl:value-of select="ssm:DrugDescription"/></Description>
					<xsl:if test="ssm:DrugCoded/ssm:DosageForm !=''">
						<Form>
							<SDACodingStandard>SCRIPT81</SDACodingStandard>
							<Code><xsl:value-of select="ssm:DrugCoded/ssm:DosageForm"/></Code>
						</Form>
					</xsl:if>
					<xsl:if test="ssm:DrugCoded/ssm:Strength !=''">
						<Strength>
							<Code><xsl:value-of select="ssm:DrugCoded/ssm:Strength"/></Code>
						</Strength>
					</xsl:if>
					<xsl:if test="ssm:DrugCoded/ssm:StrengthUnits !=''">
						<StrengthUnits>
							<SDACodingStandard>SCRIPT81</SDACodingStandard>
							<Code><xsl:value-of select="ssm:DrugCoded/ssm:StrengthUnits"/></Code>
						</StrengthUnits>
					</xsl:if>
					<OrderType>MED</OrderType>
					<OrderCategory>
						<Code>MED</Code>
						<OrderType>MED</OrderType>
					</OrderCategory>
				</DrugProduct>
				<EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp',ssm:LastFillDate)"/></EnteredOn>
				<EnteredAt>
					<SDACodingStandard>SCRIPT</SDACodingStandard>
					<Code><xsl:value-of select="ssm:Pharmacy/ssm:Identification/ssm:NCPDPID"/></Code>
					<Description>Pharmacy: <xsl:value-of select="ssm:Pharmacy/ssm:StoreName" />; NCPDP ID: <xsl:value-of select="ssm:Pharmacy/ssm:Identification/ssm:NCPDPID"/></Description>
				</EnteredAt>
				<OrderedBy>
					<xsl:apply-templates select="ssm:Prescriber" />
				</OrderedBy>
				<PlacerId>1</PlacerId>
				<FillerId>1</FillerId>
				<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp',ssm:WrittenDate)"/></StartTime>
				<EndTime><xsl:value-of select="isc:evaluate('xmltimestamp',ssm:LastFillDate)"/></EndTime>
				<TextInstruction>
					<xsl:value-of select="ssm:Directions"/>
				</TextInstruction>
				<OrderQuantity>
					<xsl:value-of select="ssm:Quantity/ssm:Value"/>
					<xsl:text> </xsl:text> <!--  Add space before units -->
					<!--  Use a lookup table to return an English text string for the supplied Quantity/Qualifier -->
					<xsl:apply-templates select="$quantityTop">
						<xsl:with-param name="currQuantityCode" select="ssm:Quantity/ssm:Qualifier" />
						<xsl:with-param name="currQuantity" select="ssm:Quantity/ssm:Value" />
					</xsl:apply-templates>
				</OrderQuantity>
				<xsl:choose>
					<xsl:when test="ssm:Refills/ssm:Qualifier = 'R'">
						<NumberOfRefills><xsl:value-of select="ssm:Refills/ssm:Quantity"/></NumberOfRefills>
					</xsl:when>
					<xsl:when test="ssm:Refills/ssm:Qualifier = 'REM'">
						<RefillDescription>Refills Remaining: <xsl:value-of select="ssm:Refills/ssm:Quantity"/></RefillDescription>
					</xsl:when>
					<xsl:when test="ssm:Refills/ssm:Qualifier = 'PRN'">
						<RefillDescription>Refills As Needed</RefillDescription>
					</xsl:when>
				</xsl:choose>
				<Duration>
					<SDACodingStandard>SCRIPT81</SDACodingStandard>
					<Code><xsl:value-of select="ssm:DaysSupply" /></Code>
					<Description><xsl:value-of select="ssm:DaysSupply" /> Days</Description>
				</Duration>
				<Priority>
					<Code>R</Code>
				</Priority>
			</Medication>		
			<!-- Can't include Diagnosis elements for now
			<xsl:if test="ssm:Diagnosis/ssm:Qualifier = 'PrescriberSupplied'">
				<Diagnoses>
					<Diagnosis>
						<DiagnosingClinician>
							<xsl:apply-templates select="ssm:Prescriber" />
						</DiagnosingClinician>
						<Diagnosis>
							<SDACodingStandard><xsl:value-of select="ssm:Diagnosis/ssm:Primary/ssm:Qualifier" /></SDACodingStandard>
							<Code><xsl:value-of select="ssm:Diagnosis/ssm:Primary/ssm:Value" /></Code>
						</Diagnosis>
					</Diagnosis>
					<xsl:if test="ssm:Diagnosis/ssm:Secondary/ssm:Value !=''" >
						<Diagnosis>
							<DiagnosingClinician>
								<xsl:apply-templates select="ssm:Prescriber" />
							</DiagnosingClinician>
							<Diagnosis>
								<SDACodingStandard><xsl:value-of select="ssm:Diagnosis/ssm:Secondary/ssm:Qualifier" /></SDACodingStandard>
								<Code><xsl:value-of select="ssm:Diagnosis/ssm:Secondary/ssm:Value" /></Code>
							</Diagnosis>
						</Diagnosis>
					</xsl:if>
				</Diagnoses>
			</xsl:if>
		</Encounter>
		-->
	</xsl:template>

	<xsl:template match="ssm:MedicationPrescribed">

				<Medication>
					<DrugProduct>
						<Code><xsl:value-of select="ssm:DrugCoded/ssm:ProductCode"/></Code>
						<Description><xsl:value-of select="ssm:DrugDescription"/></Description>
						<OrderType>MED</OrderType>
					</DrugProduct>
					<EnteredOn><xsl:value-of select="isc:evaluate('xmltimestamp',ssm:WrittenDate)"/></EnteredOn>
					<EnteredAt>
						<Code>PrescriberSPI <xsl:value-of select="ssm:Prescriber/ssm:Identification/ssm:SPI"/></Code>
						<Address>
							<xsl:if test="concat(ssm:Prescriber/ssm:Address/ssm:AddressLine1,ssm:Prescriber/ssm:Address/ssm:AddressLine2) !=''">
								<Street>
									<xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:AddressLine1"/>; <xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:AddressLine2"/>
								</Street>
							</xsl:if>
							<xsl:if test="ssm:Prescriber/ssm:Address/ssm:City != ''">
								<City>
									<Code>
										<xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:City"/>
									</Code>
								</City>
							</xsl:if>
							<xsl:if test="ssm:Prescriber/ssm:Address/ssm:State != ''">	
								<State>
									<Code>
										<xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:State"/>
									</Code>
								</State>
							</xsl:if>
							<xsl:if test="ssm:Prescriber/ssm:Address/ssm:ZipCode != ''">	
							<Zip>
								<Code>
									<xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:ZipCode"/>
								</Code>
							</Zip>
							</xsl:if>
							<xsl:if test="ssm:Prescriber/ssm:Address/ssm:Country != ''">				
								<Country>
									<Code>
										<xsl:value-of select="ssm:Prescriber/ssm:Address/ssm:Country"/>
									</Code>
								</Country>
							</xsl:if>
						</Address>
					</EnteredAt>
					<OrderedBy>
						<Code><xsl:value-of select="ssm:Prescriber/ssm:Identification/ssm:SPI"/></Code>
						<Description>
							<xsl:value-of select="ssm:Prescriber/ssm:Name/ssm:LastName"/>, <xsl:value-of select="ssm:Prescriber/ssm:Name/ssm:FirstName"/>
						</Description>
						<Name>
							<GivenName>
								<xsl:value-of select="ssm:Prescriber/ssm:Name/ssm:FirstName"/>
							</GivenName>
							<FamilyName>
								<xsl:value-of select="ssm:Prescriber/ssm:Name/ssm:LastName"/>
							</FamilyName>
						</Name>
						<CareProviderType>
							<Code>MD</Code>
							<Description>MD</Description>
						</CareProviderType>
					</OrderedBy>
					<PlacerId>1</PlacerId>
					<FillerId>1</FillerId>
					<StartTime><xsl:value-of select="isc:evaluate('xmltimestamp',ssm:WrittenDate)"/></StartTime>
					<TextInstruction>
						<xsl:value-of select="ssm:Directions"/>
					</TextInstruction>
					<DoseQuantity><xsl:value-of select="ssm:Quantity/ssm:Value"/></DoseQuantity>
					<NumberOfRefills><xsl:value-of select="ssm:Refills/ssm:Quantity"/></NumberOfRefills>
					<DoseUoM>
						<Code><xsl:value-of select="ssm:Quantity/ssm:Qualifier"/></Code>
					</DoseUoM>
					<Duration>
						<Code><xsl:value-of select="generate-id(ssm:Directions)"/></Code>
						<Description><xsl:value-of select="ssm:Directions"/></Description>
					</Duration>
					<Priority>
						<Code>R</Code>
					</Priority>
					<Status>IP</Status>
				</Medication>

	</xsl:template>
	
	<xsl:template match="ssm:Prescriber">
		<SDACodingStandard>SCRIPT81</SDACodingStandard>
		<Code><xsl:value-of select="ssm:Identification/ssm:DEANumber"/></Code>
		<Description>
			<xsl:value-of select="ssm:Name/ssm:LastName"/><xsl:text>, </xsl:text><xsl:value-of select="ssm:Name/ssm:FirstName" />
			<xsl:if test="ssm:Name/ssm:MiddleName !=''">
				<xsl:value-of select="concat(' ',ssm:Name/ssm:MiddleName)"/>
			</xsl:if>
		</Description>
		<Name>
			<GivenName>
				<xsl:value-of select="ssm:Name/ssm:FirstName"/>
			</GivenName>
			<MiddleName>
				<xsl:value-of select="ssm:Name/ssm:MiddleName"/>
			</MiddleName>
			<FamilyName>
				<xsl:value-of select="ssm:Name/ssm:LastName"/>
			</FamilyName>
		</Name>
		<CareProviderType>
			<Code>MD</Code>
			<Description>MD</Description>
		</CareProviderType>
		<Address>
			<Street>
				<xsl:value-of select="ssm:Address/ssm:AddressLine1" /><xsl:if test="ssm:Address/ssm:AddressLine2 !=''" >; <xsl:value-of select="ssm:Address/ssm:AddressLine2" /></xsl:if>
			</Street>
			<City>
				<Code><xsl:value-of select="ssm:Address/ssm:City" /></Code>
			</City>
			<State>
				<Code><xsl:value-of select="ssm:Address/ssm:State" /></Code>
			</State>
			<Zip>
				<Code><xsl:value-of select="ssm:Address/ssm:ZipCode" /></Code>
			</Zip>
		</Address>
		<ContactInfo>
			<WorkPhoneNumber>
				<xsl:value-of select="ssm:PhoneNumbers/ssm:Phone[ssm:Qualifier='TE'][1]/ssm:Number" />
			</WorkPhoneNumber>
		</ContactInfo>
	</xsl:template>
	
	<xsl:template match="ssm:Patient">
		<Name>
			<!-- Patient Name, Gender and DoB -->
			<GivenName>
				<xsl:value-of select="ssm:Name/ssm:FirstName"/>
			</GivenName>
			<FamilyName>
				<xsl:value-of select="ssm:Name/ssm:LastName"/>
			</FamilyName>
		</Name>
		<Gender>
			<Code><xsl:value-of select="ssm:Gender"/></Code>
			<Description><xsl:value-of select="ssm:Gender"/></Description>
		</Gender>
		<BirthTime>
			<xsl:value-of select="isc:evaluate('xmltimestamp',ssm:DateOfBirth)"/>
		</BirthTime>
		
		<!-- Patient ID Numbers -->
		<PatientNumber>
			<PatientNumber>
				<Number>
					<!-- SureScripts doesn't give us a MRN or any identifying number.  So we'll just use
						 the message id
					-->
					<xsl:value-of select="/ssm:Message/ssm:Header/ssm:MessageID"/>
				</Number>
				<NumberType>MRN</NumberType>
				<Organization>
					<Code>
						<xsl:value-of select="$Facility"/>
					</Code>
				</Organization>
			</PatientNumber>
		</PatientNumber>
		
		<!-- Patient Address -->
	    <Address>
			<Address>
				<xsl:if test="ssm:Address/ssm:AddressLine1 != ''">
					<Street>
						<xsl:value-of select="ssm:Address/ssm:AddressLine1"/>
					</Street>
				</xsl:if>
				<xsl:if test="ssm:Address/ssm:City != ''">
					<City>
						<Code>
							<xsl:value-of select="ssm:Address/ssm:City"/>
						</Code>
					</City>
				</xsl:if>
				<xsl:if test="ssm:Address/ssm:State != ''">	
					<State>
						<Code>
							<xsl:value-of select="ssm:Address/ssm:State"/>
						</Code>
					</State>
				</xsl:if>
				<!-- Zip will always be present -->
				<Zip>
					<Code>
						<xsl:value-of select="ssm:Address/ssm:ZipCode"/>
					</Code>
				</Zip>
				<xsl:if test="ssm:Address/ssm:Country != ''">				
					<Country>
						<Code>
							<xsl:value-of select="ssm:Address/ssm:Country"/>
						</Code>
					</Country>
				</xsl:if>
			</Address>
		</Address>
		
		<!-- Phone number(s) -->
		<xsl:for-each select="ssm:PhoneNumbers/ssm:Phone[ssm:Qualifier = 'TE']">
			<ContactInfo>
		    	<HomePhoneNumber>
					<xsl:value-of select="ssm:Number"/>
			    </HomePhoneNumber>
			</ContactInfo>
		</xsl:for-each>

		<EnteredAt>
			<Code><xsl:value-of select="$Facility"/></Code>
		</EnteredAt>
		<EnteredOn/>
	</xsl:template>
	
	<xsl:template match="iscssl:QuantityLookup">
		<xsl:param name="currQuantityCode" />
		<xsl:param name="currQuantity" />
		<xsl:if test="$currQuantity = 1">
			<xsl:value-of select="key('medQuantityCode', $currQuantityCode)/iscssl:Text" />
		</xsl:if>
		<xsl:if test="$currQuantity != 1">
			<xsl:value-of select="key('medQuantityCode', $currQuantityCode)/iscssl:TextPlural" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ssm:Body">
		<xsl:apply-templates select="ssm:RxHistoryResponse"/>
	</xsl:template>
	
	<xsl:template match="/ssm:Message">
		<xsl:apply-templates select="ssm:Body"/>
	</xsl:template>
	
	<iscssl:QuantityLookup xmlns:iscssl="http://www.intersystems.com/surescripts/lookup">monkey
		<iscssl:Quantity><iscssl:Code>4E</iscssl:Code><iscssl:Text>20-Pack</iscssl:Text><iscssl:TextPlural>20-Packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AM</iscssl:Code><iscssl:Text>Ampoule</iscssl:Text><iscssl:TextPlural>Ampoules</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AQ</iscssl:Code><iscssl:Text>Anti-hemophilic Factor (AHF) Units</iscssl:Text><iscssl:TextPlural>Anti-hemophilic Factor (AHF) Units</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UR</iscssl:Code><iscssl:Text>Application</iscssl:Text><iscssl:TextPlural>Applications</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y5</iscssl:Code><iscssl:Text>Applicator full</iscssl:Text><iscssl:TextPlural>Applicator full</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AY</iscssl:Code><iscssl:Text>Assembly</iscssl:Text><iscssl:TextPlural>Assemblies</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AS</iscssl:Code><iscssl:Text>Assortment</iscssl:Text><iscssl:TextPlural>Assortments</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>BG</iscssl:Code><iscssl:Text>Bag</iscssl:Text><iscssl:TextPlural>Bags</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>BI</iscssl:Code><iscssl:Text>Bar</iscssl:Text><iscssl:TextPlural>Bars</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>BO</iscssl:Code><iscssl:Text>Bottle</iscssl:Text><iscssl:TextPlural>Bottles</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>BX</iscssl:Code><iscssl:Text>Box</iscssl:Text><iscssl:TextPlural>Boxes</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>93</iscssl:Code><iscssl:Text>Calories Per Gram</iscssl:Text><iscssl:TextPlural>Calories Per Gram</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AV</iscssl:Code><iscssl:Text>Capsule</iscssl:Text><iscssl:TextPlural>Capsules</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CT</iscssl:Code><iscssl:Text>Carton</iscssl:Text><iscssl:TextPlural>Cartons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CQ</iscssl:Code><iscssl:Text>Cartridge</iscssl:Text><iscssl:TextPlural>Cartridges</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>N9</iscssl:Code><iscssl:Text>Cartridge Needle</iscssl:Text><iscssl:TextPlural>Cartridge Needles</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CS</iscssl:Code><iscssl:Text>Cassette</iscssl:Text><iscssl:TextPlural>Cassettes</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AF</iscssl:Code><iscssl:Text>Centigram</iscssl:Text><iscssl:TextPlural>Centigrams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>C3</iscssl:Code><iscssl:Text>Centiliter</iscssl:Text><iscssl:TextPlural>Centiliters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CM</iscssl:Code><iscssl:Text>Centimeter</iscssl:Text><iscssl:TextPlural>Centimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>C7</iscssl:Code><iscssl:Text>Centipoise</iscssl:Text><iscssl:TextPlural>Centipoise</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CH</iscssl:Code><iscssl:Text>Container</iscssl:Text><iscssl:TextPlural>Containers</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>C5</iscssl:Code><iscssl:Text>Cost</iscssl:Text><iscssl:TextPlural>Cost</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>1N</iscssl:Code><iscssl:Text>Count</iscssl:Text><iscssl:TextPlural>Counts</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CC</iscssl:Code><iscssl:Text>Cubic Centimeter</iscssl:Text><iscssl:TextPlural>Cubic Centimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>C8</iscssl:Code><iscssl:Text>Cubic Decimeter</iscssl:Text><iscssl:TextPlural>Cubic Decimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CI</iscssl:Code><iscssl:Text>Cubic Inches</iscssl:Text><iscssl:TextPlural>Cubic Inches</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>CU</iscssl:Code><iscssl:Text>Cup</iscssl:Text><iscssl:TextPlural>Cups</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DA</iscssl:Code><iscssl:Text>Days</iscssl:Text><iscssl:TextPlural>Days</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DJ</iscssl:Code><iscssl:Text>Decagram</iscssl:Text><iscssl:TextPlural>Decagrams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DG</iscssl:Code><iscssl:Text>Decigram</iscssl:Text><iscssl:TextPlural>Decigrams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DL</iscssl:Code><iscssl:Text>Deciliter</iscssl:Text><iscssl:TextPlural>Deciliter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>22</iscssl:Code><iscssl:Text>Deciliter per Gram</iscssl:Text><iscssl:TextPlural>Deciliters per Gram</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DD</iscssl:Code><iscssl:Text>Degree</iscssl:Text><iscssl:TextPlural>Degrees</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DI</iscssl:Code><iscssl:Text>Dispenser</iscssl:Text><iscssl:TextPlural>Dispensers</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>US</iscssl:Code><iscssl:Text>Dosage Form</iscssl:Text><iscssl:TextPlural>Dosage Form</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y6</iscssl:Code><iscssl:Text>Dose</iscssl:Text><iscssl:TextPlural>Doses</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DF</iscssl:Code><iscssl:Text>Dram</iscssl:Text><iscssl:TextPlural>Drams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UX</iscssl:Code><iscssl:Text>Dram (Minim)</iscssl:Text><iscssl:TextPlural>Dram (Minim)</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>X4</iscssl:Code><iscssl:Text>Drop</iscssl:Text><iscssl:TextPlural>Drops</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>DB</iscssl:Code><iscssl:Text>Dry Pound</iscssl:Text><iscssl:TextPlural>Dry Pounds</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>EA</iscssl:Code><iscssl:Text>Each</iscssl:Text><iscssl:TextPlural>Each</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>EC</iscssl:Code><iscssl:Text>Each per Month</iscssl:Text><iscssl:TextPlural>Each per Month</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P8</iscssl:Code><iscssl:Text>Eight-pack</iscssl:Text><iscssl:TextPlural>Eight-packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>EP</iscssl:Code><iscssl:Text>Eleven Pack</iscssl:Text><iscssl:TextPlural>Eleven Packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>F3</iscssl:Code><iscssl:Text>Equivalent</iscssl:Text><iscssl:TextPlural>Equivalent</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>EQ</iscssl:Code><iscssl:Text>Equivalent Gallon</iscssl:Text><iscssl:TextPlural>Equivalent Gallons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P5</iscssl:Code><iscssl:Text>Five-pack</iscssl:Text><iscssl:TextPlural>Five-packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>FO</iscssl:Code><iscssl:Text>Fluid Ounce</iscssl:Text><iscssl:TextPlural>Fluid Ounces</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>FZ</iscssl:Code><iscssl:Text>Fluid Ounce (Imperial) Fluid Ounces (Imperial)</iscssl:Text><iscssl:TextPlural>Fluid Ounce (Imperial) Fluid Ounces (Imperial)</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P4</iscssl:Code><iscssl:Text>Four-pack</iscssl:Text><iscssl:TextPlural>Four-packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GA</iscssl:Code><iscssl:Text>Gallon</iscssl:Text><iscssl:TextPlural>Gallons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GB</iscssl:Code><iscssl:Text>Gallon per Day</iscssl:Text><iscssl:TextPlural>Gallons per Day</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GX</iscssl:Code><iscssl:Text>Grain</iscssl:Text><iscssl:TextPlural>Grains</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GR</iscssl:Code><iscssl:Text>Gram</iscssl:Text><iscssl:TextPlural>Grams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GF</iscssl:Code><iscssl:Text>Gram per 100 Centimeters</iscssl:Text><iscssl:TextPlural>Grams per 100 Centimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GC</iscssl:Code><iscssl:Text>Gram per 100 Grams</iscssl:Text><iscssl:TextPlural>Grams per 100 Grams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>23</iscssl:Code><iscssl:Text>Gram per Cubic Centimeter</iscssl:Text><iscssl:TextPlural>Grams per Cubic Centimeter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GK</iscssl:Code><iscssl:Text>Gram per Kilogram</iscssl:Text><iscssl:TextPlural>Grams per Kilogram</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GL</iscssl:Code><iscssl:Text>Gram per Liter</iscssl:Text><iscssl:TextPlural>Grams per Liter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GJ</iscssl:Code><iscssl:Text>Gram per Milliliter</iscssl:Text><iscssl:TextPlural>Grams per Milliliter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GM</iscssl:Code><iscssl:Text>Gram per Sq. Meter</iscssl:Text><iscssl:TextPlural>Grams per Sq. Meter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>10</iscssl:Code><iscssl:Text>Group</iscssl:Text><iscssl:TextPlural>Groups</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y7</iscssl:Code><iscssl:Text>Gum</iscssl:Text><iscssl:TextPlural>Gum</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GH</iscssl:Code><iscssl:Text>Half Gallon</iscssl:Text><iscssl:TextPlural>Half Gallons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>HT</iscssl:Code><iscssl:Text>Half Hour</iscssl:Text><iscssl:TextPlural>Half Hours</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>H2</iscssl:Code><iscssl:Text>Half Liter</iscssl:Text><iscssl:TextPlural>Half Liters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PV</iscssl:Code><iscssl:Text>Half Pint</iscssl:Text><iscssl:TextPlural>Half Pints</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>H4</iscssl:Code><iscssl:Text>Hectoliter</iscssl:Text><iscssl:TextPlural>Hectoliters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>HR</iscssl:Code><iscssl:Text>Hour</iscssl:Text><iscssl:TextPlural>Hours</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GI</iscssl:Code><iscssl:Text>Imperial Gallon</iscssl:Text><iscssl:TextPlural>Imperial Gallons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>IN</iscssl:Code><iscssl:Text>Inch</iscssl:Text><iscssl:TextPlural>Inches</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>E8</iscssl:Code><iscssl:Text>Inch, Decimal - Actual</iscssl:Text><iscssl:TextPlural>Inches, Decimal - Actual</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UT</iscssl:Code><iscssl:Text>Inhalation</iscssl:Text><iscssl:TextPlural>Inhalations</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y8</iscssl:Code><iscssl:Text>Inhalation</iscssl:Text><iscssl:TextPlural>Inhalations</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>IH</iscssl:Code><iscssl:Text>Inhaler</iscssl:Text><iscssl:TextPlural>Inhalers</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>F2</iscssl:Code><iscssl:Text>International Unite</iscssl:Text><iscssl:TextPlural>International Unite</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>JR</iscssl:Code><iscssl:Text>Jar</iscssl:Text><iscssl:TextPlural>Jars</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KE</iscssl:Code><iscssl:Text>Keg</iscssl:Text><iscssl:TextPlural>Kegs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KG</iscssl:Code><iscssl:Text>Kilogram</iscssl:Text><iscssl:TextPlural>Kilograms</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>D5</iscssl:Code><iscssl:Text>Kilogram per Square Centimeter</iscssl:Text><iscssl:TextPlural>Kilograms per Square Centimeter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KD</iscssl:Code><iscssl:Text>Kilogram Decimal</iscssl:Text><iscssl:TextPlural>Kilograms Decimal</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KC</iscssl:Code><iscssl:Text>Kilogram per Cubic Meter</iscssl:Text><iscssl:TextPlural>Kilograms per Cubic Meter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>3F</iscssl:Code><iscssl:Text>Kilogram per Liter of Product</iscssl:Text><iscssl:TextPlural>Kilograms per Liter of Product</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KW</iscssl:Code><iscssl:Text>Kilogram per Millimeter</iscssl:Text><iscssl:TextPlural>Kilograms per Millimeter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KM</iscssl:Code><iscssl:Text>Kilogram per Square Meter, Kilograms, Decimal</iscssl:Text><iscssl:TextPlural>Kilograms per Square Meter, Kilograms, Decimal</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KI</iscssl:Code><iscssl:Text>Kilogram per Millimeter Width</iscssl:Text><iscssl:TextPlural>Kilograms per Millimeter Width</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KT</iscssl:Code><iscssl:Text>Kit</iscssl:Text><iscssl:TextPlural>Kits</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>LT</iscssl:Code><iscssl:Text>Liter</iscssl:Text><iscssl:TextPlural>Liters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>LQ</iscssl:Code><iscssl:Text>Liter per Day</iscssl:Text><iscssl:TextPlural>Liters per Day</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>L2</iscssl:Code><iscssl:Text>Liter per Minute</iscssl:Text><iscssl:TextPlural>Liters per Minute</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UU</iscssl:Code><iscssl:Text>Lozenge</iscssl:Text><iscssl:TextPlural>Lozenges</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MR</iscssl:Code><iscssl:Text>Meter</iscssl:Text><iscssl:TextPlural>Meters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>M7</iscssl:Code><iscssl:Text>Micro Inch</iscssl:Text><iscssl:TextPlural>Micro Inches</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MC</iscssl:Code><iscssl:Text>Microgram</iscssl:Text><iscssl:TextPlural>Micrograms</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GQ</iscssl:Code><iscssl:Text>Microgram per Cubic Meter</iscssl:Text><iscssl:TextPlural>Micrograms per Cubic Meter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>4G</iscssl:Code><iscssl:Text>Microliter</iscssl:Text><iscssl:TextPlural>Microliters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>FH</iscssl:Code><iscssl:Text>Micromolar</iscssl:Text><iscssl:TextPlural>Micromolar</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UW</iscssl:Code><iscssl:Text>Milliequivalent</iscssl:Text><iscssl:TextPlural>Milliequivalent</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>ME</iscssl:Code><iscssl:Text>Milligram</iscssl:Text><iscssl:TextPlural>Milligrams</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GP</iscssl:Code><iscssl:Text>Milligram per Cubic Meter</iscssl:Text><iscssl:TextPlural>Milligrams per Cubic Meter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>4M</iscssl:Code><iscssl:Text>Milligram per Hour</iscssl:Text><iscssl:TextPlural>Milligrams per Hour</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>NA</iscssl:Code><iscssl:Text>Milligram per Kilogram</iscssl:Text><iscssl:TextPlural>Milligrams per Kilogram</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>M1</iscssl:Code><iscssl:Text>Milligram per Liter</iscssl:Text><iscssl:TextPlural>Milligrams per Liter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GO</iscssl:Code><iscssl:Text>Milligram per Square Meter</iscssl:Text><iscssl:TextPlural>Milligrams per Square Meter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>ML</iscssl:Code><iscssl:Text>Milliliter</iscssl:Text><iscssl:TextPlural>Milliliter</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>41</iscssl:Code><iscssl:Text>Milliliter per Minute</iscssl:Text><iscssl:TextPlural>Milliliters per Minute</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>40</iscssl:Code><iscssl:Text>Milliliter per Second</iscssl:Text><iscssl:TextPlural>Milliliters per Second</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>WW</iscssl:Code><iscssl:Text>Milliliter of Water</iscssl:Text><iscssl:TextPlural>Milliliters of Water</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>KX</iscssl:Code><iscssl:Text>Milliliter per Kilogram</iscssl:Text><iscssl:TextPlural>Milliliters per Kilogram</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MM</iscssl:Code><iscssl:Text>Millimeter</iscssl:Text><iscssl:TextPlural>Millimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>M2</iscssl:Code><iscssl:Text>Millimeter - Actual</iscssl:Text><iscssl:TextPlural>Millimeters - Actual</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MY</iscssl:Code><iscssl:Text>Millimeter - Average</iscssl:Text><iscssl:TextPlural>Millimeters - Average</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MZ</iscssl:Code><iscssl:Text>Millimeter - Minimum</iscssl:Text><iscssl:TextPlural>Millimeters - Minimum</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>HP</iscssl:Code><iscssl:Text>Millimeter H20</iscssl:Text><iscssl:TextPlural>Millimeters H20</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UM</iscssl:Code><iscssl:Text>Million Units</iscssl:Text><iscssl:TextPlural>Million Units</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>F4</iscssl:Code><iscssl:Text>Minim</iscssl:Text><iscssl:TextPlural>Minims</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MX</iscssl:Code><iscssl:Text>Mixed</iscssl:Text><iscssl:TextPlural>Mixed</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>F5</iscssl:Code><iscssl:Text>MOL</iscssl:Text><iscssl:TextPlural>MOL</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MO</iscssl:Code><iscssl:Text>Month</iscssl:Text><iscssl:TextPlural>Months</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>ZZ</iscssl:Code><iscssl:Text>Mutually Defined</iscssl:Text><iscssl:TextPlural>Mutually Defined</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>58</iscssl:Code><iscssl:Text>Net Kilogram</iscssl:Text><iscssl:TextPlural>Net Kilograms</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P9</iscssl:Code><iscssl:Text>Nine pack</iscssl:Text><iscssl:TextPlural>Nine packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>00</iscssl:Code><iscssl:Text>Not Specified</iscssl:Text><iscssl:TextPlural>Not Specified</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AU</iscssl:Code><iscssl:Text>Ocular Insert System</iscssl:Text><iscssl:TextPlural>Ocular Insert System</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>OZ</iscssl:Code><iscssl:Text>Ounce - Av</iscssl:Text><iscssl:TextPlural>Ounces - Av</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PH</iscssl:Code><iscssl:Text>Pack</iscssl:Text><iscssl:TextPlural>Packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PK</iscssl:Code><iscssl:Text>Package</iscssl:Text><iscssl:TextPlural>Packages</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>12</iscssl:Code><iscssl:Text>Packet</iscssl:Text><iscssl:TextPlural>Packets</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PR</iscssl:Code><iscssl:Text>Pair</iscssl:Text><iscssl:TextPlural>Pairs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>NX</iscssl:Code><iscssl:Text>Part per Thousand</iscssl:Text><iscssl:TextPlural>Parts Per Thousand</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PY</iscssl:Code><iscssl:Text>Peck, Dry Imperial</iscssl:Text><iscssl:TextPlural>Pecks, Dry Imperial</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>N1</iscssl:Code><iscssl:Text>Pen Calories</iscssl:Text><iscssl:TextPlural>Pen Calories</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>N4</iscssl:Code><iscssl:Text>Pen Gram (Protein)</iscssl:Text><iscssl:TextPlural>Pen Grams (Protein)</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P1</iscssl:Code><iscssl:Text>Percent</iscssl:Text><iscssl:TextPlural>Percent</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UV</iscssl:Code><iscssl:Text>Percent Topical Only</iscssl:Text><iscssl:TextPlural>Percent Topical Only</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>VP</iscssl:Code><iscssl:Text>Percent Volume</iscssl:Text><iscssl:TextPlural>Percent Volume</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>60</iscssl:Code><iscssl:Text>Percent Weight</iscssl:Text><iscssl:TextPlural>Percent Weight</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PT</iscssl:Code><iscssl:Text>Pint</iscssl:Text><iscssl:TextPlural>Pints</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Q2</iscssl:Code><iscssl:Text>Pint U.S. Dry</iscssl:Text><iscssl:TextPlural>Pints U.S. Dry</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>PX</iscssl:Code><iscssl:Text>Pint, Imperial</iscssl:Text><iscssl:TextPlural>Pints, Imperial</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>X9</iscssl:Code><iscssl:Text>Portion</iscssl:Text><iscssl:TextPlural>Portions</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>LB</iscssl:Code><iscssl:Text>Pound</iscssl:Text><iscssl:TextPlural>Pounds</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>GE</iscssl:Code><iscssl:Text>Pound per Gallon</iscssl:Text><iscssl:TextPlural>Pounds per Gallon</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AW</iscssl:Code><iscssl:Text>Powder-Filled Vial</iscssl:Text><iscssl:TextPlural>Powder-Filled Vials</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y9</iscssl:Code><iscssl:Text>Puff</iscssl:Text><iscssl:TextPlural>Puffs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>QT</iscssl:Code><iscssl:Text>Quart</iscssl:Text><iscssl:TextPlural>Quarts</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>QS</iscssl:Code><iscssl:Text>Quart, Dry U.S.</iscssl:Text><iscssl:TextPlural>Quarts, Dry U.S.</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>QU</iscssl:Code><iscssl:Text>Quart, Imperial</iscssl:Text><iscssl:TextPlural>Quarts, Imperial</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>QK</iscssl:Code><iscssl:Text>Quarter Kilogram</iscssl:Text><iscssl:TextPlural>Quarter Kilograms</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y10</iscssl:Code><iscssl:Text>Scoop</iscssl:Text><iscssl:TextPlural>Scoops</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>S1</iscssl:Code><iscssl:Text>Semester</iscssl:Text><iscssl:TextPlural>Semesters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P7</iscssl:Code><iscssl:Text>Seven pack</iscssl:Text><iscssl:TextPlural>Seven packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>14</iscssl:Code><iscssl:Text>Shot</iscssl:Text><iscssl:TextPlural>Shots</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P6</iscssl:Code><iscssl:Text>Six pack</iscssl:Text><iscssl:TextPlural>Six packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y11</iscssl:Code><iscssl:Text>Spray</iscssl:Text><iscssl:TextPlural>Sprays</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>MS</iscssl:Code><iscssl:Text>Square Millimeter</iscssl:Text><iscssl:TextPlural>Square Millimeters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>SR</iscssl:Code><iscssl:Text>Strip</iscssl:Text><iscssl:TextPlural>Strips</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>AR</iscssl:Code><iscssl:Text>Suppository</iscssl:Text><iscssl:TextPlural>Suppositories</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>SZ</iscssl:Code><iscssl:Text>Syringe</iscssl:Text><iscssl:TextPlural>Syringes</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y2</iscssl:Code><iscssl:Text>Tablespoon</iscssl:Text><iscssl:TextPlural>Tablespoons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>U2</iscssl:Code><iscssl:Text>Tablet</iscssl:Text><iscssl:TextPlural>Tablets</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y3</iscssl:Code><iscssl:Text>Teaspoon</iscssl:Text><iscssl:TextPlural>Teaspoons</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>U3</iscssl:Code><iscssl:Text>Ten</iscssl:Text><iscssl:TextPlural>Tens</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>TP</iscssl:Code><iscssl:Text>Ten-pack</iscssl:Text><iscssl:TextPlural>Ten-packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y12</iscssl:Code><iscssl:Text>Thin layer</iscssl:Text><iscssl:TextPlural>Thin layers</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>T2</iscssl:Code><iscssl:Text>Thousandth of an Inch</iscssl:Text><iscssl:TextPlural>Thousandths of an Inch</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>P3</iscssl:Code><iscssl:Text>Three Pack</iscssl:Text><iscssl:TextPlural>Three Packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>FG</iscssl:Code><iscssl:Text>Transdermal Patches</iscssl:Text><iscssl:TextPlural>Transdermal Patch</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>TY</iscssl:Code><iscssl:Text>Tray</iscssl:Text><iscssl:TextPlural>Trays</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>U1</iscssl:Code><iscssl:Text>Treatment</iscssl:Text><iscssl:TextPlural>Treatments</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>S2</iscssl:Code><iscssl:Text>Trimester</iscssl:Text><iscssl:TextPlural>Trimesters</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UP</iscssl:Code><iscssl:Text>Troche</iscssl:Text><iscssl:TextPlural>Troche</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>Y4</iscssl:Code><iscssl:Text>Tub</iscssl:Text><iscssl:TextPlural>Tubs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>TB</iscssl:Code><iscssl:Text>Tube</iscssl:Text><iscssl:TextPlural>Tubes</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>U5</iscssl:Code><iscssl:Text>Two Hundred Fifty</iscssl:Text><iscssl:TextPlural>Two Hundred Fifty</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>OP</iscssl:Code><iscssl:Text>Two Pack</iscssl:Text><iscssl:TextPlural>Two Packs</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UN</iscssl:Code><iscssl:Text>Unit</iscssl:Text><iscssl:TextPlural>Units</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>VI</iscssl:Code><iscssl:Text>Vial</iscssl:Text><iscssl:TextPlural>Vials</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>VS</iscssl:Code><iscssl:Text>Visit</iscssl:Text><iscssl:TextPlural>Visits</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>UQ</iscssl:Code><iscssl:Text>Wafer</iscssl:Text><iscssl:TextPlural>Wafers</iscssl:TextPlural></iscssl:Quantity>
		<iscssl:Quantity><iscssl:Code>YR</iscssl:Code><iscssl:Text>Year</iscssl:Text><iscssl:TextPlural>Years</iscssl:TextPlural></iscssl:Quantity>
	</iscssl:QuantityLookup>

</xsl:stylesheet>
