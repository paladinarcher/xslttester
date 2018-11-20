<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:isc="http://extension-functions.intersystems.com" 
				exclude-result-prefixes="xsi isc dsml"
				version="1.0">

<!-- Set up keys to each HPD attribute by class.
      Note: Could convert to store a separate hpdLower attribute.
      Note: the parser won't accept the lowercase and uppercase variables in the use clause. --> 
<xsl:key name="attr-lookup" match="attribute" use="concat(class,translate(@hpd,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'))"/>
<xsl:variable name="attrs-top" select="document('Configuration.xml')/attributes"/>

<!-- Returns the Provider Directory attribute that corresponds to an HPD attribute -->
<xsl:template match="attributes" mode="getAttr">
	<xsl:param name="curr-attr"/>
	<xsl:value-of select="key('attr-lookup', $curr-attr)/attr"/>
</xsl:template>
<!-- Return other information about the attribute -->
<xsl:template match="attributes" mode="getField">
	<xsl:param name="curr-attr"/>
	<xsl:value-of select="key('attr-lookup', $curr-attr)/field"/>
</xsl:template>
<xsl:template match="attributes" mode="getType">
	<xsl:param name="curr-attr"/>
	<xsl:value-of select="key('attr-lookup', $curr-attr)/type"/>
</xsl:template>
<xsl:template match="attributes" mode="getNodeType">
	<xsl:param name="curr-attr"/>
	<xsl:value-of select="key('attr-lookup', $curr-attr)/nodeType"/>
</xsl:template>

<!-- Look up an attribute in the attribute table -->
<xsl:template name="lookupAttr">
	<xsl:param name="name"/>
	<xsl:param name="class"/>
	<xsl:variable name="attrLookup">
		<xsl:apply-templates select="$attrs-top" mode="getAttr">
			<xsl:with-param name="curr-attr" select="concat($class,translate($name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="string-length($attrLookup)>0"><xsl:value-of select="$attrLookup"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="concat('invalid:',$name)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Find invalid attributes -->
<xsl:template match="*" mode="Invalid">
	<xsl:param name="class"/>
	<xsl:variable name="attrLookup">
		<xsl:apply-templates select="$attrs-top" mode="getAttr">
			<xsl:with-param name="curr-attr" select="concat($class,translate(@name,$uppercase,$lowercase))"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:if test="string-length($attrLookup)=0">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid attribute:',@name,' '))"></xsl:if>
	</xsl:if>
</xsl:template>

<!-- Given a dn, return the class that corresponds to the organizational unit (ou):
	(O)rganization),(I)ndividual,(C)redential,(R)elationship,(M)embership,(S)ervice.
    Note that there is still no specification for the ou of the Membership or Service class. -->
<xsl:template name="getClass">
	<xsl:param name="dn"/>
	<xsl:variable name="ou" select="substring-before(substring-after(translate($dn,$uppercase,$lowercase),'ou='),',')"/>
	 <xsl:choose>
		<xsl:when test="$ou='hcprofessional'">I</xsl:when>
		<xsl:when test="$ou='hcregulatedorganization'">O</xsl:when>
		<xsl:when test="$ou='hpdcredential'">C</xsl:when>
		<xsl:when test="$ou='relationship'">R</xsl:when>
		<xsl:when test="contains($ou,'membership')">M</xsl:when>
		<xsl:when test="contains($ou,'service')">S</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Given a class, return the corresponding organization unit (ou).
      Note that there is still no agreement for the ou of the Service or Membership classes -->
<xsl:template name="getOu">
	<xsl:param name="class"/>
	<xsl:choose>
		<xsl:when test="$class='I'">HCProfessional</xsl:when>
		<xsl:when test="$class='O'">HCRegulatedOrganization</xsl:when>
		<xsl:when test="$class='R'">Relationship</xsl:when>
		<xsl:when test="$class='C'">HPDCredential</xsl:when>
		<xsl:when test="$class='S'">Service</xsl:when>
		<xsl:when test="$class='M'">Membership</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Adds a "dn" attribute to an XML element -->
