<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="xs math"
    expand-text="yes"
    version="3.0">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:include href="uwlswd_index_schema.xsl"/>
    <!-- test uwlswd_index_schema
    <xsl:output method="json" indent="yes"/>
    <xsl:template match="/">{xml-to-json($schema)}</xsl:template> -->
    <!-- webviews > footer template -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>
    
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
        <!-- 
        testing here
        can't process by resourceType (schema:disambiguatingDescription yet because:
            some resources still have no value
            some resources have incorrect value
        -->
        <xsl:for-each-group select="$DataCite_resources" group-by="normalize-space(datacite:resourceType)">
            <test>
                <resourceType>{current-grouping-key()}</resourceType>
            </test>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>