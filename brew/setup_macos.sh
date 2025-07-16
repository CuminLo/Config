#!/usr/bin/env bash

# ==============================================================================
#                      macOS 软件自动化安装脚本
# ==============================================================================
#
# 作者: Gemini (为你定制)
# 日期: 2025-07-15
#
# 描述:
#   此脚本用于在新 macOS 上自动化安装开发环境和常用软件。
#   它会首先检查并安装 Homebrew，然后根据预设列表安装各种
#   命令行工具 (Formulae) 和图形界面应用 (Casks)。
#   此版本新增了 Zsh 安装、设置为默认 Shell 以及 Zinit 插件管理器的安装。
#
# 使用方法:
#   1. 将此脚本保存为 setup_macos.sh
#   2. 在终端中给予执行权限: chmod +x setup_macos.sh
#   3. 运行脚本: ./setup_macos.sh
#
# ==============================================================================

# --- 配置 ---

# 如果任何命令执行失败，则立即退出脚本
set -e

# --- 彩色输出定义 ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

# --- 日志函数 ---
info() { echo -e "${C_BLUE}INFO: $1${C_RESET}" }
success() { echo -e "${C_GREEN}SUCCESS: $1${C_RESET}" }
warn() { echo -e "${C_YELLOW}WARN: $1${C_RESET}" }
error() { echo -e "${C_RED}ERROR: $1${C_RESET}" >&2; exit 1 }

# 检查命令是否存在
command_exists() { command -v "$1" >/dev/null 2>&1 }

# 安装 Homebrew（如果未安装）
install_brew() {
  if ! command_exists brew; then
    info "未找到 Homebrew，正在安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
      error "安装 Homebrew 失败，请检查网络连接后重试。"
    fi
  else
    info "Homebrew 已安装。"
  fi
}

# 安装命令行工具
install_software() {
  local software_list=("$@")
  for software in "${software_list[@]}"; do
    if brew list | grep -q "^${software}\$"; then
      info "$software 已安装。"
    else
      info "正在安装 $software..."
      brew install "$software"
      if [ $? -ne 0 ]; then
        warn "安装 $software 失败，继续安装下一个软件。"
      fi
    fi
  done
}

# 安装图形界面应用（cask）
# install_cask_software() {
#   local cask_list=("$@")
#   for cask in "${cask_list[@]}"; do
#     if brew list --cask | grep -q "^${cask}\$"; then
#       info "$cask 已安装。"
#     else
#       info "正在安装 $cask..."
#       brew install --cask "$cask"
#       if [ $? -ne 0 ]; then
#         warn "安装 $cask 失败，继续安装下一个软件。"
#       fi
#     fi
#   done
# }

# 设置 zsh 和安装 zinit
setup_zsh() {
  # 确保 zsh 已安装（macOS 通常预装 zsh）
  if ! command_exists zsh; then
    info "未找到 zsh，正在通过 Homebrew 安装 zsh..."
    brew install zsh
    if [ $? -ne 0 ]; then
      error "安装 zsh 失败，请检查系统设置。"
    fi
  else
    info "zsh 已安装。"
  fi

  # 安装 zinit 插件管理器
  info "正在安装 zinit..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  if [ $? -ne 0 ]; then
    warn "安装 zinit 失败，请检查网络连接后重试。"
  else
    success "zinit 安装成功。"
  fi

  # 检查并设置 zsh 为默认 shell
  current_shell=$(dscl . -read /Users/$USER UserShell | grep UserShell | cut -d: -f2 | tr -d ' ')
  if [ "$current_shell" != "/bin/zsh" ]; then
    info "正在将 zsh 设置为默认 shell..."
    chsh -s /bin/zsh
    if [ $? -eq 0 ]; then
      success "已将 zsh 设置为默认 shell，请启动新的终端会话以使用。"
    else
      warn "设置 zsh 为默认 shell 失败，请确保 /bin/zsh 存在。"
    fi
  else
    info "zsh 已是默认 shell。"
  fi
}

setup_rime() {
  local target_dir="$HOME/Library/Rime"
  
  if [ -d "$target_dir" ]; then
    info "检测到 Rime 目录已存在，将克隆到 $target_dir.new"
    
    # 处理 .new 目录已存在的情况
    local new_dir="$target_dir.new"
    if [ -d "$new_dir" ]; then
      info "发现已存在的 .new 目录，正在清理..."
      rm -rf "$new_dir"
    fi
    
    git clone https://github.com/iDvel/rime-ice.git "$new_dir" --depth 1
  else
    info "正在 clone rime-ice..."
    git clone https://github.com/iDvel/rime-ice.git "$target_dir" --depth 1
  fi

  local pack={
    "squirrel-app"
  }

  install_software "${pack[@]}"
}

# 主函数
main() {
  # 延长 sudo 会话以避免多次提示（尽管 chsh 不需要 sudo）
  sudo -v

  # 安装 Homebrew（如果需要）
  install_brew

  # 更新 Homebrew 以确保获取最新的软件包定义
  info "正在更新 Homebrew..."
  brew update

  # 命令行工具列表
  local cli_tools=(
    "font-jetbrains-maple-mono"
    "font-fira-code-nerd-font"
    "font-jetbrains-mono-nerd-font"
    "font-lxgw-wenkai"
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
    "tree"
    "tlrc"
    "tmux"
    "tmux-mem-cpu-load"
    "upx"
    "pyenv"
    "ripgrep"
  )

  # 图形界面应用列表（cask）
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
  )

  # 安装命令行工具
  install_software "${cli_tools[@]}"

  # 安装图形界面应用
  install_software "${casks[@]}"

  # 设置 zsh 和安装 zinit
  setup_zsh

  setup_rime

  success "软件安装过程已完成。"
}

# 执行主函数
main