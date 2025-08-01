#!/usr/bin/env bash

# ==============================================================================
#                      macOS 设置脚本 - 共享辅助函数
# ==============================================================================
#
# 这个脚本包含了其他设置脚本共用的函数，例如彩色输出、包安装逻辑等。
# 它不应该被直接执行。
#
# ==============================================================================

# --- 配置 ---
# 如果任何命令执行失败，则立即退出脚本
set -e
# 在管道中，只要有命令失败，就将整个管道标记为失败
set -o pipefail

# --- 彩色输出定义 ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

# --- 日志函数 ---
info()    { echo -e "${C_BLUE}INFO: $1${C_RESET}"; }
success() { echo -e "${C_GREEN}SUCCESS: $1${C_RESET}"; }
warn()    { echo -e "${C_YELLOW}WARN: $1${C_RESET}"; }
error()   { echo -e "${C_RED}ERROR: $1${C_RESET}" >&2; exit 1; }

# --- 辅助函数 ---

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查 Homebrew 是否已安装
check_brew_installed() {
    if ! command_exists brew; then
        error "Homebrew 未安装。请先运行 '00_install_homebrew.sh' 脚本进行安装。"
    fi
}

# 统一的包安装函数 (兼容 Formulae 和 Casks)
# 用法: install_package "package_name" 或 install_package "package_name" "--cask"
install_package() {
    local package="$1"
    local type_flag="$2" # --cask or empty
    local list_command="brew list"
    local install_command="brew install"

    if [[ "$type_flag" == "--cask" ]]; then
        list_command="brew list --cask"
        install_command="brew install --cask"
    fi

    # 检查包是否已经安装
    if $list_command | grep -q "^${package}$"; then
        info "${package} 已安装，跳过。"
    else
        info "正在安装 ${package} (${type_flag:-formula})..."
        if $install_command "$package"; then
            success "成功安装 ${package}。"
        else
            # 不使用 error 退出，而是警告后继续
            warn "安装 ${package} 失败。请检查网络或稍后手动尝试：'$install_command \"$package\"'"
        fi
    fi
}
