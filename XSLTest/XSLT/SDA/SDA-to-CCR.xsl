<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="urn:astm-org:CCR"
				xsi:schemaLocation="urn:astm-org:CCR CCR9.xsd"
				version="1.0">
	
	<!-- Additional parameters -->
	<xsl:param name="TIMESTAMP">__TIMESTAMP_NOT_SET__</xsl:param>
	<xsl:param name="ORGANIZATION">__ORGANIZATION_NOT_SET__</xsl:param>
	<xsl:param name="CONSENTAPPLIED"></xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="Container/Patients/Patient" />
	</xsl:template>
	
	<xsl:template match="Medication">
		<!-- Link to parent encounter -->
		<xsl:for-each select="../..">
			<InternalCCRLink>
				<LinkID><xsl:value-of select="generate-id()"/></LinkID>
			</InternalCCRLink>
		</xsl:for-each>

		<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
		<DateTime>
			<Type>
				<Text>Prescription Date</Text>
			</Type>
			<ExactDateTime><xsl:value-of select="EnteredOn"/></ExactDateTime>
		</DateTime>
		<Type>
			<Text>Medication</Text>
		</Type>
		<Description>
			<Text><xsl:value-of select="DrugProduct/Description"/></Text>
			<Code>
				<Value><xsl:value-of select="DrugProduct/Code"/></Value>
				<CodingSystem><xsl:value-of select="DrugProduct/SDACodingStandard"/></CodingSystem>
				<Version></Version>
			</Code>								
		</Description>
		<Status>
			<Text>Active</Text>
		</Status>
		<Source>
			<Actor>
				<ActorID>HCF_<xsl:value-of select="EnteredAt/Code"/></ActorID>
				<ActorRole>
					<Text>Healthcare Provider</Text>
				</ActorRole>
			</Actor>
		</Source>
		<Product>
			<ProductName>
				<Text><xsl:value-of select="DrugProduct/Description"/></Text>
				<Code>
					<Value><xsl:value-of select="DrugProduct/Code"/></Value>
					<CodingSystem><xsl:value-of select="DrugProduct/SDACodingStandard"/></CodingSystem>
					<Version></Version>
				</Code>
			</ProductName>
			<BrandName>
				<Text><xsl:value-of select="DrugProduct/Description"/></Text>
				<Code>
					<Value><xsl:value-of select="DrugProduct/Code"/></Value>
					<CodingSystem><xsl:value-of select="DrugProduct/SDACodingStandard"/></CodingSystem>
					<Version></Version>
				</Code>
			</BrandName>
			<Strength>
				<Value><xsl:value-of select="Strength"/></Value>
			</Strength>
			<Form>
				<Text><xsl:value-of select="DosageForm/Description"/></Text>
			</Form>
		</Product>
		<Quantity>
			<Value><xsl:value-of select="OrderQuantity"/></Value>
			<xsl:if test="OrderQuantityUnits != ''">
				<Units><Unit><xsl:value-of select="OrderQuantityUnits"/></Unit></Units>
			</xsl:if>
		</Quantity>
		<Directions>
			<Direction>
				<Dose>
					<Value><xsl:value-of select="DoseQuantity"/></Value>
					<xsl:if test="DoseUoM/Description != ''">
						<Units><Unit><xsl:value-of select="DoseUoM/Description"/></Unit></Units>
					</xsl:if>
				</Dose>
				<Route>
					<Text><xsl:value-of select="Route/Description"/></Text>
				</Route>
				<Frequency>
					<Description>
						<Text><xsl:value-of select="Frequency/Description"/></Text>
						<Code>
							<Value><xsl:value-of select="Frequency/Code"/></Value>
							<CodingSystem><xsl:value-of select="Frequency/SDACodingStandard"/></CodingSystem>
							<Version></Version>
						</Code>
					</Description>
				</Frequency>
				<xsl:if test="Indication != ''">
					<Indication>
						<Description>
							<Text><xsl:value-of select="Indication"/></Text>
						</Description>
						<Source/>
					</Indication>
				</xsl:if>
				<Duration>
					<Description>
						<Text><xsl:value-of select="Duration/Description"/></Text>
						<Code>
							<Value><xsl:value-of select="Duration/Code"/></Value>
							<CodingSystem><xsl:value-of select="Duration/SDACodingStandard"/></CodingSystem>
							<Version></Version>
						</Code>
					</Description>
				</Duration>
			</Direction>
		</Directions>
		<PatientInstructions>
			<Instruction>
				<Text><xsl:value-of select="TextInstruction"/></Text>
			</Instruction>
		</PatientInstructions>
		<xsl:if test="NumberOfRefills != ''">
			<Refills>
				<Refill>
					<Number><xsl:value-of select="NumberOfRefills"/></Number>
				</Refill>
			</Refills>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/Container/Patients/Patient">

		<ContinuityOfCareRecord>

			<!-- Begin CCR Header -->

			<CCRDocumentObjectID><xsl:value-of select="generate-id(node())"/></CCRDocumentObjectID>
			<Language>
				<Text>English</Text>
			</Language>
			<Version>1.0</Version>
			<DateTime>
				<ExactDateTime><xsl:value-of select="$TIMESTAMP"/></ExactDateTime>
			</DateTime>
			<Patient>
				<ActorID>PAT_<xsl:value-of select="PatientNumber/PatientNumber[NumberType = 'MRN']/Number"/></ActorID>
			</Patient>

			<!-- TODO: Do we need the From/To tags? -->
			<From>
				<ActorLink>
					<ActorID>AA_FROM</ActorID>
					<ActorRole>
						<Text><xsl:value-of select="$ORGANIZATION"/></Text>
					</ActorRole>
				</ActorLink>
			</From>			
			<To>
				<ActorLink>
					<ActorID>AA_TO</ActorID>
					<ActorRole>
						<Text>Primary Care Provider</Text>
					</ActorRole>
				</ActorLink>
			</To>
			<Purpose>
				<Description>
					<Text>For Patient Use</Text>
				</Description>
				<xsl:if test="$CONSENTAPPLIED != ''"> 
					<CommentID>Consent_Disclaimer</CommentID>
				</xsl:if> 
			</Purpose>

			<!-- Begin CCR Body -->

			<Body>
				<!-- Payers section here -->
				<!-- AdvanceDirectives section here -->
				<!-- Support section here -->
				<!-- FunctionalStatus section here -->
				<!-- Problems -->
				<xsl:variable name="PROBLEMS" select="//Diagnoses/Diagnosis"/>
				<xsl:if test="$PROBLEMS">
					<Problems>
						<xsl:for-each select="$PROBLEMS">
							<Problem>
								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Onset</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="EnteredOn"/></ExactDateTime>
								</DateTime>
								<Type>
									<Text>Diagnosis</Text>
								</Type>
								<Description>
									<Text><xsl:value-of select="Diagnosis/Description"/></Text>
									<Code>
										<Value><xsl:value-of select="Diagnosis/Code"/></Value>
										<CodingSystem><xsl:value-of select="Diagnosis/SDACodingStandard"/></CodingSystem>
										<Version></Version>
									</Code>
								</Description>							
								<Status>
									<Text>Active</Text>
								</Status>
								<Source>
									<Actor>
										<ActorID>HCF_<xsl:value-of select="EnteredAt/Code"/></ActorID>
										<ActorRole>
											<Text>Healthcare Provider</Text>
										</ActorRole>
									</Actor>
								</Source>
							</Problem>
						</xsl:for-each>
					</Problems>
				</xsl:if>
				
				<!-- FamilyHistory section here -->
				<xsl:variable name="FAMILYHISTORY" select="FamilyHistory/FamilyHistory"/>
				<xsl:if test="$FAMILYHISTORY">
				    <FamilyHistory>
						<xsl:for-each select="$FAMILYHISTORY">
							<FamilyProblemHistory>
								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<xsl:if test="EnteredAt">
									<Source>
										<Actor>
											<ActorID>HCF_<xsl:value-of select="EnteredAt/Code"/></ActorID>
											<ActorRole>
												<Text>Healthcare Provider</Text>
											</ActorRole>
										</Actor>
									</Source>
								</xsl:if>
								<xsl:if test="FromTime">
									<DateTime>
										<Type>
											<Text>Onset Date</Text>
										</Type>
										<ExactDateTime><xsl:value-of select="FromTime"/></ExactDateTime>
									</DateTime>
								</xsl:if>
								<FamilyMember>
									<ActorRole><Text><xsl:value-of select="FamilyMember/Description"/></Text></ActorRole>
								</FamilyMember>
								<xsl:if test="Diagnosis">
									<Problem>
										<Type><Text>Diagnosis</Text></Type>
										<Description>
											<ObjectAttribute>
												<Attribute>Diagnosis</Attribute>
												<AttributeValue>
													<Value><xsl:value-of select="Diagnosis/Description"/></Value>
													<Code>
														<Value><xsl:value-of select="Diagnosis/Code"/></Value>
														<CodingSystem><xsl:value-of select="Diagnosis/SDACodingStandard"/></CodingSystem>
														<Version></Version>
													</Code>
												</AttributeValue>
											</ObjectAttribute>
										</Description>
									</Problem>
								</xsl:if>
							</FamilyProblemHistory>
						</xsl:for-each>
				    </FamilyHistory>				
				</xsl:if>
				
				<!-- SocialHistory section here -->
				<xsl:variable name="SOCIALHISTORY" select="SocialHistory/SocialHistory"/>
				<xsl:if test="$SOCIALHISTORY">
				    <SocialHistory>
						<xsl:for-each select="$SOCIALHISTORY">
							<History>
								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<Type>
									<Text><xsl:value-of select="SocialHabit/Code"/></Text>
								</Type>
								<Description>
									<Text><xsl:value-of select="SocialHabitQty/Description"/></Text>
									<Code>
										<Value><xsl:value-of select="SocialHabitQty/Code"/></Value>
										<CodingSystem><xsl:value-of select="SocialHabitQty/SDACodingStandard"/></CodingSystem>
										<Version></Version>
									</Code>
								</Description>
							</History>
						</xsl:for-each>
				    </SocialHistory>
				</xsl:if>
				
				<!-- Alerts -->
				<xsl:variable name="ALERTS" select="Allergies/Allergies"/>
				<xsl:if test="$ALERTS">
					<Alerts>
						<xsl:for-each select="$ALERTS">
							<Alert>
								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Time First Noticed</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="FromTime"/></ExactDateTime>
								</DateTime>
								<Type>
									<Text>Allergy</Text>
									<Code>
										<Value>Allergy</Value>
									</Code>
								</Type>
								<Description>
									<Text><xsl:value-of select="Allergy/Description"/></Text>
									<Code>
										<Value><xsl:value-of select="Allergy/Code"/></Value>
										<CodingSystem><xsl:value-of select="Allergy/SDACodingStandard"/></CodingSystem>
										<Version></Version>
									</Code>
								</Description>
								<Source>
									<Actor>
										<ActorID>HCF_<xsl:value-of select="EnteredAt/Code"/></ActorID>
										<ActorRole>
											<Text>Healthcare Provider</Text>
										</ActorRole>
									</Actor>
								</Source>
								<Reaction>
									<Description>
										<Text><xsl:value-of select="Reaction/Description"/></Text>
										<Code>
											<Value><xsl:value-of select="Reaction/Code"/></Value>
											<CodingSystem><xsl:value-of select="Reaction/SDACodingStandard"/></CodingSystem>
											<Version></Version>
										</Code>
									</Description>
									<Severity>
										<Text><xsl:value-of select="Severity/Description"/></Text>
										<Code>
											<Value><xsl:value-of select="Severity/Code"/></Value>
											<CodingSystem><xsl:value-of select="Severity/SDACodingStandard"/></CodingSystem>
											<Version></Version>
										</Code>
									</Severity>
								</Reaction>
							</Alert>
						</xsl:for-each>
					</Alerts>
				</xsl:if>

				<!-- Encounters -->
				<xsl:variable name="ENCOUNTERS" select="Encounters/Encounter"/>
				<xsl:if test="$ENCOUNTERS">
					<Encounters>
						<xsl:for-each select="$ENCOUNTERS">
							<Encounter>
								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<ExactDateTime><xsl:value-of select="StartTime"/></ExactDateTime>
								</DateTime>
								<Type>
									<Text><xsl:value-of select="EncounterType"/></Text>
								</Type>
								<Description>
									<Text><xsl:value-of select="EncounterType"/></Text>
								</Description>
								<Source>
									<Actor>
										<ActorID>HCF_<xsl:value-of select="HealthCareFacility/Code"/></ActorID>
										<ActorRole>
											<Text>Healthcare Provider</Text>
										</ActorRole>
									</Actor>
								</Source>

								<xsl:variable name="DOCUMENTS" select="Documents/Document[string-length(NoteText) > 0]"/>
								<xsl:for-each select="$DOCUMENTS">
									<CommentID><xsl:value-of select="generate-id()"/></CommentID>
								</xsl:for-each>

								<xsl:variable name="PRACTITIONERS" select="AdmittingClinician | AttendingClinicians/* | ConsultingClinicians/* | ReferringClinician | Procedures/Procedure/Clinician"/>
								<xsl:if test="$PRACTITIONERS">
									<Practitioners>
										<xsl:for-each select="$PRACTITIONERS">
											<Practitioner>
												<ActorID>HCP_<xsl:value-of select="Code"/></ActorID>
												<ActorRole>
													<xsl:choose>
														<xsl:when test="name() = 'AdmittingClinician'">														
															<Text>Admitting Physician</Text>
														</xsl:when>
														<xsl:when test="name() = 'ReferringClinician'">														
															<Text>Referring Physician</Text>
														</xsl:when>
														<xsl:when test="name() = 'AttendingClinician'">														
															<Text>Attending Physician</Text>
														</xsl:when>
														<xsl:when test="name() = 'ConsultingClinician'">														
															<Text>Consulting Physician</Text>
														</xsl:when>
														<xsl:otherwise>
															<Text>Attending Physician</Text>
														</xsl:otherwise>
													</xsl:choose>
												</ActorRole>
											</Practitioner>
										</xsl:for-each>
									</Practitioners>
								</xsl:if>

								<!--
								<Consent/>
								-->
							</Encounter>
						</xsl:for-each>
					</Encounters>
				</xsl:if>
				
				<!-- Medications -->
				<xsl:variable name="MEDICATIONS" select="//Medication[DrugProduct/OrderType != 'VXU']"/>
				<xsl:if test="$MEDICATIONS">
					<Medications>
						<xsl:for-each select="$MEDICATIONS">
							<Medication>
								<xsl:apply-templates select="."/>
							</Medication>
						</xsl:for-each>
					</Medications>
				</xsl:if>
				
				<!-- Medical equipment -->

				<!-- Immunizations section here -->
				<xsl:variable name="IMMUNIZATIONS" select="//Medication[DrugProduct/OrderType = 'VXU']"/>
				<xsl:if test="$IMMUNIZATIONS">
					<Immunizations>
						<xsl:for-each select="$IMMUNIZATIONS">
							<Immunization>
								<xsl:apply-templates select="."/>
							</Immunization>
						</xsl:for-each>
					</Immunizations>
				</xsl:if>

				<!-- Vital Signs -->
				<xsl:variable name="OBSERVATIONS" select="//Observations/Observation"/>
				<xsl:if test="$OBSERVATIONS">
					<VitalSigns>
						<xsl:for-each select="$OBSERVATIONS">
							<Result>
								<!-- Link to parent encounter -->
								<xsl:for-each select="../..">
									<InternalCCRLink>
										<LinkID><xsl:value-of select="generate-id()"/></LinkID>
									</InternalCCRLink>
								</xsl:for-each>

								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Assessment Time</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="ObservationTime"/></ExactDateTime>
								</DateTime>
								<Description>
									<Text><xsl:value-of select="ObservationCode/Description"/></Text>
									<Code>
										<Value><xsl:value-of select="ObservationCode/Code"/></Value>
										<CodingSystem><xsl:value-of select="ObservationCode/CDACodingStandard"/></CodingSystem>
									</Code>
								</Description>
								<Source/>
								<Test>
									<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
									<Type>
										<Text>Observation</Text>
									</Type>
									<Description>
										<Text><xsl:value-of select="ObservationCode/Description"/></Text>
										<Code>
											<Value><xsl:value-of select="ObservationCode/Code"/></Value>
											<CodingSystem><xsl:value-of select="ObservationCode/CDACodingStandard"/></CodingSystem>
										</Code>
									</Description>
									<Source/>
									<TestResult>
										<Value><xsl:value-of select="ObservationValue"/></Value>
										<xsl:if test="Comments != ''">
											<Description>
												<Text><xsl:value-of select="Comments"/></Text>
											</Description>
										</xsl:if>
									</TestResult>
								</Test>
							</Result>
						</xsl:for-each>
					</VitalSigns>
				</xsl:if>

				<xsl:variable name="LABRESULTS" select="//Results/LabResult"/>
				<xsl:variable name="TXTRESULTS" select="//Results/Result"/>
				<xsl:if test="$LABRESULTS or $TXTRESULTS">
					<Results>
						<!-- Lab results -->
						<xsl:for-each select="$LABRESULTS">
							<Result>
								<!-- Link to parent encounter -->
								<xsl:for-each select="../..">
									<InternalCCRLink>
										<LinkID><xsl:value-of select="generate-id()"/></LinkID>
									</InternalCCRLink>
								</xsl:for-each>

								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Collection Time</Text>
									</Type>
									<ExactDateTime>
										<xsl:value-of select="EnteredOn"/>
									</ExactDateTime>
								</DateTime>
								<DateTime>
									<Type>
										<Text>Assessment Time</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="ResultTime"/></ExactDateTime>
								</DateTime>
								<Description>
									<Text><xsl:value-of select="InitiatingOrder/OrderItem/Description"/></Text>
								</Description>
								<Source/>
								<xsl:for-each select="ResultItems/LabResultItem">
									<Test>
										<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
										<Type>
											<Text>Result</Text>
										</Type>
										<Description>
											<Text><xsl:value-of select="TestItemCode/Description"/></Text>
											<Code>
												<Value><xsl:value-of select="TestItemCode/Code"/></Value>
												<CodingSystem><xsl:value-of select="TestItemCode/CDACodingStandard"/></CodingSystem>
											</Code>
										</Description>
										<Source/>
										<TestResult>
											<Value><xsl:value-of select="ResultValue"/></Value>
											<xsl:if test="ResultValueUnits != ''">
												<Units>
													<Unit><xsl:value-of select="ResultValueUnits"/></Unit>
												</Units>
											</xsl:if>
										</TestResult>
										<Flag>
											<Text><xsl:value-of select="ResultInterpretation"/></Text>
										</Flag>
									</Test>
								</xsl:for-each>
							</Result>
						</xsl:for-each>
					
						<!-- Text results -->
						<xsl:for-each select="$TXTRESULTS">
							<Result>
								<!-- Link to parent encounter -->
								<xsl:for-each select="../..">
									<InternalCCRLink>
										<LinkID><xsl:value-of select="generate-id()"/></LinkID>
									</InternalCCRLink>
								</xsl:for-each>

								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Collection Time</Text>
									</Type>
									<ExactDateTime>
										<xsl:value-of select="SpecimenCollectedTime"/>
									</ExactDateTime>
								</DateTime>
								<DateTime>
									<Type>
										<Text>Assessment Time</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="ResultTime"/></ExactDateTime>
								</DateTime>
								<Description>
									<Text><xsl:value-of select="InitiatingOrder/OrderItem/Description"/></Text>
								</Description>
								<Source/>
								<Test>
									<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
									<Type>
										<Text>Result</Text>
									</Type>
									<Description>
										<Text><xsl:value-of select="InitiatingOrder/OrderItem/Description"/></Text>
										<Code>
											<Value><xsl:value-of select="InitiatingOrder/OrderItem/Code"/></Value>
											<CodingSystem><xsl:value-of select="InitiatingOrder/OrderItem/CDACodingStandard"/></CodingSystem>
										</Code>
									</Description>
									<Source/>
									<TestResult>
										<Description>
											<Text>
	<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
	<xsl:value-of select="ResultText"/>
	<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
											</Text>
										</Description>
									</TestResult>
								</Test>
							</Result>
						</xsl:for-each>					
					</Results>
				</xsl:if>

				<!-- Procedures section here -->
				<xsl:variable name="PROCEDURES" select="//Procedures/Procedure"/>
				<xsl:if test="$PROCEDURES">
					<Procedures>
						<xsl:for-each select="$PROCEDURES">
							<Procedure>
								<!-- Link to parent encounter -->
								<xsl:for-each select="../..">
									<InternalCCRLink>
										<LinkID><xsl:value-of select="generate-id()"/></LinkID>
									</InternalCCRLink>
								</xsl:for-each>

								<CCRDataObjectID><xsl:value-of select="generate-id()"/></CCRDataObjectID>
								<DateTime>
									<Type>
										<Text>Procedure Date</Text>
									</Type>
									<ExactDateTime><xsl:value-of select="ProcedureTime"/></ExactDateTime>
								</DateTime>
								<Type>
									<xsl:value-of select="ProcedureIdentifier"/>
								</Type>
								<Description>
									<Text><xsl:value-of select="Procedure/Description"/></Text>
									<Code>
										<Value><xsl:value-of select="Procedure/Code"/></Value>
										<CodingSystem><xsl:value-of select="Procedure/CDACodingStandard"/></CodingSystem>
									</Code>
								</Description>
								<Source/>
								<Locations>
									<Location>
										<Actor>
											<ActorID>HCF_<xsl:value-of select="EnteredAt/Code"/></ActorID>
											<ActorRole>
												<Text>Healthcare Provider</Text>
											</ActorRole>
										</Actor>
									</Location>
								</Locations>
								<Practitioners>
									<Practitioner>
										<ActorID>HCP_<xsl:value-of select="Clinician/Code"/></ActorID>
										<ActorRole>
											<Text>Physician</Text>
										</ActorRole>
									</Practitioner>
								</Practitioners>
							</Procedure>
						</xsl:for-each>
					</Procedures>
				</xsl:if>

				<!-- PlanofCare section here -->
				<!-- TDB: SDA doesn't support types of orders!
				<PlanOfCare>
					<xsl:for-each select="//Plan">
						<Plan>
							<xsl:for-each select="Orders">
								<OrderRequest>
									
								</OrderRequest>
							</xsl:for-each>
						</Plan>
					</xsl:for-each>
				</PlanOfCare>
			    -->
				
				<!-- HealthcareProviders section here -->
			</Body>

			<Actors>
				<!-- The patient -->
				<Actor>
					<ActorObjectID>PAT_<xsl:value-of select="PatientNumber/PatientNumber[NumberType = 'MRN']/Number"/></ActorObjectID>
					<Person>
						<Name>
							<CurrentName>
								<xsl:if test="Name/NamePrefix != ''">
									<Title><xsl:value-of select="Name/NamePrefix"/></Title>
								</xsl:if>
								<Given><xsl:value-of select="Name/GivenName"/></Given>
								<Middle><xsl:value-of select="Name/MiddleName"/></Middle>
								<Family><xsl:value-of select="Name/FamilyNamePrefix"/> <xsl:value-of select="Name/FamilyName"/></Family>
								<xsl:if test="Name/NameSuffix != ''">
									<Suffix><xsl:value-of select="Name/NameSuffix"/></Suffix>
								</xsl:if>
							</CurrentName>
						</Name>
						<DateOfBirth>
							<ExactDateTime><xsl:value-of select="BirthTime"/></ExactDateTime>
						</DateOfBirth>
						<Gender>
							<Text><xsl:value-of select="Gender/Description"/></Text>
							<Code>
								<Value><xsl:value-of select="Gender/Code"/></Value>
								<CodingSystem><xsl:value-of select="Gender/CDACodingStandard"/></CodingSystem>
							</Code>
						</Gender>
					</Person>

					<xsl:for-each select="PatientNumber/PatientNumber">	
						<IDs>
							<Type>
								<Text><xsl:value-of select="NumberType"/></Text>
							</Type>
							<ID><xsl:value-of select="Number"/></ID>
							<xsl:if test="Organization">
								<IssuedBy>
									<ActorID>ORG_<xsl:value-of select="Organization/Code"/></ActorID>
								</IssuedBy>
							</xsl:if>
							<Source/>
						</IDs>
					</xsl:for-each>

					<Relation>
						<Text>Patient</Text>
					</Relation>
										
					<xsl:for-each select="Address/Address">	
						<Address>
							<Line1><xsl:value-of select="Street"/></Line1>
							<City><xsl:value-of select="City/Description"/></City>
							<State><xsl:value-of select="State/Description"/></State>
							<PostalCode><xsl:value-of select="Zip/Description"/></PostalCode>
						</Address>
					</xsl:for-each>
					
					<xsl:if test="normalize-space(ContactInfo/HomePhoneNumber) != ''">
						<Telephone>
							<Value><xsl:value-of select="normalize-space(ContactInfo/HomePhoneNumber)"/></Value>
							<Type>
								<Text>Home</Text>
							</Type>
						</Telephone>
					</xsl:if>
					<xsl:if test="normalize-space(ContactInfo/WorkPhoneNumber) != ''">
						<Telephone>
							<Value><xsl:value-of select="normalize-space(ContactInfo/WorkPhoneNumber)"/></Value>
							<Type>
								<Text>Work</Text>
							</Type>
						</Telephone>
					</xsl:if>
					<xsl:if test="normalize-space(ContactInfo/EmailAddress) != ''">
						<EMail>
							<Value><xsl:value-of select="normalize-space(ContactInfo/EmailAddress)"/></Value>
						</EMail>
					</xsl:if>
					
					<Source/>
				</Actor>

				<!-- Render each healthcare organization -->
				<xsl:for-each select="Encounters/Encounter/HealthCareFacility | PatientNumber/PatientNumber">
					<Actor>
						<ActorObjectID>ORG_<xsl:value-of select="Organization/Code"/></ActorObjectID>
						<Organization>
							<Name><xsl:value-of select="Organization/Description"/></Name>
						</Organization>
						<Source/>
					</Actor>
				</xsl:for-each>

				<!-- Render each healthcare provider -->
				<xsl:for-each select="Encounters/Encounter">
					<xsl:variable name="HCF" select="HealthCareFacility"/>
					<xsl:for-each select="AdmittingClinician | AttendingClinicians/* | ConsultingClinicians/* | ReferringClinician | Procedures/Procedure/Clinician">
						<Actor>
							<ActorObjectID>HCP_<xsl:value-of select="Code"/></ActorObjectID>
							<Person>
								<Name>
									<CurrentName>
										<Given>
											<xsl:value-of select="normalize-space(substring-before(Description,','))"/>
										</Given>
										<Middle></Middle>
										<Family>
											<xsl:value-of select="normalize-space(substring-after(Description,','))"/>
										</Family>
									</CurrentName>
								</Name>
							</Person>
							<IDs>
								<Type>
									<Text>ID</Text>
								</Type>
								<ID><xsl:value-of select="Code"/></ID>
								<IssuedBy>
									<ActorID>HCF_<xsl:value-of select="$HCF/Code"/></ActorID>
								</IssuedBy>
								<Source/>
							</IDs>
							<Relation>
								<Text>Primary Care Provider</Text>
							</Relation>
							<Specialty>
								<Text><xsl:value-of select="CareProviderType/Description"/></Text>
							</Specialty>
							<Source/>
						</Actor>
					</xsl:for-each>
				</xsl:for-each>
				
				<!-- Static To/From actors -->
				<Actor>
					<ActorObjectID>AA_FROM</ActorObjectID>
					<Organization>
						<Name><xsl:value-of select="$ORGANIZATION"/></Name>
					</Organization>
					<Source/>
				</Actor>

				<Actor>
					<ActorObjectID>AA_TO</ActorObjectID>
					<Organization>
						<Name>Primary Care Provider</Name>
					</Organization>
					<Source/>
				</Actor>

			</Actors>

			<!-- References section here -->

			<!-- Comments section here -->
		<xsl:variable name="DOCUMENTS" select ="//Documents/Document[string-length(NoteText) > 0]"/>
		<xsl:if test="$CONSENTAPPLIED  or  $DOCUMENTS"> 
			<Comments>
				<xsl:if test="$CONSENTAPPLIED"> 
					<Comment>
						<CommentObjectID>Consent_Disclaimer</CommentObjectID>
						<DateTime>
							<ExactDateTime><xsl:value-of select="$TIMESTAMP"/></ExactDateTime>
						</DateTime>					
						<Description>
							<Text>A consent policy has been applied to this report, and therefore some important information might be missing.</Text>
						</Description>
						<Source>
							<ActorID>PAT_<xsl:value-of select="PatientNumber/PatientNumber[NumberType = 'MRN']/Number"/></ActorID>
						</Source>
					</Comment>
				</xsl:if>
				<xsl:if test="$DOCUMENTS"> 		
						<xsl:for-each select="$DOCUMENTS">
							<Comment>
								<CommentObjectID><xsl:value-of select="generate-id()"/></CommentObjectID>
								<DateTime>
									<ExactDateTime><xsl:value-of select="EnteredOn"/></ExactDateTime>
								</DateTime>					
								<Description>
									<Text>
										<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
										<xsl:value-of select="NoteText"/>
										<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
									</Text>
								</Description>
								<Source>
									<ActorID><xsl:value-of select="EnteredAt/Code"/></ActorID>
								</Source>
							</Comment>
						</xsl:for-each>
				</xsl:if>
			</Comments>
		</xsl:if> 

			<!-- Signatures section here -->

		</ContinuityOfCareRecord>

	</xsl:template>	

</xsl:stylesheet>
