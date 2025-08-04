#!/bin/bash
# Wait until 192.168.3.2 is assigned to usb0, with timeout

for i in {1..15}; do
    if ip addr show usb0 | grep -q '192.168.3.2/24'; then
        exit 0
    fi
    sleep 1
done
echo "usb0 static IP 192.168.3.2 not found after 15 seconds" >&2
exit 1

