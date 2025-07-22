# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# ------------------------------------------------------------------------------
# 历史记录设置 (History Settings)
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1500000
SAVEHIST=1500000

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit load agkozak/zsh-z

zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma/fast-syntax-highlighting

# 自动建议
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

# 搜索
zinit ice lucid wait='0'
zinit light zsh-users/zsh-history-substring-search

zi ice wait lucid id-as"go-command"
zi snippet OMZP::golang


zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::qrcode
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::brew
zinit snippet OMZP::eza


zinit snippet OMZP::git
zinit snippet OMZP::svn
zinit snippet OMZP::vscode
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZP::copypath
zinit snippet OMZP::copyfile
zinit snippet OMZP::copybuffer
zinit snippet OMZP::brew
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found


export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

export WINEPREFIX=~/.wine
export VK_ICD_FILENAMES=/opt/homebrew/opt/vulkan-tools/lib/mock_icd/VkICD_mock_icd.json

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/libomp/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"
export PATH="$PATH:$HOME/.composer/vendor/bin"

export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig:/opt/homebrew/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib -L/opt/homebrew/opt/libomp/lib -L/opt/homebrew/opt/curl/lib -L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include -I/opt/homebrew/opt/curl/include -I/opt/homebrew/opt/libomp/include -I/opt/homebrew/opt/libomp/include"

export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix sqlite3)/lib -L$(brew --prefix xz)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix tcl-tk)/lib ${LDFLAGS}"
export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix readline)/include -I$(brew --prefix sqlite3)/include -I$(brew --prefix xz)/include -I$(brew --prefix zlib)/include -I$(brew --prefix tcl-tk)/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="$(brew --prefix curl)/lib/pkgconfig:$(brew --prefix openssl)/lib/pkgconfig:$(brew --prefix readline)/lib/pkgconfig:$(brew --prefix sqlite3)/lib/pkgconfig:$(brew --prefix xz)/lib/pkgconfig:$(brew --prefix zlib)/lib/pkgconfig:$(brew --prefix tcl-tk)/lib/pkgconfig:${PKG_CONFIG_PATH}"



zinit snippet https://raw.githubusercontent.com/CuminLo/Config/main/zsh/alias.zsh

# zinit light zdharma-continuum/fast-syntax-highlighting
# zinit load zsh-users/zsh-completions

zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid; zinit light marlonrichert/zsh-autocomplete

# 语法高亮插件必须最后加载
zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid; zinit light Aloxaf/fzf-tab

### End of Zinit's installer chunk

[ -f "$HOME/.zsh/export.zsh" ] && source "$HOME/.zsh/export.zsh"
[ -f "$HOME/.zsh/key_export.zsh" ] && source "$HOME/.zsh/key_export.zsh"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
#[ -f "$HOME/.zsh/alias.zsh" ] && source "$HOME/.zsh/alias.zsh"

# ------------------------------------------------------------------------------
# Powerlevel10k 主题配置 (Theme Configuration)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# ------------------------------------------------------------------------------
# 必须放在最后
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh