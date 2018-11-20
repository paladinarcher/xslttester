<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform DSMLv2 searchRequest into a Provider SearchRequest -->
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				 xmlns:isc="http://extension-functions.intersystems.com" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core"
				 xmlns:exsl="http://exslt.org/common"
				 extension-element-prefixes="exsl"
				exclude-result-prefixes="xsi isc dsml exsl"
				version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- Create top-level SearchRequest -->
<xsl:template match="dsml:searchRequest">
	<xsl:if test="isc:evaluate('varReset', 'HPDErrorMessage')"></xsl:if>
	<xsl:variable name="ou">
		<xsl:choose>
			<!-- Can't translate the "ou=" to lower case, as we want to return the ou in the case it was entered -->
			<xsl:when test="contains(@dn,'ou=')"><xsl:value-of select="substring-before(substring-after(@dn,'ou='),',')"/></xsl:when>
			<xsl:when test="contains(@dn,'OU=')"><xsl:value-of select="substring-before(substring-after(@dn,'OU='),',')"/></xsl:when>
			<xsl:when test="contains(@dn,'Ou=')"><xsl:value-of select="substring-before(substring-after(@dn,'Ou='),',')"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ouClass">
		<xsl:call-template name="getClass">
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
    </xsl:variable>
    <xsl:variable name="class">
		<xsl:choose>
			<!-- an ou was specified that mapped to a class -->
			<xsl:when test="string-length($ouClass)>0"><xsl:value-of select="$ouClass"/></xsl:when>
			<!-- an ou was specified that didn't map to a class -->
			<xsl:when test="string-length($ou)>0">
				<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid ou:',$ou,' '))"></xsl:if>			
			</xsl:when>
			<!-- no ou was specified - look for the class in the filter -->
			<xsl:otherwise>
				<xsl:apply-templates select="dsml:filter" mode="getClass"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

    <SearchRequest>
        <Type><xsl:value-of select="$class"/></Type>
        <MaxMatches><xsl:value-of select="@sizeLimit"/></MaxMatches>
        <HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
        <ActiveOnly>0</ActiveOnly>
        <BestOnly><xsl:value-of select="$indBestOnly"/></BestOnly>
		<!-- Record the ou to be fed back in the response.  If none is specified, the ou will default based on the type of entity found -->
		<OrganizationalUnit><xsl:value-of select="$ou"/></OrganizationalUnit>
		
		<xsl:choose>
			<xsl:when test="@scope='singleLevel' and $class='A'">
				<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage','An organizational unit must be specified when scope = singleLevel')"></xsl:if>
			</xsl:when>
			<xsl:when test="@scope='baseObject'">
				<xsl:apply-templates select="." mode="baseObject">
					<xsl:with-param name="class" select="$class"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="dsml:filter">
					<xsl:with-param name="class" select="$class"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
        <xsl:apply-templates select="dsml:attributes">
			<xsl:with-param name="class" select="$class"/>
        </xsl:apply-templates>
        <xsl:if test="not(dsml:attributes)">
			<HPDAttrs>
				<xsl:for-each select="$attrs-top/attribute[class=$class]">
					<HPDAttrsItem><xsl:value-of select="@hpd"/></HPDAttrsItem>
				</xsl:for-each>
			</HPDAttrs>
        </xsl:if>
        <xsl:if test="string-length($class)=0">
			<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage','Cannot identify object hierarchy to search')"></xsl:if>        
        </xsl:if>
		<xsl:call-template name="ErrorMessage"/>
    </SearchRequest>
</xsl:template>

<!-- Add Provider directory attributes to look up along with HPD attributes to return -->
<xsl:template match="dsml:attributes">
	<xsl:param name="class"/>
	<xsl:variable name="allAttrs" select="dsml:attribute[@name='*'] or not(dsml:attribute)"/>
	<HPDAttrs>
    	<xsl:choose>
			<xsl:when test="$allAttrs">
				<xsl:for-each select="$attrs-top/attribute[class=$class]">
					<HPDAttrsItem><xsl:value-of select="@hpd"/></HPDAttrsItem>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="dsml:attribute">
					<HPDAttrsItem><xsl:value-of select="@name"/></HPDAttrsItem>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>	
    </HPDAttrs>
	<Attributes>
		 <!-- Return the entire sub-table when it is the ou.
		       Otherwise add the appropriate uid field to the requested attributes, so it can be used in forming the dn -->
		<xsl:choose>
			<xsl:when test="$class='C'">Credential</xsl:when>
			<xsl:when test="$allAttrs">*</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$class='R'">GroupName</xsl:when>
					<xsl:otherwise>UniqueID</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="dsml:attribute"> 
					<xsl:text>,</xsl:text>
					<xsl:call-template name="lookupAttr">
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="class" select="$class"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
    </Attributes>
