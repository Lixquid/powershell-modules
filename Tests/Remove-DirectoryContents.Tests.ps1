. .\_Setup.ps1
Import-Module Remove-DirectoryContents -Force

Describe "Remove-DirectoryContents" {
    BeforeEach {
        New-Item TestDrive:\container -ItemType Directory
        New-Item TestDrive:\container\subfolder -ItemType Directory

        New-Item TestDrive:\container\topfile.txt -ItemType File
        New-Item TestDrive:\container\subfolder\subfile.txt -ItemType File
    }
    AfterEach {
        Remove-Item TestDrive:\container -Recurse -ErrorAction SilentlyContinue
    }

    It "Given a file path, removes the contents" {
        Remove-DirectoryContents TestDrive:\container
        Get-ChildItem TestDrive:\container | Should -HaveCount 0
    }
    It "Given a file path and -AndRemoveParent, removes the entire folder" {
        Remove-DirectoryContents TestDrive:\container -AndRemoveParent
        Test-Path TestDrive:\container | Should -BeFalse
    }

    It "Given a file path and -Exclude, removes everything except the excluded file" {
        Remove-DirectoryContents TestDrive:\container -Exclude "topfile.txt"
        Test-Path TestDrive:\container\subfolder | Should -BeFalse
        Test-Path TestDrive:\container\topfile.txt | Should -BeTrue
    }

    It "Given an invalid folder, excepts" {
        {Remove-DirectoryContents TestDrive:\invalid} | Should -Throw
    }
}
