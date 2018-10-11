#requires -Version 4.0
Import-Module Get-CallerPreference
Import-Module Confirm-Path

<#
.SYNOPSIS
    Validates XML files against an XSD Schema.
.PARAMETER SchemaPath
    Mandatory.

    The path to the XSD Schema to apply to documents.
.PARAMETER DocumentPath
    Mandatory.
    Accepts Pipeline Input

    The path to the XML Document(s) to validate against the schema.
.OUTPUTS
    None. The function will throw an exception if a validation error occurs.
#>
function Confirm-Xml {
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $SchemaPath,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]] $DocumentPath
    )
    begin {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $SchemaPath = Confirm-Path $SchemaPath -IsXml -PassThru
        try {
            $schemaReader = New-Object System.Xml.XmlTextReader $SchemaPath
            $schema = [Xml.Schema.XmlSchema]::Read($schemaReader, {
                param($sender, $eventArgs)
                throw $eventArgs.Message
            })
        } finally {
            if ($schemaReader) {
                $schemaReader.Close()
            }
        }
    }
    process {
        foreach ($doc in $DocumentPath) {
            $doc = Confirm-Path $doc -IsXml -PassThru

            [xml] $xml = New-Object System.Xml.XmlDocument
            $xml.Schemas.Add($schema)
            $xml.Load($doc)
            $xml.Validate({
                param($sender, $eventArgs)
                throw $eventArgs.Message
            })
        }
    }
}
Export-ModuleMember -Function Confirm-Xml
