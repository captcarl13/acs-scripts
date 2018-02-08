#!/bin/sh

#MACOS NETWORK SETTINGS SCRIPT

#Turn off wifi
networksetup -setnetworkserviceenabled Wi-Fi off

#LAN proxy settings
networksetup -setautoproxydiscovery Ethernet on

#see manpage for more information

#END OF SCRIPT
