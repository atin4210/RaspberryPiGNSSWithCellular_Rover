# Raspberry Pi GNSS + PPP Modem Setup — Full Guide

This guide walks through setting up a Raspberry Pi to serve GNSS corrections from a Mosaic-X5 HAT and provide internet connectivity through a SIM7670G modem.

---

## 📁 Directory Overview

| Path | Purpose |
|------|---------|
| `systemd/*.service` | systemd units for automation |
| `scripts/` | helper shell scripts for network/device management |
| `ppp/peers/` | PPP peer configuration |
| `ppp/chatscripts/` | Modem chat initialization |
| `ppp/ip-up.d/` | Default route addition |
| `config/` | Config files for DNS, NAT, firewall |
| `udev/` | USB persistent naming rules |
| `README.md` | Quick summary and paths |
| `README_FULL.md` | This guide |

---

## 🛠 Dependencies

```bash
sudo apt update
sudo apt install ppp dnsmasq unbound nftables network-manager
```

---

## 🧾 File Installation

### 1. Systemd Services

```bash
sudo cp systemd/*.service /etc/systemd/system/
sudo mkdir -p /etc/systemd/system/dnsmasq.service.d
sudo cp systemd/dnsmasq_override.conf /etc/systemd/system/dnsmasq.service.d/override.conf
sudo mkdir -p /etc/systemd/system/unbound.service.d
sudo cp systemd/unbound_override.conf /etc/systemd/system/unbound.service.d/override.conf
sudo systemctl daemon-reexec
```

### 2. Scripts

```bash
sudo install -m 755 scripts/*.sh /usr/local/bin/
```

### 3. PPP Configuration

```bash
sudo mkdir -p /etc/ppp/peers /etc/chatscripts
sudo cp ppp/peers/sim7670g-usb /etc/ppp/peers/
sudo cp ppp/chatscripts/sim7670g-usb /etc/chatscripts/
sudo cp ppp/ip-up.d/add-default-route /etc/ip-up.d/
```

### 4. Configuration Files

```bash
sudo cp config/dnsmasq.conf /etc/dnsmasq.conf
sudo cp config/unbound.conf /etc/unbound/unbound.conf
sudo cp config/pi.conf /etc/unbound/unbound.conf.d/pi.conf
sudo cp config/nftables.conf /etc/nftables.conf
```

### 5. Udev Rules

```bash
sudo cp udev/99-persistent-usb-net.rules /etc/udev/rules.d/
```

---

## 🔌 Service Enablement

```bash
sudo systemctl enable mosaic-usb0.service
sudo systemctl enable wait-usb0-address.service
sudo systemctl enable wait-modem-device.service
sudo systemctl enable ppp-sim7670g-usb.service
sudo systemctl enable fix-resolvconf-after-ppp.service
sudo systemctl enable refresh-arp-usb0.service
```

---

## 🌐 Notes

- Mosaic-X5 is assigned `usb0`, IP: `192.168.3.1`
- The Raspberry Pi’s interface for dnsmasq is `usb0`
- The modem interface `ppp0` provides fallback internet and NAT
- Unbound runs as a local DNS resolver at `192.168.3.2`
- nftables handles packet forwarding and NAT

---

## 🧠 Route Prioritization

Temporarily prioritize `wlan0`:

```bash
sudo ip route change default dev wlan0 metric 70
```

Restore `ppp0`:

```bash
sudo ip route change default dev ppp0 metric 50
```

---

## 🧯 Rollback

Back up any files you're overwriting. You may want to run:

```bash
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
sudo cp /etc/unbound/unbound.conf /etc/unbound/unbound.conf.bak
```

And similar for others.

