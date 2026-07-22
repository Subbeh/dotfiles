---
name: commit
description: Create intelligent git commits following Conventional Commits. Use when the user says "/commit", asks to commit changes, or wants to create git commits. Supports single commit mode (staged changes only) and batch mode (analyzes all changes, groups related ones into multiple logical commits). Triggers on "/commit", "/commit --all", "commit my changes", "commit this".
---

# Intelligent Commit

Create precise, well-structured git commits with automatic change analysis and interactive scope selection.

## Step 1: Gather Context

Run these commands in parallel:

```bash
git status
git diff --cached --stat
git diff --cached
git log --oneline -10
git branch --show-current
find . -maxdepth 1 -name "CONTRIBUTING.md" -o -name "CONTRIBUTING" -o -path "./docs/CONTRIBUTING.md" -o -path "./docs/CONTRIBUTING" -o -path "./.github/CONTRIBUTING.md" -o -path "./.github/CONTRIBUTING"
```

For large staged diffs (>500 lines total), use `git diff --cached --stat` first, then selectively read key files with `git diff --cached -- <file>`.

**If a CONTRIBUTING.md (or CONTRIBUTING) file exists** (check `./`, `./docs/`, and `./.github/`), read it and follow any commit-related guidelines it contains (commit message format, branch naming, sign-off requirements, etc.). Those guidelines take precedence over the defaults in this skill where they conflict.

## Step 2: Determine Scope

Analyze `git status` output and follow this decision tree:

### 2a: Check for changes

- **No changes at all** → Abort: "No changes to commit."
- **Merge conflict markers in status** → Abort: "Resolve merge conflicts before committing."

### 2b: Determine commit scope

| Situation                      | Action                           |
| ------------------------------ | -------------------------------- |
| User passed `--all`            | Batch mode, skip scope question  |
| ONLY staged changes exist      | Single mode, skip scope question |
| ONLY unstaged/untracked exist  | Batch mode, skip scope question  |
| BOTH staged AND unstaged exist | **Ask user** (see below)         |

When both staged and unstaged changes exist, ask the user using AskUserQuestion:

**Question:** "Both staged and unstaged changes detected. What would you like to commit?"
**Options:**

1. "Only staged changes" → Single mode (staged only)
2. "All changes" → Batch mode (stage everything, group logically)

## Step 3: Verify Branch

Check the current branch from `git branch --show-current` output gathered in Step 1.

**If on `main` or `master`:**

First, analyze the changes to derive a suggested branch name from the primary change: `type/short-kebab-description`
- Examples: `feat/add-tmux-session-picker`, `fix/ssh-jump-host-matching`, `chore/cleanup-zsh-aliases`
- Keep it under 50 characters

Ask the user using AskUserQuestion:

**Question:** "You're on main. Create branch `<suggested-name>`?"
**Options:**

1. "Yes, create branch" → Create the suggested branch
2. "Use different name" → Ask for custom name, then create
3. "Commit to main" → Proceed without creating branch

**Branch creation:**

Create branch from current HEAD (not from main) — this avoids stash/pop complexity:

```bash
git switch -c <branch-name>
```

This works with uncommitted changes because no file content changes during the switch.

**If on any other branch:**

Check if the branch name relates to the changes being committed. If there's a clear mismatch (e.g., branch is `feat/ignore-config` but changes are about profile attributes), ask the user:

**Question:** "Branch `feat/ignore-config` doesn't seem to match these changes. What would you like to do?"
**Options:**

1. "Create new branch" → Derive name from changes, create branch
2. "Commit anyway" → Proceed on current branch

If branch name reasonably matches the changes, proceed without prompting.

## Single Commit Mode

### Analyze

Read `git diff --cached` output. Skip binary file contents. For lock files (package-lock.json, yarn.lock, etc.), note their presence but do not base the message on their contents.

### Generate Commit Message

Format: `type(scope): concise imperative description`

**Type selection:**

| Type       | When                                    |
| ---------- | --------------------------------------- |
| `feat`     | New functionality or capability         |
| `fix`      | Bug fix or error correction             |
| `refactor` | Code restructuring, no behavior change  |
| `perf`     | Performance improvement                 |
| `style`    | Formatting, whitespace only             |
| `docs`     | Documentation only                      |
| `test`     | Adding or updating tests                |
| `chore`    | Build, tooling, dependencies, config    |
| `ci`       | CI/CD pipeline changes                  |
| `security` | Security hardening or vulnerability fix |
| `revert`   | Reverting a previous commit             |

**Scope rules:**

- Derive from the primary directory or module affected
- Lowercase, single word when possible. I.e. `db`, `ui`, `api`, `auth`, `cli`
- Omit scope if changes span 3+ unrelated modules
- Match scopes used in recent `git log` output when applicable

**Subject line rules:**

- Imperative mood ("add", "fix", "update" — not "added", "fixes", "updates")
- Lowercase first letter after colon
- Max 72 characters total (type + scope + description)
- No trailing period
- Be specific: "add retry logic for failed API calls" not "update API code"

**Body rules — include body when changes touch 2+ files or diff exceeds 30 lines:**

- Blank line after subject
- Wrap at 72 characters
- Summarize: what changed, why, and key details
- Use bullet points for multiple distinct changes

**Examples:**

```
feat(k8s): add prometheus alerting rules for node pressure

- Add alerts for memory, disk, and CPU pressure conditions
- Configure 5m evaluation window to reduce alert noise
- Route critical alerts to PagerDuty, warnings to Slack
```

