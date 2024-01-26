<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:marc="http://www.loc.gov/MARC21/slim" version="2.0">

    <xsl:key name="letter" match="//marc:record/marc:datafield/marc:subfield"
        use="substring(., 1, 1)"/>

    <xsl:template match="marc:collection">
        <xsl:variable name="main-doc" select="."/>
        <HTML>
            <head>
                <title>Newspaper Genre List</title>
            </head>
            <body>
                <div name="#preface">
                    <p>The following list is an attempt to standardize terms used to designate
                        genres of newspapers. It includes terms denoting audience, type of creator,
                        type of distribution, content, etc. The intent is for these terms to provide
                        additional access in conjunction with authorized LC subject headings. </p>

                    <p>The original perspective and scope of the list reflected the types of papers
                        cataloged by members of the <a
                            href="https://urldefense.com/v3/__http://www.neh.gov/projects/usnp.html__;!!K-Hz7m0Vt54!n9LcPwmenybPYrTvz1yLoEdNGuLy77rXLG9DXq9OVxOSUpHvscLm7Iii4_RqRUKrgsIqb0ze$"
                                ><strong>United States Newspaper Program</strong></a>. The list may
                        be updated to be more inclusive and/or to eliminate harmful language. See
                        the UW Libraries' <a
                            href="https://www.lib.washington.edu/about/edi/critical-cataloging-and-archival-description"
                            >Critical Cataloging and Archival Description</a> for more
                        information.</p>

                    <p>The list is also expressed as linked open data. It is a SKOS vocabulary
                        available in multiple serializations (RDFa, Turtle, NTriples, RDF/XML,
                        JSON-LD); MARC-XML authority records are also available. The vocabulary IRI
                        is &#160;<a
                            href="https://urldefense.com/v3/__https://doi.org/10.6069/uwlib.55.d.5__;!!K-Hz7m0Vt54!n9LcPwmenybPYrTvz1yLoEdNGuLy77rXLG9DXq9OVxOSUpHvscLm7Iii4_RqRUKrgoaHSNOD$"
                            >https://doi.org/10.6069/uwlib.55.d.5</a>, which derefences to the RDFa
                        version. All other versions are available from that page.</p>

                    <p>The Library of Congress Network Development and MARC Standards Office has
                        assigned the MARC code "ngl" to the Newspaper Genre List. This code may be
                        used in subfield $2 (Source of term) in field 655 (Index
                        Term--Genre/Form).</p>

                    <p>Please submit questions and suggestions to:<br/>Jessica Albano, Editor, <i><a
                                href="mailto:jalbano@u.washington.edu"
                            >jalbano@u.washington.edu</a></i></p>

                    <h2>Newspaper Genre Terms<i><a href="mailto:jalbano@u.washington.edu"
                            ><br/></a></i></h2>


                    <p>
                        <xsl:for-each
                            select="'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'">
                            <a href="#{.}">
                                <xsl:if test="not(key('letter', ., $main-doc))">
                                    <xsl:attribute name="title">I go nowhere</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="."/> | </a>
                        </xsl:for-each>
                    </p>

                </div>

                <div name="#genreList">
                    <xsl:for-each-group
                        select="//marc:record/marc:datafield[@tag = '155' or @tag = '455']"
                        group-by="substring(marc:subfield, 1, 9)">
                        <xsl:sort select="current-grouping-key()" data-type="text" order="ascending"/>
                        <div id="{substring(current-grouping-key(), 1, 1)}">
                            <xsl:apply-templates select="current-group()"/>
                        </div>
                    </xsl:for-each-group>
                </div>
            </body>
        </HTML>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '155']">
        
        <xsl:for-each select="../marc:controlfield[@tag = '001']">
            <xsl:variable name="nglCode" select="."/>
        
        <p>
             <strong><xsl:value-of select="../marc:datafield[@tag = '155']/marc:subfield"/></strong>&#160;<a href="https://doi.org/10.6069/uwlib.55.d.5#{$nglCode}">[<xsl:value-of select="$nglCode"/>]</a>
        </p>
        </xsl:for-each>
        <xsl:for-each select="../marc:datafield[@tag = '260']">
            <p style="padding-left:15px;">USE <xsl:value-of select="marc:subfield"/></p>
        </xsl:for-each>

        <xsl:for-each select="../marc:datafield[@tag = '360']">
            <p style="padding-left:15px;">(<xsl:value-of select="marc:subfield"/>)</p>
        </xsl:for-each>

        <xsl:for-each select="../marc:datafield[@tag = '680']">
            <p style="padding-left:15px;">(<xsl:value-of select="marc:subfield"/>)</p>
        </xsl:for-each>

        <xsl:for-each select="../marc:datafield[@tag = '455']">
            <p style="padding-left:15px;"> UF <xsl:apply-templates select="." mode="associated"/>
            </p>
        </xsl:for-each>

        <xsl:for-each select="../marc:datafield[@tag = '555']">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = 'w']/text() = 'g'">
                    <p style="padding-left:15px;">BT <xsl:value-of
                            select="marc:subfield[@code = 'a']"/></p>
                </xsl:when>
                <xsl:when test="marc:subfield[@code = 'w']/text() = 'h'">
                    <p style="padding-left:15px;">NT <xsl:value-of
                            select="marc:subfield[@code = 'a']"/></p>
                </xsl:when>
                <xsl:otherwise>
                    <p style="padding-left:15px;">RT <xsl:value-of
                            select="marc:subfield[@code = 'a']"/></p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '455']">
        <p>
            <xsl:value-of select="marc:subfield"/>
        </p>
        <p style="padding-left:15px;"> USE <strong><xsl:apply-templates
                    select="../marc:datafield[@tag = '155']" mode="associated"/></strong>
        </p>
    </xsl:template>

    <xsl:template match="marc:datafield" mode="associated">
        <xsl:value-of select="marc:subfield"/>
    </xsl:template>

    <xsl:template match="marc:record"> </xsl:template>

    <xsl:template match="marc:leader"> </xsl:template>

    <xsl:template match="marc:controlfield"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '040']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '075']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '755']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '681']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '555']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '680']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '260']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '750']"> </xsl:template>

    <xsl:template match="marc:datafield[@tag = '360']"> </xsl:template>

</xsl:stylesheet>
