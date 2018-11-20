<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform DSMLv2 modifyRequest, modDNRequest, delRequest -->
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				 xmlns:isc="http://extension-functions.intersystems.com" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core"
				 xmlns:exsl="http://exslt.org/common"
				 extension-element-prefixes="exsl"
				exclude-result-prefixes="xsi isc dsml exsl"
				version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<xsl:variable name="nameFields">,cn,sn,givenname,initials,title,</xsl:variable>

<!-- Process delRequest -->
<xsl:template match="dsml:delRequest">
	<xsl:if test="isc:evaluate('varReset', 'HPDErrorMessage')"></xsl:if>
	 <xsl:variable name="class">
		<xsl:call-template name="getClass">
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
	</xsl:variable>
	<DeleteRequest>
		<Type><xsl:value-of select="$class"/></Type>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:call-template name="getRdn">
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="dn" select="@dn"/>
			</xsl:call-template>
		</UniqueID>
		<xsl:call-template name="NoClassErrorMessage">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</DeleteRequest>
</xsl:template>

<!-- Process modDNRequest -->
<xsl:template match="dsml:modDNRequest">
	<xsl:if test="isc:evaluate('varReset', 'HPDErrorMessage')"></xsl:if>
	 <xsl:variable name="class">
		<xsl:call-template name="getClass">
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="uidAttr">
		<xsl:call-template name="getUidAttr">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="attr">
		<xsl:call-template name="lookupAttr">
			<xsl:with-param name="name" select="$uidAttr"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>	
	</xsl:variable>
	
	<ModifyRequest>
		<MessageType>MDN</MessageType>
		<Type><xsl:value-of select="$class"/></Type>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:call-template name="getRdn">
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="dn" select="@dn"/>
			</xsl:call-template>
		</UniqueID>
		<Modifications>
			<Modification>
				<Action>A</Action>   <!-- this is how single-valued fields are replaced -->
				<Attribute><xsl:value-of select="$attr"/></Attribute>
				<Values>
					<ValuesItem>
						<xsl:attribute name="ValuesKey"><xsl:value-of select="$attr"/></xsl:attribute>
						<xsl:call-template name="getRdn">
							<xsl:with-param name="class" select="$class"/>
							<xsl:with-param name="dn" select="@newrdn"/>
						</xsl:call-template>
					</ValuesItem>
				</Values>
			</Modification>
		</Modifications>
		<xsl:call-template name="NoClassErrorMessage">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</ModifyRequest>
</xsl:template>

<!-- Process modifyRequest -->
<xsl:template match="dsml:modifyRequest">
	<!-- This variable will be used to accumulate pre-processed error messages -->
	<xsl:if test="isc:evaluate('varReset', 'HPDErrorMessage')"></xsl:if>
	 <xsl:variable name="class">
		<xsl:call-template name="getClass">
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
	</xsl:variable>
    
    <!-- Find invalid attributes -->
	<xsl:apply-templates select="dsml:modification" mode="Invalid">
		<xsl:with-param name="class" select="$class"/>
	</xsl:apply-templates>
		
	<ModifyRequest>
		<MessageType>MOD</MessageType>
		<Type><xsl:value-of select="$class"/></Type>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:call-template name="getRdn">
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="dn" select="@dn"/>
			</xsl:call-template>
		</UniqueID>
		<!-- the check prevents a hard error on Correlate if an attribute wasn't found -->
		<xsl:if test="string-length(isc:evaluate('varGet', 'HPDErrorMessage'))=0">
			<Modifications>
				<xsl:if test="$class='I'">
					<!-- Aggregate replacement of individual name fields into lists of values within the same modification -->
					<xsl:apply-templates select="dsml:modification[@operation='replace' and contains($nameFields,concat(',',translate(@name,$uppercase,$lowercase),','))]" mode="ReplaceFields">
						<xsl:with-param name="attr" select="'Name'"/>
					</xsl:apply-templates> 
					<!-- Aggregate additions of individual name fields into rows of complete names. (Must have a last name to be considered.) -->
					<xsl:apply-templates select="dsml:modification[@operation='add' and translate(@name,$uppercase,$lowercase)='sn']/dsml:value" mode="AddFields">
						<xsl:with-param name="attr" select="'Name'"/>
						<xsl:with-param name="fields" select="$nameFields"/>
					</xsl:apply-templates>	
				</xsl:if>			
			
				<!-- Normal processing of modifications (including deletes of individual name properties) -->
				<xsl:apply-templates select="dsml:modification">
					<xsl:with-param name="class" select="$class"/>
				</xsl:apply-templates>
			</Modifications>
		</xsl:if>
		<xsl:call-template name="NoClassErrorMessage">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</ModifyRequest>
