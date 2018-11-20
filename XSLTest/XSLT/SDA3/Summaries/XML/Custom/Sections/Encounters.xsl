<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="EncountersMinAge" select="0"/>
	<xsl:param name="EncountersMaxAge" select="$_18months"/>

	<!--  limit is 10 for MHV only
	<xsl:param name="EncountersCount"  select="10"/>
	-->	
	<xsl:param name="EncountersCount"  select="999999"/>
	<xsl:param name="EncountersCode"   select="',,A,I,H,T,E,'"/>

	<xsl:template match="Encounter" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="EncounterCodedType/Code" />
			</xsl:apply-templates>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Encounters" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Encounter
				[
					    @age &lt;= $EncountersMaxAge
					and @age >= $EncountersMinAge 
					and (($EncountersCode = '') or (contains($EncountersCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="FromTime" order="descending"/>
				<xsl:sort select="EncounterNumber" order="descending"/>
	
	            	<xsl:if test="position() &lt;= $EncountersCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
			
			<!--  ensure at least one encounter so xsl:key('EncNum') works in the CDA stylesheets -->
			<Encounter>
				<EncounterType>S</EncounterType>
				<EncounterNumber>Silent</EncounterNumber>
			</Encounter>

		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>