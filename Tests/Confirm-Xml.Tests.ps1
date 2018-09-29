. .\_Setup.ps1
Import-Module Confirm-Xml -Force

Describe "Confirm-Xml" {
    New-Item TestDrive:\valid.xml -Value @"
        <exampledoc>
            <number>5</number>
            <string>hello</string>
        </exampledoc>
"@
    New-Item TestDrive:\invalid.xml -Value @"
        <exampledoc>
            <number>notanumber</number>
            <string>hello</string>
        </exampledoc>
"@
    New-Item TestDrive:\schema.xml -Value @"
        <xs:schema
            elementFormDefault="unqualified"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
        >
            <xs:element name="exampledoc">
                <xs:complexType>
                    <xs:all>
                        <xs:element name="string" type="xs:string" />
                        <xs:element name="number" type="xs:int" />
                    </xs:all>
                </xs:complexType>
            </xs:element>
        </xs:schema>
"@

    It "Given a schema and file path, doesn't except" {
        Confirm-Xml (Join-Path $TestDrive schema.xml) (Join-Path $TestDrive valid.xml)
    }
    It "Given a schema and invalid file, throws validation exception" {
        {
            Confirm-Xml (Join-Path $TestDrive schema.xml) (Join-Path $TestDrive invalid.xml)
        } | Should -Throw "value 'notanumber' is invalid"
    }
}