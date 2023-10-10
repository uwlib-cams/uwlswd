<?xml version="1.0" encoding="UTF-8"?>
<!-- determine which namespaces we need -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:schema="https://schema.org/"
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    xmlns:dct="http://purl.org/dc/terms/"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    
    <!-- using xhtml method of output BECAUSE we want closing tags on all elements -->
    <!-- note that we are ACTUALLY outputing an HTML5+RDFa doc -->
    <xsl:output omit-xml-declaration="true" method="xhtml"/>
    
    <!-- rdfa xsl -->
    <xsl:include href="rdf2rdfa-table.xsl"/>
    <xsl:include href="dc2schemaorg.xsl"/>
    
    <!-- VARIABLES -->
    <!-- file path minus .rdf extension -->
    <xsl:variable name="file_path">
        <xsl:variable name="base" select="base-uri()"/>
        <xsl:value-of select="substring-before($base, '.rdf')"/>
    </xsl:variable>
    
    <!-- web server for links -->
    <xsl:variable name="final_path" select="'https://uwlib-cams.github.io'"/>
    
    <!-- relative file path (file_name) -->
    <!-- e.g. file_path is uwlswd/../uwlswd_vocabs/linked_data_platforms -->
    <!-- file_name would be /uwlswd_vocabs/linked_data_platforms for producing links to other serializations -->
    <xsl:variable name="file_name" select="replace(substring-after($file_path, 'uwlswd/'), '..', '', 'q')"/>
    
    <!-- TEMPLATE -->
    <xsl:template match="/">
        <!-- currently gotten from rdf:description/rdf:type void#Dataset - is this in every dataset? -->
        <!-- DataCite metadata file name - uses DOI from rdf/xml file -->
        <xsl:variable name="metadata_file_name">
            <xsl:variable name="rdfabout" select="rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]/@rdf:about"/>
            <xsl:value-of select="concat('../DataCite/', substring-after($rdfabout, 'https://doi.org/10.6069/'), '.xml')"/>
        </xsl:variable>
        <xsl:variable name="md_file" select="document($metadata_file_name)"/>
        
        <!-- use doi from md_file to find title and version -->
        <xsl:variable name="doi" select="lower-case(concat('https://doi.org/', $md_file/datacite:resource/datacite:identifier[@identifierType = 'DOI']))"/>
        
        <xsl:variable name="version" select="rdf:RDF/rdf:Description[lower-case(@rdf:about) = $doi]/schema:version"/>
        
        <!-- rdf:description for resource as a whole -->
        <xsl:variable name="description" select="./rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]"/>
        <!-- HTML declaration -->
        
        <!-- doctype as text -->
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="en">
            
            <!-- prefix elements from input namespace prefixes -->
            <xsl:attribute name="prefix">
                <xsl:for-each select="rdf:RDF/namespace::*">
                    <xsl:value-of select="local-name(.)"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
            <head>
                <title>
                    <xsl:value-of select="$description/dct:title"/>
                </title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <link href="https://uwlib-cams.github.io/webviews/css/uwlswd.css" rel="stylesheet" type="text/css"/>
                <!-- schema.org content -->
                <!-- find out what variables are fixed vs unique -->
                <script type="application/ld+json">
                    <xsl:call-template name="schemaorgMarkup">
                        <xsl:with-param name="metadata_file_name" select="$metadata_file_name"/>
                        <xsl:with-param name="version" select="$version"/>
                    </xsl:call-template>
                </script>
                <!-- alternate links (not visible on page) -->
                <link rel="alternate" type="application/n-triples"
                    href="{concat($final_path, $file_name, '.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($final_path, $file_name,'.rdf')}"/>
                <link rel="alternate" type="text/turtle"
                    href="{concat($final_path, $file_name,'.ttl')}"/>
                <link rel="alternate" type="application/ld+json"
                    href="{concat($final_path, $file_name,'.jsonld')}"/>
            </head>
            <body about="{$doi}">
                <!-- Title of dataset -->
                <!-- Title of dataset -->
                <h1>
                    <xsl:value-of select="$description/dct:title"/>
                </h1>
                <xsl:if test="$description/dct:alternative">
                    <xsl:choose>
                        <xsl:when test="count($description/dct:alternative) = 1">
                            <h2 id="altTitle">(<xsl:value-of select="$description/dct:alternative"/>)</h2>
                        </xsl:when>
                        <xsl:otherwise>
                            <h2 id="altTitle">(<xsl:for-each select="$description/dct:alternative">
                                <xsl:choose>
                                    <xsl:when test="position() = count($description/dct:alternative)">
                                        <xsl:value-of select="."/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>, 
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>)</h2>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <p>
                    <xsl:value-of select="$description/dct:description"/>
                </p>
                <!-- Links to alternate serializations -->
                <h2 id="links">Links to Alternate Serializations for <xsl:value-of select="$description/dct:title"/></h2>
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
                <h2 id="triples">RDF Triples for <xsl:value-of select="$description/dct:title"/></h2>
                <!-- Table setup below always stays the same -->
                <table>
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Predicate</th>
                            <th>Object</th>
                        </tr>
                    </thead>
                    <!-- add missing dct:hasFormat and update dct:format before passing to templates -->
                    <tbody>
                        <xsl:variable name="file_plus">
                            <xsl:copy select=".">
                                <xsl:copy select="rdf:RDF">
                                    <xsl:copy select="rdf:Description[@rdf:about = $doi]">
                                        <xsl:copy-of select="@*"/>
                                        <xsl:copy-of select="node()"/>
                                        <xsl:copy select="./dct:hasFormat[1]">
                                            <xsl:attribute name="rdf:resource">
                                                <xsl:value-of select="concat($final_path, $file_name,'.rdf')"/>
                                            </xsl:attribute>
                                        </xsl:copy>
                                        <xsl:copy select="./dct:format[1]">
                                            <xsl:attribute name="rdf:resource">
                                                <xsl:value-of select="'http://www.w3.org/ns/formats/RDFa'"/>
                                            </xsl:attribute>
                                        </xsl:copy>
                                    </xsl:copy>
                                    <xsl:copy-of select="rdf:Description[not(@rdf:about = $doi)]"/>
                                </xsl:copy>
                            </xsl:copy>
                        </xsl:variable>
                        <xsl:apply-templates select="$file_plus/rdf:RDF" mode="resource"/>
                        <xsl:apply-templates select="$file_plus/rdf:RDF" mode="bnode"/>
                    </tbody>
                </table>
                <hr></hr>
                <!-- Contact information -->
                <div class="contact">
                    <h3>Contact:</h3>
                    <p>
                        <a href="https://www.lib.washington.edu/msd">University of Washington Libraries,
                            Cataloging and Metadata Services</a><br/> Box 352900, Seattle, WA 98195-2900<br/> Telephone: 206-543-1919<br/>
                        <a href="mailto:tgis@uw.edu">tgis@uw.edu</a></p>
                </div>
                <!-- CC0 image/link, rights statement -->
                <xsl:call-template name="CC0-footer">
                    <xsl:with-param name="resource_title"
                        select="$description/dct:title"/>
                    <xsl:with-param name="org" select="'cams'"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>