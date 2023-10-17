<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:datacite="http://datacite.org/schema/kernel-4" xmlns:schema="https://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    <xsl:strip-space elements="*"/>
    <!-- template for producing the json schema.org markup based on rdf/xml -->
    <!-- NOTE: indentation is weird within this template and hierarchy of elements is not always clear -->
    <!-- this is to produce proper indentation within the output file -->
    <xsl:template name="rdf2schemaorg">
        <xsl:variable name="description"
            select="./rdf:RDF/rdf:Description[not(contains(@rdf:about, '#'))]"/> 
        { 
        "@context" : "http://schema.org" , 
        "@type" : "Dataset" , 
        "@id" : "<xsl:value-of select="$description/@rdf:about"/>", <!-- doi -->
        "name" : "<xsl:value-of select="$description/dct:title"/>" , 
        <xsl:choose><xsl:when test="count($description/dct:alternative) = 1"> 
        "alternateName" : "<xsl:value-of select="$description/dct:alternative"
            />" ,</xsl:when>
        <xsl:when test="count($description/dct:alternative) > 1">
        "alternateName" : [ <xsl:for-each select="$description/dct:alternative">
                <xsl:choose><xsl:when test="position() = last()"> <!-- add comma except for last in list -->
            "<xsl:value-of select="."/>"</xsl:when>
                    <xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            ] , 
        </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose>
            <xsl:when
                test="count($description/dct:description) = 1 and not($description/skos:scopeNote)">
        "description" : "<xsl:value-of select="$description/dct:description"/>" , <!-- one description -->
            </xsl:when>
            <xsl:when test="count($description/dct:description) > 1 and not($description/skos:scopeNote)">
        "description" : [<xsl:for-each select="$description/dct:description"> <!-- multiple descriptions -->
                    <xsl:choose><xsl:when test="position() = last()">
            "<xsl:value-of select="."/>"
            ] , </xsl:when><xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$description/dct:description and $description/skos:scopeNote">
        "description" : [<xsl:for-each select="$description/dct:description"> <!-- description(s) AND scopeNote(s) -->
            "<xsl:value-of select="."/>" , </xsl:for-each>
                <xsl:for-each select="$description/skos:scopeNote">
                    <xsl:choose><xsl:when test="position() = last()">
            "<xsl:value-of select="."/>"
            ] , </xsl:when><xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="count($description/dct:source) = 1">
        "isBasedOn" : "<xsl:value-of select="$description/dct:source/@rdf:resource"
            />" ,
        </xsl:if><xsl:if test="count($description/dct:source) gt 1">
        "isBasedOn" : [ <xsl:for-each select="$description/dct:source">
            <xsl:choose><xsl:when test="position() = last()">
            "<xsl:value-of select="./@rdf:resource"/>"
            ] , </xsl:when><xsl:otherwise>
            "<xsl:value-of select="./@rdf:resource"/>" , 
            </xsl:otherwise>   
            </xsl:choose>
        </xsl:for-each>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$description/dct:creator and not($description/dc:creator)">
                <xsl:choose>
                    <xsl:when test="count($description/dct:creator) = 1">
        "creator" : <xsl:apply-templates select="$description/dct:creator"/> ,        
                    </xsl:when>
                    <xsl:otherwise>
        "creator" : [<xsl:for-each select="$description/dct:creator">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if> 
        </xsl:for-each>
            ] , </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$description/dct:creator and $description/dc:creator">
        "creator" : [<xsl:for-each select="$description/dct:creator">
            <xsl:apply-templates select="."/> , 
        </xsl:for-each><xsl:for-each select="$description/dc:creator">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if>
        </xsl:for-each>
            ] , 
            </xsl:when>
            <xsl:when test="not($description/dct:creator) and $description/dc:creator">
                <xsl:choose>
                    <xsl:when test="count($description/dc:creator) = 1">
        "creator" : <xsl:apply-templates select="$description/dc:creator"/> ,       
                    </xsl:when>
                    <xsl:otherwise>
        "creator" : [<xsl:for-each select="$description/dc:creator">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if> 
        </xsl:for-each>
            ] , </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$description/dct:publisher">
                <xsl:apply-templates select="$description/dct:publisher"/>
            </xsl:when>
            <xsl:when test="$description/dc:publisher">
                <xsl:apply-templates select="$description/dc:publisher"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$description/dct:contributor and not($description/dc:contributor)">
                <xsl:choose>
                    <xsl:when test="count($description/dct:contributor) = 1">
        "contributor" : <xsl:apply-templates select="$description/dct:contributor"/> ,        
                    </xsl:when>
                    <xsl:otherwise>
        "contributor" : [<xsl:for-each select="$description/dct:contributor">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if> 
        </xsl:for-each>
            ] , </xsl:otherwise>
                </xsl:choose>
        </xsl:when>
            <xsl:when test="$description/dct:contributor and $description/dc:contributor">
        "contributor" : [<xsl:for-each select="$description/dct:contributor">
            <xsl:apply-templates select="."/> , 
        </xsl:for-each><xsl:for-each select="$description/dc:contributor">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if>
        </xsl:for-each>
            ] , 
            </xsl:when>
            <xsl:when test="not($description/dct:contributor) and $description/dc:contributor">
                <xsl:choose>
                    <xsl:when test="count($description/dc:contributor) = 1">
        "contributor" : <xsl:apply-templates select="$description/dc:contributor"/> ,       
                    </xsl:when>
                    <xsl:otherwise>
        "contributor" : [<xsl:for-each select="$description/dc:contributor">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if> 
        </xsl:for-each>
            ] , </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        "datePublished" : "<xsl:choose>
            <xsl:when test="$description/dct:issued">
                <xsl:value-of select="$description/dct:issued"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>", 
       <xsl:choose>
            <xsl:when test="count($description/dc:language) = 1">
        "inLanguage" : "<xsl:value-of select="$description/dc:language"/>" , </xsl:when>
            <xsl:when test="count($description/dc:language) > 1">
        "inLanguage" : [ <xsl:for-each select="$description/dc:language"><xsl:choose>
            <xsl:when test="position() = last()">
           "<xsl:value-of select="."/>"
           ] , </xsl:when><xsl:otherwise>
           "<xsl:value-of select="."/>" , </xsl:otherwise>
       </xsl:choose></xsl:for-each></xsl:when>
          <xsl:otherwise/>
        </xsl:choose> 
        "license" : "<xsl:choose>
            <xsl:when test="$description/dct:license">
                <xsl:value-of select="$description/dct:license/@rdf:resource"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>", 
        <xsl:choose>
            <xsl:when test="$description/schema:version">
        "version" : "<xsl:value-of select="$description/schema:version"/>" , 
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: schema:version missing from rdf/xml</xsl:message>
            </xsl:otherwise>
        </xsl:choose> 
        "distribution" : [
            { "@type" : "DataDownload" , 
              "url" : "<xsl:value-of
            select="$description/dct:hasFormat[contains(@rdf:resource, '.ttl')]/@rdf:resource"/>" ,
              "encodingFormat" : "text/turtle" 
            } , 
            { "@type" : "DataDownload" , 
              "url" : "<xsl:value-of
            select="$description/dct:hasFormat[contains(@rdf:resource, '.nt')]/@rdf:resource"/>" ,
              "encodingFormat" : "application/n-triples"  
            } , 
            { "@type" : "DataDownload" , 
              "url" : "<xsl:value-of
            select="$description/dct:hasFormat[contains(@rdf:resource, '.jsonld')]/@rdf:resource"
            />" ,
              "encodingFormat" : "application/ld+json" 
            } , 
            { "@type" : "DataDownload" , 
              "url" : "<xsl:value-of
            select="replace($description/dct:hasFormat[contains(@rdf:resource, '.ttl')]/@rdf:resource, '.ttl', '.rdf')"
        />" ,
              "encodingFormat" : "application/rdf+xml"  <!-- wrong encodingFormat -->
            } 
            ] , 
        "encodingFormat" : "text/html" <!-- this will ALWAYS be here, so we don't have to worry about trailing commas -->
        } 
    </xsl:template>
    <xsl:template match="dct:creator">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:variable name="agent" select="$agents/agents/agent[schema:sameAs/@rdf:resource = $uri]"
            />
            {
            "@id" : "<xsl:value-of select="$uri"/>", <xsl:if test="$agent/schema:name">
            "name" : "<xsl:value-of select="$agent/schema:name"/>" , </xsl:if> 
            "sameAs" : "<xsl:value-of select="$uri"/>" 
            }</xsl:template>
    
    <xsl:template match="dc:creator">
            {
            "name" : "<xsl:value-of select="."/>"
            }</xsl:template>
    
    <xsl:template match="dct:publisher">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:variable name="agent" select="$agents/agents/agent[schema:sameAs/@rdf:resource = $uri]"
            />
        "publisher" : {
            "@id" : "<xsl:value-of select="$uri"/>", <xsl:if test="$agent/schema:name">
            "name" : "<xsl:value-of select="$agent/schema:name"/>" ,  </xsl:if>
            "sameAs" : "<xsl:value-of select="$uri"/>"
            } , 
    </xsl:template>
    <xsl:template match="dc:publisher">
        "publisher" : {
            "name" : "<xsl:value-of select="."/>"
            } , 
    </xsl:template>
    
    <xsl:template match="dct:contributor">
        <xsl:variable name="uri" select="@rdf:resource"/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:variable name="agent" select="$agents/agents/agent[schema:sameAs/@rdf:resource = $uri]"
            />
            {
            "@id" : "<xsl:value-of select="$uri"/>", <xsl:if test="$agent/schema:name">
            "name" : "<xsl:value-of select="$agent/schema:name"/>" , </xsl:if>
            "sameAs" : "<xsl:value-of select="$uri"/>"
            }</xsl:template>
    
    <xsl:template match="dc:contributor">
            {
            "name" : "<xsl:value-of select="."/>"
            }</xsl:template>
    
</xsl:stylesheet>
