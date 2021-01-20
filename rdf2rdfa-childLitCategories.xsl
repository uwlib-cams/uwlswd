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

    <!-- BEGIN VARIABLES --> 

    <!-- Info about dataset -->
    <!-- Title of dataset -->
    <xsl:variable name="datasetName">Linked Data Vocabularies: Children's Literature Categories</xsl:variable>
    <xsl:variable name="currentPartDoi">https://doi.org/10.6069/uwlib.55.b.3</xsl:variable>
    <xsl:variable name="nameVersion">childrensLitCategories-1-0-0</xsl:variable>
    <xsl:variable name="description">Categories for describing types of historical childrens literature</xsl:variable>
    <!-- Filepath for generating links to serializations (path *up to filename*) -->
    <xsl:variable name="path">https://www.lib.washington.edu/static/public/cams/data/vocabularies/</xsl:variable>


    <!-- Dataset serializations: Tree, serialization names -->
    <xsl:variable name="sers">
        <sers>
            <ser>
                <xsl:value-of select="$nt"/>
            </ser>
            <ser>
                <xsl:value-of select="$turtle"/>
            </ser>
            <ser>
                <xsl:value-of select="$rdf"/>
            </ser>
        </sers>
    </xsl:variable>
    <xsl:variable name="nt">N-Triples</xsl:variable>
    <xsl:variable name="turtle">Turtle</xsl:variable>
    <xsl:variable name="rdf">RDF/XML</xsl:variable>

    <!-- END VARIABLES -->

    <xsl:template match="/">
        <!-- HTML declaration -->
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">

            <!-- Head must contain:
                 Title
                 Links to alternative serializations using <link> -->
            <head>
                <title>
                    <xsl:value-of select="$datasetName"/>
                </title>
                <script type="application/ld+json">
                    {
                    "@context" : "http://schema.org" ,
                    "@type" : "Dataset" ,
                    "@id" : "https://doi.org/10.6069/uwlib.55.b.3" ,
                    "creator" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "name" : "Linked Data Vocabularies: Children's Literature Categories" ,
                    "description" : "Categories for describing types of historical children's literature." ,
                    "publisher" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
                    "datePublished" : "2018" ,
                    "inLanguage" : "English" ,
                    "encodingFormat" : "application/xhtml+xml" ,
                    "version" : "1-0-0" ,
                    "license" : "http://creativecommons.org/publicdomain/zero/1.0/"
                    }
                </script>
                <link rel="alternate" type="application/n-triples"
                    href="{concat($path,$nameVersion,'.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($path,$nameVersion,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($path,$nameVersion,'.ttl')}"/>
            </head>

            <body about="{$currentPartDoi}">
                <!-- Title of dataset -->
                <h1>
                    <xsl:value-of select="$datasetName"/>
                </h1>
                <p>
                    <xsl:value-of select="$description"/>
                </p>

                <!-- Links to alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of select="$datasetName"
                    /></h2>
                <ul>
                    <xsl:for-each select="$sers/sers/ser">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:choose>
                                        <xsl:when test=". = $nt">
                                            <xsl:value-of
                                                select="concat($path, $nameVersion, '.nt')"/>
                                        </xsl:when>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test=". = $turtle">
                                            <xsl:value-of
                                                select="concat($path, $nameVersion, '.ttl')"/>
                                        </xsl:when>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test=". = $rdf">
                                            <xsl:value-of
                                                select="concat($path, $nameVersion, '.rdf')"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </a>
                        </li>
                    </xsl:for-each>
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
