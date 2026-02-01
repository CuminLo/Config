unalias gwt 2>/dev/null

function gwt {
    local GWT_VERSION="2026.01.30.01"

    # 参数验证
    if [ -z "$1" ]; then
        printf "错误: 缺少子工作区名称 (v%s)\n" "$GWT_VERSION"
        printf "用法: gwt <子工作区名称> [分支名称]\n"
        return 1
    fi

    local name="$1"
    local branch="${2:-}"

    # 环境检查
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        printf "错误: 当前目录不在 Git 仓库中\n"
        return 1
    fi

    # 智能提取主项目路径 (支持路径空格)
    local main_repo
    main_repo=$(git worktree list --porcelain | head -n 1 | sed 's/^worktree //')

    if [ -z "$main_repo" ] || [ ! -d "$main_repo" ]; then
        printf "错误: 无法准确定位主项目路径\n"
        return 1
    fi

    # 计算路径与冲突检查
    local parent_dir
    parent_dir=$(dirname "$main_repo")
    local target_path="${parent_dir}/${name}"

    if [ -e "$target_path" ]; then
        printf "错误: 路径已存在 -> %s\n" "$target_path"
        return 1
    fi

    # 执行创建
    printf "正在创建 worktree: %s ...\n" "$name"
    if [ -n "$branch" ]; then
        git worktree add "$target_path" "$branch"
    else
        git worktree add "$target_path"
    fi

    if [ $? -ne 0 ]; then
        printf "错误: git worktree add 执行失败\n"
        return 1
    fi

    # 进入目录
    cd "$target_path" || return 1
    printf "源路径: %s\n" "$main_repo"

    # 复制配置文件 (使用数组避免空格和特殊字符问题)
    printf "正在从主项目复制配置...\n"
    local items_to_copy=("AGENTS.md" "CLAUDE.md" "GEMINI.md" ".env" ".agent" ".sisyphus" "openspec")
    local sync_count=0

    for item in "${items_to_copy[@]}"; do
        local src="${main_repo}/${item}"
        if [ -e "$src" ]; then
            if cp -an "$src" . 2>/dev/null; then
                ((sync_count++))
            fi
        fi
    done

    printf "同步完成，共同步 %d 个文件。\n" "$sync_count"

    # 完成提示 (使用 printf 保证跨平台颜色一致)
    printf "\n\033[33m⚠️  提示: 需要执行 composer install\033[0m\n"
    printf "✅ Worktree 创建完成: %s (v%s)\n" "$target_path" "$GWT_VERSION"
}

function backup {
    local target="$1"
    local restore_mode=false

    if [[ "$1" == "-r" ]]; then
        restore_mode=true
        target="$2"
    fi

    if [[ -z "$target" ]]; then
        printf "用法: backup <file/dir> 或 backup -r <bak-file>\n"
        return 1
    fi

    if [[ "$restore_mode" == true ]]; then
        # 还原逻辑
        if [[ ! -e "$target" ]]; then
            printf "错误: 备份文件不存在 -> %s\n" "$target"
            return 1
        fi

        local original="${target%.bak*}"
        if [[ "$original" == "$target" ]]; then
            printf "错误: 无法从 %s 识别原始文件名\n" "$target"
            return 1
        fi

        if [[ -e "$original" ]]; then
            printf "正在备份现有文件 %s ...\n" "$original"
            backup "$original" || return 1
        fi

        printf "正在还原 %s 到 %s ...\n" "$target" "$original"
        cp -pRL "$target" "$original"
        printf "✅ 还原完成\n"
    else
        # 备份逻辑
        if [[ ! -e "$target" ]]; then
            printf "错误: 目标不存在 -> %s\n" "$target"
            return 1
        fi

        if [[ ! -r "$target" ]]; then
            printf "错误: 目标不可读 -> %s\n" "$target"
            return 1
        fi

        # 目录大小检查
        if [[ -d "$target" ]]; then
            local size
            size=$(du -sm "$target" | cut -f1)
            if [[ "$size" -gt 200 ]]; then
                printf "警告: 目录大小为 %sMB，超过 200MB。是否继续备份？(y/n) " "$size"
                read -k 1 "choice"
                printf "\n"
                if [[ "$choice" != "y" ]]; then
                    printf "已取消备份\n"
                    return 0
                fi
            fi
        fi

        # 计算备份文件名
        local bak_file="${target}.bak"
        if [[ -e "$bak_file" ]]; then
            local n=1
            while [[ -e "${bak_file}.${n}" ]]; do
                ((n++))
            done
            bak_file="${bak_file}.${n}"
        fi

        local parent_dir
        parent_dir=$(dirname "$bak_file")
        if [[ ! -w "$parent_dir" ]]; then
            printf "错误: 目标目录不可写 -> %s\n" "$parent_dir"
            return 1
        fi

        printf "正在备份 %s 到 %s ...\n" "$target" "$bak_file"
        cp -pRL "$target" "$bak_file"
        printf "✅ 备份完成: %s\n" "$bak_file"
    fi
}
