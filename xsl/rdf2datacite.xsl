<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:schema="https://schema.org/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="description"
            select="rdf:RDF/rdf:Description[not(contains(@rdf:about, '#')) and starts-with(@rdf:about, 'https://doi.org')]"/>
        <xsl:result-document href="./DataCite/{substring-after($description/@rdf:about,
            'https://doi.org/10.6069/')}.xml">
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
               
                <!-- creators -->
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
                <!-- if there is more than one language element AND neither are english, omit for now -->
                <xsl:choose>
                    
                    <!-- dc:language -->
                    <xsl:when test="$description/dc:language and not($description/dct:language)"> 
                        <!-- more than one language -->
                        <xsl:choose>
                            <xsl:when test="count($description/dc:language) > 1">
                                <xsl:choose>
                                    <xsl:when test="$description/dc:language[starts-with(., 'en')]">
                                        <language>
                                            <xsl:value-of
                                                select="$description/dc:language[starts-with(., 'en')]"
                                            />
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
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    
                    <!-- dct:language  -->
                    <xsl:when test="$description/dct:language and not($description/dc:language)">
                        <!-- more than one language -->
                        <xsl:choose>
                            <xsl:when test="count($description/dct:language) > 1">
                                <xsl:choose>
                                    <xsl:when test="$description/dct:language[starts-with(., 'en')]">
                                        <language>
                                            <xsl:value-of
                                                select="$description/dct:language[starts-with(., 'en')]"
                                            />
                                        </language>
                                    </xsl:when>
                                    
                                    <!-- multiple languages, none english -->
                                    <xsl:otherwise>
                                        <xsl:message>Unable to determine primary language, no language element added.</xsl:message>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            
                            <!-- one language -->
                            <xsl:when test="count($description/dct:language) = 1">
                                <language>
                                    <xsl:value-of select="$description/dct:language"/>
                                </language>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    
                    <xsl:when test="not($description/dc:language) and not($description/dct:language)">
                        <xsl:message>no dc:language or dct:language in rdf/xml</xsl:message>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:message>language elements must be dc:language OR dct:language, not both.</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- format -->
                <formats>
                    <format>text/html</format>
                </formats>
                
                <!-- relatedIdentifiers -->
                <xsl:if test="$description/dct:source">
                    <relatedIdentifiers>
                        <xsl:for-each select="$description/dct:source">
                            <relatedIdentifier relatedIdentifierType="URL"
                                relationType="IsDerivedFrom">
                                <xsl:value-of select="./@rdf:resource"/>
                            </relatedIdentifier>
                        </xsl:for-each>
                    </relatedIdentifiers>
                </xsl:if>
                
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
        <xsl:choose>
            <xsl:when
                test="document('../xml/agents.xml')/agents/agent[schema:sameAs/@rdf:resource = $uri]">
                <xsl:variable name="agent"
                    select="document('../xml/agents.xml')/agents/agent[schema:sameAs/@rdf:resource = $uri]"/>
                <xsl:choose>
                    <xsl:when test="$agent/schema:name">
                        <creator xmlns="http://datacite.org/schema/kernel-4">
                            <creatorName>
                                <xsl:if test="$agent/schema:name/@xml:lang">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="$agent/schema:name/@xml:lang"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$agent/schema:name"/>
                            </creatorName>
                        </creator>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>WARNING: dct:creator schema:sameAs has no associated schema:name in agents.xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: dct:creator not found in agents.xml</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:variable name="name" select="."/>
        <xsl:choose>
            <xsl:when test="document('../xml/agents.xml')/agents/agent[schema:name = $name]">
                <xsl:variable name="agent"
                    select="document('../xml/agents.xml')/agents/agent[schema:name = $name]"/>
                <creator xmlns="http://datacite.org/schema/kernel-4">
                    <creatorName>
                        <xsl:if test="$agent/schema:name/@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="$agent/schema:name/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$agent/schema:name"/>
                    </creatorName>
                </creator>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: dc:creator not found in agents.xml, using dc:creator value from RDF/XML</xsl:message>
                <creator xmlns="http://datacite.org/schema/kernel-4">
                    <creatorName>
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </creatorName>
                </creator>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="dct:publisher">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:choose>
            <xsl:when
                test="document('../xml/agents.xml')/agents/agent[schema:sameAs/@rdf:resource = $uri]">
                <xsl:variable name="agent"
                    select="document('../xml/agents.xml')/agents/agent[schema:sameAs/@rdf:resource = $uri]"/>
                <xsl:choose>
                    <xsl:when test="$agent/schema:name">
                        <publisher xmlns="http://datacite.org/schema/kernel-4">
                            <xsl:if test="$agent/schema:name/@xml:lang">
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$agent/schema:name/@xml:lang"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$agent/schema:name"/>
                        </publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>WARNING: dct:publisher schema:sameAs has no associated schema:name in agents.xml</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: dct:publisher not found in agents.xml</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:publisher">
        <xsl:variable name="name" select="."/>
        <xsl:choose>
            <xsl:when test="document('../xml/agents.xml')/agents/agent[schema:name = $name]">
                <xsl:variable name="agent"
                    select="document('../xml/agents.xml')/agents/agent[schema:name = $name]"/>
                <publisher xmlns="http://datacite.org/schema/kernel-4">
                    <xsl:if test="$agent/schema:name/@xml:lang">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$agent/schema:name/@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$agent/schema:name"/>
                </publisher>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: dc:publisher not found in agents.xml, using dc:publisher value from RDF/XML</xsl:message>
                <publisher xmlns="http://datacite.org/schema/kernel-4">
                    <xsl:if test="@xml:lang">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$name"/>
                </publisher>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
