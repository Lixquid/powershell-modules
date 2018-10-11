#requires -Version 2.0
Import-Module Get-CallerPreference
Import-Module Confirm-Path
Import-Module Remove-DirectoryContents

<#
.SYNOPSIS
    Moves the contents of a directory to another directory.
.DESCRIPTION
    Items cannot be moved across volumes with Move-Item. This function
    replicates the behaviour by copying all of the directory's items, then
    deleting its contents.

    Note that this will update metadata such as CreatedOn time and other
    details.
.PARAMETER Path
    Mandatory.

    The path to the directory to move the contents from.
.PARAMETER Destination
    Mandatory.

    The path to the directory to move the contents to. If it doesn't exist,
    it will be created.
.PARAMETER PassThru
    If set, the function will return the path to the destination directory.
.EXAMPLE
    Move-DirectoryContents -Path From -Destination To

    Moves the contents of the folder "From" to the folder "To".
.OUTPUTS
    If -PassThru is set, path information to the destination directory.
    Otherwise, nothing.
.LINK
    Move-Item
#>
function Move-DirectoryContents {
    [OutputType([Management.Automation.PathInfo])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Destination,

        [switch] $PassThru
    )
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    Confirm-Path $Path -IsDirectory
    if ((Test-Path $Destination)) {
        Confirm-Path $Destination -IsDirectory
    } else {
        $output = New-Item -ItemType Directory -Path $Destination
    }

    Get-ChildItem $Path | Copy-Item -Destination $Destination -Recurse
    Remove-DirectoryContents $Path
    if ($PassThru) {
        return $output
    }
}
Export-ModuleMember -Function Move-DirectoryContents
