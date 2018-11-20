<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 			xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				xmlns:tns="urn:bean.initiate.com"
				exclude-result-prefixes="tns"
				version="1.0">
	
	<!-- Additional parameters -->
	<xsl:param name="USERNAME">rwuser</xsl:param>
	<xsl:param name="PASSWORD">rwuser</xsl:param>
	<xsl:param name="MAXROWS">50</xsl:param>
	<xsl:param name="MINSCORE">1</xsl:param>
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<!-- Match an PatientSearchRequest -->
	<xsl:template match="/PatientSearchRequest">
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			 			  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
						  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<soapenv:Body>
				<searchMember xmlns="urn:bean.initiate.com">
					<memSrchReq xmlns="">
						<userPassword>
							<xsl:value-of select="$PASSWORD"/>
						</userPassword>
						<userName>
							<xsl:value-of select="$USERNAME"/>
						</userName>
						<audMode xsi:nil="true"/>
						<cvwName xsi:nil="true"/>
						<recStatFilter xsi:nil="true"/>
						<maxRows>
							<xsl:value-of select="$MAXROWS"/>
						</maxRows>
						<segCodeFilter>MEMHEAD,MEMADDR,MEMATTR,MEMDATE,MEMIDENT,MEMNAME,MEMPHONE</segCodeFilter>
						<getType>ASENTITY</getType>
						<memType>PERSON</memType>
						<segAttrFilter xsi:nil="true"/>
						<member>
							<memDrug xsi:nil="true"/>
							<entLink xsi:nil="true"/>
							<memIds xsi:nil="true"/>
							<entIque xsi:nil="true"/>
							<memAppt xsi:nil="true"/>
							<memRule xsi:nil="true"/>
							<memExtc xsi:nil="true"/>
							<memCmpd xsi:nil="true"/>
							<memAddr>
								<item>
									<rowInd xsi:nil="true"/>
									<memRecno>0</memRecno>
									<memIdnum xsi:nil="true"/>
									<entRecno>0</entRecno>
									<srcCode xsi:nil="true"/>
									<recStat xsi:nil="true"/>
									<caudRecno>0</caudRecno>
									<asaIdxno>0</asaIdxno>
									<attrCode>HOMEADDR</attrCode>
									<maudRecno>0</maudRecno>
									<attrName xsi:nil="true"/>
									<recCtime xsi:nil="true"/>
									<recMtime xsi:nil="true"/>
									<srcFtime xsi:nil="true"/>
									<srcLtime xsi:nil="true"/>
									<memSeqno>0</memSeqno>
									<attrRecno>0</attrRecno>
									<stLine4 xsi:nil="true"/>
									<xsl:choose>
										<xsl:when test="Street != ''">
											<stLine1>
												<xsl:value-of select="Street"/>
											</stLine1>
										</xsl:when>
										<xsl:otherwise>
											<stLine1 xsi:nil="true"/>
										</xsl:otherwise>
									</xsl:choose>
									<geoCode2 xsi:nil="true"/>
									<geoText1 xsi:nil="true"/>
									<stLine2 xsi:nil="true"/>
									<geoCode1 xsi:nil="true"/>
									<xsl:choose>
										<xsl:when test="City != ''">
											<city>
												<xsl:value-of select="City"/>
											</city>
										</xsl:when>
										<xsl:otherwise>
											<city xsi:nil="true"/>
										</xsl:otherwise>
									</xsl:choose>
									<stLine3 xsi:nil="true"/>
									<country xsi:nil="true"/>
									<xsl:choose>
										<xsl:when test="Zip != ''">
											<zipCode>
												<xsl:value-of select="Zip"/>
											</zipCode>
										</xsl:when>
										<xsl:otherwise>
											<zipCode xsi:nil="true"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="State != ''">
											<state>
												<xsl:value-of select="State"/>
											</state>
										</xsl:when>
										<xsl:otherwise>
											<state xsi:nil="true"/>
										</xsl:otherwise>
									</xsl:choose>
								</item>
							</memAddr>
							<memXtsk xsi:nil="true"/>
							<entXtsk xsi:nil="true"/>
							<xsl:choose>
								<xsl:when test="Telephone != ''">
									<memPhone>
										<item>
											<rowInd xsi:nil="true"/>
											<memRecno>0</memRecno>
											<memIdnum xsi:nil="true"/>
											<entRecno>0</entRecno>
											<srcCode xsi:nil="true"/>
											<recStat xsi:nil="true"/>
											<caudRecno>0</caudRecno>
											<asaIdxno>0</asaIdxno>
											<attrCode>DAYPHONE</attrCode>
											<maudRecno>0</maudRecno>
											<attrName xsi:nil="true"/>
											<recCtime xsi:nil="true"/>
											<recMtime xsi:nil="true"/>
											<srcFtime xsi:nil="true"/>
											<srcLtime xsi:nil="true"/>
											<memSeqno>0</memSeqno>
											<attrRecno>0</attrRecno>
  											<phIcc xsi:nil="true" /> 
  											<phCmnt xsi:nil="true" /> 
  											<phArea xsi:nil="true" /> 
											<phNumber>
  												<xsl:value-of select="Telephone" /> 
  											</phNumber>
											<phExtn xsi:nil="true" /> 
										</item>
									</memPhone>
								</xsl:when>
								<xsl:otherwise>
									<memPhone xsi:nil="true"/>
								</xsl:otherwise>
							</xsl:choose>

							<memExtb xsi:nil="true"/>
							<memOque xsi:nil="true"/>
							<memAttr>
								<xsl:if test="Facility != ''">
									<item>
										<rowInd xsi:nil="true"/>
										<entRecno>0</entRecno>
										<memIdnum xsi:nil="true"/>
										<memRecno>0</memRecno>
										<srcCode xsi:nil="true"/>
										<asaIdxno>0</asaIdxno>
										<attrCode>FACILITY</attrCode>
										<attrName xsi:nil="true"/>
										<attrRecno>0</attrRecno>
										<caudRecno>0</caudRecno>
										<maudRecno>0</maudRecno>
										<memSeqno>0</memSeqno>
										<recCtime xsi:nil="true"/>
										<recMtime xsi:nil="true"/>
										<recStat xsi:nil="true"/>
										<srcFtime xsi:nil="true"/>
										<srcLtime xsi:nil="true"/>
										<attrVal>
											<xsl:value-of select="Facility"/>
										</attrVal>
									</item>
								</xsl:if>
								<xsl:if test="Sex != ''">
									<item>
										<rowInd xsi:nil="true"/>
										<memRecno>0</memRecno>
										<memIdnum xsi:nil="true"/>
										<entRecno>0</entRecno>
										<srcCode xsi:nil="true"/>
										<recStat xsi:nil="true"/>
										<caudRecno>0</caudRecno>
										<asaIdxno>0</asaIdxno>
										<attrCode>SEX</attrCode>
										<maudRecno>0</maudRecno>
										<attrName xsi:nil="true"/>
										<recCtime xsi:nil="true"/>
										<recMtime xsi:nil="true"/>
										<srcFtime xsi:nil="true"/>
										<srcLtime xsi:nil="true"/>
										<memSeqno>0</memSeqno>
										<attrRecno>0</attrRecno>
										<attrVal>
											<xsl:value-of select="Sex"/>
										</attrVal>
									</item>
								</xsl:if>
								<xsl:for-each select="Identifiers/Identifier[Use='SN']">
									<item>
										<rowInd xsi:nil="true"/>
										<memRecno>0</memRecno>
										<memIdnum xsi:nil="true"/>
										<entRecno>0</entRecno>
										<srcCode xsi:nil="true"/>
										<recStat xsi:nil="true"/>
										<caudRecno>0</caudRecno>
										<asaIdxno>0</asaIdxno>
										<attrCode>INSNO</attrCode>
										<maudRecno>0</maudRecno>
										<attrName xsi:nil="true"/>
										<recCtime xsi:nil="true"/>
										<recMtime xsi:nil="true"/>
										<srcFtime xsi:nil="true"/>
										<srcLtime xsi:nil="true"/>
										<memSeqno>0</memSeqno>
										<attrRecno>0</attrRecno>
										<attrVal>
											<xsl:value-of select="Extension"/>
										</attrVal>
									</item>
								</xsl:for-each>
							</memAttr>
							<memXeia xsi:nil="true"/>
							<memEnum xsi:nil="true"/>
							<memExta xsi:nil="true"/>
							<memHead>
								<rowInd xsi:nil="true"/>
								<memRecno>0</memRecno>
								<xsl:choose>
									<xsl:when test="MRN != ''">
										<memIdnum>
											<xsl:value-of select="MRN"/>
										</memIdnum>
									</xsl:when>
									<xsl:otherwise>
										<memIdnum xsi:nil="true"/>
									</xsl:otherwise>
								</xsl:choose>
								<entRecno>0</entRecno>
								<xsl:choose>
									<xsl:when test="AssigningAuthority != ''">
										<srcCode>
											<xsl:value-of select="AssigningAuthority"/>
										</srcCode>
									</xsl:when>
									<xsl:otherwise>
										<srcCode xsi:nil="true"/>
									</xsl:otherwise>
								</xsl:choose>
								<caudRecno>0</caudRecno>
								<linkType xsi:nil="true"/>
								<matchCode xsi:nil="true"/>
								<maudRecno>0</maudRecno>
								<recCtime xsi:nil="true"/>
								<recMtime xsi:nil="true"/>
								<srcFtime xsi:nil="true"/>
								<memVerno>0</memVerno>
								<srcRecno>0</srcRecno>
								<memSeqno>0</memSeqno>
								<srcLtime xsi:nil="true"/>
								<memStat xsi:nil="true"/>
								<matchScore>0</matchScore>
							</memHead>
							<xsl:choose>
								<xsl:when test="DOB != ''">
									<memDate>
										<item>
											<rowInd xsi:nil="true"/>
											<memRecno>0</memRecno>
											<memIdnum xsi:nil="true"/>
											<entRecno>0</entRecno>
											<srcCode xsi:nil="true"/>
											<recStat xsi:nil="true"/>
											<caudRecno>0</caudRecno>
											<asaIdxno>0</asaIdxno>
											<attrCode>BIRTHDT</attrCode>
											<maudRecno>0</maudRecno>
											<attrName xsi:nil="true"/>
											<recCtime xsi:nil="true"/>
											<recMtime xsi:nil="true"/>
											<srcFtime xsi:nil="true"/>
											<srcLtime xsi:nil="true"/>
											<memSeqno>0</memSeqno>
											<attrRecno>0</attrRecno>
											<dateVal>
												<xsl:value-of select="DOB"/>
											</dateVal>
										</item>
									</memDate>
								</xsl:when>
								<xsl:otherwise>
									<memDate xsi:nil="true"/>
								</xsl:otherwise>
							</xsl:choose>
							<memExtd xsi:nil="true"/>
							<entRule xsi:nil="true"/>
							<memExte xsi:nil="true"/>
							<memLink xsi:nil="true"/>
							<xsl:choose>
								<xsl:when test="(LastName != '') or (FirstName != '') or (MiddleName != '')">
									<memName>
										<item>
											<rowInd xsi:nil="true"/>
											<memRecno>0</memRecno>
											<memIdnum xsi:nil="true"/>
											<entRecno>0</entRecno>
											<srcCode xsi:nil="true"/>
											<recStat xsi:nil="true"/>
											<caudRecno>0</caudRecno>
											<asaIdxno>0</asaIdxno>
											<attrCode>LGLNAME</attrCode>
											<maudRecno>0</maudRecno>
											<attrName xsi:nil="true"/>
											<recCtime xsi:nil="true"/>
											<recMtime xsi:nil="true"/>
											<srcFtime xsi:nil="true"/>
											<srcLtime xsi:nil="true"/>
											<memSeqno>0</memSeqno>
											<attrRecno>0</attrRecno>
											<xsl:choose>
												<xsl:when test="LastName != ''">
													<onmLast>
														<xsl:value-of select="LastName"/>
													</onmLast>
												</xsl:when>
												<xsl:otherwise>
													<onmLast xsi:nil="true"/>
												</xsl:otherwise>
											</xsl:choose>
											<onmTitle xsi:nil="true"/>
											<xsl:choose>
												<xsl:when test="FirstName != ''">
													<onmFirst>
														<xsl:value-of select="FirstName"/>
													</onmFirst>
												</xsl:when>
												<xsl:otherwise>
													<onmFirst xsi:nil="true"/>
												</xsl:otherwise>
											</xsl:choose>
											<onmDegree xsi:nil="true"/>
											<onmSuffix xsi:nil="true"/>
											<xsl:choose>
												<xsl:when test="MiddleName != ''">
													<onmMiddle>
														<xsl:value-of select="MiddleName"/>
													</onmMiddle>
												</xsl:when>
												<xsl:otherwise>
													<onmMiddle xsi:nil="true"/>
												</xsl:otherwise>
											</xsl:choose>
											<onmPrefix xsi:nil="true"/>
										</item>
									</memName>
								</xsl:when>
								<xsl:otherwise>
									<memName xsi:nil="true"/>
								</xsl:otherwise>
							</xsl:choose>
							<memNote xsi:nil="true"/>
							<memCont xsi:nil="true"/>
							<compareInfo xsi:nil="true"/>
							<entNote xsi:nil="true"/>
							<entOque xsi:nil="true"/>
							<entXeia xsi:nil="true"/>
							<memQryd xsi:nil="true"/>
							<memElig xsi:nil="true"/>
							<memOref xsi:nil="true"/>
							<memBktd xsi:nil="true"/>
							<memIque xsi:nil="true"/>
							<memIdent>
								<xsl:if test="SSN != ''">
									<item>
										<rowInd xsi:nil="true"/>
										<memRecno>0</memRecno>
										<memIdnum xsi:nil="true"/>
										<entRecno>0</entRecno>
										<srcCode xsi:nil="true"/>
										<recStat xsi:nil="true"/>
										<caudRecno>0</caudRecno>
										<asaIdxno>0</asaIdxno>
										<attrCode>SSN</attrCode>
										<maudRecno>0</maudRecno>
										<attrName xsi:nil="true"/>
										<recCtime xsi:nil="true"/>
										<recMtime xsi:nil="true"/>
										<srcFtime xsi:nil="true"/>
										<srcLtime xsi:nil="true"/>
										<memSeqno>0</memSeqno>
										<attrRecno>0</attrRecno>
										<idExpDate xsi:nil="true"/>
										<idIssuer>SSA</idIssuer>
										<idSrcRecno>0</idSrcRecno>
										<idNumber>
											<xsl:value-of select="SSN"/>
										</idNumber>
									</item>
								</xsl:if>
								<xsl:apply-templates select="Identifiers/Identifier" />
							</memIdent>
						</member>
						<srcCodeFilter xsi:nil="true"/>
						<memStatFilter xsi:nil="true"/>
						<minScore>
							<xsl:value-of select="$MINSCORE"/>
						</minScore>
						<maxCand xsi:nil="true"/>
						<keySortOrder>+getMatchScore,-getSrcCode</keySortOrder>
						<entType>id</entType>
					</memSrchReq>
				</searchMember>
			</soapenv:Body>
		</soapenv:Envelope>
	</xsl:template>

