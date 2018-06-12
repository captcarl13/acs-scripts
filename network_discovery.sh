#!/bin/sh
#MACOS NETWORK SETTINGS SCRIPT
#see networksetup manpage for more information

#Turn off wifi
networksetup -setnetworkserviceenabled Wi-Fi off

#LAN proxy settings
networksetup -setautoproxydiscovery Ethernet on

#END OF SCRIPT
