<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:ce="http://scap.nist.gov/schema/sp800-53/2.0" 
xmlns:controls="http://scap.nist.gov/schema/sp800-53/feed/2.0" 
>


	<xsl:template match="/">
		<html>
			<head>
			<style type="text/css">
			body { font-family: sans-serif; }
			table { border-collapse:collapse; }
			table.cciside { width:70%; }
			tr.header { border-top:2px solid #808080; border-bottom:1px solid #808080; font-size: 16pt; vertical-align: bottom; text-align:left; font-weight:bold}
			tr.controlenhancementstyle 	{  border-bottom: 1px solid lightgray; font-size: 16pt; vertical-align: bottom; }
			td.controlenhancementstyle 	{ padding-top: 2em; }
			tr.statementstyle			{ font-size: 12pt; vertical-align: top; } 
			td.statementstyle			{ border: none; padding-bottom: .5em; padding-right: 5em; } 
			td.statementstyleindent		{ border: none; padding-bottom: .5em; padding-right: 5em; padding-left:3em; } 
			td.statementstyleindent2		{ border: none; padding-bottom: .5em; padding-right: 5em; padding-left:6em; } 
			tr.controlstyle			 	{ border-bottom: 2px solid lightgray; }
			td.controlstyle 			{ font-size: 18pt; font-weight:bold; vertical-align: top; padding-top: 2em; }
			td.nowrap { white-space:nowrap; font-size: 12pt; vertical-align: top; }
			td.numcol { font-size: 12pt; vertical-align: top; width:10%; }
			td { padding: 3px; }
			a.numberlink { text-decoration: none; color: #000066; }
			div.title
			{ 
				text-align: center; font-size: xx-large; font-weight:bold;
				font-family: verdana,arial,sans-serif;
				<!--border-bottom: solid 1px gray; -->
				margin-left: 8%; margin-right: 8%; 
				padding-top: 1em;
				padding-bottom: 1em;
			}
			div.intro
			{ 
				text-align: left; font-size: normal; 
            	font-family: verdana,arial,sans-serif;
				margin-left: 12%; margin-right: 12%; 
				padding-top: 1em;
				padding-bottom: 2em;
			}

			</style>
			<title>Security Controls from NIST Special Publication 800-53</title>
			<div class="title">
			Security Controls from <br/><i>NIST Special Publication 800-53 Revision 4</i><br/>
			</div>
			<div class="intro">
			This document presents the security controls from <i>NIST Special Publication 800-53 revision 4,
			Security and Privacy Controls for Federal Information Systems and Organizations</i>.  It can be used
			to provide links to particular security control statements, facilitating comprehension of security
			control claims in related documents.  It is based on the XML-format version of SP 800-53 
			<a href="http://csrc.nist.gov/publications/PubsSPs.html">available from NIST</a>.
			</div>

			</head>
			<body>
				<table>
				<tr class="header">
				<th>Identifier</th>
				<th>Text</th>
				</tr>
				<xsl:apply-templates select="//controls:control" />
				</table>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="controls:control">
		<tr class="controlstyle">
		<td id="{ce:number}" class="controlstyle">
			<a href="#{ce:number}" class="numberlink"><xsl:value-of select="ce:number"/></a>
		</td>
		<td class="controlstyle">
		<xsl:value-of select="ce:family"/> :
		<xsl:value-of select="ce:title"/> 
		</td>
		<td></td>
		</tr>
		<xsl:apply-templates select="ce:statement" />
		<xsl:apply-templates select="ce:control-enhancements/ce:control-enhancement" />
	</xsl:template>	

	<xsl:template match="ce:statement">
		<!-- if parent is control-enhancement, grab number from there -->
		<xsl:variable name="num_for_statement">
			<xsl:choose>
				<xsl:when test="ce:number">
					<xsl:value-of select="ce:number"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../ce:number"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="statementstyle">
		<td id="{$num_for_statement}" class="nowrap">
			<a href="#{$num_for_statement}" class="numberlink"><xsl:value-of select="$num_for_statement"/></a>
		</td>
		<xsl:choose>
			<xsl:when test="../../../ce:statement and ../../ce:statement">
				<td class="statementstyleindent2"><xsl:value-of select="ce:description"/> </td>
			</xsl:when>
			<xsl:when test="../../ce:statement">
				<td class="statementstyleindent"><xsl:value-of select="ce:description"/> </td>
			</xsl:when>
			<xsl:otherwise>
				<td class="statementstyle"><xsl:value-of select="ce:description"/> </td>
			</xsl:otherwise>
		</xsl:choose>
		</tr>
		<xsl:apply-templates select="ce:statement" />
	</xsl:template>	

	<xsl:template match="ce:control-enhancement">
		<xsl:if test="ce:statement/ce:number">
			<xsl:message>Found a control enhancement whose child has a number:
				<xsl:value-of select="ce:statement/ce:number" />
			</xsl:message>
		</xsl:if>
		<tr class="controlenhancementstyle">
		<td></td>
		<td colspan="2" class="controlenhancementstyle"><xsl:value-of select="ce:title"/>
		</td>
		</tr>
		<xsl:apply-templates select="ce:statement" />
	</xsl:template>	

	
</xsl:stylesheet>
