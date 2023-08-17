<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- these templates match on creator and publisher names -->
    <!-- and provide additonal information required by schema.org markup -->
    <!-- if using a creator or publisher not already listed here -->
    <!-- create a new xsl:when element within the match template and add the required information -->
    <xsl:template match="datacite:creatorName">{<xsl:choose>
            <xsl:when test="lower-case(text()) = 'university of washington libraries'">
            "@type" : "Organization",
            "@id" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
            "name" : "University of Washington Libraries" , 
            "url" : "https://www.lib.washington.edu" ,
            "sameAs" : [ "http://viaf.org/viaf/139541794" , "http://www.wikidata.org/entity/Q7896575" ] 
           } ,</xsl:when>
            <!-- add more matches when relevant -->
        <xsl:otherwise>
            "@type" : "<xsl:choose>
                <xsl:when test="./@nameType">
                    <xsl:value-of select="./@nameType"/>
                </xsl:when><xsl:otherwise>
                VALUE NOT FOUND
                </xsl:otherwise>
            </xsl:choose>" , 
            "@id" : "" ,
            "name" : "<xsl:value-of select="."/>" , 
            "url" : "" , 
            "sameAs" : ""
           } ,</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="datacite:publisher">{<xsl:choose>
        <xsl:when test="lower-case(text()) = 'university of washington libraries'">
            "@type" : "Organization" , 
            "@id" : "https://doi.org/10.6069/uwlib.55.A.3.6#UniversityofWashingtonLibraries" ,
            "name" : "University of Washington Libraries" , 
            "url" : "https://www.lib.washington.edu" , 
            "sameAs" : [ "http://viaf.org/viaf/139541794" , "http://www.wikidata.org/entity/Q7896575" ] 
           } ,</xsl:when>
            <!-- add more matches when relevant -->
        <xsl:otherwise>
             "@type" : "<xsl:value-of select="./@nameType"/>" , 
             "@id" : "" ,
             "name" : "<xsl:value-of select="."/>" , 
             "url" : "" , 
             "sameAs" : ""
         } ,</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>