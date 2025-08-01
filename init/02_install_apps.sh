#!/usr/bin/env bash

# ==============================================================================
#                      02 - 安装应用 (命令行 & GUI)
# ==============================================================================
#
# 功能: 使用 Homebrew 安装常用的命令行工具和图形界面应用。
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
        "bat"
        "ca-certificates"
        "curl"
        "eza"
        "wget"
        "fd"
        "fzf"
        "git"
        "git-lfs"
        "htop"
        "reattach-to-user-namespace"
        "sqlite3"
        "tree"
        "tlrc"
        "tmux"
        "upx"
        "ripgrep"
        "procs"
        "pyenv"
        "jq"
        "sshpass"
        "w3m"
        "rustscan"
        # 依赖库
        "libffi" "libomp" "readline" "openssl@3" "tcl-tk" "xz" "zlib" "ncurses"
    )

    # 图形界面应用 (Casks)
    local casks=(
        "google-chrome"
        "iterm2"
        "orbstack"
        "itsycal"
        "clipy"
        "rectangle"
        "visual-studio-code"
        "trae-cn"
        "tabby"
        "fork"
        "stats"
        "localsend"
        "easydict"
        "pixpin"
        "wechat"
        "utools"
        "jordanbaird-ice"
        "skim"
        "motrix"
        "squirrel" # Rime 输入法本体
    )

    # --- 执行安装 ---

    info "--- 开始安装命令行工具 ---"
    for tool in "${cli_tools[@]}"; do
        install_package "$tool"
    done

    info "--- 开始安装图形界面应用 ---"
    for cask in "${casks[@]}"; do
        install_package "$cask" "--cask"
    done
    
    # --- 后续配置步骤 ---

    # 安装 fzf 的额外步骤
    if command_exists fzf; then
        info "运行 fzf 的安装后脚本..."
        "$(brew --prefix)/opt/fzf/install" --all --no-update-rc
        success "fzf 快捷键和模糊补全已配置。"
    fi
    
    # 初始化 git-lfs
    if command_exists git-lfs; then
        git lfs install
        success "Git LFS 已初始化。"
    fi

    echo
    success "============================================================"
    success "             应用安装脚本执行完毕! 🎉"
    success "============================================================"
    echo
}

# --- 脚本入口 ---
main
