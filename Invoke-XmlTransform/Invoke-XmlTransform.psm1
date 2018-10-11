#requires -Version 4.0
Import-Module Get-CallerPreference
Import-Module Confirm-Path

<#
.SYNOPSIS
    Transforms an XML document using an XDT Document.
.PARAMETER DocumentPath
    Mandatory.

    The path to the document to be transformed.
.PARAMETER TransformPath
    Mandatory.
    Cannot be set with -Transform.

    The path to the XDT document to apply to the document.
.PARAMETER Transform
    Mandatory.
    Cannot be set with -TransformPath.

    The XDT document to apply to the document.
.PARAMETER XmlTransformDllPath
    The path to the Microsoft.Web.XmlTransform DLL used to apply transforms.
.EXAMPLE
    $document = Invoke-XmlTransform web.config debugsettings.xml

    Applies the transform in debugsettings.xml to web.config, then stores the
    result in $document.
.OUTPUTS
    The transformed document.
#>
function Invoke-XmlTransform {
    [OutputType([xml])]
    [CmdletBinding(DefaultParameterSetName = "Path")]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DocumentPath,

        [Parameter(Mandatory = $true, ParameterSetName = "Path")]
        [string] $TransformPath,

        [Parameter(Mandatory = $true, ParameterSetName = "Input")]
        [xml] $Transform,

        [string] $XmlTransformDllPath = (Join-Path $PSScriptRoot Microsoft.Web.XmlTransform.dll)
    )
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    $DocumentPath = Confirm-Path $DocumentPath -IsXml -PassThru
    if ($PSCmdlet.ParameterSetName -eq "Path") {
        $TransformPath = Confirm-Path $TransformPath -IsXml -PassThru
    }
    $XmlTransformDllPath = Confirm-Path $XmlTransformDllPath -PassThru

    Add-Type -Path $XmlTransformDllPath
    $doc = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument
    $doc.PreserveWhitespace = $true
    $doc.Load($DocumentPath)
    if ($PSCmdlet.ParameterSetName -eq "Path") {
        $transformObject = New-Object Microsoft.Web.XmlTransform.XmlTransformation $TransformPath, $null
    } else {
        $transformObject = New-Object Microsoft.Web.XmlTransform.XmlTransformation `
            $Transform.OuterXml, $false, $null
    }
    if (-not $transformObject.Apply($doc)) {
        Write-Error "Transform failed to apply" -ErrorAction Stop
    }

    return [xml] $doc
}
Export-ModuleMember -Function Invoke-XmlTransform