<xsl:template name="makeDN">
	<xsl:param name="ou"/>
	<xsl:param name="rdn"/>
	<xsl:param name="rdnType" select="'uid'"/>
	<xsl:value-of select="concat($rdnType,'=',$rdn,',ou=',$ou,',o=ISC,dc=HPD')"/>
</xsl:template>

<!-- Given a class and a dn, return the rdn -->
<xsl:template name="getRdn">
	<xsl:param name="class"/>
	<xsl:param name="dn"/>
	<xsl:variable name="rdn">
		<xsl:call-template name="getUid">
			<xsl:with-param name="dn" select="$dn"/>
			<xsl:with-param name="uidAttr">
				<xsl:call-template name="getUidAttr">
					<xsl:with-param name="class" select="$class"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="(string-length($rdn)=0) and string-length($dn)>0">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid rdn:',isc:evaluate('piece',$dn,',',1),' '))"></xsl:if>
	</xsl:if>
	<xsl:value-of select="$rdn"/>
</xsl:template>

<!-- Get the name of the hpd Attr that uniquely identifies an Organizational Unit -->
<xsl:template name="getUidAttr">
	<xsl:param name="class"/>
	<xsl:choose>
		<xsl:when test="$class='R'">cn</xsl:when>
		<xsl:when test="$class='M'">hpdMemberId</xsl:when>
		<xsl:when test="$class='S'">hpdServiceId</xsl:when>
		<xsl:otherwise>uid</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Given a dn, return the unique identifier for the organizational unit, if there, ignoring case -->
<xsl:template name="getUid">
	<xsl:param name="dn"/>
	<xsl:param name="uidAttr" select="'uid'"/>
	<xsl:choose>
		<xsl:when test="contains(translate($dn,$uppercase,$lowercase),concat(translate($uidAttr,$uppercase,$lowercase),'='))">
			<xsl:value-of select="isc:evaluate('piece',substring-after($dn,'='),',',1)"/>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
</xsl:template>

<!-- Given a (lowest-level) object class, return the corresponding internal class code:
(O)rganization),(I)ndividual,(C)redential,(R)elationship,(M)embership,(S)ervice.
-->
<xsl:template name="getClassFromObjClass">
	<xsl:param name="objClass"/>
	<xsl:variable name="lcObjClass" select="translate($objClass,$uppercase,$lowercase)"/>	
	 <xsl:choose>
		<xsl:when test="$lcObjClass='hcprofessional'">I</xsl:when>
		<xsl:when test="$lcObjClass='hcregulatedorganization'">O</xsl:when>
		<xsl:when test="$lcObjClass='hpdprovidercredential'">C</xsl:when>
		<xsl:when test="$lcObjClass='relationship'">R</xsl:when>
		<xsl:when test="$lcObjClass='hpdprovidermembership'">M</xsl:when>		
		<xsl:when test="$lcObjClass='hpdelectronicservice'">S</xsl:when>		
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Dispatcher to extract multiple fields out of a single value -->
<xsl:template name="extractValues">
	<xsl:param name="attr"/>
	<xsl:param name="value"/>
	<xsl:param name="type"/>
	<xsl:param name="update" select="0"/>
	<xsl:choose>
		<xsl:when test="$attr='Address'">
			<xsl:call-template name="extractAddress">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="update" select="$update"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='Phone'">
			<xsl:call-template name="extractPhone">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="type" select="$type"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='Language'">
			<xsl:call-template name="extractLanguage">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="update" select="$update"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='Credential'">
			<xsl:call-template name="extractCredential">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="update" select="$update"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='Identifier'">
			<xsl:call-template name="extractIdentifier">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="update" select="$update"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='Specialty'">
			<xsl:call-template name="extractSpecialty">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="update" select="$update"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='CredNumber'">
			<xsl:call-template name="extractCredentialNumber">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$attr='CredName'">
			<xsl:call-template name="extractCredentialName">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:when>
				<xsl:when test="$attr='IntegrationProfile'">
			<xsl:call-template name="extractProfile">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:when>
				<xsl:when test="$attr='ContentProfile'">
			<xsl:call-template name="extractProfile">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Returns a language structure from a DSML language field 
	  Expects a language code optionally followed by a fluency percentage.
	  en and en-gb are both considered to be English.
	  Fluency follows ;q=, experssed as a decimal (e.g. en;q=.8)
