#requires -Version 2.0
Import-Module Get-CallerPreference
Import-Module Join-Paths

<#
.SYNOPSIS
    Confirms if a path is a valid item.
.DESCRIPTION
    This method will confirm the path can resolve and the file can be read
    from. After running this function, it is safe to manipulate the returned
    path.
.PARAMETER Paths
    Mandatory.
    Accepts Pipeline Input.

    The path fragments to join into a full path to test. This path will be
    automatically resolved into a full path.
.PARAMETER IsDirectory
    Cannot be set with -IsXml.

    If set, ensures the path is a directory. Otherwise, assumes the path is a
    file.
.PARAMETER IsXml
    Cannot be set with -IsDirectory.

    If set, ensures the path is a valid XML file.
.EXAMPLE
    Confirm-Path -Path File.txt

    Checks that a file exists in the current directory called "File.txt", and
    that it can be read.
.EXAMPLE
    Confirm-Path -Path Temp -IsDirectory

    Checks that a folder exists in the current directory called "Temp".
.OUTPUTS
    The resolved path that is tested. An exception is thrown if confirmation
    fails.
.LINK
    Resolve-Path
#>
function Confirm-Path {
    [OutputType([string])]
    [CmdletBinding(DefaultParameterSetName = "File")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]] $Paths,

        [Parameter(ParameterSetName = "Directory")]
        [switch] $IsDirectory,

        [Parameter(ParameterSetName = "File")]
        [switch] $IsXml
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    process {
        if ($null -ne $Paths) {
            foreach ($fragment in $Paths) {
                if ($null -eq $path) {
                    $path = $fragment
                }
                else {
                    $path = Join-Path $path $fragment
                }
            }
        }
    }
    end {
        if ($null -eq $path) {
            throw "No path given"
        }
        try {
            $path = Resolve-Path -Path $path -ErrorAction Stop
        }
        catch {
            throw "Cannot resolve path $($path):`n$($_.Exception)"
        }

        if ($IsDirectory) {
            if (-not (Test-Path -LiteralPath $path -PathType Container)) {
                throw "Directory does not exist: $path"
            }
        }
        else {
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
                throw "File does not exist: $path"
            }

            try {
                [string] $output = Get-Content -LiteralPath $path
            }
            catch {
                throw "File cannot be read from $($path):`n$($_.Exception)"
            }

            if ($IsXml) {
                try {
                    [xml] $output > $null
                }
                catch {
                    throw "File is not a valid XML File $($path):`n$($_.Exception)"
                }
            }
        }
        return $path
    }
}
Export-ModuleMember -Function Confirm-Path
