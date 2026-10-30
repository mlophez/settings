# AGENTS.md

<!-- Single source of truth for coding agents working on this project. Keep it tight: one-line bullets, no
prose, target under 250 lines. Do not restate what the code already says. -->

## Purpose

<!-- 2-4 sentences: what this project is and what it does. -->

## Stack

<!-- Languages, frameworks and relevant versions, as a bullet list. -->

## Commands

<!-- Exact commands, one bullet each: build, run, test, single test, lint, format. Use code spans. If the
project installs the agent hooks, mention that scripts/agent/ wraps lint, format and validation. -->

## Architecture

### Project layout

<!-- Annotated folder tree: each top-level folder and what belongs in it. -->

### Components

<!-- Layers/modules, their responsibilities, and the dependency rules between them (who may depend on whom). -->

### External integrations

<!-- Omit this section if not applicable. APIs, queues, third-party services: what they are used for and where
the client code lives. -->

### Persistence

<!-- Omit this section if not applicable. Database, schema approach, migrations tooling and how to run them. -->

### Configuration & environments

<!-- Environments (local/pre/pro), how configuration is loaded, and how secrets are handled. -->

## Code style

### Naming

<!-- Casing and naming rules for files, classes, functions, variables. -->

### File organization

<!-- Where each kind of code goes (models, services, handlers, helpers...). -->

### Error handling & logging

<!-- How errors are raised/propagated and how/what to log. -->

### Dependencies

<!-- How to add a dependency and the criteria to accept one. -->

### Git workflow

<!-- Branch model and commit message conventions. -->

### Forbidden patterns

<!-- Anti-patterns explicitly banned in this project. Bullet list. -->

## Testing

### Strategy

<!-- Kinds of tests in the project (unit, integration, e2e...) and when each one is required. -->

### Running tests

<!-- Exact command to run each suite, including how to run a single test. -->

### Writing tests

<!-- Framework, test location, file/test naming, and how to use fixtures, mocks and test data. -->

### Acceptance criteria

<!-- What a change needs to be accepted: required kinds of tests and coverage expectations. -->

## Security

### Secrets & credentials

<!-- What counts as a secret in this project, where secrets live, and how they are injected and rotated.
Secrets are never committed to the repo. -->

### Authentication & authorization

<!-- Omit this section if not applicable. How users/services authenticate and how permissions are enforced. -->

### Input validation & sensitive data

<!-- How inputs are validated, what sensitive/personal data the project handles, and what must never be
logged. -->

### Dependency audit

<!-- Audit tooling and the policy to keep dependencies updated and free of known vulnerabilities. -->

### Compliance

<!-- Omit this section if not applicable. Regulatory requirements the project must meet (ENS, eIDAS,
GDPR...) and how they constrain changes. -->

## Design

<!-- Omit this whole section, subsections included, if the project has no UI. -->

### Visual identity

<!-- Tone and personality of the UI: what it should feel like. -->

### Colors

<!-- Color tokens and their usage (primary, surface, semantic colors...). -->

### Typography

<!-- Font families, scale and usage rules. -->

### Spacing & layout

<!-- Spacing scale, grid/layout rules, breakpoints if applicable. -->

### Shared components

<!-- Where shared components and the theme live, and how to reuse them instead of creating parallel styles. -->

### UI states

<!-- Standard handling of loading, error and empty states. -->

### Accessibility & i18n

<!-- Accessibility requirements and internationalization approach. -->

## Agent hooks

<!-- Omit this section if no hooks were installed. State which hooks are active, that they are wired in
.claude/settings.json, implemented in scripts/agent/, and that every tooling command lives in hooks.sh at the
project root. -->

## Project notes

<!-- Omit this section if empty. Things not derivable from the code: AWS profiles, kubectl contexts,
environment quirks. -->

## Architecture decisions

<!-- Cumulative mini-ADR log. Append one entry per relevant decision: date, decision, reason. Not interviewed:
generate it as "None yet." on a fresh project, and preserve existing entries when regenerating. -->

None yet.
