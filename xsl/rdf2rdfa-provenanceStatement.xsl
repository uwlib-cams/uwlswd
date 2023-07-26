<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dpla="http://dp.la/about/map/"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:ldproc="https://doi.org/10.6069/uwlib.55.b.2#"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:schema="http://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        
        <!-- Variables -->
        <xsl:variable name="currBaseIri">https://doi.org/10.6069/uwlswd.2e2b-y833</xsl:variable>
        <!--LINE BELOW THIS COMMENT EDITS THE VARIABLE IN THIS COMMENT, which is a file path
        <xsl:variable name="uwlswdBaseIri" select="document('https://doi.org/10.6069/uwlib.55.a')"/>
        -->
        <xsl:variable name="uwlswdBaseIri" select="document('../../uwlswd_datasets/void_description_of_the_dataset_university_of_washington_libraries_semantic_web_data.html')"/>
        <xsl:variable name="uwlswdResource"
            >https://doi.org/10.6069/uwlib.55.a#uwSemWeb</xsl:variable>
        <xsl:variable name="uwlIri"
            >https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries</xsl:variable>
        
        <!-- XHTML+RDFa output -->
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">
            <head>
                <title>
                    <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"
                    />
                </title>
                <xsl:text>
                </xsl:text>
                <script type="application/ld+json">
                    <xsl:call-template name="jsonMarkup1"/>
        "@id" : "<xsl:value-of select="$currBaseIri"/>" ,
        "name" : "<xsl:value-of select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"/>" ,
        "description" : "<xsl:value-of select="normalize-space($uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:description'])"/>" ,
        "datePublished" : "<xsl:value-of select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:issued']"/>" , 
                    <xsl:call-template name="jsonMarkup2"/>
                </script>
                <xsl:text>
                </xsl:text>
                <xsl:for-each
                    select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:hasFormat']">
                    <xsl:choose>
                        <xsl:when test="ends-with(@resource, '.nt')">
                            <link rel="alternate" type="application/n-triples" href="{@resource}"/>
                        </xsl:when>
                        <xsl:when test="ends-with(@resource, '.rdf')">
                            <link rel="alternate" type="application/rdf+xml" href="{@resource}"/>
                        </xsl:when>
                        <xsl:when test="ends-with(@resource, '.ttl')">
                            <link rel="alternate" type="text/turtle" href="{@resource}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </head>
            <body>
                <!-- Dataset title -->
                <h1>
                    <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"
                    />
                </h1>
                <!-- Dataset description -->
                <p>
                    <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:description']"
                    />
                </p>
                <!-- Backlink -->
                <h2>Backlink</h2>
                <p>This dataset is part of the dataset <a href="https://doi.org/10.6069/uwlib.55.a">
                    <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $uwlswdResource]/xhtml:td[@property = 'dct:title']"
                    />
                </a>.
                </p>
                <!-- Alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of
                    select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"
                /></h2>
                <ul>
                    <xsl:for-each
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:hasFormat']">
                        <xsl:choose>
                            <xsl:when test="ends-with(@resource, '.nt')">
                                <li>
                                    <a href="{@resource}">N-Triples</a>
                                </li>
                            </xsl:when>
                            <xsl:when test="ends-with(@resource, '.rdf')">
                                <li>
                                    <a href="{@resource}">RDF/XML</a>
                                </li>
                            </xsl:when>
                            <xsl:when test="ends-with(@resource, '.ttl')">
                                <li>
                                    <a href="{@resource}">Turtle</a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <!-- Versioning -->
                <h2>Version Information</h2>
                <ul>
                    <li>Version <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'owl:version']"
                    /></li>
                    <li>Issued <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:issued']"
                    /></li>
                </ul>
                <!-- Table headline -->
                <h2>RDF Triples for <xsl:value-of
                    select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"
                /></h2>
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
                    <xsl:value-of
                        select="$uwlswdBaseIri/xhtml:html/xhtml:body/xhtml:table/xhtml:tr[@about = $currBaseIri]/xhtml:td[@property = 'dct:title']"
                    />. This work was published in the United States. </p>
            </body>
        </html>
    </xsl:template>
    <!-- Be sure to include the actual RDFa transform, schema.org markup transform! -->
    <xsl:include href="rdf2rdfa-table.xsl"/>
    <xsl:include href="schemaOrgMarkup.xsl"/>
</xsl:stylesheet>
