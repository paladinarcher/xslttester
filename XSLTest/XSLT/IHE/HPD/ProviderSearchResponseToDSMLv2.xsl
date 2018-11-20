<?xml version="1.0" encoding="UTF-8"?>
<!-- Transform a Provider SearchResponse into DSMLv2 -->
<xsl:stylesheet xmlns="urn:oasis:names:tc:DSML:2:0:core"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				 xmlns:isc="http://extension-functions.intersystems.com"
				 exclude-result-prefixes="xsi isc"
				 version="1.0">
<xsl:output method="xml" indent="no" omit-xml-declaration="no"/>
<xsl:include href="Common.xsl"/>

<!-- Create the top-level searchResponse 
      TODO: Differentiate different types of errors -->
<xsl:template match="SearchResponse">
   <searchResponse>
		<xsl:attribute name="requestID"><xsl:value-of select="RequestID"/></xsl:attribute>
		<xsl:apply-templates select="IndividualMatches/Individual | OrganizationMatches/Organization  | MembershipMatches/Membership | ServiceMatches/Service">
			<xsl:with-param name="inputClass" select="Type"/>
			<xsl:with-param name="inputOu" select="OrganizationalUnit"/>
		</xsl:apply-templates>
		<searchResultDone>
			<xsl:call-template name="LDAPResult">
				<xsl:with-param name="message" select="ErrorMessage"/>
			</xsl:call-template>
	   </searchResultDone>
   </searchResponse>
</xsl:template>

<!-- Add a searchResultEntry for each matching result -->
<!-- TODO: Handle credentials as a separate entity (or service as child data -->
<xsl:template match="Individual | Organization | Membership | Service">
	<xsl:param name="inputClass"/>
	<xsl:param name="inputOu"/>
	<xsl:variable name="class">
		<xsl:choose>
			<xsl:when test="$inputClass!='A'">
				<xsl:value-of select="$inputClass"/>
			</xsl:when>
			<!-- Can search for individual providers or organization providers if you don't specify an organizational unit in the searchRequest -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="local-name()='Individual'">I</xsl:when>
					<xsl:when test="local-name()='Organization'">O</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ou">
		<xsl:choose>
			<xsl:when test="string-length($inputOu)>0">
				<xsl:value-of select="$inputOu"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getOu">
					<xsl:with-param name="class" select="$class"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rdn">
		<xsl:choose>
			<xsl:when test="$class='R'"><xsl:value-of select="GroupName"/></xsl:when>
			<xsl:when test="$class='C'"><xsl:value-of select="Credentials/Credential/Idx"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="UniqueID"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rdnType">
		<xsl:choose>
			<xsl:when test="$class='R' and GroupName">cn</xsl:when>
			<xsl:when test="$class='C'">credentialId</xsl:when>
			<xsl:otherwise>uid</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<searchResultEntry>
		<xsl:attribute name="dn">
			<xsl:call-template name="makeDN">
				<xsl:with-param name="ou" select="$ou"/>
				<xsl:with-param name="rdn" select="$rdn"/>
				<xsl:with-param name="rdnType" select="$rdnType"/>
			</xsl:call-template>
		</xsl:attribute>
		<!-- Use attribute templates to extract the requested information -->
		<xsl:apply-templates select="../../HPDAttrs/HPDAttrsItem" mode="check">
			<xsl:with-param name="context" select="."/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:apply-templates>
	</searchResultEntry>
</xsl:template>

<!-- Exclude attributes that don't exist for this entity class (for when a specific ou isn't specified) -->
<xsl:template match="HPDAttrsItem" mode="check">
	<xsl:param name="context"/>
	<xsl:param name="class"/>
	<xsl:variable name="attr">
		<xsl:apply-templates select="$attrs-top" mode="getAttr">
			<xsl:with-param name="curr-attr" select="concat($class,translate(.,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:if test="string-length($attr)>0">
		<xsl:apply-templates select=".">
			<xsl:with-param name="context" select="$context"/>
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="attr" select="$attr"/>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

