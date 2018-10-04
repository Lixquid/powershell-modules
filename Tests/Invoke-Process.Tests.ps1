. .\_Setup.ps1
Import-Module Invoke-Process -Force

Describe "Invoke-Process" {
    It "Given a process, returns standard input" {
        Invoke-Process powershell -Arguments "-Command", "echo 5" | Should -Be "5"
    }
    It "Given a process that returns non-zero, throws" {
        { Invoke-Process ipconfig -Arguments "/?" } | Should -Throw "exit code"
    }
    # TODO: Write more tests
}
