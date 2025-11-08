# Contributing to Logseq Template Graph

Thank you for your interest in contributing! This document provides guidelines for contributing to the Logseq Template Graph project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Adding Classes and Properties](#adding-classes-and-properties)
- [Documentation Guidelines](#documentation-guidelines)

---

## Code of Conduct

This project is committed to providing a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

---

## Getting Started

### Prerequisites

- **Logseq** (desktop app with database format support)
- **Node.js** (v16+)
- **Git**
- **Babashka** (for modular development) - [Install guide](https://github.com/babashka/babashka#installation)

### Setup Development Environment

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/logseq-template-graph.git
cd logseq-template-graph

# 2. Install dependencies
npm install

# 3. Setup git hooks for commit validation
npm run setup

# 4. (Optional) Install Babashka for modular workflow
# See: https://babashka.org/
```

---

## Development Workflow

### Branch Strategy

This project uses a **dev/main branching model** with automated releases:

- **`dev`** - Development branch (default, most work happens here)
- **`main`** - Production/release branch (protected)

**Automated Release Logic:**
- **Merge `dev` → `main`** = Minor/Major release (v1.1.0 → v1.2.0)
- **Direct commit to `main`** = Patch release (v1.1.0 → v1.1.1, hotfixes only)
- **Version determined automatically** from conventional commits
- **Changelog and tags created automatically** by GitHub Actions

### Regular Development (95% of work)

Work on the `dev` branch for all normal development:

```bash
# 1. Switch to dev branch
git checkout dev
git pull origin dev

# 2. Make changes in Logseq desktop app
# ... edit classes, properties ...

# 3. Export and build (modular workflow)
npm run export                # Export + auto-split into source/ modules
npm run build:full            # Build template variant

# 4. Review changes
git diff source/              # Check modular source changes

# 5. Commit with conventional commit message
git commit -m "feat(classes): add Recipe class with ingredients property"

# 6. Push to dev
git push origin dev

# GitHub Actions will run tests and validate builds
```

### Creating a Release

When you're ready to release the features from `dev`:

```bash
# 1. Ensure dev is up to date and all tests pass
git checkout dev
git pull origin dev

# 2. Create PR from dev → main
gh pr create --base main --head dev --title "Release v1.2.0" --body "Release new features"

# Or via GitHub UI:
# - Go to Pull Requests
# - Click "New pull request"
# - Base: main, Compare: dev
# - Create pull request

# 3. Review the PR
# - Check all commits included
# - Verify CI passes
# - Preview changelog in PR

# 4. Merge PR → main
# GitHub Actions will automatically:
# - Determine version from commits (v1.2.0)
# - Generate CHANGELOG.md
# - Create git tag (v1.2.0)
# - Build all template variants
# - Create GitHub release

# 5. Sync is automatic
# main → dev sync happens automatically after hotfixes
```

### Hotfix Workflow (Emergency Patch)

For urgent production fixes only:

```bash
# 1. Work directly on main branch
git checkout main
git pull origin main

# 2. Fix the critical issue
# ... make minimal fix ...

# 3. Commit with conventional commit
git commit -m "fix(security): patch XSS vulnerability"

# 4. Push to main
git push origin main

# GitHub Actions will automatically:
# - Detect hotfix (direct commit)
# - Create PATCH version (v1.1.0 → v1.1.1)
# - Generate changelog
# - Create git tag
# - Create release
# - Sync main → dev

# ⚠️ Use hotfixes sparingly - prefer dev → main workflow
```

### Standard Workflow (Monolithic, Legacy)

If not using modular architecture:

```bash
# 1. Create a feature branch from dev
git checkout dev
git checkout -b feat/add-recipe-class

# 2. Make changes in Logseq desktop app

# 3. Export templates using scripts
./scripts/export.sh           # Mac/Linux
.\scripts\export.ps1           # Windows

# 4. Review changes
git diff

# 5. Commit with conventional commit message
git commit -m "feat(classes): add Recipe class with ingredients property"

# 6. Push and create pull request to dev
git push origin feat/add-recipe-class
gh pr create --base dev --head feat/add-recipe-class
```

---

## Commit Message Guidelines

**This project uses [Conventional Commits](https://www.conventionalcommits.org/) specification.**

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: New features or feature enhancements
- **fix**: Bug fixes
- **docs**: Documentation changes
- **style**: Code style/formatting (no logic changes)
- **refactor**: Code restructuring without behavior changes
- **perf**: Performance improvements
- **test**: Test additions or corrections
- **build**: Build system, dependencies, CI/CD changes
- **ops**: Infrastructure and deployment
- **chore**: Miscellaneous (e.g., .gitignore updates)

### Scopes

- **templates** - Changes to .edn template files
- **classes** - Schema.org class additions/modifications
- **properties** - Schema.org property additions/modifications
- **ci** - CI/CD pipeline changes
- **scripts** - Build, export, validation scripts
- **docs** - Documentation files
- **release** - Release-related changes
- **modular** - Modular architecture changes
- **workflow** - Development workflow improvements

### Examples

#### Good Commit Messages

```bash
feat(classes): add Recipe class with cookTime and ingredients
fix(properties): correct cardinality for spouse property from :many to :one
docs(contributing): add conventional commits guidelines
refactor(modular): split CreativeWork into separate modules
perf(scripts): optimize EDN parsing in validation script
build(ci): add automated changelog generation to release workflow
```

#### Breaking Changes

```bash
feat(classes)!: remove deprecated Customer class

BREAKING CHANGE: Customer class has been removed. Use Person class with
customerRole property instead. Migration guide available in docs/migration.md
```

#### Multi-line Commit

```bash
feat(classes): add comprehensive Event management classes

Added the following Schema.org Event classes:
- Event (base class)
- BusinessEvent
- EducationEvent
- SocialEvent
- MusicEvent

Each class includes standard properties: eventStatus, startDate,
endDate, location, organizer, attendee.

Closes #42
```

### Validation

Commits are automatically validated using git hooks:

```bash
# Hook will reject invalid commits
git commit -m "added new stuff"  # ❌ Invalid

# Correct format
git commit -m "feat(classes): add new Event classes"  # ✅ Valid

# Bypass validation (not recommended)
git commit --no-verify -m "quick fix"
```

---

## Pull Request Process

### Before Submitting

1. **Ensure commits follow conventional commits** - Use `npm run validate:commits`
2. **Update documentation** if adding features
3. **Test template import** in a fresh Logseq graph
4. **Run validation** - `bash scripts/validate.sh`
5. **Update CHANGELOG.md** if necessary (or use `npm run changelog:write`)

### PR Title Format

Use conventional commit format for PR titles:

```
feat(classes): add Recipe and nutrition properties
fix(templates): correct Event class inheritance
docs: update installation guide for Windows
```

### PR Description Template

```markdown
## Summary
Brief description of changes

## Type of Change
- [ ] feat - New feature
- [ ] fix - Bug fix
- [ ] docs - Documentation update
- [ ] refactor - Code restructuring
- [ ] perf - Performance improvement
- [ ] build - Build/CI changes
- [ ] chore - Miscellaneous

## Changes Made
- Added Recipe class with 12 properties
- Updated CreativeWork parent class
- Added validation for cookTime format

## Testing
- [ ] Imported templates into fresh Logseq graph
- [ ] Verified properties appear correctly
- [ ] Tested class inheritance
- [ ] Ran validation scripts

## Related Issues
Closes #123
Relates to #456

## Breaking Changes
None / Description of breaking changes

## Checklist
- [ ] Commits follow conventional commits format
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if applicable)
- [ ] Templates validated successfully
- [ ] Tested in Logseq
```

---

## Adding Classes and Properties

### Research First

1. Check [Schema.org](https://schema.org) for standard naming
2. Review existing similar classes in the template
3. Check [Tana supertags](https://tana.inc/docs/supertags) for inspiration

### Adding a New Class

```bash
# 1. Add class in Logseq UI:
#    - Create page with class name (e.g., "Recipe")
#    - Add properties in class configuration panel
#    - Set parent class (e.g., CreativeWork)
#    - Add icon and description

# 2. Export
./scripts/export.sh

# 3. Validate
bash scripts/validate.sh

# 4. Commit
git commit -m "feat(classes): add Recipe class with cookTime and ingredients properties

Added Recipe class inheriting from CreativeWork:
- Properties: cookTime, ingredients, recipeYield, nutrition
- Icon: 🍳
- Description: A recipe for cooking or baking

Follows Schema.org Recipe specification."
```

### Adding a New Property

```bash
# 1. Add property in Logseq:
#    - Define cardinality (:one or :many)
#    - Set type (:default, :node, :date, :url, :number)
#    - Assign to relevant classes
#    - Add icon and description

# 2. Export and validate
./scripts/export.sh
bash scripts/validate.sh

# 3. Commit
git commit -m "feat(properties): add allergens property to Recipe class"
```

---

## Documentation Guidelines

### When to Document

- Adding new features or classes
- Making breaking changes
- Changing development workflow
- Adding new scripts or tools

### Where to Document

```
docs/
├── user-guide/          # For template users
├── developer-guide/     # For contributors
├── modular/             # Modular development docs
├── architecture/        # Technical deep-dives
└── research/            # Analysis and research

Root level:
- README.md              # Project overview
- QUICK_START.md         # 5-minute setup
- CONTRIBUTING.md        # This file
- CHANGELOG.md           # Release history
```

### Documentation Checklist

- [ ] Place in appropriate `docs/` subfolder
- [ ] Update [docs/README.md](docs/README.md) with new entry
- [ ] Cross-link from related docs
- [ ] Test all markdown links
- [ ] Use clear examples
- [ ] Keep formatting consistent

### Commit Documentation

```bash
git commit -m "docs(developer-guide): add conventional commits best practices"
git commit -m "docs(user-guide): update import instructions for Windows"
git commit -m "docs: fix broken links in technical reference"
```

---

## Questions or Issues?

- **Bug reports**: [GitHub Issues](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
- **Feature requests**: [GitHub Discussions](https://github.com/C0ntr0lledCha0s/logseq-template-graph/discussions)
- **Documentation questions**: Check [docs/README.md](docs/README.md)

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

**Thank you for contributing to Logseq Template Graph!** 🎉
