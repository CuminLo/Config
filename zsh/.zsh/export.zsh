command_exists() { command -v "$1" >/dev/null 2>&1 }

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="/opt/homebrew/bin:$PATH"

# PHP
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command_exists pyenv; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command_exists procs; then
    source <(procs --gen-completion-out zsh)
fi

if command_exists fzf; then
    source <(fzf --zsh)
fi

if command_exists thefuck; then
    eval $(thefuck --alias)
fi

export GOOGLE_CLOUD_PROJECT="exalted-kayak-464110-t7"