<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:uml="http://schema.omg.org/spec/UML/2.2" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1">

	<xsl:output indent="yes" method="xml"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xmi:Extension extender="Enterprise Architect" extenderID="6.5">
			<elements>
				<xsl:apply-templates/>
			</elements>
		</xmi:Extension>
	</xsl:template>
	
	<!-- Copy owmedComment to Notes of packagedElements -->
	<xsl:template match="//packagedElement/ownedComment" >
		<xsl:element name="element">
			<xsl:attribute name="xmi:idref"><xsl:value-of select="../@xmi:id"/></xsl:attribute>
			<xsl:attribute name="xmi:type"><xsl:value-of select="../@xmi:type"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="../@name"/></xsl:attribute>
			<xsl:attribute name="scope">public</xsl:attribute>
			<xsl:element name="properties">
				<xsl:attribute name="sType"><xsl:value-of select="substring(../@xmi:type,5)"/></xsl:attribute>
 				<!-- <xsl:attribute name="isSpecification">false</xsl:attribute>
				<xsl:attribute name="nType">0</xsl:attribute>
				<xsl:attribute name="scope">public</xsl:attribute>
				<xsl:attribute name="isRoot">false</xsl:attribute>
				<xsl:attribute name="isLeaf">false</xsl:attribute>
				<xsl:attribute name="isActive">false</xsl:attribute> -->
				<xsl:attribute name="isAbstract"><xsl:value-of select="../@isAbstract"/></xsl:attribute>
				<xsl:attribute name="documentation"><xsl:value-of select="@body"/></xsl:attribute>

				<!--
				 Copy owmedComment to Notes of packagedElements/ownedAttributes
				 Doesnot work?
				 -->
<!-- 				<xsl:for-each select="../ownedAttribute/ownedComment">
					<xsl:element name="attribute">
						<xsl:attribute name="xmi:idref"><xsl:value-of select="../@xmi:id"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="../@name"/></xsl:attribute>
						<xsl:attribute name="scope">Public</xsl:attribute>
						<xsl:element name="documentation">
							<xsl:attribute name="value"><xsl:value-of select="@body"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:for-each> -->
			</xsl:element>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>