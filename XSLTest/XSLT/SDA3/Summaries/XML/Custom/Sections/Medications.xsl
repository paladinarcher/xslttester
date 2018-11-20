<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="MedicationsMaxAge" select="$_15months"/>
	<xsl:param name="MedicationsMinAge" select="0"/>

	<xsl:param name="MedicationsCount"  select="999999"/>
	<xsl:param name="MedicationsCode"   select="''"/>

	<xsl:param name="MedicationsMaxAgeNonVA" select="999999"/>

	<xsl:param name="docType_C32" select="'false'"/>

	<xsl:template match="Medication" mode="pass1">
		<xsl:copy>
			<xsl:apply-templates mode="attributes" select=".">
				<xsl:with-param name="date" select="FromTime" />
				<xsl:with-param name="code" select="''" />
			</xsl:apply-templates>
			<xsl:attribute name="nonVA">
				<xsl:value-of select="contains(OrderCategory/Description,'NON-VA MEDICATIONS')"/>
			</xsl:attribute>

                        <xsl:attribute name="is_C32">
                                <xsl:value-of select="$docType_C32"/>
                        </xsl:attribute>

			<xsl:apply-templates mode="pass1" select="node()|@*" />
		</xsl:copy>		
	</xsl:template>

	<xsl:template match="Medications" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="pass2"/>
			<xsl:for-each select="Medication
				[
					((@nonVA = 'false' and @age &lt;= $MedicationsMaxAge)
						or (@is_C32 ='false' and @nonVA = 'true'  and @age &lt;= $MedicationsMaxAgeNonVA)
						or (@is_C32 ='true' and @nonVA = 'true' and @age &lt;= $MedicationsMaxAge)
					) 
						and @age >= $MedicationsMinAge 
						and (($MedicationsCode = '') or (contains($MedicationsCode,concat(',',@code,','))))
				]">
				<!-- va meds first -->
				<!--
				<xsl:sort select="@nonVA" order="ascending"/>
				-->
				<xsl:sort select="OrderItem/Description" order="ascending"/>
            	<xsl:if test="position() &lt;= $MedicationsCount">
            		<xsl:copy>
						<xsl:apply-templates select="node()|@*" mode="pass2"/>
					</xsl:copy>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>	
	</xsl:template>
</xsl:stylesheet>
