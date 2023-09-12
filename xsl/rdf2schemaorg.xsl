<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    xmlns:schema="https://schema.org/"
    version="3.0">
    <xsl:strip-space elements="*"/>
    
    <!-- match creators and publishers xsl -->
    <xsl:include href="creators.xsl"/>
    
    <!-- template for producing the json schema.org markup based on DataCite metadata -->
    <!-- NOTE: indentation is weird within this template and hierarchy of elements is not always clear -->
    <!-- this is to produce proper indentation within the output file -->
    <xsl:template name="schemaorgMarkup"> 
        <xsl:param name="file_name"/>
        <xsl:param name="doi"/> 
        
        <xsl:variable name="locale" select="document($file_name)/rdf:RDF/rdf:Description[@about = $doi]"/>
        {
        "@context" : "http://schema.org" ,
        "@type" : "Dataset" , <!-- will type always be dataset? -->
        "@id" : <xsl:value-of select="$doi"/>
        "name" : "<xsl:choose>
            <xsl:when test="$locale/dct:title">
                <xsl:value-of select="$locale/dct:title"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>" ,
        "description" : "<xsl:choose>
            <xsl:when test="$locale/dct:description">
                <xsl:value-of select="$locale/dct:description"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>" ,
        <xsl:choose>
            <xsl:when test="count($locale/dct:creator) gt 1">"creator" : [
                <xsl:apply-templates select="$locale/dct:creator"/> <!-- NEED TO GET NAME NOT URI -->
                ],</xsl:when>
            <xsl:otherwise>"creator" : <xsl:apply-templates select="$locale/dct:creator"/></xsl:otherwise>
        </xsl:choose>
        "publisher" : <xsl:apply-templates select="$locale/datacite:resource/datacite:publisher"/>
        "datePublished" : "<xsl:choose>
            <xsl:when test="$locale/dct:issued">
                <xsl:value-of select="$locale/dct:issued"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>",
        "inLanguage" : "<xsl:choose>
            <xsl:when test="$locale/dct:language">
                <xsl:value-of select="$locale/dct:language"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>",
        "encodingFormat" : "text/html" , <!-- i think this is what it should be - needs review -->
        "license" : "<xsl:choose>
            <xsl:when test="$locale/dct:license">
                <xsl:value-of select="$locale/dct:license"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>",
        "version" : "<xsl:choose>
            <xsl:when test="$locale/schema:version">
                <xsl:value-of select="$locale/schema:version"/>
            </xsl:when>
            <xsl:otherwise>VALUE NOT FOUND</xsl:otherwise>
        </xsl:choose>"
        }
    </xsl:template>
</xsl:stylesheet>
