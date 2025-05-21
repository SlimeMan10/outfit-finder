# Git Workflow Guide

## IMPORTANT: Always Follow This Order
1. Always pull before starting new work
2. Create a new branch for your work (no matter how small)
3. Make your changes
4. Commit your changes
5. Push your branch
6. Create merge request
7. Get approval
8. Merge
9. Clean up

## WARNING: Common Mistakes to Avoid
- NEVER make new commits before pulling from main
- NEVER use -B when creating branches (it may override existing branches)
- NEVER commit directly to main
- ALWAYS pull before starting new work
- ALWAYS create a new branch for changes
- NEVER make commits in main while a merge request is pending

## Daily Workflow

### 1. Start Your Day
```bash
# Always start with latest main
git checkout main
git pull origin main
```

### 2. Create Your Branch
```bash
# Create and switch to new branch
git checkout -b your-name/feature-type/your-feature-name
# Using your name in the branch name helps prevent accidental branch overrides
# This is especially important when multiple team members work on similar features
```
- NEVER USE -B as it may override a branch that has the same name. In case you do the name in the branch name is a failsafe so most likely you will override your own work.

### 3. Make Changes
- Make your code changes
- Test your changes
- Don't forget to save files

### 4. Commit Your Changes
```bash
# Check what you changed
git status

# Add your changes
git add .

# Commit with clear message
git commit -m "Description of your changes"
```

### 5. Push Your Branch
```bash
# Push your branch to GitLab
git push -u origin feature/your-feature-name
```

## Merge Process

### 1. Create Merge Request (MR)
1. Go to GitLab repository
2. Click "Create merge request" button
3. Fill in:
   - Title: Clear, brief description
   - Description: Detailed explanation
   - Assign reviewers
   - Add labels

### 2. Review Process
- Wait for reviewer comments
- Make requested changes
- Push new commits
- Comment on MR when ready for re-review

### 3. Merging
1. Once approved, click "Merge"
2. Choose "Create a merge commit"
3. Check "Delete source branch"
4. Click "Merge"

### 4. Clean Up
```bash
# Switch to main
git checkout main

# Get latest changes
git pull

# Delete local branch
git branch -d feature/your-feature-name

# Delete remote branch
git push origin --delete feature/your-feature-name
```

## Handling Merge Conflicts

### Preventing Merge Conflicts
1. NEVER make commits in main while a merge request is pending
2. Always pull from main before starting new work
3. Keep your branch up to date with main:
```bash
# While on your feature branch
git checkout main
git pull
git checkout your-branch
git merge main
```

### Resolving Merge Conflicts
If a merge conflict occurs:
1. Pull latest changes from main
2. Resolve conflicts in your editor
3. Add resolved files
4. Commit the merge
5. Push your changes

## Emergency Commands
```bash
# Discard all local changes
git reset --hard HEAD

# Remove untracked files
git clean -fd

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
```

## Best Practices

### Branch Naming
- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Urgent fixes
- `docs/` - Documentation

### Commit Messages
- Start with verb (Add, Fix, Update, etc.)
- Keep it clear and concise
- Reference issue numbers if applicable

### Merge Requests
- Keep changes focused and small
- Include screenshots for UI changes
- Test before requesting review
- Respond to comments promptly

## Quick Reference

### Common Commands
```bash
# Check status
git status

# See changes
git diff

# See commit history
git log

# Stash changes
git stash

# Apply stashed changes
git stash pop
```

## Remember
- Always work in branches
- Never commit to main directly
- Keep commits small and focused
- Communicate with team
- Test before merging
- Never make new commits before pulling
- Always pull before starting new work
- Never make commits in main while a merge request is pending 