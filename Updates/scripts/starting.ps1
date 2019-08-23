#add additional items that need to run before the menu here
#unneeded
#$networkInfo = .\getNetworkInfo.ps1   # Network info [0] = IP; [1] = Campus; [2] = type; [3] = Drive;
.\driveselect.ps1                     #passes networkinfo to drive select
#.\menu.ps1 -imagedrive o: