<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">
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
</xsl:stylesheet>