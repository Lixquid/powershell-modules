function ImportDefault {
    [CmdletBinding()]
    param()
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    Write-Output $ErrorActionPreference
    Write-Output $CakePreference
}
function ImportCake {
    [CmdletBinding()]
    param()
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Variables CakePreference
    Write-Output $ErrorActionPreference
    Write-Output $CakePreference
}
function ImportAll {
    [CmdletBinding()]
    param()
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Variables CakePreference -IncludeDefault
    Write-Output $ErrorActionPreference
    Write-Output $CakePreference
}
function ImportPipe {
    [CmdletBinding()]
    param()
    "CakePreference" | Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    Write-Output $ErrorActionPreference
    Write-Output $CakePreference
}
Export-ModuleMember -Function *
