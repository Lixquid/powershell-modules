. .\_Setup.ps1
Import-Module Tee-Stream -Force -DisableNameChecking

Describe "Tee-Stream" {
    It "Given a single output stream, redirects to that stream" {
        "single" | Tee-Stream Error -ErrorAction SilentlyContinue -ErrorVariable output | Should -BeNullOrEmpty
        $output | Should -Be single
    }

    It "Given two output streams, outputs on both streams" {
        "double" | Tee-Stream Output, Error -ErrorAction SilentlyContinue -ErrorVariable output | Should -Be double
        $output | Should -Be double
    }
}