-->
<xsl:template name="extractLanguage">
	<xsl:param name="value"/>
	<xsl:param name="update"/>
	<xsl:variable name="codeTemp" select="isc:evaluate('piece',$value,';q=',1)"/>	
	<xsl:variable name="code" select="isc:evaluate('piece',$codeTemp,'-',1)"/>	
	<xsl:variable name="fluency" select="isc:evaluate('piece',$value,';q=',2)"/>	
	<xsl:variable name="error">
		<xsl:if test="$update=1 and string-length($fluency)>0 and string(number($fluency))='NaN'">
			<xsl:value-of select="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid language fluency:',$fluency,' '))"/>
		</xsl:if>
	</xsl:variable>
	<Language>
		<Code><xsl:value-of select="$code"/></Code>
		<xsl:if test="string-length($fluency)>0 and not(string(number($fluency))='NaN')">
			<Fluency><xsl:value-of select="$fluency"/></Fluency>
		</xsl:if>
	</Language>
</xsl:template>

<!-- Returns an Identifier structure from a DSML identifier field.  Assumes AA:Type:ID:Status.
	  AA and Status are optional.
      Type isn't input as it is derived from the assigning authority.
-->
<xsl:template name="extractIdentifier">
	<xsl:param name="value"/>
	<xsl:param name="update"/>
	<!-- Were colon pieces entered? -->
	<xsl:variable name="compound">
		<xsl:choose>
			<xsl:when test="contains($value,':') or contains(isc:evaluate('piece',$value,':',1),'.')">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="aa">
		<xsl:if test="$compound=1">
			<xsl:value-of select="isc:evaluate('OIDtoCode',isc:evaluate('piece',$value,':',1))"/>
		</xsl:if>
	</xsl:variable>
	<xsl:if test="contains($aa,'Unknown OID')">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',$aa)"></xsl:if>
	</xsl:if>
	<xsl:variable name="ident">
		<xsl:choose>
			<xsl:when test="$compound=1"><xsl:value-of select="isc:evaluate('piece',$value,':',3)"/>	</xsl:when>
			<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="type">
		<xsl:value-of select="isc:evaluate('piece',$value,':',2)"/>
	</xsl:variable>
	<xsl:variable name="status">
		<xsl:call-template name="convertDisplayValue">
			<xsl:with-param name="value" select="isc:evaluate('piece',$value,':',4)"/>
			<xsl:with-param name="type" select="'A,I,R,S'"/>
			<xsl:with-param name="attrName" select="'hcIdentifier Status'"/>
		</xsl:call-template>		
	</xsl:variable>

	<Identifier>
		<xsl:if test="string-length($aa)>0">
			<AssigningAuthorityName>
				<xsl:value-of select="$aa"/>
			</AssigningAuthorityName>
		</xsl:if>
		<xsl:if test="(string-length($ident)>0) or (string-length(concat($aa,$type,$status))=0)">
			<Extension>
				<xsl:value-of select="$ident"/>
			</Extension>
		</xsl:if>
		<xsl:if test="string-length($type)>0">
			<Type>
				<xsl:value-of select="$type"/>
			</Type>
		</xsl:if>
		<xsl:if test="string-length($status)>0">
			<Status>
				<xsl:value-of select="$status"/>
			</Status>	
		</xsl:if>
	</Identifier>
