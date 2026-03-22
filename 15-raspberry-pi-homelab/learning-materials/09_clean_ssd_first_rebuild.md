# Clean SSD-First Rebuild

This note is for the case where:

- Raspberry Pi already has an older setup
- you do not want to keep the old setup
- the operating system is already on SSD or you want SSD to be the main boot device
- a microSD card may still be inserted and may create confusion

If you want a truly clean system, the right mindset is:

- keep the hardware
- discard the old software state
- rebuild from a clean SSD-first baseline

## Recommendation

If you do not need anything from the old system, the cleanest approach is:

1. confirm whether the current system is booting from SSD or microSD
2. shut down the Raspberry Pi
3. remove the microSD card
4. boot from SSD only
5. if SSD boot works, continue from there
6. if you want a truly fresh system, re-image the SSD and start from scratch

This avoids ambiguous boot behavior and prevents you from cleaning the wrong storage device.

## Why Remove The microSD Card

If both SSD and microSD are present, you can easily lose track of:

- which device actually booted the OS
- which device holds the current root filesystem
- which storage you are about to wipe or clean

Removing the microSD card makes the boot path explicit.

## Step 1 - Check What Device You Are Booted From

While logged into the current system, run:

```bash
findmnt /
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
```

What to look for:

- if `/` is mounted from an SSD-backed device, you are already running from SSD
- if `/` is mounted from an SD-backed device, you are still booting from microSD

You can also inspect boot-related details with:

```bash
mount | grep ' on / '
```

## Step 2 - If You Want Clean, Stop Treating The Old Setup As Valuable

Do not spend time cleaning:

- old Portainer state
- old Docker containers
- old volumes
- old local configs

if you already know you do not want them.

A real clean baseline is simpler than selective cleanup.

## Step 3 - Shut Down And Remove The microSD Card

Run:

```bash
sudo poweroff
```

Then:

- unplug power
- remove the microSD card
- leave only the SSD connected

## Step 4 - Boot From SSD Only

Power the Raspberry Pi back on.

Try to connect again:

```bash
ssh rsidletskyi@pi5.local
```

If it boots and SSH works, you now know the SSD path is valid.

## Step 5 - Decide Between Two Clean Paths

### Path A - Keep Current SSD OS But Treat It As New Baseline

Use this if:

- the SSD boot works
- you are okay keeping the current OS install
- you just want to remove old app/runtime state later

This is faster, but not fully fresh.

### Path B - Re-image The SSD And Start Truly Clean

Use this if:

- you want a completely fresh system
- you do not trust the old OS state
- you do not want to reason about old packages, containers, or configs at all

This is the cleanest option.

If you said “I do not need anything old”, this is the better choice.

## Recommended Clean Path For Your Case

Based on your goal, the recommended path is:

- boot from SSD only
- if SSD boot works, re-image the SSD with Raspberry Pi OS Lite
- configure hostname, user, and SSH during imaging
- boot again with no microSD card inserted

That gives you a real clean system.

## Step 6 - Re-Image The SSD

Preferred method:

- connect the SSD to your main machine if possible
- use Raspberry Pi Imager
- write Raspberry Pi OS Lite to the SSD

Recommended settings during imaging:

- hostname: `pi5`
- username: `rsidletskyi`
- enable SSH
- set locale and timezone
- Wi-Fi only if needed

If Ethernet is available, prefer Ethernet.

## Step 7 - Boot The Fresh SSD System

After imaging:

- keep the microSD card out
- boot from SSD only
- wait for the system to come online
- connect with SSH

Example:

```bash
ssh rsidletskyi@pi5.local
```

## Step 8 - First Verification On The Fresh System

Run:

```bash
hostname
whoami
ip addr
findmnt /
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
df -h
free -h
docker --version
```

Expected outcome:

- hostname is correct
- user is correct
- boot root is on SSD-backed storage
- the old ambiguity with microSD is gone

## Step 9 - Only After The Clean Boot, Start Building The New Structure

Then create the new baseline:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R rsidletskyi:rsidletskyi /srv/rs-data-platform
```

Then continue with:

- SSH keys
- Docker install
- repo clone
- host-local config layout
- new compose stacks

## What To Do With The Old microSD Card

After the new SSD-based system is confirmed working, choose one:

1. keep it as an emergency recovery card
2. wipe it and reuse it for other experiments

If you keep it, label it clearly so you do not confuse it with the active system.

## What Not To Do

Do not:

- keep both storage devices inserted without knowing which one booted
- spend time repairing old containers if you already want a clean rebuild
- keep real credentials from the old system in notes
- start building new stacks before the boot path is unambiguous

## Practical Minimal Plan

If you want the shortest correct path:

1. run `findmnt /` and `lsblk`
2. power off
3. remove microSD card
4. boot SSD only
5. if SSD boot works, re-image SSD for a truly clean start
6. boot fresh SSD system
7. create `/srv/rs-data-platform/`
8. continue with the new repo workflow