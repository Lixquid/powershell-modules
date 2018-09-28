#requires -Version 2.0
Import-Module Get-CallerPreference
Import-Module Confirm-Path

<#
.SYNOPSIS
    Removes all files and folders underneath a directory.
.DESCRIPTION
    Remove-Item with the -Recurse flag suffers from scheduling issues, and it is
    believed that this will not be fixed in the future. This function
    successfully removes a directory's contents by first removing all files,
    then removing all folders.
.PARAMETER Path
    Mandatory.
    Accepts Pipeline Input.

    The path(s) to remove the contents from.
.PARAMETER AndRemoveParent
    If set, the containing folder will also be removed.
.EXAMPLE
    Remove-DirectoryContents -Paths Test

    Removes all contents from the directory called "Test".
.OUTPUTS
    None.
.LINK
    Remove-item
#>
function Remove-DirectoryContents {
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]] $Paths,

        [switch] $AndRemoveParent
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    process {
        foreach ($path in $Paths) {
            $path = Confirm-Path $path -IsDirectory -PassThru
            # Filter on PSIsContainer for Powershell v2 compatability
            Get-Childitem $path -Recurse | Where-Object {
                -not $_.PSIsContainer
            } | Remove-Item -Force
            Get-ChildItem $path -Recurse | Where-Object { $_.PSIsContainer } | Remove-Item -Force -Recurse
            if ($AndRemoveParent) {
                Remove-Item $path
            }
        }
    }
}
Export-ModuleMember -Function Remove-DirectoryContents
