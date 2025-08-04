#!/bin/bash
# /usr/local/bin/refresh_arp_usb0.sh
#
ping -c 1 192.168.3.1 >/dev/null
arping -I usb0 -c 2 192.168.3.1
