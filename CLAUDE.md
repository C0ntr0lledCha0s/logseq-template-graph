# Logseq Schema Library - Claude Code Configuration

This file provides guidance to Claude Code (AI assistant) when working with code in this repository.

**For detailed technical documentation, see:** [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md)

---

## Project Overview

A **schema library** for Logseq DB graphs: Schema.org classes and properties as hand-edited EDN under `source/`, built into two release files.

- `build/schema-library.edn` (released as `schema-library.edn`) - all classes and properties, importable via Logseq **Import -> EDN to DB Graph**
- `build/schema-presets.edn` (released as `schema-presets.edn`) - role presets, read by the Ontology Sync plugin

Counts come from `bb build` output (do not hard-code them in docs). Every `schema.*` entry carries `:schema.property/url`; non-Schema.org terms live under `custom.class/*` and `custom.property/*`.

**Purpose:** Bring Tana-style supertag functionality to open-source Logseq using Schema.org vocabulary.

---

## Workflow

Curate by editing `source/` directly. There is no export from a Logseq graph and no split step.

```bash
# edit source/<module>/classes.edn, properties.edn, source/presets/<id>.edn
bb test && bb build && bb validate
LOGSEQ_DIR=/path/to/logseq bb check-import   # optional: import into a fresh Logseq graph
```

- `bb test` - unit tests in `test/template_graph/`
- `bb build` - `scripts/build.clj`: merges modules, normalises each class's property order to one global order, writes `build/`
- `bb validate` - `scripts/validate.clj`: checks `build/` against `vendor/schemaorg-current-https.json`
- `bb check-import` - `scripts/ci/check-import.cljs` via nbb-logseq (needs `LOGSEQ_DIR`)

`build/` is git-ignored. Releases publish exactly `schema-library.edn` and `schema-presets.edn`.

---

## Repository Layout

```
source/<module>/classes.edn      class definitions
source/<module>/properties.edn   property definitions
source/presets/<id>.edn          {:id :name :description :classes {class [props]}}
src/template_graph/              edn_io, library (merge, order), presets, validate, vocab
scripts/build.clj, validate.clj  bb entry points
scripts/ci/                      check-import (nbb) support files
vendor/                          Schema.org vocabulary for validation
docs/                            documentation (see docs/README.md)
```

Documentation: [README.md](README.md), [QUICK_START.md](QUICK_START.md), [DOCS_INDEX.md](DOCS_INDEX.md), [docs/README.md](docs/README.md).

---

## EDN Format

```clojure
{:properties
 {:schema.property/email
  {:db/cardinality :db.cardinality/one      ; or :many
   :logseq.property/type :default           ; :node, :date, :url, :number
   :block/title "email"
   :build/property-classes [:schema.class/Person]
   :build/properties
   {:logseq.property/icon {:id "email", :type :emoji}
    :logseq.property/description "Email address."
    :schema.property/url "https://schema.org/email"}}}

 :classes
 {:schema.class/Person
  {:block/title "Person"
   :build/class-properties [:schema.property/email]
   :build/class-extends [:schema.class/Thing]
   :build/properties {:schema.property/url "https://schema.org/Person"}}}}
```

Module files hold the `:classes` or `:properties` section; `bb build` merges them and adds the export marker and version.

### Idents

- `:schema.class/<Name>` / `:schema.property/<name>` - the name must exist in Schema.org (exact case)
- `:custom.class/<Name>` / `:custom.property/<name>` - the name must NOT exist in Schema.org
- `:user.*` idents are rejected by validation
- Idents are fixed; never rename them once released

### Presets

`{:id "crm" :name "CRM" :description "..." :classes {:schema.class/Person [:schema.property/email]}}`. A preset may list only properties attached directly to that class (`:build/class-properties`).

---

## Important Constraints

1. **Fail fast**: `bb build` throws on conflicting definitions; `bb validate` must report `Valid`
2. **Fixed idents**: no random suffixes, no `:user.*`
3. **Every `schema.*` entry has `:schema.property/url`**
4. **Cardinality and type matter**: changing `:one` <-> `:many` or the type affects storage and UI
5. **Do not edit `build/`**: it is generated

---

## Common Development Tasks

