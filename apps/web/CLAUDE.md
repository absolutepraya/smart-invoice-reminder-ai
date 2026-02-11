# apps/web — Frontend Dashboard

> **Auto-update this file.** This CLAUDE.md reflects the current boilerplate state. As the codebase evolves — new directories, patterns, dependencies, or conventions — update this file to stay accurate. When you add or change something significant in `apps/web/`, reflect it here.

React + Vite SPA for the AR Risk & Collection Dashboard.

## Tech Stack

- **React 19** with **Vite** (SPA, no SSR)
- **TanStack Router** — file-based routing in `src/routes/`
- **TanStack Query** — server state management, API caching
- **Tailwind CSS** — utility-first styling
- **Biome** — linting + formatting (NOT ESLint)
- **Vitest** — testing
- **Knip** — dead code detection
- **TypeScript** — strict mode

## Commands

```bash
pnpm dev          # Dev server on port 3000
pnpm build        # tsc + vite build
pnpm lint         # Biome check
pnpm lint:fix     # Biome auto-fix
pnpm format       # Biome format
pnpm typecheck    # tsc --noEmit
pnpm test         # Vitest
pnpm knip         # Dead code detection
```

## Architecture

```
src/
  routes/       → Thin route definitions (file-based, TanStack Router)
  pages/        → Page components (actual UI content)
  queries/      → TanStack Query hooks (one file per domain)
  components/
    ui/         → Primitives (Button, Card, Table)
    layout/     → Sidebar, Navbar, PageHeader
  lib/          → Shared utilities (api client, formatters, constants)
  types/        → TypeScript interfaces
```

### Data Flow

```
Route → Page → Query Hook → API Client → FastAPI Backend
                  ↓
            TanStack Query (cache, refetch, stale management)
```

### Key Patterns

- **Routes are thin** — only define the route and point to a page component. No logic in routes.
- **Queries are the API layer** — all API calls go through `src/queries/`. Never use raw axios/fetch in components.
- **Pages compose queries + components** — pages import from queries and components, never talk to the API directly.
- **Lib is shared** — `src/lib/` is used by pages, queries, and components alike.

## Conventions

### Imports
- Use path alias: `import { api } from '@/lib/api'`
- Use `import type` for type-only imports
- Biome auto-organizes imports

### Styling
- Single quotes, no semicolons (Biome enforced)
- Tailwind for all styling — no CSS modules, styled-components, or inline styles
- Line width: 100 characters

### Components
```tsx
// Functional components only, with explicit return types when complex
export function InvoiceCard({ invoice }: { invoice: Invoice }) {
  return (
    <div className="rounded-lg border p-4">
      <h3>{invoice.client_name}</h3>
      <p>{formatCurrency(invoice.amount)}</p>
    </div>
  )
}
```

### Query Hooks
```tsx
// One file per domain: use-invoices.ts, use-clients.ts, use-risk.ts
export function useOverdueInvoices() {
  return useQuery({
    queryKey: ['invoices', 'overdue'],
    queryFn: () => api.get('/invoices/overdue').then((r) => r.data),
  })
}
```

### Route Files
```tsx
// Routes are thin — just point to a page
import { createFileRoute } from '@tanstack/react-router'
import { DashboardPage } from '@/pages/dashboard'

export const Route = createFileRoute('/dashboard')({
  component: DashboardPage,
})
```

## Common Pitfalls

- **Never use `any`** — always define proper types
- **Never fetch in components** — use query hooks from `src/queries/`
- **Never put logic in routes** — routes only define component + optional loader
- **Don't ignore Knip output** — dead exports accumulate fast
- **Don't create new utility files casually** — check if `src/lib/` already has what you need
- **`src/routeTree.gen.ts` is auto-generated** — never edit it manually

## API Client

All API calls go through `src/lib/api.ts`:
```tsx
import { api } from '@/lib/api'

// Base URL from VITE_API_URL env var
// Auto-redirects to /login on 401
```

The Vite dev server proxies `/api` to `http://localhost:8000` so no CORS issues in development.
