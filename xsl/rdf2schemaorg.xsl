<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:datacite="http://datacite.org/schema/kernel-4" xmlns:schema="https://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    <xsl:strip-space elements="*"/>

    <!-- template for producing the json schema.org markup based on rdf/xml -->
    <!-- NOTE: indentation is weird within this template and hierarchy of elements is not always clear -->
    <!-- this is to produce proper indentation within the output file -->
    <xsl:template name="rdf2schemaorg">
        <xsl:variable name="description"
            select="./rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]"/> 
        { 
        "@context" : "http://schema.org" , 
        "@type" : "Dataset" , 
        "@id" : "<xsl:value-of
            select="$description/@rdf:about"/>", 
        "name" : "<xsl:choose>
            <xsl:when test="$description/dct:title">
                <xsl:value-of select="$description/dct:title"/>
            </xsl:when>
            <xsl:otherwise>VALUE MISSING</xsl:otherwise>
        </xsl:choose>" , 
        <xsl:if test="count($description/dct:alternative) = 1">
        "alternateName" : "<xsl:value-of select="$description/dct:alternative"/>" , 
        </xsl:if><xsl:if test="count($description/dct:alternative) gt 1">
        "alternateName" : [ 
            <xsl:for-each select="$description/dct:alternative">"<xsl:value-of select="."/>" , 
            </xsl:for-each>] , </xsl:if>
        "description" : <xsl:choose><xsl:when
                test="(count($description/dct:description) gt 1) or ($description/dct:description and $description/skos:scopeNote)"
                >[ 
            <xsl:for-each 
                    select="$description/dct:description">"<xsl:value-of select="."/>" , 
            </xsl:for-each><xsl:for-each select="$description/skos:scopeNote"
                        >"<xsl:value-of select="."/>" , </xsl:for-each>] , </xsl:when>
            <xsl:when
                test="(count($description/dct:description) = 1) and (count($description/skos:scopeNote) = 0)"
                > "<xsl:value-of select="$description/dct:description"/>" , </xsl:when>
            <xsl:otherwise>"VALUE MISSING" , </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="count($description/dct:source) = 1">
        "isBasedOn" : "<xsl:value-of select="$description/dct:source/@rdf:resource"/>" ,
        </xsl:if><xsl:if test="count($description/dct:source) gt 1">
        "isBasedOn" : [ 
                <xsl:for-each select="$description/dct:source">"<xsl:value-of select="./@rdf:resource"/>" , 
                </xsl:for-each>] , </xsl:if>
        <xsl:choose>
            <xsl:when test="$description/dct:creator"><xsl:for-each select="$description/dct:creator">
        "creator" : { 
            "@id" : "<xsl:value-of select="./@rdf:resource"/>" 
             } , </xsl:for-each>
            </xsl:when>
            <xsl:when test="$description/dc:creator and not($description/dct:creator)"><xsl:for-each select="$description/dc:creator">
        "creator" : { 
            "name" : "<xsl:value-of select="."/>" 
             } , </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> 
        "creator" : { 
            "name" : "VALUE MISSING",
            "@id" : "VALUE MISSING"
            } , </xsl:otherwise>
        </xsl:choose> 
        "publisher" : { <xsl:choose><xsl:when test="$description/dct:publisher">
            "@id" : "<xsl:value-of select="$description/dct:publisher/@rdf:resource"/>" 
            } , </xsl:when>
            <xsl:when test="$description/dc:publisher and not($description/dct:publisher)"> 
            "name" : "<xsl:value-of select="$description/dc:publisher"/>" 
            } , </xsl:when>
            <xsl:otherwise> 
            "name" : "VALUE MISSING"
            "@id" : "VALUE MISSING"
            } , </xsl:otherwise>
        </xsl:choose><xsl:if test="$description/dct:contributor or $description/dc:contributor">
        "contributor" : { <xsl:choose><xsl:when test="$description/dct:contributor">
            "@id" : <xsl:value-of select="$description/dct:contributor/@rdf:resource"/>
            } , </xsl:when>
            <xsl:when test="$description/dc:contributor and not($description/dct:contributor)">
            "name" : <xsl:value-of select="$description/dc:contributor"/>
            } , </xsl:when>
         </xsl:choose>
         </xsl:if>
        "datePublished" : "<xsl:choose>
            <xsl:when test="$description/dct:issued">
                <xsl:value-of select="$description/dct:issued"/>
            </xsl:when>
            <xsl:otherwise>VALUE MISSING</xsl:otherwise>
        </xsl:choose>", 
        "inLanguage" : "<xsl:choose>
            <xsl:when test="$description/dc:language">
                <xsl:value-of select="$description/dc:language"/>
            </xsl:when>
            <xsl:otherwise>VALUE MISSING</xsl:otherwise>
        </xsl:choose>", 
        "encodingFormat" : "text/html" , <!-- i think this is what it should be - needs review --> 
        "license" : "<xsl:choose> 
            <xsl:when test="$description/dct:license">
                <xsl:value-of select="$description/dct:license/@rdf:resource"/>
            </xsl:when>
            <xsl:otherwise>VALUE MISSING</xsl:otherwise>
        </xsl:choose>", 
        "version" : "<xsl:choose>
            <xsl:when test="$description/schema:version">
                <xsl:value-of select="$description/schema:version"/>
            </xsl:when>
            <xsl:otherwise>VALUE MISSING</xsl:otherwise>
        </xsl:choose>" 
        } 
    </xsl:template>
</xsl:stylesheet>
