<#
  Maybe add the ability to create Bootable Media with an existing WinPE environment?
  Add this to the existing system's hidden menu? -cv
#>
<#
NOTE: This script is intended to work only in a preimage environment.
If you want to create media in an existing Windows environment, follow the documentation
located in \\owcaddist-srv\GhostImages\WinPE\WINDOWS PE IMAGE AUTOMATION.docx
#>
wait 1
Write-Output NYIT ACS WinPE bootable media creation script, version PowerShell
wait 1
<#
DISKPART BEGINS HERE
#>
Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
wait 3
Clear-Disk -Number 1 -RemoveData
wait 3
Initialize-Disk -Number 1 -PartitionStyle MBR
<#
  Force assign to always mount USB to a unique drive letter, like U:\?
  By doing this, the script could run fully-automated?
#>
assign
exit
<#
DISKPART ENDS HERE
#ROBOCOPY BEGINS HERE
#>
ROBOCOPY /S /XO O:\WinPE\USB\ U:\ *.* # whatever USB drive letter may be needs to go here
<#
  ROBOCOPY ENDS HERE
  end of script
#>
