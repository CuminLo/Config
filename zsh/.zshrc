# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# ------------------------------------------------------------------------------
# 历史记录设置 (History Settings)
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=500000
setopt APPEND_HISTORY       # 在会话之间追加历史，而不是覆盖
setopt SHARE_HISTORY        # 在所有打开的终端之间立即共享历史
setopt HIST_IGNORE_DUPS     # 忽略重复的命令
setopt HIST_IGNORE_SPACE    # 忽略以空格开头的命令

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

zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::history
zinit snippet OMZP::eza
zinit snippet OMZP::z
zinit snippet OMZP::brew

# zinit light zdharma-continuum/fast-syntax-highlighting
# zinit load zsh-users/zsh-completions

zinit ice wait lucid && zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid && zinit light marlonrichert/zsh-autocomplete

# 语法高亮插件必须最后加载
zinit ice wait lucid && zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid && zinit light Aloxaf/fzf-tab

### End of Zinit's installer chunk

[ -f "$HOME/.zsh/alias.zsh" ] && source "$HOME/.zsh/alias.zsh"
[ -f "$HOME/.zsh/export.zsh" ] && source "$HOME/.zsh/export.zsh"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

source <(fzf --zsh)

eval $(thefuck --alias)

# ------------------------------------------------------------------------------
# Powerlevel10k 主题配置 (Theme Configuration)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# ------------------------------------------------------------------------------
# 必须放在最后
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh