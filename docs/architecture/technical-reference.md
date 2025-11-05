# Technical Reference (formerly CLAUDE.md)

This file provides technical guidance for AI assistants and developers working with code in this repository.

**Note:** This file is now located at `docs/architecture/technical-reference.md` as part of the organized documentation structure.

**Quick Navigation:**
- [Project Overview](#project-overview)
- [File Structure](#file-structure-and-purpose)
- [EDN Format](#edn-file-format)
- [Key Concepts](#key-concepts)
- [Development Tasks](#common-development-tasks)
- [Automation Scripts](#automation-scripts)
- [Constraints](#important-constraints)

---

## Project Overview

This is a **Logseq DB template graph** starter repository that provides structured ontologies for organizing knowledge in Logseq's database format. It contains predefined properties and classes based on Schema.org vocabulary to help users add structure to their Logseq databases.

**Key Statistics:**
- 632 classes (Thing, Person, Organization, Event, Place, etc.)
- 1,033 properties with rich metadata
- 15,422 lines in main template file
- Schema.org-compliant vocabulary
- Automated CI/CD pipeline for development
- Modular workflow for large templates

## File Structure and Purpose

### Core Templates

- **logseq_db_Templates.edn** (15,422 lines) - The main template file containing 632 classes and 1,033 properties. This is the recommended starting point for most users. Clean structure without timestamps.

- **logseq_db_Templates_full.edn** (~7,000 lines) - The comprehensive version with full timestamps (`:block/created-at`, `:block/updated-at`) and additional metadata, representing the complete exported graph ontology.

**Note:** Due to the large size (15K+ lines), consider using the modular workflow for easier maintenance. See [Modular Quickstart](../modular/quickstart.md).

### Documentation Files

**📁 All documentation is now organized in the [`docs/`](../) folder!**

**Root Level (Quick Access):**
- [README.md](../../README.md) - Project overview, quick start, and feature showcase
- [QUICK_START.md](../../QUICK_START.md) - Installation guide and 5-minute setup (for both users and developers)
- [DOCS_INDEX.md](../../DOCS_INDEX.md) - Complete documentation index

**Documentation Portal:**
- [docs/README.md](../README.md) - Central documentation hub with organized navigation

**Developer Guides (`docs/developer-guide/`):**
- [ci-cd-pipeline.md](../developer-guide/ci-cd-pipeline.md) - Complete CI/CD pipeline and development workflow
- [implementation-summary.md](../developer-guide/implementation-summary.md) - Implementation summary and project status

**Modular Development (`docs/modular/`):**
- [quickstart.md](../modular/quickstart.md) - 5-minute modular workflow guide
- [strategy.md](../modular/strategy.md) - Complete modularization strategy

**Architecture (`docs/architecture/`):**
- [technical-reference.md](technical-reference.md) (this file) - Technical architecture for AI assistants

**Research (`docs/research/`):**
- [comprehensive-analysis.md](../research/comprehensive-analysis.md) - Deep dive into Logseq DB, Tana, and Schema.org

**Where to Create New Documentation:**
- User guides → `docs/user-guide/`
- Developer guides → `docs/developer-guide/`
- Modular templates → `docs/modular/`
- Technical deep-dives → `docs/architecture/`
- Research/analysis → `docs/research/`

### Automation Scripts

Located in [../../scripts/](../../scripts/):

**Core Export Scripts:**
- **export.sh** - Bash export script for Mac/Linux/Git Bash
- **export.ps1** - PowerShell export script for Windows
- **validate.sh** - EDN file validation script
- **analyze.sh** - Template analysis and statistics

**Modular Development Scripts (for 15K+ line templates):**
- **split.clj** - Babashka script to split monolith into modules
- **build.clj** - Build automation for creating template variants
- **init-modular.sh** - One-command setup for modular workflow

See [CI/CD Pipeline](../developer-guide/ci-cd-pipeline.md) for complete workflow documentation.

### Configuration Files

- [.gitignore](../../.gitignore) - Ignores timestamped exports, backups, build artifacts, and IDE files
- [LICENSE](../../LICENSE) - MIT License

### EDN File Format

Both EDN files follow the Clojure Extended Data Notation format with this structure:

```clojure
{:properties
 {:user.property/propertyName-UniqueID
  {:db/cardinality :db.cardinality/one  ; or :db.cardinality/many
   :logseq.property/type :default        ; or :node, :date, :url, :number
   :block/title "propertyName"
   :build/property-classes [:user.class/ClassName-UniqueID]
   :build/properties
   {:logseq.property/icon {:id "emoji_name" :type :emoji}
    :logseq.property/description "Description text"}}}

 :classes
 {:user.class/ClassName-UniqueID
  {:block/title "ClassName"
   :build/class-properties [:user.property/prop1 :user.property/prop2]
   :build/class-parent :user.class/ParentClass-ID
   :block/alias #{[:block/uuid #uuid "..."]}
   :build/properties
   {:logseq.property/icon {:id "emoji_name" :type :emoji}
    :logseq.property/description "Description text"}}}

 :logseq.db.sqlite.export/export-type :graph-ontology}
```

## Key Concepts

### Properties

Properties define attributes that can be attached to pages/blocks. Each property has:
- **Cardinality**: `:db.cardinality/one` (single value) or `:db.cardinality/many` (multiple values)
- **Type**: `:default`, `:node` (links to other pages), `:date`, `:url`, `:number`
- **Property Classes**: Which classes this property can be used with
- **Icon and Description**: UI metadata

### Classes

Classes define types of entities (e.g., Person, Organization, Event). Each class has:
- **Class Properties**: List of properties applicable to this class
- **Class Parent**: Inheritance relationship (e.g., Person inherits from Thing)
- **Aliases**: UUID-based references for cross-referencing
- **Build Properties**: Metadata including icons and descriptions

### Schema.org Inspiration

The ontology is heavily inspired by Schema.org vocabulary, including:
- **Thing** - Base class for all entities
- **Person** - People with properties like jobTitle, email, familyName, birthDate
- **Organization** - Companies, schools, NGOs with properties like legalName, employee, member
- **Event** - Events with properties like eventStatus, eventSchedule, attendee
- **Place** - Locations with address and event properties
- **Creative Work** - Books, articles, media with properties like author, isbn

### Naming Convention

- Property IDs: `user.property/propertyName-ShortRandomID`
- Class IDs: `user.class/ClassName-ShortRandomID`
- UUIDs in full version: RFC 4122 format for persistent references

## Automation Scripts

### Export Scripts

The export scripts automate the workflow of exporting Logseq graphs to clean, version-controlled EDN files.

**scripts/export.sh** (Bash):
- Checks for Logseq CLI installation
- Validates graph directory path
- Exports minimal template (no timestamps, clean structure)
- Exports full template (with all metadata)
- Shows statistics (line count, properties, classes)
- Displays git diff
- Prompts for commit and push
- Color-coded output for better UX

**scripts/export.ps1** (PowerShell):
- Windows equivalent of export.sh
- Same functionality with PowerShell syntax
- Supports Windows paths and conventions

**Configuration:**
- Set `LOGSEQ_GRAPH_PATH` environment variable
- Or edit the `GRAPH_PATH` variable in the script
- Default: `C:/Users/YourName/Logseq/template-dev`

### Validation Script

**scripts/validate.sh**:
- Checks file existence and non-empty content
- Validates EDN structure (starts with `{:properties`)
- Checks for export type marker
- Counts properties and classes
- Detects accidental timestamp filenames

### Usage Examples

```bash
# Export templates
./scripts/export.sh                    # Mac/Linux/Git Bash
.\scripts\export.ps1                   # Windows PowerShell

# Validate templates
./scripts/validate.sh

# Analyze template statistics
./scripts/analyze.sh
```

## Common Development Tasks

### Automated Workflow (Recommended)

```bash
# 1. Make changes in Logseq
# ... edit classes and properties in your graph ...

# 2. Export using the script
./scripts/export.sh

# 3. Script handles:
#    - Export to clean filenames
#    - Show statistics
#    - Display git diff
#    - Prompt for commit
#    - Optional push
```

### Manual Inspection

```bash
# Count properties and classes
grep -c "user.property/" logseq_db_Templates.edn
grep -c "user.class/" logseq_db_Templates.edn

# Find where classes section starts
grep -n "^ :classes" logseq_db_Templates.edn

# View specific definitions
grep -A 20 "user.property/email" logseq_db_Templates.edn
grep -A 30 "user.class/Person" logseq_db_Templates.edn
```

### Working with EDN Files

- EDN files are text-based and can be edited directly with proper Clojure/EDN syntax
- Maintain consistent indentation (2 spaces per level)
- Ensure all brackets `{}`, `[]`, and `#{}` are balanced
- UUIDs should follow RFC 4122 format when present
- Keywords start with `:` and use kebab-case naming
- **IMPORTANT:** Always use scripts for export, not manual UI export

## Important Constraints

1. **Do not modify structural markers**: `:logseq.db.sqlite.export/export-type :graph-ontology` must remain at the end
2. **Preserve unique IDs**: Random suffixes like `-cB8UklzM` ensure property/class uniqueness
3. **UUID references**: When present, UUIDs create persistent cross-references between entities
4. **Cardinality matters**: Changing between `:one` and `:many` affects how Logseq stores values
5. **Property type constraints**: Type changes (e.g., `:default` to `:date`) affect UI and validation

## Schema Relationships

Key parent-child class relationships:
- `Thing` → base for most classes
- `Thing` → `Person`, `Organization`, `Place`
- `Event` → `EventSeries`, `BusinessMeeting`
- Properties like `spouse`, `sibling` are typed as `:node` with cardinality constraints

References to other entities use UUID aliases or property relationships (e.g., `subOrganization` links Organizations).

## Documentation Cross-Reference

### For Users
- Start with [QUICK_START.md](../../QUICK_START.md#for-users-import-templates) for installation
- See [README.md](../../README.md#-quick-start) for feature overview
- Browse [Documentation Portal](../README.md) for organized navigation

### For Developers
- Follow [QUICK_START.md](../../QUICK_START.md#for-developers-set-up-development-environment) for setup
- Read [CI/CD Pipeline](../developer-guide/ci-cd-pipeline.md) for complete CI/CD pipeline
- Check [Implementation Summary](../developer-guide/implementation-summary.md) for implementation details
- Use [Modular Quickstart](../modular/quickstart.md) for large templates (15K+ lines)

### For Understanding
- Read [Comprehensive Analysis](../research/comprehensive-analysis.md) for background on Logseq DB, Tana, Schema.org
- Review [Modularization Strategy](../modular/strategy.md) for modular architecture details
- Check [DOCS_INDEX.md](../../DOCS_INDEX.md) for complete documentation map

## Git Workflow

### Recommended Commit Message Format

```bash
# Semantic commit messages
git commit -m "feat: add Recipe class with ingredients property"
git commit -m "fix: correct cardinality for spouse property"
git commit -m "docs: update installation instructions"
git commit -m "chore: auto-export templates on 2025-01-15"
```

### Release Workflow

```bash
# 1. Export templates
./scripts/export.sh

# 2. Tag release
git tag v0.3.0
git push --tags

# 3. Create GitHub release
gh release create v0.3.0 \
  --title "v0.3.0 - CreativeWork Classes" \
  --notes "Added Book, Article, Recipe" \
  logseq_db_Templates.edn \
  logseq_db_Templates_full.edn
```

## Documentation Organization

All documentation is organized in the `docs/` folder by category and audience:

```
docs/
├── README.md                          ← Documentation portal
├── user-guide/                        ← For template users
├── developer-guide/                   ← For contributors
│   ├── ci-cd-pipeline.md
│   └── implementation-summary.md
├── modular/                           ← For large templates (15K+ lines)
│   ├── quickstart.md
│   └── strategy.md
├── architecture/                      ← Technical deep-dives
│   └── technical-reference.md (this file)
└── research/                          ← Background analysis
    └── comprehensive-analysis.md
```

**When creating new documentation:**
1. Determine the audience (user, developer, researcher)
2. Place in appropriate `docs/` subfolder
3. Update [docs/README.md](../README.md) with new entry
4. Update [DOCS_INDEX.md](../../DOCS_INDEX.md) if major addition
5. Cross-link from related documentation
6. Test all links before committing

## Best Practices

### When Adding New Classes

1. Research Schema.org for standard naming
2. Add appropriate icon (emoji)
3. Write clear description
4. Define class properties list
5. Set class parent for inheritance
6. Test import in a fresh graph
7. Export using scripts
8. Document in commit message

### When Adding New Properties

1. Check Schema.org for standard name
2. Choose correct cardinality (`:one` or `:many`)
3. Set appropriate type (`:default`, `:node`, `:date`, `:url`, `:number`)
4. Define which classes can use it
5. Add icon and description
6. Test with actual data
7. Export and commit

### File Naming

- ✅ Use: `logseq_db_Templates.edn`
- ✅ Use: `logseq_db_Templates_full.edn`
- ❌ Never: `logseq_db_Templates_1762330414.edn` (timestamped)
- ❌ Never: Manual UI export without renaming

## Troubleshooting

### Common Issues

1. **Timestamped filename appears**
   - Solution: Always use `./scripts/export.sh`, not UI export

2. **Export script fails**
   - Check Logseq CLI installed: `logseq --version`
   - Verify graph path: `ls "$LOGSEQ_GRAPH_PATH"`
   - Check permissions: `chmod +x scripts/*.sh`

3. **Invalid EDN structure**
   - Run validation: `./scripts/validate.sh`
   - Check bracket balance
   - Ensure export-type marker present

4. **Git conflicts in EDN files**
   - EDN is text-based, review diffs carefully
   - Ensure brackets are balanced after merge
   - Re-export if structure is corrupted

## Related Resources

- [Logseq Official Docs](https://docs.logseq.com)
- [Logseq CLI on npm](https://www.npmjs.com/package/@logseq/cli)
- [Schema.org](https://schema.org)
- [EDN Format Spec](https://github.com/edn-format/edn)
- [Tana Supertags Concept](https://tana.inc/docs/supertags)
