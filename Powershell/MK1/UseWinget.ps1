if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$winGetPackage = Get-AppPackage *Microsoft.DesktopAppInstaller*|select PackageFullName
if($winGetPackage -ne $null) {
    winget install --id Microsoft.Powershell --source winget
    exit 0
} else {
    Write-Host "Winget is missing from system, installing it..."
    # This is from https://github.com/asheroto/winget-install
    powershell.exe -NoLogo -NoProfile -Interactive -Command ".\winget-install.ps1" -ExecutionPolicy Bypass
}

winget install --id Microsoft.Powershell --source winget
