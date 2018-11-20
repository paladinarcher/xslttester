<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform DSMLv2 addRequest into a Provider AddEditIndividualRequest or AddEditOrganization Request -->
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				 xmlns:isc="http://extension-functions.intersystems.com" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core"
				 xmlns:exsl="http://exslt.org/common"
				 extension-element-prefixes="exsl"
				exclude-result-prefixes="xsi isc dsml exsl"
				version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- Classify addRequests -->
<xsl:template match="dsml:addRequest">
	<!-- This variable will be used be accumulate pre-processed error messages -->
	<xsl:if test="isc:evaluate('varReset', 'HPDErrorMessage')"></xsl:if>
	 <xsl:variable name="class">
		<xsl:call-template name="getClass">
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="rdn">
		<xsl:call-template name="getRdn">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="dn" select="@dn"/>
		</xsl:call-template>
    </xsl:variable>
    
	<!-- Find invalid attributes -->
	<xsl:apply-templates select="dsml:attr" mode="Invalid">
		<xsl:with-param name="class" select="$class"/>
	</xsl:apply-templates>    
    
	 <xsl:choose>
		<xsl:when test="$class='I' or $class='O'">
			<xsl:apply-templates select="." mode="Provider">
				<xsl:with-param name="class" select="$class"/>
				<xsl:with-param name="uid" select="$rdn"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$class='M'">
			<xsl:apply-templates select="." mode="Membership">
				<xsl:with-param name="uid" select="$rdn"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$class='R'">
			<xsl:apply-templates select="." mode="Relationship">
				<xsl:with-param name="cn" select="$rdn"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$class='S'">
			<xsl:apply-templates select="." mode="Service">
				<xsl:with-param name="uid" select="$rdn"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<AddEditIndividualRequest>
				<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
				<xsl:call-template name="NoClassErrorMessage">
					<xsl:with-param name="class" select="$class"/>
				</xsl:call-template>
			</AddEditIndividualRequest>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Adding a relationship is the same as modifying the organization to add the group name-->
<xsl:template match="dsml:addRequest" mode="Relationship">
	<xsl:param name="cn"/>
	<ModifyRequest>
		<MessageType>MOD</MessageType>
		<Type>O</Type>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:call-template name="getUid">
				<xsl:with-param name="dn" select="dsml:attr[@name='owner']/dsml:value"/>
			</xsl:call-template>
		</UniqueID>		
		<Modifications>
			<Modification>
				<Action>A</Action>
				<Attribute>GroupName</Attribute>
				<Values>
					<ValuesItem>
						<xsl:attribute name="ValuesKey"><xsl:value-of select="'GroupName'"/></xsl:attribute>
						<xsl:value-of select="$cn"/>
					</ValuesItem>	
				</Values>
			</Modification>
			<xsl:for-each select="dsml:attr[@name='member']">
				<Modification>
					<Action>A</Action>
					<Attribute>Members</Attribute>
					<Values>
						<ValuesItem>
							<xsl:attribute name="ValuesKey">PrvMember</xsl:attribute>
							<xsl:call-template name="extractMemberID">
								<xsl:with-param name="dn" select="dsml:value"/>
							</xsl:call-template>
						</ValuesItem>	
					</Values>
				</Modification>
			</xsl:for-each>
		</Modifications>
		<xsl:call-template name="ErrorMessage"/>
	</ModifyRequest>
</xsl:template>

<!-- HPDPlus Add Membership Requests -->
<xsl:template match="dsml:addRequest" mode="Membership">
	<xsl:param name="uid"/>
	<xsl:variable name="class" select="'M'"/>
	<AddEditIndMemberRequest>
		<AddOrUpdate>A</AddOrUpdate>
		<AllInclusive>0</AllInclusive>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:value-of select="$uid"/>
		</UniqueID>
		<Source>
			<xsl:value-of select="substring-before($uid,':')"/>
		</Source>
		<Owner>
			<xsl:call-template name="getUid">
				<xsl:with-param name="dn" select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdhasanorg']"/>
			</xsl:call-template>
		</Owner>
		<Member>
			<xsl:call-template name="getUid">
				<xsl:with-param name="dn" select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdhasaprovider']"/>
			</xsl:call-template>
		</Member>		
		<Emails>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='email']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Emails>
		<Phones>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='telephonenumber' or translate(@name,$uppercase,$lowercase)='mobile' or translate(@name,$uppercase,$lowercase)='pager'  or translate(@name,$uppercase,$lowercase)='facsimiletelephonenumber']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Phones>
		<Services>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdhasaservice']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Services>
		<xsl:call-template name="ErrorMessage"/>
	</AddEditIndMemberRequest>
