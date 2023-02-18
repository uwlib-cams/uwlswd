<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:hclsr="https://doi.org/10.70027/uwlib.55.A.2.1#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:dpla="http://dp.la/about/map/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:void="http://rdfs.org/ns/void#" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:schema="http://schema.org/" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="2.0">
    <xsl:strip-space elements="*"/>

    <!-- Variables -->
    <!-- Tried to leave below var. only in calling template but could not transform -->
    <xsl:variable name="uwlswdBaseIri" select="document('https://doi.org/10.6069/uwlib.55.a')"/>
    <xsl:variable name="uwlIri"
        >https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries</xsl:variable>
    <!-- VARIABLE BELOW PULLS DATA FROM FILES IN LOCAL WORKSPACE / CONFIRM PRIOR TO TRANSFORMATION -->
    <xsl:variable name="agentRdfXml" select="document('../../contentdmToRdfXml/uwlswdWorkspace/agent-1-0-2.rdf')"/>

    <xsl:template name="jsonMarkup1"> 
        { 
        "@context" : "http://schema.org" , 
        "@type" : "Dataset" , 
    </xsl:template>
    <!-- SOME KEY/VALUE PAIRS STILL IN PARTITION TRANSFORMS -->
    <xsl:template name="jsonMarkup2"> 
        "creator" : { 
            "@type" : "Organization" ,
            "@id" : "<xsl:value-of select="$uwlIri"/>" ,
            "name" : "<xsl:value-of select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/dpla:providedLabel"/>" , 
            "url" : "<xsl:value-of select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/schema:url/@rdf:resource"/>" , 
            "sameAs" : [ <xsl:for-each select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/owl:sameAs">
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>"</xsl:text><xsl:value-of select="@rdf:resource"/><xsl:text>" , </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>"</xsl:text><xsl:value-of select="@rdf:resource"/><xsl:text>"</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each> ] 
            } , 
        "publisher" : { 
            "@type" : "Organization" ,
            "@id" : "<xsl:value-of select="$uwlIri"/>" ,
            "name" : "<xsl:value-of select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/dpla:providedLabel"/>" , 
            "url" : "<xsl:value-of select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/schema:url/@rdf:resource"/>" , 
            "sameAs" : [ <xsl:for-each select="$agentRdfXml/rdf:RDF/rdf:Description[@rdf:about = $uwlIri]/owl:sameAs">
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>"</xsl:text><xsl:value-of select="@rdf:resource"/><xsl:text>" , </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>"</xsl:text><xsl:value-of select="@rdf:resource"/><xsl:text>"</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each> ] 
                } , 
        "inLanguage" : "<xsl:value-of select="substring-after($uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = 'https://doi.org/10.6069/uwlib.55.a']/xhtml:td[@property = 'dct:language'], 'languages/')"/>" , 
        "encodingFormat" : "application/xhtml+xml" , 
        "license" : "http://creativecommons.org/publicdomain/zero/1.0/" 
        } 
    </xsl:template>
</xsl:stylesheet>
