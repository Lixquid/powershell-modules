#requires -Version 2.0

<#
.SYNOPSIS
    Joins multiple path fragments into a path string.
.DESCRIPTION
    The default Join-Path function only accepts two arguments to join
    together, and the .NET method System.IO.Path.Join has an inconsistent API
    across .NET Version. Join-Paths is a backwards-comparible to Powershell
    v2 function to join multiple path fragments together.
.PARAMETER Paths
    Mandatory.
    Accepts Pipeline Input.

    The path fragments to join together.
.EXAMPLE
    Join-Paths -Paths $Root,Directory,File.xml

    Assuming $Root is "C:\" and run on Windows, this will produce:
    "C:\Directory\File.xml"
.EXAMPLE
    Join-Paths $Root Directory File.xml

    Same as previous Example.
.EXAMPLE
    $Root, "Directory", "File.xml" | Join-Paths

    Same as previous Example.
.OUTPUTS
    A single path with all fragments joined together.
.LINK
    Join-Path
#>
function Join-Paths {
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]] $Paths
    )
    begin {
        $output = $null
    }
    process {
        if ($null -ne $Paths) {
            foreach ($path in $Paths) {
                if ($null -eq $output) {
                    $output = $path
                } else {
                    $output = Join-Path $output $path
                }
            }
        }
    }
    end {
        return $output
    }
}
Export-ModuleMember -Function Join-Paths
