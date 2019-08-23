##Return appropriate drive letter

$ipAddresses = @()  # Stores IP Address from NICs
$networkLocation = "Unknown"
$networkType = "Unknown"
$networkDrive= "Unknown"

get-wmiobject win32_networkadapterconfiguration | ? { $_.IPAddress -ne $null } | Sort-Object IPAddress -Unique | % { 
   $ipAddresses +=$_.IPAddress[0]
} 

foreach ( $ip in $ipAddresses ){
$ipsplit = $ip.Split('.')

Switch ([int]$ipsplit[0])
{ 
  192
    {
    Switch ([int]$ipsplit[2])    
        {        
          {($_ -ge 32) -and ($_ -le 42)} {$networkLocation ="OW"; $networkType ="Acad";$networkDrive = "O:"}
          {(($_ -ge 60) -and ($_ -le 75)) -or ($_ -eq 164)} {$networkLocation ="MC"; $networkType ="Acad";$networkDrive = "M:"} 
		  97 {$networkLocation ="CI"; $networkType ="Acad";$networkDrive = "O:"}       
          193 {$networkLocation ="VC"; $networkType ="Acad";$networkDrive = "V:"}       
          {($_ -ge 1) -and ($_ -le 31)} {$networkLocation ="OW"; $networkType ="Admin"; $networkDrive = "O:"}       
          default {$networkLocation ="MC"; $networkType ="Acad";$networkDrive = "M:"} #use default drive letter    
        }  
      }

  169 
    {$networkLocation ="Local"; $networkType ="Local";$networkDrive = ""}
	
  default
    {}

}
}
Return @($ipAddresses[0],$networkLocation, $networkType, $networkDrive)