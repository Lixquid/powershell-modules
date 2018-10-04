# Sets the module directory to the current script's directory if it doesn't
# exist
$private:modulePath = (Get-Item $PSCommandPath).Directory.Parent.FullName
if ($env:PSModulePath -split ";" -inotcontains $private:modulePath) {
    $env:PSModulePath += ";$private:modulePath"
}

# Enables strict mode
Set-StrictMode -Version Latest