### Adding New Classes
1. Check Schema.org for the standard name (`schema.*` if it exists, `custom.*` if not)
2. Add the class to the fitting `source/<module>/classes.edn` with icon, description, `:schema.property/url`
3. Define `:build/class-properties` and `:build/class-extends`
4. Run `bb test && bb build && bb validate`
5. Commit: `git commit -m "feat(classes): add Recipe class"`

### Adding New Properties
1. Check Schema.org for the standard name
2. Choose cardinality (`:one` or `:many`) and type (`:default`, `:node`, `:date`, `:url`, `:number`)
3. Add it to the module's `properties.edn` and to `:build/class-properties` of the classes that use it
4. Run `bb test && bb build && bb validate`
5. Commit

### Documentation
1. Determine audience (user, developer, researcher)
2. Place in the right `docs/` subfolder (`developer-guide/`, `architecture/`, `research/`)
3. Update [docs/README.md](docs/README.md) and [DOCS_INDEX.md](DOCS_INDEX.md)
4. Cross-link from related docs and test links

---

## PowerShell Script Guidelines

When working with PowerShell scripts (`.ps1` files), especially git hooks:

### Avoid Emojis in PowerShell Scripts

Emojis can become corrupted due to encoding issues, causing syntax errors.

**❌ Bad (causes errors):**
```powershell
Write-Host "❌ Error message" -ForegroundColor Red
Write-Host "✅ Success message" -ForegroundColor Green
```

**✅ Good (ASCII-safe):**
```powershell
Write-Host "[ERROR] Error message" -ForegroundColor Red
Write-Host "[SUCCESS] Success message" -ForegroundColor Green
```

### ASCII-Safe Alternatives

Use these instead of emojis:

| Emoji | ASCII Alternative | Use Case |
|-------|-------------------|----------|
| ❌ | `[ERROR]` or `[X]` | Errors, failures |
| ✅ | `[SUCCESS]` or `[OK]` | Success, passed checks |
| ⚠️ | `[WARNING]` or `[!]` | Warnings, attention needed |
| 📝 | `[CHECK]` or `[i]` | Info, checking |
| 🔍 | `[SCAN]` or `[?]` | Searching, analyzing |
| 📦 | `[BUILD]` or `[*]` | Building, packaging |
| 🚀 | `[PUSH]` or `[>>]` | Pushing, deploying |

### String Quoting Rules

PowerShell interprets characters differently in single vs. double quotes:

**Use single quotes for literal strings:**
```powershell
# Good - prevents PowerShell from interpreting special chars
$pattern = '^(feat|fix|docs)(\(.+\))?: .+'
Write-Host 'Expected format: type(scope): description'
```

**Use double quotes only when you need variable expansion:**
```powershell
# Good - expands $commitMsg variable
Write-Host "   $commitMsg" -ForegroundColor Yellow
```

### Testing PowerShell Scripts

Always test on both PowerShell versions:
```powershell
# Test on PowerShell 5.1 (Windows default)
powershell.exe -NoProfile -File script.ps1

# Test on PowerShell 7+ (if installed)
pwsh -NoProfile -File script.ps1
```

### Common Issues

1. **Pipe `|` interpreted as command separator** - Use single quotes
2. **Parentheses `()` cause parsing errors** - Use single quotes
3. **Emoji corruption** - Use ASCII alternatives
4. **Line endings** - Git may show CRLF warnings (normal on Windows)

---

## Git Workflow

### Conventional Commits

**This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automated changelog generation and semantic versioning.**

#### Commit Message Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

#### Commit Types
- `feat` - New features or feature enhancements
- `fix` - Bug fixes
- `docs` - Documentation changes
- `style` - Code style/formatting (no logic changes)
- `refactor` - Code restructuring without behavior changes
- `perf` - Performance improvements
- `test` - Test additions or corrections
- `build` - Build system, dependencies, CI/CD changes
- `ops` - Infrastructure and deployment
- `chore` - Miscellaneous (e.g., .gitignore updates)

#### Scopes (optional but recommended)
- `templates` - Changes to .edn template files
- `classes` - Schema.org class additions/modifications
- `properties` - Schema.org property additions/modifications
- `ci` - CI/CD pipeline changes
- `scripts` - Build and validation scripts
- `docs` - Documentation files
- `release` - Release-related changes
- `source` - Changes to the source/ module layout
- `workflow` - Development workflow improvements

