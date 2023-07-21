<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:hclsr="https://doi.org/10.70027/uwlib.55.A.2.1#" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:dpla="http://dp.la/about/map/" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:ore="http://www.openarchives.org/ore/terms/" 
    xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xml="http://www.w3.org/XML/1998/namespace" 
    xmlns:ldproc="https://doi.org/10.6069/uwlib.55.b.2#"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    version="3.0">
    
    <xsl:strip-space elements="*"/>
        
        <xsl:variable name="file_path" select="base-uri()"/>
        
        <!-- get from metadata file -->
        <!-- metadata thought - one big file or minis? -->
        <xsl:variable name="metadata_file">
            <xsl:variable name="metadata_file_path" select="replace($file_path, '\.rdf', '_metadata.xml')"/>
            <xsl:copy-of select="j:json-to-xml(document($metadata_file_path)/data)"/>
        </xsl:variable>
        
        <xsl:variable name="datasetName" select="$metadata_file/j:array/j:map/j:string[@key='datasetName']"/>       
        <xsl:variable name="description" select="$metadata_file/j:array/j:map/j:string[@key = 'description']"/>
        <!-- Filepath for generating links to serializations (path *up to filename*) -->
        <xsl:variable name="path" select="$metadata_file/j:array/j:map/j:string[@key = 'path']"/>
        <xsl:variable name="fileName" select="$metadata_file/j:array/j:map/j:string[@key = 'fileName']"/>
        <xsl:variable name="doi" select="$metadata_file/j:array/j:map/j:string[@key = 'doi']"/>
        
        <xsl:template match="/">
            <!-- HTML declaration -->
            <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
                lang="en" xml:lang="en">
                <head>
                    <title>
                        <xsl:value-of select="$datasetName"/>
                    </title>
                    <script type="application/ld+json">
                        {
                        "@context" : "http://schema.org" ,
                        "@type" : "Dataset" ,
                        "@id" : <xsl:value-of select="$doi"/> ,
                        "creator" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                        "name" : <xsl:value-of select="$datasetName"/>,
                        "description" : <xsl:value-of select="$description"/>,
                        "publisher" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                        "datePublished" : "2018" ,
                        "inLanguage" : "English" ,
                        "encodingFormat" : "application/xhtml+xml" ,
                        "version" : "1-0-0" ,
                        "license" : "http://creativecommons.org/publicdomain/zero/1.0/"
                        }
                    </script>
                    <link rel="alternate" type="application/n-triples"
                        href="{concat($path,$fileName,'.nt')}"/>
                    <link rel="alternate" type="application/rdf+xml"
                        href="{concat($path,$fileName,'.rdf')}"/>
                    <link rel="alternate" type="application/turtle"
                        href="{concat($path,$fileName,'.ttl')}"/>
                    <link rel="{concat($path,$fileName,'.jsonld')}"/>
                </head>
            </html>
        </xsl:template>
</xsl:stylesheet>