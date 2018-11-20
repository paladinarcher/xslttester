<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">

	<!-- Additional parameters -->
	<xsl:param name="USEFACILITY">1</xsl:param> 
	<xsl:param name="USERNAME">rwuser</xsl:param>
	<xsl:param name="PASSWORD">rwuser</xsl:param>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<!-- Match an AddPatientRequest -->
	<xsl:template match="/AddPatientRequest">
	   <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
		 				 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
		 				 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	      <soapenv:Body>
			<putMember xmlns="urn:bean.initiate.com">
			   <memPutReq xmlns="">
			      <userPassword><xsl:value-of select="$PASSWORD"/></userPassword>
			      <userName><xsl:value-of select="$USERNAME"/></userName>
			      <audMode xsi:nil="true"/>
			      <evtLocation xsi:nil="true"/>
			      <evtInitiator xsi:nil="true"/>
			      <putType>INSERT_UPDATE</putType>
			      <evtCtime xsi:nil="true"/>
			      <evtType xsi:nil="true"/>
			      <matchMode>IMMEDIATE</matchMode>
			      <member>
			         <memDrug xsi:nil="true"/>
			         <entLink xsi:nil="true"/>
			         <memIds xsi:nil="true"/>
			         <entIque xsi:nil="true"/>
			         <memAppt xsi:nil="true"/>
			         <memRule xsi:nil="true"/>
			         <memExtc xsi:nil="true"/>
			         <memCmpd xsi:nil="true"/>
				 <xsl:if test="(Street != '') or (City != '') or (State != '') or (Zip != '')">
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
			               <stLine1><xsl:value-of select="Street"/></stLine1>
			               <geoCode2 xsi:nil="true"/>
			               <geoText1 xsi:nil="true"/>
			               <stLine2 xsi:nil="true"/>
			               <geoCode1 xsi:nil="true"/>
			               <city><xsl:value-of select="City"/></city>
			               <stLine3 xsi:nil="true"/>
			               <country xsi:nil="true"/>
			               <zipCode><xsl:value-of select="Zip"/></zipCode>
			               <state><xsl:value-of select="State"/></state>
			            </item>
			         </memAddr>
				 </xsl:if>
			         <memXtsk xsi:nil="true"/>
			         <entXtsk xsi:nil="true"/>
				 <xsl:if test="(Telephone != '') or (BusinessPhone != '')">
			         <memPhone>
				    <xsl:if test="BusinessPhone != ''">
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
			               		<phIcc xsi:nil="true"/>
			               		<phCmnt xsi:nil="true"/>
			               		<phArea xsi:nil="true"/>
			              		 <phNumber><xsl:value-of select="BusinessPhone"/></phNumber>
			               		<phExtn xsi:nil="true"/>
			            	</item>
			            	</xsl:if>
				    <xsl:if test="Telephone != ''">
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
			               		<xsl:when test="BusinessPhone != ''">
			               			<attrCode>NIGHTPHONE</attrCode>
			               		</xsl:when>
			               		<xsl:otherwise>
			               			<attrCode>DAYPHONE</attrCode>
			               		</xsl:otherwise>
			               		</xsl:choose>
			               		<maudRecno>0</maudRecno>
			               		<attrName xsi:nil="true"/>
			               		<recCtime xsi:nil="true"/>
			               		<recMtime xsi:nil="true"/>
			               		<srcFtime xsi:nil="true"/>
			               		<srcLtime xsi:nil="true"/>
			               		<memSeqno>0</memSeqno>
			               		<attrRecno>0</attrRecno>
			               		<phIcc xsi:nil="true"/>
			               		<phCmnt xsi:nil="true"/>
			               		<phArea xsi:nil="true"/>
			              		 <phNumber><xsl:value-of select="Telephone"/></phNumber>
			               		<phExtn xsi:nil="true"/>
			            	</item>
				 </xsl:if>
			         </memPhone>
				 </xsl:if>
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
	                        <attrVal><xsl:value-of select="Facility"/></attrVal>
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
			               <attrVal><xsl:value-of select="Sex"/></attrVal>
			            </item>
				 </xsl:if>
	
			<xsl:for-each select="Identifiers/Identifier[Use='SN']">
			  <xsl:if test="position() &lt;= 3">
				<item>
					<rowInd xsi:nil="true"/>
					<entRecno>0</entRecno>
					<memIdnum xsi:nil="true"/>
					<memRecno>0</memRecno>
					<srcCode xsi:nil="true"/>
					<asaIdxno>0</asaIdxno>
					<attrCode>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:text>INSNO</xsl:text>
							</xsl:when>
							<xsl:when test="position() = 2">
								<xsl:text>INSNO2</xsl:text>
							</xsl:when>
							 <xsl:when test="position() = 3">
								<xsl:text>INSNO3</xsl:text>
							</xsl:when>
						</xsl:choose>
						</attrCode>
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
						<attrVal><xsl:value-of select="Extension"/></attrVal>
				</item>
			  </xsl:if>
			</xsl:for-each>
				 
			<xsl:for-each select="AdditionalInfo/AdditionalInfoItem">
			<item>
		                       	 <rowInd xsi:nil="true"/>
		                       	 <entRecno>0</entRecno>
		                        	<memIdnum xsi:nil="true"/>
		                       	 <memRecno>0</memRecno>
		                        	<srcCode xsi:nil="true"/>
		                        	<asaIdxno>0</asaIdxno>
		                        	<attrCode><xsl:value-of select="translate(@AdditionalInfoKey,$lowercase,$uppercase)"/></attrCode>
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
		                      	  <attrVal><xsl:value-of select="."/></attrVal>
			</item>
			</xsl:for-each>

			         </memAttr>
			         <memXeia xsi:nil="true"/>
			         <memEnum xsi:nil="true"/>
			         <memExta xsi:nil="true"/>
			         <memHead>
			            <rowInd xsi:nil="true"/>
			            <memRecno>0</memRecno>
						<memIdnum>
       						<xsl:value-of select="MRN"/>
      						<xsl:if test="$USEFACILITY='0'">|<xsl:value-of select="Facility"/></xsl:if>
						</memIdnum>
			            <entRecno>0</entRecno>
			            <srcCode><xsl:value-of select="AssigningAuthority"/></srcCode>
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
			         <xsl:if test="DOB != ''">
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
			               <dateVal><xsl:value-of select="DOB"/> 00:00:00</dateVal>
			            </item>
			         </memDate>
			         </xsl:if>
			         <memExtd xsi:nil="true"/>
			         <entRule xsi:nil="true"/>
			         <memExte xsi:nil="true"/>
			         <memLink xsi:nil="true"/>
				 <xsl:if test="(FirstName != '') or (MiddleName != '') or (LastName != '')">
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
			               <onmLast><xsl:value-of select="LastName"/></onmLast>
			               <onmTitle xsi:nil="true"/>
			               <onmFirst><xsl:value-of select="FirstName"/></onmFirst>
			               <onmDegree xsi:nil="true"/>
			               <onmSuffix xsi:nil="true"/>
			               <onmMiddle><xsl:value-of select="MiddleName"/></onmMiddle>
			               <onmPrefix xsi:nil="true"/>
			            </item>
			         </memName>
				 </xsl:if>
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
					<xsl:if test="(SSN != '') or (Identifiers/Identifier[Use != 'SN'] != '')">
			         <memIdent>
					   <xsl:if test="(SSN != '')" >
							<xsl:call-template  name="Identifier">
								<xsl:with-param name="Type">SSN</xsl:with-param>
 								<xsl:with-param name="ID" select="SSN" /> 
								<xsl:with-param name="AA">SSA</xsl:with-param>
							</xsl:call-template>
					   </xsl:if>
						<xsl:apply-templates select="Identifiers/Identifier[Use != 'SN'] " />
			         </memIdent>
				 </xsl:if>
			      </member>
			      <memMode>PARTIAL</memMode>
			   </memPutReq>
			</putMember>
	      </soapenv:Body>
	   </soapenv:Envelope>
	</xsl:template>

	<xsl:template match="Identifiers/Identifier">
		<xsl:call-template  name="Identifier">
			<xsl:with-param name="Type">
				<xsl:choose>
					<xsl:when test="Use = 'XX'">CORID</xsl:when>
					<xsl:otherwise><xsl:value-of select="Use"/></xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="ID" select="Extension" /> 
			<xsl:with-param name="AA">
				<xsl:choose>
			 		<xsl:when test="AssigningAuthorityName != ''"><xsl:value-of select="AssigningAuthorityName"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="Use"/></xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="Identifier">
		<xsl:param name="Type" />
 		<xsl:param name="ID" />
 		<xsl:param name="AA" />
		<item>
			<rowInd xsi:nil="true"/>
			<memRecno>0</memRecno>
			<memIdnum xsi:nil="true"/>
			<entRecno>0</entRecno>
			<srcCode xsi:nil="true"/>
			<recStat xsi:nil="true"/>
			<caudRecno>0</caudRecno>
			<asaIdxno>0</asaIdxno>
			<attrCode><xsl:value-of select="$Type"/></attrCode>
			<maudRecno>0</maudRecno>
			<attrName xsi:nil="true"/>
			<recCtime xsi:nil="true"/>
			<recMtime xsi:nil="true"/>
			<srcFtime xsi:nil="true"/>
			<srcLtime xsi:nil="true"/>
			<memSeqno>0</memSeqno>
			<attrRecno>0</attrRecno>
			<idExpDate xsi:nil="true"/>
			<idIssuer><xsl:value-of select="$AA"/></idIssuer>
			<idSrcRecno>0</idSrcRecno>
			<idNumber><xsl:value-of select="$ID"/></idNumber>
			</item>
	</xsl:template>


</xsl:stylesheet>
