<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dcite="http://datacite.org/schema/kernel-4"
    version="2.0">
    <xsl:variable name="files" select="collection('.?*.xml')"/>
    <xsl:template match="/">
        <xsl:for-each select="$files">
            <xsl:copy-of select="."></xsl:copy-of>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>