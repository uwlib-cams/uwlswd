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
    
    <!-- using xhtml method of output BECAUSE we want closing tags on all elements -->
    <!-- note that we are ACTUALLY outputing an HTML5+RDFa doc -->
    <xsl:output omit-xml-declaration="true" method="xhtml"/>
    
    <!-- rdfa xsl -->
    <xsl:include href="rdf2rdfa-table.xsl"/>
    <xsl:include href="rdf2schemaorg.xsl"/>
     
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

        <xsl:variable name="description" select="./rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]"/>
        
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
                <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
                <link href="https://uwlib-cams.github.io/webviews/css/uwlswd.css" rel="stylesheet" type="text/css"/>
                <!-- schema.org content -->
                <!-- find out what variables are fixed vs unique -->
                <script type="application/ld+json">
                    <xsl:call-template name="rdf2schemaorg"/>
                </script>
                <!-- alternate links (not visible on page) -->
                <link rel="alternate" type="application/n-triples"
                    href="{concat($final_path, $file_name, '.nt')}"/>
                <link rel="alternate" type="application/rdf+xml"
                    href="{concat($final_path, $file_name,'.rdf')}"/>
                <link rel="alternate" type="application/turtle"
                    href="{concat($final_path, $file_name,'.ttl')}"/>
                <link rel="alternate" type="application/ld+json"
                    href="{concat($final_path, $file_name,'.jsonld')}"/>
            </head>
            <body about="{$description/@rdf:about}">
                <!-- Title of dataset -->
                <h1>
                    <xsl:value-of select="$description/dct:title"/>
                </h1>
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
                        <!-- add missing dct:hasFormat before passing to templates -->
                        <tbody>
                            <xsl:variable name="file_plus">
                                <xsl:copy select=".">
                                    <xsl:copy select="rdf:RDF">
                                        <xsl:copy select="rdf:Description[@rdf:about = $description/dct:title]">
                                            <xsl:copy-of select="@*"/>
                                            <xsl:copy-of select="node()"/>
                                            <xsl:element name="dct:hasFormat">
                                                <xsl:attribute name="rdf:resource">
                                                    <xsl:value-of select="concat($final_path, $file_name,'.rdf')"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:copy>
                                        <xsl:copy-of select="rdf:Description[not(@rdf:about = $description/@rdf:about)]"/>
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
                <div class="footer_workaround"></div>
                <footer>
                    <div class="footer_container">
                        <a href="http://creativecommons.org/publicdomain/zero/1.0/">
                            <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
                        </a>
                        To the extent possible under law, the University of Washington Libraries has waived all copyright and related or neighboring rights to the <xsl:value-of select="$description/dct:title"/>. This work was published in the United States.
                    </div>
                </footer>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>