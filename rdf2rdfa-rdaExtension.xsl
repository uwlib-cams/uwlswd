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
    
    <xsl:variable name="name">RDA Application Profile Extension</xsl:variable>
    <xsl:variable name="base">https://www.lib.washington.edu/static/public/cams/data/localResources/</xsl:variable>
    <xsl:variable name="filename">rdaApplicationProfileExtension</xsl:variable>
    <xsl:variable name="version">1-0-0</xsl:variable>
    <xsl:variable name="hrefBase" select="concat($base,$filename,'-',$version)"></xsl:variable>
    
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
                    "@type" : "Dataset" ,
                    "@id" : "https://doi.org/10.6069/uwlib.55.d.4" ,
                    "creator" : {
                    "@type" : "Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    } ,
                    "name" : "RDA Application Profile Extension" ,
                    "alternateName" : "University of Washington Libraries' RDA Application Profile Extension" ,
                    "description" : "Properties required beyond those provided by the RDA Registry to describe RDA Entities at University of Washington Libraries." ,
                    "publisher" : {
                    "@type" : "Organization" ,
                    "name" : "University of Washington Libraries" ,
                    "url" : "http://www.lib.washington.edu/" ,
                    "sameAs" : "http://viaf.org/viaf/139541794"
                    },
                    "datePublished" : "2019" ,
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
            <body about="https://doi.org/10.6069/uwlib.55.d.3">
                <h1><xsl:value-of select="$name"/></h1>
                <p>Properties required beyond those provided by the RDA Registry to describe RDA Entities at University of Washington Libraries.</p>
                <p>The RDF dataset below is a description of local properties that are not provided in the RDA Registry. The University of Washington Libraries has developed an RDA application profile to which this set of properties serves as an extension. BIBFRAME properties were preferred for extending the UW RDA profile when available; when not available, properties were taken from other vocabularies as appropriate and added to the profile; however when no property was found to adequately express a relationship, UW modeled properties required and that process has resulted in this dataset.  It is available in this format, HTML with embedded RDFa, as well as <a href="{concat($hrefBase,'.nt')}">N-Triples</a>, <a href="{concat($hrefBase,'.rdf')}">RDF/XML</a> and <a href="{concat($hrefBase,'.ttl')}">Turtle</a>. All data is in the public domain and may be used without restiction.</p>
                
                
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