</xsl:template>

<!-- Aggregate replacement of individual name fields into lists of values within the same modification -->
<xsl:template match="dsml:modification" mode="ReplaceFields">
	<xsl:param name="attr"/>
	<xsl:variable name="field">
		<xsl:apply-templates select="$attrs-top" mode="getField">
			 <xsl:with-param name="curr-attr" select="concat('I',translate(@name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	<Modification>
		<Action>R</Action>
		<Attribute><xsl:value-of select="$attr"/></Attribute>
		<Values>
			<xsl:for-each select="dsml:value">
				<ValuesItem>
					<xsl:attribute name="ValuesKey"><xsl:value-of select="concat($field,'_',position())"/></xsl:attribute>
					<xsl:value-of select="."/>
				</ValuesItem>
			</xsl:for-each>
		</Values>
	</Modification>	
</xsl:template>

<!-- Combine several added Name attributes to form names to be added to an individual provider -->
<xsl:template match="dsml:value" mode="AddFields">
	<xsl:param name="attr"/>
	<xsl:param name="fields"/>
	<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
	<Modification>
		<Action>A</Action>
		<Attribute><xsl:value-of select="$attr"/></Attribute>
		<Values>
			<xsl:for-each select="../../dsml:modification[@operation='add' and contains($fields,concat(',',translate(@name,$uppercase,$lowercase),','))]/dsml:value[position() = $pos]">
				<ValuesItem>
					<xsl:attribute name="ValuesKey">
						<xsl:apply-templates select="$attrs-top" mode="getField">
						   <xsl:with-param name="curr-attr" select="concat('I',translate(../@name,$uppercase,$lowercase))"/>
						</xsl:apply-templates>				
					</xsl:attribute>
					<xsl:value-of select="."/>
				</ValuesItem>
			</xsl:for-each>
		</Values>
	</Modification>	
</xsl:template>

<!-- Process a modification -->
<xsl:template match="dsml:modification">
	<xsl:param name="class"/>
	<xsl:variable name="attrTemp">
		<xsl:call-template name="lookupAttr">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="attr">
	<!-- A Practice is a Member (of Type PracticeMbr) for purposes of modification.   It needs to be distinct for Search -->
		<xsl:choose>
			<xsl:when test="$attrTemp='Practice'">Member</xsl:when>
			<xsl:otherwise><xsl:value-of select="$attrTemp"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="name" select="translate(@name,$uppercase,$lowercase)"/>
	<xsl:variable name="nodeType">
		<xsl:apply-templates select="$attrs-top" mode="getNodeType">
			<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="attrType">
		<xsl:apply-templates select="$attrs-top" mode="getType">
			<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
		</xsl:apply-templates>
	</xsl:variable>
	
	<!-- When replacing, delete the old field, except for a Single field or Credential Name/Number (the only compound fields in a main table), where the Add will serve to overwrite -->
	<xsl:if test="@operation='delete' or (@operation='replace' and not($nodeType='Single' or $attr='CredName' or $attr='CredNumber' or ($class='I' and $attr='Name')))">
		<xsl:apply-templates select="." mode="Modification">
			<xsl:with-param name="action" select="'D'"/>
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="attr" select="$attr"/>
			<xsl:with-param name="nodeType" select="$nodeType"/>
			<xsl:with-param name="attrType" select="$attrType"/>
		</xsl:apply-templates>
	</xsl:if>
	
	<!-- Need to add whether adding or replacing (which is a delete plus an an add), except for Individual names which are handled differently -->
	<xsl:if test="(@operation='add' or @operation='replace') and not($class='I' and $attr='Name')">
		<xsl:apply-templates select="." mode="Modification">
			<xsl:with-param name="action" select="'A'"/>
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="attr" select="$attr"/>
			<xsl:with-param name="nodeType" select="$nodeType"/>
			<xsl:with-param name="attrType" select="$attrType"/>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

     <!-- description is excluded as it is always bundled with its associated provider type code -->
	<xsl:template match="dsml:modification[translate(@name,$uppercase,$lowercase)='description']" mode="Modification"/>
	
