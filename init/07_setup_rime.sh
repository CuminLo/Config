#!/usr/bin/env bash

# ==============================================================================
#                         07 - 配置 Rime (鼠须管) 输入法
# ==============================================================================
#
# 功能: 安装鼠须管输入法 (Squirrel) 并克隆 rime-ice 配置文件。
# 依赖: Homebrew, git
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# 安装和配置 Rime 输入法
setup_rime() {
    info "开始配置 Rime 输入法..."
    # 安装鼠须管 App
    install_package "squirrel" "--cask"

    local target_dir="$HOME/Library/Rime"
    local repo_url="https://github.com/iDvel/rime-ice.git"
    
    if [ -d "$target_dir" ]; then
        warn "检测到 Rime 目录已存在 ($target_dir)。"
        info "将不会自动克隆 rime-ice 配置，以防覆盖您的现有设置。"
        info "如需更新，请进入该目录手动执行 'git pull' 或其他操作。"
    else
        if ! command_exists git; then
            error "'git' 命令未找到。请先运行命令行工具安装脚本 (02_install_cli_tools.sh)。"
        fi
        info "正在克隆 rime-ice 配置到 $target_dir..."
        if git clone "$repo_url" "$target_dir" --depth 1; then
            success "Rime 配置克隆成功。"
            info "请注销并重新登录系统，然后在输入法设置中添加“鼠须管”，最后点击菜单栏的图标选择“重新部署”以应用配置。"
        else
            warn "克隆 rime-ice 失败，请检查网络或 Git。"
        fi
    fi
}

# --- 主函数 ---
main() {
    info "--- 开始执行 Rime 输入法配置脚本 ---"
    check_brew_installed
    setup_rime

    echo
    success "============================================================"
    success "           Rime 输入法配置脚本执行完毕! 🎉"
    success "============================================================"
    echo
}

# --- 脚本入口 ---
main
