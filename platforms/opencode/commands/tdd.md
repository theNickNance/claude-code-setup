---
description: Run a test-driven development workflow
---

Use a strict TDD workflow for this task: $ARGUMENTS

Workflow:
- Understand the requirement. Check [[ARCHITECTURE]] for relevant context and check if there is an active plan in `docs/plans/`.
- Before writing implementation code, create the test file(s) with cases covering the happy path, edge cases, error paths, and state transitions.
- Run the relevant tests and confirm every new test fails. This validates that the tests are actually testing something.
- Write the minimum code to make tests pass.
- Run the tests again until all new tests pass.
- Refactor while tests stay green.
- Run the project's full test command from project instructions to confirm no regressions.

Test stack and commands:
- The test framework, runner, and exact commands live in project instructions.
- Read `AGENTS.md` first, or `CLAUDE.md` if the project only has Claude Code instructions.
- If the project instructions do not define a test command, ask the user. Do not guess based only on files in the repo.

Test placement:
- Tests live next to the code they cover, using the project's naming convention.
- Match shared fixture/helper conventions in top-level `tests/`, `__tests__/`, or `testing/` directories if present.

Common naming:
- TypeScript/JavaScript: `foo.ts` -> `foo.test.ts`
- Python: `foo.py` -> `test_foo.py` or `foo_test.py`
- Go: `foo.go` -> `foo_test.go`
- Rust: in-file `#[cfg(test)] mod tests` or `tests/foo.rs`

Patterns:
- Name tests by behavior, not implementation.
- Use Arrange, Act, Assert.
- One Act step per test.
- Use factory functions or fixtures with realistic domain data.
- Mock external boundaries only: APIs, databases, clock/randomness, filesystem access when relevant.
- Do not mock your own business logic.

Rules:
- Tests always come before implementation.
- One behavior per test case. If the name needs "and," split the test.
- Use realistic domain data, never `foo` or `bar`.
- Never default to snapshot tests.
- Never use `test.skip` or equivalent without a linked task in [[TASKS]].
- Never commit with failing tests.
- Every bug fix includes a test that reproduces the bug before the fix.
