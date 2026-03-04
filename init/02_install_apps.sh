#!/usr/bin/env bash

# ==============================================================================
#                      02 - 安装应用 (命令行 & GUI)
# ==============================================================================
#
# 功能: 使用 Homebrew 安装常用的命令行工具和图形界面应用。
#       - `bash 02_install_apps.sh`: 安装所有预定义的应用。
#       - `bash 02_install_apps.sh <app_name>`: 只安装指定的应用。
#
# 依赖: Homebrew
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# --- 主函数 ---
main() {
    info "--- 开始执行应用安装脚本 ---"
    check_brew_installed

    # --- 定义要安装的软件包列表 ---

    # 命令行工具 (Formulae)
    local cli_tools=(
        "bat" "boxes" "ca-certificates" "curl" "duf" "ncdu" "eza" "wget" "fd" "fzf" "git" "git-lfs" "htop" "zoxide"
        "goenv"
        "sqlite3" "tree" "tlrc" "tmux" "upx" "ripgrep"
        "procs" "pidof" "uv" "jq" "sshpass" "w3m" "rustscan" "glab"
        # 依赖库
        "libffi" "libomp" "readline" "openssl" "tcl-tk" "xz" "zlib" "ncurses"
    )

    # 图形界面应用 (Casks)
    local casks=(
        "google-chrome" "iterm2" "orbstack" "itsycal" "clipy" "rectangle"
        "visual-studio-code" "trae-cn" "tabby" "fork" "stats" "localsend"
        "easydict" "pixpin" "wechat" "utools" "jordanbaird-ice" "skim"
        "motrix" "monitorcontrol" "squirrel" "folo"
    )

    # --- 根据参数决定安装行为 ---
    local target_app="$1"

    if [[ -n "$target_app" ]]; then
        # 如果提供了目标应用，只安装它
        info "--- 尝试安装特定应用: $target_app ---"

        # 检查是命令行工具还是 GUI 应用
        if [[ " ${cli_tools[@]} " =~ " ${target_app} " ]]; then
            install_package "$target_app"
        elif [[ " ${casks[@]} " =~ " ${target_app} " ]]; then
            install_package "$target_app" "--cask"
        else
            error "错误: 应用 '$target_app' 未在预定义的列表中找到。"
            info "请检查拼写，或将其添加到 'init/02_install_apps.sh' 文件中。"
            exit 1
        fi
    else
        # 如果没有提供参数，安装所有应用
        info "--- 开始安装所有预定义的命令行工具 ---"
        for tool in "${cli_tools[@]}"; do
            install_package "$tool"
        done

        info "--- 开始安装所有预定义的图形界面应用 ---"
        for cask in "${casks[@]}"; do
            install_package "$cask" "--cask"
        done
    fi

    # --- 后续配置步骤 (只在完整安装时执行) ---
    if [[ -z "$target_app" ]]; then
        if command_exists fzf; then
            info "运行 fzf 的安装后脚本..."
            "$(brew --prefix)/opt/fzf/install" --all --no-update-rc
            success "fzf 快捷键和模糊补全已配置。"
        fi

        if command_exists git-lfs; then
            git lfs install
            success "Git LFS 已初始化。"
        fi
    fi

    echo
    success "============================================================="
    if [[ -n "$target_app" ]]; then
        success "             特定应用 '$target_app' 安装完毕! 🎉"
    else
        success "             所有应用安装脚本执行完毕! 🎉"
    fi
    success "============================================================="
    echo
}

# --- 脚本入口 ---
# 将所有命令行参数传递给 main 函数
main "$@"