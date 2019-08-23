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


return $localComp