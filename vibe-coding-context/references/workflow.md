# Vibe Coding Context Workflow Reference

Use this reference when setting up a new project, adjusting the workflow, or deciding how much process to apply.

## Task Size Decision

Tiny task:

- One file or a very small local change.
- No product, architecture, or UI decision.
- No future continuation expected.
- Action: do the work directly.

Light task:

- Two or three files.
- One small feature slice or bug fix.
- Existing docs may matter.
- Action: read `AGENTS.md`, read `docs/context-index.md`, update `ai/task-brief.md` only if helpful.

Medium task:

- Several files or a feature flow.
- Requirements, UI, architecture, or testing matters.
- Future continuation is likely.
- Action: use the full working loop with `ai/task-brief.md`, `ai/progress.md`, and `ai/findings.md`.

## File Roles

`AGENTS.md`:

- Short project-level behavior rules.
- Always safe to include in context.
- Should point to `docs/context-index.md`.

`docs/context-index.md` or an existing project index:

- Navigation map for progressive disclosure.
- Should say which document answers which kind of question.
- Should point to the user's real upfront documents instead of forcing standard names.

Requirement or PRD documents:

- Product goals, user stories, acceptance criteria, non-goals.

Project context or business workflow documents:

- User group, business background, constraints, local assumptions.

Architecture or technical notes:

- Module boundaries, data model, storage, APIs, state management, routing.

UI guidelines, design notes, or screenshots:

- Visual rules, component rules, layout constraints, interaction patterns.

`docs/decisions.md` or an existing decision log:

- Durable decisions and rationale.

`ai/task-brief.md`:

- Current task only.
- Should be short enough to read every time.
- Should not be deleted automatically.
- Should be replaced for the next task only after the completed task is recorded in progress.

`ai/progress.md`:

- Current implementation status.
- Should make a new chat easy to resume.
- Should preserve recent history across tasks.
- Should not be cleared unless the user explicitly asks.

`ai/findings.md`:

- Working discoveries and temporary notes.
- Promote durable content to docs when it becomes stable.
- Should preserve reusable discoveries across tasks.

## Task Memory Lifecycle

In-progress task:

- Keep `ai/task-brief.md` as the active task.
- Update `ai/progress.md` only at natural milestones.
- Add only reusable facts or resolved issues to `ai/findings.md`.

Completed task:

- Record the completed result and verification in `ai/progress.md`.
- Promote durable decisions into the user's decision document.
- Keep `ai/progress.md` and `ai/findings.md`.
- Replace `ai/task-brief.md` only when the next task starts.

Long-running project:

- Keep `ai/progress.md` focused on recent history.
- When it gets long, summarize older entries into `Handoff Summary`.
- If more history is useful, create `ai/archive/` and move summarized task records there.
- Do not archive or delete content that is still needed to resume the active task.

## Anti-Patterns

Avoid:

- Reading all docs before every small change.
- Creating duplicate standard docs when the user already provided real project documents.
- Renaming user documents just to match the template.
- Updating progress after every tool call.
- Copying long template comments into project memory.
- Keeping old active task briefs as if they were still current.
- Clearing `progress.md` at the start of each task.
- Treating `ai/` files as product truth.
- Treating Trae memory as project documentation.

## Suggested First Message In A New Project

Use wording like:

```text
Use vibe-coding-context. First identify my existing project documents, create or update a lightweight context index if needed, then set up only the minimal ai/ task memory needed for this feature.
```

## Suggested Resume Message

Use wording like:

```text
Continue from project context. Use vibe-coding-context and resume from ai/task-brief.md, ai/progress.md, and ai/findings.md.
```
