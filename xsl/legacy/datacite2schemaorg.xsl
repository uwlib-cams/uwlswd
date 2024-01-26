<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:schema="https://schema.org/"
    xmlns:datacite="http://datacite.org/schema/kernel-4" version="3.0">
    <xsl:strip-space elements="*"/>
    
    <!-- template for producing the json schema.org markup based on DataCite metadata -->
    
    <!-- NOTE: This script uses DataCite metadata to generate the Schema.org data.
            Once all resources meet our current guidelines, this script will not be neccessary,
            as Schema.org data will be able to be produced directly from the RDF/XML 
            using rdf2htmlrdfa.xsl and rdf2schemaorg.xsl -->
    
    <!-- NOTE: indentation is weird within this template and hierarchy of elements is not always clear -->
    <!-- this is to produce proper indentation within the output file -->
    <xsl:template name="schemaorgMarkup"> 
        <xsl:param name="metadata_file_name"/>
        <xsl:param name="version"/> <!-- version from RDF/XML -->
        
        <xsl:variable name="metadata_file" select="document($metadata_file_name)"/>
        {
        "@context" : "http://schema.org" ,
        "@type" : "Dataset" , 
        "@id" : "<xsl:value-of select="lower-case(concat('https://doi.org/', $metadata_file/datacite:resource/datacite:identifier[@identifierType = 'DOI']))"/>" , 
        "name" : "<xsl:value-of select="normalize-space($metadata_file/datacite:resource/datacite:titles/datacite:title[not(@titleType)])"/>" ,
        <xsl:choose><xsl:when test="count($metadata_file/datacite:resource/datacite:titles/datacite:title[@titleType = 'AlternativeTitle']) = 1"> 
        "alternateName" : "<xsl:value-of select="$metadata_file/datacite:resource/datacite:titles/datacite:title[@titleType = 'AlternativeTitle']"
            />" ,</xsl:when>
            <xsl:when test="count($metadata_file/datacite:resource/datacite:titles/datacite:title[@titleType = 'AlternativeTitle']) gt 1">
        "alternateName" : [ <xsl:for-each select="$metadata_file/datacite:resource/datacite:titles/datacite:title[@titleType = 'AlternativeTitle']">
                    <xsl:choose><xsl:when test="position() = last()"> <!-- add comma except for last in list -->
            "<xsl:value-of select="."/>"
            ] , </xsl:when> <xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose><xsl:when
            test="count($metadata_file/datacite:resource/datacite:descriptions/datacite:description) gt 1">
        "description" : [ <xsl:for-each select="$metadata_file/datacite:resource/datacite:descriptions/datacite:description">
            <xsl:choose><xsl:when test="position() = last()"> <!-- add comma except for last in list -->
            "<xsl:value-of select="."/>"
            ] , </xsl:when> <xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        </xsl:when>
            <xsl:when test="count($metadata_file/datacite:resource/datacite:descriptions/datacite:description) = 1"> 
        "description" : "<xsl:value-of select="$metadata_file/datacite:resource/datacite:descriptions/datacite:description"/>" , </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
        <xsl:choose><xsl:when
            test="count($metadata_file/datacite:resource/datacite:relatedIdentifiers/datacite:relatedIdentifier[@relationType = 'IsDerivedFrom']) gt 1">
        "isBasedOn" : [ <xsl:for-each select="$metadata_file/datacite:resource/datacite:relatedIdentifiers/datacite:relatedIdentifier[@relationType = 'IsDerivedFrom']">
                <xsl:choose><xsl:when test="position() = last()"> <!-- add comma except for last in list -->
            "<xsl:value-of select="."/>"
            ] , </xsl:when> <xsl:otherwise>
            "<xsl:value-of select="."/>" , </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:when>
            <xsl:when test="count($metadata_file/datacite:resource/datacite:relatedIdentifiers/datacite:relatedIdentifier[@relationType = 'IsDerivedFrom']) = 1"> 
        "isBasedOn" : "<xsl:value-of select="$metadata_file/datacite:resource/datacite:relatedIdentifiers/datacite:relatedIdentifier[@relationType = 'IsDerivedFrom']"/>" , </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="count($metadata_file/datacite:resource/datacite:creators/datacite:creator) = 1">
        "creator" : <xsl:apply-templates select="$metadata_file/datacite:resource/datacite:creators/datacite:creator/datacite:creatorName"/> , 
            </xsl:when>
            <xsl:otherwise>
        "creator" : [<xsl:for-each select="$metadata_file/datacite:resource/datacite:creators/datacite:creator/datacite:creatorName">
            <xsl:apply-templates select="."/><xsl:if test="not(position() = last())"> , </xsl:if> 
                </xsl:for-each>
            ] , </xsl:otherwise>
        </xsl:choose>
        "publisher" : <xsl:apply-templates select="$metadata_file/datacite:resource/datacite:publisher"/> , 
        "datePublished" : "<xsl:choose>
            <xsl:when test="$metadata_file/datacite:resource/datacite:publicationYear">
                <xsl:value-of select="$metadata_file/datacite:resource/datacite:publicationYear"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>",
        "inLanguage" : "<xsl:choose>
            <xsl:when test="$metadata_file/datacite:resource/datacite:language">
                <xsl:value-of select="$metadata_file/datacite:resource/datacite:language"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>",
        "license" : "<xsl:choose>
            <xsl:when test="$metadata_file/datacite:resource/datacite:rightsList/datacite:rights/@rightsURI">
                <xsl:value-of select="$metadata_file/datacite:resource/datacite:rightsList/datacite:rights/@rightsURI"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>",
        <xsl:choose>
            <xsl:when test="$version">
        "version" : "<xsl:value-of select="$version"/>" , <!-- version from rdf/xml -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: schema:version missing from rdf/xml</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
        "encodingFormat" : "text/html" <!-- this will ALWAYS be here, so we don't have to worry about trailing commas -->
        }
    </xsl:template>
    
    <xsl:template match="datacite:creatorName">
        <xsl:variable name="name" select="."/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:choose>
            <xsl:when test="$agents/agents/agent[schema:name = $name]">
            {
            "@id" : "<xsl:value-of select="$agents/agents/agent[schema:name = $name]/schema:sameAs/@rdf:resource"/>", 
            "name" : "<xsl:value-of select="."/>" ,  
            "sameAs" : "<xsl:value-of select="$agents/agents/agent[schema:name = $name]/schema:sameAs/@rdf:resource"/>" 
            }</xsl:when>
            <xsl:otherwise>
            {
            "name" : "<xsl:value-of select="."/>"
            }</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="datacite:publisher">
        <xsl:variable name="name" select="."/>
        <xsl:variable name="agents" select="document('../xml/agents.xml')"/>
        <xsl:choose>
            <xsl:when test="$agents/agents/agent[schema:name = $name] and $agents/agents/agent[schema:name = $name]/schema:sameAs">
                {
                "@id" : "<xsl:value-of select="$agents/agents/agent[schema:name = $name]/schema:sameAs/@rdf:resource"/>", 
                "name" : "<xsl:value-of select="."/>" ,  
                "sameAs" : "<xsl:value-of select="$agents/agents/agent[schema:name = $name]/schema:sameAs/@rdf:resource"/>" 
                }</xsl:when>
            <xsl:otherwise>
                {
                "name" : "<xsl:value-of select="."/>"
                }</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
