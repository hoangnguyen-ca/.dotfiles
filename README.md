# Dotfiles for Ubuntu on WSL

Bash aliases, Homebrew packages, language tooling, LazyVim, Git, and a WezTerm configuration for an Ubuntu development environment on WSL2.

## 1. Prepare WSL

If WSL is not installed, run this in an administrator PowerShell window on Windows:

```powershell
wsl --install -d Ubuntu-24.04
```

Restart Windows if prompted, launch Ubuntu, and finish creating your Linux username and password. Run the remaining commands inside Ubuntu, as your regular user rather than root. The bootstrap targets Ubuntu and downloads an amd64 Go distribution, so these instructions assume an x86-64 machine.

Keep the checkout in the Linux home directory (`~/.dotfiles`), rather than under `/mnt/c`.

## 2. Clone the repository

```bash
sudo apt-get update
sudo apt-get install -y git ca-certificates

git clone https://github.com/hoangnguyen-ca/.dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
```

If the repository is private, authenticate with GitHub before cloning. If it is already cloned, use the existing checkout.

## 3. Back up existing configuration

The bootstrap appends to `~/.bashrc` and creates links for Git and Neovim configuration. Back up any existing files first. Move an existing Neovim configuration aside so the bootstrap can create its directory symlink correctly.

```bash
backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for config_file in .bashrc .profile .gitconfig; do
  if [ -e "$HOME/$config_file" ] || [ -L "$HOME/$config_file" ]; then
    cp -a "$HOME/$config_file" "$backup_dir/"
  fi
done

if [ -e "$HOME/.config/nvim" ] || [ -L "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$backup_dir/nvim"
fi
```

Review `.gitconfig` before proceeding: it contains the repository owner's Git name and email and uses Windows Git Credential Manager at `/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe`. Install Git for Windows at that location to use that helper, or adjust the configuration for your own setup.

## 4. Run the bootstrap

If Homebrew is already installed, initialize it first so the bootstrap can detect it:

```bash
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

cd "$HOME/.dotfiles"
bash ./bootstrap.sh
```

Enter your Linux password when `sudo` asks. Run this in an interactive terminal. Stay in the repository directory because the script uses relative paths for its Brewfile and language scripts.

The bootstrap performs the following operations, in order:

1. Updates APT metadata, upgrades installed Ubuntu packages, and installs `build-essential`, `procps`, `curl`, `file`, and `git`.
2. Installs Homebrew if `brew` is not on `PATH`, adds Homebrew initialization to `~/.bashrc`, and runs `brew update`.
3. Installs the packages in `Brewfile`: `git`, `wget`, `curl`, `neovim`, `lazygit`, `tree-sitter`, `tree`, `fzf`, `ripgrep`, `fd`, `unzip`, `zip`, and `luarocks`.
4. Installs SDKMAN if absent and adds its shell initialization. It does **not** install a Java JDK.
5. Installs nvm using the v0.40.3 installer if absent, adds nvm and completion initialization, installs the latest Node release if nvm finds none, and installs `tree-sitter-cli` globally through npm.
6. Installs Go 1.25.1 for Linux amd64 under `/usr/local/go` if no `go` command is found, and appends its bin directory to the shell PATH. Installing Go replaces any existing `/usr/local/go` directory.
7. Adds a command to source this repository's `.bashrc`, providing `ll`, `gs`, `gp`, and `gd` aliases.
8. Links `~/.config/nvim` to this repository's Neovim configuration and `~/.gitconfig` to its Git configuration.

The script stops on most errors. If it fails, resolve the reported problem and rerun it from this directory. It checks for existing initialization lines and installations, but rerunning still upgrades Ubuntu packages, updates Homebrew, and runs package installation commands.

## 5. Open a new shell and verify

Close and reopen your Ubuntu terminal to load the new shell configuration, then run:

```bash
command -v brew nvim git node npm go
brew --version
nvm --version
node --version
go version
sdk version
ls -ld "$HOME/.config/nvim" "$HOME/.gitconfig"
git config --global --get user.name
git config --global --get user.email
```

If `brew` is still missing, initialize it in the current shell:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

The bootstrap writes initialization to `~/.bashrc` only. For Bash login shells, ensure your `~/.profile` sources `~/.bashrc` (Ubuntu's default profile normally does). Shells and applications that read neither file need their own environment setup.

## 6. Finish language and editor setup

### Java

SDKMAN is installed, but a JDK must be selected separately:

```bash
sdk list java
# Replace <identifier> with an identifier shown in the list:
sdk install java <identifier>
java -version
```

### Neovim

```bash
nvim
```

The first launch bootstraps `lazy.nvim` and the configured LazyVim plugins. Allow downloads and installation to finish. Use `:Lazy` to inspect plugin installation and `:checkhealth` to inspect missing dependencies.

The configuration enables language extras for C/C++, Go, Java, Python, and TypeScript, plus debugging and testing extras. Editor extras do not guarantee that every language runtime, compiler, debugger, or project dependency is installed.

Automatic formatting is disabled. Smart-splits maps Alt+H/J/K/L to window movement and Alt+arrow keys to resizing. The sample `lua/plugins/example.lua` is disabled by an early return.

## 7. Optional: WezTerm

The repository includes `.wezterm.lua`, but the bootstrap does **not** install WezTerm or link this file.

For a Linux-side WezTerm installation, link it manually after backing up any existing configuration:

```bash
ln -s "$HOME/.dotfiles/.wezterm.lua" "$HOME/.wezterm.lua"
```

If you run WezTerm on Windows, place a copy of the configuration in your Windows user profile as `.wezterm.lua`, or configure your Windows WezTerm setup to load it. A link in the Linux home directory alone does not configure Windows WezTerm.

The configuration provides tab and pane shortcuts and smart-splits integration with Neovim. It does not configure a default WSL distribution or install fonts.

## Repository layout

| Path | Purpose |
| --- | --- |
| `bootstrap.sh` | Main Ubuntu setup and configuration linking |
| `Brewfile` | Homebrew package list |
| `scripts/java.sh` | SDKMAN installation and shell initialization |
| `scripts/node.sh` | nvm, Node, and global Tree-sitter CLI setup |
| `scripts/go.sh` | Go installation and PATH setup |
| `.bashrc` | Shell aliases |
| `.gitconfig` | Git identity and Windows credential helper |
| `.config/nvim/` | LazyVim configuration and plugin lockfile |
| `.wezterm.lua` | Optional WezTerm configuration |