</xsl:template>

<!-- Look for a single objectClass filter to determine the class.  If none found then, return 'A'll, meaning all Individual or Organization providers -->
<xsl:template match="dsml:filter" mode="getClass">
	<xsl:variable name="objectClasses">
		<xsl:for-each select="//dsml:equalityMatch[translate(@name,$uppercase,$lowercase)='objectclass']">
			<xsl:if test="local-name(ancestor::*) != 'or' and local-name(ancestor::*) != 'not'">
				<ObjectClass><xsl:value-of select="dsml:value"/></ObjectClass>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="objectClass">
		<xsl:value-of select="exsl:node-set($objectClasses)/ObjectClass[1]"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="string-length($objectClass)>0 and string-length(exsl:node-set($objectClasses)/ObjectClass[2])=0">
				<xsl:call-template name="getClassFromObjClass">
					<xsl:with-param name="objClass" select="$objectClass"/>
				</xsl:call-template>
			</xsl:when>
			<!-- When unsure, return all individuals and organizations -->
			<xsl:otherwise>
				<xsl:text>A</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<!-- Add condition for rdn when scope=baseObject -->
<xsl:template match="dsml:searchRequest" mode="baseObject">
	<xsl:param name="class"/>
	<xsl:variable name="uidAttr">
		<xsl:call-template name="getUidAttr">
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>				
	</xsl:variable>
	<xsl:variable name="rdn">
		<xsl:call-template name="getRdn">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="dn" select="@dn"/>			
		</xsl:call-template>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="string-length($rdn)>0">
			<SearchExpression>
				<LogicalOperator>AND</LogicalOperator>
				<Conditions>
					<xsl:call-template name="addCondition">
						<xsl:with-param name="compare" select="'EQUAL'"/>
						<xsl:with-param name="attr">
							<xsl:call-template name="lookupAttr">
								<xsl:with-param name="name" select="$uidAttr"/>
								<xsl:with-param name="class" select="$class"/>
							</xsl:call-template>							
						</xsl:with-param>
						<xsl:with-param name="value" select="$rdn"/>
					</xsl:call-template>
				</Conditions>
				<Expressions>
					<xsl:apply-templates select="dsml:filter">
						<xsl:with-param name="class" select="$class"/>			
					</xsl:apply-templates>
				</Expressions>
			</SearchExpression>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage','Cannot find application base object.')"></xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Add a search expression -->
<xsl:template match="dsml:filter | dsml:and | dsml:or | dsml:not">
	<xsl:param name="class"/>
	<SearchExpression>
		<LogicalOperator>
			<xsl:choose>
				<xsl:when test="local-name()='or'">OR</xsl:when>
				<xsl:when test="local-name()='not'">NOT</xsl:when>
				<xsl:otherwise>AND</xsl:otherwise>
			</xsl:choose>
		</LogicalOperator>
		<!-- Search conditions at this level -->
		<Conditions>
			<xsl:apply-templates select="dsml:equalityMatch | dsml:substrings | dsml:greaterOrEqual | dsml:lessOrEqual | dsml:present | dsml:approxMatch | dsml:extensibleMatch" mode="condition">
				<xsl:with-param name="class" select="$class"/>			
			</xsl:apply-templates>
		</Conditions>
		<!-- Nested search expressions -->
		<Expressions>
			<xsl:apply-templates select="dsml:and | dsml:or | dsml:not">
				<xsl:with-param name="class" select="$class"/>			
			</xsl:apply-templates>
			<!-- Compound fields are converted to Anded expressions -->
			<xsl:apply-templates select="dsml:equalityMatch | dsml:substrings | dsml:greaterOrEqual | dsml:lessOrEqual | dsml:present | dsml:approxMatch | dsml:extensibleMatch" mode="expression">
				<xsl:with-param name="class" select="$class"/>			
			</xsl:apply-templates>
		</Expressions>
	</SearchExpression>
</xsl:template>

