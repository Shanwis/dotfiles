# ~/.bashrc

# Source global Bash definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

# User-specific local binaries
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Go
export PATH="/usr/local/go/bin:$PATH"

# Environment Modules / MPI
if [ -f /etc/profile.d/modules.sh ]; then
    source /etc/profile.d/modules.sh
    module load mpi/openmpi-x86_64 2>/dev/null || true
fi

# Node Version Manager (NVM) - Lazy loaded for fast shell startup
export NVM_DIR="$HOME/.nvm"

_load_nvm() {
    unset -f nvm node npm npx corepack _load_nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm() { _load_nvm; npm "$@"; }
npx() { _load_nvm; npx "$@"; }
corepack() { _load_nvm; corepack "$@"; }

# Rust / Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$HOME/android-studio/bin:$PATH"

# Neovim
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

# Julia
export PATH="/opt/julia/bin:$PATH"

# OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# Starship prompt
eval "$(starship init bash)"

# zoxide prompt
eval "$(zoxide init bash)"

# Environment variables
export EDITOR=nvim
export VISUAL=nvim

# Commonly used functions

homelab() {
    if nc -z -w 1 192.168.29.19 22 2>/dev/null; then
        echo "Connecting locally..."
        ssh homelab-lan
    else
        echo "Connecting with tailscale..."
        ssh homelab-ts
    fi
}

# Atuin history
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin &>/dev/null && eval "$(atuin init bash)"
