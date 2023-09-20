<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:schema="https://schema.org/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="description"
            select="rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]"/>
        <xsl:result-document
            href="./DataCite/{substring-after($description/@rdf:about, 'https://doi.org/10.6069/')}.xml">
            <resource xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns="http://datacite.org/schema/kernel-4"
                xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
                <identifier identifierType="DOI">
                    <xsl:value-of
                        select="upper-case(substring-after($description/@rdf:about, 'https://doi.org/'))"
                    />
                </identifier>
                <titles>
                    <title>
                        <xsl:choose>
                            <xsl:when test="$description/dct:title">
                                <xsl:if test="$description/dct:title[@xml:lang]">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="$description/dct:title/@xml:lang"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$description/dct:title"/>
                            </xsl:when>
                            <xsl:otherwise> VALUE MISSING 
                                <xsl:message>dct:title missing in rdf/xml</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </title>
                    <xsl:if test="$description/dct:alternative">
                        <title titleType="AlternativeTitle">
                            <xsl:if test="$description/dct:alternative[@xml:lang]">
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$description/dct:alternative/@xml:lang"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$description/dct:alternative"/>
                        </title>
                    </xsl:if>
                </titles>
                <creators>
                    <xsl:choose>
                        <xsl:when test="$description/dc:creator">
                            <xsl:for-each select="$description/dc:creator">
                                <creator>
                                    <creatorName>
                                        <xsl:if test="$description/dc:creator[@xml:lang]">
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$description/dc:creator/@xml:lang"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="."/>
                                    </creatorName>
                                </creator>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <creator>
                                <creatorName>VALUE MISSING</creatorName>
                            </creator>
                            <xsl:message>dc:creator missing in rdf/xml</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </creators>
                <xsl:if test="$description/dc:contributor">
                    <contributors>
                        <xsl:for-each select="$description/dc:contributor">
                            <contributor>
                                <contributorName>
                                    <xsl:if test=".[@xml:lang]">
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="./@xml:lang"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="."/>
                                </contributorName>
                            </contributor>
                        </xsl:for-each>
                    </contributors>
                </xsl:if>
                <publisher>
                    <xsl:choose>
                        <xsl:when test="$description/dc:publisher">
                            <xsl:if test="$description/dc:publisher[@xml:lang]">
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$description/dc:publisher/@xml:lang"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$description/dc:publisher"/>
                        </xsl:when>
                        <xsl:otherwise>VALUE MISSING 
                            <xsl:message>dc:publisher missing in rdf/xml</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </publisher>
                <publicationYear>
                    <xsl:choose>
                        <xsl:when test="$description/dct:issued">
                            <xsl:value-of select="$description/dct:issued"/>
                        </xsl:when>
                        <xsl:otherwise> VALUE MISSING 
                            <xsl:message>dct:issued missing in rdf/xml</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </publicationYear>
                <resourceType>
                    <xsl:attribute name="resourceTypeGeneral">
                        <xsl:choose>
                            <xsl:when test="$description/schema:additionalType">
                                <xsl:value-of select="$description/schema:additionalType"/>
                            </xsl:when>
                            <xsl:otherwise> VALUE MISSING 
                                <xsl:message>schema:additonalType missing in rdf/xml</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <!-- no need to check if rdf:type is missing - it has to exist to locate $description -->
                    <xsl:value-of select="$description/rdf:type/@rdf:resource"/>
                </resourceType>

                <xsl:choose>
                    <xsl:when test="$description/dc:language">
                        <language>
                            <xsl:value-of select="$description/dc:language"/>
                        </language>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>dc:language missing from rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="$description/dct:source">
                        <relatedIdentifiers>
                            <xsl:for-each select="$description/dct:source[@rdf:resource]">
                                <relatedIdentifier relatedIdentifierType="URL"
                                    relationType="IsDerivedFrom">
                                    <xsl:value-of select="./@rdf:resource"/>
                                </relatedIdentifier>
                            </xsl:for-each>
                        </relatedIdentifiers>
                    </xsl:when>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="$description/dct:license">
                        <rightsList>
                            <rights>
                                <xsl:attribute name="rightsURI">
                                    <xsl:value-of select="$description/dct:license/@rdf:resource"/>
                                </xsl:attribute>
                            </rights>
                        </rightsList>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>dct:license missing in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="$description/dct:description">
                        <descriptions>
                            <xsl:for-each select="$description/dct:description">
                                <description>
                                    <xsl:if test=".[@xml:lang]">
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="./@xml:lang"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$description/rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme'">
                                            <xsl:attribute name="descriptionType"
                                                >TechnicalInfo</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                    <xsl:value-of select="."/>
                                </description>
                            </xsl:for-each>
                            <xsl:if test="$description/skos:scopeNote">
                                <xsl:for-each select="$description/skos:scopeNote">
                                    <description>
                                        <xsl:if test=".[@xml:lang]">
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="./@xml:lang"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$description/rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme'">
                                                <xsl:attribute name="descriptionType"
                                                  >TechnicalInfo</xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
                                        <xsl:value-of select="."/>
                                    </description>
                                </xsl:for-each>
                            </xsl:if>
                        </descriptions>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>dct:description not in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </resource>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