<!-- Add Modification element(s) -->
<xsl:template match="dsml:modification" mode="Modification">
	<xsl:param name="action"/>
	<xsl:param name="class"/>
	<xsl:param name="name"/>
	<xsl:param name="attr"/>
	<xsl:param name="nodeType"/>
	<xsl:param name="attrType"/>

	<xsl:choose>
		<!-- Only one modification per modifyRequest when no values, or when deleting values to be replaced (except when dealing with individual name fields) -->
		<xsl:when test="not(dsml:value) or (@operation='replace' and $action='D' and not($attr='Name' and $class='I'))">
			<Modification>
				<Action><xsl:value-of select="$action"/></Action>
				<Attribute><xsl:value-of select="$attr"/></Attribute>
				<!-- May also need to add a type -->
				<Values>
					<xsl:call-template name="AddType">
						<xsl:with-param name="class" select="$class"/>
						<xsl:with-param name="attr" select="$attr"/>
						<xsl:with-param name="attrType" select="$attrType"/>
					</xsl:call-template>

					<!-- The name of the specific field is also needed for individual name fields (with no associated value) -->
					<xsl:if test="$attr='Name' and $class='I'">
						<ValuesItem>				
							<xsl:attribute name="ValuesKey">
								<xsl:apply-templates select="$attrs-top" mode="getField">
									<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
								</xsl:apply-templates>							
							</xsl:attribute>
						</ValuesItem>				
					</xsl:if>							
				</Values>
			</Modification>						
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="dsml:value">
				<Modification>
					<Action><xsl:value-of select="$action"/></Action>
					<Attribute><xsl:value-of select="$attr"/></Attribute>
					<Values>
						<xsl:choose>
							<!-- Pointer to parent Organization -->
							<xsl:when test="$attr='Member' or ($class='R' and $attr = 'Owner')">
								<xsl:variable name="container">
									<xsl:call-template name="extractOrganizationID">
										<xsl:with-param name="dn" select="."/>
									</xsl:call-template>
								</xsl:variable>
									<ValuesItem>
									<xsl:attribute name="ValuesKey">Owner</xsl:attribute>
									<xsl:choose>
										<xsl:when test="exsl:node-set($container)/*/GroupName">
											<xsl:value-of select="concat('R',exsl:node-set($container)/*/GroupName)"/>										
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('O',exsl:node-set($container)/*/UniqueID)"/>
										</xsl:otherwise>
									</xsl:choose>								
								</ValuesItem>
							</xsl:when>
							<!-- Pointer to Member Individual or Organization -->
							<xsl:when test="$attr='Members'">
								<ValuesItem>
									<xsl:attribute name="ValuesKey">PrvMember</xsl:attribute>
									<xsl:call-template name="extractMemberID">
										<xsl:with-param name="dn" select="."/>										
									</xsl:call-template>
								</ValuesItem>				
							</xsl:when>
							<xsl:when test="$nodeType='Compound' or $nodeType='Compound-Modify'">
								<xsl:variable name="container">
									<xsl:call-template name="extractValues">
										<xsl:with-param name="attr" select="$attr"/>
										<xsl:with-param name="value" select="."/>
										<xsl:with-param name="type" select="$attrType"/>
										<xsl:with-param name="update" select="1"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:for-each select="exsl:node-set($container)/*/*">
									<ValuesItem>
										<xsl:attribute name="ValuesKey"><xsl:value-of select="local-name()"/></xsl:attribute>
										<xsl:value-of select="."/>
									</ValuesItem>
								</xsl:for-each>	
							</xsl:when>
							<!-- "Normal" attributes -->
							<xsl:otherwise>
								<ValuesItem>
									<xsl:attribute name="ValuesKey">
										<xsl:choose>
											<!-- Single and list attributes -->
											<xsl:when test="$nodeType='Single' or $nodeType='List'">
												<xsl:value-of select="$attr"/>
											</xsl:when>
											<!-- Multiple attributes -->
											<xsl:otherwise>
												<xsl:apply-templates select="$attrs-top" mode="getField">
												   <xsl:with-param name="curr-attr" select="concat($class,$name)"/>
												</xsl:apply-templates>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:choose>
										<!-- HPDPlus pointer to owner/member -->
										<xsl:when test="$attr='Owner' or $attr='PrvMember'">
											<xsl:call-template name="getUid">
												<xsl:with-param name="dn" select="."/>
											</xsl:call-template>
										</xsl:when>
										<!-- HPDPlus pointer to service -->
										<xsl:when test="$attr='Service'">
											<xsl:call-template name="getRdn">
												<xsl:with-param name="class" select="'S'"/>
												<xsl:with-param name="dn" select="."/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<!-- May need to convert display value to internal value -->
											<xsl:choose>
												<xsl:when test="contains($attrType,',')">
													<xsl:call-template name="convertDisplayValue">
														<xsl:with-param name="value" select="."/>
														<xsl:with-param name="type" select="$attrType"/>
														<xsl:with-param name="attrName" select="$name"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>										
										</xsl:otherwise>
									</xsl:choose>
								</ValuesItem>

								<!-- Provider Type description always goes with its code -->
								<xsl:if test="$attr='ProviderType'">
									<xsl:variable name="operation" select="../@operation"/>
									<xsl:variable name="pos" select="position()"/>
									<xsl:for-each select="../../dsml:modification[@operation=$operation and translate(@name,$uppercase,$lowercase)='description']/dsml:value[position() = $pos]">
										<ValuesItem>
											<xsl:attribute name="ValuesKey">Description</xsl:attribute>
											<xsl:value-of select="."/>
										</ValuesItem>
									</xsl:for-each>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>

						<!-- Add an additional Type value, if any -->			
						<xsl:call-template name="AddType">
							<xsl:with-param name="class" select="$class"/>
							<xsl:with-param name="attr" select="$attr"/>
							<xsl:with-param name="attrType" select="$attrType"/>
						</xsl:call-template>
					</Values>
				</Modification>		
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Possibly add a Type qualifier -->
<xsl:template name="AddType">
	<xsl:param name="class"/>
	<xsl:param name="attr"/>
	<xsl:param name="attrType"/>

	<xsl:variable name="key">
		<xsl:choose>
			<xsl:when test="$attr='Address'">Use</xsl:when>
			<xsl:when test="$attr='Email'">EmailType</xsl:when>
			<xsl:when test="$attr='Phone'">Type</xsl:when>
			<xsl:when test="$attr='Member' or $attr='Members'">Type</xsl:when>
			<xsl:when test="$attr='Name' and $class='O'">Type</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test="string-length($key)>0">
		<ValuesItem>				
			<xsl:attribute name="ValuesKey"><xsl:value-of select="$key"/></xsl:attribute>
			<xsl:value-of select="$attrType"/>
		</ValuesItem>
	</xsl:if>
</xsl:template>
	
</xsl:stylesheet>