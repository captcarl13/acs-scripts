<#
Get's the list of installed drivers
returned as an array
ex
Returns:
Driver           : oem0.inf
OriginalFileName : C:\Windows\System32\DriverStore\FileRep
                   ository\h61carwa.inf_amd64_neutral_a9da
                   191a097f711a\h61carwa.inf
Inbox            : False
ClassName        : MEDIA
BootCritical     : False
ProviderName     : Conexant
Date             : 3/10/2011 12:00:00 AM
Version          : 8.50.4.0

#>
$drvlist=Get-WindowsDriver -Path C:
$currentdriver=0
foreach($objItem in $drvlist)
{
dism /image:C: /remove-driver /driver:$($objItem.driver)
$currentdriver++
write-host
"
$currentdriver/$($drvlist.count)
Remaining:
$($drvlist.count-$currentdriver)
"
}
