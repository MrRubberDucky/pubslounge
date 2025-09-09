#Requires -RunAsAdministrator

# Install_MK1InventoryEmu by github.com/MrRubberDucky for Pub's Lounge - v1.2.0 @ compiled to executable with ps2exe <https://github.com/MScholtes/PS2EXE>
# This utility is provided as-is, with no warranties or guarantees.
# Credits: https://stackoverflow.com/a/52856925, https://github.com/Gustxxl/7zUpdater/blob/main/7zUpdater.ps1

# Pre-setup environmental variables - Path
$env:Path += ";C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip"
# Invoke-WebRequest 
$7zipExe = "C:\Program Files\7-Zip\7z.exe"
# 7-zip installation status
$installedVersion = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ?{$_.DisplayName -like "7-Zip*"}

Write-Host "🦆 This script was made for discord.gg/pubslounge by github.com/mrrubberducky" -BackgroundColor DarkGreen
Write-Host "🔍 Checking if 7-Zip x64 is installed on system..."

if ($installedVersion -ne $null) {
    Write-Host "✔️ 7-Zip x64 was successfully found on your system!" -ForegroundColor Green
    Write-Host "Press any key to continue..."
    [console]::ReadKey($true)
} else {
    # Write error message but don't fail
    Write-Host "❌ ERROR: 7-Zip x64 was NOT found on your system!" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "☁️ This script will now fetch and install latest 7-zip x64 version for your system." -ForegroundColor Green
    
    # Just to make sure they read this error message and it's done with their consent
    Write-Host "Press any key to continue, or click on X to terminate the program..."
    [console]::ReadKey($true)
    clear
    
    # I'm too lazy to check for latest version
    $7zipDownloadUrl = "https://7-zip.org/a/7z2501-x64.exe"
    # Downloading
    Invoke-WebRequest -Uri $7zipDownloadUrl -OutFile .\7z2501-x64.exe
    # Installing
    try {
        Start-Process -FilePath .\7z2501-x64.exe -ArgumentList "/S" -Wait
    } catch {
        Write-Host "Installation failed! Details: $_"
    }
    
    $recheckInstall = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ?{$_.DisplayName -like "7-Zip*"}
    if ($recheckInstall -ne $null) {
        Write-Host "✔️ 7-Zip 25.01 x64 was successfully installed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Critical error has occured, script will terminate!"
        Write-Host "Press any key to continue..."
        [console]::ReadKey($true)
        exit 1
    }
    # Clean-up
    Remove-Item .\7z2501-x64.exe
}

Write-Host "Adding current folder to Windows Defender exceptions..."
try {
    Add-MpPreference -ExclusionPath "$pwd"
} catch {
    Write-Host "❌ An error has occured: $_" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "❌ Failed to add Windows Defender folder exception. You will have to do it yourself!" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "Press any key to continue..."
    [console]::ReadKey($true)
    clear
}

Write-Host "Grabbing latest version of MK1 Inventory Emulator... (This requires Microsoft Edge to be installed!)"
Write-Host "If this fails and you're in a sanctioned country then use a VPN! (Russia, Ukraine etc.)" -BackgroundColor DarkRed
$apiUrl = "https://api.github.com/repos/GhostyPool/MK1InvEmulator/releases/latest"
$downloadUrl = $(Invoke-RestMethod $apiUrl).assets.browser_download_url | Where-Object {$_.EndsWith(".7z")}
Invoke-WebRequest -URI $downloadUrl -OutFile MK1InvEmu.7z -UseBasicParsing
clear

# Extract it then remove it, finally exit the script
try {
    & "7z.exe" x "MK1InvEmu.7z" "-o.\MK12\Binaries\Win64"
} catch {
    Write-Host "An error has occured during archive extraction attempt: $_" -Category ResourceUnavailable -ErrorAction SilentlyContinue
    Write-Host "Press any key to continue..."
    [console]::ReadKey($true)
}

Remove-Item .\MK1InvEmu.7z
clear

Write-Host "✔️ Everything is ready! Now follow the rest of the steps." -ForegroundColor Green
Write-Host "You can close this window now by pressing any key."
[console]::ReadKey($true)
exit 1
