# Sets the module directory to the current script's directory if it doesn't
# exist
$private:modulePath = Split-Path -Parent $PSCommandPath
if ($env:PSModulePath -split ";" -inotcontains $private:modulePath) {
    $env:PSModulePath += ";$private:modulePath"
}