```
fix(ssh): correct host matching for jump hosts
```

```
chore(zsh): reorganize plugin load order
```

**NEVER include:**

- Co-Authored-By lines
- AI/tool attribution ("Generated by", "Created with")
- Emoji in commit messages
- Vague messages ("update code", "fix stuff", "minor changes")

### Execute

```bash
git commit -m "$(cat <<'EOF'
type(scope): subject line

- Body point 1
- Body point 2
EOF
)"
```

Run `git status` after to verify success and display the result.

## Batch Commit Mode

### Inventory Changes

```bash
git status --porcelain
```

Parse each line: status code + file path.

### Group Changes

Group files by logical affinity:

1. Co-dependent files (implementation + test, component + styles)
2. Manifest + lock file pairs (package.json + package-lock.json)
3. Same feature/module directory
4. Same change type (all config, all docs)
5. Remaining files form catch-all group

**Balancing rules:**
- Target 2-5 commits, never exceed 7
- If a group exceeds 10 files, split by subdirectory or change type
- If only 1 group results, fall back to single commit mode

**Commit ordering** — present and execute commits in this order:
1. Infrastructure/config (CI, build, tooling)
2. Database/schema changes
3. Features (`feat`)
4. Bug fixes (`fix`)
5. Tests
6. Documentation/style

### Present Plan

Display the commit plan before executing:

```
Proposed commits:

1. feat(tmux): add session picker with fzf integration
   - tmux/.config/tmux/scripts/session-picker.sh
   - tmux/.config/tmux/tmux.conf

2. fix(nvim): correct LSP attach for go files
   - nvim/.config/nvim/lua/plugins/lsp.lua

3. chore(zsh): clean up unused aliases
   - zsh/.config/zsh/.zshrc.d/aliases.zsh
```

Ask: **"Proceed with these commits?"** and wait for user confirmation.

### Execute Sequentially

For each group in order:

1. Reset staging area: `git reset` (only if previous staging exists)
2. Stage group files: `git add -A -- <file1> <file2> ...`
   - The `-A` flag ensures deletions are staged properly
3. Generate commit message (same rules as single mode)
4. Execute: `git commit -m "..."`
5. Verify: `git status`

**If any commit fails** (pre-commit hook, etc.): stop immediately, report the error, do NOT continue to next group. Never use `--no-verify` unless the user explicitly requests it.

### Summary

After all commits succeed:

```
Created 3 commits:
  abc1234 feat(tmux): add session picker with fzf integration
  def5678 fix(nvim): correct LSP attach for go files
  ghi9012 chore(zsh): clean up unused aliases
```

## After Committing

After all commits succeed, ask the user:

**Question:** "Push and create PR?"
**Options:**

1. "Push and create PR" → Sync, push, then create PR (see below)
2. "Push only" → Sync, then run `git push -u origin <branch-name>`, done
3. "No" → Done

**Check upstream status before push:**

If `git status` shows "upstream is gone" (remote branch was deleted), ask the user:

**Question:** "Remote branch was deleted (PR likely merged/closed). What would you like to do?"
**Options:**

1. "Create new branch and push" → Create new branch from current HEAD, push, then offer PR creation
2. "Push anyway (recreate old branch)" → Push to same branch name, do NOT offer PR (old PR may reopen)
3. "Cancel" → Done, do not push

**Sync before push:**

```bash
git fetch origin
```

**Step 1: Check if behind main**

```bash
git rev-list --count HEAD..origin/main
```

If count > 0, the branch is behind main. Ask the user:

**Question:** "Branch is X commits behind main. Rebase before pushing?"
**Options:**

1. "Yes, rebase onto main" → Run `git rebase origin/main`
2. "No, push as-is" → Proceed without rebase

If rebase has conflicts:
```bash
git rebase --abort
```
Report: "Rebase onto main has conflicts. Resolve manually with `git rebase origin/main` and re-run `/commit`." Stop here — do not push.

**Step 2: Check if behind own upstream (existing branches only)**

Skip for newly created branches (no upstream yet).

```bash
git rev-list --count HEAD..origin/<branch-name>
```

If count > 0 (behind remote), attempt rebase:
```bash
git rebase origin/<branch-name>
```

If rebase has conflicts:
```bash
git rebase --abort
```
Report: "Branch is behind remote and rebase has conflicts. Resolve manually with `git pull --rebase` and re-run `/commit`." Stop here — do not push.

If both checks pass (or user chose to skip), proceed with push.

**PR creation:**

```bash
git push -u origin <branch-name>
gh pr create --fill
```

Use `--fill` to auto-populate title and body from commit message(s). If multiple commits, the PR body will list them.

## Edge Cases

| Scenario                            | Handling                                                                      |
| ----------------------------------- | ----------------------------------------------------------------------------- |
| Binary files                        | Include in commit, do not analyze content, note as "add/update binary assets" |
| Lock files                          | Always group with their manifest file, never standalone commit                |
| Very large diffs (>1000 lines/file) | Use `--stat` + read first 100 lines for context                               |
| Untracked files only                | Stage and commit normally, usually `feat` or `chore`                          |
| Submodule changes                   | Note in message, do not analyze submodule internals                           |
| Pre-commit hook failure             | Report clearly, do NOT retry, suggest user fix and re-run `/commit`           |
| Empty staging after auto-detect     | Switch to batch mode, inform user                                             |