<!-- Add a logical condition -->
<xsl:template match="dsml:equalityMatch | dsml:approxMatch | dsml:greaterOrEqual | dsml:lessOrEqual | dsml:present | dsml:substrings | dsml:extensibleMatch" mode="condition">
	<xsl:param name="class"/>
	<xsl:variable name="nodeType">
		<xsl:apply-templates select="$attrs-top" mode="getNodeType">
			<xsl:with-param name="curr-attr" select="concat($class,translate(@name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	
	<xsl:if test="not($nodeType='Compound')">
		<xsl:variable name="attr">
			<xsl:call-template name="lookupAttr">
				<xsl:with-param name="name" select="@name"/>
				<xsl:with-param name="class" select="$class"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:apply-templates select=".">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="attr" select="$attr"/>
			<xsl:with-param name="compound" select="0"/>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

<!-- Add an anded expression for compound fields-->
<xsl:template match="dsml:equalityMatch | dsml:approxMatch | dsml:greaterOrEqual | dsml:lessOrEqual | dsml:present | dsml:substrings | dsml:extensibleMatch" mode="expression">
	<xsl:param name="class"/>
	<xsl:variable name="nodeType">
		<xsl:apply-templates select="$attrs-top" mode="getNodeType">
			<xsl:with-param name="curr-attr" select="concat($class,translate(@name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:if test="$nodeType='Compound'">
		<xsl:variable name="attr">
			<xsl:call-template name="lookupAttr">
				<xsl:with-param name="name" select="@name"/>
				<xsl:with-param name="class" select="$class"/>
			</xsl:call-template>
		</xsl:variable>
		<SearchExpression>
			<LogicalOperator>AND</LogicalOperator>
			<Conditions>
				<xsl:apply-templates select=".">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="attr" select="$attr"/>
					<xsl:with-param name="compound" select="1"/>
				</xsl:apply-templates>
			</Conditions>
		</SearchExpression>
	</xsl:if>
</xsl:template>
		
