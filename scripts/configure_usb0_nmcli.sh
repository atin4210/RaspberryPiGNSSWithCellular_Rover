#!/bin/bash

exec >> /var/log/mosaic-usb0.log 2>&1
echo "Starting Mosaic USB0 NMCLI config: $(date)"

nmcli device set usb1 managed no

CONN_NAME="$(nmcli -g NAME,DEVICE connection show --active | awk -F: '$2 == "usb0" {print $1; exit}')"

if [ -z "$CONN_NAME" ]; then
    echo "No active usb0 connection, creating 'mosaic-usb0' profile..."
    CONN_NAME="mosaic-usb0"

    # Create the connection profile if it does not already exist
    if ! nmcli connection show "$CONN_NAME" >/dev/null 2>&1; then
        nmcli connection add type ethernet ifname usb0 con-name "$CONN_NAME" autoconnect yes || {
            echo "Failed to create NetworkManager profile for usb0" >&2
            exit 1
        }
    fi
fi

echo "Configuring $CONN_NAME for usb0 static IP..."
nmcli connection modify "$CONN_NAME" ipv4.method manual \
  ipv4.addresses 192.168.3.2/24 ipv4.gateway "" ipv4.dns "127.0.0.1 1.1.1.1 1.0.0.1 8.8.8.8" autoconnect yes
nmcli connection down "$CONN_NAME" || true
sleep 2
nmcli connection up "$CONN_NAME"
ip addr show usb0

