# ~/.bashrc

# Source global Bash definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

# User-specific local binaries
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Environment Modules / MPI
source /etc/profile.d/modules.sh
module load mpi/openmpi-x86_64

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi

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

# Environment variables
export EDITOR=nvim
export VISUAL=nvim

# Commonly used functions

homelab() {
    if nc -z -w 1 192.168.29.19 22 2>/dev/null; then
        ssh homelab-lan
    else
        ssh homelab-ts
    fi
}
