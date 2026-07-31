#!/usr/bin/env bash
# Symlink dotfiles from dotfiles directory to home directory
# This script is idempotent - safe to run multiple times

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Files to symlink
files=(
    ".p10k.zsh"
    ".zshrc"
    ".mackup.cfg"
    ".nanorc"
    "path.zsh"
    "aliases.zsh"
    "functions.zsh"
    "check-updates.zsh"
)

# Create symlinks
for file in "${files[@]}"; do
    source="$DOTFILES_DIR/$file"
    target="$HOME_DIR/$file"

    if [ -f "$source" ]; then
        # Check if already correctly symlinked
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            log_success "$file already linked"
            continue
        fi

        # Backup existing file if it exists and is not a symlink
        if [ -f "$target" ] && [ ! -L "$target" ]; then
            backup="$target.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target" "$backup"
            log_warning "Backed up existing $file to $(basename "$backup")"
        fi

        # Remove existing symlink if it's wrong
        [ -L "$target" ] && rm "$target"

        # Create symlink
        ln -s "$source" "$target"
        log_success "Linked $file"
    fi
done

# Create .gitignore_global
if [ ! -f "$HOME_DIR/.gitignore_global" ]; then
    cat > "$HOME_DIR/.gitignore_global" << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Editors
.vscode/
.idea/
*.swp
*.swo
*~
.*.sw[a-z]

# Node
node_modules/
npm-debug.log*
.npm

# Python bytecode (compiled files)
__pycache__/
*.py[cod]

# Virtual environments (local dependencies)
.venv/
venv/
env/
ENV/

# Env files
.env
.env.local
.env.*.local

# Logs
*.log

# Temporary
tmp/
temp/
EOF
    log_success "Created .gitignore_global"
else
    log_success ".gitignore_global already exists"
fi

# Remove stale tabtab completion blocks from .zshrc
ZSHRC="$DOTFILES_DIR/.zshrc"
if grep -q "tabtab source" "$ZSHRC" 2>/dev/null; then
    # Find each sourced tabtab completion path and remove the block if the file doesn't exist
    while IFS= read -r line; do
        path=$(echo "$line" | grep -oE '\[\[ -f [^ ]+' | sed 's/\[\[ -f //')
        if [ -n "$path" ] && [ ! -f "$path" ]; then
            pkg=$(echo "$line" | grep -oE 'tabtab source for \S+' | awk '{print $4}')
            log_warning "Removing stale tabtab completion for: $pkg"
            sed -i '' "/# tabtab source for $pkg/,/tabtab.*$pkg/d" "$ZSHRC"
        fi
    done < <(grep "tabtab source for" "$ZSHRC")
    log_success "Tabtab completions cleaned"
fi

log_success "Dotfiles installation complete!"
