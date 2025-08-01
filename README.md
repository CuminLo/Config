# ⚙️ 个人环境自动化配置脚本

欢迎使用！这是一个包含了我的个人配置文件（dotfiles）和一系列自动化脚本的仓库，旨在帮助你快速搭建一个舒适、高效的 macOS 开发环境。

## 🚀 如何使用

整个安装过程由 `Makefile` 统一管理，你只需要在项目的根目录执行简单的 `make` 命令即可。

**✨ 贴心提示:** 在执行任何安装脚本之前，系统都会自动为它们赋予可执行权限，无需手动操作。

### 懒人一键安装

如果你想一次性安装和配置所有东西，只需要一个命令：

```bash
make all
```

### 自由分步安装

你也可以根据需要，像搭乐高一样，一步步完成安装：

- `make brew`: 安装 Homebrew 包管理器。
- `make fonts`: 安装开发和终端所需的字体。
- `make zsh`: 配置 Zsh，让你的终端更好用。
- `make pyenv`: 配置 Pyenv，轻松管理 Python 版本。
- `make nvm`: 配置 NVM，轻松管理 Node.js 版本。
- `make rime`: 配置强大的 Rime 输入法。

### 📦 灵活的应用安装

`make apps` 命令非常灵活，支持两种模式：

1.  **安装所有预设应用:**
    ```bash
    make apps
    ```

2.  **只安装你需要的特定应用:**
    直接在 `make apps` 后面加上应用的名字就行。
    ```bash
    # 示例: 只想安装 w3m 浏览器
    make apps w3m

    # 示例: 只想安装 VS Code
    make apps visual-studio-code
    ```
    > **注意:** 应用名必须是 `init/02_install_apps.sh` 脚本中预先定义好的哦！

## 📂 项目结构说明

- `Makefile`: 整个自动化流程的核心，定义了所有可执行的命令。
- `init/`: 存放所有安装脚本的地方，每个脚本负责一项具体的安装任务。
- `iterm2/`, `vscode/`, `vim/`, `rime/`, `tmux/`, `zsh/`: 我个人使用的各种工具的配置文件备份。
- `README.md`, `GEMINI.md`, `CLAUDE.md`: 项目的说明文档，帮助你更好地理解和使用它。