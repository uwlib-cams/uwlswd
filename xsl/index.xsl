<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:result-document href="./index.html">
            <html>
                <head>
                    <title>UWLSWD</title>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <link href="https://uwlib-cams.github.io/webviews/css/index_pages.css" rel="stylesheet"
                        type="text/css" />
                </head>
                <body>
                    <h1>University of Washington Libraries Semantic Web Data</h1>
                    <h2>Semantic-web data and related resources published by the University of Washington Libraries, Cataloging and Metadata Services</h2>
                    <xsl:for-each-group select="collection('../DataCite/?select=*.xml')/datacite:resource" group-by="datacite:resourceType">
                        <h2><xsl:value-of select="current-grouping-key()"/></h2>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:for-each-group>
                </body>
                
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="datacite:resource">
        <xsl:for-each select=".">
            <xsl:text> &#xa; </xsl:text>
            <h3>
            <a class="resource">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('https://doi.org/', ./datacite:identifier)"/>
                </xsl:attribute>
                <xsl:value-of select="./datacite:titles/datacite:title"/>
            </a>
            </h3>
            <xsl:for-each select="./datacite:descriptions/datacite:description">
                <p class="italic">
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>
            <xsl:text> &#xa; </xsl:text>
        </xsl:for-each>
    </xsl:template>
    

</xsl:stylesheet>