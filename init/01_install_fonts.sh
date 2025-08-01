#!/usr/bin/env bash

# ==============================================================================
#                              01 - 安装字体
# ==============================================================================
#
# 功能: 使用 Homebrew Cask 安装常用字体。
# 依赖: Homebrew
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# --- 主函数 ---
main() {
    info "--- 开始执行字体安装脚本 ---"
    check_brew_installed

    # 定义要安装的字体列表 (作为 Casks 安装)
    local fonts=(
        "font-fira-code-nerd-font"
        "font-jetbrains-mono-nerd-font"
        "font-lxgw-wenkai"
        # Jetbrains Maple Mono 似乎不再是官方核心 Cask，可以注释掉或替换
        # "font-jetbrains-maple-mono" 
    )

    info "--- 开始安装字体 ---"
    for font in "${fonts[@]}"; do
        install_package "$font" "--cask"
    done

    echo
    success "============================================================"
    success "             字体安装脚本执行完毕! 🎉"
    success "============================================================"
    echo
}

# --- 脚本入口 ---
main
