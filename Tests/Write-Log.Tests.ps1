. .\_Setup.ps1
Import-Module Write-Log -Force

Describe "Write-Log" {
    BeforeEach {
        Push-Location
        Set-location TestDrive:\
    }
    AfterEach {
        Pop-Location
    }

    It "Given a message, outputs to a log file" {
        Write-Log "test"

        "LogOutput.txt" | Should -FileContentMatch test
    }
    It "Given a message and WARN, outputs to a log file" {
        Write-Log "test" -Severity WARN -WarningAction SilentlyContinue

        "LogOutput.txt" | Should -FileContentMatch test
        "LogOutput.txt" | Should -FileContentMatch WARN
    }
    It "Given a message and ERROR, outputs to a log file" {
        Write-Log "test" -Severity ERROR 2>$null

        "LogOutput.txt" | Should -FileContentMatch test
        "LogOutput.txt" | Should -FileContentMatch ERROR
    }
    It "Given a message and WriteLogOutput, outputs to the specified file" {
        $WriteLogOutput = "MyLog.txt"
        Write-Log "test"

        $WriteLogOutput | Should -FileContentMatch test
    }
}
