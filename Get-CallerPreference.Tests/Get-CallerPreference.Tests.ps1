. ..\Testing-Toolchain-Setup.ps1
Import-Module ..\Get-CallerPreference -Force
Import-Module .\Get-CallerPreference.Tests.Util.psm1 -Force

Describe "Get-CallerPreference" {
    It "Given no parameters, imports the default Preference variables" {
        $ErrorActionPreference = "Stop"
        $CakePreference = "Chocolate"
        ImportDefault | Should -Be Stop, $null
    }

    It "Given a parameter to import, defers to switches" {
        $ErrorActionPreference = "Stop"
        ImportDefault -EA Continue | Should -Be Continue, $null
    }

    It "Given parameters, imports only the specified variables" {
        $ErrorActionPreference = "Stop"
        $CakePreference = "Chocolate"
        ImportCake | Should -Be Continue, Chocolate
    }

    It "Given parameters and -IncludeDefault, imports everything" {
        $ErrorActionPreference = "Stop"
        $CakePreference = "Chocolate"
        ImportAll | Should -Be Stop, Chocolate
    }

    It "Given pipeline input, imports only the specified variables" {
        $ErrorActionPreference = "Stop"
        $CakePreference = "Chocolate"
        ImportPipe | Should -Be Continue, Chocolate
    }
}
