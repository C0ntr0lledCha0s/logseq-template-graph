# Logseq Template Graph - Claude Code Configuration

This file provides guidance to Claude Code (AI assistant) when working with code in this repository.

**For detailed technical documentation, see:** [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md)

---

## Project Overview

This is a **Logseq DB template graph** starter repository that provides structured ontologies for organizing knowledge in Logseq's database format. It contains predefined properties and classes based on Schema.org vocabulary.

**Current Scale:**
- **632 classes** (Thing, Person, Organization, Event, Place, etc.)
- **1,033 properties** with rich metadata
- **15,422 lines** in main template file
- Schema.org-compliant vocabulary
- Automated CI/CD pipeline + Modular workflow

**Purpose:** Bring Tana-style supertag functionality to open-source Logseq using Schema.org vocabulary.

---

## Quick File Navigation

### Core Templates
- `logseq_db_Templates.edn` (15,422 lines) - Main template with 632 classes and 1,033 properties
- `logseq_db_Templates_full.edn` (~7K lines) - Full version with timestamps

### Documentation Structure

**📁 All documentation is in the `docs/` folder:**

```
docs/
├── README.md                    ← Documentation portal (START HERE)
├── user-guide/                  ← For template users
├── developer-guide/             ← For contributors
│   ├── ci-cd-pipeline.md        ← Complete CI/CD workflow
│   └── implementation-summary.md
├── modular/                     ← For large templates (15K+ lines)
│   ├── quickstart.md            ← 5-min modular guide
│   └── strategy.md              ← Complete modularization
├── architecture/                ← Technical deep-dives
│   └── technical-reference.md   ← Detailed technical reference
└── research/
    └── comprehensive-analysis.md ← Logseq/Tana/Schema.org analysis
```

**Root Level Quick Access:**
- [README.md](README.md) - Project overview
- [QUICK_START.md](QUICK_START.md) - 5-minute setup
- [DOCS_INDEX.md](DOCS_INDEX.md) - Complete documentation map

### Scripts

**Location:** `scripts/`

**Core Export Scripts:**
- `export.sh` / `export.ps1` - Export from Logseq + auto-split into modules
- `validate.sh` - EDN validation
- `analyze.sh` - Template statistics
- `check-deps.js` - Verify Babashka installation (runs on npm install)

**Modular Development (Babashka required):**
- `split.clj` - Split monolith into modules (auto-runs after export)
- `build.clj` - Build template variants (full, CRM, research, etc.)

---

## Development Workflow

### Recommended Workflow (Modular - Default for 15K+ lines)
```bash
# 1. Make changes in Logseq
# ... edit classes, properties ...

# 2. Export and auto-split
npm run export                # Exports → auto-splits into src/ modules

# 3. Build template variants (optional)
npm run build:full            # Full template (632 classes)
npm run build:crm             # CRM preset
npm run build:research        # Research preset

# 4. Review and commit
git diff src/                 # Review modular source changes
git add .
git commit -m "feat(classes): add Recipe class"
git push
```

### Alternative: Direct Script Execution
```bash
# Run scripts directly (bypasses npm):
./scripts/export.sh           # Mac/Linux
.\scripts\export.ps1           # Windows

# Manual split (if needed):
bb scripts/split.clj

# Manual build:
bb scripts/build.clj full
```

**See:** [docs/modular/quickstart.md](docs/modular/quickstart.md)

---

## EDN File Format

Template files use Clojure Extended Data Notation (EDN):

```clojure
{:properties
 {:user.property/propertyName-UniqueID
  {:db/cardinality :db.cardinality/one  ; or :many
   :logseq.property/type :default        ; :node, :date, :url, :number
   :block/title "propertyName"
   :build/property-classes [:user.class/ClassName-ID]
   :build/properties
   {:logseq.property/icon {:id "emoji" :type :emoji}
    :logseq.property/description "Description"}}}

 :classes
 {:user.class/ClassName-UniqueID
  {:block/title "ClassName"
   :build/class-properties [:user.property/prop1 ...]
   :build/class-parent :user.class/ParentClass-ID
   :build/properties {...}}}

 :logseq.db.sqlite.export/export-type :graph-ontology}
```

---

## Key Concepts

### Properties
Attributes attached to pages/blocks:
- **Cardinality**: `:one` (single) or `:many` (multiple values)
- **Type**: `:default`, `:node` (links), `:date`, `:url`, `:number`
- **Property Classes**: Which classes can use this property
- **Icon & Description**: UI metadata

