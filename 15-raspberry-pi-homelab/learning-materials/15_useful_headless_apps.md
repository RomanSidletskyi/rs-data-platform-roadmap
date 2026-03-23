# Useful Headless Apps For Daily Raspberry Pi Work

This note collects a small set of practical applications that make a headless Raspberry Pi much easier to use.

The focus is not desktop software.

The focus is daily terminal work for:

- navigation
- monitoring
- file inspection
- search
- remote maintenance

## Recommended Set

Install this group first:

```bash
sudo apt update
sudo apt install -y \
  tmux htop btop mc tree ncdu \
  ripgrep fd-find bat vim \
  jq rsync lsof net-tools dnsutils \
  python3-venv sqlite3
```

## Must-Have Minimal Block

If you want only the highest-value tools first, install this smaller set:

```bash
sudo apt update
sudo apt install -y tmux btop mc ripgrep fd-find python3-venv
```

This is the smallest set I would install on a headless Raspberry Pi for daily work.

## One-Command Install Script

This repository now includes a small helper script for that minimal set:

`shared/scripts/setup/raspberry-pi/install-headless-apps.sh`

Run it on Raspberry Pi:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-headless-apps.sh
```

What it installs:

- `tmux`
- `btop`
- `mc`
- `ripgrep`
- `fd-find`
- `python3-venv`

It also prints a short reminder about the Raspberry Pi OS command names:

- `fdfind` instead of `fd`
- `batcat` instead of `bat` when `bat` is installed later

## Extended Install Script

If you want the fuller everyday toolbox, use the extended script:

`shared/scripts/setup/raspberry-pi/install-extended-headless-apps.sh`

Run it on Raspberry Pi:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-extended-headless-apps.sh
```

What it installs:

- `tmux`
- `htop`
- `btop`
- `mc`
- `tree`
- `ncdu`
- `ripgrep`
- `fd-find`
- `bat`
- `vim`
- `jq`
- `rsync`
- `lsof`
- `net-tools`
- `dnsutils`
- `python3-venv`
- `sqlite3`

Use the extended script if the Pi is already your main remote lab host and you want a more complete terminal toolbox from the start.

## Why These Apps Are Worth It

### `tmux`

Use it when you want persistent terminal sessions over SSH.

Good for:

- long-running commands
- reconnecting after network drops
- keeping logs open in one pane and commands in another

Useful start:

```bash
tmux new -s lab
```

### `htop`

Simple interactive system monitor.

Good for:

- CPU and memory overview
- seeing which process is consuming RAM
- fast service/process inspection

Run:

```bash
htop
```

### `btop`

More modern and clearer system monitor than `htop`.

Good for:

- cleaner CPU, memory, and disk graphs
- easier visual inspection during Docker work

Run:

```bash
btop
```

### `mc`

Midnight Commander, a terminal file manager.

Good for:

- browsing directories quickly
- moving files without long shell commands
- editing runtime folders on a headless host

Run:

```bash
mc
```

### `ripgrep`

Fast recursive text search.

Command:

```bash
rg airflow /srv/rs-data-platform/repo/rs-data-platform-roadmap
```

Use it for:

- finding config values
- searching compose files
- locating DAG IDs and environment variables

### `fd-find`

Fast file search.

On Debian and Raspberry Pi OS the command is usually `fdfind`, not `fd`.

Command:

```bash
fdfind docker /srv/rs-data-platform
```

Use it for:

- finding compose files
- locating logs or scripts
- replacing slow `find` usage for common cases

### `bat`

Better `cat` with syntax highlighting.

On Debian and Raspberry Pi OS the command is usually `batcat`.

Command:

```bash
batcat --paging=never /etc/os-release
```

Use it for:

- reading config files
- inspecting YAML, shell, Python, and markdown files

### `vim`

Keep at least one more editor installed besides `nano`.

Use it when:

- you need fast inline edits over SSH
- you work on servers without GUI tools

### `ncdu`

Interactive disk usage viewer.

Command:

```bash
ncdu /srv/rs-data-platform
```

Use it for:

- finding what is eating disk on SSD
- inspecting Docker/runtime growth

### `jq`

JSON processor.

Command:

```bash
cat sample.json | jq
```

Use it for:

- API payload inspection
- pretty-printing config output
- filtering JSON from scripts

### `lsof`

See which process owns a file or port.

Commands:

```bash
sudo lsof -i :8088
sudo lsof -i :9001
```

Use it for:

- port conflict debugging
- understanding what is listening where

### `net-tools` and `dnsutils`

These give you older but still useful network commands.

Examples:

```bash
ifconfig
netstat -tulpn
dig pi5.local
```

Use them for:

- quick network checks
- hostname resolution debugging
- service exposure checks

### `python3-venv`

Required for clean Python virtual environments.

Use it for:

- MinIO client examples
- ETL scripts
- sandbox Python tools on the Pi

### `sqlite3`

Useful lightweight local database CLI.

Use it for:

- small experiments
- inspecting local sqlite files
- quick SQL practice without a full server

## Suggested Install Priority

If you do not want everything at once, install in this order:

1. `tmux`
2. `btop`
3. `mc`
4. `ripgrep`
5. `fd-find`
6. `bat`
7. `python3-venv`

## Practical Minimal Set For Your Homelab

If I had to keep only a few, I would keep:

- `tmux`
- `btop`
- `mc`
- `ripgrep`
- `fd-find`
- `python3-venv`

That set gives the biggest quality-of-life improvement for Raspberry Pi terminal work.

## Optional Shell Aliases

Because Debian package names and command names are not always aligned, these aliases are useful:

```bash
echo "alias bat='batcat --paging=never'" >> ~/.bashrc
echo "alias fd='fdfind'" >> ~/.bashrc
source ~/.bashrc
```

## Quick Verification

After installation, these commands should work:

```bash
tmux -V
btop --version
mc --version
rg --version
fdfind --version
batcat --version
python3 -m venv --help
sqlite3 --version
```

## What I Would Not Install First

Avoid turning the Pi into a random toolbox full of rarely used packages.

Do not start with:

- heavy desktop applications
- large monitoring suites before you need them
- many overlapping editors and file managers

Keep the host small, predictable, and easy to maintain.