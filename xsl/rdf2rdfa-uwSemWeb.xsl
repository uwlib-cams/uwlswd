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
    <xsl:key name="resources" match="rdf:Description" use="@rdf:about"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <!-- Variables -->
        <xsl:variable name="currBaseIri">https://doi.org/10.6069/uwlib.55.a</xsl:variable>
        <xsl:variable name="uwlswdResource"
            >https://doi.org/10.6069/uwlib.55.a#uwSemWeb</xsl:variable>
        <!-- XHTML+RDFa output -->
        <html xmlns="http://www.w3.org/1999/xhtml" version="XHTML+RDFa 1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/xhtml http://www.w3.org/MarkUp/SCHEMA/xhtml-rdfa-2.xsd"
            lang="en" xml:lang="en">
            <head>
                <title>
                    <xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"/>
                </title>
                <xsl:text>
                </xsl:text>
                <script type="application/ld+json">
                    <xsl:call-template name="jsonMarkup"/>
                </script>
                <xsl:text>
                </xsl:text>
                <xsl:for-each
                    select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:hasFormat">
                    <xsl:choose>
                        <xsl:when test="ends-with(@rdf:resource, '.nt')">
                            <link rel="alternate" type="application/n-triples"
                                href="{@rdf:resource}"/>
                        </xsl:when>
                        <xsl:when test="ends-with(@rdf:resource, '.rdf')">
                            <link rel="alternate" type="application/rdf+xml" href="{@rdf:resource}"
                            />
                        </xsl:when>
                        <xsl:when test="ends-with(@rdf:resource, '.ttl')">
                            <link rel="alternate" type="text/turtle" href="{@rdf:resource}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </head>
            <body>
                <!-- Dataset title -->
                <h1>
                    <xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"/>
                </h1>
                <!-- Dataset description -->
                <p>
                    <xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:description"
                    />
                </p>
                <!-- Dataset partitions -->
                <h3>This dataset consists of <xsl:value-of
                        select="count(rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/void:classPartition)"
                    /> partitions:</h3>
                <ul>
                    <xsl:for-each
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/void:classPartition">
                        <li>
                            <a
                                href="{distinct-values(key('resources', @rdf:resource)/@rdf:about[1])}">
                                <xsl:value-of select="key('resources', @rdf:resource)/dct:title"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                <!-- Digital collections -->
                <h3>Digital collections from which the dataset's resources were harvested:</h3>
                <ul>
                    <xsl:for-each
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/ldproc:dataHarvestSource">
                        <li>
                            <a href="{@rdf:resource}">
                                <xsl:value-of select="@rdf:resource"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                <!-- Alternate serializations -->
                <h2>Links to Alternate Serializations for <xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"
                    />:</h2>
                <ul>
                    <xsl:for-each
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:hasFormat">
                        <xsl:choose>
                            <xsl:when test="ends-with(@rdf:resource, '.nt')">
                                <li>
                                    <a href="{@rdf:resource}">N-Triples</a>
                                </li>
                            </xsl:when>
                            <xsl:when test="ends-with(@rdf:resource, '.rdf')">
                                <li>
                                    <a href="{@rdf:resource}">RDF/XML</a>
                                </li>
                            </xsl:when>
                            <xsl:when test="ends-with(@rdf:resource, '.ttl')">
                                <li>
                                    <a href="{@rdf:resource}">Turtle</a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <!-- Versioning -->
                <h2>Version Information:</h2>
                <p><xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"/>
                    is not versioned as a whole; the partitions only are versioned. See the data
                    below to determine the current version of each partition.</p>
                <!-- Table headline -->
                <h2>RDF Triples for <xsl:value-of
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"
                    /></h2>
                <!-- Table setup below always stays the same -->
                <table border="1" cellpadding="6">
                    <tr>
                        <th>Subject</th>
                        <th>Predicate</th>
                        <th>Object</th>
                    </tr>
                    <!-- Apply templates in the transform included below -->
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
                        select="rdf:RDF/rdf:Description[@rdf:about = $uwlswdResource]/dct:title"/>.
                    This work was published in the United States. </p>
            </body>
        </html>
    </xsl:template>
    <!-- Be sure to include the actual RDFa transform, schema.org markup transform! -->
    <xsl:include href="rdf2rdfa-table.xsl"/>
    <xsl:include href="schemaOrgMarkup-uwSemWeb.xsl"/>
</xsl:stylesheet>
