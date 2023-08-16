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
        <!-- group by rdf:about and then iterate through each grouping -->
        <xsl:for-each select="rdf:Description[@rdf:about]">
            <!-- currently sorting alphabetically by doi as well - CHECK ON THIS -->
            <xsl:sort select="substring-after(@rdf:about, '#')"/>
            
            <!-- save rdf:about (doi) as variable -->
            <xsl:variable name="doi" select="@rdf:about"/>
            
            <!-- iterate through all children -->
            <xsl:for-each select="./*">
                <!-- sort by name -->
                <xsl:sort select="name(.)"/>
                <tr>
                    <!-- <tr about=> -->
                    <xsl:attribute name="about">
                        <xsl:value-of select="$doi"/>
                    </xsl:attribute>
                    
                    <!-- subject is doi (@rdf:about) -->
                    <xsl:choose>
                        <!-- sets id if first child -->
                        <xsl:when test="position() = 1 and substring-after($doi, '#')">
                            <td id="{substring-after($doi,'#')}">
                                <a href="{$doi}">
                                    <xsl:value-of select="$doi"/>
                                </a>
                            </td>
                        </xsl:when>
                        <!-- otherwise no id attrib -->
                        <xsl:when test="position() > 1 or not(substring-after($doi,'#'))">
                            <td>
                                <a href="{$doi}">
                                    <xsl:value-of select="$doi"/>
                                </a>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>POSITION FUNCTION FOR @id NOT WORKING.</td>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- predicate is element name -->
                    <td>
                        <a href="{concat(namespace-uri(.),local-name(*))}">
                            <xsl:value-of select="name(.)"/>
                        </a>
                    </td>
                    <!-- object -->
                    <!-- property is also element name -->
                    <td property="{name(.)}">
                        <!-- check for attributes -->
                        <xsl:if test="./@rdf:datatype">
                            <xsl:attribute name="datatype">
                                <xsl:value-of select="./@rdf:datatype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="./@xml:lang">
                            <xsl:attribute name="lang"
                                namespace="http://www.w3.org/XML/1998/namespace">
                                <xsl:value-of select="./@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <!-- if object is rdf:resource, this becomes attrib AND value -->
                            <xsl:when test="./@rdf:resource">
                                <xsl:attribute name="resource">
                                    <xsl:value-of select="./@rdf:resource"/>
                                </xsl:attribute>
                                <a href="{*/@rdf:resource}">
                                    <xsl:value-of select="./@rdf:resource"/>
                                </a>
                            </xsl:when>
                            <!-- if it's a literal - no attrib -->
                            <xsl:when test="./text()">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <!-- if it's a nodeID -->
                            <xsl:when test="./@rdf:nodeID">
                                <xsl:attribute name="resource">
                                    <xsl:text>[_:</xsl:text>
                                    <xsl:value-of select="./@rdf:nodeID"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:attribute>
                                <xsl:text>_:</xsl:text>
                                <xsl:value-of select="./@rdf:nodeID"/>
                            </xsl:when>
                            <xsl:otherwise>****WONKY OBJECT****</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!-- for blank node? -->
    <xsl:template match="rdf:Description[@rdf:nodeID]" mode="bnode">
        <!-- select rdf:Description with @rdf:nodeID attrib -->
        <xsl:variable name="nodeID" select="@rdf:nodeID"/>
        <xsl:for-each select="./*">
            <tr>
                <xsl:attribute name="about">
                    <xsl:text>[_:</xsl:text>
                    <xsl:value-of select="$nodeID"/>
                    <xsl:text>]</xsl:text>
                </xsl:attribute>
                <td>
                    <xsl:text>_:</xsl:text>
                    <xsl:value-of select="$nodeID"/>
                </td>
                <td>
                    <a href="{concat(namespace-uri(.),local-name(.))}">
                        <xsl:value-of select="name(.)"/>
                    </a>
                </td>
                <td property="{name(.)}">
                    <xsl:if test="./@rdf:datatype">
                        <xsl:attribute name="datatype">
                            <xsl:value-of select="./@rdf:datatype"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./@xml:lang">
                        <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace">
                            <xsl:value-of select="./@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="./@rdf:resource">
                            <xsl:attribute name="resource">
                                <xsl:value-of select="./@rdf:resource"/>
                            </xsl:attribute>
                            <a href="{./@rdf:resource}">
                                <xsl:value-of select="./@rdf:resource"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="./text()">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:when test="./@rdf:nodeID">
                            <xsl:attribute name="resource">
                                <xsl:text>[_:</xsl:text>
                                <xsl:value-of select="./@rdf:nodeID"/>
                                <xsl:text>]</xsl:text>
                            </xsl:attribute>
                            <xsl:text>_:</xsl:text>
                            <xsl:value-of select="./@rdf:nodeID"/>
                        </xsl:when>
                        <xsl:otherwise>****weird object to bnode subject***</xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>




