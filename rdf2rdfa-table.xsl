<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:dpla="http://dp.la/about/map/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="2.0">
 
 <!-- this is the core RDF-2-RDFa transform to be included in a dataset-specific custom xslt file;
      it produces the html table with embedded rdfa-->
 
    <xsl:template match="rdf:RDF" mode="resource">
        <xsl:for-each-group select="rdf:Description" group-by="@rdf:about">
            <xsl:for-each select="current-group()">
                <tr>
                    <xsl:attribute name="about">
                        <xsl:value-of select="@rdf:about"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="position() = 1 and substring-after(current-grouping-key(),'#')">
                            <td id="{substring-after(current-grouping-key(),'#')}">
                                <a href="{current-grouping-key()}">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </a>
                            </td>
                        </xsl:when>
                        <xsl:when test="position() > 1 or not(substring-after(current-grouping-key(),'#'))">
                            <td>
                                <a href="{current-grouping-key()}">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </a>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>POSITION FUNCTION FOR @id NOT WORKING.</td>
                        </xsl:otherwise>
                    </xsl:choose>

                    <td>
                        <a href="{concat(namespace-uri(*),local-name(*))}">
                            <xsl:value-of select="name(*)"/>
                        </a>
                    </td>

                    <td property="{name(*)}">
                        <xsl:if test="*/@rdf:datatype">
                            <xsl:attribute name="datatype">
                                <xsl:value-of select="*/@rdf:datatype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="*/@xml:lang">
                            <xsl:attribute name="lang"
                                namespace="http://www.w3.org/XML/1998/namespace">
                                <xsl:value-of select="*/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="*/@rdf:resource">
                                <xsl:attribute name="resource">
                                    <xsl:value-of select="*/@rdf:resource"/>
                                </xsl:attribute>
                                <a href="{*/@rdf:resource}">
                                    <xsl:value-of select="*/@rdf:resource"/>
                                </a>
                            </xsl:when>
                            <xsl:when test="*/text()">
                                <xsl:value-of select="*"/>
                            </xsl:when>
                            <xsl:when test="*/@rdf:nodeID">
                                <xsl:attribute name="resource">
                                    <xsl:text>[_:</xsl:text>
                                    <xsl:value-of select="*/@rdf:nodeID"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:attribute>
                                <xsl:text>_:</xsl:text>
                                <xsl:value-of select="*/@rdf:nodeID"/>
                            </xsl:when>
                            <xsl:otherwise>****WONKY OBJECT****</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="rdf:Description" mode="bnode">
        <xsl:for-each select=".[@rdf:nodeID]">
            <tr>
                <xsl:attribute name="about">
                    <xsl:text>[_:</xsl:text>
                    <xsl:value-of select="@rdf:nodeID"/>
                    <xsl:text>]</xsl:text>
                </xsl:attribute>
                <td>
                    <xsl:text>_:</xsl:text>
                    <xsl:value-of select="@rdf:nodeID"/>
                </td>
                <td>
                    <a href="{concat(namespace-uri(*),local-name(*))}">
                        <xsl:value-of select="name(*)"/>
                    </a>
                </td>
                <td property="{name(*)}">
                    <xsl:if test="*/@rdf:datatype">
                        <xsl:attribute name="datatype">
                            <xsl:value-of select="*/@rdf:datatype"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="*/@xml:lang">
                        <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace">
                            <xsl:value-of select="*/@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="*/@rdf:resource">
                            <!-- editing this condition-->
                            
                            <xsl:attribute name="resource">
                                <xsl:value-of select="*/@rdf:resource"/>
                            </xsl:attribute>
                            <a href="{*/@rdf:resource}">
                                <xsl:value-of select="*/@rdf:resource"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="*/text()">
                            <xsl:value-of select="*"/>
                        </xsl:when>
                        <xsl:when test="*/@rdf:nodeID">
                            <xsl:attribute name="resource">
                                <xsl:text>[_:</xsl:text>
                                <xsl:value-of select="*/@rdf:nodeID"/>
                                <xsl:text>]</xsl:text>
                            </xsl:attribute>
                            <xsl:text>_:</xsl:text>
                            <xsl:value-of select="*/@rdf:nodeID"/>
                        </xsl:when>
                        <xsl:otherwise>****weird object to bnode subject***</xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
