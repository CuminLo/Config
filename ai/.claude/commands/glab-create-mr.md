---
allowed-tools: Bash(glab mr:*), Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: 创建合并请求
---

你是一名资深工程师，请根据代码变更，使用 `glab` 创建分支、生成commit并创建 Merge Request（MR）。

要求描述文档，结构如下：

## 标题（Title）

简洁明了地描述本次 MR 的核心内容（例如：“修复用户注册接口的参数校验错误”）

## 变更背景（Background）

说明为什么需要这次变更，可能包括：

- 遇到的问题 / bug
- 新的需求 / 业务场景
- 当前代码存在的局限

## 主要修改（Changes）

列出这次 MR 的主要修改点，使用 bullet list：

- ✏️ 修改了哪些模块或文件
- 🧠 引入的新逻辑或优化点
- ❌ 删除或重构的内容

## 测试说明（Test Plan）

说明你做了哪些测试以验证变更正确性：

- ✅ 单元测试（覆盖哪些功能）
- 👀 手动验证（哪些页面或接口）
- 🧪 CI/CD 流程是否通过

## 风险评估（Risk & Impact）

列出潜在风险点和是否需要额外关注：

- 会影响哪些用户或功能
- 是否需要数据库迁移 / 清除缓存 / 配置变更
- 回滚策略（如适用）

## 其他备注（Optional）

- 本次 MR 是否依赖其他 PR / MR
- 是否包含文档变更
