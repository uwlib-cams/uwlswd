<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:datacite="http://datacite.org/schema/kernel-4" exclude-result-prefixes="#all"
    expand-text="yes" version="3.0">
    
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="DataCite_resources"
        select="collection('../DataCite/?select=*.xml')/datacite:resource"/>

    <xsl:template match="/">
        <xsl:result-document href="../xml/temp_index_categories.xml">
            <temp_index_categories>
                <xsl:for-each-group select="$DataCite_resources"
                    group-by="normalize-space(datacite:resourceType)">
                    <category label="{current-grouping-key()}">
                        <xsl:for-each select="current-group()">
                            <resource>{normalize-space(datacite:titles/datacite:title
                                [not(@titleType = 'AlternativeTitle')][@xml:lang = 'en'])}</resource>
                        </xsl:for-each>
                    </category>
                </xsl:for-each-group>
            </temp_index_categories>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
