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

What it actually does:

- keeps your shell session alive even if SSH disconnects
- lets you split one terminal into multiple panes
- helps you keep long-running work open in the background

Why it matters on Raspberry Pi:

- SSH sessions drop sometimes
- long logs, installs, and Docker commands should not die with the connection

Quick commands:

```bash
tmux new -s lab          # create new session named lab
tmux ls                  # list sessions
tmux attach -t lab       # reconnect to session
tmux kill-session -t lab # remove session
```

Most useful keyboard shortcuts inside tmux:

- `Ctrl+b` then `d` : detach from session
- `Ctrl+b` then `"` : split horizontally
- `Ctrl+b` then `%` : split vertically
- `Ctrl+b` then arrow key : move between panes

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

What it actually does:

- shows CPU, RAM, swap, process list, and per-process usage
- lets you sort processes interactively
- lets you kill a bad process without remembering its PID first

Quick actions:

```bash
htop
```

Useful keys inside `htop`:

- `F6` : choose sort column
- `F4` : filter processes by name
- `F9` : kill selected process
- `F10` : quit

### `btop`

More modern and clearer system monitor than `htop`.

Good for:

- cleaner CPU, memory, and disk graphs
- easier visual inspection during Docker work

Run:

```bash
btop
```

What it actually does:

- shows CPU, memory, disks, network, and process list in a more visual layout
- makes it easier to spot resource spikes quickly

When I would use it instead of `htop`:

- when you want to understand whether Docker or Airflow is eating RAM
- when you want a clearer overview, not just a process table

Quick actions:

```bash
btop
```

Useful keys inside `btop`:

- `Esc` or `q` : quit
- `f` : filter process list
- `m` : switch memory view options
- `p` : switch process sorting options

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

What it actually does:

- opens a two-panel file manager inside the terminal
- lets you copy, move, rename, and delete files faster than raw shell commands
- gives you a built-in file viewer and editor launcher

Why it is useful on Pi:

- runtime folders get messy quickly
- it is much faster to inspect `/srv/rs-data-platform` visually with `mc`

Quick actions:

```bash
mc
```

Most useful keys inside `mc`:

- `Tab` : switch panel
- `F3` : view file
- `F4` : edit file
- `F5` : copy
- `F6` : move/rename
- `F8` : delete
- `F10` : quit

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

What it actually does:

- searches inside files recursively and very fast
- is much better than old `grep -R` for everyday code and config search

Quick commands:

```bash
rg airflow /srv/rs-data-platform/repo/rs-data-platform-roadmap
rg MINIO_ROOT_PASSWORD /srv/rs-data-platform
rg "dag_id=|dag_id\s*=\s*" /srv/rs-data-platform/repo/rs-data-platform-roadmap
rg --glob '*.yml' portainer /srv/rs-data-platform/repo/rs-data-platform-roadmap
```

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

What it actually does:

- finds files and directories by name patterns
- is a cleaner, faster replacement for many common `find` commands

Quick commands:

```bash
fdfind docker /srv/rs-data-platform
fdfind compose /srv/rs-data-platform/repo
fdfind '.env' /srv/rs-data-platform
fdfind -e py dag /srv/rs-data-platform/repo/rs-data-platform-roadmap
```

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

What it actually does:

- prints file contents with syntax highlighting and line numbers
- makes reading config and code files much easier than plain `cat`

Quick commands:

