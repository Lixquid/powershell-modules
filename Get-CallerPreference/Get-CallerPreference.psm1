#requires -Version 2.0

# Adapted from https://gallery.technet.microsoft.com/scriptcenter/Inherit-Preference-82343b9d
# by David Wyatt

<#
.SYNOPSIS
    Imports a caller's Preference variables (ErrorActionPreference,
    OutputEncoding, etc.) into the executing scope.
.DESCRIPTION
    By default, Powershell functions do not import the Preference Variables of
    the functions calling them. If a calling function sets
    "ErrorActionPreference", this is not automatically set in your library
    function (unless explicitly set with -ErrorAction). This function will
    automatically import the given Preference variables, the list of built-in
    Powershell (as of Powershell v5) Preference variables, or both.
.PARAMETER Cmdlet
    Mandatory.

    The Powershell Cmdlet to import Preference variables into.
    This should usually be: $PSCmdlet
.PARAMETER SessionState
    Mandatory.

    The Powershell Execution Session State to import Preference variables from.
    This should usually be: $ExecutionContext.SessionState
.PARAMETER Variables
    Accepts Pipeline Input.

    The list of variables to import. If this is not specified, a default list of
    Preference variables will be imported.
.PARAMETER IncludeDefault
    If set, the default list of Preference variables will be imported in
    addition to the variables specified in -Variables.
.EXAMPLE
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Imports the default Preference variables from the executing scope into the
    current scope.
.EXAMPLE
    Get-CallerPreference -Cmdlet $PSCmdlet `
        -SessionState $ExecutionContext.SessionState `
        -Variables ErrorActionPreference,SomeOtherVariable

    Imports the values of "ErrorActionPreference" and "SomeOtherVariable" into
    the current scope.
.OUTPUTS
    None.
.LINK
    about_Preference_Variables
#>
function Get-CallerPreference {
    [CmdletBinding(DefaultParameterSetName = "None")]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_.GetType().FullName -ieq "System.Management.Automation.PSScriptCmdlet" } )]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [Management.Automation.SessionState] $SessionState,

        [Parameter(ParameterSetName = "Specific", ValueFromPipeline = $true, ValueFromRemainingArguments = $true, Mandatory = $true)]
        [string[]] $Variables,

        [Parameter(ParameterSetName = "Specific")]
        [switch] $IncludeDefault
    )
    begin {
        $variablesToImport = @{}
    }
    process {
        if ($null -ne $Variables) {
            foreach ($var in $Variables) {
                if ($variablesToImport.ContainsKey($var)) { continue }
                $variablesToImport[$var] = $null
            }
        }
    }
    end {
        if ($PSCmdlet.ParameterSetName -eq "None" -or $IncludeDefault) {
            $defaultVariables = @{
                ErrorView                     = $null
                FormatEnumerationLimit        = $null
                LogCommandHealthEvent         = $null
                LogCommandLifecycleEvent      = $null
                LogEngineHealthEvent          = $null
                LogEngineLifecycleEvent       = $null
                LogProviderLifecycleEvent     = $null
                LogProviderHealthEvent        = $null
                MaximumAliasCount             = $null
                MaximumDriveCount             = $null
                MaximumErrorCount             = $null
                MaximumFunctionCount          = $null
                MaximumHistoryCount           = $null
                MaximumVariableCount          = $null
                OFS                           = $null
                OutputEncoding                = $null
                ProgressPreference            = $null
                PSDefaultParameterValues      = $null
                PSEmailServer                 = $null
                PSModuleAutoLoadingPreference = $null
                PSSessionApplicationName      = $null
                PSSessionConfigurationName    = $null
                PSSessionOption               = $null

                # These preference variables can be overridden by switches
                ConfirmPreference             = "Confirm"
                VerbosePreference             = "Verbose"
                InformationPreference         = "InformationAction"
                WarningPreference             = "WarningAction"
                DebugPreference               = "Debug"
                ErrorActionPreference         = "ErrorAction"
                WhatIfPreference              = "WhatIf"
            }
            foreach ($var in $defaultVariables.GetEnumerator()) {
                if ($variablesToImport.ContainsKey($var.Key)) { continue }
                $variablesToImport.Add($var.Key, $var.Value)
            }
        }

        foreach ($var in $variablesToImport.GetEnumerator()) {
            # Don't autoset variables overridden by switches
            if ($null -ne $var.Value -and $Cmdlet.MyInvocation.BoundParameters.ContainsKey($var.Value)) {
                continue
            }
            # Set the variable from the cmdlet's session state
            $variable = $Cmdlet.SessionState.PSVariable.Get($var.Key)
            if ($null -eq $variable) { continue }
            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
        }
    }
}
Export-ModuleMember -Function Get-CallerPreference