</xsl:template>

<!-- HPDPlus Add Service Requests -->
<xsl:template match="dsml:addRequest" mode="Service">
	<xsl:param name="uid"/>
	<xsl:variable name="class" select="'S'"/>
	<AddEditServiceRequest>
		<AddOrUpdate>A</AddOrUpdate>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<UniqueID>
			<xsl:value-of select="$uid"/>
		</UniqueID>
		<Source>
			<xsl:value-of select="substring-before($uid,':')"/>
		</Source>	
		
		<!-- Single attributes -->
		<xsl:apply-templates select="dsml:attr[not(translate(@name,$uppercase,$lowercase)='hpdserviceid')]" mode="Single">
			<xsl:with-param name="class" select="$class"/>
		</xsl:apply-templates>
		
		<IntegrationProfile>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdintegrationprofile']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</IntegrationProfile>
		<ContentProfile>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdcontentprofile']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</ContentProfile>
		
		<!-- List attributes -->
		<Certificates>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdcertificate']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Certificates>
		
		<xsl:call-template name="ErrorMessage"/>
	</AddEditServiceRequest>
</xsl:template>

<!-- Individual and Organization Add Provider Requests -->
<xsl:template match="dsml:addRequest" mode="Provider">
	<xsl:param name="class"/>
	<xsl:param name="uid"/>
	<xsl:variable name="request">
		<xsl:choose>
			<xsl:when test="$class='I'">AddEditIndividualRequest</xsl:when>
			<xsl:otherwise>AddEditOrganizationRequest</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="uniqueID" select="$uid"/>
	<xsl:element name="{$request}">
		<AddOrUpdate>A</AddOrUpdate>
		<AllInclusive>0</AllInclusive>
		<HPDRequestID><xsl:value-of select="@requestID"/></HPDRequestID>
		<Source><xsl:value-of select="substring-before($uniqueID,':')"/></Source>
		<SourceID>
			<xsl:choose>
				<xsl:when test="contains($uniqueID,':')"><xsl:value-of select="substring-after($uniqueID,':')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$uniqueID"/></xsl:otherwise>
			</xsl:choose>
		</SourceID>
		<UniqueID><xsl:value-of select="$uniqueID"/></UniqueID>
		
		<!-- Single attributes -->
		<xsl:apply-templates select="dsml:attr[not(translate(@name,$uppercase,$lowercase)='uid')]" mode="Single">
			<xsl:with-param name="class" select="$class"/>
		</xsl:apply-templates>
		
		<!-- Multiple attributes that contain several fields within one -->
		<Identifiers>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcidentifier']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Identifiers>
		<Languages>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdproviderlanguagesupported']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Languages>
		<Addresses>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdprovidermailingaddress' or translate(@name,$uppercase,$lowercase)='hpdproviderbillingaddress' or translate(@name,$uppercase,$lowercase)='hpdproviderpracticeaddress']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdproviderlegaladdress']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Addresses>
		<Phones>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='telephonenumber' or translate(@name,$uppercase,$lowercase)='mobile' or translate(@name,$uppercase,$lowercase)='pager'  or translate(@name,$uppercase,$lowercase)='facsimiletelephonenumber']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Phones>
		<Credentials>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdcredential']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Credentials>
		<Specialties>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcspecialisation']" mode="Compound">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Specialties>
		
		<!-- Attributes that point to another organizational unit -->
		<MemberOf>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='memberof']" mode="OrgPointer"/>
		</MemberOf>
		
		<!-- Multiple attributes that contain a single field (but may also have system-calculated fields) -->
		<Emails>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='mail' or translate(@name,$uppercase,$lowercase)='hpdmedicalrecordsdeliveryemailaddress']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Emails>
		<ProviderTypes>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcprofession' or translate(@name,$uppercase,$lowercase)='businesscategory']/dsml:value" mode="ProviderType">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</ProviderTypes>
		<ServiceURIs>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='labeleduri']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</ServiceURIs>
		<Services>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hpdhasaservice']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Services>
		<Certificates>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='usercertificate' or translate(@name,$uppercase,$lowercase)='hcorganizationcertificates']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</Certificates>
		<SigningCertificates>
			<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcsigningcertificate']" mode="Multiple">
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</SigningCertificates>
		
		<!-- Individual vs. Organization-specific attributes -->
		<xsl:choose>
			<xsl:when test="$class='I'">
				<Names>
					<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='sn']/dsml:value" mode="IndividualName"/>
				</Names>
				<SMimeCertificates>
					<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='usersmimecertificate']" mode="Multiple">
						<xsl:with-param name="class" select="$class"/>
					</xsl:apply-templates>
				</SMimeCertificates>
				<Facilities>
					<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='physicaldeliveryofficename']" mode="Multiple">
						<xsl:with-param name="class" select="$class"/>
					</xsl:apply-templates>
				</Facilities>
				<Practices>
					<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcpracticelocation']" mode="OrgPointer"/>
				</Practices>
			</xsl:when>
			<xsl:when test="$class='O'">
				<Names>
					<xsl:apply-templates select="dsml:attr[translate(@name,$uppercase,$lowercase)='hcregisteredname' or translate(@name,$uppercase,$lowercase)='o']" mode="Multiple">
						<xsl:with-param name="class" select="$class"/>
					</xsl:apply-templates>
				</Names>
			</xsl:when>
		</xsl:choose>		
		<xsl:call-template name="ErrorMessage"/>
	</xsl:element>