</xsl:template>

<!-- Returns a Specialty code structure from a DSML field. 
-->
<xsl:template name="extractSpecialty">
	<xsl:param name="value"/>
	<xsl:param name="update"/>

	<!-- Were colon pieces entered? -->
	<xsl:variable name="compound">
		<xsl:choose>
			<xsl:when test="contains($value,':')">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Was just a number entered? -->
	<xsl:variable name="string">
		<xsl:choose>
			<xsl:when test="string(number($value))='NaN'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="codeSystem">
		<xsl:if test="$compound=1">
			<xsl:value-of select="isc:evaluate('OIDtoCode',isc:evaluate('piece',$value,':',2))"/>		
		</xsl:if>
	</xsl:variable>
	<xsl:if test="contains($codeSystem,'Unknown OID')">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',$codeSystem)"></xsl:if>
	</xsl:if>
	<xsl:variable name="code">
		<xsl:choose>
			<xsl:when test="$compound=1">
				<xsl:value-of select="isc:evaluate('piece',$value,':',3)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$string=0"><xsl:value-of select="$value"/></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="desc">
		<xsl:choose>
			<xsl:when test="$compound=1">
				<xsl:value-of select="isc:evaluate('piece',$value,':',4)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$string=1"><xsl:value-of select="$value"/></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<Specialty>
		<xsl:if test="string-length($codeSystem)>0">
			<CodeSystem>
				<xsl:value-of select="$codeSystem"/>
			</CodeSystem>
		</xsl:if>
		<xsl:if test="string-length($code)>0 or string-length($desc)=0">
			<Code>
				<xsl:value-of select="$code"/>
			</Code>
		</xsl:if>
		<xsl:if test="string-length($desc)>0">
			<Description>
				<xsl:value-of select="$desc"/>
			</Description>
		</xsl:if>
	</Specialty>
</xsl:template>

<!-- Returns a credential structure from a DSML credential DN
	  Expects credentialId or licensing authority OID:credential number,
	  Note that the CredNumber must be flattened for the Search only.
-->
<xsl:template name="extractCredential">
	<xsl:param name="value"/>
	<xsl:param name="update"/>
	
	<xsl:variable name="id" select="isc:evaluate('piece',substring-after($value,'credentialId='),',',1)"/>	
	<xsl:variable name="numberPiece" select="isc:evaluate('piece',substring-after($value,'credentialNumber='),',',1)"/>	
	<xsl:variable name="liscAuth" select="isc:evaluate('OIDtoCode',isc:evaluate('piece',$numberPiece,':',1))"/>
	<xsl:variable name="number" select="isc:evaluate('piece',$numberPiece,':',2)"/>
	<xsl:if test="contains($liscAuth,'Unknown OID')">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',$liscAuth)"></xsl:if>
	</xsl:if>
	
	<Credential>
		<xsl:if test="string-length($id)>0 or (string-length(concat($number,$liscAuth))=0)">
			<Idx><xsl:value-of select="$id"/></Idx>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$update=1">
				<xsl:if test="string-length($number)>0">
					<CredNumber>
						<Extension><xsl:value-of select="$number"/></Extension>
						<xsl:if test="string-length($liscAuth)>0">
							<AssigningAuthorityName><xsl:value-of select="$liscAuth"/></AssigningAuthorityName>
						</xsl:if>
					</CredNumber>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($number)>0">
					<CredNumber_Extension><xsl:value-of select="$number"/></CredNumber_Extension>
				</xsl:if>
				<xsl:if test="string-length($liscAuth)>0">
					<CredNumber_AssigningAuthorityName><xsl:value-of select="$liscAuth"/></CredNumber_AssigningAuthorityName>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</Credential>
</xsl:template>

<!-- Expects a licensing authority AA followed by a colon and the credential number (e..g StateMedicalBoard:12345) 
      or just a credential number
