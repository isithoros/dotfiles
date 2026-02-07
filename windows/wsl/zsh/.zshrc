# Path
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Editor
export EDITOR="fresh"
export VISUAL="fresh"

# Disable theme since we use Starship
ZSH_THEME=""

# Plugins
plugins=(
  git
  gitfast
  history-substring-search
)

autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# ls replacement
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"

# Fix yazi on WezTerm WSL
export TERM_PROGRAM=""

function yazi() {
    stty -echo
    sleep 0.05
    stty echo
    command yazi "$@"
}

# SSH agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# Starship prompt
eval "$(starship init zsh)"
