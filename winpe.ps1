<#
  Maybe add the ability to create Bootable Media with an existing WinPE environment?
  Add this to the existing system's hidden menu? -cv
#>
<#
  NOTE: This script is intended to work only in a preimage environment.
  If you want to create media in an existing Windows environment, follow the documentation
  located in \\owcaddist-srv\GhostImages\WinPE\WINDOWS PE IMAGE AUTOMATION.docx
#>
timeout 1
Write-Output "NYIT ACS WinPE bootable media creation script, version PowerShell"
timeout 1
<#
  DISKPART BEGINS HERE
#>
Get-Disk 1 | Clear-Disk -RemoveData #prompts user to confirm, possibly always confirm as yes?
New-Partition -DiskNumber 1 -UseMaximumSize -IsActive -DriveLetter U | Format-Volume -FileSystem FAT32 -NewFileSystemLabel ACS
<#
  Force assign to always mount USB to a unique drive letter, like U:\?
  By doing this, the script could run fully-automated?
  DISKPART ENDS HERE
  ROBOCOPY BEGINS HERE
#>
ROBOCOPY /S /XO O:\WinPE\USB\ U:\
<#
  ROBOCOPY ENDS HERE
  end of script
#>
