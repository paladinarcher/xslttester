<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
xmlns:rs="urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0" 
xmlns:ihe="urn:ihe:iti:xds-b:2007" 
xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"
xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
xmlns:a="http://www.w3.org/2005/08/addressing"
>
<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<!-- used by the notification broker to transform subscription requests -->
<xsl:template match="/">
<xsl:variable name="apos" select='"&apos;"' />
<Subscription>
<RecipientAddress><xsl:value-of select='/wsnt:Subscribe/wsnt:ConsumerReference/a:Address/text()'/></RecipientAddress>
<TerminationTime><xsl:value-of select='wsnt:Subscribe/wsnt:InitialTerminationTime/text()'/></TerminationTime>
<Topic><xsl:value-of select='/wsnt:Subscribe/wsnt:Filter/wsnt:TopicExpression/text()'/></Topic>
<PatientID><xsl:value-of select='substring-before(substring-after(/wsnt:Subscribe/wsnt:Filter/rim:AdhocQuery/rim:Slot[@name="$XDSDocumentEntryPatientId"]/rim:ValueList/rim:Value,$apos),$apos)'/></PatientID>
<Type><xsl:value-of select='/wsnt:Subscribe/wsnt:Filter/rim:AdhocQuery/@id'/></Type>
<xsl:for-each select='/wsnt:Subscribe/wsnt:Filter/rim:AdhocQuery/rim:Slot[@name!="$XDSDocumentEntryPatientId"]'>
<xsl:call-template name="Item">
<xsl:with-param name="Slot" select="."/>
</xsl:call-template>
</xsl:for-each>
</Subscription>
</xsl:template>

<xsl:template name="Item">
<FilterItems>
<Item><xsl:value-of select='@name'/></Item>
<Values>
<xsl:for-each select='rim:ValueList/rim:Value'>
<xsl:call-template name="ValueItems">
<xsl:with-param name="value" select="substring-before(substring-after(text(), '('),')')"/>
</xsl:call-template>
</xsl:for-each>
</Values>
</FilterItems>
</xsl:template>

<xsl:template name="ValueItems">
<xsl:param name="value"/>
<xsl:variable name="apos" select='"&apos;"' />
<xsl:variable name="thisValue" select="substring-before(substring-after(substring-before($value,','),$apos),$apos)"/>

<xsl:choose>
<xsl:when test="string-length($thisValue) =0">
<ValuesItem><xsl:value-of select="substring-before(substring-after($value,$apos),$apos)"/></ValuesItem>
</xsl:when>
<xsl:otherwise>
<ValuesItem><xsl:value-of select="$thisValue"/></ValuesItem>
<xsl:variable name="remainder" select="substring-after($value,',')"/>
<xsl:call-template name="ValueItems">
<xsl:with-param name="value" select="$remainder"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>