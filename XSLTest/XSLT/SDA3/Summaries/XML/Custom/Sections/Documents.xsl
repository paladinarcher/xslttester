<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--these need to be revisted once the custom query dates are implemented.  For most sections, if the non-MHV user enters
			QD's, count limit should = 0 for all sections.  Exceptions are doc types of PN,C,W,A and D are always limited to 50, and Medication
		  	and Plan of Care section defaults remain the same.
		  	
		Default Limits:  
			Observations = 5 count and 12 months.  If Custom QD's no count limit.
			
			Encounters (sect 1) = unlimited count and 18 months
			Encounter Associated Documents (sect 2) = all doc types that are linked to an enounter in Sect 1 (LR,RA,SR,CP,CR,HP,CM,DS,PN,C,W,A & D).
						 					  		  Limit is 5 per encounter with a max of 10 encounters, so 50 count limit.
						 					  		  Default age is 18 months.  Even if user enters custom QD's, only display
						 					  		  documents associated with the 1st 10 encounters in Sect 1,so default count is always 50 for
						 					  		  these doc type:  PN, C, W, A and D.
			Encounter Document Types/Titles (sect 3 & 4) = doc types of CR, HP & DS have default counts of 5 for CR and 2 for the others,							
															UNLESS the user entered custom QD's, then there is no count limit.
															Doc types of CR, HP & DS display all document note titles in sect 4, so ultimately there 
															is no count or age limit for these 3 document types.  If the user enters QD's, sect 4
															does NOT display.
			
			Results:  Lab Chem/Hem = 10 count and 24 months.  If Custom QD's no count limit.
					  Radiology & Pathology = these results come from the Document container.  default count is 5 and age is 24 months.
					  	HOWEVER, these documents can also appear in the Associated Encounter Documents (Encounter sect 2), so true default
					  	count is 50 UNLESS the user entered custom QD's, then there is no count limit.
			
			Procedures:	Surgical Procedures (sect 1) = 5 count and 18 months. 
						Surg Proc Notes (sect 2) = 5 most recent SR docs per SP in section 1, so default count is 25.  HOWEVER, since these docs
													can also appear in Encounters Sect 2, true default count limit is 50 UNLESS the user entered
													custom QD's, then there is no count limit.
						Clin Proc Documents (sect 3 & 4) = Full doc displays for the 1st 10 and 18 months (sect 3).  Titles for the rest display
															in sect 4, therefore, there is no default count or age for doc types of CP. If the
															user enters custom QD's do NOT display section 4.
			
			Functional Status:  3 count and 36 months.  If Custom QD's no count limit.
			
			Medications = unlimited count and 15 months for VA meds.  Non-VA dispsensed Meds are unlimited count and no time limit.
							Custom QD's do NOT affect this section.
							
			Plan of Care:  Custom QD's do NOT affect this section
						   Appointments (sect 1) = 20 count and up to 6 months in the future.  
						   Active, Pending and Scheduled orders (sect 2) = 45 days in the past or future.  No count limit.
			
			
	-->

	<xsl:param name="DocumentsMinAge" select="0"/>
	<xsl:param name="LRDocumentsMinAge" select="0"/>
	<xsl:param name="CMDocumentsMinAge" select="0"/>

	<xsl:param name="DocumentsMaxAge" select="$_18months"/>
	<xsl:param name="LRDocumentsMaxAge" select="$_24months"/>
	
	<xsl:param name="NODocumentsCount"  select="999999"/>
	<xsl:param name="DocumentsCount"  select="50"/>
	<xsl:param name="LRDocumentsCount"  select="50"/>	
	<xsl:param name="SRDocumentsCount"  select="50"/>

	
	<xsl:param name="DocumentsCode"   select="''"/>
	<xsl:param name="NODocumentsCode"   select="',CR,CP,HP,DS,'"/>


	<xsl:template match="Document" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="DocumentType/Code"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Documents" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<!-- first Surg Path Docs since it has a different age -->

				<xsl:for-each select="Document
					[
							(@code = 'LR' or @code = 'RA')
						and @age &lt;= $LRDocumentsMaxAge
						and @age >= $LRDocumentsMinAge 
						and (($DocumentsCode = '') or (contains($DocumentsCode,concat(',',@code,',')))) 
					]">
					<xsl:sort select="FromTime" order="descending"/>
					<xsl:sort select="ExternalId" order="descending"/>
					
	           			<xsl:if test="position() &lt;= $LRDocumentsCount">
						<xsl:copy>
							<xsl:apply-templates select="node()|@*" mode="pass2"/>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
				
				<!-- then Cmp and Pen Docs since it has a different age -->

				<xsl:for-each select="Document
					[
							@code = 'CM'
						and @age &lt;= $DocumentsMaxAge
						and @age >= $CMDocumentsMinAge 
						and (($DocumentsCode = '') or (contains($DocumentsCode,concat(',',@code,',')))) 
					]">
					<xsl:sort select="FromTime" order="descending"/>
					<xsl:sort select="ExternalId" order="descending"/>
					
	           			<xsl:if test="position() &lt;= $DocumentsCount">
						<xsl:copy>
							<xsl:apply-templates select="node()|@*" mode="pass2"/>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
				
			<xsl:for-each select="Document
				[
						not(@code = 'LR')
					and not(@code = 'CM')
					and not(@code = 'RA')
					and @age &lt;= $DocumentsMaxAge
					and @age >= $DocumentsMinAge 
					and (($DocumentsCode = '') or (contains($DocumentsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="ExternalId" order="descending"/>
				
				<!--Surgical Proc and Encounter Docs have a different count, all others have no limit
				-->
				<xsl:choose>
					<xsl:when test="(@code= 'SR')">
						<xsl:if test="position() &lt;= $SRDocumentsCount">
							<xsl:copy>
								<xsl:apply-templates select="node()|@*" mode="pass2"/>
							</xsl:copy>
						</xsl:if>
					</xsl:when>
					<xsl:when test="(contains($NODocumentsCode,concat(',',@code,',')))">
						<xsl:if test="position() &lt;= $NODocumentsCount">
							<xsl:copy>
								<xsl:apply-templates select="node()|@*" mode="pass2"/>
							</xsl:copy>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
	            		<xsl:if test="position() &lt;= $DocumentsCount">
							<xsl:copy>
								<xsl:apply-templates select="node()|@*" mode="pass2"/>
							</xsl:copy>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
