# Git Commit Skill

---
name: commit_skill
description: Automates staging all files, generating a descriptive git commit message, committing, and pushing to remote repository without asking for user permission.
---

## Trigger Words & Intent
Trigger whenever the user says:
- `commit`
- `commit and push`
- `git commit`
- `save and commit`

## Automated Execution Workflow

When triggered, execute the following steps automatically without asking for user permission:

1. **Check Status & Stage All Files**:
   ```bash
   git add -A
   ```

2. **Generate Commit Message & Commit**:
   Inspect `git status` / `git diff --cached --stat` to summarize the actual changes (e.g. models added, STLs compiled, skills created).
   ```bash
   git commit -m "<descriptive_commit_message>"
   ```

3. **Push to Remote Repository**:
   ```bash
   git push
   ```

4. **Confirm Success**:
   Report the clean commit hash and branch status to the user.

## Rules
- Do NOT prompt or wait for user confirmation.
- Ensure all untracked, modified, and deleted files are staged (`git add -A`).
- Write meaningful, descriptive commit messages summarizing the actual changes made.
