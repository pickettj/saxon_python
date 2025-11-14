<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>

    <!-- html superstructure -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Hamlet</title>
                <style type="text/css">
                    <!-- lg elements will be block-indented -->
                    .lg {
                        display: block;
                        margin-left: 1em;
                    }</style>
            </head>
            <body>
                <h1>Hamlet</h1>
                <xsl:apply-templates select="//body"/>
            </body>
        </html>
    </xsl:template>

    <!-- 
        Acts and scenes
        
        Acts and scenes are both output as <section> elements, and the only
        difference is that the <head> of an act is output as <h2>, while the
        <head> of a scene is output as <h3>.
        
        All children of acts and scenes are processed. For acts, that means
        the <head> and the scenes. For scenes it means speeches and stage
        directions. The instruction is the same though: process my children,
        whatever they might be.
    -->
    <xsl:template match="div">
        <section>
            <xsl:apply-templates/>
        </section>
    </xsl:template>
    <xsl:template match="body/div/head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="div/div/head">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <!-- speeches (except stage directions inside speeches, lines, etc.) -->
    <xsl:template match="sp">
        <!-- Speeches are output as blocks of text -->
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="speaker">
        <!-- Embold the speaker, follow with a colon, and start the text on the next line -->
        <strong>
            <xsl:apply-templates/>
            <xsl:text>: </xsl:text>
        </strong>
        <br/>
    </xsl:template>
    <xsl:template match="lg">
        <!-- 
            Line groups can't be <p> elements because HTML doesn’t permit nesting a <p>
            inside a <p>. Instead, make it a <span> (which is inline as far as HTML is
            concerned, so it can occur inside a <p>), and use CSS to block-indent the
            group, that is, to format it as if it were a block. The @class attribute on
            the <span> provides the hook for the CSS (see above).
        -->
        <span class="lg">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="l | ab">
        <!--
            Process the line, then, if it has a following sibling, add a line break (<br/>).
            The <xsl:if> ensures that we don’t output a <br/> after the last line of a 
            speech, since there’s nothing to break there.
        -->
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::*">
            <br/>
        </xsl:if>
    </xsl:template>

    <!-- stage directions -->
    <xsl:template match="div/stage">
        <!-- 
            stage children of scenes are paragraphs
            <xsl:next-match> lets us use the code from the next template without having
            to create a literal copy of it.
        -->
        <p>
            <xsl:next-match/>
        </p>
    </xsl:template>
    <xsl:template match="stage">
        <!-- stage children of lines, etc. are inline (no <p>) -->
        <em>
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </em>
    </xsl:template>
</xsl:stylesheet>
