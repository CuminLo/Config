# 项目
自用的脚本和常用软件的配置

## 如何使用
该项目使用 `Makefile` 来自动化环境的安装和配置。所有命令都需要在项目根目录下执行。

**注意:** 所有脚本在执行前都会被自动赋予执行权限。

### 一键安装
执行以下命令会按预定顺序安装和配置所有环境：
```bash
make all
```

### 分步安装
您可以执行单个目标来完成特定的安装任务：
- `make brew`: 安装 Homebrew.
- `make fonts`: 安装字体.
- `make zsh`: 配置 Zsh.
- `make pyenv`: 配置 Pyenv.
- `make nvm`: 配置 NVM.
- `make rime`: 配置 Rime 输入法.

### 安装应用 (`apps`)
`apps` 目标提供了两种安装模式：

1.  **安装所有应用:**
    ```bash
    make apps
    ```

2.  **安装特定应用:**
    直接在 `make apps` 后面跟上应用名即可。
    ```bash
    # 示例: 只安装 w3m
    make apps w3m

    # 示例: 只安装 Visual Studio Code
    make apps visual-studio-code
    ```
    如果应用名未在 `init/02_install_apps.sh` 的列表中，将会报错。

## 项目结构说明
- `Makefile`: 用于自动化执行安装和配置脚本的核心文件。
- `init/`: 存放所有初始化脚本。每个脚本对应 `Makefile` 中的一个命令，用于在新电脑上快速搭建开发环境。
- `iterm2/`, `vscode/`, `vim/`, `rime/`, `tmux/`, `zsh/`: 各个常用软件和工具的配置文件手动备份。
- `GEMINI.md`, `README.md`, `CLAUDE.md`: 项目说明文档。