<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="ProblemsMinAge" select="-9999"/>
	<xsl:param name="ProblemsMaxAge" select="99999"/>
	<xsl:param name="ProblemsCount"  select="99999"/>
	<xsl:param name="ProblemsCode"   select="',248536006,373930000,'"/>
	<xsl:param name="FIMProbMaxAge" select="$_36months"/>
	<xsl:param name="FIMProbCount"  select="3"/>

	<xsl:template match="Problems/Problem" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="EnteredOn" />
				<xsl:with-param name="code" select="'Category/Code'" />
			</xsl:apply-templates>
			<xsl:attribute name="status"><xsl:apply-templates mode="problemActive" select="Status"/></xsl:attribute>
			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Problems" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			
			<!--1st do FIM, it has a shorter count/time frame-->
			<xsl:for-each select="Problem
				[
					    @age &lt;= $FIMProbMaxAge
					and @age >= $ProblemsMinAge 
					and ((contains($ProblemsCode,concat(',',@code,','))))
				]">
	
				<xsl:sort select="@date"/>
	
	            	<xsl:if test="position() &lt;= $FIMProbCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="Problem
				[
					    @age &lt;= $ProblemsMaxAge
					and @age >= $ProblemsMinAge 
					and (($ProblemsCode = '') or not(contains($ProblemsCode,concat(',',@code,',')))) 
				]">
	
				<xsl:sort select="@status"/>
				<xsl:sort select="Problem/Description"/>
	
	            	<xsl:if test="position() &lt;= $ProblemsCount">
					<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>

	<!-- map status to active, inactive, or unknown using SNOMED codes or descriptions -->
	<xsl:template mode="problemActive" match="Status">
		<xsl:variable name="code"><xsl:value-of select="Code"/></xsl:variable>
		<xsl:variable name="desc"><xsl:apply-templates mode="ucase" select="Description"/></xsl:variable>
		<xsl:choose>
			
			<!--  inactive first since it contains('active') -->
			<xsl:when test="$code = 73425007 or contains($desc,'INACTIVE')">inactive</xsl:when>
			<xsl:when test="$code = 410516002 or contains($desc,'RULED OUT')">inactive</xsl:when>
			<xsl:when test="$code = 413322009 or contains($desc,'RESOLVED')">inactive</xsl:when>
			
			<!-- actives -->
			<xsl:when test="$code = 55561003 or contains($desc,'ACTIVE')">active</xsl:when>
			<xsl:when test="$code = 90734009 or contains($desc,'CHRONIC')">active</xsl:when>
			<xsl:when test="$code = 7087005 or contains($desc,'INTERMITTENT')">active</xsl:when>
			<xsl:when test="$code = 255227004 or contains($desc,'RECURRENT')">active</xsl:when>
			<xsl:when test="$code = 415684004 or contains($desc,'SUSPECTED')">active</xsl:when>
			
			<xsl:otherwise>unknown</xsl:otherwise>

		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
