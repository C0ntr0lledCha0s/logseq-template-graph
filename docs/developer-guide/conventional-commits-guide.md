# Conventional Commits Guide

This guide explains how to use conventional commits in the Logseq Template Graph project for automated changelog generation and semantic versioning.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Commit Message Format](#commit-message-format)
- [Benefits](#benefits)
- [Tools and Automation](#tools-and-automation)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

---

## Overview

**Conventional Commits** is a specification for adding human and machine-readable meaning to commit messages. This project uses the [git-conventional-commits](https://github.com/qoomon/git-conventional-commits) tool to:

- **Automatically generate changelogs** from commit history
- **Determine semantic version** bumps (major.minor.patch)
- **Validate commit messages** before they're committed
- **Standardize contribution** workflow across contributors

### Key Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [git-conventional-commits Tool](https://github.com/qoomon/git-conventional-commits)
- [Configuration Gist](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)

---

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Setup Git Hooks

This enables automatic commit message validation:

```bash
npm run setup
```

### 3. Make a Commit

```bash
git commit -m "feat(classes): add Recipe class with cookTime property"
```

If your commit message doesn't follow the format, the hook will reject it:

```
❌ Commit message does not follow conventional commits format
Expected: type(scope): description
Example: feat(classes): add Recipe class
```

---

## Commit Message Format

### Structure

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Components

#### 1. **Type** (required)

Describes the kind of change:

| Type | Description | Changelog | Version Bump |
|------|-------------|-----------|--------------|
| `feat` | New features or enhancements | ✅ Included | Minor (0.x.0) |
| `fix` | Bug fixes | ✅ Included | Patch (0.0.x) |
| `docs` | Documentation only | ✅ Included | - |
| `style` | Formatting, no logic change | ❌ Excluded | - |
| `refactor` | Code restructuring | ✅ Included | - |
| `perf` | Performance improvements | ✅ Included | - |
| `test` | Test additions/corrections | ❌ Excluded | - |
| `build` | Build system, dependencies | ✅ Included | - |
| `ops` | Infrastructure, deployment | ❌ Excluded | - |
| `chore` | Miscellaneous | ❌ Excluded | - |

#### 2. **Scope** (optional but recommended)

Indicates what area of the project is affected:

- `templates` - .edn template files
- `classes` - Schema.org class definitions
- `properties` - Schema.org property definitions
- `ci` - CI/CD pipeline
- `scripts` - Build/export/validation scripts
- `docs` - Documentation
- `release` - Release process
- `modular` - Modular architecture
- `workflow` - Development workflow

#### 3. **Description** (required)

Brief summary of the change:

- Use **imperative mood** ("add" not "added")
- **Lowercase** first letter
- **No period** at the end
- **Max 100 characters**

#### 4. **Body** (optional)

Detailed explanation of the change:

- Explain **why** the change was made
- Provide **context** and **reasoning**
- Separate from description with blank line

#### 5. **Footer** (optional)

Additional metadata:

- **Breaking changes**: `BREAKING CHANGE: description`
- **Issue references**: `Closes #123`, `Fixes #456`
- **Co-authors**: `Co-authored-by: Name <email>`

---

## Benefits

### 1. Automated Changelog Generation

Instead of manually maintaining `CHANGELOG.md`, run:

```bash
npm run changelog:write
```

This generates a changelog grouped by type:

```markdown
## Features & Enhancements
- feat(classes): add Recipe class with cookTime property
- feat(properties): add allergens property

## Bug Fixes
- fix(templates): correct spouse cardinality from :many to :one

## Documentation
- docs: update installation guide for Windows
```

### 2. Automatic Version Bumping

Determine the next version based on commits:

```bash
npm run version
# Output: 0.3.0
```

Version rules:
- `feat` commits → **minor** version bump (0.x.0)
- `fix` commits → **patch** version bump (0.0.x)
- `BREAKING CHANGE` → **major** version bump (x.0.0)

### 3. CI/CD Integration

GitHub Actions automatically:
- **Validates** commits in pull requests
- **Generates** release notes from commits
- **Creates** releases with proper changelogs

### 4. Consistent History

All commits follow the same format, making it easy to:
- **Search** for specific types of changes
- **Filter** commits by scope
- **Understand** project history at a glance

---

## Tools and Automation

### NPM Scripts

```bash
# Setup git hooks for validation
npm run setup

# Determine next version from commits
npm run version

# Generate changelog preview
npm run changelog

# Write changelog to CHANGELOG.md
npm run changelog:write

# Manually validate commit message
npm run validate:commits
```

### Git Hooks

After running `npm run setup`, git hooks are installed:

- **commit-msg hook**: Validates every commit message
- **Prevents invalid commits** from being created
- **Provides helpful error messages** with examples

### GitHub Actions

Two workflows handle automation:

#### 1. Validate Commits (`.github/workflows/validate-commits.yml`)

Runs on pull requests to validate all commit messages.

#### 2. Release Workflow (`.github/workflows/release.yml`)

Enhanced to generate changelogs from conventional commits when creating releases.

---

## Examples

### Feature Addition

```bash
# Simple feature
git commit -m "feat(classes): add Recipe class"

# Feature with body and footer
git commit -m "feat(properties): add comprehensive nutrition properties

Added the following properties to Recipe class:
- calories (number)
- protein (number)
- carbohydrates (number)
- fat (number)
- fiber (number)

All properties follow Schema.org NutritionInformation specification.

Closes #42"
```

### Bug Fix

```bash
# Simple fix
git commit -m "fix(templates): correct spouse cardinality"

# Fix with explanation
git commit -m "fix(scripts): handle empty property lists in validation

The validation script was failing when classes had no properties.
Added null check and default empty array handling.

Fixes #58"
```

### Documentation

```bash
git commit -m "docs: update Windows installation instructions"
git commit -m "docs(contributing): add conventional commits section"
```

### Breaking Change

```bash
git commit -m "feat(classes)!: remove deprecated Customer class

BREAKING CHANGE: The Customer class has been removed in favor of
using the Person class with a customerRole property.

Migration steps:
1. Export existing Customer pages
2. Re-import as Person pages
3. Add customerRole property

See docs/migration/v1.0.0.md for detailed instructions.

Closes #100"
```

### Multiple Types in One Commit

**Don't do this** - keep commits focused:

```bash
# ❌ Bad - multiple unrelated changes
git commit -m "feat(classes): add Recipe class and fix Event bug"

# ✅ Good - separate commits
git commit -m "feat(classes): add Recipe class"
git commit -m "fix(classes): correct Event inheritance"
```

---

## Troubleshooting

### Hook Not Running

If commits aren't being validated:

```bash
# Re-run setup
npm run setup

# Check git config
git config core.hooksPath
# Should output: .git-hooks

# Verify hook exists
ls -la .git-hooks/commit-msg  # Unix
dir .git-hooks\commit-msg     # Windows
```

### Commit Rejected

If your commit is rejected:

```bash
# See the error message for guidance
git commit -m "added new stuff"

# Output:
# ❌ Commit message does not follow conventional commits format
# Expected: type(scope): description
# Valid types: feat, fix, docs, ...
# Example: feat(classes): add Recipe class
```

Fix the message and try again:

```bash
git commit -m "feat(classes): add new Recipe class"
```

### Bypass Validation (Emergency Only)

```bash
# Skip hook validation (not recommended)
git commit --no-verify -m "quick emergency fix"

# Or amend the last commit to fix the message
git commit --amend
```

### Wrong Type Used

If you used the wrong type:

```bash
# Before pushing, amend the commit
git commit --amend -m "fix(classes): correct Recipe inheritance"

# If already pushed, revert and recommit
git revert HEAD
git commit -m "fix(classes): correct Recipe inheritance"
```

### Changelog Not Generating

If `npm run changelog` fails:

```bash
# Ensure you have valid commits since last release
git log v0.2.0..HEAD --oneline

# Check configuration
cat git-conventional-commits.yaml

# Manually test pattern
echo "feat(classes): test" | grep -E '^(feat|fix|docs).*: '
```

### Windows PowerShell Issues

If hooks don't work on Windows:

```bash
# Use PowerShell setup script
powershell -ExecutionPolicy Bypass -File .\scripts\setup-hooks.ps1

# Or manually configure
git config core.hooksPath .git-hooks
```

---

## Best Practices

### 1. Write Descriptive Scopes

```bash
# ✅ Good - clear scope
git commit -m "feat(properties): add birthDate to Person"

# ❌ Vague - unclear scope
git commit -m "feat: update stuff"
```

### 2. Keep Descriptions Clear

```bash
# ✅ Good - explains what
git commit -m "fix(validation): prevent crash on empty property list"

# ❌ Vague - doesn't explain what
git commit -m "fix: bug in validation"
```

### 3. Use Body for Complex Changes

```bash
git commit -m "refactor(modular): split CreativeWork into submodules

Moved the following classes to separate modules:
- Book → creative-work/book.edn
- Article → creative-work/article.edn
- Recipe → creative-work/recipe.edn

This reduces the size of the main module from 5000 to 2000 lines
and makes it easier to maintain individual content types."
```

### 4. Reference Issues

```bash
git commit -m "feat(classes): add Event management classes

Closes #42, #43, #44"
```

### 5. Indicate Breaking Changes Clearly

```bash
git commit -m "feat(classes)!: restructure inheritance hierarchy

BREAKING CHANGE: All CreativeWork subclasses now inherit from
new MediaObject base class. Existing graphs must be migrated.

See MIGRATION.md for upgrade instructions."
```

---

## Release Workflow

Complete release process using conventional commits:

```bash
# 1. Check what changes have been made
git log v0.2.0..HEAD --oneline

# 2. Determine next version
npm run version
# Output: 0.3.0

# 3. Generate and review changelog
npm run changelog

# 4. Write changelog to file
npm run changelog:write

# 5. Review and edit if needed
cat CHANGELOG.md

# 6. Commit changelog
git commit -am "docs(release): update changelog for v0.3.0"

# 7. Tag release
git tag v0.3.0

# 8. Push
git push --tags

# 9. GitHub Actions creates release automatically
```

---

## Additional Resources

- [Conventional Commits Official Site](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Project CONTRIBUTING.md](../../CONTRIBUTING.md)

---

**Questions or issues?** Open an issue on [GitHub](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues).
