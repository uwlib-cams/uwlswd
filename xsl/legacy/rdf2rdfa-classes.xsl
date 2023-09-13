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
    
    <xsl:variable name="base">https://www.lib.washington.edu/static/public/cams/data/localResources/</xsl:variable>
    <xsl:variable name="filename">classes_local</xsl:variable>
    <xsl:variable name="version">1-0-0</xsl:variable>
    <xsl:variable name="hrefBase" select="concat($base,$filename,'-',$version)"></xsl:variable>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">
            <head>
                <title>Classes: University of Washington Libraries rdfs:Class definitions</title>
                <script type="application/ld+json">
                    {
                    "@context" : "http://schema.org" ,
                    "@type" : "Dataset" ,
                    "@id" : "https://doi.org/10.6069/uwlib.55.d.1" ,
                    "creator" : {
                    "@type" : "Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    } ,
                    "name" : "Classes: University of Washington Libraries rdfs:Class definitions" ,
                    "alternateName" : "Local classes, University of Washingto Libraries" ,
                    "description" : "Classes used in University of Washington Libraries RDF data." ,
                    "publisher" : {
                    "@type" : "Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    },
                    "datePublished" : "2018" ,
                    "inLanguage" : "English" ,
                    "encodingFormat" : "application/xhtml+xml" ,
                    "version" : "1-0-0" ,
                    "license" : "http://creativecommons.org/publicdomain/zero/1.0/"
                    }
                </script>
                <link rel="alternate" type="application/n-triples"
                    href="{concat($hrefBase,'.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($hrefBase,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($hrefBase,'.ttl')}"
                />
            </head>
            <body about="https://doi.org/10.6069/uwlib.55.D.1">
                <h1>Classes: University of Washington Libraries rdfs:Class definitions</h1>
                <p>RDF dataset describing classes used in University of Washington Libraries RDF data.</p>
                <p>The RDF dataset below is a description of classes needed to describe University of Washington Libraries resources. It is available in this format, HTML with embedded RDFa, as well as <a href="{concat($hrefBase,'.nt')}">N-Triples</a>, <a href="{concat($hrefBase,'.rdf')}">RDF/XML</a> and <a href="{concat($hrefBase,'.ttl')}">Turtle</a>. All data is in th public domain and may be used without restiction.</p>
                
                
                <h2>Triples for "Classes: University of Washington Libraries rdfs:Class definitions"</h2>
                <table border="1" cellpadding="6">
                    <tr>
                        <th>Subject</th>
                        <th>Predicate</th>
                        <th>Object</th>
                    </tr>
                    <xsl:apply-templates select="rdf:RDF" mode="resource"/>
                    <xsl:apply-templates select="rdf:RDF" mode="bnode"/>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:include href="rdf2rdfa-table.xsl"/>
    
</xsl:stylesheet>