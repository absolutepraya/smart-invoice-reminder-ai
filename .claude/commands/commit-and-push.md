---
description: Create a git commit and push to origin, iterating until both pre-commit and pre-push hooks pass
---

## Your Task

Create a git commit for the staged/unstaged changes following the repository's commit conventions, then push to origin remote.

## Critical Requirements

1. **NEVER update git config** - respect user's existing configuration
2. **NEVER run destructive git commands** unless explicitly requested
3. **NEVER force push** to main/master - warn if requested
4. **NEVER skip hooks** (--no-verify, --no-gpg-sign) - EVEN IF TESTS ARE FLAKY
5. **Iterate until hooks pass** - fix issues automatically when possible
6. **Report and block on flaky tests** - NEVER assume and proceed with --no-verify
7. **Act like an owner** - thoroughly understand changes before committing

## Pre-Commit Hooks

(See `/commit` command for full details)
1. Biome check (web)
2. Ruff check + format (api)
3. tsc --noEmit (web)
4. mypy src/ (api)
5. Knip (web)

## Pre-Push Hooks

The repository has these pre-push checks:
1. **Frontend type check** (`cd apps/web && pnpm typecheck`)
2. **Frontend tests** (`cd apps/web && pnpm test`)
3. **Backend type check** (`cd apps/api && uv run mypy src/`)
4. **Backend tests** (`cd apps/api && uv run pytest`)

## Workflow

### Step 1: Analyze Changes

Run these commands **in parallel** to understand the full context:

```bash
git status && git diff HEAD && git log --oneline -20 --format="%s" && git branch --show-current
```

**CRITICAL**: Take time to thoroughly understand:
- What changed and why
- Which files are affected
- Current branch name
- Whether on main/master (create feature branch if needed)
- Any debugging/temporary code that might need removal

### Step 2: Create Feature Branch (if needed)

```bash
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  git checkout -b "feat/descriptive-feature-name"
fi
```

### Step 3: Stage, Commit, and Iterate

Follow the `/commit` command workflow. Iterate until all pre-commit hooks pass.

### Step 4: Push to Origin

```bash
git push -u origin $(git branch --show-current)
```

**Pre-push hooks run here.**

### Step 5: Handle Pre-Push Hook Failures

#### A. Type Check Failures

```bash
# Fix TypeScript errors
cd apps/web && pnpm typecheck  # See what failed
# Fix issues, stage, amend
git add . && git commit --amend --no-edit
git push -u origin $(git branch --show-current)

# Fix Python type errors
cd apps/api && uv run mypy src/  # See what failed
# Fix issues, stage, amend
git add . && git commit --amend --no-edit
git push -u origin $(git branch --show-current)
```

#### B. Test Failures - THE CRITICAL CASE

**If tests fail, DO NOT proceed. Stop and report.**

**NEVER do this**:
```bash
# NEVER EVER DO THIS
git push --no-verify
```

**Instead, analyze and report**:

```bash
# 1. Review test output carefully
# 2. Run tests again to check for flakiness
cd apps/web && pnpm test       # Frontend tests
cd apps/api && uv run pytest   # Backend tests

# 3. If tests fail consistently → fix the code
# 4. If tests are flaky → REPORT TO USER
```

**Reporting Template for Test Failures**:

```markdown
**Pre-push hook blocked: Test failures detected**

## Summary

Tests failed in `<apps/web | apps/api>`. Based on my analysis, these appear to be
[legitimate test failures | flaky tests | environment issues].

## Failed Tests

<paste test output>

## Analysis

**Likely Cause**:
- [If legitimate]: Changes in [file] broke [functionality]
- [If flaky]: Tests are intermittent and likely unrelated to changes
- [If unclear]: Need more investigation

**Evidence**:
- Ran tests 2-3 times: [Results varied | Consistently failed]
- Changes in this commit: [List key changes]
- Error patterns: [Timeouts | Assertion errors | Import errors]

## Next Steps

1. Fix the identified issue (if legitimate failure)
2. Investigate further (if unclear)
3. Get your approval to use --no-verify (ONLY if you're certain tests are flaky)

**I am blocked and need your help to proceed.**
```

### Step 6: Verify Success

```bash
git log -1 --format="%s"     # Verify commit message
git status                   # Check working tree
git branch -vv               # Verify upstream tracking
```

## Iteration Pattern

```
1. Commit → Pre-commit hooks pass ✅
2. Push → Pre-push hooks run
3. If hooks fail:
   a. Type errors → Fix, amend, retry push
   b. Test failures → STOP, analyze, report to user
4. DO NOT use --no-verify without explicit user approval
5. Iterate until hooks pass OR report blockage
```

## Success Criteria

✅ Commit created successfully
✅ All pre-commit hooks passed
✅ Feature branch created (if was on main)
✅ Pushed to origin with upstream tracking
✅ All pre-push hooks passed
✅ No test failures OR failures analyzed and reported
✅ Working tree is clean
