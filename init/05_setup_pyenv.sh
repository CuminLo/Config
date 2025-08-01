#!/usr/bin/env bash

# ==============================================================================
#                             05 - 配置 pyenv
# ==============================================================================
#
# 功能: 安装 pyenv，并使用 pyenv 安装最新稳定版的 Python。
# 依赖: Homebrew, pyenv (会通过 brew 安装)
#
# ==============================================================================

# 引入共享辅助函数
source "$(dirname "$0")/_helpers.sh"

# 安装和配置 pyenv
setup_pyenv() {
    # 确保 pyenv 已安装
    install_package "pyenv"

    # 查找最新的稳定版 Python 版本号
    # 过滤掉 -dev, rc, a, b 等预发布版本
    info "正在查找最新的 Python 稳定版本..."
    local py_latest_version
    py_latest_version=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -n 1 | tr -d ' ')
    
    if [ -z "$py_latest_version" ]; then
        error "无法从 'pyenv install --list' 中找到最新的 Python 版本。"
    fi
    
    info "找到最新的 Python 版本为: ${py_latest_version}"

    # 尝试安装最新稳定版 Python
    info "正在安装 Python ${py_latest_version} (如果尚未安装)..."
    if pyenv install --skip-existing "$py_latest_version"; then
        success "成功安装 Python ${py_latest_version}。"
        
        info "将全局 Python 版本设置为 ${py_latest_version}..."
        pyenv global "$py_latest_version"
        success "全局 Python 版本已设置。"

        # 在 pyenv 的 python 环境下安装 pip 包
        info "正在升级 pip 并安装全局 Python 工具..."
        local pyenv_python_path
        pyenv_python_path="$(pyenv which python)"
        
        "$pyenv_python_path" -m ensurepip --upgrade
        "$pyenv_python_path" -m pip install --upgrade pip
        "$pyenv_python_path" -m pip install --no-deps -U yt-dlp
        "$pyenv_python_path" -m pip install runlike
        success "yt-dlp 和 runlike 安装完毕。"

    else
        warn "pyenv 安装 Python ${py_latest_version} 失败。请在脚本结束后，打开新终端手动执行 'pyenv install ${py_latest_version}'"
    fi
}

# --- 主函数 ---
main() {
    info "--- 开始执行 pyenv 配置脚本 ---"
    check_brew_installed
    setup_pyenv

    echo
    success "============================================================"
    success "             pyenv 配置脚本执行完毕! 🎉"
    success "============================================================"
    info "请重启终端或重新 source 配置文件，以使 pyenv 的设置生效。"
    echo
}

# --- 脚本入口 ---
main
