<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:datacite="http://datacite.org/schema/kernel-4"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
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
                    <resourceType>{datacite:resourceType}</resourceType>
                    <doi>{datacite:identifier[@identifierType = 'DOI']}</doi>
                    <title>{datacite:titles/datacite:title[not(@titleType)]}</title>
                    <description>{datacite:descriptions/datacite:description}</description>
                </resource>
            </xsl:for-each>
        </collection>
    </xsl:variable>
    <xsl:variable name="schema">
        <fn:map>
            <fn:string key="@context">http://schema.org</fn:string>
            <fn:string key="@type">DataCatalog</fn:string>
            <fn:string key="@id">https://uwlib-cams.github.io/uwlswd/</fn:string>
            <fn:string key="name">University of Washington Libraries Semantic Web Data</fn:string>
            <fn:string key="description">Catalog of datasets and vocabularies published and maintained by the University of Washington Libraries Cataloging and Metadata Services Department.</fn:string>
            <fn:map key="creator">
                <fn:string key="@type">LibrarySystem</fn:string>
                <fn:string key="@id">http://viaf.org/viaf/139541794</fn:string>
                <fn:string key="name">University of Washington Libraries</fn:string>
            </fn:map>
            <fn:map key="publisher">
                <fn:string key="@type">LibrarySystem</fn:string>
                <fn:string key="@id">http://viaf.org/viaf/139541794</fn:string>
                <fn:string key="name">University of Washington Libraries</fn:string>
            </fn:map>
            <fn:string key="datePublished">{format-date(current-date(), '[Y0001]')}</fn:string>
            <fn:string key="inLanguage">en</fn:string>
            <fn:string key="encodingFormat">text/html</fn:string>
            <fn:string key="license">http://creativecommons.org/publicdomain/zero/1.0</fn:string>
        </fn:map>
    </xsl:variable>
    <!-- key -->
    <xsl:key name="datacite" match="collection/resource" use="normalize-space(resourceType)"/>
    
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
                    <script type="application/ld+json">{xml-to-json($schema)}</script>
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
                        <xsl:variable name="category" select="normalize-space(@label)"/>
                        <h3 id="{replace(@label, ' ', '')}">{@label}</h3>
                        <xsl:for-each select="key('datacite', $category, $doi_title_desc)">
                            <xsl:variable name="URL"
                                select="concat('https://doi.org/', doi)"/>
                            <h4>{title}</h4>
                            <div class="margin_left_30">
                                <p>
                                    <a href="{$URL}">{$URL}</a>
                                </p>
                                <xsl:if test="description">
                                    <p class="italic"
                                        >{description}</p>
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
