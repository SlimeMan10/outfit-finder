# Git Workflow Guide

## Branch Management
### Creating a new Branch
- `git checkout -b/B <name>`
    - `-b` creates a new branch if one already exists it will give you an error (safest)
    - `-B` creates a new branch and if one already exists it will override it

### Switching Branches
- `git checkout <branch-name>` - Switch to an existing branch
- `git branch` - List all local branches
- `git branch -a` - List all branches (local and remote)

## Syncing with Main
### Pulling from main
If you are pulling from main do these steps to keep your changes (if we are not doing any branches):
- `git stash` (stashes your current changes to avoid overriding)
- `git pull`
- `git stash pop` (puts all changes back into place)

### Alternative Pull Method
- `git pull --rebase` - Pulls changes and rebases your local commits on top

## Making Changes
### Committing Changes
- `git add .` - Stage all changes
- `git add <file>` - Stage specific file
- `git commit -m "your message"` - Commit staged changes
- `git commit -am "your message"` - Stage and commit all tracked files

### Pushing Changes
- `git push origin <branch-name>` - Push your branch to remote
- `git push -u origin <branch-name>` - Push and set upstream branch

## Resolving Conflicts
1. Pull latest changes: `git pull`
2. If conflicts occur:
   - Resolve conflicts in your code editor
   - `git add` the resolved files
   - `git commit` to complete the merge

## Useful Commands
- `git status` - Check current status
- `git log` - View commit history
- `git diff` - See changes in working directory
- `git diff --staged` - See staged changes

## Best Practices
1. Always pull before starting new work
2. Create feature branches for new features
3. Write clear commit messages
4. Keep commits focused and atomic
5. Review changes before committing
6. Don't commit sensitive information

## Emergency Commands
- `git reset --hard HEAD` - Discard all local changes
- `git clean -fd` - Remove untracked files and directories
- `git revert <commit>` - Undo a specific commit

## Team Communication
- Use meaningful branch names (e.g., `feature/login`, `bugfix/navbar`)
- Keep commit messages clear and descriptive
- Communicate when pushing major changes
- Review code before merging to main

## GitLab Merge Process
### Creating a Merge Request (MR)
1. Push your branch to GitLab: `git push origin <branch-name>`
2. Go to GitLab repository in your browser
3. Click "Create merge request" button that appears after pushing
4. Fill in the merge request details:
   - Title: Brief description of changes
   - Description: Detailed explanation of changes
   - Assign reviewers
   - Add labels if needed

### Review Process
1. Team members will review your code
2. Address any review comments:
   - Make requested changes
   - Push new commits to your branch
   - Comment on the MR to notify reviewers

### Merging
1. Once approved, click "Merge" button
2. Choose merge strategy:
   - "Create a merge commit" (recommended)
   - "Squash and merge"
   - "Fast-forward merge"
3. Delete source branch after merge (recommended)

### After Merging
1. Switch to main branch: `git checkout main`
2. Pull latest changes: `git pull`
3. Delete local branch: `git branch -d <branch-name>`
4. Delete remote branch: `git push origin --delete <branch-name>`

### Merge Request Best Practices
1. Keep MRs small and focused
2. Update MR description if changes are made
3. Respond to review comments promptly
4. Test changes before requesting review
5. Include screenshots for UI changes
6. Reference related issues/tickets