<!-- Add a logical condition or, for compound fields, an anded expression -->
<xsl:template match="dsml:equalityMatch | dsml:approxMatch | dsml:greaterOrEqual | dsml:lessOrEqual | dsml:present | dsml:substrings | dsml:extensibleMatch">
	<xsl:param name="class"/>
	<xsl:param name="attr"/>
	<xsl:param name="compound"/>
	<xsl:variable name="compare">
		<xsl:choose>
			<xsl:when test="local-name()='equalityMatch'">EQUAL</xsl:when>
			<xsl:when test="local-name()='approxMatch'">APPROX</xsl:when>
			<xsl:when test="local-name()='greaterOrEqual'">GE</xsl:when>
			<xsl:when test="local-name()='lessOrEqual'">LE</xsl:when>
			<xsl:when test="local-name()='present'">PRESENT</xsl:when>
			<xsl:when test="local-name()='extensibleMatch'">EXTENSIBLE</xsl:when>
			<xsl:when test="local-name()='substrings'">
				<xsl:choose>
					<xsl:when test="dsml:initial">STARTSWITH</xsl:when>
					<xsl:otherwise>LIKE</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
	</xsl:variable>
	<xsl:variable name="name" select="translate(@name,$uppercase,$lowercase)"/>
	<xsl:variable name="value">
		<xsl:choose>
			<xsl:when test="dsml:value"><xsl:value-of select="dsml:value"/></xsl:when>
			<xsl:when test="dsml:initial"><xsl:value-of select="dsml:initial"/></xsl:when>
			<xsl:when test="dsml:any"><xsl:value-of select="dsml:any"/></xsl:when>
			<xsl:when test="dsml:final"><xsl:value-of select="dsml:final"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="final">
		<xsl:choose>
			<xsl:when test="string-length(dsml:final)>0">%</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="attrType">
		<xsl:apply-templates select="$attrs-top" mode="getType">
			<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:choose>
		<!-- Potentially multiple field/value pairs within a single field  -->
		<xsl:when test="$compound='1'">
			<xsl:variable name="container">
				<xsl:call-template name="extractValues">
					<xsl:with-param name="attr" select="$attr"/>
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="type" select="$attrType"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:for-each select="exsl:node-set($container)/*/*">
				<xsl:call-template name="addCondition">
					<xsl:with-param name="compare">
						<xsl:choose>
							<!-- Codes are always exact match -->
							<xsl:when test="local-name()='Code' and $compare != 'PRESENT'">EQUAL</xsl:when>
							<!--These Fields are really Types, embedded in the compound conditiona -->
							<xsl:when test="(local-name()='Type' or local-name()='Use') and $compare = 'PRESENT'">EQUAL</xsl:when>
							<xsl:otherwise> <xsl:value-of select="$compare"/></xsl:otherwise>
						</xsl:choose>
					 </xsl:with-param>
					 	 <!-- For credential number and name, the fields go into the attribute -->
					<xsl:with-param name="attr">
						<xsl:choose>
							<xsl:when test="$attr='CredNumber' or $attr='CredName'"><xsl:value-of select="local-name()"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$attr"/></xsl:otherwise>
						</xsl:choose>
					</xsl:with-param> 
					<xsl:with-param name="field">
						<xsl:choose>
							<xsl:when test="$attr='CredNumber' or $attr='CredName'"></xsl:when>
							<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
						</xsl:choose>					
					</xsl:with-param>
					<xsl:with-param name="value" select="concat($final,text())"/>
					<xsl:with-param name="attrType" select="$attrType"/>
				</xsl:call-template>
			</xsl:for-each>	
		</xsl:when>
		
		<!-- Pointer to Organization or Individual-->
		<xsl:when test="$attr='Practice' or $attr='Member' or $attr='Members' or $attr = 'Owner' or $attr='PrvMember'">
			<xsl:variable name="memberClass">
				<xsl:choose>
					<xsl:when test="$attr='Members'">
						<xsl:call-template name="getClass">
							<xsl:with-param name="dn" select="."/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>O</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- Add a condition on the uid for the member individual provider or member (or owner) organization -->
			<xsl:choose>
				<xsl:when test="$memberClass='O'">
					<xsl:variable name="container">
						<xsl:call-template name="extractOrganizationID">
							<xsl:with-param name="dn" select="$value"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- For-each just sets the context for the single element -->
					<xsl:for-each select="exsl:node-set($container)/*/*">
						<xsl:call-template name="addCondition">
							<xsl:with-param name="compare" select="$compare"/>
							<xsl:with-param name="attr" select="$attr"/>
							<xsl:with-param name="value" select="."/>
							<xsl:with-param name="attrType">
								<xsl:choose>
									<xsl:when test="local-name()='GroupName'">GROUP</xsl:when>
									<xsl:when test="local-name()='DisplayName'">NAME</xsl:when>
									<xsl:when test="local-name()='UniqueID'">UNIQUEID</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="addCondition">
						<xsl:with-param name="compare" select="$compare"/>
						<xsl:with-param name="attr" select="$attr"/>
						<xsl:with-param name="value">
							<xsl:if test="string-length(.)>0">
								<xsl:call-template name="extractMemberID">
									<xsl:with-param name="dn" select="."/>										
								</xsl:call-template>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="attrType" select="$attrType"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<!-- All other attributes with a single field and value -->
		<xsl:otherwise>
			<xsl:variable name="field">
				<xsl:apply-templates select="$attrs-top" mode="getField">
				   <xsl:with-param name="curr-attr" select="concat($class,$name)"/>
				</xsl:apply-templates>
			</xsl:variable>
				
			<xsl:call-template name="addCondition">
				<xsl:with-param name="compare" select="$compare"/>
				<xsl:with-param name="attr" select="$attr"/>
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="value">
					<xsl:choose>
						<xsl:when test="$attr='Service'">
							<xsl:call-template name="getRdn">
								<xsl:with-param name="class" select="'S'"/>
								<xsl:with-param name="dn" select="$value"/>
							</xsl:call-template>
						</xsl:when>
						<!--Add % to implement "final" as "like" -->
						<xsl:otherwise>
							<xsl:value-of select="concat($final,$value)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="attrType" select="$attrType"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="addCondition">
	<xsl:param name="compare"/>
	<xsl:param name="attr"/>
	<xsl:param name="field"/>
	<xsl:param name="value"/>
	<xsl:param name="attrType"/>
	<SearchCondition>
		<Comparison><xsl:value-of select="$compare"/></Comparison>
		<Attribute><xsl:value-of select="$attr"/></Attribute>
		<xsl:if test="string-length($field)>0">
			<Field><xsl:value-of select="$field"/></Field>
		</xsl:if>
		<xsl:if test="string-length($value)>0">
			<Value><xsl:value-of select="$value"/></Value>
		</xsl:if>
		<xsl:if test="string-length($attrType)>0">
			<Type><xsl:value-of select="$attrType"/></Type>
		</xsl:if>
	</SearchCondition>
	</xsl:template>
		
</xsl:stylesheet>