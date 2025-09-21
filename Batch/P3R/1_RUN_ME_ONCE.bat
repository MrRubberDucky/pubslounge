@echo off
& powershell.exe -ExecutionPolicy Bypass -NoExit -NoLogo -NoProfile -Command "Get-ChildItem '%~dp0\Engine\Binaries\ThirdParty\Steamworks\Steamv151\Win64' | Remove-Item -Recurse -Force"
