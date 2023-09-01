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
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    version="3.0">
    
    <!-- rdfa xsl -->
    <xsl:include href="rdf2rdfa-table-draft.xsl"/>
    <xsl:include href="schemaOrgMarkup-draft.xsl"/>
    
    <!-- get from metadata file -->   
    <xsl:variable name="file_path">
        <xsl:variable name="base" select="base-uri()"/>
        <xsl:value-of select="substring-before($base, '.rdf')"/>
    </xsl:variable>
    <xsl:variable name="final_path" select="'https://uwlib-cams.github.io'"/>
    <!-- need to do this a better way -->
    <xsl:variable name="file_name" select="substring-after($file_path, '..')"/>
    <xsl:template match="/">
        <!-- currently gotten from rdf:description/rdf:type void#Dataset - is this in every dataset? -->
        <xsl:variable name="metadata_file_name">
            <xsl:variable name="rdfabout" select="rdf:RDF/rdf:Description[./rdf:type[@rdf:resource = 'http://rdfs.org/ns/void#Dataset']]/@rdf:about"/>
            <xsl:value-of select="concat('../DataCite/', substring-after($rdfabout, 'https://doi.org/10.6069/'), '.xml')"/>
            <!-- at some point change to github?-->
        </xsl:variable>
        <xsl:variable name="md_file" select="document($metadata_file_name)"/>
        
        <xsl:variable name="doi" select="lower-case(concat('https://doi.org/', $md_file/datacite:resource/datacite:identifier[@identifierType = 'DOI']))"/>
        <xsl:variable name="datasetName" select="$md_file/datacite:resource/datacite:titles/datacite:title[1]"/>
        
        <xsl:variable name="version" select="rdf:RDF/rdf:Description[lower-case(@rdf:about) = $doi]/owl:versionInfo"/>
        
        <!-- HTML declaration -->
        <html xmlns="http://www.w3.org/1999/xhtml"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">
            <head>
                <title>
                    <xsl:value-of select="$datasetName"/>
                </title>
                <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
                <link href="https://uwlib-cams.github.io/webviews/css/uwlswd.css" rel="stylesheet" type="text/css"/>
                <!-- schema.org content -->
                <!-- find out what variables are fixed vs unique -->
                <script type="application/ld+json">
                    <xsl:call-template name="jsonMarkup">
                        <xsl:with-param name="metadata_file_name" select="$metadata_file_name"/>
                        <xsl:with-param name="version" select="$version"/>
                    </xsl:call-template>
                </script>
                <link rel="alternate" type="application/n-triples"
                    href="{concat($final_path, $file_name, '.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($final_path, $file_name,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($final_path, $file_name,'.ttl')}"/>
                <link rel="alternate" type="application/ld+json"
                    href="{concat($final_path, $file_name,'.jsonld')}"/>
            </head>
            <body about="{$doi}">
                <!-- Title of dataset -->
                <h1>
                    <xsl:value-of select="$datasetName"/>
                </h1>
                <p>
                    <xsl:value-of select="$md_file/datacite:resource/datacite:descriptions/datacite:description"/>
                </p>
                <!-- Links to alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of select="$datasetName"/></h2>
                <div class="alternatelinks">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($final_path, $file_name,'.nt')"/>
                        </xsl:attribute>N-Triples
                    </a>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($final_path, $file_name,'.ttl')"/>
                        </xsl:attribute>Turtle
                    </a>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($final_path, $file_name,'.jsonld')"/>
                        </xsl:attribute>JSON-LD
                    </a>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($final_path, $file_name,'.rdf')"/>
                        </xsl:attribute>RDF/XML
                    </a>
                </div>
                    <!-- Table headline -->
                <h2 id="triples">RDF Triples for <xsl:value-of select="$datasetName"/></h2>
                    <!-- Table setup below always stays the same -->
                    <table>
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th>Predicate</th>
                                <th>Object</th>
                            </tr>
                        </thead>
                        <!-- add missing dct:hasFormat before passing to templates -->
                        <tbody>
                            <xsl:variable name="file_plus">
                                <xsl:copy select=".">
                                    <xsl:copy select="rdf:RDF">
                                        <xsl:copy select="rdf:Description[@rdf:about = $doi]">
                                            <xsl:copy-of select="@*"/>
                                            <xsl:copy-of select="node()"/>
                                            <xsl:element name="dct:hasFormat">
                                                <xsl:attribute name="rdf:resource">
                                                    <xsl:value-of select="concat($final_path, $file_name,'.rdf')"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:copy>
                                        <xsl:copy-of select="rdf:Description[not(@rdf:about = $doi)]"/>
                                    </xsl:copy>
                                </xsl:copy>
                            </xsl:variable>
                            <xsl:apply-templates select="$file_plus/rdf:RDF" mode="resource"/>
                            <xsl:apply-templates select="$file_plus/rdf:RDF" mode="bnode"/>
                        </tbody>
                    </table>
                <hr/>
                <!-- Contact information -->
                <div class="contact">
                    <h3>Contact:</h3>
                    <p>
                        <a href="https://www.lib.washington.edu/msd">University of Washington Libraries,
                            Cataloging and Metadata Services</a><br/> Box 352900, Seattle, WA 98195-2900<br/> Telephone: 206-543-1919<br/>
                        <a href="mailto:tgis@uw.edu">tgis@uw.edu</a></p>
                </div>
                <!-- CC0 image/link, rights statement -->
                <div class="footer_workaround"></div>
                <footer>
                    <div class="footer_container">
                        <a href="http://creativecommons.org/publicdomain/zero/1.0/">
                            <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
                        </a>
                        To the extent possible under law, the University of Washington Libraries has waived all copyright and related or neighboring rights to the <xsl:value-of select="$datasetName"/>. This work was published in the United States.
                    </div>
                </footer>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>