-->
<xsl:template name="extractCredentialNumber">
	<xsl:param name="value"/>
	<xsl:param name="update"/>
	
	<xsl:variable name="piece1" select="isc:evaluate('piece',$value,':',1)"/>	
	<xsl:variable name="piece2" select="isc:evaluate('piece',$value,':',2)"/>	
	<xsl:variable name="number">
		<xsl:choose>
			<xsl:when test="string-length($piece2)>0"><xsl:value-of select="$piece2"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$piece1"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="liscAuth">
		<xsl:if test="string-length($piece2)>0">
			<xsl:value-of select="isc:evaluate('OIDtoCode',$piece1)"/>
		</xsl:if>
	</xsl:variable>
	<xsl:if test="contains($liscAuth,'Unknown OID')">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',$liscAuth)"></xsl:if>
	</xsl:if>
	
	<CredNumber>
		<CredNumber_Extension>
			<xsl:value-of select="$number"/>
		</CredNumber_Extension>	
		<xsl:if test="string-length($liscAuth)>0">
			<CredNumber_AssigningAuthorityName>
				<xsl:value-of select="$liscAuth"/>
			</CredNumber_AssigningAuthorityName>
		</xsl:if>
	</CredNumber>
</xsl:template>

<!-- Extract the name and domain from a credential name -->
<xsl:template name="extractCredentialName">
	<xsl:param name="value"/>
	
	<xsl:variable name="name" select="isc:evaluate('piece',$value,'@',1)"/>
	<xsl:variable name="domain" select="isc:evaluate('piece',$value,'@',2)"/>
	
	<Credential>
		<CredName><xsl:value-of select="$name"/></CredName>
		<xsl:if test="string-length($domain)>0">
			<CredDomainName><xsl:value-of select="$domain"/></CredDomainName>
		</xsl:if>
	</Credential>
</xsl:template>

<!-- Returns an address structure from a DSML address field
	  Expects an optional status field, optionally followed by the parts of the address, which are name/value pairs preceded by dollar signs.
-->
<xsl:template name="extractAddress">
	<xsl:param name="value"/>
	<xsl:param name="type"/>
	<xsl:param name="update"/>
	
	<xsl:variable name="status">
		<xsl:call-template name="convertDisplayValue">
			<xsl:with-param name="value" select="isc:evaluate('pieceStrip',substring-after($value,'status='),'$',1)"/>
			<xsl:with-param name="type" select="'A,I,1,0'"/>
			<xsl:with-param name="attrName" select="'Address Status'"/>
		</xsl:call-template>		
	</xsl:variable>
	<xsl:variable name="addr" select="isc:evaluate('pieceStrip',substring-after($value,'addr='),'$',1)"/>
	<xsl:variable name="streetNumber" select="isc:evaluate('pieceStrip',substring-after($value,'streetNumber='),'$',1)"/>
	<xsl:variable name="streetName" select="isc:evaluate('pieceStrip',substring-after($value,'streetName='),'$',1)"/>
	<xsl:variable name="city" select="isc:evaluate('pieceStrip',substring-after($value,'city='),'$',1)"/>
	<xsl:variable name="state" select="isc:evaluate('pieceStrip',substring-after($value,'state='),'$',1)"/>
	<xsl:variable name="postalCode" select="isc:evaluate('pieceStrip',substring-after($value,'postalCode='),'$',1)"/>
	<xsl:variable name="country" select="isc:evaluate('pieceStrip',substring-after($value,'country='),'$',1)"/>

	<PrvAddress>
		<xsl:if test="string-length($status)>0">
			<xsl:choose>
				<xsl:when test="$status='1'">
					<PrimaryFlag>1</PrimaryFlag>
				</xsl:when>
				<xsl:when test="$status='0'">
					<PrimaryFlag>0</PrimaryFlag>
				</xsl:when>
				<xsl:otherwise>
					<Status><xsl:value-of select="$status"/></Status>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="string-length($streetNumber)>0">
			<StreetNumber><xsl:value-of select="$streetNumber"/></StreetNumber>
		</xsl:if>
		<xsl:if test="string-length($streetName)>0">
			<StreetName><xsl:value-of select="$streetName"/></StreetName>
		</xsl:if>
		<xsl:if test="$update = 1">
			<xsl:if test="string-length($streetNumber)>0 or string-length($streetName)>0">
				<StreetLine>
					<xsl:value-of select="concat($streetNumber,' ',$streetName)"/>
				</StreetLine>
			</xsl:if>
		</xsl:if>
		<xsl:if test="string-length($city)>0">
			<City><xsl:value-of select="$city"/></City>
		</xsl:if>
		<xsl:if test="string-length($state)>0">
			<State><xsl:value-of select="$state"/></State>
		</xsl:if>
		<xsl:if test="string-length($postalCode)>0">
			<PostalCode><xsl:value-of select="$postalCode"/></PostalCode>
		</xsl:if>
		<xsl:if test="string-length($country)>0">
			<Country><xsl:value-of select="$country"/></Country>
		</xsl:if>
		<xsl:if test="string-length($value)>0 and (string-length($streetNumber)+string-length($streetName)+string-length($city)+string-length($state)+string-length($postalCode)+string-length($country)=0)">
			<TextAddress>
				<xsl:choose>
					<xsl:when test="string-length($addr)>0 "><xsl:value-of select="$addr"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
				</xsl:choose>
			</TextAddress>
		</xsl:if>
		<Use><xsl:value-of select="$type"/></Use>
	</PrvAddress>
