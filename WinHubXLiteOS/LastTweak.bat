@echo off
rem Esporta e modifica ContentDeliveryManager
set regKeyPath=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager
set exportedRegFile=ContentDeliveryManager.reg

reg query "%regKeyPath%"
if %errorlevel% equ 0 (
    powershell -command "$regKeyPath='%regKeyPath%';$exportedRegFile='%exportedRegFile%';"
    powershell -command "reg export $regKeyPath $exportedRegFile;"
    powershell -command "((Get-Content $exportedRegFile) -replace '=dword:00000001','=dword:00000000') | Set-Content $exportedRegFile;"
    powershell -command "reg import $exportedRegFile;"
    powershell -command "Remove-Item $exportedRegFile"
)

Echo Nascondo Cortana
taskkill /F /IM SearchUI.exe
move "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy.bak"

echo Disinstallo OneDrive
powershell -Command "Start-Process 'C:\Windows\System32\OneDriveSetup.exe' -ArgumentList '/uninstall'"

echo Abilito F8
bcdedit.exe /set {current} bootmenupolicy Legacy