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

**Releases are manual.** A maintainer bumps the version and writes the changelog on `dev`, merges `dev` → `main`, and pushes a `vX.Y.Z` tag; the tag builds and publishes the release. `auto-release.yml` only previews the next version. The full steps are in the [CI/CD Pipeline guide](docs/developer-guide/ci-cd-pipeline.md#release-flow).

### Regular Development

You curate the library by editing the EDN under `source/`; there is no export from a Logseq graph.

```bash
# 1. Switch to dev branch
git checkout dev
git pull origin dev

# 2. Edit source/<module>/classes.edn, properties.edn or source/presets/<id>.edn

# 3. Test, build and validate
bb test && bb build && bb validate

# 3b. Publish the generated library (do not hand-edit library/; the Ontology Schema Builder plugin downloads it)
bb publish-library

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

Maintainers only. Follow [Release flow](docs/developer-guide/ci-cd-pipeline.md#release-flow):

1. PR `chore(release): prepare version X.Y.Z` into `dev`: bump `package.json`, add the `CHANGELOG.md` entry, run `bb publish-library`. Squash-merge.
2. PR `release: merge dev into main for vX.Y.Z` into `main`. Merge with a merge commit, keeping that title as the commit subject (the default `Merge pull request ...` subject skips the sync back to `dev`).
3. `git tag -a vX.Y.Z origin/main -m "Release vX.Y.Z"` and `git push origin vX.Y.Z`. The tag runs `release.yml`, which publishes `schema-library.edn` and `schema-presets.edn`.
4. `main` syncs back into `dev` automatically.

### Hotfix Workflow (Emergency Patch)

For urgent fixes only. The same manual steps apply, with a patch version:

```bash
# 1. Branch from main, fix, open a PR into main
git checkout main && git pull origin main
git checkout -b fix/critical-issue
# ... minimal fix, bb test && bb build && bb validate && bb publish-library ...
# bump package.json to the next patch version and add the CHANGELOG entry in the same PR

# Squash-merge it with a fix: title (a subject containing "Merge pull request" or "chore(release):" skips the sync to dev)

# 2. After merging, tag main as in the release flow
git fetch origin
git tag -a vX.Y.Z origin/main -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

`sync-branches.yml` then merges `main` back into `dev`.

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
3. **Run** `bb test && bb build && bb validate && bb publish-library`, and commit `library/` (generated; do not hand-edit)
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