<!-- Search for IDentifiers that may include an assigning authority -->
	<xsl:template match="Identifiers/Identifier">
		<xsl:if test="(Use='XX') or (Use='DL') or (Use = 'PPN')">
			<item>
				<rowInd xsi:nil="true"/>
				<memRecno>0</memRecno>
				<memIdnum xsi:nil="true"/>
				<entRecno>0</entRecno>
				<srcCode xsi:nil="true"/>
				<recStat xsi:nil="true"/>
				<caudRecno>0</caudRecno>
				<asaIdxno>0</asaIdxno>
				<xsl:choose>
					<xsl:when  test="Use = 'XX'">
						<attrCode>CORID</attrCode>
					</xsl:when>
					<xsl:when  test="Use = 'DL'">
						<attrCode>DL</attrCode>
					</xsl:when>
					<xsl:when  test="Use = 'PPN'">
						<attrCode>DL</attrCode>
					</xsl:when>
				</xsl:choose>
				<maudRecno>0</maudRecno>
				<attrName xsi:nil="true"/>
				<recCtime xsi:nil="true"/>
				<recMtime xsi:nil="true"/>
				<srcFtime xsi:nil="true"/>
				<srcLtime xsi:nil="true"/>
				<memSeqno>0</memSeqno>
				<attrRecno>0</attrRecno>
				<idExpDate xsi:nil="true"/>
				<xsl:choose>
					<xsl:when  test="AssigningAuthorityName  != ''">
						<idIssuer><xsl:value-of select="AssigningAuthorityName"/></idIssuer>
					</xsl:when>
					<xsl:otherwise>
						<idIssuer xsi:nil="true"/>
					</xsl:otherwise>
				</xsl:choose>
				<idSrcRecno>0</idSrcRecno>
				<idNumber><xsl:value-of select="Extension"/></idNumber>
			</item>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
