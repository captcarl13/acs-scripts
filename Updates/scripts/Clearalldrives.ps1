"rescan"|diskpart
$drives = Get-Disk
foreach($objItem in $drives)
    
    {"sel disk "+$objItem.Number+"`rclean"|diskpart}
