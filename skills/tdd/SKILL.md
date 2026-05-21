# /tdd — Test-Driven Development Workflow

When invoked with a description of what to build, write the tests FIRST,
then implement to make them pass.

## Workflow

1. **Understand** — Read the requirement. Check [[ARCHITECTURE]] for relevant
   context. Check if there's an active plan in `docs/plans/`.

2. **Design tests** — Before writing any implementation code, create the test
   file(s) with all test cases covering:
   - Happy path
   - Edge cases (empty input, null, boundaries)
   - Error paths
   - State transitions (valid and invalid)

3. **Run tests → RED** — Confirm every test fails. This validates the tests
   are actually testing something.

4. **Implement** — Write the minimum code to make tests pass.

5. **Run tests → GREEN** — All new tests pass.

6. **Refactor** — Clean up while tests stay green.

7. **Run full suite** — Use the project's full test command (defined in the
   project CLAUDE.md) to confirm no regressions.

If invoked without a description, ask what to build.

## Test Stack and Commands

The test framework, runner, and exact commands live in the project's
`CLAUDE.md`. Read that file before running anything — different projects use
different runners (Vitest, Jest, pytest, go test, cargo test, etc.) and the
"full suite" command may differ from the "targeted file" command.

If the project CLAUDE.md does not define a test command, ask the user. Do not
guess based on what files are in the repo.

## Test File Placement

Tests live next to the code they cover, using the project's naming convention.
The project CLAUDE.md should specify the convention. Common conventions by
language:

- TypeScript/JavaScript: `foo.ts` → `foo.test.ts`
- Python: `foo.py` → `test_foo.py` or `foo_test.py`
- Go: `foo.go` → `foo_test.go`
- Rust: in-file `#[cfg(test)] mod tests` or `tests/foo.rs`

Shared fixtures and helpers typically go in a top-level `tests/`, `__tests__/`,
or `testing/` directory — match the project convention.

## Patterns

These patterns are language-agnostic. Adapt the syntax to the project's test
framework, but keep the structure.

### Naming — describe behavior, not implementation

```
# Good
it('returns high score for workflows with repetitive manual steps')
it('throws when workflow has no activities')

# Bad
it('should call the scoring function')
it('works correctly')
```

### Structure — Arrange, Act, Assert

Every test has three sections, in this order:

1. **Arrange** — set up the inputs, fixtures, and any mocked boundaries.
2. **Act** — call the thing being tested. One call per test.
3. **Assert** — check the outputs and observable side effects.

If a test needs more than one Act step, it's testing more than one behavior;
split it.

### Fixtures — factory functions with realistic domain data

Prefer typed factory functions (or fixtures, depending on the language) that
produce realistic domain data with sensible defaults and accept partial
overrides for the bits each test cares about.

```
createMockWorkflow({ activities: [...] })  // override just what the test needs
```

Names, IDs, and dates in fixtures should look like production data
("Invoice Approval", "Accounts Payable"), never `foo`/`bar`.

### Mocking — boundaries only

Mock the things you don't own:

- External APIs (HTTP, gRPC, third-party SDKs)
- The database driver (or use an in-memory/test instance)
- The clock and randomness (so tests are deterministic)
- File system access (when relevant)

Do not mock your own modules. If you find yourself mocking a function in the
same package as the test, you're testing the mock instead of the behavior —
refactor or test the real thing.

## Rules

- Tests ALWAYS come before implementation. No exceptions.
- One behavior per test case. If the name needs "and," split the test.
- Use realistic domain data (workflow names, company names), never "foo" or "bar."
- Mock external boundaries (APIs, databases, third-party services). Never mock
  your own business logic — test it directly.
- Never use snapshot tests. They break on every change and verify nothing useful.
- Never use `test.skip` (or the language equivalent) without a linked task in [[TASKS]].
- Never commit with failing tests. Main is always green.
- Every bug fix includes a test that reproduces the bug BEFORE the fix.
