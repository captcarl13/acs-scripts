<#
need to look into using powershell instead of cmdline reg tools
#>
if(Test-Path -Path c:\Windows\System32\config\SYSTEM)
{
reg load HKLM\temp c:\Windows\System32\config\SYSTEM | Out-Null
$compname=(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\temp\ControlSet001\Control\ComputerName\ComputerName).computername
reg unload HKLM\temp | Out-Null
return $compname
}
else
{
return "No-Name"
}