</xsl:template>

<!-- Combine several attributes to form the names for an individual provider. (Must have a last name to be considered.) -->
<xsl:template match="*" mode="IndividualName">
	<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
	<Name>
		<Family><xsl:value-of select="."/></Family>
		<Given><xsl:value-of select="../../dsml:attr[translate(@name,$uppercase,$lowercase)='givenname']/dsml:value[position() = $pos]"/></Given>
		<Middle><xsl:value-of select="../../dsml:attr[translate(@name,$uppercase,$lowercase)='initials']/dsml:value[position() = $pos]"/></Middle>
		<Prefix><xsl:value-of select="../../dsml:attr[translate(@name,$uppercase,$lowercase)='title']/dsml:value[position() = $pos]"/></Prefix>
		<CommonName><xsl:value-of select="../../dsml:attr[translate(@name,$uppercase,$lowercase)='cn']/dsml:value[position() = $pos]"/></CommonName>
	</Name>
</xsl:template>

<!-- Add description to provider type code -->
<xsl:template match="*" mode="ProviderType">
	<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
	<ProviderType>
		<Code><xsl:value-of select="."/></Code>
		<xsl:variable name="desc">
			<xsl:value-of select="../../dsml:attr[translate(@name,$uppercase,$lowercase)='description']/dsml:value[position() = $pos]"/>
		</xsl:variable>
		<xsl:if test="string-length($desc)>0">
			<Description><xsl:value-of select="$desc"/></Description>
		</xsl:if>
	</ProviderType>
</xsl:template>

