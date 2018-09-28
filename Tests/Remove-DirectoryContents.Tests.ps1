. .\_Setup.ps1
Import-Module Remove-DirectoryContents -Force

Describe "Remove-DirectoryContents" {
    function setup {
        New-Item TestDrive:\container -ItemType Directory
        New-Item TestDrive:\container\subfolder -ItemType Directory

        New-Item TestDrive:\container\topfile.txt -ItemType File
        New-Item TestDrive:\container\subfolder\subfile.txt -ItemType File
    }

    It "Given a file path, removes the contents" {
        setup
        Remove-DirectoryContents TestDrive:\container
        Get-ChildItem TestDrive:\container | Should -HaveCount 0
        Remove-Item TestDrive:\container -Recurse
    }
    It "Given a file path and -AndRemoveParent, removes the entire folder" {
        setup
        Remove-DirectoryContents TestDrive:\container -AndRemoveParent
        Test-Path TestDrive:\container | Should -BeFalse
    }

    It "Given an invalid folder, excepts" {
        {Remove-DirectoryContents TestDrive:\invalid} | Should -Throw
    }
}
