#!/usr/bin/env bash

# ==============================================================================
#                            00 - 安装 Homebrew
# ==============================================================================
#
# 功能: 检查并安装 Homebrew 包管理器。
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# --- 主函数 ---
main() {
    info "--- 开始执行 Homebrew 安装脚本 ---"

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
            if ! grep -q '/opt/homebrew/bin/brew shellenv' ~/.zprofile &>/dev/null; then
                 echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            fi
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            # Intel
            if ! grep -q '/usr/local/bin/brew shellenv' ~/.zprofile &>/dev/null; then
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            fi
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        success "Homebrew 安装并配置成功。"
        info "请重启终端或运行 'source ~/.zprofile' 使环境生效。"
    else
        info "Homebrew 已安装，正在更新..."
        brew update
        success "Homebrew 更新完毕。"
    fi

    echo
    success "============================================================"
    success "          Homebrew 安装脚本执行完毕! 🎉"
    success "============================================================"
    echo
}

# --- 脚本入口 ---
main
