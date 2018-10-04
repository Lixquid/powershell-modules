#requires -Version 2.0
Import-Module Get-CallerPreference
Import-Module Format-EscapeCmd

<#
.SYNOPSIS
    Invokes a process, returning its Standard Input and throwing on any
    output to Standard Error.
.PARAMETER ProcessName
    Mandatory.

    The process to start.
.PARAMETER Arguments
    The arguments to pass to the process when starting.
.PARAMETER StandardInput
    Accepts Pipeline Input.

    The standard input to pass to the process.
.PARAMETER IgnoreExitCode
    If set, Invoke-Process will not throw an exception if a non-zero exit code
    is returned.
.OUTPUTS
    The Standard Output of the process.

    If the process returns anything on Standard Error, it is thrown.
    If the process returns a non-zero exit code, an exception is thrown.
#>
function Invoke-Process {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProcessName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $Arguments = @(),

        [Parameter(ValueFromPipeline = $true)]
        [string[]] $StandardInput = @(),

        [switch] $IgnoreExitCode
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo.FileName = $ProcessName
        if ($Arguments) {
            $process.StartInfo.Arguments = foreach ($arg in $Arguments) {
                Format-EscapeCmd $arg
            }
        }
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardInput = $true
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.CreateNoWindow = $true
        $process.Start() > $null
    }
    process {
        foreach ($line in $StandardInput) {
            $process.StandardInput.WriteLine($line)
        }
    }
    end {
        $process.StandardInput.Close()
        while ($null -ne ($line = $process.StandardOutput.ReadLine())) {
            Write-Output $line
        }
        $process.WaitForExit()

        if ($process.StandardError.Peek() -gt -1) {
            throw $process.StandardError.ReadToEnd()
        }
        if ($process.ExitCode -ne 0 -and -not $IgnoreExitCode) {
            throw "Process returned non-zero exit code: $($process.ExitCode)"
        }
    }
}
Export-ModuleMember -Function Invoke-Process
