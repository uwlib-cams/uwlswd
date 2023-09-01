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
    xmlns:schema="https://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="html"/>
    <xsl:template match="/">
        <!-- var below requires file name change at end of path, depending on rdfxml file being processed -->
        <xsl:variable name="dataLoc" 
            select="document('../../uwlswd_vocabs_marc_006_008/008/visual_type_of_visual_material.rdf')"/>
        <xsl:variable name="prov" select="document('../../uwlswd_datasets/instances_of_the_provenancestatement_class.rdf')"/>
        <!-- XHTML+RDFa output -->
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of
                        select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:title"
                    />
                </title>
                <xsl:text>
                </xsl:text>
                <script type="application/ld+json">
                    "@context" : "http://schema.org" ,
                    "@id" : "<xsl:value-of select="$dataLoc/rdf:RDF/skos:ConceptScheme/@rdf:about"/>" ,
                    "@type" : "Dataset" ,
                    "@type" : "http://www.w3.org/2004/02/skos/core#ConceptScheme" ,
                    "name" : "<xsl:value-of select="normalize-space($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title)"/>" ,
                    "alternateName" : "<xsl:value-of select="normalize-space($dataLoc/rdf:RDF/skos:ConceptScheme/dct:alternative)"/>" ,
                    "description" : "<xsl:value-of select="normalize-space($dataLoc/rdf:RDF/skos:ConceptScheme/dct:description)"/>" ,
                    "datePublished" : "<xsl:value-of select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:issued"/>" ,
                    "creator" : {
                        "@type" : "Organization" ,
                        "@id" : "http://viaf.org/viaf/139541794" ,
                        "name" : "University Of Washington Libraries"
                    } , 
                    "publisher" : {
                        "@id" "http://viaf.org/viaf/139541794" 
                    } ,
                    <xsl:for-each select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:contributor">
                        <xsl:choose>
                            <xsl:when test="@rdf:resource">
                    "contributor" : {
                        "@id" : "<xsl:value-of select="@rdf:resource"/>" 
                                } ,
                            </xsl:when>
                            <xsl:otherwise>
                    "contributor" : {
                        "name" : "<xsl:value-of select="."/>" 
                                } ,
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="$dataLoc/rdf:RDF/skos:ConceptScheme/dc:contributor">
                        <xsl:choose>
                            <xsl:when test="@rdf:resource">
                    "contributor" : {
                        "@id" : "<xsl:value-of select="@rdf:resource"/>" 
                                } ,
                            </xsl:when>
                            <xsl:otherwise>
                    "contributor" : {
                        "name" : "<xsl:value-of select="."/>" 
                                } ,
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:source">
                    "isBasedOn" : "<xsl:value-of select="@rdf:resource"/>" ,
                    </xsl:for-each>
                    "inLanguage" : "en" ,
                    "encodingFormat" : "application/xhtml+xml" ,
                    "license" : "http://creativecommons.org/publicdomain/zero/1.0" ,
                    "version" : "<xsl:value-of select="$dataLoc/rdf:RDF/skos:ConceptScheme/schema:version"/>"
                </script>
                <link rel="alternate" type="application/n-triples" href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.nt"/>
                <link rel="alternate" type="application/rdf+xml" href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.rdf"/>
                <link rel="alternate" type="text/turtle" href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.ttl"/>
                <link rel="alternate" type="application/ld+json" href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.json"/>
            </head>
            <body>
                <!-- Dataset title -->
                <h1><xsl:value-of select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:title"/></h1>
                <!-- Dataset description -->
                <p><xsl:value-of select="normalize-space($dataLoc/rdf:RDF/skos:ConceptScheme/dct:description)"/></p>
                <p><xsl:value-of select="normalize-space($prov/rdf:RDF/rdf:Description[@rdf:about='https://doi.org/10.6069/uwlswd.2e2b-y833#marc00Xvalues']/rdf:value)"/></p>
                <!-- Alternate serializations -->
                <h2>Links to Alternate Serializations for 
                    <xsl:value-of select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:title"/>
                </h2>
                <ul>
                    <li>
                        <a href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.nt">N-Triples
                        </a>
                    </li>
                    <li>
                        <a href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.rdf">RDF/XML
                        </a>
                    </li>
                    <li>
                        <a href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.ttl">Turtle
                        </a>
                    </li>
                    <li>
                        <a href="https://uwlib-cams.github.io/uwlswd_vocabs_marc_006_008/008/{lower-case(replace(replace($dataLoc/rdf:RDF/skos:ConceptScheme/dct:title,' ','_'),':',''))}.json">JSON-LD
                        </a>
                    </li>
                </ul>
                <!-- Versioning -->
                <h2>Version Information</h2>
                <ul>
                    <li>Version <xsl:value-of
                        select="$dataLoc/rdf:RDF/skos:ConceptScheme/schema:version"/></li>
                    <li>Originally published <xsl:value-of
                        select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:issued"/></li>
                </ul>
                <!-- Table headline -->
                <h2>RDF Triples for <xsl:value-of
                    select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:title"/></h2>
                <!-- Table setup below always stays the same -->
                <table border="1" cellpadding="6" >
                    <tr>
                        <th>Subject</th>
                        <th>Predicate</th>
                        <th>Object</th>
                    </tr>
                    <xsl:for-each select="$dataLoc/rdf:RDF/skos:ConceptScheme">
                        <tr about="{@rdf:about}">
                            <td>
                                <a href="{@rdf:about}">
                                    <xsl:value-of select="@rdf:about"/>
                                </a>
                            </td>
                            <td><a href="http://www.w3.org/1999/02/22-rdf-syntax-ns#">rdf:type</a></td>
                            <td property="rdf:type" rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme">
                                <a href="http://www.w3.org/2004/02/skos/core#ConceptScheme">
                                    http://www.w3.org/2004/02/skos/core#ConceptScheme
                                </a>
                            </td>
                        </tr>
                        <xsl:for-each select="*">
                            <tr about="{../@rdf:about}">
                                <td>
                                    <a href="{../@rdf:about}">
                                        <xsl:value-of select="../@rdf:about"/>
                                    </a>
                                </td>
                                <td>
                                    <a href="{concat(namespace-uri(.),local-name(.))}">
                                        <xsl:value-of select="name(.)"/>
                                    </a>
                                </td>
                                <td>
                                    <xsl:attribute name="property">
                                        <xsl:value-of select="name(.)"/>
                                    </xsl:attribute>
                                    <!-- check for attributes -->
                                    <xsl:if test="./@rdf:datatype">
                                        <xsl:attribute name="datatype">
                                            <xsl:value-of select="./@rdf:datatype"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="./@xml:lang">
                                        <xsl:attribute name="lang"
                                            namespace="http://www.w3.org/XML/1998/namespace">
                                            <xsl:value-of select="./@xml:lang"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                        <!-- if object is rdf:resource, this becomes attrib AND value -->
                                        <xsl:when test="./@rdf:resource">
                                            <xsl:attribute name="resource">
                                                <xsl:value-of select="./@rdf:resource"/>
                                            </xsl:attribute>
                                            <a href="{./@rdf:resource}">
                                                <xsl:value-of select="./@rdf:resource"/>
                                            </a>
                                        </xsl:when>
                                        <!-- if it's a literal - no attrib -->
                                        <xsl:when test="./text()">
                                            <xsl:value-of select="."/>
                                        </xsl:when>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="$dataLoc/rdf:RDF/skos:Concept">
                        <tr about="{@rdf:about}">
                            <td id="{substring-after(@rdf:about,'#')}">
                                <a href="{@rdf:about}">
                                <xsl:value-of select="@rdf:about"/>
                                </a>
                            </td>
                            <td><a href="http://www.w3.org/1999/02/22-rdf-syntax-ns#">rdf:type</a></td>
                            <td property="rdf:type" rdf:resource="http://www.w3.org/2004/02/skos/core#Concept">
                                <a href="http://www.w3.org/2004/02/skos/core#Concept">
                                    http://www.w3.org/2004/02/skos/core#Concept
                                </a>
                            </td>
                        </tr>
                        <xsl:for-each select="*">
                            <tr about="{../@rdf:about}">
                                <td>
                                    <a href="{../@rdf:about}">
                                        <xsl:value-of select="../@rdf:about"/>
                                    </a>
                                </td>
                                <td>
                                    <a href="{concat(namespace-uri(.),local-name(.))}">
                                        <xsl:value-of select="name(.)"/>
                                    </a>
                                </td>
                                <td>
                                    <xsl:attribute name="property">
                                        <xsl:value-of select="name(.)"/>
                                    </xsl:attribute>
                                    <!-- check for attributes -->
                                    <xsl:if test="./@rdf:datatype">
                                        <xsl:attribute name="datatype">
                                            <xsl:value-of select="./@rdf:datatype"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="./@xml:lang">
                                        <xsl:attribute name="lang"
                                            namespace="http://www.w3.org/XML/1998/namespace">
                                            <xsl:value-of select="./@xml:lang"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                        <!-- if object is rdf:resource, this becomes attrib AND value -->
                                        <xsl:when test="./@rdf:resource">
                                            <xsl:attribute name="resource">
                                                <xsl:value-of select="./@rdf:resource"/>
                                            </xsl:attribute>
                                            <a href="{./@rdf:resource}">
                                                <xsl:value-of select="./@rdf:resource"/>
                                            </a>
                                        </xsl:when>
                                        <!-- if it's a literal - no attrib -->
                                        <xsl:when test="./text()">
                                            <xsl:value-of select="."/>
                                        </xsl:when>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
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
                        select="$dataLoc/rdf:RDF/skos:ConceptScheme/dct:title"
                    />. This work was published in the United States. </p>
            </body>
        </html>
    </xsl:template>
 </xsl:stylesheet>
