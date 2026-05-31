# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Own ZSH Configuration
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load modular configs
# Derive dotfiles location from .zshrc symlink
if [ -L "${HOME}/.zshrc" ]; then
    DOTFILES="$(dirname "$(readlink "${HOME}/.zshrc")")"
else
    DOTFILES="${HOME}/dotfiles"
fi

[ -f "$DOTFILES/path.zsh" ] && source "$DOTFILES/path.zsh"
[ -f "$DOTFILES/aliases.zsh" ] && source "$DOTFILES/aliases.zsh"
[ -f "$DOTFILES/functions.zsh" ] && source "$DOTFILES/functions.zsh"
[ -f "$DOTFILES/check-updates.zsh" ] && source "$DOTFILES/check-updates.zsh"

# Environment variables
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_historys
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Case-insensitive completion
autoload -Uz compinit && compinit
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Custom prompt
[ -f "$DOTFILES/prompt.zsh" ] && source "$DOTFILES/prompt.zsh"

# Load any local overrides (not tracked in git)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
