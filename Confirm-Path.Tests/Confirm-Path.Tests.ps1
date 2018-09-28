. ..\Testing-Toolchain-Setup.ps1
Import-Module ..\Confirm-Path -Force

Describe "Confirm-Path" {
    # Setup
    New-Item -ItemType File -Path TestDrive:\file.txt -Value "File Contents"
    New-Item -ItemType File -Path TestDrive:\file.xml -Value "<root>Valid XML</root>"
    New-Item -ItemType Directory -Path TestDrive:\directory
    New-Item -ItemType File -Path TestDrive:\directory\subfile.txt

    It "Given a file path, doesn't except or return" {
        Confirm-Path TestDrive:\file.txt | Should -BeNullOrEmpty
    }
    It "Given a directory and -IsDirectory, doesn't except" {
        Confirm-Path TestDrive:\directory -IsDirectory
    }
    It "Given an xml path and -IsXml, doesn't except" {
        Confirm-Path TestDrive:\file.xml -IsXml
    }

    It "Given a local path and -PassThru, returns a resolved path" {
        Push-Location
        cd TestDrive:\directory
        (Confirm-Path subfile.txt -PassThru).Path | Should -Be (Resolve-Path subfile.txt).Path
        Pop-Location
    }

    It "Given an invalid path, excepts" {
        {Confirm-Path TestDrive:\doesntexist} | Should -Throw "Cannot resolve path"
    }
    It "Given a directory path, excepts" {
        {Confirm-Path TestDrive:\directory} | Should -Throw "File does not exist"
    }
    It "Given a file path with -IsDirectory, excepts" {
        {Confirm-Path TestDrive:\file.txt -IsDirectory} | Should -Throw "Directory does not exist"
    }
    It "Give a file path with -IsXml, excepts" {
        {Confirm-Path TestDrive:\file.txt -IsXml} | Should -Throw "File is not a valid XML File"
    }
}
