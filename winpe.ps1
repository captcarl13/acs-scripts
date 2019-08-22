<#
  NOTE: This script is intended to work only in a preboot (PE) environment.
  If you want to create media in an existing Windows environment, follow the documentation
  located in \\owcaddist\GhostImages\WinPE\WINDOWS PE IMAGE AUTOMATION.docx

  TO USE THIS SCRIPT:
  After booting into PE, press '0' to open a new command prompt.
  type 'powershell ./winpe.ps1'
  Follow the prompts on-screen.
#>

<#
  TODO:
  Find way to integrate into existing menu. MF said a hidden switch should already exist.
#>

Start-Sleep -s 1
Write-Output "NYIT ACS WinPE bootable media creation script, version PowerShell"
Start-Sleep -s 1
Read-Host "Please insert a USB drive, then press ENTER to continue"
Start-Sleep -s 1
<#
  DISKPART BEGINS HERE
#>
Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} | Clear-Disk -RemoveData -RemoveOEM
Start-Sleep -s 1
Write-Output "Formatting USB as ACS bootable drive, please stand by..."
Start-Sleep -s 1
Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} New-Partition -UseMaximumSize -IsActive -DriveLetter U | Format-Volume -FileSystem FAT32 -NewFileSystemLabel ACS
<#
  Force assign to always mount USB to a unique drive letter not in use (U:\)
  DISKPART ENDS HERE & ROBOCOPY BEGINS HERE
#>
Start-Sleep -s 1
Write-Output "Format complete!"
Start-Sleep -s 3
Write-Output "Copying WinPE files..."
Start-Sleep -s 1
robocopy /S /XO /V O:\WinPE\USB\ U:\
<#
  ROBOCOPY ENDS HERE
#>
Start-Sleep -s 1
Write-Output "Bootable USB creation complete!"
Start-Sleep -s 1
Write-Output "Please remove the USB drive from the computer."
<#
  END OF SCRIPT
#>
