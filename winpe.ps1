<#
The following is the BASH version of this script to use as a reference can be deleted once basic framework is laid out for PS version
#!/bin/bash
#
#NOTE this script will only work on macOS, not *nix due to DISKUTIL being macOS-specific
ECHO NYIT ACS WinPE Bootable USB creation script, version BASH
sleep 1
afplay /System/Library/Sounds/Funk.aiff & read -p "Please insert a USB drive, then press RETURN to continue..."
sleep 2
#DISKUTIL lists disks, use READ to find correct disk for USB
diskutil list
sleep 1
afplay /System/Library/Sounds/Sosumi.aiff & read -p "Please enter disk NUMBER for USB drive (eg. /dev/disk#) that is listed above: " -e input
ECHO Selected /dev/disk$input
sleep 2
afplay /System/Library/Sounds/Sosumi.aiff & read -r -p "You have selected /dev/disk$input, is this correct? [y/N] " response
    if [[ "$response" =~ ^([yY][eE]|[yY])+$ ]]
      then
        ECHO Formatting USB as ACS bootable drive, please stand by...
        sleep 1
        #Pull information from READ to populate eraseDisk correctly
        diskutil eraseDisk FAT32 ACS MBRFormat /dev/disk$input
      else
        afplay /System/Library/Sounds/Basso.aiff & ECHO Please confirm correct drive number and run script again.
        exit
    fi
sleep 1
ECHO Format complete!
sleep 3
#//owacaddist-srv/GhostImages must be mounted to /Volumes/GhostImages in order for this section to work
ECHO Copying WinPE files...
sleep 1
rsync -vah --progress /Volumes/GhostImages/WinPE/USB/ ~/WinPE
sleep 2
rsync -vah --progress ~/WinPE/ /Volumes/ACS
sleep 1
diskutil eject /dev/disk$input
sleep 5
afplay /System/Library/Sounds/Glass.aiff & ECHO Boootable USB creation complete!
sleep 1
ECHO Please remove the USB drive from the computer.

#BASH VERSION ENDS HERE
#>

#BEGIN POWERSHELL VERSION HERE
# Maybe add the ability to create Bootable Media with an existing WinPE environment? Add this to the existing system's hidden menu? -cv
wait 1
ECHO NYIT ACS WinPE bootable USB creation script, version PowerShell
wait 1
#DISKPART BEGINS HERE
DISKPART
list disk
#READ (lines 15-25) goes here // called CHOICE on Windows
select disk $input
clean
create partition primary
select partition 1
active
format -q fs=FAT32
assign
exit
#DISKPART ENDS HERE
#ROBOCOPY BEGINS HERE
#add another CHOICE section requesting drive letter of USB
ROBOCOPY O:\WinPE\USB\ $input:\ *.* /e #whatever the USB's drive letter may be needs to go here
#ROBOCOPY ENDS HERE
#end of script
