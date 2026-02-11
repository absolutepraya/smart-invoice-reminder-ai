---
description: Create a GitHub Pull Request from the current branch using gh CLI
---

## Your Task

Create a GitHub Pull Request for the current branch.

## Prerequisites

- `gh` CLI installed and authenticated (`gh auth status`)
- Current branch pushed to remote
- Changes committed

## Workflow

### Step 1: Gather Context

Run these commands **in parallel**:

```bash
git branch --show-current
git log main..HEAD --oneline
git diff main...HEAD --stat
gh auth status
```

### Step 2: Ask the User

Ask conversationally:
1. "What should the PR title be?"
   - Convention: `<type>(scope): description` (same as commits)
   - Examples: `feat(api): add risk scoring engine`, `fix(web): resolve dashboard loading`
2. "Would you like to add a description? (optional - I'll auto-generate from commits if not)"
3. "Base branch? (default: main)"

### Step 3: Ensure Branch is Pushed

```bash
# Push if not already pushed
git push -u origin $(git branch --show-current)
```

### Step 4: Create the PR

```bash
gh pr create \
  --title "PR title here" \
  --body "$(cat <<'EOF'
## Summary
<1-3 bullet points summarizing the changes>

## Changes
<list of key changes, auto-generated from commits>

## Test Plan
- [ ] Tests pass locally (`make test`)
- [ ] Linting passes (`make lint`)
- [ ] Manually verified [specific behavior]

---
Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)" \
  --base main
```

### Step 5: Output Result

Display the PR URL:
```
Pull Request created: https://github.com/org/smart-invoice-reminder-ai/pull/XX
```

## Auto-Generated Body

If the user doesn't provide a custom description, generate one from commits:

```bash
# Get commit messages since main
COMMITS=$(git log main..HEAD --format="- %s")

# Generate body
## Summary
<Summarize the overall change in 1-2 sentences>

## Changes
$COMMITS

## Test Plan
- [ ] `make test` passes
- [ ] `make lint` passes
```

## Error Handling

| Error | Solution |
|-------|----------|
| `gh: not authenticated` | Run `gh auth login` |
| `branch not found on remote` | Push first: `git push -u origin HEAD` |
| `no commits between main and HEAD` | Nothing to PR — check branch |
| `pull request already exists` | Show existing PR URL |

## Success Criteria

✅ PR created on GitHub
✅ Title follows conventional commits format
✅ Body includes summary, changes, and test plan
✅ Base branch is correct
✅ PR URL displayed to user