### Classes
Types of entities (like Tana supertags):
- **Class Properties**: List of properties for this class
- **Class Parent**: Inheritance (e.g., Person inherits from Thing)
- **Aliases**: UUID-based cross-references

### Schema.org Inspiration
Standard vocabulary from schema.org:
- **Thing** - Base class
- **Person** - jobTitle, email, birthDate, spouse, worksFor
- **Organization** - legalName, employee, member
- **Event** - eventStatus, attendee, organizer
- And 628+ more classes

---

## Important Constraints

1. **Do not modify**: `:logseq.db.sqlite.export/export-type :graph-ontology` marker
2. **Preserve unique IDs**: Random suffixes like `-cB8UklzM` ensure uniqueness
3. **Cardinality matters**: Changing `:one` ↔ `:many` affects storage
4. **Type constraints**: Type changes affect UI and validation
5. **Always use export scripts**: Never manual UI export without scripts

---

## Common Development Tasks

### Adding New Classes
1. Research Schema.org for standard naming
2. Add icon (emoji) and description
3. Define class properties list
4. Set class parent for inheritance
5. Test import in fresh graph
6. Export using scripts: `./scripts/export.sh`
7. Commit with semantic message: `git commit -m "feat: add Recipe class"`

### Adding New Properties
1. Check Schema.org for standard name
2. Choose cardinality (`:one` or `:many`)
3. Set type (`:default`, `:node`, `:date`, `:url`, `:number`)
4. Define which classes use it
5. Add icon and description
6. Test with actual data
7. Export and commit

### Documentation
**When creating new documentation:**
1. Determine audience (user, developer, researcher)
2. Place in appropriate `docs/` subfolder:
   - User guides → `docs/user-guide/`
   - Developer guides → `docs/developer-guide/`
   - Modular templates → `docs/modular/`
   - Technical deep-dives → `docs/architecture/`
   - Research/analysis → `docs/research/`
3. Update [docs/README.md](docs/README.md) with new entry
4. Update [DOCS_INDEX.md](DOCS_INDEX.md) if major addition
5. Cross-link from related docs
6. Test all links

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
- `scripts` - Build, export, validation scripts
- `docs` - Documentation files
- `release` - Release-related changes
- `modular` - Modular architecture changes
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
git commit -m "chore(templates): auto-export templates"
git commit -m "chore: update dependencies"

# Breaking changes
git commit -m "feat(classes)!: remove deprecated Customer class

BREAKING CHANGE: Customer class removed, use Person with customerRole property instead"
```

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
   - Runs `npm run build:full` to validate changes
   - Reports build success or failure
   - Suggests `/diagnose` command on failure

3. **`pre-push`** - Comprehensive validation before pushing
   - Builds all template variants (full, CRM, research)
   - Validates all conventional commit messages
   - Checks for uncommitted changes in `source/`
   - Blocks push if any validation fails

4. **`post-merge`** - Auto-rebuild after merge/pull
   - Detects if `source/` changed during merge
   - Auto-runs `npm run build:full`
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
#    - Builds all template variants
#    - Generates release notes
#    - Creates GitHub release with .edn files
```

**Manual Release (legacy):**

```bash
# 1. Export and test
./scripts/export.sh

# 2. Tag release
git tag v0.3.0
git push --tags

# 3. GitHub Actions handles the rest automatically
```

---

## Quick Reference Links

### For Users
- [QUICK_START.md](QUICK_START.md#for-users-import-templates) - Installation
- [README.md](README.md) - Feature overview

### For Developers
- [QUICK_START.md](QUICK_START.md#for-developers-set-up-development-environment) - Dev setup
- [docs/developer-guide/ci-cd-pipeline.md](docs/developer-guide/ci-cd-pipeline.md) - Complete CI/CD
- [docs/modular/quickstart.md](docs/modular/quickstart.md) - Modular workflow (15K+ lines)

### For Deep Understanding
- [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md) - Complete technical reference
- [docs/research/comprehensive-analysis.md](docs/research/comprehensive-analysis.md) - Logseq/Tana/Schema.org
- [DOCS_INDEX.md](DOCS_INDEX.md) - Complete documentation map

---

## Related Resources

- [Logseq Official Docs](https://docs.logseq.com)
- [Logseq CLI on npm](https://www.npmjs.com/package/@logseq/cli)
- [Schema.org](https://schema.org)
- [EDN Format Spec](https://github.com/edn-format/edn)
- [Tana Supertags](https://tana.inc/docs/supertags)
- [Babashka](https://babashka.org/) - For modular workflow

---

**Last Updated:** November 2025 | **Template Size:** 15,422 lines, 632 classes, 1,033 properties
