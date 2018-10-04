. .\_Setup.ps1
Import-Module Invoke-XmlTransform -Force

Describe "Invoke-XmlTransform" {
    $transformXml = @"
        <root xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
            <a xdt:Transform="Replace">Changed</a>
            <b xdt:Transform="Remove"></b>
            <c>
                <added xdt:Transform="Insert">InnerText</added>
            </c>
        </root>
"@

    BeforeEach {
        New-Item TestDrive:\doc.xml -Value @"
            <root>
                <a>CHANGEME</a>
                <b>DELETEME</b>
                <c></c>
            </root>
"@

        New-Item TestDrive:\transform.xml -Value $transformXml
    }
    AfterEach {
        Remove-Item TestDrive:\doc.xml
        Remove-Item TestDrive:\transform.xml
    }

    It "Given document and transform path, transforms the document" {
        $doc = Invoke-XmlTransform -DocumentPath (Join-Path $TestDrive doc.xml) -TransformPath (Join-Path $TestDrive transform.xml)
        $doc.root | Should -Not -BeNullOrEmpty
        $doc.root.a | Should -Be Changed
        $doc.root.b | Should -BeNullOrEmpty
        $doc.root.c.added | Should -Be InnerText
    }
    It "Given document and transform, transforms the document" {
        $doc = Invoke-XmlTransform -DocumentPath (Join-Path $TestDrive doc.xml) -Transform $transformXml
        $doc.root | Should -Not -BeNullOrEmpty
        $doc.root.a | Should -Be Changed
        $doc.root.b | Should -BeNullOrEmpty
        $doc.root.c.added | Should -Be InnerText
    }
}
