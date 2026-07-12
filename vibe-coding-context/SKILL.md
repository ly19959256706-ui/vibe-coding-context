---
name: vibe-coding-context
description: Lightweight file-based context workflow for Trae Work Desktop vibe coding. Use when building or iterating on small-to-medium tools, MVPs, dashboards, scripts with UI, or feature work that spans multiple files, uses existing project documents, needs continuation across chats, or benefits from progressive disclosure of requirements, product context, architecture, UI guidelines, decisions, and current task state.
---

# Vibe Coding Context

Use this skill as a light context operating system for small-to-medium coding projects. Keep the user in flow while preserving enough state to resume reliably.

## Core Rule

Prefer useful momentum over heavy process.

Use file memory only when it reduces confusion, prevents repeated explanation, or makes a future chat easier to resume. Do not turn small edits into project management.

## When To Activate

Activate for tasks that meet any of these conditions:

- The task touches 3 or more files.
- The task spans product behavior, UI, architecture, data flow, or tests.
- The user says to continue from project context, vibe code, resume, plan with files, or work from docs.
- A new feature, MVP, tool, workflow, or multi-step fix is being built.
- The work is likely to continue in another Trae Work chat.

Skip for:

- Single-file edits.
- Tiny text, style, or configuration changes.
- One-off explanations that do not need persistence.

## Project Context Model

Do not require a fixed documentation structure.

Respect the user's existing upfront project documents, whatever their names are. They may be in Chinese or English, may live in the project root or a docs folder, and may include requirement docs, product notes, business workflows, architecture drafts, UI rules, screenshots, research notes, or other context files.

Use this skill to create a lightweight map over those documents, not to replace them.

Preferred optional structure:

```text
AGENTS.md
docs/context-index.md  # optional document map
docs/decisions.md      # optional durable decisions
ai/task-brief.md
ai/progress.md
ai/findings.md
```

The templates in `assets/templates/` are optional scaffolds. Use them only when the project does not already have equivalent documents or when the user asks to initialize a standard structure.

If existing docs are present, do not duplicate or rename them. Create or update only `docs/context-index.md` to point at the real files.

## Progressive Disclosure

Do not read every project document by default.

1. Read `AGENTS.md` if present.
2. Read `docs/context-index.md` if present.
3. If no index exists, inspect filenames and nearby docs briefly, then create a minimal index if the task is medium-sized or likely to continue.
4. Choose only the relevant real documents for the current task:
   - Product scope: requirement docs, PRDs, feature lists, user stories.
   - Background and constraints: project context, business notes, workflow docs.
   - Data flow or module boundaries: architecture docs, technical notes, API notes.
   - UI, components, layout, copy, or interaction: UI guidelines, design notes, screenshots.
   - Prior tradeoffs: decision logs, meeting notes, implementation notes.
5. Read `ai/task-brief.md`, `ai/progress.md`, and `ai/findings.md` when resuming or when the user asks to continue.

## Context Index Rules

`docs/context-index.md` is a map, not a source of truth.

Create it only when it helps the agent choose what to read. Keep paths to original documents. Do not summarize away important details unless the original is very long and the summary includes a clear pointer back to the source file.

If the user already has a different index file, use that instead and do not create a duplicate.

## Working Loop

1. Classify the task as tiny, light, or medium.
2. For tiny tasks, work directly and do not create planning files.
3. For light or medium tasks, discover or update the context index before reading detailed docs.
4. Create or update `ai/task-brief.md` with goal, scope, acceptance, current step, and open questions.
5. Read only the docs needed for the current step.
6. Implement normally.
7. Update `ai/progress.md` after a natural milestone, not after every edit.
8. Update `ai/findings.md` only for useful discoveries, blockers, resolved issues, or project facts.
9. Move long-lived decisions into `docs/decisions.md` or the user's existing decision document.
10. Before final delivery, verify the acceptance criteria and record checks in `ai/progress.md` when useful.

## Update Policy

Keep updates short.

Update `ai/task-brief.md` when:

- The goal, scope, acceptance criteria, or current step changes.
- The user changes direction.
- A blocker appears.

Update `ai/progress.md` when:

- A feature slice is complete.
- Tests or checks have run.
- The next step changes.
- A chat is about to end and continuation is likely.

Update `ai/findings.md` when:

- A project fact was discovered.
- A decision was made but may still be temporary.
- An issue was resolved and should not be repeated.

Update `docs/decisions.md` or the user's existing decision document when:

- The decision should survive beyond the current task.
- The decision affects architecture, data storage, UI conventions, libraries, or product scope.

## Task Lifecycle

Do not delete task memory files unless the user explicitly asks.

`ai/task-brief.md` represents only the active task:

- Keep it while the task is in progress.
- When the task is complete, first record the result in `ai/progress.md`.
- Then replace `ai/task-brief.md` with the next active task brief when a new task starts.
- Do not silently erase an unfinished task brief.

`ai/progress.md` keeps recent project work history:

- Preserve it across tasks.
- Append or update concise milestone entries.
- Do not clear it between tasks.
- If it becomes long, summarize older entries into a handoff summary or move them into `ai/archive/`.

`ai/findings.md` keeps reusable working discoveries:

- Preserve it across tasks.
- Remove or compress stale items only after their useful content has been moved into project docs or decisions.

Use `ai/archive/` only when history becomes too long for fast resume. Archive by summary, not by dumping every old line.

## Resume Protocol

When the user says to continue, resume, use project context, or opens a fresh chat:

1. Read `AGENTS.md`.
2. Read `docs/context-index.md` or the project's existing context map.
3. Read `ai/task-brief.md`.
4. Read `ai/progress.md`.
5. Read `ai/findings.md`.
6. Read only additional source docs needed for the next step.
7. State the current goal and next action briefly, then continue.

## User Interaction

Ask the user only when a decision is blocking or risky.

Prefer making a reasonable local decision when:

- The existing docs or code imply the answer.
- The decision is easy to reverse.
- The task can continue without changing product scope.

Ask before:

- Changing product scope.
- Choosing a paid external service.
- Removing or rewriting large parts of the app.
- Making a design or architecture decision that conflicts with project docs.

## Trae Work Notes

- Treat `AGENTS.md` as the always-on project entry point.
- Treat this skill as the on-demand workflow.
- Treat existing project documents as project truth, regardless of naming.
- Treat `docs/context-index.md` as a pointer map.
- Treat `ai/` as current task memory.
- Do not rely on Claude-specific hooks, `.claude/projects`, or session logs.
- Hooks are optional and should not be required for this workflow.

For detailed workflow guidance, read `references/workflow.md` only when implementing or adjusting the workflow itself.
