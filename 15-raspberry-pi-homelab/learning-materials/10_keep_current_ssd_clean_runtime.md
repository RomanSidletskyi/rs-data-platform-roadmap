# Keep Current SSD OS And Clean Runtime State

This note is for the case where:

- the Raspberry Pi is already booting correctly from SSD
- you do not want to reinstall the operating system right now
- you do want to remove old Docker and runtime state
- you want a clean baseline for this repository

This path keeps the SSD OS but discards old application-level state.

## When This Path Is Correct

Use this path if:

- the SSD boot is already correct
- SSH works
- the OS itself is acceptable
- old containers, volumes, or GUI tools are the real clutter

Do not use this path if you want a truly fresh OS image.

## Current Situation In Your Case

You already confirmed:

- root filesystem is on `nvme0n1p2`
- the Raspberry Pi is booting from SSD
- Docker is installed
- an old Portainer container is still running

That means the boot path is already correct.

The cleanup target is now:

- old Docker containers
- old Docker images
- old Docker volumes
- old Docker networks not needed anymore
- old runtime directories and logs you no longer care about

## Recommended Order

Use this order:

1. inspect the current Docker state
2. stop and remove old containers
3. prune unused Docker objects
4. create the new repository runtime layout
5. update the OS
6. continue with the new repo workflow

## Step 1 - Inspect Current Docker State

Run on Raspberry Pi:

```bash
docker ps -a
docker image ls
docker volume ls
docker network ls
docker system df
```

This gives you a final look before deleting runtime state.

## Step 2 - Remove Old Portainer

If you do not want to keep Portainer:

```bash
docker stop portainer || true
docker rm -f portainer || true
docker volume rm portainer_data || true
```

This removes the current Portainer container and its named volume if present.

## Step 3 - Remove Any Other Old Containers

Stop and remove everything that still exists:

```bash
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true
```

If there are no containers, these commands safely do nothing.

## Step 4 - Prune Old Images, Networks, And Volumes

Run:

```bash
docker system prune -a -f
docker volume prune -f
```

This removes unused Docker artifacts and gives you a clean runtime baseline.

## Step 5 - Check That Docker Is Now Clean

Run:

```bash
docker ps -a
docker image ls
docker volume ls
docker network ls
docker system df
```

Expected result:

- no old containers
- no Portainer container
- only minimal remaining Docker state

## Step 6 - Create The New Repository Runtime Layout

Run:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R rsidletskyi:rsidletskyi /srv/rs-data-platform
mkdir -p /srv/rs-data-platform/configs/shared
```

This creates the new baseline expected by the repository docs.

## Step 7 - Update The Host

Run:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo rpi-eeprom-update -a
```

Then reboot:

```bash
sudo reboot
```

## Step 8 - Continue With The New Workflow

After reboot:

1. reconnect with SSH
2. set up SSH keys if not already done
3. clone the repository under `/srv/rs-data-platform/repo`
4. use the new config layout under `/srv/rs-data-platform/configs`
5. start only the new compose stacks you want to keep

## Optional Script

A helper script is available in the repository:

- `shared/scripts/setup/raspberry-pi/cleanup-docker-runtime.sh`

It automates the Docker cleanup part.

## Important Warning

This path deletes old Docker state.

That includes:

- old containers
- old images not currently needed
- old volumes when pruned

Only use it if you are sure you do not need the old setup.

## Minimal Command Set

If you want the shortest practical path:

```bash
docker stop portainer || true
docker rm -f portainer || true
docker volume rm portainer_data || true
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker system prune -a -f
docker volume prune -f
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R rsidletskyi:rsidletskyi /srv/rs-data-platform
mkdir -p /srv/rs-data-platform/configs/shared
```