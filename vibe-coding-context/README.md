# Vibe Coding Context v2

这是一个按任务规模自动选择上下文工作流的通用 skill。它保留轻量 vibe coding 的开发节奏，同时为研究、迁移、复杂排错和跨会话任务提供阶段计划与证据链。

对外 skill 名称和仓库内正式目录名均为 `vibe-coding-context`。本内容是相对于 Git 标签 `v1.0.0` 的 v2 升级。

## 四档路由

每个任务先检查六项：涉及文件数、前置项目文档、工具调用量、研究/审计/迁移/跨阶段、验收测试、跨会话恢复。按照明确优先级选择唯一档位：

| 档位 | 记录方式 | 适合任务 |
|---|---|---|
| tiny | 不建规划文件 | 单文件和一次性小修改 |
| light | 仅 `ai/task-brief.md` | 小型多文件或少量上下文任务 |
| medium | `ai/` 三文件 | 带验收、测试和自然里程碑的中型功能 |
| heavy | `.planning/<任务>/` 三文件 | 研究、迁移、复杂排错、跨阶段或跨会话任务 |

同一个任务只能有一个活动记录位置。`ai/` 和 `.planning/` 绝不能同时更新。

## 项目文档仍是真相来源

当任务需要需求、架构或 UI 文档时，先读取项目已有 `AGENTS.md` 和上下文索引，再只读当前步骤需要的真实文档。索引负责导航，任务记忆负责恢复，二者都不能替代原始项目资料。

## Heavy 初始化

在 heavy 档显式运行：

```powershell
& 'C:\路径\vibe-coding-context\scripts\init-planning.ps1' `
  -TaskName '中文任务名' `
  -WorkingDirectory (Get-Location) `
  -Mode Auto
```

脚本输出 `PLANNING_DIR`。后续只在该目录维护 `plan.md`、`progress.md` 和 `findings.md`。

脚本不会注册 hooks，不读取会话日志，也不会自动拦截停止。所有恢复和完成检查都由当前代理按 skill 规则显式执行。

## 目录内容

```text
vibe-coding-context/
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

## CSV 导入功能的四档示例

下面用同一类需求展示不同规模会创建什么。

### tiny：只改提示文字

任务：把 CSV 上传按钮的提示从“选择文件”改成“选择 CSV 文件”。

- A–F 全部不命中。
- 直接修改并验证。
- 不创建 `ai/` 或 `.planning/`。

### light：修改三个局部文件

任务：在上传按钮、空状态和帮助提示三个文件中统一 CSV 文案，不需要读取项目文档，没有额外测试门禁。

- 只命中 A。
- 创建 `ai/task-brief.md`。
- 不创建 progress、findings 或 `.planning/`。

### medium：实现带验收的 CSV 导入

任务：根据现有需求和 UI 规范实现上传、解析与错误提示，并满足明确测试标准。

- 命中 A、B、C、E；E 使任务进入 medium。
- 创建 `ai/task-brief.md`、`ai/progress.md`、`ai/findings.md`。
- 验收标准全部勾选后才能完成。

### heavy：迁移旧数据并跨会话完成

任务：研究旧 CSV 格式、迁移历史数据、分阶段实现兼容解析，并在多个会话中持续验证。

- 命中 D 和 F，直接进入 heavy。
- 创建 `.planning/CSV-历史数据迁移/plan.md`、`progress.md`、`findings.md`。
- 若此前已经使用 medium，在 task brief 顶部加入升级行并冻结 `ai/`；不迁移旧记录。
- 验收全勾选、测试全通过、阶段全 complete 后才能完成。
