<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:template match="/">
	<html>
		<head><title>Open-SIS Report for <xsl:value-of select="scaninformation/details/computername"/></title>
			<meta HTTP-EQUIV="expires" CONTENT="0" />
		</head>
	<body>

<img src="open-sis-logo.jpg" /><hr></hr>
  <h1>Open-SIS Report for <xsl:value-of select="scaninformation/details/computername"/></h1>
    <table border="1" cellpadding="0" cellspacing="0" >
    <tr><td bgcolor="#c0c0c0"><b>Computername:</b></td>
        <td><xsl:value-of select="scaninformation/details/computername"/></td></tr>
    <tr><td bgcolor="#c0c0c0"><b>Operating system</b></td>
        <td><xsl:value-of select="scaninformation/details/operatingsystem"/></td></tr>
    <tr><td bgcolor="#c0c0c0"><b>OS Version:</b></td>
        <td><xsl:value-of select="scaninformation/details/os-version"/></td></tr>
    <tr><td bgcolor="#c0c0c0"><b>OS Product-ID:</b></td>
        <td><xsl:value-of select="scaninformation/details/os-product-id"/></td></tr>
    <tr><td bgcolor="#c0c0c0"><b>OS Registered Organisation</b></td>
        <td><xsl:value-of select="scaninformation/details/os-reg-org"/></td></tr>
    <tr><td bgcolor="#c0c0c0"><b>OS Registered Owner:</b></td>
        <td><xsl:value-of select="scaninformation/details/os-reg-owner"/></td></tr>
        
    <tr><td bgcolor="#c0c0c0"><b>Acquisition timestamp:</b></td>
        <td><xsl:value-of select="scaninformation/details/open-sis-timestamp"/></td></tr>
    </table>
    <hr></hr>
    <h2>Installed applications</h2>
    <table border="1" cellpadding="0" cellspacing="0">
    <tr bgcolor="#c0c0c0">
      <th align="left">Application name</th>
      <th align="left">Version</th>
    </tr>

    <xsl:for-each select="scaninformation/software/application">
    <tr>
    	<td bgcolor="#80ff80" colspan="2"><sub><xsl:value-of select="hkey"/></sub></td>
    </tr>
    <tr>
      <td><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="version"/></td>
    </tr>
    
    </xsl:for-each>
    </table>
    <hr> </hr>
    <h2>Attached storage</h2>
    <table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr bgcolor="#c0c0c0">
      <th align="left">Interface</th>
      <th align="left">Vendor</th>
      <th align="left">Product</th>
    </tr>
    <xsl:for-each select="scaninformation/hardware/storage/device">
    <tr>
      <td><xsl:value-of select="interface"/></td>
      <td><xsl:value-of select="vendor"/></td>
      <td><xsl:value-of select="product"/></td>
    </tr>
    </xsl:for-each>
    </table>
    <hr></hr>
    <center><sub>(C) P.A. de Rijk - GPLv2 License - <a href="http://www.adslweb.net/tools/open-sis/" target="_blank">Open-SIS-Site</a></sub></center>
  </body>
  </html>
</xsl:template></xsl:stylesheet>
