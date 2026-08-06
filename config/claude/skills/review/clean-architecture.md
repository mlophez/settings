# Clean architecture baseline

General architecture and design principles shared by the `review` and `implement` skills. They are a baseline, not
project law: the `Architecture` and `Code style` sections of `AGENTS.md` and the surrounding code always win when they
conflict with anything here.

- Validate domain objects at creation: domain entities and value objects enforce their invariants in the constructor
  or factory, so an instance can never exist in an invalid state (fail fast on construction).
- Immutable domain objects: domain entities and value objects are open for reading but closed for writing; never
  mutate an instance in place. A change is driven by its corresponding use case and always returns a new copy with the
  change applied, leaving the original untouched.
- Prefer composition over inheritance: build behavior by composing small collaborators rather than extending base
  classes; reach for inheritance only for genuine is-a relationships.
- Validate use case input at the boundary: every use case validates the shape, type and required fields of its input
  (DTO, command or request) before touching domain logic, and rejects invalid input with a clear error. This boundary
  check is distinct from and complementary to the domain object invariants validated on construction.
- Separate pure logic from the impure shell: keep pure functions (no I/O, no side effects, output depends only on
  input) apart from the thin shell that performs side effects (shell commands, network, disk, DB, clock, randomness).
  Push side effects to the edges so the core logic stays deterministic and testable without mocks (functional core,
  imperative shell).
