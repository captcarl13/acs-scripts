Param(
    [Switch]$noReboot,
    [Switch]$capture,
    [Parameter(Mandatory=$False)]$compname,
    [Parameter(Mandatory=$False)]$imagedrive,
    [switch]$win10
    )


#Variables
$dsMenuChoice    # Choice from dsMenu
$cmdCall         # Command that will be called
$cmdDrive = "X:" # Drive where the command is located
$cmdPath = "\"   # Path to the command
$imgFile         # File name to the image
$imgName         # Name of the image
$networkInfo = @()
$networkInfo = X:\getNetworkInfo   # Network info [0] = IP; [1] = Campus; [2] = type; [3] = Drive;
$imagedrive = "O:"
$cmdString       # String containing the command to be invoked


if($compname -eq $null) #if compname not set runs verify to set it
{
##$compname=x:\getname.ps1
}



$cmdOptions ="$(if ($capture) {"-capture "}if ($noReboot) {"-noreboot "}) -compname $compname " # Options for the command to be invoked this needs to be defined here to pass later

do
{
	Clear-Host
	write-host "
	Imaging dsMenu $compname $($networkInfo[0])"
	Write-Host -BackgroundColor Red -ForegroundColor Green
	$(if(!$capture){Write-Host "Deploying(C)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Capturing(C)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
	$(if($win10){Write-Host "Windows 10(W)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Windows 7(W)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
	Write-Host -NoNewline " with DISM"
	Write-Host -NoNewline " finishing with a "
	$(if ($noReboot) {Write-Host "CMD    (R)" -BackgroundColor Green -ForegroundColor Black -NoNewline }else{Write-Host "Reboot (R)" -BackgroundColor Red -ForegroundColor Black -NoNewline })
    write-Host -NoNewline "

		1) Admin Base
		2) COM Desktop
        3) COM Laptop

		4) FourWinds Signage

        5) COM Library Laptop

		8) Change Computer Name
		0) Launch Another Command Prompt

		X) Exit
	 "
		$dsMenuchoice = read-host -prompt "Enter choice: "
} until ($dsMenuchoice -in "1", "2", "3", "4", "5", "8", "A", "R", "C", "0", "X", "P", "M", "U", "W", "AR")
Switch ($dsMenuchoice)
{
         # 1 through 8 call the imaging script with proper flags
    "1" {$cmdCall = "dsimage.ps1"; $imgFile = 'admin'; $imgName = 'Base' }     # DS Base
    "2" {$cmdCall = "dsimage.ps1"; $imgFile = 'admin'; $imgName = 'NYCOM' }     # NYITCOM
    "3" {$cmdCall = "dsimage.ps1"; $imgFile = 'admin'; $imgName = 'COMLaptop' }     # DS Laptop
    "4" {$cmdCall = "dsimage.ps1"; $imgFile = 'fourwinds'; $imgName = 'FourWinds' } # FourWinds Signage
    "5" {$cmdCall = "dsimage.ps1"; $imgFile = 'admin'; $imgName = 'COMLibLaptop' }     # NYITCOM Laptop
    "AR" {$cmdCall = "dsimage.ps1"; $imgFile = 'adminAR'; $imgName = 'Arkansas' }       # Arkansas Admin NYITCOM Image

    "8" {$cmdCall = "dsMenu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "}Invoke-Expression -Command "X:\dsverifycomputername.ps1 -fail") "} # Change Name
    "R" {$cmdCall = "dsMenu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if (!$noReboot) {"-noReboot "})$compname "} #Flip noReboot
    "C" {$cmdCall = "dsMenu.ps1"; $cmdOptions ="$(if (!$capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "} #Flip capture 
    "W" {$cmdCall = "dsMenu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if (!$win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "} #Flip windows 10 
    ##'Hidden' dsMenu Items
    "A" {$cmdCall = "menu.ps1";  $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})$compname "} #Switch to Academic Menu
    "P" {$cmdCall = "dsMenu.ps1"; $cmdOptions ="$(if ($capture) {"-capture "}if ($win10) {"-win10 "}if ($noReboot) {"-noReboot "})PROMPTNAME "} #Will call getName to bypass the retain name process (need to rename to undo)
    "M" {Invoke-Expression -Command "X:\MapNetworkDrives.exe"; $cmdCall = "dsMenu.ps1"} #Re-map network drives
    "U" {Invoke-Expression -Command "X:\updateUSB.ps1 $($imagedrive)"; $cmdCall = "dsMenu.ps1"}#Check WIM updates and notify if an update is available
    "L" {Invoke-Expression -Command "X:\mapLocal.ps1"; $imagedrive = "L:"; $cmdCall = "dsMenu.ps1"} #Map the local server info to 
    "V" {$cmdCall = "image.ps1"; $imgFile = 'adminVC'; $imgName = 'VC' }       # Vancouver Image
    ##End of 'hidden' dsMenu Items
    "0" {Start-Process cmd -Wait; $cmdCall = "dsMenu.ps1"}                # load a command prompt and then call this file again with -imgProg $imgProg
    ##"10"{$cmdCall = "image.ps1"; $imgFile = 'win10'; $imgName = 'Test' } # Win10 test
    "X" {$cmdCall = "exit"}                                                     # reboot the system http://technet.microsoft.com/en-us/library/hh849837.aspx #this should exit all the way out and should cause winpe to reboot
}
$cmdString = "$($cmdDrive)$($cmdPath)$($cmdCall)"    # Create the full path to the invoked expression
if($cmdCall -eq "exit")                              # Create special options for exit call
{
    Exit
}
if($cmdCall -eq "dsimage.ps1")                         # Create special options for imaging calls
{
if($win10) {$imgFile += 'Win10'}
    $cmdOptions = "$cmdOptions-filename $($imgFile) -image $($imgName) -imagedrive $($imagedrive) "
}
Invoke-Expression -Command "$cmdString $cmdOptions"  # Execute the command with proper paramters