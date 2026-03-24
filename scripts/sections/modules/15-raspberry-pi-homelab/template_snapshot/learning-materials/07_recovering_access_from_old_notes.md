# Recovering Access From Old Notes

This note is for the situation where Raspberry Pi was configured earlier and you still have old setup notes.

That is a common real-world scenario.

Instead of rebuilding everything immediately, you should first try to recover access safely and then convert the useful parts of the old setup into clean documentation.

## What Was Useful In The Old Notes

Your older notes contained practical information such as:

- likely SSH login patterns
- an older direct IP address
- a hostname-based login pattern
- `raspi-config` usage
- power commands
- package update commands
- EEPROM update command
- SSD boot order notes
- storage benchmark notes
- Docker install flow
- Portainer install flow

That is useful operational knowledge.

What should not be copied into the repository:

- passwords
- default credentials still in use
- anything secret-bearing that could remain valid

## Safe Recovery Order

Use this order when trying to regain access.

### 1. Try The Newer Hostname Pattern First

From your laptop:

```bash
ssh rsidletskyi@pi5.local
```

If that fails, do not assume the machine is broken yet.

### 2. Try The Older Known IP

From your laptop:

```bash
ssh rsidletskyi@192.168.0.108
```

This works only if:

- the Raspberry Pi is still on the same subnet
- the IP has not changed
- the device is powered on and connected

### 3. Check Whether The Host Is Reachable

```bash
ping pi5.local
ping 192.168.0.108
```

If ping fails, the issue may be:

- changed IP
- hostname resolution failure
- different network
- powered off device

### 4. Check Your Router Client List

Look for a device named like:

- `pi5`
- `raspberrypi`
- your old hostname

This is often the fastest way to recover the current IP.

### 5. If SSH Works, Capture The Current State Immediately

After login, run:

```bash
hostname
whoami
ip addr
df -h
free -h
docker ps
```

This tells you:

- current hostname
- current user
- current IP addresses
- storage state
- memory state
- whether Docker is already installed and running workloads

## First Cleanup After Recovery

If you regain access, do these next:

1. verify which hostname and IP are current
2. set up SSH key authentication if not already configured
3. add or update your SSH alias on the laptop
4. document current storage layout
5. identify which services are actually installed
6. rotate any password that appears in old notes and may still be valid

## Commands From The Old Notes Worth Keeping

Open Raspberry Pi configuration utility:

```bash
sudo raspi-config
```

Turn off the device:

```bash
sudo poweroff
```

Restart the device:

```bash
sudo reboot
sudo shutdown -r now
```

Schedule shutdown:

```bash
sudo shutdown -h 21:00
```

Update packages:

```bash
sudo apt update && sudo apt upgrade -y
```

Update Raspberry Pi EEPROM:

```bash
sudo rpi-eeprom-update -a
```

## SSD Boot Notes Worth Preserving

Your old notes indicate that SSD boot and boot order tuning were already part of the setup.

Useful commands to preserve:

Edit EEPROM config:

```bash
sudo rpi-eeprom-config --edit
```

Depending on your desired priority, boot order values may differ.

Because these values are hardware- and setup-dependent, verify them against current Raspberry Pi documentation before changing them again.

## PCIe Gen 3 SSD Tuning Notes Worth Preserving

Your old notes also showed that you enabled PCIe Gen 3 on Raspberry Pi 5 for higher SSD throughput.

Relevant config file noted in your setup:

```bash
sudo nano /boot/firmware/config.txt
```

Relevant settings under `[all]`:

```conf
dtparam=pciex1
dtparam=pciex1_gen=3
```

Then reboot:

```bash
sudo reboot
```

This is worth keeping in the learning repo because it is a real performance optimization detail, not just generic theory.

## Storage Benchmark Reference

Your old notes referenced PiBenchmarks for storage validation.

Benchmark command:

```bash
sudo curl https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh | sudo bash
```

This is useful after:

- moving from microSD to SSD
- enabling PCIe Gen 3
- changing enclosure or storage hardware

## Portainer Notes

Your old notes also included a Portainer setup.

That is useful, but it should be treated as optional.

Portainer can help if you want a GUI for containers.

It is not required for learning Docker properly.

Good use:

- quick visual inspection
- container restart
- volume and stack overview

Bad use:

- replacing understanding of CLI commands

## What To Add To The Learning Repo From Old Notes

Keep in learning materials:

- recovery flow from old IP/hostname notes
- `raspi-config`
- power and reboot commands
- EEPROM update command
- SSD boot order notes
- PCIe Gen 3 tuning note
- benchmark command
- optional Portainer install

Do not keep in learning materials:

- old passwords
- copied private credentials
- any secret that could still work today

## Practical Next Step

If you are trying to log in right now, use this order:

1. `ssh rsidletskyi@pi5.local`
2. `ssh rsidletskyi@192.168.0.108`
3. check router client list
4. after login, run the inspection commands and normalize the setup into the new repo structure