# WORKSTATION

## Purpose

Versioned dotfiles and configuration repository for Miguel's workstation (Linux and macOS).
This is not application code: it consists of configuration files + a `just` orchestrator + Nix Home Manager to manage packages and symlinks into the user's `$HOME`.

The Containerfile is used to build the OS distribution by deriving from Universal Blue, which is based on Fedora Atomic Desktop.

Three versioned hierarchies, all mapped onto the system via symlinks:
- `config/` → user dotfiles and application configuration. Each subfolder is symlinked to its destination under `$HOME` (typically `~/.config/<app>`, see the `dotfiles` recipe in the `Justfile`).
- `default/` → system-level configuration (`/etc/`). Each file/subfolder is symlinked to its equivalent path under `/etc/` (requires `sudo`).
- `bin/` → user executable scripts. Each file is symlinked to `$HOME/.local/bin/<script>`.

The full repo tree is also symlinked at `$HOME/.local/share/settings`.

## Main commands

Single entry point: `just` from the repo root.
Run `just` to see the help.

## Architecture

### Platform and environments

- macOS: Homebrew for GUI apps (see README), Nix Home Manager for CLI tools.
- Linux: Flatpak for GUI apps (`linux-setup-apps`), Distrobox `archlinux` for tools not available on the host (ublue/ostree), Nix optional. Apps from the distrobox are exported to the host with `distrobox-export`.

## Task management

- Two sources, different purpose: TickTick MCP (`mcp__ticktick__*`) is for personal reminders and informal to-dos
  not tied to a work ticket; Jira via the Atlassian MCP (`mcp__claude_ai_Atlassian__*`) is for tracked work items
  (see the `ticket` and `close` skills for how Jira tickets are created/closed).
- Only act on these when Miguel explicitly asks for one of them or uses matching phrasing below. Never capture,
  complete, or sync a task on your own initiative.

### Unified agenda
Trigger phrases: "qué tengo pendiente", "mi agenda", "qué tengo hoy/esta semana".
- Query TickTick with `mcp__ticktick__filter_tasks` (or `list_undone_tasks_by_date` for a date range), status `0`
  (active).
- Query Jira with `mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql`, resolving the team/project as in the
  `ticket` skill (`TIF` for Infraestructura, `TS` for Sistemas), `statusCategory != Done`, filtered to issues
  assigned to Miguel.
- Present two sections in this order: **TickTick** (title, due date if set) and **Jira** (key, status, title).
  Sort each section by due/updated date. If a section is empty, say so instead of omitting it.

### Quick capture
Trigger phrases: "recuérdame X", "apunta esto", "añade una tarea".
- Extract the task title and, if mentioned, a due date/time from the request.
- If Miguel names a TickTick project (list, area), resolve its id with `mcp__ticktick__list_projects` matching by
  name (case-insensitive). Otherwise use the Inbox project.
- Create it with `mcp__ticktick__create_task`, passing `title`, `projectId`, and `dueDate` (ISO 8601) when given.
- Confirm back with the created task's title and due date (if any).

### Complete / update
Trigger phrases: "márcalo como hecho", "he terminado X", "cambia la fecha/prioridad de X".
- Resolve the task with `mcp__ticktick__search_task` using the title/keyword Miguel gave. If more than one match is
  returned, list them and ask which one.
- To complete: `mcp__ticktick__complete_task` with the resolved `project_id`/`task_id`.
- To update a field (date, priority, title): `mcp__ticktick__update_task` with `task_id` and only the changed
  fields in `task`.

### Reflect a Jira ticket into TickTick
Trigger phrases: "apunta el ticket X en TickTick", "pon TIF-123 en mi TickTick".
- Resolve the Jira key from the request (or from session context, same resolution order as the `close` skill).
- Fetch its summary with `mcp__claude_ai_Atlassian__getJiraIssue` (fields: `summary`).
- Create a TickTick task via `mcp__ticktick__create_task` with `title` set to `"<KEY> <summary>"` and `content` set
  to the ticket URL, in the Inbox unless Miguel names a project.
- This is one-way and on-request only: it does not update the reverse direction, and it does not run automatically
  when a ticket is created or assigned.
