---
description: Create a git commit following conventional commits format, iterating until pre-commit hooks pass
---

## Your Task

Create a git commit for the staged/unstaged changes following the repository's commit conventions.

## Critical Requirements

1. **NEVER update git config** - respect user's existing configuration
2. **NEVER run destructive git commands** unless explicitly requested
3. **NEVER skip hooks** (--no-verify, --no-gpg-sign) unless explicitly requested
4. **NEVER use git commit --amend** unless explicitly requested
5. **Iterate until pre-commit hooks pass** - fix issues automatically when possible
6. **Act like an owner** - thoroughly understand changes before committing

## Pre-Commit Hooks

The repository has these pre-commit checks (in order):
1. **Biome check** (`pnpm lint`) - Frontend lint + format check
2. **Ruff check** (`uv run ruff check . && uv run ruff format --check .`) - Backend lint + format
3. **TypeScript compile** (`pnpm typecheck`) - Frontend type check
4. **mypy** (`uv run mypy src/`) - Backend type check
5. **Knip** (`pnpm knip`) - Frontend dead code detection

## Workflow

### Step 1: Analyze Changes

Run these commands **in parallel** to understand the full context:

```bash
# Get current status, diff, and recent commits
git status && git diff HEAD && git log --oneline -20 --format="%s"
```

**CRITICAL**: Take time to thoroughly understand:
- What changed and why
- Which files are affected
- How changes relate to each other
- Whether changes should be split into multiple commits
- Any debugging/temporary code that might need removal

### Step 2: Draft Commit Message

Follow the repository's **conventional commits** format:

```
<type>[optional scope]: <description>

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring (no functional changes)
- `test`: Test additions or modifications
- `docs`: Documentation changes
- `chore`: Build process, dependencies, tooling

**Scopes**:
- `web`: Frontend changes
- `api`: Backend changes
- `worker`: Celery worker/task changes
- `infra`: Docker, Nginx, Compose changes
- `db`: Database migrations, schema changes
- `ci`: GitHub Actions, CI/CD changes
- `lint`: Linting/formatting fixes
- `hooks`: Git hooks changes

**Examples**:
```
feat(api): add risk scoring endpoint
fix(web): resolve dashboard loading state
chore(infra): update Docker base image
refactor(worker): improve retry logic for reminder tasks
feat(db): add client risk history migration
chore: replace ESLint with Biome
```

### Step 3: Stage Files and Commit

```bash
# Stage relevant files
git add <files>

# Create commit with heredoc for proper formatting
git commit -m "$(cat <<'EOF'
fix(api): improve risk scoring with payment history weights

- Add weighted scoring based on payment frequency
- Handle edge case for new clients with no history
- Update Pydantic response model with score breakdown

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 4: Handle Pre-Commit Hook Failures

If pre-commit hooks fail:

**A. Biome Lint/Format Issues (web)**:
```bash
# Auto-fix
cd apps/web && pnpm lint:fix
# Stage fixes and retry commit
git add apps/web/ && git commit -m "..."
```

**B. Ruff Lint/Format Issues (api)**:
```bash
# Auto-fix
cd apps/api && uv run ruff check --fix . && uv run ruff format .
# Stage fixes and retry commit
git add apps/api/ && git commit -m "..."
```

**C. TypeScript Type Errors (web)**:
- Fix type errors manually
- Stage fixes and retry commit

**D. mypy Type Errors (api)**:
- Fix type annotation issues manually
- Stage fixes and retry commit

**E. Knip Dead Code (web)**:
- Review Knip output carefully
- Remove unused exports/imports
- **Manually verify** before deleting files
- Stage fixes and retry commit

**Iteration Pattern**:
```
1. Attempt commit → Pre-commit hook fails
2. Review failure output
3. Fix issues (auto-fix if safe, manual if not)
4. Stage fixes: git add <files>
5. Retry commit
6. Repeat until hooks pass
```

### Step 5: Verify Success

```bash
# After successful commit
git log -1 --format="%s" # Verify commit message
git status              # Ensure clean working tree
```

## Important Notes

- **Act like an owner**: Understand changes deeply before committing
- **Never skip hooks**: Fix issues, don't bypass them
- **Auto-fix when safe**: Format/lint issues can be auto-fixed
- **Manual review for risky changes**: Dead code removal, type errors
- **Iterate patiently**: Keep trying until all hooks pass

## Edge Cases

**Debugging/Temporary Code**:
If you find debugging code (console.logs, print statements), mention it:
```
fix(api): improve invoice query performance

Note: contains temporary logging in risk_service.py for monitoring - remove before prod
```

**Multiple Unrelated Changes**:
If changes span multiple concerns, consider splitting:
```bash
# Split into separate commits
git add apps/web/
git commit -m "feat(web): add client risk history chart"
git add apps/api/
git commit -m "feat(api): add client risk history endpoint"
```

**Pre-Commit Hook Modifies Files**:
This is expected - formatters auto-fix and re-stage files. Just retry the commit.

## Success Criteria

✅ Commit created successfully
✅ All pre-commit hooks passed
✅ Commit message follows conventional commits format
✅ Changes are accurately described
✅ Working tree is clean
✅ No debugging code committed (unless intentional with note)
