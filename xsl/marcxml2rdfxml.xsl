<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:void="http://rdfs.org/ns/void#">
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
               Problem: MARC 750 may have been used inappropriately?
               Can use skos:closeMatch or skos:relatedMatch for $0's that begin with http://id.loc.gov/authorities/subjects as those are skos:Concepts.
               Other 750s are fast headings and they are not skos:Concepts so we cannot use a skos mapping relation; in addition, they are not madsrdf:Authority instances and so we cannot use madsrdf:isIdentifiedByAuthority; so I believe we're stuck with rdfs:seeAlso.
               If other types of headings are used, we will have to write additional conditions.
        755 >> only $1 exist in NGL MARC records; extract only $1.
               All IRIs point to wikidata; these probably need to be related with rdfs:seeAlso.
    -->
    <!-- 
        ERRORS THAT SHOULD BE CORRECTED IN MARC XML:
        1. 155=Native American newspapers. 
            1.a. 680is a dupe of the 360. The 360 is correct. Deletre the 680.
            1.b. The 360 is truncated. Add the correct full text from the HTML.
        2. Is MARC 750 appropriately used in current MARC NGL? Shouldn't those be 755s?
            2.a. Note: 750s in current NGL always points to an authority.
        3. NGL IRIs entered in 555$1 should be moved to 555$0
    -->
    <xsl:key name="lookup" match="marc:record" use="marc:datafield[@tag = '155']"/>
    <xsl:template match="/">
        <rdf:RDF xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:ldproc="https://doi.org/10.6069/uwlib.55.b.2#"
            xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
            xmlns:void="http://rdfs.org/ns/void#">
            <rdf:Description rdf:about="https://doi.org/10.6069/uwlib.55.d.5">
                <dc:contributor>Jessica Albano</dc:contributor>
                <dcterms:contributor rdf:resource="http://viaf.org/viaf/139541794"/>
                <dcterms:description xml:lang="en">Terms used to designate genres of
                    newspapers.</dcterms:description>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.html"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.json"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.nt"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.rdf"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.ttl"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list.xml"/>
                <dcterms:hasFormat
                    rdf:resource="https://github.com/uwlib-cams/uwlswd_ngl/raw/main/newspaper_genre_list_uwl.html"/>
                <dcterms:hasFormat
                    rdf:resource="https://www.lib.washington.edu/gmm/collections/mcnews/ngl"/>
                <dcterms:title xml:lang="en">Newspaper Genre List</dcterms:title>
                <rdf:type rdf:resource="http://rdfs.org/ns/void#Dataset"/>
                <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
                <owl:versionInfo>1-1-0</owl:versionInfo>
                <rdfs:seeAlso rdf:resource="http://www.wikidata.org/entity/Q106632466"/>
                <void:class rdf:resource="http://www.w3.org/2004/02/skos/core#Collection"/>
                <void:class rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
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
