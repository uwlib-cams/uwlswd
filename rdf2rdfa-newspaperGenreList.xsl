<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:dpla="http://dp.la/about/map/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:rdaclass="http://rdaregistry.info/Elements/c/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:ldproc="https://doi.org/10.6069/uwlib.55.b.2#" xmlns:rdaext="https://doi.org/10.6069/uwlib.55.d.4"
    version="2.0">
    
    <xsl:variable name="name">Newspaper Genre List</xsl:variable>
    <xsl:variable name="base">https://uwlib-cams.github.io/uwlswd_vocabs/</xsl:variable><!-- Probably will change to some github location -->
    <xsl:variable name="filename">newspaperGenreList</xsl:variable>
    <xsl:variable name="version">1-0-0</xsl:variable>
    <xsl:variable name="hrefBase" select="concat($base,$filename)"></xsl:variable><!-- removed arg3 from concat() spec [[,$version]] -->
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en"
            prefix="http://www.w3.org/1999/xhtml xsi: http://www.w3.org/2001/XMLSchema-instance  rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns# hclsr: https://doi.org/10.70027/uwlib.55.A.2.1# dct: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/ edm: http://www.europeana.eu/schemas/edm/ rdfs: http://www.w3.org/2000/01/rdf-schema# foaf: http://xmlns.com/foaf/0.1/ dpla: http://dp.la/about/map/ ldproc: https://doi.org/10.6069/uwlib.55.b.2# skos: http://www.w3.org/2004/02/skos/core# bf: http://id.loc.gov/ontologies/bibframe/ ore: http://www.openarchives.org/ore/terms/ dcmitype: http://purl.org/dc/dcmitype/ xs: http://www.w3.org/2001/XMLSchema">
            <head>
                <title><xsl:value-of select="$name"/></title>
                <script type="application/ld+json">
                    {
                    "@context" : "http://schema.org" ,
                    "@type" : "https://schema.org/DefinedTermSet" ,
                    "@id" : "https://doi.org/10.6069/uwlib.55.d.5" ,
                    "sourceOrganization" : {
                    "@type" : "https://schema.org/Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    } ,
                    "editor" : {
                    "@type" : "https://schema.org/Person",
                    "name" : "Jessica Albano" 
                    },
                    "name" : "Newspaper Genre List" ,
                    "description" : "Standardizes terms used to designate genres of newspapers. The perspective and scope of the list reflects types of papers cataloged by members of the United States Newspaper Program. The Library of Congress Network Development and MARC Standards Office has assigned the MARC code 'ngl' to the Newspaper Genre List. This code may be used in subfield $2 (Source of term) in field 655 (Index Term--Genre/Form). The intent is for these terms to provide additional access in conjunction with authorized LC subject headings." ,
                    "publisher" : {
                    "@type" : "Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    },
                    "datePublished" : "2021" ,
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
                    href="{concat($hrefBase,'.ttl')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($hrefBase,'.json')}"/>
                
                
            </head>
            <body about="https://doi.org/10.6069/uwlib.55.d.5">
                <h1><xsl:value-of select="$name"/></h1>
                <p>The following table represents a list standardizing terms used to designate genres of newspapers. The perspective and scope of the list reflects types of papers cataloged by members of the <a href="https://www.neh.gov/us-newspaper-program">United States Newspaper Program</a>.</p>
                <p>The page source (the underlying HTML markup) of the table is an RDF dataset (using RDFa) comprising an RDF vocabulary for the Newspaper Genre List. The <a href="https://www.lib.washington.edu/gmm/collections/mcnews/ngl">original HTML page</a> is still available.</p>
                <p>The intent is for these terms to provide additional access in conjunction with authorized LC subject headings or other vocabularies.</p>  
                <p>The RDF Newspaper Genre List is available in this format, HTML with embedded RDFa, as well as <a href="{concat($hrefBase,'.nt')}">N-Triples</a>, <a href="{concat($hrefBase,'.rdf')}">RDF/XML,</a> <a href="{concat($hrefBase,'.json')}">JSON-LD,</a> and <a href="{concat($hrefBase,'.ttl')}">Turtle</a>. All data is in the public domain and may be used without restiction.</p>
                
                
                <h2>Triples for "<xsl:value-of select="$name"/>"</h2>
                <table border="1" cellpadding="6">
                    <tr>
                        <th>Subject</th>
                        <th>Predicate</th>
                        <th>Object</th>
                    </tr>
                    <xsl:apply-templates select="rdf:RDF" mode="resource"/>
                    <xsl:apply-templates select="rdf:RDF" mode="bnode"/>
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
                        <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
                            style="border-style: none;" alt="CC0"/>
                    </a>
                    <br/><br/> To the extent possible under law, the University of Washington
                    Libraries has waived all copyright and related or neighboring rights to the
                    <xsl:value-of select="$name"/>. This work was published in the United
                    States. </p>
            </body>
        </html>
    </xsl:template>
    
    <xsl:include href="rdf2rdfa-table.xsl"/>
    
</xsl:stylesheet>