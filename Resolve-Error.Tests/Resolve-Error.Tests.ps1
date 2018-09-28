. ..\Testing-Toolchain-Setup.ps1
Import-Module ..\Resolve-Error -Force

Describe "Resolve-Error" {
    It "Given an Error Record, prints invocation info" {
        try {
            NonExistentFunction
        }
        catch {
            $e = Resolve-Error $Error[0]
            # Invocation Info
            $e | Should -BeLike "*Invocation Info*"
            $e | Should -Match "Line.*NonExistentFunction"
            $e | Should -Match "InvocationName.*NonExistentFunction"
            # Exception
            $e | Should -BeLike "*Inner Exception 1*"
            $e | Should -Match "ErrorRecord.*NonExistentFunction"
            $e | Should -Match "CommandName.*NonExistentFunction"
            $e | Should -Match "WasThrownFromThrowStatement.*False"
        }
    }
}
