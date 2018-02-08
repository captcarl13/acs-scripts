#!/bin/sh

#MACOS NETWORK AUTO PROXY DISCOVERY SCRIPT

#syntax
#networksetup -setautoproxydiscovery INTERFACE on
#see manpage for more information

networksetup -setautoproxydiscovery Ethernet on

#END OF SCRIPT
