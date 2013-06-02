<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:uml="http://schema.omg.org/spec/UML/2.2" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1">

	<xsl:output indent="yes" method="xml"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/xmi:XMI">
		<xmi:XMI xmi:version="2.1">
		<xsl:apply-templates mode="cleanup"/>
		
		<xmi:Extension extender="Enterprise Architect" extenderID="6.5">
			<elements>
				<xsl:apply-templates mode="documentation"/>
			</elements>
		</xmi:Extension>
		</xmi:XMI>
	</xsl:template>
	
	<!-- TODO: copy everything but the <artifact>'s & operations -->
    <xsl:template match="@* | node()" mode="cleanup">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="cleanup"/>
        </xsl:copy>
    </xsl:template>	

	<xsl:template match="packagedElement[@xmi:type='uml:Artifact']" mode="cleanup">
	</xsl:template>
	
	<xsl:template match="ownedOperation" mode="cleanup">
	</xsl:template>
	
	<!-- Copy owmedComment to Notes of packagedElements -->
	<xsl:template match="//packagedElement/ownedComment" mode="documentation">
		<xsl:element name="element">
			<xsl:attribute name="xmi:idref"><xsl:value-of select="../@xmi:id"/></xsl:attribute>
			<xsl:attribute name="xmi:type"><xsl:value-of select="../@xmi:type"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="../@name"/></xsl:attribute>
			<xsl:attribute name="scope">public</xsl:attribute>
			<xsl:element name="properties">
				<xsl:attribute name="sType"><xsl:value-of select="substring(../@xmi:type,5)"/></xsl:attribute>
				<xsl:attribute name="isAbstract"><xsl:value-of select="../@isAbstract"/></xsl:attribute>
				<xsl:attribute name="documentation"><xsl:value-of select="@body"/></xsl:attribute>
			</xsl:element>
			<!--
			 Copy ownedComment to Notes of packagedElements/ownedAttributes
			 -->
			<attributes>
 				<xsl:for-each select="../ownedAttribute/ownedComment">
					<xsl:element name="attribute">
						<xsl:attribute name="xmi:idref"><xsl:value-of select="../@xmi:id"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="../@name"/></xsl:attribute>
						<xsl:attribute name="scope">Public</xsl:attribute>
						<xsl:element name="documentation">
							<xsl:attribute name="value"><xsl:value-of select="@body"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</attributes>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>