<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:schema="https://schema.org/"
    xmlns:uwp="https://doi.org/10.6069/uwlib.55.d.3#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:uw="https://www.lib.washington.edu/static/public/cams/data/localResources/properties_local.html"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
    <!--
**Changes to directory structure:
y    1. create folder for every rdfxml file
y    2. place file in folder
**Change to root element
y    1. add prefix to root element:
        xmlns:schema="https://schema.org/"
**Changes to conceptSchemes:
y    <dct:type rdf:resource="http://purl.org/dc/dcmitype/Dataset"/>
y    <schema:disambiguatingDescription>SKOS Concept Scheme for MARC 00X Values</schema:disambiguatingDescription>
y    <dct:publisher rdf:resource="http://viaf.org/viaf/139541794"/>
y    <dct:source rdf:resource="https://www.loc.gov/marc/bibliographic/bd006.html"/>
y    <dct:source rdf:resource="http://marc21rdf.info"/>
y    <dct:provenance rdf:resource="https://doi.org/10.6069/uwlswd.2e2b-y833#marc00Xvalues"/>
y    <dct:creator rdf:resource="http://viaf.org/viaf/139541794"/>
y    <dct:contributor rdf:resource="http://viaf.org/viaf/151962300"/>
y    <dc:contributor xml:lang="en">Metadata Management Associates</dc:contributor>
y    <dct:issued>2024</dct:issued>
y    <dc:language>en</dc:language>
y    <dct:license rdf:resource="http://creativecommons.org/publicdomain/zero/1.0"/>
y    <schema:version>1-0-0</schema:version>
y    <dct:format rdf:resource="http://www.w3.org/ns/formats/RDF_XML"/>
y    appliesToMaterial needs actual IRI
y    swap skos:ConceptScheme for rdf:Description and add an rdf:type triple
y    <dct:title> needs lang tag
y    dct:alternative needs lang tag
y    dct:description needs lang tag
y    remove terminal # from IRI top-level
**Changes to Concepts
y    1. Accommodate values with notation = #
y    2. remove xml:lang="en" from concept top-level
y    2. remove skos:exactMatch triples from concepts
y    3. swap skos:Concept for rdf:Description and add an rdf:type triple\
y    4. remove terminal # from all skos:inScheme values
-->
    <xsl:output exclude-result-prefixes="#all"/>
    <xsl:variable name="files" select="collection('../../../uwlswd_vocabs_marc_007/?*.rdf')"/>
    <xsl:template match="/">
        <xsl:for-each select="$files">
            <xsl:variable name="fileName" select="tokenize(base-uri(.), '/')[last()]"/>
            <xsl:variable name="dirName" select="substring-before($fileName, '.rdf')"/>
            <xsl:result-document
                href="../../../tests-deleteContents/{$dirName}/{$fileName}">
                <!-- Old value for above: ../../uwlswd_vocabs_marc_007/copyAll007/{$dirName}/{$fileName} -->
                <xsl:apply-templates/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <rdf:RDF xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:schema="https://schema.org/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:uwp="https://doi.org/10.6069/uwlib.55.d.3#">
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="skos:ConceptScheme">
        <rdf:Description rdf:about="{substring-before(./@rdf:about,'#')}">
            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
            <dct:type rdf:resource="http://purl.org/dc/dcmitype/Dataset"/>
            <dct:title xml:lang="en">
                <xsl:value-of select="dct:title"/>
            </dct:title>
            <dct:alternative xml:lang="en">
                <xsl:value-of select="dct:alternative"/>
            </dct:alternative>
            <dct:description xml:lang="en">
                <xsl:value-of select="dct:description"/>
            </dct:description>
            <schema:disambiguatingDescription>SKOS Concept Scheme for MARC 00X Values</schema:disambiguatingDescription>
            <xsl:copy-of select="dct:publisher"/>
            <dct:source rdf:resource="https://www.loc.gov/marc/bibliographic/bd007.html"/>
            <dct:source rdf:resource="http://marc21rdf.info"/>
            <dct:provenance rdf:resource="https://doi.org/10.6069/uwlswd.2e2b-y833"/>
            <dct:creator rdf:resource="http://viaf.org/viaf/139541794"/>
            <dct:contributor rdf:resource="http://viaf.org/viaf/151962300"/>
            <dct:issued>2024</dct:issued>
            <dc:contributor xml:lang="en">Metadata Management Associates</dc:contributor>
            <dc:language>en</dc:language>
            <dct:license rdf:resource="http://creativecommons.org/publicdomain/zero/1.0"/>
            <schema:version>1-0-0</schema:version>
            <dct:issued>2024</dct:issued>
            <dct:format rdf:resource="http://www.w3.org/ns/formats/RDF_XML"/>
            <xsl:for-each select="uw:appliesToMaterial">
                <uwp:appliesToMaterial>
                    <xsl:value-of select="."/>
                </uwp:appliesToMaterial>
            </xsl:for-each>

        </rdf:Description>
    </xsl:template>
    <xsl:template match="skos:Concept">
        <xsl:element name="rdf:Description">
            <xsl:choose>
                <xsl:when test="ends-with(./@rdf:about, '%23')">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="concat(substring-before(./@rdf:about, '%'), 'pound')"
                        />
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="./@rdf:about"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
            <skos:inScheme rdf:resource="{substring-before(skos:inScheme/@rdf:resource,'#')}"/>
            <xsl:copy-of select="skos:prefLabel"/>
            <xsl:copy-of select="skos:definition"/>
            <xsl:copy-of select="skos:scopeNote"/>
            <xsl:copy-of select="skos:notation"/>
            <xsl:apply-templates select="skos:exactMatch"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="skos:exactMatch"/>
</xsl:stylesheet>
