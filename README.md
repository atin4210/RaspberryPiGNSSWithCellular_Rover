# Raspberry Pi GNSS + PPP Modem Project

This project configures a Raspberry Pi to support:
- GNSS via Mosaic-X5 HAT on `usb0`
- Internet fallback via SIM7670G modem using PPP on `usb1`
- Local DNS via `unbound` + `dnsmasq`
- NAT forwarding via `nftables`

---

## ⚠️ Important: Backup/Conflict Warning

Many files in this project are copied into system directories like `/etc/` and `/usr/local/bin/`. **Please back up or merge existing files before replacing them.** This ensures you can undo changes if needed.

---

## 🗂 File Paths and Usage

| Repo Path | System Install Path |
|-----------|----------------------|
| `systemd/*.service` | `/etc/systemd/system/` |
| `scripts/*.sh` | `/usr/local/bin/` |
| `ppp/peers/sim7670g-usb` | `/etc/ppp/peers/sim7670g-usb` |
| `ppp/chatscripts/sim7670g-usb` | `/etc/chatscripts/sim7670g-usb` |
| `ppp/ip-up.d/add-default-route` | `/etc/ip-up.d/add-default-route` |
| `systemd/dnsmasq_override.conf` | `/etc/systemd/system/dnsmasq.service.d/override.conf` |
| `systemd/unbound_override.conf` | `/etc/systemd/system/unbound.service.d/override.conf` |
| `config/dnsmasq.conf` | `/etc/dnsmasq.conf` |
| `config/unbound.conf` | `/etc/unbound/unbound.conf` |
| `config/pi.conf` | `/etc/unbound/unbound.conf.d/pi.conf` |
| `config/nftables.conf` | `/etc/nftables.conf` |
| `udev/99-persistent-usb-net.rules` | `/etc/udev/rules.d/99-persistent-usb-net.rules` |
| `NetworkManader/dispatcher.d/70-prefer-wlan0` | `/etc/NetworkManader/dispatcher.d/70-prefer-wlan0` |

---

## ✅ Setup Instructions

See `README_FULL.md` in the repo for full installation and service enablement steps.

---

## 🌐 Notes

- `dnsmasq` assigns static IP 192.168.3.1 to Mosaic-X5
- `unbound` runs local DNS resolver at 192.168.3.2
- `nftables` enables NAT for `usb0 <-> ppp0/wlan0`
- `udev` rules pin device order: Mosaic = usb0, SIM7670G = usb1