<!-- Return object class hierarchy for requested object class -->
<xsl:template match="attributes" mode="getObjectClasses">
	<xsl:param name="class"/>
	<xsl:param name="element" select="'value'"/>
	<xsl:for-each select="key('attr-lookup', concat($class,'objectclass'))/objectClass">
		<xsl:element name="{$element}"><xsl:value-of select="."/></xsl:element>
	</xsl:for-each>
	<xsl:element name="{$element}">top</xsl:element>
</xsl:template>

<!-- Display a requested HPD attribute -->
<xsl:template match="HPDAttrsItem">
	<xsl:param name="context"/>
	<xsl:param name="class"/>
	<xsl:param name="attr"/>
	<xsl:variable name="lc" select="translate(.,$uppercase,$lowercase)"/>
	<xsl:variable name="nodeType">
		<xsl:apply-templates select="$attrs-top" mode="getNodeType">
			<xsl:with-param name="curr-attr" select="concat($class,$lc)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="type">
		<xsl:apply-templates select="$attrs-top" mode="getType">
			<xsl:with-param name="curr-attr" select="concat($class,$lc)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="field">
		<xsl:apply-templates select="$attrs-top" mode="getField">
			<xsl:with-param name="curr-attr" select="concat($class,$lc)"/>
		</xsl:apply-templates>
	</xsl:variable>
	
	<attr>
		<xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute> 
		<xsl:choose>
		<!-- Show the LDAP object hierarchy when requested (from Configuration file) -->
			<xsl:when test="$lc='objectclass'">
				<xsl:apply-templates select="$attrs-top" mode="getObjectClasses">
					<xsl:with-param name="class" select="$class"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- Credential Attributes -->
			<xsl:when test="substring($lc,1,10)='credential'">
				<xsl:variable name="credContext" select="$context/Credentials/Credential"/>
				<!-- Note: Must use an xsl:choose instead of a generic select, as in XSLT you can't select a portion of the XML tree 
                          identified by the contents of a variable -->
                <value>
					<xsl:choose>
						<xsl:when test="$attr='Idx'"><xsl:value-of select="$credContext/Idx"/></xsl:when>
						<xsl:when test="$attr='CredName'"><xsl:value-of select="$credContext/CredName"/></xsl:when>
						<xsl:when test="$attr='CredDescription'"><xsl:value-of select="$credContext/CredDescription"/></xsl:when>
						<xsl:when test="$attr='CredIssueDate'"><xsl:value-of select="$credContext/CredIssueDate"/></xsl:when>
						<xsl:when test="$attr='CredRenewalDate'"><xsl:value-of select="$credContext/CredRenewalDate"/></xsl:when>
						<xsl:when test="$attr='CredType'">
							<xsl:choose>
								<xsl:when test="$credContext/CredType='D'">Degree</xsl:when>
								<xsl:when test="$credContext/CredType='C'">Credential</xsl:when>
								<xsl:when test="$credContext/CredType='R'">Certificate</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$attr='CredStatus'">
							<xsl:choose>
								<xsl:when test="$credContext/CredStatus='A'">Active</xsl:when>
								<xsl:when test="$credContext/CredStatus='I'">Inactive</xsl:when>
								<xsl:when test="$credContext/CredStatus='R'">Revoked</xsl:when>
								<xsl:when test="$credContext/CredStatus='S'">Suspended</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$attr='CredNumber' and $credContext/CredNumber/Extension">
							<xsl:value-of select="isc:evaluate('getOIDForCode',$credContext/CredNumber/AssigningAuthorityName,'LicensingAuthority')"/>
							<xsl:text>:</xsl:text>
							<xsl:value-of select="$credContext/CredNumber/Extension"/>
						</xsl:when>
					</xsl:choose>
				</value>
			</xsl:when>
				
				<!-- Single-value attributes -->
			<xsl:when test="$nodeType='Single'">
				<value>
					<xsl:choose>
						<xsl:when test="$attr='UniqueID'"><xsl:value-of select="$context/UniqueID"/></xsl:when>
						<xsl:when test="$attr='DateCreated'"><xsl:value-of select="isc:evaluate('addUTCtoDateTime',$context/DateCreated)"/></xsl:when>
						<xsl:when test="$attr='LastUpdated'"><xsl:value-of select="isc:evaluate('addUTCtoDateTime',$context/LastUpdated)"/></xsl:when>
						<xsl:when test="$attr='Gender'"><xsl:value-of select="$context/Gender"/></xsl:when>
						<xsl:when test="$attr='GroupName'"><xsl:value-of select="$context/GroupName"/></xsl:when>
						<xsl:when test="$attr='HPDDisplayName'"><xsl:value-of select="$context/HPDDisplayName"/></xsl:when>
						<xsl:when test="$attr='ServiceAddress'"><xsl:value-of select="$context/ServiceAddress"/></xsl:when>
						<xsl:when test="$attr='ProviderStatus'">
							<xsl:choose>
								<xsl:when test="$context/ProviderStatus='A'">Active</xsl:when>
								<xsl:when test="$context/ProviderStatus='I'">Inactive</xsl:when>
								<xsl:when test="$context/ProviderStatus='R'">Retired</xsl:when>
								<xsl:when test="$context/ProviderStatus='D'">Deceased</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$attr='Idx' and $class='C'"><xsl:value-of select="$context/Credentials/Credential/Idx"/></xsl:when>
						<xsl:when test="$attr='Owner'">
							<xsl:call-template name="makeDN">
								<xsl:with-param name="ou">
									<xsl:call-template name="getOu">
										<xsl:with-param name="class" select="'O'"/>
									</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="rdn">
									<xsl:choose>
										<xsl:when test="$class='R'"><xsl:value-of select="$context/UniqueID"/></xsl:when>
										<xsl:when test="$class='M'"><xsl:value-of select="$context/Owner"/></xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$attr='PrvMember'">
							<xsl:call-template name="makeDN">
								<xsl:with-param name="ou">
									<xsl:call-template name="getOu">
										<xsl:with-param name="class" select="'I'"/>
									</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="rdn" select="$context/Member"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</value>
			</xsl:when>
				
			<!--Names -->
			<xsl:when test="$attr='Name'">
				<xsl:choose>
					<xsl:when test="$type='Legal'">
						<xsl:apply-templates select="$context/Names/Name[Type='Legal']">
							<xsl:with-param name="field" select="$field"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$type='DBA'">
						<xsl:apply-templates select="$context/Names/Name[Type!='Legal' or string-length(Type)=0]">
							<xsl:with-param name="field" select="$field"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$context/Names/Name">
							<xsl:with-param name="field" select="$field"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<!--Provider Types -->
			<xsl:when test="$attr='ProviderType'">
				<xsl:for-each select="$context/ProviderTypes/ProviderType">
					<value>
						<xsl:choose>
							<xsl:when test="$field='Code'"><xsl:value-of select="Code"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="Description"/></xsl:otherwise>
						</xsl:choose>
					</value>
				</xsl:for-each>			
			</xsl:when>
			
			<!--Specialites -->
			<xsl:when test="$attr='Specialty'">
				<xsl:for-each select="$context/Specialties/Specialty">
					<value>
						<xsl:text>HS:</xsl:text>
						<xsl:if test="string-length(CodeSystem)>0">
							<xsl:value-of select="isc:evaluate('getOIDForCode',CodeSystem,'CodeSystem')"/>
						</xsl:if>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="Code"/>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="Description"/>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!-- Practice and MemberOf -->
			<xsl:when test="$attr='Practice'">
				<xsl:for-each select="$context/Practices/IDOrganization">
					<value>
						<xsl:call-template name="makeDN">
							<xsl:with-param name="ou">
								<xsl:call-template name="getOu">
								<xsl:with-param name="class" select="'O'"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="rdn" select="UniqueID"/>
						</xsl:call-template>
					</value>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$attr='Member'">
				<xsl:for-each select="$context/MemberOf/IDOrganization">
					<value>
					<!-- The dn for a group can be the group name or the owner ID (if the group was created outside of HPD) -->
						<xsl:choose>
							<xsl:when test="string-length(GroupName)>0">
								<xsl:call-template name="makeDN">
									<xsl:with-param name="ou" select="'Relationship'"/>
									<xsl:with-param name="rdn" select="GroupName"/>
									<xsl:with-param name="rdnType" select="'cn'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="makeDN">
									<xsl:with-param name="ou">
										<xsl:call-template name="getOu">
											<xsl:with-param name="class" select="'O'"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="rdn" select="UniqueID"/>
									<xsl:with-param name="rdnType" select="'owner'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!-- Members of a relationship -->
			<xsl:when test="$attr='Members'">
				<xsl:for-each select="$context/Members/IDMember">
					<value>
						<xsl:call-template name="makeDN">
							<xsl:with-param name="ou">
								<xsl:call-template name="getOu">
									<xsl:with-param name="class" select="Type"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="rdn" select="UniqueID"/>
						</xsl:call-template>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Languages -->
			<xsl:when test="$attr='Language'">
				<xsl:for-each select="$context/Languages/Language">
					<value>
						<xsl:value-of select="Code"/>
						<xsl:if test="string-length(Fluency)>0">
							<xsl:value-of select="concat(';q=',Fluency)"/>
						</xsl:if>
					</value>
				</xsl:for-each>
			</xsl:when>	
		
			<!--Credentials  - Return the dn of the credential, as it's a separate ou.
				 Show the credential number (with AA OID) if there, otherwise show the credentialId-->		
			<xsl:when test="$attr='Credential'">
				<xsl:for-each select="$context/Credentials/Credential">
					<value>
						<xsl:call-template name="makeDN">
							<xsl:with-param name="ou" select="'HPDCredential'"/>
							<xsl:with-param name="rdnType">
									<xsl:choose>
									<xsl:when test="CredNumber/Extension">credentialNumber</xsl:when>
									<xsl:otherwise>credentialId</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="rdn">
								<xsl:choose>
									<xsl:when test="CredNumber/Extension">
										<xsl:value-of select="isc:evaluate('getOIDForCode',CredNumber/AssigningAuthorityName,'LicensingAuthority')"/>
										<xsl:text>:</xsl:text>
										<xsl:value-of select="CredNumber/Extension"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="Idx"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Identifiers -->
			<xsl:when test="$attr='Identifier'">
				<xsl:for-each select="$context/Identifiers/Identifier">
					<xsl:variable name="status">
						<xsl:choose>
							<xsl:when test="Status='A'">Active</xsl:when>
							<xsl:when test="Status='I'">Inactive</xsl:when>
							<xsl:when test="Status='R'">Revoked</xsl:when>
							<xsl:when test="Status='S'">Suspended</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<value>
						<xsl:value-of select="isc:evaluate('getOIDForCode',AssigningAuthorityName,'AssigningAuthority')"/>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="Type"/>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="Extension"/>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="$status"/>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Email -->
			<xsl:when test="$attr='Email'">
				<xsl:for-each select="$context/Emails/Email[EmailType=$type]">
					<value><xsl:value-of select="Email"/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Phones -->
			<xsl:when test="$attr='Phone'">
				<xsl:for-each select="$context/Phones/Phone">
					<xsl:choose>
						<xsl:when test="$type=Type">
							<value><xsl:value-of select="PhoneNumberFull"/></value>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="($type='L') and (string-length(Type)=0)">
								<value><xsl:value-of select="PhoneNumberFull"/></value>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			
			<!--Addresses -->
			<xsl:when test="$attr='Address'">
				<xsl:for-each select="$context/Addresses/PrvAddress[Use=$type]">
					<xsl:variable name="status">
						<xsl:choose>
							<xsl:when test="PrimaryFlag = 'true'">Primary</xsl:when>
							<xsl:when test="Status='I'">Inactive</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<value>
						<xsl:if test="string-length($status)>0">
							<xsl:text>status=</xsl:text><xsl:value-of select="$status"/>
						</xsl:if>
						<xsl:text> $ addr=</xsl:text><xsl:value-of select="Address"/>
						<xsl:if test="string-length(StreetNumber)>0">
							<xsl:text> $ streetNumber=</xsl:text><xsl:value-of select="StreetNumber"/>
						</xsl:if>
						<xsl:if test="string-length(StreetName)>0">
							<xsl:text> $ streetName=</xsl:text><xsl:value-of select="StreetName"/>
						</xsl:if>
						<xsl:if test="string-length(City)>0">
							<xsl:text> $ city=</xsl:text><xsl:value-of select="City"/>
						</xsl:if>
						<xsl:if test="string-length(State)>0">
							<xsl:text> $ state=</xsl:text><xsl:value-of select="State"/>
						</xsl:if>
						<xsl:if test="string-length(PostalCode)>0">
							<xsl:text> $ postalCode=</xsl:text><xsl:value-of select="PostalCode"/>
						</xsl:if>
						<xsl:if test="string-length(Country)>0">
							<xsl:text> $ country=</xsl:text><xsl:value-of select="Country"/>
						</xsl:if>
					</value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Signing certificates -->
			<xsl:when test="$attr='SigningCertificates'">
				<xsl:for-each select="$context/SigningCertificates/SigningCertificatesItem">
					<value><xsl:value-of select="."/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--General certificates -->
			<xsl:when test="$attr='Certificates'">
				<xsl:for-each select="$context/Certificates/CertificatesItem">
					<value><xsl:value-of select="."/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--SMime certificates -->
			<xsl:when test="$attr='SMimeCertificates'">
				<xsl:for-each select="$context/SMimeCertificates/SMimeCertificatesItem">
					<value><xsl:value-of select="."/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Service URIs -->
			<xsl:when test="$attr='ServiceURI'">
				<xsl:for-each select="$context/ServiceURIs/ServiceURIsItem">
					<value><xsl:value-of select="."/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Facilities -->
			<xsl:when test="$attr='Facility'">
				<xsl:for-each select="$context/Facilities/FacilitiesItem">
					<value><xsl:value-of select="."/></value>
				</xsl:for-each>
			</xsl:when>
			
			<!--Integration  -->
			<xsl:when test="$attr='IntegrationProfile'">
				<xsl:apply-templates select="$context/IntegrationProfile/Profile"/>
			</xsl:when>
			
			<!--Content Profile -->
			<xsl:when test="$attr='ContentProfile'">
				<xsl:apply-templates select="$context/ContentProfile/Profile"/>
			</xsl:when>
			
			<!-- Pointers to HPDPlus Services -->
			<xsl:when test="$attr='Service'">
				<xsl:for-each select="$context/Services/Service/UniqueID">
					<value>
						<xsl:call-template name="makeDN">
							<xsl:with-param name="ou" select="'HPDElectronicService'"/>
							<xsl:with-param name="rdn" select="."/>
							<xsl:with-param name="rdnType" select="'hpdServiceId'"/>
						</xsl:call-template>
					</value>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</attr>
</xsl:template>

<xsl:template match="Names/Name">
	<xsl:param name="field"/>
	<value>
		<xsl:choose>
			<xsl:when test="$field='Name'"><xsl:value-of select="Name"/></xsl:when>
			<xsl:when test="$field='CommonName'"><xsl:value-of select="CommonName"/></xsl:when>
			<xsl:when test="$field='Given'"><xsl:value-of select="Given"/></xsl:when>
			<xsl:when test="$field='Family'"><xsl:value-of select="Family"/></xsl:when>
			<xsl:when test="$field='Middle'"><xsl:value-of select="Middle"/></xsl:when>
			<xsl:when test="$field='Prefix'"><xsl:value-of select="Prefix"/></xsl:when>
		</xsl:choose>
	</value>
</xsl:template>

<!-- Display an Integration or Content Profile -->
<xsl:template match="Profile">
	<value>
		<xsl:value-of select="Code"/>
		<xsl:text>$</xsl:text>
		<xsl:value-of select="Version"/>
		<xsl:text>$</xsl:text>
		<xsl:value-of select="Option"/>
	</value>
</xsl:template>

</xsl:stylesheet>