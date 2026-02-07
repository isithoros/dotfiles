#!/bin/bash
# install-wsl.sh
# Run inside Arch WSL: chmod +x install-wsl.sh && ./install-wsl.sh
#
# Creates symlinks from dotfiles repo to actual config locations.
# Existing files are backed up with .bak extension.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Install (WSL) ==="
echo "Dotfiles directory: $DOTFILES_DIR"

link_file() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak"
        echo "  Backed up: $dst -> ${dst}.bak"
    elif [ -L "$dst" ]; then
        rm "$dst"
        echo "  Removed old symlink: $dst"
    fi

    ln -sf "$src" "$dst"
    echo "  Linked: $dst -> $src"
}

# --- Zsh ---
echo -e "\n[Zsh]"
link_file "$DOTFILES_DIR/windows/wsl/zsh/.zshrc" "$HOME/.zshrc"

# --- Starship ---
echo -e "\n[Starship]"
link_file "$DOTFILES_DIR/windows/wsl/starship/starship.toml" "$HOME/.config/starship.toml"

# --- Yazi ---
echo -e "\n[Yazi]"
link_file "$DOTFILES_DIR/windows/wsl/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# Download Catppuccin Mocha Blue theme for yazi if not present
if [ ! -f "$HOME/.config/yazi/theme.toml" ]; then
    echo "  Downloading Catppuccin Mocha Blue theme for yazi..."
    curl -sL https://raw.githubusercontent.com/catppuccin/yazi/main/themes/mocha/catppuccin-mocha-blue.toml \
        -o "$HOME/.config/yazi/theme.toml"
    echo "  Downloaded yazi theme."
fi

# --- Git ---
echo -e "\n[Git]"
if [ ! -f "$HOME/.gitconfig" ]; then
    cp "$DOTFILES_DIR/shared/git/.gitconfig.template" "$HOME/.gitconfig"
    echo "  Copied .gitconfig.template -> ~/.gitconfig"
else
    echo "  ~/.gitconfig already exists, skipping (check template manually)"
fi

if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat > "$HOME/.gitconfig.local" << 'EOF'
[user]
    name = CHANGEME
    email = CHANGEME@example.com
EOF
    echo "  Created ~/.gitconfig.local — EDIT THIS with your name/email!"
fi

# Create directory structure for multiple git accounts
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/work"
mkdir -p "$HOME/personal"

if [ ! -f "$HOME/.config/git/work.gitconfig" ]; then
    cat > "$HOME/.config/git/work.gitconfig" << 'EOF'
[user]
    name = CHANGEME
    email = CHANGEME@work.com
EOF
    echo "  Created ~/.config/git/work.gitconfig — EDIT THIS!"
fi

if [ ! -f "$HOME/.config/git/personal.gitconfig" ]; then
    cat > "$HOME/.config/git/personal.gitconfig" << 'EOF'
[user]
    name = CHANGEME
    email = CHANGEME@personal.com
EOF
    echo "  Created ~/.config/git/personal.gitconfig — EDIT THIS!"
fi

echo -e "\n=== WSL symlinks complete! ==="
echo ""
echo "IMPORTANT: Edit these files with your actual info:"
echo "  ~/.gitconfig.local              (default git identity)"
echo "  ~/.config/git/work.gitconfig    (work repos in ~/work/)"
echo "  ~/.config/git/personal.gitconfig (personal repos in ~/personal/)"
