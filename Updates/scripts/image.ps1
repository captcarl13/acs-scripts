Param(
   [string]$filename,
   [string]$image,
   [Switch]$noreboot,
   [Switch]$capture,
   [String]$compname,
   [Parameter(Mandatory=$False)]$imagedrive
)
function countdown
{
    write "Press CTRL-C to cancel"
    write "5..."
    Start-Sleep -Seconds 1
    write "4..."
    Start-Sleep -Seconds 1
    write "3..."
    Start-Sleep -Seconds 1
    write "2..."
    Start-Sleep -Seconds 1
    write "1..."
    Start-Sleep -Seconds 1
    
}
function preDeployment
{

}
function postDeployment
{
    diskpart /s rescan.txt
    robocopy /S /XO $imagedrive\Updates\copytoroot C:\
    X:\getdrivers.ps1 -compname $compname -imagedrive $imagedrive
    X:\keepname.ps1 $compname
    X:\patch.ps1 $imagedrive
}
function preCapture
{
  ######################################################################
  #####
  #####      Code to Impletement
  #####      
  #####  check if image is existing in the wim
  #####  If exist remove from wim
  #####
  #####
  ######################################################################
    
}
function postCapture
{
    diskpart /s rescan.txt
    Remove-Item -Path C:\firstrun.bat
}
<#
To import the dism module into your powershell ISE 
import-module "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
as per http://technet.microsoft.com/en-us/library/hh825010.aspx
#>
IF ($capture) 
{
    write "Capturing $($image) to $imagedrive\capture\$($filename)"
    countdown
    write "Capturing DO NOT INTERUPT"
    preCapture
    $version=X:\capversupd.ps1 $image
    if (Test-Path -Path $imagedrive\Capture\$filename.wim)
    {
        dism /append-image /imagefile:$imagedrive\Capture\$filename.wim /name:$image /Description:"$version" /capturedir:c: /logpath:$imagedrive\Capture\Logs\$compname.log #/scratchdir:D:\tmp
        #Add-WindowsImage -CapturePath C: -ImagePath $imagedrive\Capture\$filename.wim -Name $image -CheckIntegrity -LogPath $imagedrive\capture\$compname.log -Verify
    }
    else
    {
        dism /capture-image /imagefile:$imagedrive\Capture\$filename.wim /name:$image /Description:"$version" /capturedir:c: /compress:max /logpath:$imagedrive\Capture\Logs\$compname.log
        #New-WindowsImage -CapturePath C: -ImagePath $imagedrive\Capture\$filename.wim -Name $image -CheckIntegrity -LogPath $imagedrive\capture\$compname.log -Verify
    }
    postcapture
} 
else 
{
    $compname=X:\VerifyComputerName.ps1 $compname
    write "Deploying $($image) from $imagedrive\current\$($filename)"
    countdown
    write "Deploying DO NOT INTERUPT"
    preDeployment
    #what to do if no capture flag is set
    if($image -eq "FourWinds" -or $filename -Match "Win10")
    {
    diskpart /s \cleanUEFI.txt
    ##dism /apply-image /imagefile:$imagedrive\Current\$filename.wim /name:efisys /applydir:s: /CheckIntegrity /verify /logpath:$imagedrive\Current\Logs\$compname.log
    ##dism /apply-image /imagefile:$imagedrive\Current\$filename.wim /name:recovery /applydir:r: /CheckIntegrity /verify /logpath:$imagedrive\Current\$compname.log
    dism /apply-image /imagefile:$imagedrive\Current\$filename.wim /name:$image /applydir:c: /CheckIntegrity /verify /logpath:$imagedrive\Current\Logs\$compname.log
    X:\UEFISetBCD.bat
    if($filename -Match "Win10")
    {postDeployment}
    }

    else{
	diskpart /s \clean.txt
    dism /apply-image /imagefile:$imagedrive\Current\$filename.wim /name:$image /applydir:c: /CheckIntegrity /verify /logpath:$imagedrive\Current\Logs\$compname.log
    #Expand-WindowsImage -ApplyPath C: -ImagePath $imagedrive\Current\$filename.wim -Name $image -CheckIntegrity -LogLevel Errors -LogPath \imagex.log #not working
    postDeployment
    }
   
}
if ($noreboot) 
{
    #opens command prompt
    Start-Process cmd -Wait
}
Exit