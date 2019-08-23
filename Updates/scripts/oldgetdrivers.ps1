Param(
   [String]$compname,
   [Parameter(Mandatory=$False)]$imagedrive
)
<#
To import the dism module into your powershell ISE 
import-module "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
as per http://technet.microsoft.com/en-us/library/hh825010.aspx
#>
#Stores Model from the Bios to array $model in "Series Model# format"  i.e. Latitue E5420 **NOTE Precision series returns PRECISION WORKSTAION T####**
$colItems = Get-WmiObject Win32_ComputerSystem
reg load HKLM\tmp "C:\windows\system32\config\SOFTWARE"
$OSVersion = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\tmp\Microsoft\Windows NT\CurrentVersion' ProductName).ProductName
reg unload HKLM\tmp
if($OSVersion.StartsWith("Windows 7")){ $winVer="win7" }
elseif($OSVersion.StartsWith("Windows 10")) { $winVer="win10" }
else {}

if($colItems.Model.Equals(" "))
{
#For Intel mini PC used for signage
$dellmodel = (Get-WmiObject WIN32_Baseboard | Select -ExpandProperty "Product")
}
else
{
foreach($objItem in $colItems) {
$model=$objItem.Model.Split(" ")
}
$lastpos=$model.Length-1 #finds the last position in the array
while ($model[$lastpos] -eq ""){$lastpos--} #Finding last non-empty index in array
<#at this point
Laptops are the issue here one one them has the v-core or something like that on the end of their model number
$model[$lastpos] =  The model number  AKA 3010, E5420, T5500
$model[0]                  =  The series        AKA Optiplex, Precision
Right now this is working if Dell adds spaces before the model the way they have after
$firstpos=0
while ($model[$firstpos] -eq ""){$firstpos++}
$dellseries=$model[$firstpos]
#>
$dellseries=$model[0]
if ($model -contains "Tower")
{
    $dellmodel="T"+$model[$lastpos]
} else {
if ($dellseries -eq "Precision" -or $model[1] -eq "Precision")
{
    if($model[$lastpos] -eq "Tower"){##Precision 5820 returns model as Precision 5820 Tower
    $dellmodel=$model[$lastpos-1]
    }
    else {
    $dellmodel=$model[$lastpos]
    }
} else {
    $dellmodel=$model[1]
}
}
#expand the cab
}
#cabs must start with the Dell Model Number and end with .cab
New-Item -ItemType directory -path C:\DellDrivers
expand $imagedrive\Drivers\Dell\$dellmodel-$winVer*.cab -f:* C:\DellDrivers
#add the x64 drivers to the offline windows image located at C:\
Dism /image:c: /add-driver /driver:C:\DellDrivers\$dellmodel\$winVer\x64 /ForceUnsigned /Recurse
if($dellmodel -eq "T3620")
{
   #Dism /image:C: /add-package /packagepath:$imagedrive\HotFixes\NVMEHotfixes 
}
#add wireless drivers for carts if needed.
if($compname.Contains("-CART-"))
{
    Dism /image:c: /add-driver /driver:$imagedrive\Drivers\Wireless /ForceUnsigned /Recurse
}
Dism /image:c: /add-driver /driver:$imagedrive\Drivers\Wacom /ForceUnsigned /Recurse
Remove-Item -Path C:\DellDrivers -Recurse -Force