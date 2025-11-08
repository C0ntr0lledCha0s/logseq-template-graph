# Conventional Commits Integration Summary

**Date:** November 2025
**Project:** Logseq Template Graph
**Integration:** git-conventional-commits by qoomon

---

## Overview

This document summarizes the integration of [Conventional Commits](https://www.conventionalcommits.org/) into the Logseq Template Graph project, enabling automated changelog generation, semantic versioning, and standardized commit messages.

---

## What Was Integrated

### 1. Core Tool: git-conventional-commits

**Source:**
- [GitHub Repository](https://github.com/qoomon/git-conventional-commits)
- [Configuration Gist](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)

**Capabilities:**
- ✅ Validate commit messages against conventional commits format
- ✅ Generate changelogs automatically from commit history
- ✅ Determine semantic version bumps (major.minor.patch)
- ✅ Support customizable commit types and scopes
- ✅ Integrate with CI/CD workflows

---

## Files Created/Modified

### New Files

| File | Purpose |
|------|---------|
| [`git-conventional-commits.yaml`](git-conventional-commits.yaml) | Configuration for commit types, scopes, and changelog generation |
| [`package.json`](package.json) | NPM dependencies and scripts for conventional commits tooling |
| [`.git-hooks/commit-msg`](.git-hooks/commit-msg) | Git hook for Unix/Linux commit message validation |
| [`.git-hooks/commit-msg.ps1`](.git-hooks/commit-msg.ps1) | Git hook for Windows PowerShell validation |
| [`scripts/setup-hooks.sh`](scripts/setup-hooks.sh) | Unix/Linux setup script for git hooks |
| [`scripts/setup-hooks.ps1`](scripts/setup-hooks.ps1) | Windows PowerShell setup script for git hooks |
| [`.github/workflows/validate-commits.yml`](.github/workflows/validate-commits.yml) | GitHub Actions workflow to validate PR commits |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Complete contributing guide with commit standards |
| [`docs/developer-guide/conventional-commits-guide.md`](docs/developer-guide/conventional-commits-guide.md) | Comprehensive guide for conventional commits |
| `CONVENTIONAL_COMMITS_INTEGRATION.md` | This file - integration summary |

### Modified Files

| File | Changes |
|------|---------|
| [`CLAUDE.md`](CLAUDE.md) | Updated Git Workflow section with conventional commits guidelines |
| [`.github/workflows/release.yml`](.github/workflows/release.yml) | Enhanced to generate changelogs from commits automatically |
| [`.gitignore`](.gitignore) | Added node_modules and conventional commits temp files |
| [`docs/README.md`](docs/README.md) | Added links to Contributing and Conventional Commits guides |

---

## Configuration Details

### Commit Types

| Type | Description | Changelog | Version Bump |
|------|-------------|-----------|--------------|
| `feat` | New features or enhancements | ✅ Yes | Minor (0.x.0) |
| `fix` | Bug fixes | ✅ Yes | Patch (0.0.x) |
| `docs` | Documentation changes | ✅ Yes | - |
| `style` | Code formatting (no logic) | ❌ No | - |
| `refactor` | Code restructuring | ✅ Yes | - |
| `perf` | Performance improvements | ✅ Yes | - |
| `test` | Test additions/corrections | ❌ No | - |
| `build` | Build system, dependencies | ✅ Yes | - |
| `ops` | Infrastructure, deployment | ❌ No | - |
| `chore` | Miscellaneous | ❌ No | - |

### Commit Scopes

Project-specific scopes defined for clarity:

- `templates` - .edn template files
- `classes` - Schema.org class definitions
- `properties` - Schema.org property definitions
- `ci` - CI/CD pipeline changes
- `scripts` - Build/export/validation scripts
- `docs` - Documentation
- `release` - Release process
- `modular` - Modular architecture
- `workflow` - Development workflow

---

## Usage

### Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Setup git hooks (automatic validation)
npm run setup

# 3. Make a commit
git commit -m "feat(classes): add Recipe class with cookTime property"
```

### Available NPM Scripts

```bash
npm run setup              # Setup git hooks for validation
npm run version            # Determine next version from commits
npm run changelog          # Generate changelog preview
npm run changelog:write    # Write changelog to CHANGELOG.md
npm run validate:commits   # Manually validate commit message
```

### Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Examples:**

```bash
# Simple feature
git commit -m "feat(classes): add Recipe class"

# Bug fix with scope
git commit -m "fix(templates): correct spouse cardinality"

# Documentation
git commit -m "docs: update installation guide"

# Breaking change
git commit -m "feat(classes)!: remove deprecated Customer class

BREAKING CHANGE: Use Person class with customerRole property instead"
```

---

## Automation

### Git Hooks

**Pre-commit validation** ensures all commits follow the format:

- **Unix/Linux**: `.git-hooks/commit-msg` (Bash script)
- **Windows**: `.git-hooks/commit-msg.ps1` (PowerShell script)

Invalid commits are **rejected** with helpful error messages.

### GitHub Actions

#### 1. Validate Commits Workflow

**File:** [`.github/workflows/validate-commits.yml`](.github/workflows/validate-commits.yml)

**Triggers:** Pull requests (opened, synchronized, reopened)

**Action:** Validates all commits in the PR against conventional commits format

**Output:** Comments on PR if commits don't follow the standard

#### 2. Enhanced Release Workflow

**File:** [`.github/workflows/release.yml`](.github/workflows/release.yml)

**Enhancements:**
- Automatically generates changelog from conventional commits
- Falls back to existing CHANGELOG.md if generation fails
- Includes download instructions and template statistics

**Workflow:**
1. Checkout with full history (`fetch-depth: 0`)
2. Install Node.js and dependencies
3. Generate changelog using `npx git-conventional-commits`
4. Create GitHub release with generated notes

---

## Benefits

### 1. Automated Changelog Generation

**Before:**
```bash
# Manually write CHANGELOG.md entries
vim CHANGELOG.md
# Add entries manually...
git commit -m "update changelog"
```

**After:**
```bash
# Automatic generation from commits
npm run changelog:write
git commit -am "docs(release): update changelog for v0.3.0"
```

### 2. Semantic Versioning

**Before:**
```bash
# Manually determine version
# Is it 0.3.0 or 0.2.1?
git tag v0.3.0
```

**After:**
```bash
# Automatic version based on commits
npm run version
# Output: 0.3.0 (feat commits = minor bump)
```

### 3. Consistent Commit History

**Before:**
```
added new stuff
fix bug
update templates
WIP
```

**After:**
```
feat(classes): add Recipe class with cookTime property
fix(templates): correct spouse cardinality from :many to :one
docs: update installation instructions
chore(templates): auto-export templates
```

### 4. Better Collaboration

- **Developers** know exactly what format to use
- **Reviewers** can quickly understand changes
- **Users** get clear, organized changelogs
- **Automation** works reliably

---

## Migration Guide

### For Existing Contributors

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Setup git hooks:**
   ```bash
   npm run setup
   ```

3. **Update commit habits:**
   ```bash
   # Old way
   git commit -m "added Recipe class"

   # New way
   git commit -m "feat(classes): add Recipe class"
   ```

4. **If commit is rejected:**
   ```bash
   # Fix the message format
   git commit --amend -m "feat(classes): add Recipe class"
   ```

### For New Contributors

Follow the [CONTRIBUTING.md](CONTRIBUTING.md) guide which includes conventional commits from the start.

---

## Troubleshooting

### Hook Not Running

```bash
# Re-run setup
npm run setup

# Verify git config
git config core.hooksPath
# Should output: .git-hooks
```

### Commit Rejected

```bash
# Error shows expected format
git commit -m "added stuff"
# ❌ Rejected with helpful message

# Fix and retry
git commit -m "feat(classes): add Recipe class"
# ✅ Accepted
```

### Bypass Validation (Emergency)

```bash
# Not recommended, but available
git commit --no-verify -m "emergency fix"
```

### Changelog Not Generating

```bash
# Check configuration
cat git-conventional-commits.yaml

# Verify commits exist
git log --oneline

# Test manually
npm run changelog
```

---

## Next Steps

### Recommended Actions

1. **Update existing commits** (optional):
   - Review recent commit history
   - Use interactive rebase to rewrite messages (if not pushed)
   - Document any non-standard commits

2. **Update documentation links:**
   - Ensure all docs reference CONTRIBUTING.md
   - Add conventional commits badge to README
   - Update quick start guides

3. **Team communication:**
   - Notify all contributors of new requirements
   - Share CONTRIBUTING.md and conventional commits guide
   - Provide examples and answer questions

4. **Monitor adoption:**
   - Review PRs for proper commit format
   - Provide gentle feedback and guidance
   - Update docs based on common questions

### Future Enhancements

- [ ] Add commit message template (`.gitmessage`)
- [ ] Create VS Code snippets for common commits
- [ ] Add commit-lint for more advanced validation
- [ ] Integrate with semantic-release for full automation
- [ ] Add conventional commits badge to README
- [ ] Create video tutorial on conventional commits workflow

---

## Resources

### Official Documentation

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [git-conventional-commits GitHub](https://github.com/qoomon/git-conventional-commits)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

### Project Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute with conventional commits
- [docs/developer-guide/conventional-commits-guide.md](docs/developer-guide/conventional-commits-guide.md) - Comprehensive guide
- [CLAUDE.md](CLAUDE.md) - AI assistant guidelines including commit standards

### Examples

- [Configuration Gist](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13) - Example configuration
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit) - Industry standard example

---

## Questions or Issues?

- **Technical Issues:** [GitHub Issues](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
- **Questions:** [GitHub Discussions](https://github.com/C0ntr0lledCha0s/logseq-template-graph/discussions)
- **Documentation:** See [docs/README.md](docs/README.md)

---

**Integration Completed:** November 2025
**Maintained By:** Logseq Template Graph Contributors
**License:** MIT
