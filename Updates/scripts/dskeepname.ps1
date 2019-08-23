Param(
    [String]$compname
)
$localDir = "x:"
#$compname=.\VerifyComputerName.ps1 $compname
$sourceFile = ".\dsunattend.xml"
$destinationFile = "C:\Windows\panther\Unattend.xml"

if(!$compname.CompareTo("PROMPTNAME"))  #CompareTo returns 0 if equal need to negate to get true
{
  $outputText=""
  $inputText = Get-Content -path $sourceFile
  ForEach ($i in $inputText)
    { 
     if($i.Trim() -like "<ComputerName>*") # Removes whitespace to find line starting with <ComputerName>
      {} 
     else
      {$outputText += $i+"`r`n"}  #Need 'r for Carriage Return and 'n for Line Feed
    } 
   Set-Content $destinationFile $outputText
}

else
{
  #here it needs to change the name in Unattend.xml
  ## Unattend -> settings[specialize] -> component[Microsoft-Windows-Shell-Setup] -> computername
  [xml]$unattend=Get-Content $sourceFile
  $unattend.unattend.settings[0].component[1].ComputerName = $compname  
  $unattend.Save($destinationFile)
}