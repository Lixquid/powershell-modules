#requires -Version 2.0

<#
.SYNOPSIS
    Returns the contents of an Xml node, even if it is possibly a string or
    node.
.DESCRIPTION
    Accessing XML Nodes in Powershell can return either a string or another
    XML node, depending on if the node has wrapped its contents in a CDATA tag.
.PARAMETER Node
    Mandatory.

    The node to extract text content from.
.PARAMETER PreserveWhitespace
    If set, the node's contents will not be trimmed before being output.
#>
function Get-XmlNodeContent {
    param (
        [Parameter(Mandatory = $true)]
        $Node,

        [switch] $PreserveWhitespace
    )

    if ($Node -is [string]) {
        $output = $Node
    } elseif ($Node -is [Xml.XmlElement]) {
        $output = $Node.InnerText
    } else {
        throw "Node is not an xml element"
    }

    if ($PreserveWhitespace) {
        return $output
    } else {
        return $output.Trim() -replace "\s+", " "
    }
}
Export-ModuleMember -Function Get-XmlNodeContent
