#!/bin/sh

#Install printer for MK102/203 script
#TO ADD LATER: IF/THEN BASED ON ROOM NAME


# this assumes your naming has the room designation in the 1st half of the name.
# adjust the regex as needed if it differs.
#echo ${computername} | awk 'BEGIN {FS="-"}; {print $1"-"$2"-"$3}'
computername= $(scutil --get ComputerName)
case $computername in
"OW-MK-102"*)
  printer='OW-MK102-LaserJet'
  ;;
"OW-MK-203"*)
  printer='OW-MK203-LaserJet'
  ;;
*)
  printer="none"
  ;;
esac

if [[ $printer == "none" ]]; then
  echo "no valid printer for $computername"
else
  lpadmin -p $printer blah blah
  sleep 10
  lpoptions -d $printer
fi


#mk102
scutil --get $ComputerName
if $ComputerName is OW-MK-102
  then #computer name is MK102
    lpadmin -p 'MK-102-LaserJet' -E -v socket://192.168.36.6 -P /Library/Printers/PPDs/Contents/Resources/HP\ Color\ LaserJet\ CP5520\ Series.gz -o printer-is-shared=false
    sleep 10
    lpoptions -d 'MK-102-LaserJet' #sets default printer
  else #computer name is MK203
    lpadmin -p 'MK-203-LaserJet' -E -v socket://192.168.36.7 -P /Library/Printers/PPDs/Contents/Resources/HP\ Color\ LaserJet\ CP5520\ Series.gz -o printer-is-shared=false
    sleep 10
    lpoptions -d 'MK-203-LaserJet' #sets default printer
fi
#mk203
if $ComputerName is OW-MK-102
  then #computer name is MK102
    lpadmin -p 'MK-102-LaserJet' -E -v socket://192.168.36.6 -P /Library/Printers/PPDs/Contents/Resources/HP\ Color\ LaserJet\ CP5520\ Series.gz -o printer-is-shared=false
    sleep 10
    lpoptions -d 'MK-102-LaserJet' #sets default printer
  else #computer name is MK203
    lpadmin -p 'MK-203-LaserJet' -E -v socket://192.168.36.7 -P /Library/Printers/PPDs/Contents/Resources/HP\ Color\ LaserJet\ CP5520\ Series.gz -o printer-is-shared=false
    sleep 10
    lpoptions -d 'MK-203-LaserJet' #sets default printer
fi
