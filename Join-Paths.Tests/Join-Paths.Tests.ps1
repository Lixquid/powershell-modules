. ..\Testing-Toolchain-Setup.ps1
Import-Module ..\Join-Paths -Force

Describe "Join-Paths" {
    It "Given a single argument, returns the fragment" {
        Join-Paths -Paths "file.xml" | Should -Be "file.xml"
    }
    It "Given two arguments, returns a path" {
        Join-Paths -Paths parent, file.xml | Should -Be `
        (Join-Path parent file.xml)
    }
    It "Given three arguments, returns a path" {
        Join-Paths -Paths top, middle, bottom.xml | Should -Be `
        (Join-Path (Join-Path top middle) bottom.xml)
    }
    It "Given parameter input, returns a path" {
        Join-Paths top middle bottom.xml | Should -Be `
        (Join-Path (Join-Path top middle) bottom.xml)
    }
    It "Given pipeline input, returns a path" {
        "top", "middle", "bottom.xml" | Join-Paths | Should -Be `
        (Join-Path (Join-Path top middle) bottom.xml)
    }
}
