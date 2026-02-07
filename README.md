# Dotfiles

Personal dotfiles managed across Windows (GlazeWM + WezTerm + WSL Arch) and Arch Linux.

## Structure

```
dotfiles/
├── shared/              # Configs used on both systems
│   └── git/             # Git config templates
├── windows/             # Windows-specific configs
│   ├── wezterm/         # WezTerm terminal
│   ├── glazewm/         # GlazeWM tiling WM
│   ├── zebar/           # Zebar status bar
│   ├── vscode/          # VS Code settings
│   └── wsl/             # WSL Arch configs (zsh, starship, yazi)
├── arch/                # Arch Linux native configs (coming soon)
└── scripts/             # Install/setup scripts
```

## Setup

### Windows

1. Clone the repo:
   ```powershell
   git clone git@github.com:isithoros/dotfiles.git $env:USERPROFILE\dotfiles
   ```

2. Run the install script (PowerShell as admin):
   ```powershell
   cd $env:USERPROFILE\dotfiles
   .\scripts\install-windows.ps1
   ```

3. Set up Git identity (not stored in repo):
   ```powershell
   .\scripts\setup-git-identity.ps1
   ```

### WSL Arch

The Windows install script symlinks WSL configs automatically.
For Git identity inside WSL:
```bash
~/dotfiles/scripts/setup-git-identity.sh
```

### Switching Git Accounts (Arch Linux)

```bash
~/dotfiles/scripts/switch-git-account.sh --setup    # First time
~/dotfiles/scripts/switch-git-account.sh personal    # Switch to personal
~/dotfiles/scripts/switch-git-account.sh work         # Switch to work
```

Account details are stored in `~/.git-accounts/` (gitignored).

## Dependencies

### Windows
- WezTerm, GlazeWM, Zebar, VS Code, WSL + Arch Linux (ArchWSL)

### WSL Arch
- zsh + Oh My Zsh, Starship, yazi, Fresh editor, fzf, fd, eza, bat
