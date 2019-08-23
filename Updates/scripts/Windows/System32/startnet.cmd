@ echo off
wpeinit
echo This script will automatically reboot when finished.
REM Wait 20 seconds for drivers to load
powershell Start-Sleep 20
x:
\MapNetworkDrives.exe
cd \
powershell Set-ExecutionPolicy Unrestricted
REM Wait 5 seconds for drives to map
powershell Start-Sleep 5
robocopy /S /XO O:\Updates\scripts X:\
REM Wait 1 seconds for robocopy to finish up
powershell Start-Sleep 2
powershell X:\starting.ps1
exit