# Solution - Static IP And Remote Access

This solution uses the simplest recommended setup after SSH keys already work:

- Raspberry Pi gets a reserved IP from the router
- macOS connects with SSH key auth
- the laptop uses an SSH alias such as `pi5`

## 1. Confirm Current Access

Before changing IP behavior, confirm that SSH already works:

```bash
ssh pi5
hostname -I
```

## 2. Keep Or Adjust SSH Alias On macOS

Edit `~/.ssh/config` on your Mac and ensure it contains something like:

```sshconfig
Host pi5
    HostName pi5.local
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

Now test it:

```bash
ssh pi5
```

## 3. Make The IP Stable

Preferred approach:

- open your router admin page
- find DHCP reservation or address reservation
- bind Raspberry Pi MAC address to a stable address such as `192.168.1.110`

If your router cannot do that, use static IP on Raspberry Pi.

On Raspberry Pi edit:

```bash
sudo nano /etc/dhcpcd.conf
```

Add something like this at the end:

```conf
interface eth0
static ip_address=192.168.1.110/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 1.1.1.1
```

Then reboot:

```bash
sudo reboot
```

Adjust the addresses to your network.

## 4. Optional VS Code Remote SSH

After `ssh pi5` works, you can use VS Code Remote SSH and connect to host `pi5`.

## 5. Definition Of Done Check

Run:

```bash
ssh pi5
ping -c 3 192.168.1.110
```

This task is complete if:

- Raspberry Pi is reachable with a stable IP
- `ssh pi5` works
- you do not need to rediscover the IP every time