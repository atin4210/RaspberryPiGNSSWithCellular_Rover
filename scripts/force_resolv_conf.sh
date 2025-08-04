#!/bin/bash
# Overwrite /etc/resolv.conf with preferred DNS

cat <<EOF > /etc/resolv.conf
nameserver 192.168.3.2
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
EOF

