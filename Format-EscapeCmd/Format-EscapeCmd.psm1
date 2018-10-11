#requires -Version 2.0
Import-Module Get-CallerPreference

<#
.SYNOPSIS
    Formats a string for cmd.exe argument passing.
.DESCRIPTION
    Inputs passed to environments that do their own parsing on input, such as
    cmd.exe or other shells, require that arguments need special handing if
    they contain escaping constructs.
.PARAMETER In
    Mandatory.
    Accepts Pipeline Input.

    String(s) to be formatted for escaping.
.EXAMPLE
    Format-EscapeCmd -In 'value "with quotes"'

    Returns: "value \"with quotes\""
.OUTPUTS
    A collection of escaped string(s)
#>
function Format-EscapeCmd {
    [OutputType([string[]])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNull()]
        [string[]] $In
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $output = @()
    }
    process {
        foreach ($segment in $In) {
            if (-not $segment.Contains(' ') -and -not $segment.Contains('"')) {
                $output += $segment
                continue
            }
            $output += ('"' + $segment.Replace('\', '\\').Replace('"', '\"') + '"')
        }
    }
    end {
        return $output
    }
}
Export-ModuleMember -Function Format-EscapeCmd
