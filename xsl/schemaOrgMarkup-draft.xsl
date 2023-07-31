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
    xmlns:schema="http://schema.org/" xmlns:xhtml="http://www.w3.org/1999/xhtml" 
    xmlns:datacite="http://datacite.org/schema/kernel-4" version="3.0">
    <xsl:strip-space elements="*"/>
    
    <!-- may need this, may not -->
    <xsl:variable name="uwlIri">https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries</xsl:variable>
    
    <xsl:template name="jsonMarkup"> 
        <xsl:param name="metadata_file_name"/>
        <xsl:variable name="metadata_file" select="document($metadata_file_name)"/>
        {
        "@context" : "http://schema.org" ,
        "@type" : "Dataset" ,
        "@id" : "<xsl:value-of select="concat('https://doi.org/', $metadata_file/datacite:resource/datacite:identifier[@identifierType = 'DOI'])"/>" ,
        "name" : "<xsl:value-of select="normalize-space($metadata_file/datacite:resource/datacite:titles/datacite:title[1])"/>" ,
        "description" : "<xsl:value-of select="normalize-space($metadata_file/datacite:resource/datacite:descriptions/datacite:description[1])"/>" ,
        <!--
        "creator" : { 
            "@type" : "Organization" , 
            "@id" : "<xsl:value-of select="$uwlIri"/>" ,
            "name" : "<xsl:value-of select="$metadata_file/resource/creators/creator/creatorName[1]"/>" , 
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
        } , -->
        "creator" : { 
            "@type" : "Organization" ,
            "@id" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
            "name" : "University of Washington Libraries" , 
            "url" : "https://www.lib.washington.edu" , 
            "sameAs" : [ "http://viaf.org/viaf/139541794" , "http://www.wikidata.org/entity/Q7896575" ] 
        } , 
        "publisher" : { 
            "@type" : "Organization" ,
            "@id" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
            "name" : "University of Washington Libraries" , 
            "url" : "https://www.lib.washington.edu" , 
            "sameAs" : [ "http://viaf.org/viaf/139541794" , "http://www.wikidata.org/entity/Q7896575" ] 
        } , 
        "datePublished" : "<xsl:value-of select="$metadata_file/datacite:resource/datacite:dates/datacite:date[@dateType='Issued']"/>" , <!-- may need to change -->
        "inLanguage" : "<xsl:value-of select="$metadata_file/datacite:resource/datacite:language"/>" ,
        "encodingFormat" : "application/xhtml+xml" ,
        "license" : <xsl:value-of select="$metadata_file/datacite:resource/datacite:rightsList/datacite:rights/@rightsURI"/>
        }
    </xsl:template>
</xsl:stylesheet>
