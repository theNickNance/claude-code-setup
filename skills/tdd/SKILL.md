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

7. **Run full suite** — `pnpm test` to confirm no regressions.

If invoked without a description, ask what to build.

## Test Stack

- **Vitest** — Unit, component, API route tests
- **React Testing Library** — Component rendering and interaction
- **Playwright** — E2E (critical paths only, not invoked by /tdd)

## Test File Placement

Tests live next to the code: `scoring.ts` → `scoring.test.ts`

```
src/lib/scoring.ts          → src/lib/scoring.test.ts
src/components/card.tsx      → src/components/card.test.ts
src/app/api/workflows/route.ts → src/app/api/workflows/route.test.ts
```

Shared fixtures and helpers go in `tests/`:
```
tests/
  fixtures/        # Factory functions for mock data
  helpers/         # render-with-providers, mock utilities
  setup.ts         # Global test setup
```

## Configuration

If vitest is not yet configured, set it up:

**vitest.config.ts:**
```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
    include: ['**/*.test.{ts,tsx}'],
    exclude: ['**/node_modules/**', '**/e2e/**'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'text-summary'],
      include: ['src/**/*.{ts,tsx}'],
      exclude: ['src/**/*.test.{ts,tsx}', 'src/**/*.d.ts', 'src/**/types.ts'],
    },
  },
  resolve: { alias: { '@': path.resolve(__dirname, './src') } },
})
```

**tests/setup.ts:**
```typescript
import '@testing-library/jest-dom/vitest'
import { cleanup } from '@testing-library/react'
import { afterEach } from 'vitest'
afterEach(() => { cleanup() })
```

## Patterns

### Naming — describe behavior, not implementation

```typescript
// ✅ Good
it('returns high score for workflows with repetitive manual steps', () => {})
it('throws when workflow has no activities', () => {})

// ❌ Bad
it('should call the scoring function', () => {})
it('works correctly', () => {})
```

### Structure — Arrange, Act, Assert

```typescript
it('returns high score for repetitive manual workflows', () => {
  // Arrange
  const workflow = createMockWorkflow({
    activities: [
      { type: 'manual', frequency: 'daily', duration: 30 },
      { type: 'manual', frequency: 'daily', duration: 45 },
    ],
  })

  // Act
  const score = calculateAutomationScore(workflow)

  // Assert
  expect(score).toBeGreaterThan(0.7)
  expect(score).toBeLessThanOrEqual(1.0)
})
```

### Fixtures — factory functions with realistic domain data

```typescript
// tests/fixtures/workflows.ts
export function createMockWorkflow(overrides?: Partial<Workflow>): Workflow {
  return {
    id: 'wf-test-001',
    name: 'Invoice Approval',
    status: 'active',
    activities: [],
    createdAt: new Date('2025-01-01'),
    updatedAt: new Date('2025-01-01'),
    ...overrides,
  }
}

export function createMockActivity(overrides?: Partial<Activity>): Activity {
  return {
    id: 'act-test-001',
    name: 'Review Invoice',
    type: 'manual',
    owner: 'Accounts Payable',
    duration: 15,
    frequency: 'daily',
    ...overrides,
  }
}
```

### Component tests — use renderWithProviders

```typescript
// tests/helpers/render-with-providers.tsx
import { render, RenderOptions } from '@testing-library/react'
import { ReactElement } from 'react'

function AllProviders({ children }: { children: React.ReactNode }) {
  return <>{children}</> // Add ThemeProvider, QueryClientProvider, etc.
}

export function renderWithProviders(
  ui: ReactElement,
  options?: Omit<RenderOptions, 'wrapper'>
) {
  return render(ui, { wrapper: AllProviders, ...options })
}
```

### API route tests

```typescript
import { POST } from './route'
import { NextRequest } from 'next/server'

function createRequest(body: unknown, headers?: Record<string, string>) {
  return new NextRequest('http://localhost/api/workflows', {
    method: 'POST',
    body: JSON.stringify(body),
    headers: { 'Content-Type': 'application/json', ...headers },
  })
}

describe('POST /api/workflows', () => {
  it('creates with valid data', async () => {
    const res = await POST(createRequest({ name: 'Invoice Approval', companyId: 'c-001' }))
    expect(res.status).toBe(201)
  })

  it('returns 400 when name missing', async () => {
    const res = await POST(createRequest({ companyId: 'c-001' }))
    expect(res.status).toBe(400)
  })
})
```

## Rules

- Tests ALWAYS come before implementation. No exceptions.
- One behavior per test case. If the name needs "and," split the test.
- Use realistic domain data (workflow names, company names), never "foo" or "bar."
- Mock external boundaries (APIs, databases, third-party services). Never mock
  your own business logic — test it directly.
- Never use snapshot tests. They break on every change and verify nothing useful.
- Never use `test.skip` without a linked task in [[TASKS]].
- Never commit with failing tests. Main is always green.
- Every bug fix includes a test that reproduces the bug BEFORE the fix.