#### Examples
```bash
# Feature commits
git commit -m "feat(classes): add Recipe class with ingredients property"
git commit -m "feat(properties): add cookTime property to Recipe class"

# Bug fixes
git commit -m "fix(templates): correct cardinality for spouse property"
git commit -m "fix(scripts): handle empty property lists in validation"

# Documentation
git commit -m "docs: update installation instructions"
git commit -m "docs(contributing): add commit message guidelines"

# Chores
git commit -m "chore: update dependencies"

# Breaking changes
git commit -m "feat(classes)!: remove deprecated Customer class

BREAKING CHANGE: Customer class removed, use Person with customerRole property instead"
```

#### Handling Merge Commits

**Merge commits are automatically skipped during validation** since they're auto-generated by Git/GitHub.

**Best Practices:**
- **Prefer rebase over merge** for feature branches to maintain linear history
- **Squash commits** before merging to keep history clean
- **Merge commits are allowed** for:
  - Pull request merges from GitHub
  - Emergency hotfix merges
  - Branch synchronization with main

**When merge commits occur**, they're recognized by these patterns:
- `Merge branch 'branch-name'`
- `Merge pull request #123 from user/branch`
- `Merge <commit-hash> into <commit-hash>` (auto-generated)

The CI/CD validation automatically skips these without requiring fixes.

#### Setup Commit Validation
```bash
# Install dependencies
npm install

# Setup git hooks (automatic validation)
npm run setup

# Validate commits manually
npm run validate:commits
```

### Git Hooks

**This project uses git hooks for automated validation and build safety.**

The following hooks are automatically installed via `npm run setup`:

#### Active Hooks

1. **`commit-msg`** - Validates conventional commits format
   - Checks commit message follows conventional commits standard
   - Validates commit types and scopes
   - Runs before commit is created

2. **`post-commit`** - Validates build after source/ changes
   - Detects if `source/` directory was modified
   - Runs `bb build` and `bb validate`
   - Reports build success or failure

3. **`pre-push`** - Comprehensive validation before pushing
   - Runs `bb test`, `bb build` and `bb validate`
   - Validates all conventional commit messages
   - Checks for uncommitted changes in `source/`
   - Blocks push if any validation fails

4. **`post-merge`** - Auto-rebuild after merge/pull
   - Detects if `source/` changed during merge
   - Auto-runs `bb build` and `bb validate`
   - Notifies about changes to review

#### Hook Locations

- **Hook templates:** `.git-hooks/` (versioned in git)
- **Setup scripts:** `scripts/setup-hooks.sh` and `scripts/setup-hooks.ps1`
- **Git configuration:** `core.hooksPath = .git-hooks`

#### Bypassing Hooks

```bash
# Bypass all hooks (not recommended)
git commit --no-verify
git push --no-verify

# Or bypass specific validations
git commit --no-verify -m "WIP: experimental changes"
```

**Note:** Hooks are cross-platform (Unix + Windows PowerShell).

### Release Process

**Automated with Conventional Commits:**

```bash
# 1. Make changes and commit using conventional commits
git commit -m "feat(classes): add Book class with author property"

# 2. Determine next version (automatic based on commits)
npm run version
# Output: 0.3.0 (if there are new features)

# 3. Update CHANGELOG.md (automatic)
npm run changelog:write

# 4. Commit changelog
git commit -am "docs(release): update changelog for v0.3.0"

# 5. Tag release
git tag v0.3.0
git push --tags

# 6. GitHub Actions automatically:
#    - Runs bb test, bb build, bb validate (and check-import)
#    - Generates release notes
#    - Creates GitHub release with schema-library.edn and schema-presets.edn
```

---

## Quick Reference Links

- [QUICK_START.md](QUICK_START.md) - import and develop
- [CONTRIBUTING.md](CONTRIBUTING.md) - contribution guide
- [docs/developer-guide/ci-cd-pipeline.md](docs/developer-guide/ci-cd-pipeline.md) - CI/CD
- [docs/developer-guide/validation-reference.md](docs/developer-guide/validation-reference.md) - validation rules
- [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md) - technical reference
- [DOCS_INDEX.md](DOCS_INDEX.md) - documentation map

---

## Related Resources

- [Logseq Official Docs](https://docs.logseq.com)
- [Schema.org](https://schema.org)
- [EDN Format Spec](https://github.com/edn-format/edn)
- [Tana Supertags](https://tana.inc/docs/supertags)
- [Babashka](https://babashka.org/)
