#!/usr/bin/env bash

# ==============================================================================
#                              06 - 配置 nvm
# ==============================================================================
#
# 功能: 安装 nvm，并使用 nvm 安装 Node.js 的 LTS 版本。
# 依赖: curl
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# 安装和配置 nvm
setup_nvm() {
    export NVM_DIR="$HOME/.nvm"
    
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        info "nvm 已安装。"
    else
        info "正在安装 nvm..."
        # 从官方源安装 nvm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        success "nvm 安装脚本已执行。请重启终端以加载 nvm。"
    fi
    
    # 在当前脚本中加载 nvm，以便后续命令可用
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        info "在当前会话中加载 nvm..."
        source "$NVM_DIR/nvm.sh"
    else
        error "nvm 安装后未能找到 nvm.sh 脚本，无法继续。请重启终端后重试此脚本。"
    fi

    info "正在使用 nvm 安装 Node.js LTS 版本..."
    if nvm install --lts; then
        local lts_version
        lts_version=$(nvm alias lts)
        nvm use lts
        nvm alias default lts
        success "Node.js LTS 版本 (${lts_version}) 安装并设为默认。"

        info "正在安装全局 npm 包..."
        npm install -g @google/gemini-cli
        npm install -g @anthropic-ai/claude-code
        npm install -g tunnelmole
        success "全局 npm 包安装完毕。"
    else
        warn "nvm 安装 Node.js 失败。请在脚本结束后，打开新终端手动执行 'nvm install --lts'"
    fi
}

# --- 主函数 ---
main() {
    info "--- 开始执行 nvm 配置脚本 ---"
    setup_nvm

    echo
    success "============================================================"
    success "              nvm 配置脚本执行完毕! 🎉"
    success "============================================================"
    info "请重启终端或重新 source 配置文件，以使 nvm 的设置生效。"
    echo
}

# --- 脚本入口 ---
main
