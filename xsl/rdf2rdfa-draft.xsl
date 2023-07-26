<?xml version="1.0" encoding="UTF-8"?>
<!-- determine which namespaces we need -->
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
    
    <!-- rdfa xsl -->
    <xsl:include href="rdf2rdfa-table.xsl"/>

    
    <!-- get from metadata file -->   
    <xsl:variable name="file_path" select="base-uri()"/>
    
    <!-- parse metadata file -->
    <xsl:variable name="metadata_file">
        <xsl:variable name="metadata_file_path" select="replace($file_path, '\.rdf', '_metadata.xml')"/>
        <xsl:copy-of select="j:json-to-xml(document($metadata_file_path)/data)"/>
    </xsl:variable>
    
    <!-- name of dataset in plain text -->
    <xsl:variable name="datasetName" select="$metadata_file/j:map/j:string[@key='datasetName']"/>  
    
    <!-- description for html -->    
    <xsl:variable name="description" select="$metadata_file/j:map/j:string[@key = 'description']"/>
    
    <!-- Filepath for generating links to serializations -->
    <xsl:variable name="path" select="$metadata_file/j:map/j:string[@key = 'path']"/>
    
    <!-- file name for generating links to serializations -->
    <xsl:variable name="fileName" select="$metadata_file/j:map/j:string[@key = 'fileName']"/>

    <xsl:variable name="doi" select="$metadata_file/j:map/j:string[@key = 'doi']"/>
    
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
                <!-- schema.org content -->
                <!-- find out what variables are fixed vs unique -->
                <script type="application/ld+json">
                    {
                    "@context" : "http://schema.org" ,
                    "@type" : "Dataset" ,
                    "@id" : "<xsl:value-of select="$doi"/>" ,
                    "creator" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "name" : "<xsl:value-of select="$datasetName"/>" ,
                    "description" : "<xsl:value-of select="$description"/>" ,
                    "publisher" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "datePublished" : "2018" ,
                    "inLanguage" : "English" ,
                    "encodingFormat" : "application/xhtml+xml" ,
                    "version" : "1-0-0" ,
                    "license" : "http://creativecommons.org/publicdomain/zero/1.0/"
                        }
                </script>
                <link rel="alternate" type="application/n-triples"
                    href="{concat($path, $fileName,'.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($path, $fileName,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($path, $fileName,'.ttl')}"/>
                <link rel="alternate" type="application/ld+json"
                    href="{concat($path, $fileName,'.jsonld')}"/>
            </head>
            <body about="{$doi}">
                <!-- Title of dataset -->
                <h1>
                    <xsl:value-of select="$datasetName"/>
                </h1>
                <p>
                    <xsl:value-of select="$description"/>
                </p>
                <!-- Links to alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of select="$datasetName"/></h2>
                    <ul>
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat($path, $fileName,'.nt')"/>
                                </xsl:attribute>N-Triples
                            </a>
                        </li>
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat($path, $fileName,'.ttl')"/>
                                </xsl:attribute>Turtle
                            </a>
                        </li>
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat($path, $fileName,'.jsonld')"/>
                                </xsl:attribute>JSON-LD
                            </a>
                        </li>                        
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat($path, $fileName,'.rdf')"/>
                                </xsl:attribute>RDF/XML
                            </a>
                        </li>
                    </ul>
                    <!-- Table headline -->
                    <h2>RDF Triples for <xsl:value-of select="$datasetName"/></h2>
                    <!-- Table setup below always stays the same -->
                    <table border="1" cellpadding="6">
                        <tr>
                            <th>Subject</th>
                            <th>Predicate</th>
                            <th>Object</th>
                        </tr>
                        <!-- add missing dct:hasFormat before passing to templates -->
                        <xsl:variable name="file_plus">
                            <xsl:copy select=".">
                                <xsl:copy select="rdf:RDF">
                                    <xsl:copy-of select="rdf:Description"/>
                                    <xsl:element name="rdf:Description">
                                        <xsl:attribute name="rdf:about">
                                            <xsl:value-of select="$doi"/>
                                        </xsl:attribute>
                                        <xsl:element name="dct:hasFormat">
                                            <xsl:attribute name="rdf:resource">
                                                <xsl:value-of select="concat($path, $fileName,'.rdf')"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:copy>
                            </xsl:copy>
                        </xsl:variable>
                        <xsl:apply-templates select="$file_plus/rdf:RDF" mode="resource"/>
                        <xsl:apply-templates select="$file_plus/rdf:RDF" mode="bnode"/>
                    </table>
                    <hr/>
                    <hr/>
                    <!-- Contact information -->
                    <h3>Contact:</h3>
                    <p>
                        <a href="https://www.lib.washington.edu/msd">University of Washington Libraries,
                            Cataloging and Metadata Services</a><br/> Box 352900, Seattle, WA
                        98195-2900<br/> Telephone: 206-543-1919<br/>
                        <a href="mailto:tgis@uw.edu">tgis@uw.edu</a></p>
                    <hr/>
                    <hr/>
                    <!-- CC0 image/link, rights statement -->
                    <p>
                        <a href="http://creativecommons.org/publicdomain/zero/1.0/">
                            <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
                        </a>
                        <br/><br/>
                        To the extent possible under law, the University of Washington Libraries has waived all copyright and related or neighboring rights to the <xsl:value-of select="$datasetName"/>. This work was published in the United States.
                    </p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>