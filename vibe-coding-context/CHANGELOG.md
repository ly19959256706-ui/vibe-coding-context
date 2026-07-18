# 改造说明

## 从 vibe-coding-context 保留的能力

- 保留 tiny/light/medium 的轻量开发节奏。
- 保留 `AGENTS.md`、上下文索引和按需读取真实项目文档的渐进式上下文策略。
- 保留 `ai/task-brief.md`、`ai/progress.md`、`ai/findings.md` 的任务记忆分工。
- 保留自然里程碑更新、长期决策提升到项目文档和原始项目资料优先原则。
- 保留跨宿主可迁移性，不依赖特定聊天产品的内部日志。

## 从 planning-with-files 吸收的能力

- 增加 heavy 档，使用 `.planning/<任务>/` 隔离复杂任务。
- 增加阶段计划、结构化证据、测试记录、阻塞与错误升级。
- 增加显式恢复协议，使跨会话任务能从三文件继续。
- 增加中文与 UTF-8 友好的 PowerShell 初始化器。
- 增加验收标准、测试记录、阶段状态三项完成门禁。

## 主动放弃的能力

- 不引入 Codex、Claude 或其他宿主 hooks。
- 不解析 SessionStart、聊天日志或内部会话记录。
- 不提供自动 Stop 拦截和隐式完成检查。
- 不使用固定次数的工具调用作为强制写入时机。

这些取舍是刻意的：可迁移性优先于自动化，明确的显式流程优先于宿主相关的隐式行为，同时避免代理在不知情时被自动注入或阻止结束。

## 修复的问题

1. 用 A–F checklist 统一原 vibe 中“3 个以上文件”和 light/medium 边界不一致的问题。
2. 为 tiny、light、medium、heavy 分别规定完成检查。
3. 增加重新分级、light→medium 和任意档位→heavy 的失败与范围升级协议。
4. 删除 planning reference 中 Manus、Claude 和旧 hooks 背景，只保留当前融合规则。
5. 把 heavy 完成条件强化为验收全勾选、测试全通过、阶段全 complete，避免只数状态标签。
6. 明确禁止 `ai/` 与 `.planning/` 双写，并规定升级时冻结旧文件、不迁移内容。

## 对外兼容性

- YAML 名称保持 `vibe-coding-context`。
- 仓库内正式目录继续使用 `vibe-coding-context`；v2 内容直接替换 v1，旧版可从 Git 标签 `v1.0.0` 获取。
- 如需与 v1 并行安装，请在本地复制并重命名其中一个 skill 目录。
- Heavy 脚本只要求 Windows PowerShell 5.1+；其他档位仅依赖普通文件读写。