<!-- Get the appropriate value for single-occurence dsml attributes that apply to the class-->
<xsl:template match="dsml:attr" mode="Single">
	<xsl:param name="class"/>
	<xsl:variable name="attr">
		<xsl:call-template name="lookupAttr">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="name" select="translate(@name,$uppercase,$lowercase)"/>
	<xsl:variable name="nodeType">
		<xsl:apply-templates select="$attrs-top" mode="getNodeType">
			<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="type">
		<xsl:apply-templates select="$attrs-top" mode="getType">
			<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<!-- Single properties -->
	<xsl:if test="string-length($attr)>0 and $nodeType='Single'">
		<xsl:element name="{$attr}">
			<!-- May need to convert display value to internal value -->
			<xsl:choose>
				<xsl:when test="contains($type,',')">
					<xsl:call-template name="convertDisplayValue">
						<xsl:with-param name="value" select="dsml:value"/>
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="attrName" select="@name"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="dsml:value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>	
	</xsl:if>
</xsl:template>

<!-- Get the appropriate value for simple multiple-occurence dsml attribute that apply to the class-->
<xsl:template match="dsml:attr" mode="Multiple">
	<xsl:param name="class"/>
	<xsl:variable name="attr">
		<xsl:call-template name="lookupAttr">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="not(contains($attr,'invalid'))">
		<xsl:variable name="name" select="translate(@name,$uppercase,$lowercase)"/>
		<xsl:variable name="field">
			<xsl:apply-templates select="$attrs-top" mode="getField">
			   <xsl:with-param name="curr-attr" select="concat($class,$name)"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="type">
			<xsl:apply-templates select="$attrs-top" mode="getType">
				<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="nodeType">
			<xsl:apply-templates select="$attrs-top" mode="getNodeType">
				<xsl:with-param name="curr-attr" select="concat($class,$name)"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:for-each select="dsml:value">
			<xsl:choose>
				<!-- These are handled a little differently -->
				<xsl:when test="$attr='Facility'">
					<FacilitiesItem><xsl:value-of select="."/></FacilitiesItem>
				</xsl:when>
				<xsl:when test="$attr='ServiceURI'">
					<ServiceURIsItem><xsl:value-of select="."/></ServiceURIsItem>
				</xsl:when>	
			
				<!-- Multiple values that contain fields -->
				<xsl:when test="string-length($field)>0">
					<xsl:element name="{$attr}">
						<xsl:element name="{$field}">
							<xsl:choose>
								<xsl:when test="$attr='Service'">
									<xsl:call-template name="getRdn">
										<xsl:with-param name="class" select="'S'"/>
										<xsl:with-param name="dn" select="."/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<!-- Add types where appropriate -->
						<xsl:choose>
							<xsl:when test="$attr='Email'">
								<EmailType><xsl:value-of select="$type"/></EmailType>
							</xsl:when>
							<xsl:when test="$attr='Name' and $class='O'">
								<Type><xsl:value-of select="$type"/></Type>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:when>
				
				<!-- Simple multiple items -->
				<xsl:when test="$nodeType='List'">
					<xsl:element name="{concat($attr,'Item')}"><xsl:value-of select="."/></xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<!-- Get the appropriate value for a compound multiple-occurence dsml attribute -->
<xsl:template match="dsml:attr" mode="Compound">
	<xsl:param name="class"/>
	<xsl:variable name="attr">
		<xsl:call-template name="lookupAttr">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="type">
		<xsl:apply-templates select="$attrs-top" mode="getType">
			<xsl:with-param name="curr-attr" select="concat($class,translate(@name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>	
	</xsl:variable>
	<xsl:if test="string-length($attr)>0">
		<xsl:for-each select="dsml:value">
			<xsl:variable name="container">
					<xsl:call-template name="extractValues">
						<xsl:with-param name="attr" select="$attr"/>
						<xsl:with-param name="value" select="."/>
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="update" select="1"/>
					</xsl:call-template>
			</xsl:variable>
			<xsl:copy-of select="exsl:node-set($container)"/>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<!-- Get the pointer to an organization from the dn of an organization or relationship -->
<xsl:template match="dsml:attr" mode="OrgPointer">
	<xsl:for-each select="dsml:value">
		<xsl:variable name="container">
			<xsl:call-template name="extractOrganizationID">
				<xsl:with-param name="dn" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy-of select="exsl:node-set($container)"/>
	</xsl:for-each>
</xsl:template>
	
</xsl:stylesheet>