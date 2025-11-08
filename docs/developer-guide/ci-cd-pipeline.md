# Development Workflow & CI/CD Pipeline

This document outlines the development workflow for building and maintaining the Logseq Template Graph project, including automation strategies to replace manual timestamp-based exports.

**Quick Links:** [README](README.md) | [Quick Start](QUICK_START.md) | [Technical Docs](CLAUDE.md)

---

## Table of Contents

- [Current Problem](#current-problem)
- [Solution Overview](#solution-overview)
- [Setup: Logseq CLI Installation](#setup-logseq-cli-installation)
- [Manual Development Workflow](#manual-development-workflow)
- [🆕 Modular Development Workflow](#modular-development-workflow-for-large-templates) ← **For 15K+ line templates**
- [Automated CI/CD Workflow](#automated-cicd-workflow)
- [Recommended Workflow](#recommended-workflow-for-this-project)
- [File Naming Convention](#file-naming-convention)
- [Advanced: Babashka Workflow](#advanced-babashka-developer-workflow)
- [Testing Your Templates](#testing-your-templates)
- [Troubleshooting](#troubleshooting)

---

## Current Problem

**Manual export via UI creates timestamped files:**
- `logseq_db_Templates_1762330414.edn` ❌
- No version control
- Hard to track changes
- Inconsistent naming

**We need:**
- Clean filenames (`logseq_db_Templates.edn`) ✅
- Automated exports
- Git-trackable changes
- CI/CD pipeline

---

## Solution Overview

Logseq provides **two CLI approaches** for automated EDN export:

1. **`@logseq/cli` (Official)** - Standalone npm package for DB graphs
2. **Babashka scripts (Developer)** - For Logseq repository contributors

For this template project, we'll use **`@logseq/cli`** as it's designed for external users.

---

## Setup: Dependencies Installation

### Prerequisites

- Node.js 16+ installed
- Logseq DB version installed on your system
- A Logseq DB graph where you're building your templates

### Install Project Dependencies

```bash
# Clone the repository
git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
cd logseq-template-graph

# Install npm dependencies (includes @logseq/cli)
npm install

# This automatically:
# - Installs @logseq/cli as a dev dependency
# - Sets up git commit hooks
# - Checks for Babashka (optional, for modular workflow)
```

### Install Babashka (Optional - Recommended)

Babashka is required for the modular workflow (splitting large templates):

```bash
# Mac
brew install borkdude/brew/babashka

# Windows
scoop install babashka

# Linux
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)

# Verify
bb --version
```

### Available npm Scripts

```bash
npm run export          # Export + auto-split into modules
npm run split           # Manually split template into modules
npm run build:full      # Build full template from modules
npm run build:crm       # Build CRM preset
npm run build:research  # Build research preset
npm run validate        # Validate EDN syntax
```

---

## Manual Development Workflow

### 1. Work in Your Logseq DB Graph

Create and refine your template in a dedicated Logseq DB graph:

```
C:\Users\YourName\Logseq\
└── template-dev\          # Your development graph
    ├── Person
    ├── Organization
    ├── Event
    └── ... other classes/properties
```

**Best Practices:**
- Use one graph exclusively for template development
- Document changes as you go
- Test properties and classes before exporting
- Keep a changelog in the graph itself

### 2. Export via npm Scripts (Recommended)

Instead of using the UI export (which adds timestamps) or manual CLI commands, use npm scripts:

```bash
# Navigate to your project directory
cd C:\Users\YourName\Documents\Code Files\Logseq-db\logseq-template-graph

# Export and auto-split (recommended)
npm run export

# This automatically:
# - Exports from Logseq → archive/pre-modular/logseq_db_Templates.edn
# - Splits into modules → src/
# - Shows statistics and git changes
```

**Alternative: Direct Script Execution**

```bash
# Mac/Linux
./scripts/export.sh

# Windows
.\scripts\export.ps1
```

**What the export script does:**
1. Exports using `npx logseq export-edn` (uses local CLI from node_modules)
2. Excludes built-in pages and `logseq.kv` namespace
3. Shows statistics (lines, properties, classes)
4. Automatically splits into modules (if Babashka installed)
5. Shows git diff summary
6. Displays next steps

### 3. Review Modular Changes

```bash
# Review modular source files (much easier than 15K line diff!)
git diff src/person/properties.edn
git diff src/event/classes.edn

# Review full diff summary
git diff src/

# Or review the monolith (if needed)
git diff archive/pre-modular/logseq_db_Templates.edn
```

### 4. Build Template Variants (Optional)

```bash
# Build specific presets from modular source
npm run build:full      # Full template (632 classes)
npm run build:crm       # CRM preset
npm run build:research  # Research preset

# Files are created in build/ directory
```

### 5. Commit and Push

```bash
# Add all changes (modules + archives)
git add src/ archive/

# Commit with conventional commits format
git commit -m "feat(classes): add Recipe and Book classes with author properties"

# Push to remote
git push
git push origin main
```

---

## Modular Development Workflow (For Large Templates)

**🆕 Use this workflow when your template exceeds 5,000 lines or has 100+ classes.**

Current template: **15,422 lines, 1,033 properties, 632 classes** → **Modularization recommended!**

### When to Modularize

Use modular workflow when you have:
- ✅ Template > 5,000 lines
- ✅ 100+ classes
- ✅ Multiple contributors (merge conflicts)
- ✅ Need for template variants (CRM, Research, Content, etc.)
- ✅ Difficulty navigating single file

### Quick Start with Modular Workflow

```bash
# 1. One-time setup (installs Babashka, creates structure)
./scripts/init-modular.sh

# 2. Work in Logseq as usual
# ... make changes to classes and properties ...

# 3. Export from Logseq
./scripts/export.sh

# 4. Split into modules
bb scripts/split.clj

# 5. Review modular changes (much cleaner diffs!)
git diff source/person/properties.edn    # 15 lines changed
git diff source/event/classes.edn        # 8 lines changed

# 6. Build variants
bb scripts/build.clj full      # Full template (15K+ lines)
bb scripts/build.clj crm       # CRM only (~2K lines)
bb scripts/build.clj research  # Research only (~3K lines)

# 7. Validate
./scripts/validate.sh build/logseq_db_Templates_full.edn

# 8. Commit source (not build artifacts)
git add source/
git commit -m "feat: add Recipe class to creative-work module"
git push
```

### Modular Structure

```
source/                    ← Edit these (50-200 lines each)
├── base/
│   ├── classes.edn
│   ├── properties.edn
│   └── README.md
├── person/
│   ├── classes.edn       ← Person class
│   ├── properties.edn    ← 150+ person properties
│   └── README.md
├── organization/
├── event/
├── creative-work/
└── presets/
    ├── full.edn          ← All modules
    ├── crm.edn           ← CRM variant
    └── research.edn      ← Research variant

build/                     ← Generated artifacts
├── logseq_db_Templates_full.edn
├── logseq_db_Templates_crm.edn
└── logseq_db_Templates_research.edn
```

### Benefits of Modular Approach

**Before (Monolith):**
```
❌ Single 15,422-line file
❌ Git diffs: 500+ lines changed
❌ Can't navigate efficiently
❌ Merge conflicts everywhere
❌ Can't create variants
```

**After (Modular):**
```
✅ 50-200 line modules
✅ Git diffs: 10-20 lines per change
✅ Easy to find and edit
✅ Multiple contributors work in parallel
✅ Build 5+ variants (full, CRM, research, content, events)
```

### Documentation

**Quick Reference:** [MODULAR_QUICKSTART.md](MODULAR_QUICKSTART.md)
**Complete Strategy:** [MODULARIZATION_PLAN.md](MODULARIZATION_PLAN.md)

---

## Automated CI/CD Workflow

### Option 1: Local Script (Recommended for Start)

Create a simple export script to standardize your workflow.

**`scripts/export.sh` (Git Bash/WSL on Windows):**

```bash
#!/bin/bash

# Configuration
GRAPH_PATH="C:/Users/YourName/Logseq/template-dev"
OUTPUT_DIR="."
DATE=$(date +%Y-%m-%d)

echo "🚀 Exporting Logseq Template Graph..."

# Export minimal version (no timestamps)
echo "📦 Exporting minimal template..."
logseq export-edn \
  --graph "$GRAPH_PATH" \
  --output "$OUTPUT_DIR/logseq_db_Templates.edn" \
  --exclude-namespaces "logseq.kv" \
  --ignore-builtin-pages

# Export full version (with timestamps and metadata)
echo "📦 Exporting full template..."
logseq export-edn \
  --graph "$GRAPH_PATH" \
  --output "$OUTPUT_DIR/logseq_db_Templates_full.edn" \
  --include-timestamps

echo "✅ Export complete!"
echo "📊 Changes:"
git diff --stat logseq_db_Templates.edn logseq_db_Templates_full.edn

# Optional: Auto-commit (use with caution)
# read -p "Commit changes? (y/n) " -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#   git add logseq_db_Templates*.edn
#   git commit -m "chore: auto-export templates on $DATE"
#   echo "✅ Changes committed"
# fi
```

**`scripts/export.ps1` (PowerShell on Windows):**

```powershell
# Configuration
$GRAPH_PATH = "C:\Users\YourName\Logseq\template-dev"
$OUTPUT_DIR = "."
$DATE = Get-Date -Format "yyyy-MM-dd"

Write-Host "🚀 Exporting Logseq Template Graph..." -ForegroundColor Cyan

# Export minimal version
Write-Host "📦 Exporting minimal template..." -ForegroundColor Yellow
logseq export-edn `
  --graph "$GRAPH_PATH" `
  --output "$OUTPUT_DIR\logseq_db_Templates.edn" `
  --exclude-namespaces "logseq.kv" `
  --ignore-builtin-pages

# Export full version
Write-Host "📦 Exporting full template..." -ForegroundColor Yellow
logseq export-edn `
  --graph "$GRAPH_PATH" `
  --output "$OUTPUT_DIR\logseq_db_Templates_full.edn" `
  --include-timestamps

Write-Host "✅ Export complete!" -ForegroundColor Green
Write-Host "📊 Changes:"
git diff --stat logseq_db_Templates.edn logseq_db_Templates_full.edn
```

**Make executable and run:**

```bash
# Git Bash/WSL
chmod +x scripts/export.sh
./scripts/export.sh

# PowerShell
.\scripts\export.ps1
```

### Option 2: GitHub Actions (Scheduled Exports)

**Note:** This requires Logseq running on a server or self-hosted runner, which is complex. Start with local scripts first.

**`.github/workflows/export-templates.yml`:**

```yaml
name: Export Template Graph

on:
  # Manual trigger
  workflow_dispatch:

  # Or schedule (every day at 2 AM UTC)
  # schedule:
  #   - cron: '0 2 * * *'

jobs:
  export:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install Logseq CLI
        run: npm install -g @logseq/cli

      # NOTE: This step requires access to your Logseq graph
      # You'd need to either:
      # 1. Commit your graph to the repo (not recommended - privacy)
      # 2. Download from a cloud sync location
      # 3. Use a self-hosted runner with Logseq installed

      - name: Export templates
        run: |
          logseq export-edn \
            --graph ./dev-graph \
            --output logseq_db_Templates.edn

      - name: Commit changes
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add logseq_db_Templates*.edn
          git diff --staged --quiet || git commit -m "chore: auto-export templates [skip ci]"
          git push
```

**Limitations:**
- GitHub Actions runners don't have Logseq installed
- Your graph needs to be accessible (security/privacy concern)
- Better suited for CI validation than export

### Option 3: Git Hooks (Pre-Commit Validation)

Instead of automated export, validate before committing:

**`.git/hooks/pre-commit`:**

```bash
#!/bin/bash

echo "🔍 Validating EDN files..."

# Check if EDN files are valid
for file in logseq_db_Templates*.edn; do
  if [ -f "$file" ]; then
    # Basic validation: check if file is valid EDN
    # (You'd need a proper EDN validator here)

    # Check for common issues
    if grep -q "logseq_db_Templates_[0-9]" "$file"; then
      echo "❌ ERROR: File contains timestamped reference: $file"
      echo "   Please use clean filenames without timestamps"
      exit 1
    fi

    echo "✅ $file looks good"
  fi
done

echo "✅ All validations passed"
```

---

## Recommended Workflow for This Project

### Daily Development

```bash
# 1. Work in Logseq on your template graph
# ... make changes to classes and properties ...

# 2. Export when ready
./scripts/export.sh   # or export.ps1 on Windows

# 3. Review changes
git diff logseq_db_Templates.edn

# 4. Commit with semantic message
git add logseq_db_Templates*.edn
git commit -m "feat: add Recipe class with ingredients and instructions"
git push
```

### Creating Releases

```bash
# 1. Update version in a changelog or release notes
echo "## v0.2.0 - 2025-01-15" >> CHANGELOG.md
echo "- Added Recipe, Book, and Article classes" >> CHANGELOG.md
echo "- Enhanced Person with knowsLanguage property" >> CHANGELOG.md

# 2. Export templates
./scripts/export.sh

# 3. Commit and tag
git add .
git commit -m "chore: release v0.2.0"
git tag v0.2.0
git push origin main --tags

# 4. Create GitHub release
gh release create v0.2.0 \
  --title "v0.2.0 - CreativeWork Classes" \
  --notes "$(cat CHANGELOG.md | head -20)" \
  logseq_db_Templates.edn \
  logseq_db_Templates_full.edn
```

---

## File Naming Convention

**Standardized naming (no timestamps):**

```
logseq_db_Templates.edn          # Minimal version (recommended)
logseq_db_Templates_full.edn     # Complete with metadata
```

**Archive old exports (if needed):**

```bash
# Move UI-exported files to archive
mkdir -p archive
mv logseq_db_Templates_*.edn archive/
```

**Git ignore patterns (`.gitignore`):**

```gitignore
# Ignore UI-exported files with timestamps
logseq_db_Templates_[0-9]*.edn

# Ignore personal development graphs
dev-graph/
template-dev/

# Ignore backups
*.backup
archive/
```

---

## Advanced: Babashka Developer Workflow

**For contributors to the Logseq project itself**, you can use Babashka scripts:

### Install Babashka

```bash
# Windows (with Scoop)
scoop install babashka

# macOS
brew install borkdude/brew/babashka

# Linux
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
```

### Clone Logseq Repository

```bash
git clone https://github.com/logseq/logseq.git
cd logseq
```

### Use bb Tasks

```bash
# Export a DB graph to EDN
bb dev:db-export --graph-dir /path/to/graph --output output.edn

# Import EDN to create a new graph
bb dev:db-create --edn-file output.edn --graph-dir /path/to/new-graph

# Diff two graphs
bb dev:db-diff graph1-dir graph2-dir

# Validate a DB graph
bb dev:validate-db --graph-dir /path/to/graph
```

**Note:** This approach requires the full Logseq development environment and is overkill for template maintenance.

---

## Testing Your Templates

### Manual Import Test

```bash
# 1. Create a test Logseq DB graph
# File → New Graph → Database Graph → "template-test"

# 2. Import your template
# Settings → Import → EDN to DB Graph
# Select: logseq_db_Templates.edn

# 3. Verify classes and properties loaded
# - Check #Person has correct properties
# - Check #Organization hierarchy
# - Test creating tagged pages
```

### Automated Validation Script

**`scripts/validate.sh`:**

```bash
#!/bin/bash

echo "🔍 Validating template EDN files..."

# Check file exists
if [ ! -f "logseq_db_Templates.edn" ]; then
  echo "❌ logseq_db_Templates.edn not found!"
  exit 1
fi

# Check file is not empty
if [ ! -s "logseq_db_Templates.edn" ]; then
  echo "❌ logseq_db_Templates.edn is empty!"
  exit 1
fi

# Check starts with {:properties
if ! head -1 logseq_db_Templates.edn | grep -q "^{:properties"; then
  echo "❌ File doesn't start with {:properties"
  exit 1
fi

# Check ends with export type marker
if ! tail -1 logseq_db_Templates.edn | grep -q "logseq.db.sqlite.export/export-type"; then
  echo "❌ File doesn't end with export-type marker"
  exit 1
fi

# Count properties and classes
PROP_COUNT=$(grep -c "user.property/" logseq_db_Templates.edn)
CLASS_COUNT=$(grep -c "user.class/" logseq_db_Templates.edn)

echo "✅ Validation passed!"
echo "📊 Properties: $PROP_COUNT"
echo "📊 Classes: $CLASS_COUNT"
```

---

## CI/CD Pipeline Summary

### Phase 1: Local Automation (Start Here)
- ✅ Install `@logseq/cli`
- ✅ Create `scripts/export.sh` or `.ps1`
- ✅ Use consistent naming (no timestamps)
- ✅ Git commit with semantic messages

### Phase 2: Validation
- ✅ Add pre-commit hooks for EDN validation
- ✅ Create automated tests for import
- ✅ Compare diffs between versions

### Phase 3: GitHub Integration
- ✅ Set up GitHub releases with tagged versions
- ✅ Attach EDN files to releases
- ✅ Generate changelog automatically

### Phase 4: Community (Future)
- ⬜ Accept community PRs for new classes
- ⬜ Automated validation of PRs
- ⬜ Template variants in separate branches
- ⬜ Documentation site with examples

---

## Quick Reference

### Export Commands

```bash
# Basic export (minimal)
logseq export-edn -g "C:\Users\YourName\Logseq\template-dev" -o logseq_db_Templates.edn

# Full export (with timestamps)
logseq export-edn -g "C:\Users\YourName\Logseq\template-dev" -o logseq_db_Templates_full.edn --include-timestamps

# Clean export (no builtin pages)
logseq export-edn -g "C:\Users\YourName\Logseq\template-dev" -o logseq_db_Templates.edn --ignore-builtin-pages --exclude-namespaces "logseq.kv"
```

### Git Workflow

```bash
# Export
./scripts/export.sh

# Review
git diff logseq_db_Templates.edn

# Commit
git add logseq_db_Templates*.edn
git commit -m "feat: add new class"
git push

# Tag release
git tag v0.3.0
git push --tags
```

---

## Troubleshooting

### Problem: `logseq: command not found`

**Solution:**
```bash
# Install CLI globally
npm install -g @logseq/cli

# Check npm global bin location
npm config get prefix

# Add to PATH if needed (Windows)
# Add C:\Users\YourName\AppData\Roaming\npm to PATH

# Verify
logseq --version
```

### Problem: Export includes timestamp in filename

**Solution:** Use `--output` flag explicitly:
```bash
logseq export-edn --output logseq_db_Templates.edn
# NOT: logseq export-edn (uses default timestamped name)
```

### Problem: Export is too large / includes unwanted data

**Solution:** Use filtering options:
```bash
logseq export-edn \
  --ignore-builtin-pages \
  --exclude-namespaces "logseq.kv,user.journal"
```

### Problem: Can't find graph path

**Solution:** Logseq graphs are typically in:
- Windows: `C:\Users\YourName\Logseq\GraphName`
- macOS: `~/Logseq/GraphName`
- Linux: `~/Logseq/GraphName`

List all graphs:
```bash
logseq list
```

---

## Next Steps

1. **Install Logseq CLI** - `npm install -g @logseq/cli`
2. **Create export script** - Copy `scripts/export.sh` or `.ps1`
3. **Run first export** - `./scripts/export.sh`
4. **Set up `.gitignore`** - Ignore timestamped files
5. **Commit with clean names** - No more timestamps!

You now have a professional, repeatable workflow for maintaining your Logseq template graph! 🚀

---

## Related Documentation

- [README.md](README.md) - Project overview and features
- [QUICK_START.md](QUICK_START.md) - 5-minute setup guide
- [CLAUDE.md](CLAUDE.md) - Technical architecture reference
- [RESEARCH_REPORT.md](RESEARCH_REPORT.md) - Background research
- [SUMMARY.md](SUMMARY.md) - Implementation summary

[Back to top](#development-workflow--cicd-pipeline)
