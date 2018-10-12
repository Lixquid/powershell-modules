#requires -Version 2.0

function Tee-Stream {
    param (
        [ValidateSet("Output", "Error", "Warning", "Verbose", "Debug", "Information")]
        [string[]] $OutputStreams,

        [Parameter(ValueFromPipeline = $true)]
        [array] $InputArray
    )
    process {
        foreach ($obj in $InputArray) {
            if ($OutputStreams -contains "Output") {
                Write-Output $obj
            }
            if ($OutputStreams -contains "Error") {
                Write-Error $obj
            }
            if ($OutputStreams -contains "Warning") {
                Write-Warning $obj
            }
            if ($OutputStreams -contains "Verbose") {
                Write-Verbose $obj
            }
            if ($OutputStreams -contains "Debug") {
                Write-Debug $obj
            }
            if ($OutputStreams -contains "Information") {
                Write-Information $obj
            }
        }
    }
}
Export-ModuleMember -Function Tee-Stream
