<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:cci="http://iase.disa.mil/cci"
xmlns:ce="http://scap.nist.gov/schema/sp800-53/2.0" 
xmlns:controls="http://scap.nist.gov/schema/sp800-53/feed/2.0" 
>

<xsl:variable name="cci_items" select="document('../input/U_CCI_List.xml')/cci:cci_list/cci:cci_items" />

<xsl:key name="ccikey" match="cci:cci_item" use="cci:references/cci:reference[@title='NIST SP 800-53 Revision 4']/@index" />

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
			tr.controlstyle			 	{ border-bottom: 2px solid lightgray; }
			td.controlstyle 			{ font-size: 18pt; font-weight:bold; vertical-align: top; padding-top: 2em; }
			td.nowrap { white-space:nowrap; font-size: 12pt; vertical-align: top; }
			td.numcol { font-size: 12pt; vertical-align: top; width:10%; }
			td { padding: 3px; }
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
			<title>NIST 800-53 Analysis</title>
			<div class="title">
			Side-by-side Presentation of<br/>
			<i>NIST Special Publication 800-53 Revision 4</i><br/> and the <br/><i>DISA FSO Control Correlation Identifier (CCI) List</i>
			</div>
			<div class="intro">
			This table presents the security controls from NIST 800-53
			next to their form in the DISA FSO CCI list.
			This table is designed to foster conversation about how to use the
			security controls.  Topics include:
			<ul>
				<li>whether association with a control implies partial or complete satisfaction</li>
				<li>level of granularity needed by DoD</li>
				<li>how controls relate to writing both security
			functional requirements (expressed in Protection Profiles) and configuration
			requirements (expressed in STIGs) for commercial products.</li>  
			</ul>
			Appendix H of NIST 800-53 describes high-level intentions while
			this table is designed to facilitate coordination and implementation
			between organizations.
			</div>

			</head>
			<body>
				<table>
				<tr class="header">
				<th>NIST ID</th>
				<th>NIST Text</th>
				<th>CCI Identifiers and Text</th>
				</tr>
				<xsl:apply-templates select="//controls:control" />
				</table>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="controls:control">
		<!-- if the following statement has no number, join the rows -->
		<tr class="controlstyle">
		<td class="controlstyle"><xsl:value-of select="ce:number"/></td>
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
		<xsl:variable name="numbernodots"><xsl:value-of select="normalize-space(translate($num_for_statement,'.',' '))"/></xsl:variable>
		<!-- number then lowercase gets a space in between -->
		<xsl:variable name="numbertrans" select="replace($numbernodots, '([0-9])([a-z])','$1 $2')" />
		<!-- could do count(key('','') to do a rowspan here if needed to get in flat table) -->
		<tr class="statementstyle">
		<td class="nowrap">
			<xsl:value-of select="$num_for_statement"/> 
		</td>
		<xsl:choose>
			<xsl:when test="../../ce:statement">
				<td class="statementstyleindent"><xsl:value-of select="ce:description"/> </td>
			</xsl:when>
			<xsl:otherwise>
				<td class="statementstyle"><xsl:value-of select="ce:description"/> </td>
			</xsl:otherwise>
		</xsl:choose>
		<td><table>
			<xsl:call-template name="insert_cci">
				<xsl:with-param name="nist_id" select="$numbertrans" />
			</xsl:call-template>
		</table></td>
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

	<xsl:template name="insert_cci">
		<xsl:param name="nist_id" />
		<xsl:variable name="nist_id_txt"><xsl:value-of select="$nist_id" /></xsl:variable>
		<!-- an empty-foreach, just to change node context for key lookup -->
		<xsl:for-each select="$cci_items">
			<xsl:for-each select="key('ccikey', $nist_id_txt)">
				<xsl:variable name="matched_cci" select="."/>
				<xsl:variable name="disareftonist" select="$matched_cci/cci:references/cci:reference[@title='NIST SP 800-53 Revision 4']/@index" />
			<tr>
			<td class="nowrap">
			<xsl:value-of select="$disareftonist" /><br/>
			(<xsl:value-of select="$matched_cci/@id"/>)
			</td>
			<td>
			<xsl:value-of select="$matched_cci/cci:definition"/>
			</td>

			</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
