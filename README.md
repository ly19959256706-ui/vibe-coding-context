# Vibe Coding Context v2

一个按任务规模自动选择上下文工作流的通用 skill。

它保留 vibe coding 的轻量开发节奏，同时吸收复杂任务所需的阶段计划、结构化证据、跨会话恢复和完成门禁。面对不同规模的任务，代理会先完成统一 checklist，再在 tiny、light、medium、heavy 四个档位中选择唯一工作流。

> 对外 skill 名称仍为 `vibe-coding-context`。v2 是本仓库相对于 `v1.0.0` 的重大内容升级。

## 为什么需要它

实际项目中的上下文通常分散在需求、业务流程、架构、接口、UI 规范和历史决策中。完全不记录会导致跨会话遗忘；所有任务都建立重型计划又会打断开发节奏。

本 skill 解决这两个极端：

- 小任务不创建任何规划文件。
- 中小型功能只保存最少任务记忆。
- 复杂研究、迁移、审计和跨会话任务使用独立计划与证据链。
- 项目已有文档始终是真相来源，任务记忆只负责执行与恢复。
- 同一任务只有一个活动记录位置，禁止 `ai/` 与 `.planning/` 双写。

## v2 的主要变化

- 从 tiny/light/medium 三档扩展为 tiny/light/medium/heavy 四档。
- 使用 A–F checklist 和固定优先级消除档位模糊地带。
- 为每个档位明确文件位置、更新时机和完成条件。
- heavy 增加阶段计划、结构化证据、测试记录和三项完成门禁。
- 支持 medium→heavy 追加升级：冻结旧 `ai/` 文件，不迁移、不双写。
- 提供 PowerShell 5.1+ 中文初始化器。
- 不引入 hooks、会话日志解析或自动 Stop，保持跨宿主可迁移性。

完整执行规则见 [SKILL.md](vibe-coding-context/SKILL.md)，详细字段与恢复流程见 [reference.md](vibe-coding-context/reference.md)。

## 第一步：任务分级

每个新任务先判断以下六项：

| 判定项 | 说明 |
|---|---|
| A. 涉及文件数 ≥ 3 | 跨模块修改 |
| B. 需要读现有架构/UI/需求文档才能动手 | 有前置上下文 |
| C. 预计工具调用次数 > 5 | 工作量指标 |
| D. 涉及研究、审计、迁移、跨阶段开发 | 重型规划场景 |
| E. 有明确验收标准或测试要求 | 完成需要门禁 |
| F. 容易被中断或跨会话继续 | 需要可恢复性 |

按以下优先级确定唯一档位：

1. 命中 D、F 或总命中数 ≥5：heavy。
2. 否则命中 E，或总命中数为 3–4：medium。
3. 否则命中 1–2 项且全部属于 A/B/C：light。
4. 全部未命中：tiny。

## 四档工作流

| 档位 | 唯一记录位置 | 适合任务 | 完成条件 |
|---|---|---|---|
| tiny | 不创建规划文件 | 单文件和一次性小修改 | 直接完成与验证 |
| light | `ai/task-brief.md` | 小型多文件或少量上下文任务 | 交付并由用户确认 |
| medium | `ai/task-brief.md`、`ai/progress.md`、`ai/findings.md` | 带验收、测试和自然里程碑的中型功能 | 验收标准全部满足 |
| heavy | `.planning/<任务>/plan.md`、`progress.md`、`findings.md` | 研究、迁移、审计、复杂排错、跨阶段或跨会话任务 | 验收全勾选、测试全通过、阶段全 complete |

## 安装

### 1. 克隆仓库

```powershell
git clone https://github.com/ly19959256706-ui/vibe-coding-context.git
cd vibe-coding-context
```

真正的 skill 包位于仓库内的 `vibe-coding-context/` 子目录。不要把整个 Git 仓库当作 skill 目录。

### 2. 安装到 Codex

将该子目录复制到 Codex skills 目录，并保持最终目录名为 `vibe-coding-context`。

```powershell
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$SkillsRoot = Join-Path $CodexHome 'skills'
[System.IO.Directory]::CreateDirectory($SkillsRoot) | Out-Null

Copy-Item '.\vibe-coding-context' `
  -Destination (Join-Path $SkillsRoot 'vibe-coding-context') `
  -Recurse
```

如果已经安装 v1，请先备份或完整替换旧 skill 目录，避免旧 `assets/`、`references/` 与 v2 文件混在一起。

### 3. 其他宿主

任何支持 `SKILL.md` 或目录式自定义技能的代理都可以导入 `vibe-coding-context/` 子目录。light/medium 只依赖普通文件读写；heavy 初始化器要求 Windows PowerShell 5.1+。

## 快速使用

通常只需告诉代理：

```text
使用 vibe-coding-context。先按 A–F checklist 判断任务档位，再按唯一档位执行；不要双写任务记录。
```

继续已有任务时：

```text
使用 vibe-coding-context，从当前项目的任务记忆恢复目标、进度和下一步，然后继续。
```

代理会自行判断应该读取 `ai/`，还是恢复 `.planning/` 中最新的活动 heavy 任务。

## Heavy 初始化