</xsl:template>

<!-- Extracts individual phone fields from a single phone number formatted according to ITI TF-2a 3.24.5.2.3.3 Phone Numbers:
		National notation       (042) 123 4567
		International notation  +31 42 123 4567
	and adds the appropriate properties indicating the type of phone
-->
<xsl:template name="extractPhone">
	<xsl:param name="value"/>
	<xsl:param name="type"/>
	<xsl:variable name="normalPhone" select="translate(translate($value,'+()',''),'./\ ','----')"/>
	<xsl:if test="not(contains($normalPhone,'-'))">
		<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid phone:',$value,' '))"/>
	</xsl:if>
	<xsl:variable name="country">
		<xsl:if test="substring($value,1,1)='+'"><xsl:value-of select="isc:evaluate('piece',$normalPhone,'-',1)"/></xsl:if>
	</xsl:variable>
	<Phone>
		<xsl:choose>
			<xsl:when test="string-length($country)>0">
				<xsl:variable name="phone" select="substring-after($normalPhone,concat($country,'-'))"/>
				<PhoneCountryCode><xsl:value-of select="$country"/></PhoneCountryCode>
				<PhoneAreaCode><xsl:value-of select="substring-before($phone,'-')"/></PhoneAreaCode>
				<PhoneNumber><xsl:value-of select="substring-after($phone,'-')"/></PhoneNumber>
			</xsl:when>
			<xsl:otherwise>
				<PhoneAreaCode><xsl:value-of select="substring-before($normalPhone,'-')"/></PhoneAreaCode>
				<PhoneNumber><xsl:value-of select="substring-after($normalPhone,'-')"/></PhoneNumber>		
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$type='L'">
			<Use>WP</Use>
		</xsl:if>
		<Type><xsl:value-of select="$type"/></Type>
	</Phone>
</xsl:template>

<xsl:template name="extractProfile">
	<xsl:param name="value"/>
	<xsl:variable name="version"><xsl:value-of select="isc:evaluate('pieceStrip',$value,'$',2)"/></xsl:variable>
	<xsl:variable name="option"><xsl:value-of select="isc:evaluate('pieceStrip',$value,'$',3)"/></xsl:variable>
	<Profile>
		<Code><xsl:value-of select="isc:evaluate('pieceStrip',$value,'$',1)"/></Code>
		<xsl:if test="string-length($version)>0">
			<Version><xsl:value-of select="$version"/></Version>
		</xsl:if>
		<xsl:if test="string-length($option)>0">
			<Option><xsl:value-of select="$option"/></Option>
		</xsl:if>
	</Profile>
