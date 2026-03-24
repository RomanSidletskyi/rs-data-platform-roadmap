# Solution - First Session Linux Basics

This solution covers the minimum commands you should know after the first successful login to Raspberry Pi.

## 1. Log In

Use hostname if it works:

```bash
ssh rsidletskyi@pi5.local
```

Or use IP:

```bash
ssh rsidletskyi@192.168.1.110
```

## 2. Run Basic Checks

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

## 3. Move Around The Filesystem

```bash
cd
pwd
cd /srv
cd /srv/rs-data-platform
cd ..
cd -
```

## 4. Create And Remove Test Files

```bash
mkdir -p ~/pi-test-dir
cd ~/pi-test-dir
touch notes.txt
ls -lah
cp notes.txt notes-copy.txt
mv notes-copy.txt notes-old.txt
rm notes-old.txt
cd ..
rmdir ~/pi-test-dir
```

## 5. Edit A File In Nano

```bash
nano ~/test-config.txt
```

Type any small text, then save with:

1. `Ctrl + O`
2. `Enter`
3. `Ctrl + X`

Verify:

```bash
cat ~/test-config.txt
rm ~/test-config.txt
```

## 6. Reboot Or Exit

Reboot:

```bash
sudo reboot
```

Exit session:

```bash
exit
```

## 7. Definition Of Done Check

This task is complete if:

- you can log in and run basic checks
- you understand `pwd`, `ls`, and `cd`
- you can create and remove files safely
- you can save a file in `nano`
- you know how to exit the SSH session