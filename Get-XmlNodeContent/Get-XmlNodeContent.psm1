#requires -Version 2.0

<#
.SYNOPSIS
    Returns the contents of an Xml node, even if it is possibly a string or
    node.
.DESCRIPTION
    Accessing XML Nodes in Powershell can return either a string or another
    XML node, depending on if the node has wrapped its contents in a CDATA tag.
#>
function Get-XmlNodeContent {
    param (
        [Parameter(Mandatory = $true)]
        $Node
    )

    if ($Node -is [string]) {
        return $Node
    } elseif ($Node -is [Xml.XmlElement]) {
        return $Node.InnerText
    }

    throw "Node is not an xml element"
}
Export-ModuleMember -Function Get-XmlNodeContent