</xsl:template>

<!-- Returns a structure containing the ID and type of an organization based on its dn -->
<xsl:template name="extractOrganizationID">
	<xsl:param name="dn"/>
	<xsl:variable name="ou">
        <xsl:value-of select="substring-before(substring-after(translate($dn,$uppercase,$lowercase),'ou='),',')"/>
    </xsl:variable>
    <xsl:variable name="uid">
		<xsl:call-template name="getUid">
			<xsl:with-param name="dn" select="$dn"/>
			<xsl:with-param name="uidAttr" select="'uid'"/>
		</xsl:call-template>
    </xsl:variable>
    <xsl:variable name="cn">
		<xsl:call-template name="getUid">
			<xsl:with-param name="dn" select="$dn"/>
			<xsl:with-param name="uidAttr" select="'cn'"/>
		</xsl:call-template>
    </xsl:variable>
     <xsl:variable name="owner">
		<xsl:call-template name="getUid">
			<xsl:with-param name="dn" select="$dn"/>
			<xsl:with-param name="uidAttr" select="'owner'"/>
		</xsl:call-template>
    </xsl:variable>
    <xsl:variable name="IdElement">
    	<xsl:choose>
			<xsl:when test="string-length($owner)>0">UniqueID</xsl:when>
			<xsl:when test="contains($ou,'relationship')">GroupName</xsl:when>
			<xsl:when test="string-length($cn)>0">DisplayName</xsl:when>
			<xsl:when test="string-length($uid)>0">UniqueID</xsl:when>
			<xsl:otherwise>Invalid</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>
    <IDOrganization>
		<xsl:element name="{$IdElement}">
			<xsl:choose>
				<xsl:when test="string-length($cn)>0"><xsl:value-of select="$cn"/></xsl:when>
				<xsl:when test="string-length($uid)>0"><xsl:value-of select="$uid"/></xsl:when>
				<xsl:when test="string-length($owner)>0"><xsl:value-of select="$owner"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$dn"/></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</IDOrganization>
</xsl:template>

<!-- Concatenate the member class - (I)ndividual vs. (O)rganization - onto the Member uid-->
<xsl:template name="extractMemberID">
	<xsl:param name="dn"/>			
	<xsl:call-template name="getClass">
		<xsl:with-param name="dn" select="."/>
	</xsl:call-template>
	<xsl:call-template name="getUid">
		<xsl:with-param name="dn" select="."/>
	</xsl:call-template>
</xsl:template>	

