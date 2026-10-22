# Release Preparation Checklist

Prepare and validate a release before tagging and pushing.

This command prevents release mistakes by validating everything first.

## What This Does

1. **Validates git state** - No uncommitted changes, clean working tree
2. **Analyzes commits** - Reviews all commits since last tag
3. **Determines version** - Calculates next version from conventional commits
4. **Generates changelog** - Preview what will be in CHANGELOG.md
5. **Validates builds** - Ensures the library builds and validates (`bb test && bb build && bb validate`)
6. **Creates release** - Tags, pushes, triggers GitHub Actions (if approved)

## Usage

```
/release-prep [version]
```

**Examples:**
```bash
/release-prep          # Auto-detect next version
/release-prep v0.3.0   # Specify version explicitly
/release-prep patch    # Force patch version
/release-prep minor    # Force minor version
/release-prep major    # Force major version
```

## Process

### Step 1: Validate Git State
```
🔍 Checking git status...
  ✓ Working directory clean
  ✓ All changes committed
  ✓ On branch: feat/new-classes
  ✓ Up to date with remote

Current branch: feat/new-classes
Target branch: main
```

If uncommitted changes:
```
❌ Uncommitted changes detected!

Modified files:
  source/person/properties.edn
  source/creative-work/classes.edn

💡 Please commit or stash changes before releasing:
  git add .
  git commit -m "feat: final changes"

Or force release anyway? [y/N]
```

### Step 2: Analyze Commits Since Last Tag
```
📋 Commits since v0.2.0 (14 commits)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feat(classes): add Recipe class (abc1234)
feat(properties): add cookTime to Recipe (def5678)
feat(classes): add Book class with ISBN (ghi9012)
fix(templates): correct spouse cardinality (jkl3456)
docs: update quickstart guide (mno7890)
chore(deps): update dependencies (pqr1234)
... (8 more)

Summary:
  5 features (feat)
  1 fix
  2 docs updates
  6 chores

Breaking changes: None
```

If invalid commit messages found:
```
⚠️  Warning: Non-conventional commits detected

These commits don't follow conventional commits:
  - "Added new property" (should be: feat: add new property)
  - "fixed bug" (should be: fix: correct ...)

Continue anyway? [y/N]
```

### Step 3: Determine Next Version
```
📦 Version Calculation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current version: v0.2.0

Based on conventional commits:
  5 features (feat) → MINOR bump
  1 fix → PATCH bump
  0 breaking changes → No MAJOR bump

Recommended: v0.3.0

Override version? [0.3.0]:
```

**Version Logic:**
- `feat:` → minor bump (0.2.0 → 0.3.0)
- `fix:` → patch bump (0.2.0 → 0.2.1)
- `BREAKING CHANGE:` → major bump (0.2.0 → 1.0.0)
- Multiple types → highest wins

### Step 4: Generate Changelog Preview
```
📝 Changelog Preview for v0.3.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## [0.3.0] - 2025-11-08

### Features
- **classes**: add Recipe class with 5 properties (abc1234)
- **properties**: add cookTime to Recipe class (def5678)
- **classes**: add Book class with ISBN property (ghi9012)
- **classes**: add Article class for blog posts (stu5678)
- **properties**: add datePublished to CreativeWork (vwx9012)

### Bug Fixes
- **templates**: correct spouse property cardinality from :many to :one (jkl3456)

### Documentation
- update quickstart guide with new classes (mno7890)
- add examples for Recipe and Book classes (yza3456)

### Chores
- **deps**: update dependencies (pqr1234)
- update dependencies (bcd7890)
- clean up temporary files (efg1234)
... (3 more)

Full changelog will be written to CHANGELOG.md
```

### Step 5: Validate All Builds
```
🔨 Running bb test && bb build && bb validate ...
  [████████████] full      (8,934 lines) ✓
  [████████████] crm       (5,389 lines) ✓
  [████████████] research  (4,203 lines) ✓
  [████████████] content   (3,902 lines) ✓
  [████████████] events    (2,801 lines) ✓

All builds successful! ✅
```

If any build fails:
```
❌ Build failed

Cannot release with broken builds!

💡 Options:
  1. Fix the build: bb build
  2. Abort release: [recommended]

Abort release? [Y/n]
```