heavy 档显式运行：

```powershell
& '.\vibe-coding-context\scripts\init-planning.ps1' `
  -TaskName '中文任务名' `
  -WorkingDirectory (Get-Location) `
  -Mode Auto
```

脚本会：

- 保留中文任务名并生成合法目录名。
- 自动识别 Git、`package.json`、`pyproject.toml`、`.sln` 等项目标记。
- 在项目根或 standalone 工作目录下创建 `.planning/<任务名>/`。
- 只创建 `plan.md`、`progress.md`、`findings.md`。
- 二次运行时跳过已有文件，不覆盖任务记录。
- 输出 `PLANNING_DIR=<绝对路径>`，后续 heavy 记录只写入该目录。

## Medium 升级到 Heavy

任务进行中出现研究、迁移、跨阶段、跨会话或明显低估复杂度时，重新执行 checklist。

升级到 heavy 时：

1. 在原 `ai/task-brief.md` 顶部加入：

   ```text
   > 已升级到 heavy，后续记录见 .planning/<任务名>/
   ```

2. 立即冻结全部 `ai/` 文件。
3. 初始化 `.planning/<任务名>/` 三文件。
4. 后续进度、发现和证据只写 `.planning/`。
5. 不迁移旧记录，不回填两边，不保持双向同步。

## 项目文档仍是真相来源

命中 B 时，优先读取项目已有：

1. `AGENTS.md`
2. `docs/context-index.md` 或其他上下文索引
3. 当前步骤需要的需求、业务、架构、接口、UI 和决策文档

上下文索引只负责导航，`ai/` 和 `.planning/` 只负责当前任务执行与恢复。不要为了匹配模板复制、重命名或覆盖用户已有文档。

## 仓库结构

```text
vibe-coding-context/
├── README.md
├── LICENSE
└── vibe-coding-context/
    ├── SKILL.md
    ├── reference.md
    ├── README.md
    ├── CHANGELOG.md
    ├── templates/
    │   ├── ai/
    │   │   ├── task-brief.md
    │   │   ├── progress.md
    │   │   └── findings.md
    │   └── planning/
    │       ├── plan.md
    │       ├── progress.md
    │       └── findings.md
    └── scripts/
        └── init-planning.ps1
```

## 从 v1 升级

- v1 的项目文档和项目内 `ai/` 文件不需要自动迁移。
- 用 v2 完整替换已安装的旧 skill 目录，不要只覆盖同名文件。
- v1 发布的 `assets/templates/` 和 `references/workflow.md` 不再包含在 v2 skill 包中。
- 已开始的任务先重新执行 A–F checklist：
  - 仍是 light/medium 时继续使用项目内 `ai/`。
  - 达到 heavy 时写入升级指针、冻结 `ai/`，再初始化 `.planning/`。
- v1 源码仍可通过 Git 标签 `v1.0.0` 获取。

完整改造记录见 [CHANGELOG.md](vibe-coding-context/CHANGELOG.md)。

## 验证结果

以下结果于 2026-07-18 在隔离工作区完成，并在发布前重新复核：

### 基础结构与兼容性

- SKILL frontmatter 验证通过。
- 最终 skill 包严格为 11 个文件。
- 不包含 agents、hooks、SessionStart、Stop 或会话日志解析脚本。
- PowerShell 5.1 AST 解析 0 错误。
- 中文 standalone 任务名、项目根识别和二次运行幂等性全部通过。

### 四档路由

| 场景 | 结果 |
|---|---|
| tiny | 未创建 `ai/` 或 `.planning/` |
| light | 只创建 `ai/task-brief.md` |
| medium | 只创建 `ai/` 三文件，边界验收全部通过 |
| heavy | 未创建 `ai/`，只创建 `.planning/<任务>/` 三文件 |

### Heavy 独立任务

- CSV 迁移验证 4/4 通过，覆盖字段映射、可重复执行、源文件保护和错误输入拒绝。
- 四个阶段全部 `complete`。
- 验收、测试、阶段三项完成门禁全部通过。
- 无遗留未勾选验收项。

### Medium→Heavy 与跨会话恢复

- medium 阶段的验收与 8 MB 边界测试全部通过。
- 升级时 task brief 只增加 `.planning/` 指针。
- 原 `ai/progress.md` 和 `ai/findings.md` 哈希保持不变。
- 新进度和证据只写入 `.planning/`，未发生双写。
- 一个没有聊天前文的新代理仅凭工作区文件成功恢复到验证阶段。
- 文档覆盖检查 10/10 通过，推测性 fixture 安全检查通过。
- 8 MB−1、8 MB、8 MB+1 三个真实调用链回归测试通过。
- 五项验收、四个阶段、三项完成门禁和三条测试记录全部通过。

## 为什么不使用 Hooks

本项目刻意不引入 Codex、Claude 或其他宿主的生命周期 hooks，也不读取内部会话日志。

原因是：

- 可迁移性优先于自动化。
- 明确的文件规则比隐式注入更容易审计。
- 用户可以随时看到任务记忆写在哪里。
- 不会因为宿主事件名称或 payload 变化导致工作流失效。

## License

[MIT License](LICENSE)
