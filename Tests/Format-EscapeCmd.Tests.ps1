. .\_Setup.ps1
Import-Module Format-EscapeCmd -Force

Describe "Format-EscapeCmd" {
    It "Given plain input, returns the same input" {
        Format-EscapeCmd plainstring | Should -Be plainstring
        Format-EscapeCmd 5 | Should -Be 5
    }
    It "Given input with spaces, wraps the input" {
        Format-EscapeCmd "a b" | Should -Be '"a b"'
        Format-EscapeCmd "1 2,3" | Should -Be '"1 2,3"'
    }
    It "Given input with quotes, escapes the quotes" {
        Format-EscapeCmd '"a"' | Should -Be '"\"a\""'
        Format-EscapeCmd '"a b"' | Should -Be '"\"a b\""'
    }
}
