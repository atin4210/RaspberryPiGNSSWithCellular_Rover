#!/bin/bash

exec >> /var/log/mosaic-usb0.log 2>&1
echo "Starting Mosaic USB0 NMCLI config: $(date)"

CONN_NAME="$(nmcli -g NAME,DEVICE connection show --active | awk -F: '$2 == "usb0" {print $1; exit}')"

if [ -n "$CONN_NAME" ]; then
    echo "Configuring $CONN_NAME for usb0 static IP..."
    nmcli connection modify "$CONN_NAME" ipv4.method manual \
      ipv4.addresses 192.168.3.2/24 ipv4.gateway "" ipv4.dns "127.0.0.1 1.1.1.1 1.0.0.1 8.8.8.8" 
    nmcli connection down "$CONN_NAME"
    sleep 2
    nmcli connection up "$CONN_NAME"
    ip addr show usb0
else
    echo "usb0 connection not found. Please check 'nmcli device status'."
fi

