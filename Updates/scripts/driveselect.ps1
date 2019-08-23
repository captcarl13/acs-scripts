$networkInfo = .\getNetworkInfo.ps1        # Network info [0] = IP; [1] = Campus; [2] = type; [3] = Drive;
$drive=$networkInfo[3]
$campus=$networkInfo[1]
while ($campus -eq "Local" -or $campus -eq "Unknown")   #when you have an unkown or local IP address present a menu
{
    Do 
    {
        Clear-Host
        Write-Host "
        You seem to have a network issue you can
        1: Renew IP
        2: Continue using OW server
        3: Continue using MC server
        4: Continue using VC server
        5: Quit
        "
        $choice1 = read-host -prompt "Select number & press enter"
    } until ($choice1 -in "1", "2", "3", "4" ,"5", "0")
    Switch ($choice1) 
    {
        "1" {
				.\Ipconfig-Release-Renew.ps1
				$networkInfo = .\getNetworkInfo.ps1        # Network info [0] = IP; [1] = Campus; [2] = type; [3] = Drive;
				$drive=$networkInfo[3]
				$campus=$networkInfo[1]
			} #refreshes your IP
        "2" {$drive = "O:";$campus="OW"} #forces the system to use O:
        "3" {$drive = "M:";$campus="MC"} #forces the system to use M:
        "4" {$drive = "V:";$campus="VC"} #forces the system to use V:
        "5" {exit} #quit
        "0" {Start-Process cmd -Wait}

    }
    #after realease renew redefines $drive and $campus

}
while (!(.\drivetest.ps1 -drive $drive))  #if the drive is connected and working then continue else do the while we # we could also use the path of the actual image
{
    Switch ($drive) #if the drive doesn't connect this runs
    {
        "O:"
        {
            Do 
            {
                Clear-Host
                Write-Host "
                You are currently trying to use the OW Server
                1: Remap
                2: Use MC server
                3: Quit
                "
                $choice1 = read-host -prompt "Select number & press enter"
            } until ($choice1 -in "1", "2", "3","0")

            Switch ($choice1) 
            {
                "1" {$drive = "O:"}#Try again
                "2" {$drive = "M:"}#switch what server you use
                "3" {exit}
                "0" {Start-Process cmd -Wait}
            }
        }
        "M:"
        {
            Do 
            {
                Clear-Host
                Write-Host "
                You are currently trying to use the MC Server
                1: Remap
                2: Use MC server
                3: Quit
                "
                $choice1 = read-host -prompt "Select number & press enter"
            } until ($choice1 -in "1", "2", "3","0")

            Switch ($choice1) 
            {
                "1" {$drive = "M:"}#Try again
                "2" {$drive = "O:"}#switch what server you use
                "3" {exit}
                "0" {Start-Process cmd -Wait}
            }
        }
        "V:"
        {
            Do 
            {
                Clear-Host
                Write-Host "
                You are currently trying to use the Vancouver Server. Please check your network connection and remap.
                1: Remap
                2: Quit
                "
                $choice1 = read-host -prompt "Select number & press enter"
            } until ($choice1 -in "1", "2","0")

            Switch ($choice1) 
            {
                "1" {$drive = "V:"}#Try again
                "2" {exit}
                "0" {Start-Process cmd -Wait}
            }
        }
        "P:"
        {
            Do 
            {
                Clear-Host
                Write-Host "
                You are currently trying to use the Admin Server. Please check your network connection and remap.
                1: Remap
                2: Quit
                "
                $choice1 = read-host -prompt "Select number & press enter"
            } until ($choice1 -in "1", "2","0")

            Switch ($choice1) 
            {
                "1" {$drive = "P:"}#Try again
                "2" {exit}
                "0" {Start-Process cmd -Wait}
            }
        }
        default #if you somehow get here and don't have a drive set
        {
        Do 
            {
                Clear-Host
                Write-Host "
                You don't have a Server
                1: Use OW server
                2: Use MC server
                3: Use Admin server
                4: Use Vancouver server
                5: Quit
                "
                $choice1 = read-host -prompt "Select number & press enter"
            } until ($choice1 -in "1", "2", "3", "4","0")

            Switch ($choice1) 
            {
                "1" {$drive = "O:"}#switch what server you use
                "2" {$drive = "M:"}#switch what server you use
                "3" {$drive = "P:"}#switch what server you use
                "4" {$drive = "V:"}#switch what server you use
                "5" {exit}
                "0" {Start-Process cmd -Wait}
            }
        }
    }
}
if($networkInfo[2] -eq "Admin") {.\dsMenu.ps1 -imagedrive $drive -win10}
else {.\menu.ps1 -imagedrive $drive -win10}