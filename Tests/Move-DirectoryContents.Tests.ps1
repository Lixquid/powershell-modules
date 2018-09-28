. .\_Setup.ps1
Import-Module Remove-DirectoryContents -Force
Import-Module Move-DirectoryContents -Force

Describe "Move-DirectoryContents" {
    function setup {
        New-Item TestDrive:\from -ItemType Directory

        New-Item TestDrive:\from\a.txt -ItemType File -Value a
        New-Item TestDrive:\from\b.txt -ItemType File -Value b
        New-Item TestDrive:\from\subdir -ItemType Directory
        New-item TestDrive:\from\subdir\sub.txt -ItemType File -Value c
    }
    function teardown {
        Remove-DirectoryContents TestDrive:\from TestDrive:\to -AndRemoveParent
    }

    It "Given two paths, the directory's contents will be moved and nothing returned" {
        setup
        New-Item TestDrive:\to -ItemType Directory
        Move-DirectoryContents TestDrive:\from TestDrive:\to | Should -BeNullOrEmpty
        Get-ChildItem TestDrive:\from | Should -HaveCount 0
        Get-ChildItem TestDrive:\to | Should -HaveCount 3
        Get-Content TestDrive:\to\a.txt | Should -Be a
        Get-Content TestDrive:\to\b.txt | Should -Be b
        Get-Content TestDrive:\to\subdir\sub.txt | Should -Be c
        teardown
    }
    It "Given one path, the directory's contents will be moved to a new folder" {
        setup
        Move-DirectoryContents TestDrive:\from TestDrive:\to
        Get-ChildItem TestDrive:\from | Should -HaveCount 0
        Get-ChildItem TestDrive:\to | Should -HaveCount 3
        Get-Content TestDrive:\to\a.txt | Should -Be a
        Get-Content TestDrive:\to\b.txt | Should -Be b
        Get-Content TestDrive:\to\subdir\sub.txt | Should -Be c
        teardown
    }
    It "Given one path and -PassThru, the directory's contents will be moved to a new folder and the new path returned" {
        setup
        $output = Move-DirectoryContents TestDrive:\from TestDrive:\to -PassThru
        $output | Should -Be (Join-Path $TestDrive to)
        Get-ChildItem TestDrive:\from | Should -HaveCount 0
        Get-ChildItem TestDrive:\to | Should -HaveCount 3
        teardown
    }
}
