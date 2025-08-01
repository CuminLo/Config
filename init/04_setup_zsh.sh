#!/usr/bin/env bash

# ==============================================================================
#                               04 - 配置 Zsh
# ==============================================================================
#
# 功能: 安装 Zsh, zinit, 并从远程仓库下载 .zshrc 配置文件。
# 依赖: Homebrew, curl, git
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# 设置 Zsh, Zinit, 和 .zshrc 配置文件
setup_zsh() {
    # 1. 安装 Zsh
    install_package "zsh"

    # 2. 设置 Homebrew 的 Zsh 为默认 Shell
    local brew_zsh_path
    if [[ "$(uname -m)" == "arm64" ]]; then
        brew_zsh_path="/opt/homebrew/bin/zsh"
    else
        brew_zsh_path="/usr/local/bin/zsh"
    fi

    info "检查默认 Shell 设置..."
    if [[ "$SHELL" != "$brew_zsh_path" ]]; then
        info "需要将默认 Shell 设置为 Homebrew Zsh ($brew_zsh_path)..."
        # 将 brew 的 zsh 添加到允许的 shells 列表
        if ! grep -q "$brew_zsh_path" /etc/shells; then
            info "需要管理员权限将 $brew_zsh_path 添加到 /etc/shells..."
            echo "$brew_zsh_path" | sudo tee -a /etc/shells
        fi
        # 更改默认 shell
        chsh -s "$brew_zsh_path"
        if [ $? -eq 0 ]; then
            success "已将默认 Shell 设置为 Zsh。请在脚本完成后重启终端以生效。"
        else
            warn "设置 Zsh 为默认 Shell 失败。请尝试手动执行: chsh -s $brew_zsh_path"
        fi
    else
        info "默认 Shell 已是 Homebrew Zsh。"
    fi

    # 3. 安装 zinit 插件管理器
    info "检查并安装 zinit 插件管理器..."
    if [ ! -d "${HOME}/.local/share/zinit/zinit.git" ]; then
        info "正在安装 zinit..."
        bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
        success "zinit 安装成功。"
    else
        info "zinit 已安装。"
    fi

    # 4. 下载并配置 .zshrc 和相关文件
    info "正在配置 .zshrc 文件..."
    local zshrc_url="https://raw.githubusercontent.com/CuminLo/Config/main/zsh/.zshrc"
    local zshrc_path="${HOME}/.zshrc"
    
    # 如果已存在 .zshrc，则进行备份
    if [ -f "$zshrc_path" ]; then
        local backup_path="${zshrc_path}.bak_$(date +%Y%m%d_%H%M%S)"
        info "发现已存在的 .zshrc，正在备份到 ${backup_path}"
        mv "$zshrc_path" "$backup_path"
    fi
    
    info "正在从网络下载配置文件到 $zshrc_path..."
    if curl -fsSL -o "$zshrc_path" "$zshrc_url"; then
        success "成功下载并设置 .zshrc 文件。"
    else
        error "下载 .zshrc 失败，请检查网络或 URL: $zshrc_url"
    fi

    # 创建 .zsh 目录并下载其他配置文件
    mkdir -p "$HOME/.zsh"
    info "正在下载 export.zsh..."
    if curl -fsSL -o "${HOME}/.zsh/export.zsh" https://raw.githubusercontent.com/CuminLo/Config/main/zsh/.zsh/export.zsh; then
        success "成功下载 export.zsh。"
    else
        warn "下载 export.zsh 失败。"
    fi
}

# --- 主函数 ---
main() {
    info "--- 开始执行 Zsh 配置脚本 ---"
    check_brew_installed
    
    # 请求一次 sudo 权限，延长会话有效期
    info "脚本需要管理员权限来更改 Shell 设置，请输入密码..."
    sudo -v
    # 在脚本退出时，保持 sudo 会话的激活状态
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    setup_zsh

    echo
    success "============================================================"
    success "              Zsh 配置脚本执行完毕! 🎉"
    success "============================================================"
    info "重要提示: 请完全关闭并重新启动您的终端 (iTerm2, Tabby 等)，"
    info "以确保所有更改 (尤其是新的 Zsh Shell) 完全生效。"
    echo
}

# --- 脚本入口 ---
main
