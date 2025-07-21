# 检查命令是否存在
command_exists() { command -v "$1" >/dev/null 2>&1 }

# 定义其他命令的别名
alias cat='bat --paging=never'
alias ls='eza --icons'
alias la='eza -a --icons'
alias ll='eza -al --icons --group-directories-first'

alias code='trae'

# 定义 update 函数
update() {
    local original_dir=$(pwd)
    brew update
    brew upgrade
    if command_exists tldr; then
        tldr --update
        tldr --clean-cache
    fi
    if [ -d "$HOME/Library/Rime" ]; then
        cd "$HOME/Library/Rime" && git pull -r
    fi
    cd "$original_dir"
}