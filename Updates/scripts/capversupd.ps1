Param(
    [string]$image
)
reg load HKLM\temp c:\Windows\System32\config\SYSTEM | Out-Null
<#
going to make three registry keys year, semester, version they will be defined using the following

if month>11 then year=currentyear+1 else year=currentyear
if 11<month>3 then term = Spring else term = Fall
if year = reg.year and term = reg.term then version=currentversion+1 else version=1
#>
#store current date
$date=get-date
#set image year
if($date.Month -gt 11){$year=$date.Year+1}else{$year=$date.Year}
#set image term
if ($date.Month -gt 11 -or $date.Month -lt 3){$term="Spring"}else{$term="Fall"}
#sets the current setting from the image if they exist
if (Test-Path -Path HKLM:\temp\ACS)
{
$currentyear=(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\temp\ACS).Year
$currentterm=(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\temp\ACS).Term
$currentversion=(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\temp\ACS).Version
$currentimage = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\temp\ACS).Image
}
else
{
New-Item HKLM:\temp -Name ACS
$currentyear=$year
$currentterm=$term
$currentversion=0
}
#sets version
if($currentyear-eq $year -and $currentterm-eq $term -and $currentimage -eq $image){$version=$currentversion+1}else{$version=1}
Set-ItemProperty -Path HKLM:\temp\ACS -Name Year -Value $year
Set-ItemProperty -Path HKLM:\temp\ACS -Name Term -Value $term
Set-ItemProperty -Path HKLM:\temp\ACS -Name Version -Value $version
Set-ItemProperty -Path HKLM:\temp\ACS -Name Date -Value $date
Set-ItemProperty -Path HKLM:\temp\ACS -Name Image -Value $image
reg unload HKLM\temp | Out-Null
Return "$term $year V$version Date:$date"