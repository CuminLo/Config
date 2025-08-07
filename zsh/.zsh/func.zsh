# 加入 ~/.zshrc
function claude-code() {
    for arg in "$@"; do
        case $arg in
            --ar)
                //export ANTHROPIC_AUTH_TOKEN="sk-..."
                export ANTHROPIC_BASE_URL="https://anyrouter.top"
                shift # Remove the --ar argument
                ;;
            --k2)
                //export ANTHROPIC_AUTH_TOKEN="sk-..."
                export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
                shift # Remove the --k2 argument
                ;;
            --zp)
                //export ANTHROPIC_AUTH_TOKEN="..."
                export ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
                shift # Remove the --zp argument
                ;;
            --help|-h)
                echo "Usage: claude-code [--ar | --k2 | --zp] [other options]"
                echo "Options:"
                echo "  --ar   Use Anthropic's AnyRouter API"
                echo "  --k2   Use K2's Anthropic API"
                echo "  --zp   Use Zhipu's Anthropic API"
                echo "  --help Show this help message"
                return
                ;;
        esac
    done

    claude --dangerously-skip-permissions "$@"
}