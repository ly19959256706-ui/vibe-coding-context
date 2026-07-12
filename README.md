# Vibe Coding Context Skill 说明

这份 skill 是为 Trae Work Windows Desktop 准备的轻量上下文工作流，用来替代Manus原版 `planning-with-files` 的重型流程。

## 它解决什么问题

它解决的是 vibe coding 过程中的上下文管理问题：

- 项目需求、业务背景、架构、UI 规范分散在多个文档里。
- AI 不应该每次一次性读完所有文档。
- 中小型工具开发需要一点计划，但不能重到打断节奏。
- 新开窗口时需要快速恢复当前任务状态。
- 重要决策和踩坑记录需要沉淀下来。

## 推荐项目结构

下面这套结构只是推荐，不是强制。你的前期文档可以叫任何名字，也可以放在项目根目录、`docs/`、`需求/`、`设计/` 等目录里。

```text
AGENTS.md
docs/
  context-index.md
  decisions.md
ai/
  task-brief.md
  progress.md
  findings.md
```

模板文件在：

```text
vibe-coding-context\assets\templates
```

如果你已经有前期文档，不要为了适配 skill 去重命名或复制一份。应该创建一个轻量 `context-index.md`，把你的真实文档映射进去。

例如你的项目里已有：

```text
需求说明v1.md
页面交互稿.md
业务流程.md
技术想法.md
竞品参考.md
```

那么 `docs/context-index.md` 可以写成：

```markdown
# Context Index

## 需求
- `需求说明v1.md`

## 页面与交互
- `页面交互稿.md`

## 业务流程
- `业务流程.md`

## 技术方向
- `技术想法.md`

## 参考资料
- `竞品参考.md`
```

## 每个文件的作用

`AGENTS.md` 是项目入口规则。Trae 设置里开启“将 AGENTS.md 包含在上下文中”后，它会成为默认提示。

`docs/context-index.md` 是文档导航。它告诉 AI 什么任务该读哪个真实文档。它不是新的需求文档，也不替代你的原始资料。

`requirements.md`、`project-context.md`、`architecture.md`、`ui-guidelines.md` 这些只是可选模板。项目已有等价文档时，直接用已有文档。

`docs/decisions.md` 或你的已有决策记录，放长期有效的产品、设计和技术决策。

`ai/task-brief.md` 放当前这一轮任务的目标、范围、验收标准和当前步骤。

`ai/progress.md` 放当前进度、已完成事项、验证结果和下一步。

`ai/findings.md` 放开发过程中的发现、临时决策、已解决问题。

## Task Brief 和 Progress 怎么滚动

这版 skill 的明确规则是：**不自动删除这些文件**。

`ai/task-brief.md` 只代表当前正在做的任务。任务没做完时保留；任务完成后，先把完成结果和验证写进 `ai/progress.md`，然后下一轮任务开始时再用新的任务 brief 替换它。它不是长期日志，也不应该把一堆历史任务一直堆在里面。

`ai/progress.md` 是近期进度记录。它会跨任务保留，不会在每轮任务开始时清空。每完成一个自然阶段，就追加或更新简短记录。如果它变得太长，才把旧内容压缩到 `Handoff Summary`，或者放进 `ai/archive/`。

`ai/findings.md` 会跨任务保留有复用价值的发现。只有当某些发现已经沉淀到项目文档或决策记录里，才可以压缩或移除。

所以正常行为是：

```text
task-brief.md = 当前任务白板，可以在下一轮任务开始时替换
progress.md = 近期进度日志，保留并滚动更新
findings.md = 可复用发现，保留并定期压缩
```

## 开发时会发生什么

当任务很小，比如改一个文案或单文件小修，skill 会倾向于不创建计划文件，直接完成。

当任务是中小型小工具功能，比如新增页面、实现上传流程、接本地存储、调整 UI 流程，skill 会：

1. 先读 `AGENTS.md`。
2. 再读 `docs/context-index.md`。
3. 如果没有索引，先识别你已有的前期文档，再建立一个轻量索引。
4. 根据任务只读取相关真实文档。
5. 创建或更新 `ai/task-brief.md`。
6. 开始正常写代码。
7. 一个自然阶段完成后更新 `ai/progress.md`。
8. 发现有价值的信息时更新 `ai/findings.md`。
9. 长期决策写入 `docs/decisions.md` 或你的已有决策文档。
10. 交付前确认验收标准和测试结果。

## 新窗口恢复

新开 Trae Work 对话时，可以这样说：

```text
继续这个项目，使用 vibe-coding-context，从 ai/task-brief.md、ai/progress.md、ai/findings.md 恢复上下文。
```

它应该先恢复当前目标、已完成内容、下一步，然后继续实现。

## 和Manus的原版 planning-with-files 区别

原版更适合长任务和研究任务，强调 `task_plan.md`、`findings.md`、`progress.md` 三件套，以及频繁更新。

这个版本改成：

- 只在中小型复杂任务启用。
- 不强制每次都写三份文件。
- 不强制你使用固定 docs 文件名。
- 优先识别并尊重你已经准备好的前期文档。
- 用 `context-index.md` 作为文档地图。
- 不使用 Claude hooks。
- 不读取 `.claude/projects`。
- 不要求每两次工具调用就写文件。
- 使用你的原始项目文档保存项目真相。
- 使用 `ai/` 保存当前任务记忆。
- 使用 `AGENTS.md` 作为 Trae Work 的默认入口。

## 建议用法

项目第一次开始时，可以让 Trae 执行：

```text
使用 vibe-coding-context。先识别我项目里的已有前期文档，建立一个轻量 context-index，然后只初始化必要的 ai/ 工作记忆。这个项目是一个中小型小工具，保持流程轻量。
```

日常开发时，可以说：

```text
按项目上下文继续做这个功能。
```

或者：

```text
使用 vibe-coding-context，先读 context-index，再按需读取相关文档，不要一次性读完所有 docs。
```

## 当前不建议启用的东西

暂时不要为这个工作流配置 Hooks。Hooks 适合后续自动格式化、自动测试、自动同步进度，但现在先保持简单。

也不要把项目需求写进 Trae 的用户记忆。Trae 记忆适合个人偏好，项目事实应该放在项目目录里。
