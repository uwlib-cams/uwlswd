<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:datacite="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="#all" expand-text="yes" version="3.0">
    <xsl:output method="html" indent="yes"/>

    <!-- footer template from webviews -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>

    <!-- variables -->
    <xsl:variable name="columns"/>
    <xsl:variable name="temp_index_categories"
        select="doc('../xml/temp_index_categories.xml')/temp_index_categories"/>
    <xsl:variable name="DataCite_resources"
        select="collection('../DataCite/?select=*.xml')/datacite:resource"/>
    <xsl:variable name="doi_title_desc">
        <collection>
            <xsl:for-each select="$DataCite_resources">
                <resource>
                    <doi>{datacite:identifier[@identifierType = 'DOI']}</doi>
                    <title>{datacite:titles/datacite:title[not(@titleType)]}</title>
                    <description>{datacite:descriptions/datacite:description}</description>
                </resource>
            </xsl:for-each>
        </collection>
    </xsl:variable>
    <!-- key -->
    <xsl:key name="datacite" match="collection/resource" use="title"/>

    <xsl:template match="/">
        <xsl:result-document href="../index.html">
            <html lang="en">
                <head>
                    <title>UWLSWD</title>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                    <link href="https://uwlib-cams.github.io/webviews/css/index_pages.css"
                        rel="stylesheet" type="text/css"/>
                    <link rel="icon" type="image/png"
                        href="https://uwlib-cams.github.io/webviews/images/book.png"/>
                </head>
                <body>
                    <h1 id="top">University of Washington Libraries Semantic Web Data</h1>
                    <p>The following datasets and vocabularies are published and maintained by the <a
                            href="https://www.lib.washington.edu/cams"
                            >University of Washington Libraries Cataloging and Metadata Services department</a>. For additional information about linked-data initiatives at the University of Washington Libraries, visit the <a
                            href="https://www.lib.washington.edu/cams/swr"
                            >University of Washington Libraries Semantic Web Resources</a> page.</p>
                    <!-- navigation links -->
                    <nav>
                        <h2>Categories</h2>
                        <ul>
                            <xsl:for-each select="$temp_index_categories/category">
                                <li>
                                    <a href="{concat('#', replace(@label, ' ', ''))}">{@label}</a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </nav>
                    <!-- link to CAMS public page
                        provide uwlsemanticweb@uw.edu email link -->
                    <xsl:for-each select="$temp_index_categories/category">
                        <h3 id="{replace(@label, ' ', '')}">{@label}</h3>
                        <xsl:for-each select="resource">
                            <xsl:variable name="URL"
                                select="concat('https://doi.org/', key('datacite', ., $doi_title_desc)/doi)"/>
                            <h4>{.}</h4>
                            <div class="margin_left_30">
                                <p>
                                    <a href="{$URL}">{$URL}</a>
                                </p>
                                <xsl:if test="key('datacite', ., $doi_title_desc)/description">
                                    <p class="italic"
                                        >{key('datacite', ., $doi_title_desc)/description}</p>
                                </xsl:if>
                            </div>
                        </xsl:for-each>
                        <div class="italic return_to_top">
                            <p>
                                <a href="#top">Return to categories</a>
                            </p>
                        </div>
                    </xsl:for-each>
                    <xsl:call-template name="CC0-footer">
                        <xsl:with-param name="resource_title" select="'UWLSWD'"/>
                        <xsl:with-param name="org" select="'cams'"/>
                    </xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
