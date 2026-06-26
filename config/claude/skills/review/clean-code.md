# Clean code baseline

General coding style principles shared by the `review` and `implement` skills. They are a baseline, not project law:
`docs/code-style.md` and the surrounding code always win when they conflict with anything here.

For architecture and design principles (domain validation, immutability, pure/shell separation) see `clean-architecture.md`
in this same directory.

- Intention-revealing names: variables, functions and types say what they are or do, with no abbreviations that need a
  comment to be understood.
- Small, single-responsibility functions: each does one thing; extract a helper when a function mixes levels of
  abstraction or grows hard to read.
- Reduce nesting with early returns and guard clauses instead of deep if/else pyramids.
- DRY: reuse existing functions and utilities instead of duplicating logic; locate them with `rg` before writing new
  ones.
- No dead code: do not leave commented-out blocks, unused variables, imports or parameters behind.
- Explicit error handling: no silent catches; fail with context. Do not swallow or hide errors.
- Comment the why, not the what: explain intent and non-obvious decisions, and keep comments in sync with the code.
- No magic numbers or strings: give them a named constant with a meaningful identifier.
- YAGNI: build what the task needs, not speculative abstraction; but never copy-paste to avoid a small, justified
  abstraction.

## Python

- Type hints: annotate every function parameter and return value, and any variable whose type is not obvious from its
  assignment. Code must pass the project's type checker (`mypy`, `pyright` or equivalent) with no new errors.
