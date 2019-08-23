param
(
    [Parameter(Mandatory=$False)]$drive
)
if ($drive -eq $null) #if the drive parameter isn't set you can't connect to anything
{
    Return 0
}
else
{
    if (Test-Path -Path $drive) #test to see if you can connect
    {
        Return 1
    }
    else
    {
        .\MapNetworkDrives.exe #if not remap
        if (Test-Path -Path $drive) #then test again
        {
            Return 1
        }
        else
        {
            Return 0
        }
    }
}