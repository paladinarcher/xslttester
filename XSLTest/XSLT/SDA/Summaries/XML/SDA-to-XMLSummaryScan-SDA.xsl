<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:isc="http://extension-functions.intersystems.com"
				version="1.0"
				exclude-result-prefixes="isc">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="sectionTypes"/>

<xsl:template match="Patients/Patient">
	<xsl:copy>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<!-- Add sequence to individual Patient attributes -->
<xsl:template match="Race | Religion | PrimaryLanguage |  MaritalStatus">
	<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name()='MaritalStatus'">Marital Status</xsl:when>
				<xsl:when test="local-name()='PrimaryLanguage'">Language</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
	</xsl:variable>
	<xsl:copy>
		<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PAT','','','',$type,Description)"/>
		</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

<xsl:template match="Allergies/Allergies">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ALG,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="FromTime"/>
			<xsl:variable name="category" select="Allergy/AllergyCategory/Description"/>
			<xsl:variable name="desc" select="Allergy/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','ALG',$source,'',$date,$category,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Alerts/Alert">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ART,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="FromTime"/>
			<xsl:variable name="type" select="AlertType/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','ART',$source,'',$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="PastHistory/PastHistory | FamilyHistory/FamilyHistory | SocialHistory/SocialHistory">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',HIS,')">
			<xsl:variable name="source" select="EnteredAt/Code"/>
			<xsl:variable name="date" select="FromTime"/>
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="Condition">Medical</xsl:when>
					<xsl:when test="Diagnosis">Family</xsl:when>
					<xsl:when test="SocialHabit">Social</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','HIS',$source,'',$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Encounters/Encounter">
	<xsl:copy>
		<xsl:if test="not(EncounterType = 'S' or EncounterType = 'G')">
			<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',ENC,')">
				<xsl:variable name="source" select="HealthCareFacility/Organization/Code"/>
				<xsl:variable name="sourceType" select="EncounterType"/>
				<xsl:variable name="date" select="StartTime"/>
				<xsl:variable name="visitNum" select="VisitNumber"/>
				<xsl:attribute name="sequence">
					<xsl:value-of select="isc:evaluate('addFilterEntity','ENC',$source,$sourceType,$date,$visitNum,$sourceType)"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Diagnoses/Diagnosis">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DXG,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="ObservationTime"/>
			<xsl:variable name="code" select="Diagnosis/Code"/>
			<xsl:variable name="desc" select="Diagnosis/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','DXG',$source,$sourceType,$date,$code,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Observations/Observation">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DOC,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType" /> 
			<xsl:variable name="date" select="ObservationTime"/>
			<xsl:variable name="type" select="ObservationCode/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','OBS',$source,$sourceType,$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Problems/Problem">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',PRB,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="FromTime"/>
			<xsl:variable name="type" select="Problem/Description"/>
			<xsl:variable name="status" select="Status/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','PRB',$source,$sourceType,$date,$type,$status)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Documents/Document">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',DOC,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType" /> 
			<xsl:variable name="date" select="TranscriptionTime"/>
			<xsl:variable name="type" select="DocumentType/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','DOC',$source,$sourceType,$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template>

<xsl:template match="Medications/Medication[OrderItem/OrderType = 'MED']">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',MED,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="StartTime" />
			<xsl:variable name="desc"> 
				<xsl:choose>
					<xsl:when test="DrugProduct/Description">
						<xsl:value-of select="DrugProduct/Description"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="OrderItem/Description"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','MED',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>	
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Medications/Medication[OrderItem/OrderType = 'VXU']">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',VXU,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="EnteredAt"><xsl:value-of select="EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="StartTime" />
			<xsl:variable name="desc"> 
				<xsl:choose>
					<xsl:when test="DrugProduct/Description">
						<xsl:value-of select="DrugProduct/Description"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="OrderItem/Description"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','VXU',$source,$sourceType,$date,$desc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy> 
</xsl:template> 

<xsl:template match="Results/Result[InitiatingOrder/OrderItem/OrderType = 'RAD']">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',RAD,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="InitiatingOrder/EnteredAt"><xsl:value-of select="InitiatingOrder/EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="InitiatingOrder/StartTime" />
			<xsl:variable name="proc" select="InitiatingOrder/OrderItem/Description"/>

			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','RAD',$source,$sourceType,$date,$proc)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template> 

<xsl:template match="Results/Result[InitiatingOrder/OrderItem/OrderType = 'OTH']">
	<xsl:copy>
		<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',OTH,')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="InitiatingOrder/EnteredAt"><xsl:value-of select="InitiatingOrder/EnteredAt/Code"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sourceType" select="../../EncounterType"/>
			<xsl:variable name="date" select="InitiatingOrder/StartTime" />
			<xsl:variable name="type" select="InitiatingOrder/OrderItem/Description"/>
			<xsl:attribute name="sequence">
				<xsl:value-of select="isc:evaluate('addFilterEntity','OTH',$source,$sourceType,$date,$type)"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template> 

<xsl:template match="Results/LabResult">
	<xsl:copy>
		<xsl:variable name="source">
			<xsl:choose>
				<xsl:when test="InitiatingOrder/EnteredAt"><xsl:value-of select="InitiatingOrder/EnteredAt/Code"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="../../EnteredAt/Code"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sourceType" select="../../EncounterType"/>
		<xsl:variable name="date" select="InitiatingOrder/SpecimenCollectedTime" />
		<xsl:apply-templates/>
		<ResultItems>
			<xsl:for-each select="ResultItems/LabResultItem">
				<xsl:copy>
					<xsl:if  test="string-length($sectionTypes)= 0 or contains(concat(',',$sectionTypes,','),',LAB,')">
						<xsl:variable name="testItem" select="TestItemCode/Description"/>
						<xsl:variable name="result" select="concat(ResultValue,' ',ResultValueUnits)"/>
						<xsl:variable name="range" select="ResultNormalRange"/>
						<xsl:attribute name="sequence">
							<xsl:value-of select="isc:evaluate('addFilterEntity','LAB',$source,$sourceType,$date,$testItem,$result,$range)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</xsl:copy>
			</xsl:for-each>
		</ResultItems>
	</xsl:copy>
</xsl:template> 

<!-- Copy child nodes (other then ResultItems, handled above) -->
<xsl:template match="node()|@*">
	<xsl:if test="local-name()!='ResultItems'">
		<xsl:copy> 
 			<xsl:apply-templates select="node()|@*"/>
     	 </xsl:copy>
	</xsl:if>
 </xsl:template>

</xsl:stylesheet>
