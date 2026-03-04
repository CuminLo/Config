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

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

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
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/mysql-client/lib/pkgconfig"

export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rust
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

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

# ZeroClaw
if command_exists zeroclaw; then
    source <(zeroclaw completions zsh)
fi

# ==============================================================================
#  End of Configuration
# ==============================================================================
