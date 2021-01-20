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
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="datasetName">RDF Vocabulary for Linked Data Processes</xsl:variable><!-- Title of dataset -->
    <xsl:variable name="path">https://www.lib.washington.edu/static/public/cams/data/vocabularies/</xsl:variable> <!-- path to dataset, up to file name -->
    <xsl:variable name="filename">reconVocab-1-2-1</xsl:variable><!-- filename of dataset without file extension -->
    
    <xsl:template match="/">
        <!-- 2018-09-13 -->
        <!-- html declaration -->
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">
            
            <!-- head must contain:
                 title
                 links to alternative serializations using <LINK> -->
            <head>
                <title><xsl:value-of select="$datasetName"/></title>
                <script type="application/ld+json">
                    {
                    "@context" : "http://schema.org" ,
                    "@type" : "Dataset" ,
                    "@id" : "https://doi.org/10.6069/uwlib.55.b.2" ,
                    "creator" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "name" : "RDF Vocabulary for Linked Data Processes" ,
                    "alternateName" : "Reconciliation Vocabulary" ,
                    "description" : "Vocabulary for describing processes run on linked data datasets." ,
                    "publisher" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "datePublished" : "2018" ,
                    "inLanguage" : "English" ,
                    "encodingFormat" : "application/xhtml+xml" ,
                    "version" : "1-2-1" ,
                    "license" : "http://creativecommons.org/publicdomain/zero/1.0/"
                    }
                </script>
                <link rel="alternate" type="application/n-triples"
                    href="{concat($path,$filename,'.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($path,$filename,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($path,$filename,'.ttl')}"
                />
            </head>
            
            <body>
                <!-- Title of dataset -->
                <h1><xsl:value-of select="$datasetName"/></h1>
      
                <!-- NOTE on this section: Number of parts may vary from dataset to dataset -->
                <h2>About the <xsl:value-of select="$datasetName"/></h2>
                <p>The RDF triples below define a vocabulary for describing processes run on linked data datasets.</p>
                <p>This vocabulary was originally intended as administrative and provenance data for RDF datasets produced at the University of Washington Libraries.</p>
                <p>All serializations of this dataset are accessible online. The HTML format contains machine-readable RDFa data, and also serves as a human-readable landing page for each part. Links to alternate serializations are contained in the introductory material. No zipped downloads or SPARQL endpoints are currently available.</p>
                
                <!-- Links to alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of select="$datasetName"/></h2>
                <ul>
                    <li><a href="{concat($path,$filename,'.nt')}">N-Triples</a></li>
                    <li><a href="{concat($path,$filename,'.rdf')}">RDF/XML</a></li>
                    <li><a href="{concat($path,$filename,'.ttl')}">Turtle</a></li>
                </ul>
                <!-- About the current dataset part (in the HTML table below) -->
                <!-- we have no info about the curent dataset part, ok?? -->
                
                <!-- Table headline -->
                <h2>RDF Triples for <xsl:value-of select="$datasetName"/></h2>               
                <!-- Table setup below always stays the same -->
                <table border="1" cellpadding="6">
                    <tr>
                        <th>Subject</th>
                        <th>Predicate</th>
                        <th>Object</th>
                    </tr>
                    <xsl:apply-templates select="rdf:RDF" mode="resource"/>
                    <xsl:apply-templates select="rdf:RDF" mode="bnode"/>
                </table>
                <hr/><hr/>
                
                <!-- Contact information -->
                <h3>Contact:</h3>
                <p>
                    <a href="https://www.lib.washington.edu/msd">University of Washington Libraries, Cataloging and Metadata Services</a><br/>
                    Box 352900, Seattle, WA 98195-2900<br/>
                    Telephone: 206-543-1919<br/>
                    <a href="mailto:tgis@uw.edu">tgis@uw.edu</a></p>
                <hr/><hr/>
                
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
    
    <!-- Be sure to include the actual RDFa transform! -->
    <xsl:include href="rdf2rdfa-table.xsl"/>
    
</xsl:stylesheet>