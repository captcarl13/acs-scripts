<#
  Maybe add the ability to create Bootable Media with an existing WinPE environment?
  Add this to the existing system's hidden menu? -cv
#>
wait 1
Write-Output NYIT ACS WinPE bootable media creation script, version PowerShell
wait 1
<#
DISKPART BEGINS HERE
#>
Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
#READ (lines 15-25) goes here // called CHOICE on Windows
select disk $input
Clear-Disk
clean
create partition primary
select partition 1
active
format -q fs=FAT32
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
