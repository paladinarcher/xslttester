<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <!-- IHE constants; keep in sync with EnsLib.IHE.Common.Macros -->
   
   <!--***** Top-level variables *****-->
   <xsl:variable name="lcm" select="'urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0'"/>
   <xsl:variable name="query" select="'urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0'"/>
   <xsl:variable name="rim" select="'urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0'"/>
   <xsl:variable name="rs" select="'urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0'"/>
   <xsl:variable name="xdsb" select="'urn:ihe:iti:xds-b:2007'"/>
   <xsl:variable name="xop" select="'http://www.w3.org/2004/08/xop/include'"/>
   
   <xsl:variable name="xdsbProvideAndRegisterAction" select="'urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b'"/>
   <xsl:variable name="xdsbProvideAndRegisterRequest" select="'XDSb_ProvideAndRegisterRequest'"/>
   <xsl:variable name="xdsbProvideAndRegisterResponse" select="'XDSb_ProvideAndRegisterResponse'"/>
   <xsl:variable name="xdsbProvideAndRegisterResponseAction" select="'urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-bResponse'"/>
   
   <xsl:variable name="xdsbQueryAction" select="'urn:ihe:iti:2007:RegistryStoredQuery'"/>
   <xsl:variable name="xdsbQueryFindDocuments" select="'urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d'"/>
   <xsl:variable name="xdsbQueryFindFolders" select="'urn:uuid:958f3006-baad-4929-a4de-ff1114824431'"/>
   <xsl:variable name="xdsbQueryFindSubmissionSets" select="'urn:uuid:f26abbcb-ac74-4422-8a30-edb644bbc1a9'"/>
   <xsl:variable name="xdsbQueryGetAll" select="'urn:uuid:10b545ea-725c-446d-9b95-8aeb444eddf3'"/>
   <xsl:variable name="xdsbQueryGetAssociations" select="'urn:uuid:a7ae438b-4bc2-4642-93e9-be891f7bb155'"/>
   <xsl:variable name="xdsbQueryGetDocsAndAssociations" select="'urn:uuid:bab9529a-4a10-40b3-a01f-f68a615d247a'"/>
   <xsl:variable name="xdsbQueryGetDocuments" select="'urn:uuid:5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4'"/>
   <xsl:variable name="xdsbQueryGetFolderAndContents" select="'urn:uuid:b909a503-523d-4517-8acf-8e5834dfc4c7'"/>
   <xsl:variable name="xdsbQueryGetFolders" select="'urn:uuid:5737b14c-8a1a-4539-b659-e03a34a5e1e4'"/>
   <xsl:variable name="xdsbQueryGetFoldersForDocument" select="'urn:uuid:10cae35a-c7f9-4cf5-b61e-fc3278ffb578'"/>
   <xsl:variable name="xdsbQueryGetRelatedDocuments" select="'urn:uuid:d90e5407-b356-4d91-a89f-873917b4b0e6'"/>
   <xsl:variable name="xdsbQueryGetSubSetsAndContents" select="'urn:uuid:e8e3cb2c-e39c-46b9-99e4-c12f57260b83'"/>
   <xsl:variable name="xdsbQueryGetSubmissionSets" select="'urn:uuid:51224314-5390-4169-9b91-b1980040715a'"/>
   <xsl:variable name="xdsbQueryRequest" select="'XDSb_QueryRequest'"/>
   <xsl:variable name="xdsbQueryResponse" select="'XDSb_QueryResponse'"/>
   <xsl:variable name="xdsbQueryResponseAction" select="'urn:ihe:iti:2007:RegistryStoredQueryResponse'"/>
   
   <xsl:variable name="xdsbRegisterAction" select="'urn:ihe:iti:2007:RegisterDocumentSet-b'"/>
   <xsl:variable name="xdsbRegisterOnDemandAction" select="'urn:ihe:iti:2010:RegisterOnDemandDocumentEntry'"/>
   <xsl:variable name="xdsbRegisterOnDemandRequest" select="'XDSb_RegisterOnDemandRequest'"/>
   <xsl:variable name="xdsbRegisterOnDemandResponse" select="'XDSb_RegisterOnDemandResponse'"/>
   <xsl:variable name="xdsbRegisterOnDemandResponseAction" select="'urn:ihe:iti:2010:RegisterOnDemandDocumentResponse'"/>
   <xsl:variable name="xdsbRegisterRequest" select="'XDSb_RegisterRequest'"/>
   <xsl:variable name="xdsbRegisterResponse" select="'XDSb_RegisterResponse'"/>
   <xsl:variable name="xdsbRegisterResponseAction" select="'urn:ihe:iti:2007:RegisterDocumentSet-bResponse'"/>
   
   <xsl:variable name="xdsbRetrieveAction" select="'urn:ihe:iti:2007:RetrieveDocumentSet'"/>
   <xsl:variable name="xdsbRetrieveRequest" select="'XDSb_RetrieveRequest'"/>
   <xsl:variable name="xdsbRetrieveResponse" select="'XDSb_RetrieveResponse'"/>
   <xsl:variable name="xdsbRetrieveResponseAction" select="'urn:ihe:iti:2007:RetrieveDocumentSetResponse'"/>
   
   <!-- XDSb ExtrinsicObject types -->
   <xsl:variable name="xdsbOnDemandDocument" select="'urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248'"/>
   <xsl:variable name="xdsbStableDocument" select="'urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1'"/>
   
   <!-- Status/error codes -->
   <xsl:variable name="errorURN" select="'urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error'"/>
   <xsl:variable name="warningURN" select="'urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Warning'"/>
   <xsl:variable name="failureURN" select="'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure'"/>
   <xsl:variable name="partialURN" select="'urn:ihe:iti:2007:ResponseStatusType:PartialSuccess'"/>
   <xsl:variable name="successURN" select="'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success'"/>
   <xsl:variable name="approvedURN" select="'urn:oasis:names:tc:ebxml-regrep:StatusType:Approved'"/>
   <xsl:variable name="errorSevPrefix" select="'urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:'"/>
   <xsl:variable name="responseStatPrefix" select="'urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:'"/>
   <xsl:variable name="statusTypePrefix" select="'urn:oasis:names:tc:ebxml-regrep:StatusType:'"/>
   
   <!-- OnDemand messages -->
   <xsl:variable name="xdsbOnDemandDocumentList" select="'XDSb_OnDemandDocumentList'"/>
   <xsl:variable name="xdsbOnDemandPersistenceRequest" select="'XDSb_OnDemandPersistenceRequest'"/>
   <xsl:variable name="xdsbPushDeliveryRequest" select="'XDSb_PushDeliveryRequest'"/>
   
   <!-- Identification schemes sometimes used in isolation (most only need to be in UtilityMapURN.xsl) -->
   <xsl:variable name="DocumentUniqueIdURN" select="'urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab'"/>
   <xsl:variable name="SubmissionSetSourceIdURN" select="'urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832'"/>
   
   <!-- Selected classification schemes (most only need to be in UtilityMapURN.xsl) -->
   <xsl:variable name="documentAuthorScheme" select="'urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d'"/>
   <xsl:variable name="submissionAuthorScheme" select="'urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d'"/>
   <xsl:variable name="ContentTypeCodeScheme" select="'urn:uuid:aa543740-bdda-424e-8c96-df4873be8500'"/>
   <xsl:variable name="FormatCodeScheme" select="'urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d'"/>
   
   <!-- Selected classification nodes -->
   <xsl:variable name="submissionSetClass" select="'urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd'"/>
   <xsl:variable name="folderClass" select="'urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2'"/>
   
   <!-- Associations -->
   <xsl:variable name="appends" select="'urn:ihe:iti:2007:AssociationType:APND'"/>
   <xsl:variable name="hasMember" select="'urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember'"/>
   <xsl:variable name="isSnapshotOf" select="'urn:ihe:iti:2010:AssociationType:IsSnapshotOf'"/>
   <xsl:variable name="replaces" select="'urn:ihe:iti:2007:AssociationType:RPLC'"/>
   <xsl:variable name="signs" select="'urn:ihe:iti:2007:AssociationType:signs'"/>
   <xsl:variable name="transforms" select="'urn:ihe:iti:2007:AssociationType:XFRM'"/>
   <xsl:variable name="transformsAndReplaces" select="'urn:ihe:iti:2007:AssociationType:XFRM_RPLC'"/>
   <xsl:variable name="updateAvailability" select="'urn:ihe:iti:2010:AssociationType:UpdateAvailabilityStatus'"/>
   
   <!-- General utility variables -->
   <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
   <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
   
   <!-- Scenarios for xsl:include
      When you want to use utility routines, you will often need to include more than one module
      to obtain all the functionality. Nearly everything needs to do an xsl:include of Variables.xsl
      (this file). Inclusion of other modules is driven by which common routines you want to use,
      but all require that at least Variables also be included.
      The following sets of included files should work:
      Variables 
      UtilityRoutines, Variables
      UtilityMapURN
      UtilityMapURN, Variables
      UtilityMapURN, UtilityRoutines, Variables
      UtilityEmitIHE, UtilityMapURN, Variables
      UtilityEmitIHE, UtilityMapURN, UtilityRoutines, Variables
      UtilityImportIHE, UtilityMapURN, UtilityRoutines, Variables
      Your stylesheet may have 1-4 xsl:include statements using one of the above sets, and possibly
      other xsl:includes not involving the cross-IHE common routines.
      
      Expressed another way, here is the dependency graph:
      UtilityImportIHE             }
      |     |      UtilityEmitIHE  } These two are "opposites" and unlikely to both be needed
      |     |       |    |
      |     v       v    |
      |    UtilityMapURN |  (the above two require this, but this can also be used without either)
      v                  |
      UtilityRoutines    |  (ImportIHE requires this, but EmitIHE does not, yet)
                 |       |
                 v       v
                 Variables   (three of the above require this, but this can also be used without any others)
   -->
   
</xsl:stylesheet>