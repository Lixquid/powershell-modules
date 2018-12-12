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
    Cannot be set with -AndRemoveParent.

    The path(s) to remove the contents from.
.PARAMETER Exclude
    A list of paths to exclude from being removed.
.PARAMETER AndRemoveParent
    Cannot be set with -Exclude.

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
    [CmdletBinding(DefaultParameterSetName = "Exclude")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNull()]
        [string[]] $Path,

        [Parameter(ParameterSetName = "Exclude")]
        [string[]] $Exclude = @(),

        [Parameter(ParameterSetName = "AndRemoveParent")]
        [switch] $AndRemoveParent
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
    process {
        if ($null -eq $Path) {
            return
        }
        foreach ($subpath in $Path) {
            $subpath = Confirm-Path $subpath -IsDirectory -PassThru
            # Filter on PSIsContainer for Powershell v2 compatability
            Get-Childitem $subpath -Recurse | Where-Object {
                -not $_.PSIsContainer
            } | Remove-Item -Force -Exclude $Exclude
            Get-ChildItem $subpath -Recurse | Where-Object { $_.PSIsContainer } | Remove-Item -Force -Recurse -Exclude $Exclude
            if ($AndRemoveParent) {
                Remove-Item $subpath
            }
        }
    }
}
Export-ModuleMember -Function Remove-DirectoryContents
