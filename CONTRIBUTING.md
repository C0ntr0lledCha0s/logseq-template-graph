# Contributing to the Logseq Schema Library

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

- **Logseq** DB version (optional, only to try the library in a graph)
- **Node.js** (v16+)
- **Git**
- **Babashka** (runs tests, build and validation) - [Install guide](https://github.com/babashka/babashka#installation)

### Setup Development Environment

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/logseq-template-graph.git
cd logseq-template-graph

# 2. Install dependencies
npm install

# 3. Setup git hooks for commit validation
npm run setup

# 4. Install Babashka (bb) - https://babashka.org/
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

### Regular Development

You curate the library by editing the EDN under `source/`; there is no export from a Logseq graph.

```bash
# 1. Switch to dev branch
git checkout dev
git pull origin dev

# 2. Edit source/<module>/classes.edn, properties.edn or source/presets/<id>.edn

# 3. Test, build and validate
bb test && bb build && bb validate

# 4. Review changes (small, per-module diffs)
git diff source/

# 5. Commit with conventional commit message
git add source/
git commit -m "feat(classes): add Recipe class"

# 6. Push to dev
git push origin dev
# GitHub Actions will run tests, build and validate
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
# - Build schema-library.edn and schema-presets.edn
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
- **scripts** - Build and validation scripts
- **docs** - Documentation files
- **release** - Release-related changes
- **source** - Changes to the source/ module layout
- **workflow** - Development workflow improvements

### Examples

#### Good Commit Messages

```bash
feat(classes): add Recipe class with cookTime and ingredients
fix(properties): correct cardinality for spouse property from :many to :one
docs(contributing): add conventional commits guidelines
refactor(source): split CreativeWork into separate modules
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
3. **Run** `bb test && bb build && bb validate`
4. **Check the import** in a fresh Logseq graph when you can: `LOGSEQ_DIR=/path/to/logseq bb check-import`
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
- [ ] Imported the library into a fresh Logseq graph (or ran `bb check-import`)
- [ ] Verified properties appear correctly
- [ ] Tested class inheritance
- [ ] Ran `bb test && bb build && bb validate`

## Related Issues
Closes #123
Relates to #456

## Breaking Changes
None / Description of breaking changes

## Checklist
- [ ] Commits follow conventional commits format
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if applicable)
- [ ] `bb validate` passes
- [ ] Tested in Logseq
```

---

## Adding Classes and Properties

### Research First

1. Check [Schema.org](https://schema.org) for the standard name. A name that exists in Schema.org must use the `schema.*` namespace; a name that does not must use `custom.*`.
2. Review existing similar classes in `source/`.
3. Check [Tana supertags](https://tana.inc/docs/supertags) for inspiration.

### Adding a New Class

1. Pick the module under `source/` whose theme fits (for example `source/creative-work/classes.edn`).
2. Add the class under `:classes` with a fixed ident:

```clojure
:schema.class/Recipe
{:block/title "Recipe",
 :build/class-properties [:schema.property/cookTime :schema.property/recipeYield],
 :build/class-extends [:schema.class/HowTo],
 :build/properties
 {:logseq.property/icon {:id "cooking", :type :emoji},
  :logseq.property/description "A recipe.",
  :schema.property/url "https://schema.org/Recipe"}}
```

3. Make sure every property it lists exists (in some `properties.edn`) and that its parent is a known class.
4. Run `bb test && bb build && bb validate`.
5. Commit:

```bash
git commit -m "feat(classes): add Recipe class"
```

### Adding a New Property

1. Add the property to the module's `properties.edn` under `:properties`:

```clojure
:schema.property/cookTime
{:db/cardinality :db.cardinality/one,
 :logseq.property/type :default,
 :block/title "cookTime",
 :build/properties
 {:logseq.property/description "The time it takes to actually cook the dish.",
  :schema.property/url "https://schema.org/cookTime"}}
```

2. Add its ident to `:build/class-properties` of each class that should carry it.
3. Run `bb test && bb build && bb validate`.
4. Commit: `git commit -m "feat(properties): add cookTime property"`

Terms that are not in Schema.org use `:custom.class/...` or `:custom.property/...` and omit `:schema.property/url`. Do not use `:user.*` idents. The build normalises each class's property order to one global order, so you do not need to keep orders consistent by hand.

### Changing a Preset

Edit `source/presets/<id>.edn`: `{:id :name :description :classes {class [props]}}`. A preset may list only properties attached directly to that class. See [source/presets/README.md](source/presets/README.md).

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
├── developer-guide/     # For contributors
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
git commit -m "docs: update import instructions"
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

**Thank you for contributing!**
