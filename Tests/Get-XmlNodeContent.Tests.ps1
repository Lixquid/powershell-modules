. .\_Setup.ps1
Import-Module Get-XmlNodeContent -Force

Describe "Get-XmlNodeContent" {
    BeforeEach {
        [xml] $xml = @"
            <root>
                <cdata><![CDATA[cdata content]]></cdata>
                <text>textcontent</text>
            </root>
"@
    }

    It "Given a string node, returns text" {
        Get-XmlNodeContent $xml.root.text | Should -Be textcontent
    }
    It "Given an xml node, returns text" {
        $xml.root.cdata | Should -Not -Be "cdata content"
        Get-XmlNodeContent $xml.root.cdata | Should -Be "cdata content"
    }
}
