alias cat='bat --paging=never'
alias ls='eza --icons'
alias la='eza -a --icons'
alias ll='eza -al --icons --group-directories-first'

# 可以在这里添加其他别名
alias update='brew update && brew upgrade && tldr --update && tldr --clean-cache && z rime && git pull -r'