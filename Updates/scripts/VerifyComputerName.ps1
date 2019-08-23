Param(
   [Parameter(Mandatory=$False)]$localComp, # Current name to be checked
   [switch] $fail, # Will run the rename fucntion prior to checking.  This will allow to call the function recursivily if name is entered wrong.
   [int] $errorCode 
   )

$unattendedLoc = "C:\Windows\Panther\unattend.xml"
$nameBreakdown =@()


if ($fail)
{
    switch ($errorCode)
    {
        1 {Write-Host "Name is too long"}
        2 {Write-Host "Name is not properly formatted! Campus-Building-Room-##"}
        3 {Write-Host "Invalid Campus"}
        4 {Write-Host "Invalid Building"}
        5 {Write-Host "C:\CompName.txt does not exist"}
        6 {Write-Host "PC Load Letter"}
        default
        {

        }

    }
    $localComp = Read-Host -prompt "Please enter new computer name"
}

if($localComp -eq $null)
{ # Local Computername is not specified looking for C:\CompName.txt
    if(Test-Path -Path C:\CompName.txt)
    {
        $localComp=Get-Content "C:\CompName.txt" -TotalCount 1
    }
    else
    {
        $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 5"
    }
}

# Make sure computer name is in proper UPPERCASE format and check for the underscore error
$localComp = $localComp -replace "_", "-"
$localComp = $localComp.ToUpper()
if($localComp.Length -gt 15)
{   # Name exceeds Windows 15 character limit
    $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 1"
}

elseif(!$localComp.CompareTo("PROMPTNAME")) # CompareTo returns 0 if equal so it has to be negated to be true
{
}

else
{
    do
    {
        $badname=0
        $nameBreakdown =@()
        $nameBreakdown += $localComp.Split('-')         # Split computer name by '-'



        if($nameBreakdown.Length -ne 4)
        {   # Name is not properly split
            if($nameBreakdown.Length -eq 2){
                if($nameBreakdown[0] -eq "NL") {}
                else{
                    $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 2"
                    $badname=1
                    }
            
            }
            else {
            $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 2"
            $badname=1
            }
        }
        else
        {   
            #Number Contains 'O' replace with 0(zero) since to upper is called only need to check for upper character
            $nameBreakdown[3] = $nameBreakdown[3] -replace "O", "0"    

            if($nameBreakdown[3].Length -lt 2)
            {   #Number is missing leading 0
                $nameBreakdown[3] = "0"+$nameBreakdown[3]
            }
            elseif($nameBreakdown[3].Length -gt 2)
            {   #Invalid number. Enter in Valid number
                $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 2"
                $badname=1
            }
            switch ($nameBreakdown[0])
            {
                "OW" 
                {
                    switch ($nameBreakdown[1])
                    {
                        "HSH" {} # Harry Schure Hall
                        "300" {} # Anna Rubin (AARH)/300 Building
                        "400" {} # Theobald Hall (JJTH)/400 Building
                        "500" {} # 500 Building
                        "WIS" {} # Wisser Library
                        "ED" {$nameBreakdown[1]="EH"} # Incorrect Education Hall
                        "EH" {} # Education Hall
                        "MK" {} # Midge Karr Arts Center MKAC
                        "SH" {} # Salten Hall DGSH
                        "SC" {$nameBreakdown[1]="SH"} # Incorrect Salten Hall
                        "SAC" {} #Student Activites Center
                        "WLH" {} # Whitney Lane House
                        "BH" {} # Balding House
                        "DS" {} # DeServersky Mansion
			            "SUNY"{}# SUNY Old Westbury Housing
			            "ORL"{} #Office of Res Life in SUNY OW
                        "GL"{} #Office of Res Life in SUNY OW
                        "AV" {} # Mobile PC's/Laptops
                        default ##Building not valid OW Building
                        {
                            $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 4"
                            $badname=1
                        }

                    }
                }
                "MC" 
                {
                    switch ($nameBreakdown[1])
                    {
                        "1855" {$nameBreakdown[1]="EGGC";} # Incorrect Edward Guiliano Global Center
                        "EGGC" {} # Edward Guiliano Global Center
                        "MC61" {} # 16 W 61st
                        "MC26" {} # 26 W 61st
                        "AV" {} # Mobile PC's/Laptops
                        default ##Building not valid MC Building
                        {
                            $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 4"
                            $badname=1
                        }
                    }
                }
                "VC" 
                {
                
                }
                "CI"
                {

                }
                default 
                {
                    $localComp = Invoke-Expression -Command "X:\verifycomputername.ps1 -fail -errorCode 3"
                    $badname=1
                }
            } # End Campus Switch

        } # End Else
    }until($badname -eq 0) #End Do while
    $localComp = $nameBreakdown -join "-"
} ## End Else

return $localComp