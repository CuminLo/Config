#!/usr/bin/env bash

# ==============================================================================
#                      macOS 软件自动化安装脚本
# ==============================================================================
#
# 作者: Gemini
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
command_exists() { command -v "$1" >/dev/null 2>&1 }

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

  if $list_command | grep -q "^${package}$"; then
    info "${package} 已安装，跳过。"
  else
    info "正在安装 ${package} (${type_flag:-formula})..."
    if $install_command "$package"; then
      success "成功安装 ${package}。"
    else
      warn "安装 ${package} 失败，继续下一个。"
    fi
  fi
}

# --- 安装与配置模块 ---

# 安装 Homebrew
install_brew() {
  if ! command_exists brew; then
    info "未找到 Homebrew，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
      error "安装 Homebrew 失败，请检查网络连接或手动安装后重试。"
    fi
    # 将 Homebrew 添加到当前 Shell 的 PATH，以便后续命令可以使用
    info "将 Homebrew 添加到当前 Shell 环境..."
    if [[ "$(uname -m)" == "arm64" ]]; then
      # Apple Silicon (M1/M2/M3)
      export PATH="/opt/homebrew/bin:$PATH"
    else
      # Intel
      export PATH="/usr/local/bin:$PATH"
    fi
    success "Homebrew 安装并配置成功。"
  else
    info "Homebrew 已安装。"
  fi
}

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
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    success "zinit 安装成功。"
  else
    info "zinit 已安装。"
  fi

  # 4. 下载并配置 .zshrc
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

  mkdir $HOME/.zsh
  curl -fsSL -o "${HOME}/.zsh/export.zsh" https://raw.githubusercontent.com/CuminLo/Config/main/zsh/.zsh/export.zsh
}

# 安装和配置 Rime 输入法
setup_rime() {
  info "开始配置 Rime 输入法..."
  install_package "squirrel-app" "--cask"

  local target_dir="$HOME/Library/Rime"
  local repo_url="https://github.com/iDvel/rime-ice.git"
  
  if [ -d "$target_dir" ]; then
    warn "检测到 Rime 目录已存在 ($target_dir)。"
    info "将不会自动克隆 rime-ice 配置，以防覆盖您的现有设置。"
    info "如需更新，请手动操作。"
  else
    info "正在克隆 rime-ice 配置到 $target_dir..."
    if git clone "$repo_url" "$target_dir" --depth 1; then
      success "Rime 配置克隆成功。"
    else
      warn "克隆 rime-ice 失败，请检查网络或 Git。"
    fi
  fi
}

# 安装和配置 pyenv
setup_pyenv() {
  info "开始配置 pyenv..."
  if command_exists pyenv; then
    info "pyenv 已安装。"
  else
    install_package "pyenv"
  fi  

  local py_latest_version=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -n 1)

  # 尝试安装最新稳定版 Python
  if pyenv install --skip-existing "$py_latest_version"; then
    success "成功安装最新版 Python。"
  else
    warn "pyenv 安装 Python 失败。请在脚本结束后，打开新终端手动执行 'pyenv install <version>'"
    return
  fi

  pyenv global $py_latest_version

  python -m ensurepip --upgrade
  python -m pip install --no-deps -U yt-dlp
  python -m pip install runlike
}

# 安装和配置 nvm
setup_nvm() {
  info "开始配置 nvm..."
  export NVM_DIR="$HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    info "nvm 已安装。"
  else
    info "正在安装 nvm..."
    # 从官方源安装 nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  fi
  
  # 在当前脚本中加载 nvm，以便后续命令可用
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    info "在当前会话中加载 nvm..."
    source "$NVM_DIR/nvm.sh"
  else
    error "nvm 安装后未能找到 nvm.sh 脚本，无法继续。"
  fi

  info "正在使用 nvm 安装 Node.js LTS 版本..."
  if nvm install --lts; then
    success "Node.js LTS 版本安装成功。"

    info "正在安装全局 npm 包"

    npm install -g @google/gemini-cli
    npm install -g @anthropic-ai/claude-code
  else
    warn "nvm 安装 Node.js 失败。请在脚本结束后，打开新终端手动执行 'nvm install --lts'"
  fi
}

setup_tmux() {
  info "正在配置 .tmux.conf 文件..."

  local tmux_url="https://raw.githubusercontent.com/CuminLo/Config/main/tmux/.tmux.conf"
  local tmux_path="${HOME}/.tmux.conf" 

  # todo...如果已存在则备份
  if [ -f "$tmux_path" ]; then
    return
  fi
  
  info "正在从网络下载配置文件到 $tmux_path..."
  if curl -fsSL -o "$tmux_path" "$tmux_url"; then
    success "成功下载并设置 tmux 文件。"
  else
    error "下载 tmux 失败，请检查网络或 URL: $tmux_url"
  fi
}

# --- 主函数 ---
main() {
  # 脚本开始，请求一次 sudo 权限，延长会话有效期
  info "脚本需要管理员权限来更改 Shell 设置，请输入密码..."
  sudo -v
  # 在脚本退出时，保持 sudo 会话的激活状态
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  # 1. 安装 Homebrew
  install_brew
  info "更新 Homebrew 仓库..."
  brew update

  # 2. 定义要安装的软件包列表
  # 字体 (作为 Casks 安装)
  local fonts=(
    "font-jetbrains-maple-mono"
    "font-fira-code-nerd-font"
    "font-jetbrains-mono-nerd-font"
    "font-lxgw-wenkai"
  )
  # 命令行工具
  local cli_tools=(
    "bat" "ca-certificates" "curl" "eza" "wget" "fd" "fzf" "git" "git-lfs"
    "htop" "openssl@3" "readline" "sqlite3" "tcl-tk@8" "tree" "tlrc" "tmux"
    "upx" "ripgrep" "procs" "pyenv" "xz" "zlib"
  )
  # 图形界面应用
  local casks=(
    "google-chrome" "iterm2" "orbstack" "itsycal" "clipy" "rectangle"
    "visual-studio-code" "trae-cn" "tabby" "fork" "stats" "localsend"
    "easydict" "pixpin" "wechat" "utools" "jordanbaird-ice"
  )

  # 3. 执行安装
  info "--- 开始安装字体 ---"
  for font in "${fonts[@]}"; do install_package "$font" "--cask"; done

  info "--- 开始安装命令行工具 ---"
  for tool in "${cli_tools[@]}"; do install_package "$tool"; done

  info "--- 开始安装图形界面应用 ---"
  for cask in "${casks[@]}"; do install_package "$cask" "--cask"; done

  # 4. 执行独立的配置模块
  info "--- 开始执行环境配置 ---"
  setup_pyenv
  setup_nvm
  setup_rime
  setup_tmux
  # Zsh 设置放在最后，因为它会下载配置文件，可能会覆盖之前的设置
  setup_zsh

  echo
  success "============================================================"
  success "           🎉 所有任务已执行完毕! 🎉"
  success "============================================================"
  info "重要提示: 请完全关闭并重新启动您的终端 (iTerm2, Tabby 等)，"
  info "以确保所有更改 (尤其是新的 Zsh Shell) 完全生效。"
  echo
}

# --- 脚本入口 ---
main
