#requires -Version 2.0
Import-Module Get-CallerPreference

<#
.SYNOPSIS
    Writes a structured log entry to a file.
.PARAMETER Message
    Accepts Pipeline Input.

    The message to write out.
.PARAMETER Severity
    Defaults to "INFO".
    Acceptable Values: "INFO", "WARN", "ERROR"

    The severity of the message to log.

    INFO messages output to verbose, WARN output to warning, ERROR output to
    error
#>
function Write-Log {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]] $Message = "",

        [ValidateSet("INFO", "WARN", "ERROR")]
        [string] $Severity = "INFO"
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Variables WriteLogOutput -IncludeDefault
    }
    process {
        foreach ($msg in $Message) {
            $private:path = if ($WriteLogOutput) {
                $WriteLogOutput
            } else {
                "LogOutput.txt"
            }

            Out-File `
                -FilePath $private:path `
                -Append `
                -InputObject "$(Get-Date -Format s) $Severity $Message" `
                -Confirm:$false

            switch ($Severity) {
                INFO { Write-Verbose "$($Severity): $Message" }
                WARN { Write-Warning "$($Severity): $Message" }
                ERROR { Write-Error "$($Severity): $Message" -ErrorAction Continue }
            }
        }
    }
}
Export-ModuleMember -Function Write-Log
