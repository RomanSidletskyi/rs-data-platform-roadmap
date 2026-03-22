# Solution - Static IP And Remote Access

This solution uses the simplest recommended setup:

- Raspberry Pi gets a reserved IP from the router
- macOS connects with SSH key auth
- the laptop uses an SSH alias `rpi-lab`

## 1. Generate SSH Key On macOS

If you do not already have a key:

```bash
ssh-keygen -t ed25519 -C "rpi-lab"
```

Press Enter through the prompts or set a passphrase if you want one.

## 2. Copy The Key To Raspberry Pi

If hostname works:

```bash
ssh-copy-id piuser@rpi-lab.local
```

If hostname does not work yet, use the IP:

```bash
ssh-copy-id piuser@192.168.1.50
```

## 3. Test Passwordless Login

```bash
ssh piuser@rpi-lab.local
```

Or by IP:

```bash
ssh piuser@192.168.1.50
```

You should not be asked for the account password again.

## 4. Add SSH Alias On macOS

Edit `~/.ssh/config` on your Mac and add:

```sshconfig
Host rpi-lab
    HostName 192.168.1.50
    User piuser
    IdentityFile ~/.ssh/id_ed25519
```

Now test it:

```bash
ssh rpi-lab
```

## 5. Make The IP Stable

Preferred approach:

- open your router admin page
- find DHCP reservation or address reservation
- bind Raspberry Pi MAC address to `192.168.1.50`

If your router cannot do that, use static IP on Raspberry Pi.

On Raspberry Pi edit:

```bash
sudo nano /etc/dhcpcd.conf
```

Add something like this at the end:

```conf
interface eth0
static ip_address=192.168.1.50/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 1.1.1.1
```

Then reboot:

```bash
sudo reboot
```

Adjust the addresses to your network.

## 6. Optional VS Code Remote SSH

After `ssh rpi-lab` works, you can use VS Code Remote SSH and connect to host `rpi-lab`.

## 7. Definition Of Done Check

Run:

```bash
ssh rpi-lab
ping -c 3 192.168.1.50
```

This task is complete if:

- Raspberry Pi is reachable with a stable IP
- `ssh rpi-lab` works
- SSH keys are configured
- you do not need to rediscover the IP every time