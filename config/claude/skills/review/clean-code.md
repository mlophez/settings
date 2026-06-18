# Clean code baseline

General clean-code principles shared by the `review` and `implement` skills. They are a baseline, not project law:
`docs/code-style.md` and the surrounding code always win when they conflict with anything here.

- Intention-revealing names: variables, functions and types say what they are or do, with no abbreviations that need a
  comment to be understood.
- Small, single-responsibility functions: each does one thing; extract a helper when a function mixes levels of
  abstraction or grows hard to read.
- Reduce nesting with early returns and guard clauses instead of deep if/else pyramids.
- DRY: reuse existing functions and utilities instead of duplicating logic; locate them with `rg` before writing new
  ones.
- No dead code: do not leave commented-out blocks, unused variables, imports or parameters behind.
- Validate domain objects at creation: domain entities and value objects enforce their invariants in the constructor
  or factory, so an instance can never exist in an invalid state (fail fast on construction).
- Immutable domain objects: domain entities and value objects are open for reading but closed for writing; never
  mutate an instance in place. A change is driven by its corresponding use case and always returns a new copy with the
  change applied, leaving the original untouched.
- Prefer composition over inheritance: build behavior by composing small collaborators rather than extending base
  classes; reach for inheritance only for genuine is-a relationships.
- Explicit error handling: no silent catches; fail with context. Do not swallow or hide errors.
- Comment the why, not the what: explain intent and non-obvious decisions, and keep comments in sync with the code.
- No magic numbers or strings: give them a named constant with a meaningful identifier.
- YAGNI: build what the task needs, not speculative abstraction; but never copy-paste to avoid a small, justified
  abstraction.
