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
                <!-- identifier should never be missing, it's how we find the correct rdf:description -->
                <identifier identifierType="DOI">
                    <xsl:value-of
                        select="upper-case(substring-after($description/@rdf:about, 'https://doi.org/'))"
                    />
                </identifier>
                
                <!-- titles-->
                <xsl:choose>
                    <!-- main title - REQUIRED -->
                    <xsl:when test="$description/dct:title">
                        <titles>
                            <title>
                                <!-- @xml:lang attribute -->
                                <xsl:if test="$description/dct:title[@xml:lang]">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="$description/dct:title/@xml:lang"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$description/dct:title"/>
                            </title>
                            <!-- alternative titles -->
                            <xsl:if test="$description/dct:alternative">
                                <xsl:for-each select="$description/dct:alternative">
                                    <title titleType="AlternativeTitle">
                                        <!-- @xml:lang attribute -->
                                        <xsl:if test=".[@xml:lang]">
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="./@xml:lang"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="."/>
                                    </title>
                                </xsl:for-each>
                            </xsl:if>
                        </titles>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>REQUIRED VALUE MISSING: dct:title missing in rdf/xml.</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- creators - NEEDS EDITING -->
                <creators>
                    <xsl:choose>
                        <xsl:when test="$description/dct:creator">
                            <xsl:for-each select="$description/dct:creator">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$description/dc:creator">
                            <xsl:for-each select="$description/dc:creator">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message>REQUIRED VALUE MISSING: dct:creator or dc:creator missing in rdf/xml</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </creators>
                
                <!-- publisher - REQUIRED, MAX 1 -->
                <xsl:choose>
                    <xsl:when test="$description/dct:publisher">
                        <xsl:apply-templates select="$description/dct:publisher"/>
                    </xsl:when>
                    <xsl:when test="$description/dc:publisher">
                        <xsl:apply-templates select="$description/dc:publisher"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>REQUIRED VALUE MISSING: dct:publisher or dc:publisher missing in rdf/xml</xsl:message>
                    </xsl:otherwise>
                    </xsl:choose>
                
                <!-- contributor currently not included in DataCite metadata -->
                
                <!-- publicationYear - REQUIRED -->
                <xsl:choose>
                    <xsl:when test="$description/dct:issued">
                        <publicationYear>
                            <xsl:value-of select="$description/dct:issued"/>
                        </publicationYear>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>REQUIRED VALUE MISSING: dct:issued missing in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- resourceType - REQUIRED -->
                <xsl:choose>
                    <xsl:when test="$description/schema:disambiguatingDescription">
                        <resourceType>
                            <xsl:attribute name="resourceTypeGeneral">
                                <xsl:value-of select="'Dataset'"/>
                            </xsl:attribute>
                            <!-- subject to change -->
                            <xsl:value-of select="$description/schema:disambiguatingDescription"/>
                        </resourceType>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>REQUIRED VALUE MISSING: schema:disambiguatingDescription missing in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>                
                
                <!-- language -->
                <!-- if there is more than one dc:language element AND neither are english, omit for now -->
                <xsl:choose>
                    <!-- more than one language -->
                    <xsl:when test="count($description/dc:language) > 1">
                        <xsl:choose>
                            <!-- check if this will work - always just one en? -->
                            <xsl:when test="starts-with(lower-case($description/dc:language), 'en')">
                                <language>
                                    <xsl:value-of select="$description/dc:language"/>
                                </language>
                            </xsl:when>
                            <!-- multiple languages, none english -->
                            <xsl:otherwise>
                                <xsl:message>Unable to determine primary language, no language element added.</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- one language -->
                    <xsl:when test="count($description/dc:language) = 1">
                        <language>
                            <xsl:value-of select="$description/dc:language"/>
                        </language>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>no dc:language in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- relatedIdentifiers -->
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
                    <xsl:otherwise>no dct:source in rdf/xml</xsl:otherwise>
                </xsl:choose>
                
                <!-- rightsList -->
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
                        <xsl:message>no dct:license in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- description -->
                <xsl:choose>
                    <!-- there should always be at least one dct:description -->
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
                                        <!-- if skos:ConceptScheme, type is TechnicalInfo -->
                                        <xsl:when
                                            test="$description/rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme'">
                                            <xsl:attribute name="descriptionType"
                                                >TechnicalInfo</xsl:attribute>
                                        </xsl:when>
                                        <!-- else it is Other -->
                                        <xsl:otherwise>
                                            <xsl:attribute name="descriptionType"
                                                >Other</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="."/>
                                </description>
                            </xsl:for-each>
                            <!-- description from skos:scopeNote -->
                            <xsl:if test="$description/skos:scopeNote">
                                <xsl:for-each select="$description/skos:scopeNote">
                                    <description>
                                        <xsl:if test=".[@xml:lang]">
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="./@xml:lang"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <!-- if skos:ConceptScheme, type is TechnicalInfo -->
                                        <xsl:choose>
                                            <xsl:when
                                                test="$description/rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#ConceptScheme'">
                                                <xsl:attribute name="descriptionType"
                                                  >TechnicalInfo</xsl:attribute>
                                            </xsl:when>
                                            <!-- else it is Other -->
                                            <xsl:otherwise>
                                                <xsl:attribute name="descriptionType"
                                                    >Other</xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:value-of select="."/>
                                    </description>
                                </xsl:for-each>
                            </xsl:if>
                        </descriptions>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>no dct:description in rdf/xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </resource>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="dct:creator">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:variable name="agent" select="$agents/agents/agent[schema:sameAs/@rdf:resource = $uri]"
        />
        <creator xmlns="http://datacite.org/schema/kernel-4">
            <creatorName>
                <xsl:value-of select="$agent/schema:name"/>
            </creatorName>
        </creator>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:variable name="name" select="."/>
        <xsl:if test="not(document('../xml/agents.xml')/agents/agent[schema:name = $name])">
            <creator xmlns="http://datacite.org/schema/kernel-4">
                <creatorName>
                    <xsl:value-of select="$name"/>
                </creatorName>
            </creator>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dct:publisher">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:variable name="agent"
            select="document('../xml/agents.xml')/agents/agent[schema:sameAs[@rdf:resource = $uri]]"
        />
        <publisher xmlns="http://datacite.org/schema/kernel-4">
            <xsl:value-of select="$agent/schema:name"/>
        </publisher>
    </xsl:template>
    <xsl:template match="dc:publisher">
        <xsl:variable name="name" select="."/>
        <xsl:if test="not(document('../xml/agents.xml')/agents/agent[schema:name = $name])">
            <publisher xmlns="http://datacite.org/schema/kernel-4">
                <xsl:value-of select="$name"/>
            </publisher>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
