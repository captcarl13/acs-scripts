#!/bin/bash
#
# NOTE this script will only work on macOS, not *nix due to DISKUTIL being macOS-specific
ECHO NYIT ACS WinPE Bootable media creation script, version BASH
sleep 1
afplay /System/Library/Sounds/Funk.aiff & read -p "Please insert a USB drive, then press RETURN to continue..."
sleep 2
#DISKUTIL lists disks, use READ to find correct disk for USB
diskutil list external
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
# //owacaddist-srv/GhostImages must be mounted to /Volumes/GhostImages in order for this section to work
ECHO Copying WinPE files...
sleep 1
rsync -vrh --progress --delete /Volumes/GhostImages/WinPE/USB/ ~/WinPE
sleep 2
rsync -varh --progress ~/WinPE/ /Volumes/ACS
sleep 3
diskutil unmountDisk /dev/disk$input
sleep 5
afplay /System/Library/Sounds/Glass.aiff & ECHO Boootable USB creation complete!
sleep 1
ECHO Please remove the USB drive from the computer.
