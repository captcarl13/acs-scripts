rem MAYBE THIS SHOULD BE A CMD INSTEAD OF A BAT???
rem If you need syntax and context, please refer to winpe.sh
rem BEGIN BATCH VERSION HERE
wait 1
ECHO ON NYIT ACS WinPE bootable USB creation script, version Batch
wait 1
rem DISKPART BEGINS HERE
DISKPART
list disk
rem READ goes here // CHOICE on Windows
select disk $input
clean
create partition primary
select partition 1
active
format -q fs=FAT32
assign
exit
rem DISKPART ENDS HERE
rem ROBOCOPY BEGINS HERE
rem add another read section requesting drive letter of USB
ROBOCOPY \\owacaddist-srv\GhostImages\WinPE\USB\ $input:\ *.* /e
rem ROBOCOPY ENDS HERE
rem end of script
