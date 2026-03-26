# First 15 Minutes On Pi

## Purpose

This note is the shortest practical checklist for the first session after Raspberry Pi boots and you can log in.

Use it when you need to:

- log in for the first time
- understand how to leave the session safely
- reboot or shut down correctly
- move through folders
- run the minimum useful checks on the host

## 1. First Login

If you are on the same local network, connect by hostname:

```bash
ssh rsidletskyi@pi5.local
```

If `.local` does not resolve, connect by IP:

```bash
ssh rsidletskyi@192.168.1.110
```

At first login:

- type `yes` if SSH asks to trust the host fingerprint
- enter the user password

## 2. Minimum Commands Right After Login

Run these first:

```bash
whoami
hostname
hostname -I
pwd
ls -lah
df -h
free -h
uname -a
```

This confirms:

- which user you are using
- which machine you are on
- current IP address
- current folder
- free disk space
- free memory

## 3. How To Move Around The Filesystem

Show current folder:

```bash
pwd
```

List files in current folder:

```bash
ls
ls -lah
```

Go to home folder:

```bash
cd
```

Go to a specific folder:

```bash
cd /srv/rs-data-platform
```

Go one level up:

```bash
cd ..
```

Go to the previous folder:

```bash
cd -
```

## 4. Basic File Operations

Create a folder:

```bash
mkdir test-dir
mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs/shared}
```

Create an empty file:

```bash
touch notes.txt
```

Copy a file:

```bash
cp notes.txt notes.bak.txt
```

Move or rename a file:

```bash
mv notes.bak.txt notes-old.txt
```

Remove a file:

```bash
rm notes-old.txt
```

Remove an empty folder:

```bash
rmdir test-dir
```

## 5. Read And Edit Files

Show file contents:

```bash
cat /etc/hostname
```

Read a long file safely:

```bash
less /etc/ssh/sshd_config
```

Edit a file:

```bash
nano ~/.ssh/config
```

Save in `nano`:

1. `Ctrl + O`
2. `Enter`
3. `Ctrl + X`

## 6. Update And Restart The Host

Update package metadata:

```bash
sudo apt update
```

Upgrade installed packages:

```bash
sudo apt full-upgrade -y
```

Reboot the Raspberry Pi:

```bash
sudo reboot
```

Power it off safely:

```bash
sudo shutdown now
```

## 7. Exit The Raspberry Pi Console Safely

If you are inside an SSH session:

```bash
exit
```

or press:

```text
Ctrl + D
```

If you started a foreground process and want to stop it:

```text
Ctrl + C
```

## 8. Browser Access Versus SSH Access

SSH gives shell access to the operating system.

Browser access is only for services that expose a web UI on a port.

Examples:

```text
http://192.168.1.110:3000
http://192.168.1.110:8080
https://192.168.1.110:9443
```

If no service is running on that port, nothing useful will open in the browser.

## 9. First Useful Directories To Know

Your home directory:

```text
/home/rsidletskyi
```

Repository runtime base:

```text
/srv/rs-data-platform
```

SSH configuration on Raspberry Pi:

```text
~/.ssh/
```

## 10. Short Version

First login:

```bash
ssh rsidletskyi@pi5.local
```

Quick checks:

```bash
whoami
hostname
hostname -I
pwd
ls -lah
df -h
free -h
```

Useful navigation:

```bash
cd
cd /srv/rs-data-platform
cd ..
cd -
```

Update and reboot:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Exit session:

```bash
exit
```