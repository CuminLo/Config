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

rime_update() {
    # --- 更新 Rime 設定 (如果目錄存在) ---
    local rime_dir="$HOME/Library/Rime"
    if [ -d "$rime_dir" ]; then
        echo ">>> 發現 Rime 設定目錄，正在更新..."
        # 進入 Rime 目錄，暫存變更、拉取更新、然後恢復變更
        if cd "$rime_dir"; then
            git stash && git pull -r && git stash pop
            echo ">>> Rime 設定更新完成。"
        else
            echo "!!! 無法進入 $rime_dir 目錄。"
        fi
    else
        echo "--- 未找到 Rime 設定目錄 ($rime_dir)，跳過更新。 ---"
    fi
}

#goenv_update() {
#    local original_dir=$(pwd)
#    if command_exists goenv; then
#        cd ~/.goenv && git pull -r
#        go version
#        goenv install -l | tail -n 1
#    fi
#    cd "$original_dir"
#}