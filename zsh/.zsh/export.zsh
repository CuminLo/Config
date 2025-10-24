# ==============================================================================
#  Zsh Configuration
# ==============================================================================

# 帮助函数: 检查命令是否存在
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------------------------
# 1. Homebrew 核心配置
# ------------------------------------------------------------------------------
# 禁止 Homebrew 在执行命令时自动更新
export HOMEBREW_NO_AUTO_UPDATE=1

# 将 Homebrew 的主路径添加到 PATH 的最前面，确保优先使用 Homebrew 安装的工具
export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# ------------------------------------------------------------------------------
# 2. 编译环境变量 (LDFLAGS, CPPFLAGS, PKG_CONFIG_PATH)
# ------------------------------------------------------------------------------

# 编译器链接器标志，告诉编译器去哪里找库文件 (.lib, .so, .dylib)
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/curl/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/openssl/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libffi/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libomp/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/readline/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/sqlite3/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/xz/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/ncurses/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/tcl-tk/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/mysql-client/lib"

# C/C++ 预处理器标志，告诉编译器去哪里找头文件 (.h)
export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/curl/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/openssl/include/openssl"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libffi/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libomp/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/readline/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/sqlite3/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/xz/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/ncurses/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/tcl-tk/include"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/mysql-client/include"

# pkg-config 工具的路径，帮助找到库的元信息
export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/curl/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/openssl/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/readline/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/sqlite3/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/xz/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/ncurses/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/tcl-tk/lib/pkgconfig"

# ------------------------------------------------------------------------------
# 3. 编程语言版本管理器 (NVM, pyenv)
# ------------------------------------------------------------------------------
# 版本管理器需要优先加载，因为它们会动态修改 PATH 来注入 "shims"（垫片），
# 从而接管 `node`, `python` 等命令。

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
# 检查 nvm.sh 脚本是否存在且非空，然后加载它
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# 加载 nvm 的自动补全功能
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pyenv (Python Version Manager)
export PYENV_ROOT="$HOME/.pyenv"
if command_exists pyenv; then
  # 将 pyenv 的可执行文件目录添加到 PATH
  export PATH="$PYENV_ROOT/bin:$PATH"
  # 初始化 pyenv，这会设置 shims 路径和自动补全
  eval "$(pyenv init - zsh)"
fi

# ------------------------------------------------------------------------------
# 4. 其他 Homebrew 安装的软件路径
# ------------------------------------------------------------------------------
# 将特定软件的路径也加入 PATH。
# 注意：这些路径应该在版本管理器之后、在 Homebrew 主路径之前，
# 但由于版本管理器会自动处理，我们在这里添加通常是安全的。

# PHP
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
if command_exists composer; then
  export PATH="$PATH:$HOME/.composer/vendor/bin"
fi

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
if command_exists goenv; then
  eval "$(goenv init -)"
fi

# zoxide
if command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

# tcl-tk@8
export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"

export PATH="/opt/homebrew/opt/curl/bin:$PATH"

export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

export OLLAMA_ORIGINS=chrome-extension://*

# ------------------------------------------------------------------------------
# 5. Shell 增强工具和别名
# ------------------------------------------------------------------------------

# fzf (Fuzzy Finder)
if command_exists fzf; then
  source <(fzf --zsh)
fi

# procs (a modern replacement for ps)
if command_exists procs; then
  source <(procs --gen-completion-out zsh)
fi

# The Fuck (corrects errors in previous console commands)
if command_exists thefuck; then
  eval $(thefuck --alias)
fi

# ==============================================================================
#  End of Configuration
# ==============================================================================
