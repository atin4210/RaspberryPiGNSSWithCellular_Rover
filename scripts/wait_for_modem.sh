#!/bin/bash
DEV="/dev/serial/by-id/usb-QualComm_QualComm_Compo_000000000001-if06"
for i in {1..30}; do
    [ -e "$DEV" ] && exit 0
    sleep 2
done
echo "PPP modem device not found after 60s: $DEV" >&2
exit 1

