# 1. Workstation (macOS)

Commands assume macOS on Apple Silicon with zsh. Linux and Windows notes are at the end.

Each step: **install**, **verify**, and **why**. Run the verification before moving on; most later problems come from a skipped check here.

## 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

- **Verify:** `brew --version`, `brew doctor` reports no blocking issues.
- **Why:** one package manager for CLIs, runtimes, and desktop apps, with one upgrade command (`brew upgrade`).

## 2. Shell Basics

- Configuration lives in `~/.zshrc` (interactive settings) and `~/.zprofile` (login PATH).
- After editing either file: `source ~/.zshrc` or open a new terminal.
- Project variables go in ignored env files, not in `~/.zshrc`. See [local env files workflow](../local-env-files-workflow.md).

## 3. Git and GitHub SSH Access

```bash
brew install git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true

ssh-keygen -t ed25519 -C "you@example.com"      # accept default path, set a passphrase
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub                    # paste in GitHub: Settings, SSH and GPG keys
```

- **Verify:** `ssh -T git@github.com` greets you by username.
- **Why:** SSH keys avoid typing tokens; the keychain keeps the passphrase.

## 4. VS Code

```bash
brew install --cask visual-studio-code
# In VS Code: Command Palette, "Shell Command: Install 'code' command in PATH"
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-toolsai.jupyter
code --install-extension redhat.vscode-yaml
code --install-extension bierner.markdown-mermaid
code --install-extension hediet.vscode-drawio
code --install-extension snowflake.snowflake-vsc
code --install-extension innoverio.vscode-dbt-power-user
```

Also install the Docker or Container Tools extension from the Marketplace (its ID has changed over time; search "Container Tools").

- **Verify:** `code --list-extensions` shows the list; Markdown preview renders Mermaid blocks.
- **Why:** Mermaid preview for the diagrams in this repository, the Snowflake extension for running SQL from the editor, Draw.io for hand-drawn diagrams.

## 5. Python

Use a recent Python from Homebrew and one virtual environment per project. Never install packages into the system Python.

```bash
brew install python@3.12
python3.12 --version

# Per project
cd <project folder>
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
deactivate
```

Optional, faster alternative: `brew install uv`, then `uv venv` and `uv pip install -r requirements.txt` in the project folder.

- **Verify:** inside an activated venv, `which python` points into `.venv/`.
- **Why:** each project pins its own dependencies; deleting `.venv` resets it completely.
- **VS Code:** Command Palette, "Python: Select Interpreter", choose the project's `.venv`.

## 6. Java 17

Spark, Flink, Kafka tooling, and Iceberg need a JDK.

```bash
brew install --cask temurin@17
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
source ~/.zshrc
```

- **Verify:** `java -version` prints 17; `echo $JAVA_HOME` is set.
- **Why:** Java 17 is supported by current Spark and Flink releases. If a module pins another version, `/usr/libexec/java_home -V` lists installed JDKs and you can switch `JAVA_HOME` per terminal.

## 7. Docker

Pick one runtime.

| Option | Install | Notes |
| --- | --- | --- |
| Docker Desktop | `brew install --cask docker`, then open Docker.app | Free for personal use, education, and small businesses; check the license terms for your situation |
| Colima | `brew install colima docker docker-compose`, then `colima start --cpu 4 --memory 8 --disk 60` | Open source, command-line only |

With Colima, tell the Docker CLI where the Compose plugin is:

```bash
mkdir -p ~/.docker
cat > ~/.docker/config.json <<'EOF'
{ "cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"] }
EOF
```

Resources: give Docker at least 4 CPUs and 8 GB of memory. Kafka plus Airflow on less memory fails in confusing ways.

- **Verify:** `docker run --rm hello-world` and `docker compose version`.
- **Why:** every local service in [Local services](03_local_services.md) runs in containers, so your machine stays clean.
- **Apple Silicon:** most images are multi-architecture. If an image is amd64-only, add `platform: linux/amd64` to its Compose service; it runs through emulation, more slowly.

## 8. Utilities

```bash
brew install jq yq graphviz kcat httpie tree wget
```

| Tool | Used for |
| --- | --- |
| `jq`, `yq` | Inspect JSON and YAML: API responses, CLI output, Compose files |
| `graphviz` | Render icon architecture diagrams (`dot`) |
| `kcat` | Produce and consume Kafka messages from the terminal |
| `httpie` | Readable HTTP calls to APIs (`http GET ...`) |

## 9. This Repository

```bash
git clone git@github.com:<you>/rs-data-platform-roadmap.git
cd rs-data-platform-roadmap
code templates/rs-data-platform-roadmap.code-workspace
./scripts/check_repo.sh structure
```

## 10. Verify the Whole Workstation

```bash
brew --version && git --version && code --version | head -1 \
  && python3.12 --version && java -version 2>&1 | head -1 \
  && docker --version && docker compose version && dot -V && jq --version
```

All commands should print a version. Fix any failure before installing cloud CLIs.

## Linux and Windows Notes

- **Linux:** use the distribution package manager for Git, Python, and Java; install Docker Engine from Docker's repository; everything else matches.
- **Windows:** use WSL 2 with Ubuntu and run every command inside WSL; install Docker Desktop with the WSL 2 backend; Power BI Desktop runs natively on Windows only.