<!-- Return an error message or success indicator -->
<xsl:template name="LDAPResult" xmlns="urn:oasis:names:tc:DSML:2:0:core">
	<xsl:param name="message"/>
	<xsl:param name="resultCode"/>
	
	<resultCode>
		<xsl:attribute name="code">
			<xsl:choose>
				<xsl:when test="string-length($resultCode)>0"><xsl:value-of select="$resultCode"/></xsl:when>
				<xsl:when test="string-length($message)>0">53</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="descr">
			<xsl:choose>
				<xsl:when test="string-length($resultCode)>0">
					<xsl:choose>
						<xsl:when test="$resultCode='1'">operationsError</xsl:when>
						<xsl:when test="$resultCode='2'">protocolError</xsl:when>
						<xsl:when test="$resultCode='3'">timeLimitExceeded</xsl:when>
						<xsl:when test="$resultCode='4'">sizeLimitExceeded</xsl:when>
						<xsl:when test="$resultCode='7'">authMethodNotSupported</xsl:when>
						<xsl:when test="$resultCode='13'">confidentialityRequired</xsl:when>
						<xsl:when test="$resultCode='16'">noSuchAttribute</xsl:when>
						<xsl:when test="$resultCode='17'">undefinedAttributeType</xsl:when>
						<xsl:when test="$resultCode='18'">inappropriateMatching</xsl:when>
						<xsl:when test="$resultCode='19'">constraintViolation</xsl:when>
						<xsl:when test="$resultCode='20'">AttributeOrValueExists</xsl:when>
						<xsl:when test="$resultCode='32'">noSuchObject</xsl:when>
						<xsl:when test="$resultCode='34'">invalidDNSyntax</xsl:when>
						<xsl:when test="$resultCode='49'">invalidCredentials</xsl:when>
						<xsl:when test="$resultCode='53'">unwillingToPerform</xsl:when>
						<xsl:when test="$resultCode='50'">insufficientAccessRights</xsl:when>
						<xsl:when test="$resultCode='68'">entryAlreadyExists</xsl:when>
						<xsl:when test="$resultCode='80'">other</xsl:when>
						<xsl:otherwise>other</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="string-length($message)>0">unwillingToPerform</xsl:when>
				<xsl:otherwise>success</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</resultCode>
	<xsl:if test="string-length($message)>0">
		 <errorMessage><xsl:value-of select="$message"/></errorMessage>
	</xsl:if>
</xsl:template>

<!-- Convert display value to logical value -->
<xsl:template name="convertDisplayValue">
	<xsl:param name="value"/>
	<xsl:param name="type"/>
	<xsl:param name="attrName"/>
	<xsl:if test="string-length($value)>0">
		<xsl:variable name="display"><xsl:value-of select="translate($value,$uppercase,$lowercase)"/></xsl:variable>
		<xsl:variable name="logical">
			<xsl:choose>
				<!--Status-->
				<xsl:when test="$display='active'">A</xsl:when>
				<xsl:when test="$display='inactive'">I</xsl:when>
				<!-- Individual-provider-specific status -->
				<xsl:when test="$display='retired'">R</xsl:when>
				<xsl:when test="$display='deceased'">D</xsl:when>
				<!-- Credential-specific status -->
				<xsl:when test="$display='suspended'">S</xsl:when>
				<xsl:when test="$display='revoked'">R</xsl:when>
				<!-- Address-specific status -->
				<xsl:when test="$display='primary'">1</xsl:when>
				<xsl:when test="$display='secondary'">0</xsl:when>
				<!--Credential Type-->
				<xsl:when test="$display='degree'">D</xsl:when>
				<xsl:when test="$display='credential'">C</xsl:when>
				<xsl:when test="$display='certificate'">R</xsl:when>
				<!--Gender-->
				<xsl:when test="$display='m'">M</xsl:when>
				<xsl:when test="$display='f'">F</xsl:when>
				<xsl:when test="$display='o'">O</xsl:when>
				<xsl:when test="$display='u'">U</xsl:when>
				<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains(concat(',',$type,','),concat(',',$logical,','))">
					<xsl:value-of select="$logical"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="isc:evaluate('varConcat', 'HPDErrorMessage',concat('Invalid ',$attrName,':',$value,' '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
</xsl:template>

<!-- Return an error message, either cached or explicitly passed in -->
<xsl:template name="ErrorMessage">
	<xsl:param name="message"/>
	<ErrorMessage>
		<xsl:choose>
			<xsl:when test="string-length($message) = 0">
				<xsl:value-of select="isc:evaluate('varGet', 'HPDErrorMessage')"/>		
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$message"/>
			</xsl:otherwise>
		</xsl:choose>
	</ErrorMessage>
</xsl:template>


<!-- A class could not be ascertained from the ou in the dn -->
<xsl:template name="NoClassErrorMessage">
	<xsl:param name="class"/>
	<xsl:call-template name="ErrorMessage">
		<xsl:with-param name="message">
			<xsl:if test="string-length($class)=0">A valid organizational unit must be specified</xsl:if>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