### Step 6: Run Pre-Release Checks
```
✅ Pre-Release Checklist
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓ Git working directory clean
  ✓ All commits follow conventional commits
  ✓ Version bump calculated: v0.2.0 → v0.3.0
  ✓ Changelog generated successfully
  ✓ bb build succeeds
  ✓ bb validate passes
  ✓ No uncommitted changes
  ✓ Branch up to date with remote
  ✓ No merge conflicts detected

Everything looks good! ✅
```

### Step 7: Confirm and Execute
```
🚀 Ready to Release v0.3.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This will:
  1. Write CHANGELOG.md
  2. Commit changelog: "docs(release): update changelog for v0.3.0"
  3. Create git tag: v0.3.0
  4. Push to remote (triggers GitHub Actions)
  5. GitHub Actions will:
     - Run bb test, bb build, bb validate
     - Generate release notes
     - Create GitHub release
     - Upload .edn files as release assets

Proceed with release? [Y/n]:
```

If user confirms:
```
📤 Executing release...

  ✓ Wrote CHANGELOG.md
  ✓ Committed changelog
  ✓ Created tag v0.3.0
  ✓ Pushed to remote

🎉 Release v0.3.0 initiated!

GitHub Actions is now running:
  → https://github.com/YourOrg/logseq-template-graph/actions

The release will be available at:
  → https://github.com/YourOrg/logseq-template-graph/releases/tag/v0.3.0

Estimated completion: 3-5 minutes
```

## Manual Release Process (if preferred)

If you want to do it manually:

```bash
# 1. Determine version
npm run version

# 2. Generate changelog
npm run changelog:write

# 3. Commit changelog
git commit -am "docs(release): update changelog for v0.3.0"

# 4. Tag
git tag v0.3.0

# 5. Push
git push --tags
```

## Error Scenarios

### Uncommitted Changes
```
❌ Cannot release with uncommitted changes

Modified:
  source/person/properties.edn
  README.md

Options:
  1. Commit changes: git add . && git commit -m "..."
  2. Stash changes: git stash
  3. Force release (not recommended): --force
```

### Version Conflict
```
❌ Tag v0.3.0 already exists!

Existing tag: v0.3.0 (created 2025-11-01)

Options:
  1. Use different version: v0.4.0, v1.0.0
  2. Delete existing tag: git tag -d v0.3.0 (dangerous!)
  3. Abort release
```

### Build Failure
```
❌ Cannot release: build validation failed

Failed step: bb build

See error above or run:
  /diagnose full

Release aborted for safety.
```

### No Changes Since Last Release
```
⚠️  Warning: No commits since last tag (v0.2.0)

Current HEAD is already tagged as v0.2.0

Nothing to release!

Did you mean to:
  - Make changes first?
  - Create a patch release anyway? (not recommended)
```

## Tips

- **First time?** Run `/validate-env` to check setup
- **Test builds first?** Run `/test-workflow` before releasing
- **Unsure about version?** Let the tool auto-detect from commits
- **Want to preview?** Run with `--dry-run` (doesn't actually release)

## Conventional Commits Guide

Your commit messages determine the version bump:

| Commit Type | Example | Version Impact |
|-------------|---------|---------------|
| `feat:` | `feat: add Recipe class` | Minor (0.2.0 → 0.3.0) |
| `fix:` | `fix: correct cardinality` | Patch (0.2.0 → 0.2.1) |
| `BREAKING CHANGE:` | `feat!: remove Customer class` | Major (0.2.0 → 1.0.0) |
| `docs:` | `docs: update README` | No bump (chore) |
| `chore:` | `chore: update deps` | No bump (chore) |

**Scopes** (optional):
- `feat(classes): ...`
- `fix(templates): ...`
- `docs(release): ...`

See: [CLAUDE.md - Conventional Commits](../../CLAUDE.md#conventional-commits)

## Time Savings

**Manual release:** ~15-20 minutes
- Check git status (2 min)
- Review commits (3 min)
- Calculate version (2 min)
- Generate changelog (5 min)
- Build and validate (3 min)
- Tag and push (5 min)

**With /release-prep:** ~5 minutes
- Automated checks (2 min)
- Review and confirm (3 min)

**Saves:** 10-15 minutes per release

## Related Commands

- `/test-workflow` - Test changes before releasing
- `/validate-env` - Check environment setup
- `/stats` - View project statistics

## Learn More

- [Conventional Commits](https://www.conventionalcommits.org/)
- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)
- [CLAUDE.md - Git Workflow](../../CLAUDE.md#git-workflow)
