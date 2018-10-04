#requires -Version 4.0

function Tee-Stream {
    param (
        [ValidateSet("Output", "Error", "Warning", "Verbose", "Debug", "Information")]
        [string[]] $OutputStreams,

        [Parameter(ValueFromPipeline = $true)]
        [array] $InputArray
    )
    process {
        foreach ($obj in $InputArray) {
            if ("Output" -in $OutputStreams) {
                Write-output $obj
            }
            if ("Error" -in $OutputStreams) {
                Write-Error $obj
            }
            if ("Warning" -in $OutputStreams) {
                Write-Warning $obj
            }
            if ("Verbose" -in $OutputStreams) {
                Write-Verbose $obj
            }
            if ("Debug" -in $OutputStreams) {
                Write-Debug $obj
            }
            if ("Information" -in $OutputStreams) {
                Write-Information $obj
            }
        }
    }
}
Export-ModuleMember -Function Tee-Stream
