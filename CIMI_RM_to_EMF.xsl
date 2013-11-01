<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet converts Enterprise Architect 2.2 XMI output into (more or less) standard UML compliant XMI.  It also includes
     a couple of transformations that are specific to the Eclipse EMF framework.  It has been tested with EA 10.0.1007 and was
     designed specifically for use with the CIMI Reference Model
     
     Usage:
     1) Select the EA Resources window, select Stylesheets and import this stylesheet.
     2) Right click on the CIMI Reference Model node in the project browser
     3) Select import/export Export Package to XMI
     4) Click the "Publish" button
     5) Select the output file name
     6) Select UML 2.2(XMI 2.1)
     7) Select the Format XML Output and Exclude EA Extensions options.  Deselect all others
     8) Hit Export
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:uml="http://schema.omg.org/spec/UML/2.2" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"  
    xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0" xmlns:EAUML="http://www.sparxsystems.com/profiles/EAUML/1.0"
    xmlns:DFD="http://www.sparxsystems.com/profiles/DFD/1.1" exclude-result-prefixes="xs thecustomprofile EAUML DFD" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- All attributes are copied verbatim  - note that changes are covered in the node match below -->
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:choose>
            <!-- Remove everything in the sparxsystems namespaces -->
            <xsl:when test="namespace-uri() = 'http://www.sparxsystems.com/profiles/DFD/1.1'"/>
            <xsl:when test="namespace-uri() = 'http://www.sparxsystems.com/profiles/thecustomprofile/1.0'"/>
            <xsl:when test="namespace-uri() = 'http://www.sparxsystems.com/profiles/EAUML/1.0'"/>

            <!-- Remove Extensions, Profiles and ownedComments (they are an artifact of a non-EA tool and
                do not actually appear within the EA rendering itself) -->
            <xsl:when test="name()='xmi:Extension'"/>
            <xsl:when test="name()='profileApplication'"/>
            <xsl:when test="name()='ownedComment'"/>
            
            <!-- unnamed classes are diagram elements or other unninteresting things -->
            <xsl:when test="name()='packagedElement' and not(@name) and @xmi:type='uml:Class'"/>
            
            <!-- This is an issue with EMF, not the output XMI -->
            <xsl:when test="name()='xmi:Documentation'"/>

            <!-- Diagrams are various boxes etc -->
            <xsl:when test="starts-with(@name,'$diagram://')"/>

            <!-- All blank text gets stripeed -->
            <xsl:when test="self::text()">
                <xsl:if test="normalize-space() != ''">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:when>

            <!-- EAJava types are specific to EA.  All references should be to the internal primitive types class -->
            <xsl:when test="name()='type' and starts-with(@xmi:idref,'EAJava_')">
                <xsl:message select="concat('Wrong String type for', ../name())"/>
            </xsl:when>

            <!-- EMF treates TemplateSignature as abstract.  This may be an error on the EMF side but... -->
            <xsl:when test="name()='ownedTemplateSignature' and @xmi:type='uml:TemplateSignature'">
                <xsl:copy>
                    <xsl:attribute name="xmi:type">uml:RedefinableTemplateSignature</xsl:attribute>
                    <xsl:apply-templates select="@*[name()!='xmi:type']"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>

                    <!-- Add in the local RM primitive types -->
                    <!--<xsl:if test="name()='uml:Model'">

                        <packagedElement xmi:type="uml:Package" xmi:id="RMPrimitiveTypesPackage" name="RM_PrimitiveTypes_Package">
                            <packagedElement xmi:type="uml:Package" xmi:id="RMTypesPackage" name="RM_Types_Package">
                                <packagedElement xmi:type="uml:PrimitiveType" xmi:id="RM_Byte" name="Byte"/>
                                <packagedElement xmi:type="uml:PrimitiveType" xmi:id="RM_Character" name="Character"/>
                            </packagedElement>
                        </packagedElement>

                    </xsl:if>-->

                    <!-- Map proprietary EA documentation into ownedComments -->
                    <xsl:if test="@xmi:id">
                        <xsl:if test="//element[@xmi:idref=current()/@xmi:id]/properties[@documentation]">
                            <ownedComment xmi:id="{@xmi:id}_0" xmi:type="uml:Comment">
                                <body>
                                    <xsl:value-of select="//element[@xmi:idref=current()/@xmi:id]/properties/@documentation"/>
                                </body>
                                <annotatedElement xmi:idref="{current()/@xmi:id}"/>
                            </ownedComment>
                        </xsl:if>
                        <xsl:if test="//attribute[@xmi:idref=current()/@xmi:id]/documentation/@value">
                            <ownedComment xmi:id="{@xmi:id}_0" xmi:type="uml:Comment">
                                <body>
                                    <xsl:value-of select="//attribute[@xmi:idref=current()/@xmi:id]/documentation/@value"/>
                                </body>
                                <annotatedElement xmi:idref="{current()/@xmi:id}"/>
                            </ownedComment>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
