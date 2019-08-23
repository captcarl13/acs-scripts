Param(
    [string] $networkDrive
    )

## Will detect USB drives then compare the date of Boot.wim against the server to see if a newer version is available.
## It will then prompt user that an update is available and ask if they want to update
## Current Boot.wim Drive info is located in the registry key "HKLM:\SYSTEM\CurrentControlSet\Control\PERamDiskSourceDrive" if needed
$driveLetters = Get-WmiObject win32_volume | ? {$_.drivetype -eq 2} | %{$_.driveLetter} ## Get all drive letters where the device type is USB and store into $driveLetters as an array
$updateSource = Get-childitem -Path "$networkDrive\WinPE\USB\sources\boot.wim"
$fileChecked = "\sources\boot.wim"
foreach ($drive in $driveLetters)
{  
    if(Test-Path $drive$fileChecked) #Check if \Sources\boot.wim exists
    {
        $currentFile = Get-childitem -Path $drive$fileChecked
        if ($currentFile.LastWriteTime -lt $updateSource.LastWriteTime)  #Updates if source is current is older than source based on modified date
        {
            Write-Host "There is an Update available for drive $drive"
            do{
            $updateResponse = Read-Host "Would you like to update $($drive)?"
            } until ($updateResponse -in "y","n")
            if ($updateResponse -eq "y")
            {    # User wishes to update
                $successful = 0
                do
                {
                    Write-Host "Updating..."
                    Copy-Item "$($updateSource.DirectoryName)\$($updateSource.Name)" -Destination "$($currentFile.DirectoryName)" -Recurse -Force
                    if ($currentFile.LastWriteTime -lt $updateSource.LastWriteTime)
                    { #File Updated
                        Write-Host "Update Successful"
                        $successful++
                    }

                    else
                    { #Update Failed
                        Write-Host "Update Failed"
                        do
                        {
                            $retry = Read-Host "Retry? (y/n)"
                        } until ($retry.ToUpper() -in "Y","N")
                    }
                }
                while(-NOT $successful -or $retry.ToUpper() -eq "Y")
            }
            else
            {    # User declines update
                Write-Host "Update has been declined for drive $drive"
            }
        }
        else
        {
            Write-Host "Drive $drive is current"
        }
    }
    else    #Not bootable...Maybe add a configure option?
    {
        Write-Host "Drive $drive is not configured as a bootable WinPE drive"
    }
}