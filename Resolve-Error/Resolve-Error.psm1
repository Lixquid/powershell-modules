#requires -Version 2.0

<#
.SYNOPSIS
    Prints out the entire stacktrace of an Error Record.
.DESCRIPTION
    The output typically produced form an unhandled Error Record is typically
    not enough information; useful diagnostic information such as the
    invocation info and the inner exception(s) is hidden. Resolve-Error will
    pretty-print all of this information in an Error Record.
.PARAMETER ErrorRecord
    Mandatory.
    Accepts Pipeline Input.

    The Error Record(s) to process.
.EXAMPLE
    Resolve-Error $Error[0]

    Outputs the error information for the last error that has occurred.
.EXAMPLE
    try {
        # ...
    } catch {
        Write-Error (Resolve-Error $Error[0]) -ErrorAction Continue
    }

    Executes a block of code, printing the full stacktrace of any errors to the
    error output stream.
.OUTPUTS
    A pretty printed stacktrace of input Error Records as a string.
#>
function Resolve-Error {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNull()]
        [Management.Automation.ErrorRecord[]] $ErrorRecord
    )
    begin {
        $output = ""
    }
    process {
        foreach ($record in $ErrorRecord) {
            $output += "== Exception ==================================================================="
            $output += ($record | Format-List * -Force | Out-String) + "`n"
            $output += "== Invocation Info ==============================="
            $output += ($record.InvocationInfo | Format-List * | Out-String) + "`n"
            $exception = $record.Exception
            for ($i = 1; $exception; $i++, ($exception = $exception.InnerException)) {
                $output += "== Inner Exception $i ============================="
                $output += (($exception | Format-List * -Force | Out-String) -replace "`n", "`n    ") + "`n"
            }
        }
    }
    end {
        return $output
    }
}
Export-ModuleMember -Function Resolve-Error
