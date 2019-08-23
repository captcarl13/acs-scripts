Param(
    [Switch]$noReboot,
    [Switch]$capture,
    [Parameter(Mandatory=$False)]$compname,
    [Parameter(Mandatory=$False)]$imagedrive,
    [switch]$win10
    )


#Variables
$menuChoice      # Choice from menu
$cmdCall         # Command that will be called
$cmdDrive = "X:" # Drive where the command is located
$cmdPath = "\"   # Path to the command
$imgFile         # File name to the image
$imgName         # Name of the image
$networkInfo = @()
$networkInfo = X:\getNetworkInfo   # Network info [0] = IP; [1] = Campus; [2] = type; [3] = Drive;
$imagedrive=$networkInfo[3]
$cmdString       # String containing the command to be invoked


if($compname -eq $null) #if compname not set runs verify to set it
{
$compname=x:\getname.ps1
}



$cmdOptions ="$(if ($capture) {"-capture "}if ($noReboot) {"-noreboot "}) -compname $compname " # Options for the command to be invoked this needs to be defined here to pass later

do
{
	Clear-Host
	write-host "
	Imaging Menu $compname $($networkInfo[0])"
	Write-Host -BackgroundColor Red -ForegroundColor Green
	$(if(!$capture){Write-Host "Deploying(C)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Capturing(C)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
	$(if($win10){Write-Host "Windows 10(W)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Windows 7(W)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
	Write-Host -NoNewline " with DISM"
	Write-Host -NoNewline " finishing with a "
	$(if ($noReboot) {Write-Host "CMD    (R)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Reboot (R)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
    write-Host -NoNewline "

		1) ACS Base
		2) ACS Full

		4) FourWinds Signage
		5) Architecture
		6) Fine Arts
		7) Engineering and Computer Science
		8) Change Computer Name
		0) Launch Another Command Prompt

		X) Exit
	 "
		$menuchoice = read-host -prompt "Enter choice: "
} until ($menuchoice -in "1", "2", "4", "5", "6", "7", "8", "D", "R", "C", "0", "X", "P", "M", "U", "W", "V")
Switch ($menuchoice)
{
         # 1 through 8 call the imaging script with proper flags
    "1" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'Base' }     # ACS Base
    "2" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'Full' }     # ACS Full
    #"3" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'FullwME' }  # ACS Full and Mechanical Engineering
    "4" {$cmdCall = "image.ps1"; $imgFile = 'fourwinds'; $imgName = 'FourWinds' } # FourWinds Signage
    "5" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'Arch' }     # Architecture Image
    "6" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'FA' }       # Fine Arts Image
    "7" {$cmdCall = "image.ps1"; $imgFile = 'academic'; $imgName = 'Eng' }      # School of Eng
    "8" {$cmdCall = "menu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "}Invoke-Expression -Command "X:\verifycomputername.ps1 -fail") "} # Change Name
    "R" {$cmdCall = "menu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if (!$noReboot) {"-noReboot "})$compname "} #Flip noReboot
    "C" {$cmdCall = "menu.ps1"; $cmdOptions ="$(if (!$capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "} #Flip capture
    "W" {$cmdCall = "menu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if (!$win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "} #Flip windows 10
    ##'Hidden' MENU Items
    "D" {$cmdCall = "dsMenu.ps1";  $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})PROMPTNAME "} #Swtich to Academic Menu
    "P" {$cmdCall = "menu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})PROMPTNAME "} #Will call getName to bypass the retain name process (need to rename to undo)
    "M" {Invoke-Expression -Command "X:\MapNetworkDrives.exe"; $cmdCall = "menu.ps1"} #Re-map network drives
    "U" {Invoke-Expression -Command "X:\updateUSB.ps1 $($imagedrive)"; $cmdCall = "menu.ps1"}#Check WIM updates and notify if an update is available
    "L" {Invoke-Expression -Command "X:\mapLocal.ps1"; $imagedrive = "L:"; $cmdCall = "menu.ps1"} #Map the local server info to
    "V" {$cmdCall = "image.ps1"; $imgFile = 'academicVC'; $imgName = 'VC' }       # Vancouver Image
    ##End of 'hidden' Menu Items
    "0" {Start-Process cmd -Wait; $cmdCall = "menu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "}               # load a command prompt and then call this file again with -imgProg $imgProg
    ##"10"{$cmdCall = "image.ps1"; $imgFile = 'win10'; $imgName = 'Test' } # Win10 test
    "X" {$cmdCall = "exit"}                                                     # reboot the system http://technet.microsoft.com/en-us/library/hh849837.aspx #this should exit all the way out and should cause winpe to reboot
}
$cmdString = "$($cmdDrive)$($cmdPath)$($cmdCall)"    # Create the full path to the invoked expression
if($cmdCall -eq "exit")                              # Create special options for exit call
{
    Exit
}
if($cmdCall -eq "image.ps1")                         # Create special options for imaging calls
{
if($win10) {$imgFile += 'Win10'}
    $cmdOptions = "$cmdOptions-filename $($imgFile) -image $($imgName) -imagedrive $($imagedrive) "
}
Invoke-Expression -Command "$cmdString $cmdOptions"  # Execute the command with proper paramters
