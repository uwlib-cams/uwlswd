<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:schema="https://schema.org/">
    <!-- 
    MARC Authority fields present in NGL MARC Authority records:
        001 >> incorporated in concept IRI.
        003 >> not used in RDF.
        005 >> not used in RDF.
        008 >> not used in RDF.
        040 >> not used in RDF.
        075 >> extract $0 and $1 values; remaining subfields not used.
        155 >> only $a exist in NGL MARC records; extract only $a.
        260 >> Output full field as a single note.
               We create a skos:Collection for each 260.
        360 >> Output full field as a single note
        455 >> only $a exist in NGL MARC records; extract only $a.
        555 >> Output $1 value as value of one of 3 skos properties (either skos:broader, skos:narrower, or skos:related).
               Problem with $1:
                   NGL MARC currently has 2 IRI sources for this $1: the NGL itself & Wikidata.
                   The NGL IRIs, however, should have been in $0.
                   This should be manually changed in the MARC;
                   after that change to the MARC, the code below should be appropriately edited.
        680 >> only $i exist in NGL MARC records; extract only $i.
        681 >> not used in RDF.
        750 >> Output only $0. All 750s in current MARC NGL have only $0, no $1.
               $0 values are either FAST headings (not instances of skos:Concept) or have base IRI http://id.loc.gov/authorities/subjects (are instances of skos:Concept).
               If other types of headings are used, we will have to write additional conditions.
        755 >> only $1 exist in NGL MARC records; extract only $1.
    -->
    <xsl:key name="lookup" match="marc:record" use="marc:datafield[@tag = '155']"/>
    <xsl:template match="/">
        <rdf:RDF xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dct="http://purl.org/dc/terms/"
            xmlns:schema="http://schema.org/"
            xmlns:ldproc="https://doi.org/10.6069/uwlib.55.b.2#"
            xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
            xmlns:void="http://rdfs.org/ns/void#">
            <rdf:Description rdf:about="https://doi.org/10.6069/uwlib.55.d.5">
                <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
                <schema:disambiguatingDescription xml:lang="en">SKOS Concept Scheme</schema:disambiguatingDescription>
                <dc:creator xml:lang="en">University of Washington Libraries Government Publications, Maps, Microforms and Newspapers</dc:creator>
                <dct:title xml:lang="en">Newspaper Genre List</dct:title>
                <dc:publisher xml:lang="en">University of Washington Libraries</dc:publisher>
                <dct:publisher rdf:resource="http://viaf.org/viaf/139541794"/>
                <dct:issued>2021</dct:issued>
                <dc:language>en</dc:language>
                <dct:format rdf:resource="http://www.w3.org/ns/formats/RDF_XML"/>
                <dct:hasFormat
                    rdf:resource="https://uwlib-cams.github.io/uwlswd_ngl/newspaper_genre_list.html"/>
                <dct:hasFormat
                    rdf:resource="https://uwlib-cams.github.io/uwlswd_ngl/newspaper_genre_list.json"/>
                <dct:hasFormat
                    rdf:resource="https://uwlib-cams.github.io/uwlswd_ngl/newspaper_genre_list.nt"/>
                <dct:hasFormat
                    rdf:resource="https://uwlib-cams.github.io/uwlswd_ngl/newspaper_genre_list.ttl"/>
                <dct:hasFormat
                    rdf:resource="https://uwlib-cams.github.io/uwlswd_ngl/newspaper_genre_list.xml"/>
                <dct:hasFormat
                    rdf:resource="https://www.lib.washington.edu/gmm/collections/mcnews/ngl/"/>
                <dct:license rdf:resource="http://creativecommons.org/publicdomain/zero/1.0"/>
                <dct:description xml:lang="en">Terms used to designate genres of newspapers.</dct:description>
                <schema:version>1-1-1</schema:version>
                <dc:contributor>Jessica Albano</dc:contributor>
                <rdfs:seeAlso rdf:resource="http://www.wikidata.org/entity/Q106632466"/>
             </rdf:Description>
            <xsl:apply-templates select="marc:collection/marc:record"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="marc:record">

        <rdf:Description
            rdf:about="{concat('https://doi.org/10.6069/uwlib.55.d.5#', marc:controlfield[@tag='001'])}">
            <!-- 075=rdf:type -->
            <xsl:for-each select="marc:datafield[@tag = '075']">
                <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                    <rdf:type rdf:resource="{.}"/>
                </xsl:for-each>
            </xsl:for-each>
            <!-- 155=skos:prefLabel -->
            <skos:prefLabel xml:lang="eng">
                <xsl:value-of select="marc:datafield[@tag = '155']"/>
            </skos:prefLabel>
            <!-- 260=skos:note -->
            <xsl:for-each select="marc:datafield[@tag = '260']">
                <skos:note>
                    <xsl:value-of select="*"/>
                </skos:note>
            </xsl:for-each>
            <!-- 360=skos:note -->
            <xsl:for-each select="marc:datafield[@tag = '360']">
                <skos:note>
                    <xsl:value-of select="*"/>
                </skos:note>
            </xsl:for-each>
            <!-- 455=skos:altLabel -->
            <xsl:for-each select="marc:datafield[@tag = '455']">
                <skos:altLabel>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </skos:altLabel>
            </xsl:for-each>
            <!-- 555=skos:related or skos:broader or skos:narrower -->
            <xsl:for-each select="marc:datafield[@tag = '555']">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'w'] = 'h'">
                        <xsl:for-each
                            select="marc:subfield[@code = '1'] | marc:subfield[@code = '0']">
                            <skos:narrower>
                                <xsl:value-of select="."/>
                            </skos:narrower>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'w'] = 'g'">
                        <xsl:for-each
                            select="marc:subfield[@code = '1'] | marc:subfield[@code = '0']">
                            <skos:broader>
                                <xsl:value-of select="."/>
                            </skos:broader>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each
                            select="marc:subfield[@code = '1'] | marc:subfield[@code = '0']">
                            <skos:related>
                                <xsl:value-of select="."/>
                            </skos:related>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!-- 680=skos:scopeNote -->
            <xsl:for-each select="marc:datafield[@tag = '680']">
                <skos:scopeNote>
                    <xsl:value-of select="marc:subfield[@code = 'i']"/>
                </skos:scopeNote>
            </xsl:for-each>
            <!-- 750=skos:closeMatch and rdfs:seeAlso -->
            <xsl:for-each select="marc:datafield[@tag = '750']">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(marc:subfield[@code = '0'], 'http://id.loc.gov/authorities')">
                        <skos:closeMatch>
                            <xsl:value-of select="marc:subfield[@code = '0']"/>
                        </skos:closeMatch>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdfs:seeAlso>
                            <xsl:value-of select="marc:subfield[@code = '0']"/>
                        </rdfs:seeAlso>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!-- 755=rdfs:seeAlso -->
            <xsl:for-each select="marc:datafield[@tag = '755']">
                <rdfs:seeAlso>
                    <xsl:value-of select="marc:subfield[@code = '1']"/>
                </rdfs:seeAlso>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
