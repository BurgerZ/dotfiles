# Command aliases

# Shortcuts
alias zshconfig='$EDITOR ~/.zshrc'
alias help='use-my-mac'

# Dotfiles shortcut (derives location from .zshrc symlink)
dotfiles() {
    if [ -L "${HOME}/.zshrc" ]; then
        cd "$(dirname "$(readlink "${HOME}/.zshrc")")"
    else
        cd "${HOME}/dotfiles"
    fi
}

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# System Utilities
alias c='clear'
alias h='history | tail -20'
alias path='echo $PATH | tr ":" "\n"'
alias myip='curl ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias cleanup='find . -name ".DS_Store" -delete'
alias hosts='sudo nvim /etc/hosts'
alias brewup='brew update && brew upgrade && brew cleanup'

# Network Diagnostics
alias domaininfo='bun /Users/$USER/dotfiles/scripts/domain-info.ts'

# Claude
_claude_bin() {
  local bin="${HOME}/.local/bin/claude"
  if [[ -x "$bin" ]]; then
    echo "$bin"
  else
    find /opt/homebrew/Caskroom/claude-code -maxdepth 2 -name "claude" -type f 2>/dev/null | sort -V | tail -1
  fi
}
claude() {
  local bin
  bin=$(_claude_bin)
  [[ -z "$bin" ]] && { echo "claude: binary not found" >&2; return 1; }
  "$bin" --dangerously-skip-permissions "$@"
}
claude-safe() {
  local bin
  bin=$(_claude_bin)
  [[ -z "$bin" ]] && { echo "claude: binary not found" >&2; return 1; }
  "$bin" "$@"
}
alias cc='claude'
alias cc-safe='claude-safe'

# Bun shortcuts
alias br='bun run'
alias bi='bun install'
alias ba='bun add'
alias brm='bun remove'
alias bt='bun test'