```bash
batcat --paging=never /etc/os-release
batcat --paging=never docker-compose.yml
batcat --paging=never /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

### `vim`

Keep at least one more editor installed besides `nano`.

Use it when:

- you need fast inline edits over SSH
- you work on servers without GUI tools

What it actually does:

- gives you a faster modal editor for server work
- is useful when you want more control than `nano`

Very short survival guide:

```bash
vim /etc/hostname
```

Minimal keys you need:

- `i` : enter insert mode
- `Esc` : leave insert mode
- `:w` : save
- `:q` : quit
- `:wq` : save and quit
- `:q!` : quit without saving

### `ncdu`

Interactive disk usage viewer.

Command:

```bash
ncdu /srv/rs-data-platform
```

Use it for:

- finding what is eating disk on SSD
- inspecting Docker/runtime growth

What it actually does:

- scans a directory and shows disk usage interactively
- helps you find which folders consume the most storage

Quick commands:

```bash
ncdu /srv/rs-data-platform
ncdu /srv/rs-data-platform/runtime
ncdu /var/lib/docker
```

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

What it actually does:

- formats and filters JSON directly in the terminal
- is extremely useful for APIs, logs, and config outputs

Quick commands:

```bash
cat sample.json | jq
cat sample.json | jq '.items[0]'
curl -s http://localhost:9000/minio/health/live | jq
```

Note:

- `jq` only works on valid JSON
- it will not help with HTML or plain text responses

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

What it actually does:

- shows which process has a file or network port open
- is one of the fastest ways to debug “what is using this port?”

Quick commands:

```bash
sudo lsof -i :8088
sudo lsof -i :9001
sudo lsof -iTCP -sTCP:LISTEN -P -n
```

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

What they actually do:

- `net-tools` gives you commands like `ifconfig` and `netstat`
- `dnsutils` gives you commands like `dig` for DNS troubleshooting

Quick commands:

```bash
ifconfig
netstat -tulpn
dig pi5.local
dig google.com
```

### `python3-venv`

Required for clean Python virtual environments.

Use it for:

- MinIO client examples
- ETL scripts
- sandbox Python tools on the Pi

What it actually does:

- lets you create isolated Python environments per project
- prevents mixing all Python packages into the system interpreter

Quick commands:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
deactivate
```

### `sqlite3`

Useful lightweight local database CLI.

Use it for:

- small experiments
- inspecting local sqlite files
- quick SQL practice without a full server

What it actually does:

- opens sqlite database files directly in the terminal
- gives you a tiny SQL environment without running PostgreSQL or MySQL

Quick commands:

```bash
sqlite3 demo.db
sqlite3 demo.db '.tables'
sqlite3 demo.db 'select 1;'
```

## Fast Everyday Workflows

### Find A Config Value Fast

```bash
rg AIRFLOW__DATABASE__SQL_ALCHEMY_CONN /srv/rs-data-platform
```

### Find A Compose File Fast

```bash
fdfind docker-compose /srv/rs-data-platform/repo
```

### Inspect A Config File Nicely

```bash
batcat --paging=never /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

### Watch Host Health While Working

```bash
btop
```

### Inspect Runtime Folders Visually

```bash
mc /srv/rs-data-platform
```

### Keep Work Alive Over SSH

```bash
tmux new -s lab
```

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

## Recommended Aliases For Daily Pi Work

If you use the Raspberry Pi often, this slightly bigger alias block is worth keeping in `~/.bashrc`:

```bash
cat <<'EOF' >> ~/.bashrc
alias bat='batcat --paging=never'
alias fd='fdfind'
alias ll='ls -lah'
alias ports='sudo lsof -iTCP -sTCP:LISTEN -P -n'
alias croot='cd /srv/rs-data-platform'
alias crepo='cd /srv/rs-data-platform/repo/rs-data-platform-roadmap'
alias crun='cd /srv/rs-data-platform/runtime'
alias ccompose='cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker compose logs --tail=100'
EOF

source ~/.bashrc
```

Why these aliases help:

- `bat` : easier file reading with syntax highlight
- `fd` : easier fast file search
- `ll` : readable file listings
- `ports` : quick view of listening services
- `croot`, `crepo`, `crun`, `ccompose` : fast navigation to important Pi folders
- `dps` : compact Docker container overview
- `dlog` : quick recent compose logs

Quick examples:

```bash
crepo
fd docker
bat README.md
ports
ccompose
dps
dlog
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