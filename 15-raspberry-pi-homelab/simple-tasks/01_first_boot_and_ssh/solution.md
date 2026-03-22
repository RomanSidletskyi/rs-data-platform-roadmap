# Solution - First Boot And SSH

This is a practical answer for macOS as the main machine and Raspberry Pi OS Lite as the target OS.

## 1. Flash Raspberry Pi OS Lite

Use Raspberry Pi Imager and set these options during imaging:

- hostname: `rpi-lab`
- username: `piuser`
- enable SSH: yes
- locale and timezone: set them immediately
- Wi-Fi: configure only if you do not use Ethernet

If you can choose, use Ethernet for the first boot.

## 2. Boot The Device

Insert the storage, connect network, and power on the Raspberry Pi.

Wait 1 to 3 minutes.

## 3. Try Hostname Access From macOS

On your Mac:

```bash
ping rpi-lab.local
ssh piuser@rpi-lab.local
```

If that does not work, find the IP in your router and connect like this:

```bash
ssh piuser@192.168.1.50
```

Replace `192.168.1.50` with the real Raspberry Pi IP.

## 4. Run First Inspection Commands

After login:

```bash
hostname
whoami
ip addr
df -h
free -h
uname -a
```

Expected result:

- hostname is `rpi-lab`
- current user is `piuser`
- you can see the active IP address
- disk and memory look normal

## 5. Update The System

Run:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Reconnect after reboot:

```bash
ssh piuser@rpi-lab.local
```

## 6. Definition Of Done Check

This task is complete if:

- Raspberry Pi boots normally
- you can SSH from macOS
- `hostname` works
- `ip addr` shows the network interface
- you know the current hostname and IP address