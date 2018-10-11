#requires -Version 2.0
Import-Module Get-CallerPreference
Import-Module Join-Paths

<#
.SYNOPSIS
    Confirms if a path is a valid item.
.DESCRIPTION
    This method will confirm the path can resolve and the file can be read
    from. After running this function, it is safe to manipulate the path.
.PARAMETER Path
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
    If -PassThru is set, the resolved path that is tested. Otherwise,
    nothing.
    An exception is thrown if confirmation fails.
.LINK
    Resolve-Path
#>
function Confirm-Path {
    [OutputType([Management.Automation.PathInfo])]
    [CmdletBinding(DefaultParameterSetName = "File")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNull()]
        [string[]] $Path,

        [Parameter(ParameterSetName = "Directory")]
        [switch] $IsDirectory,

        [Parameter(ParameterSetName = "File")]
        [switch] $IsXml,

        [switch] $PassThru
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    process {
        if ($null -ne $Path) {
            foreach ($fragment in $Path) {
                if ($null -eq $testpath) {
                    $testpath = $fragment
                } else {
                    $testpath = Join-Path $testpath $fragment
                }
            }
        }
    }
    end {
        if ($null -eq $testpath) {
            throw "No path given"
        }
        try {
            $testpath = Resolve-Path -Path $testpath -ErrorAction Stop
        } catch {
            throw "Cannot resolve path $($testpath):`n$($_.Exception)"
        }

        if ($IsDirectory) {
            if (-not (Test-Path -LiteralPath $testpath -PathType Container)) {
                throw "Directory does not exist: $testpath"
            }
        } else {
            if (-not (Test-Path -LiteralPath $testpath -PathType Leaf)) {
                throw "File does not exist: $testpath"
            }

            try {
                [string] $output = Get-Content -LiteralPath $testpath
            } catch {
                throw "File cannot be read from $($testpath):`n$($_.Exception)"
            }

            if ($IsXml) {
                try {
                    [xml] $output > $null
                } catch {
                    throw "File is not a valid XML File $($testpath):`n$($_.Exception)"
                }
            }
        }
        if ($PassThru) {
            return $testpath
        }
    }
}
Export-ModuleMember -Function Confirm-Path
