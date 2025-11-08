# Quick Start Guide

Get up and running with the Logseq Template Graph in 5 minutes!

**Table of Contents:**
- [For Users: Import Templates](#for-users-import-templates)
- [For Developers: Set Up Development Environment](#for-developers-set-up-development-environment)

---

## For Users: Import Templates

### Step 0: Install Logseq Database Version

**IMPORTANT:** This template requires Logseq Database version, not the regular markdown-based Logseq.

#### How to Get Logseq DB

1. **Download the Database Version:**
   - Visit [Logseq Downloads](https://logseq.com/downloads)
   - Look for the "Database Version" or "DB Version" (currently in alpha/beta)
   - Or check the [Logseq GitHub Releases](https://github.com/logseq/logseq/releases) for DB builds

2. **Install Logseq DB:**
   - **Windows:** Run the `.exe` installer
   - **macOS:** Open the `.dmg` file and drag to Applications
   - **Linux:** Extract `.AppImage` and make executable

3. **Verify Database Version:**
   - Open Logseq
   - Create a new graph
   - Check that you see "Database Graph" option (not just "Markdown Graph")
   - If you only see markdown options, you need the DB version

4. **Create Your First DB Graph:**
   - In Logseq, go to: File → New Graph → **Database Graph**
   - Choose a location and name for your graph
   - This will be your structured knowledge base

#### Differences Between Versions

| Feature | Markdown Logseq | Database Logseq |
|---------|-----------------|-----------------|
| Storage | `.md` files | SQLite database |
| Classes | No | Yes (like Tana supertags) |
| Properties | Basic | Rich (with types, cardinality) |
| Templates | Limited | Full ontology support |
| **Compatible?** | ❌ Not compatible | ✅ Required for this template |

### Step 1: Download the Template

Download the latest template from the [Releases page](https://github.com/C0ntr0lledCha0s/logseq-template-graph/releases/latest).

**Available variants:**
- **logseq_db_Templates_full.edn** - Complete template (632 classes, 1,033 properties)
- **logseq_db_Templates_crm.edn** - CRM preset (Person, Organization focused)
- **logseq_db_Templates_research.edn** - Research preset (Books, Articles, Academic)

**Tip:** Start with the full template, or choose a preset that matches your use case.

### Step 2: Import into Logseq

1. Open your Logseq **Database Graph**
2. Go to: Settings (⚙️) → Import → **EDN to DB Graph**
3. Select the downloaded `.edn` file
4. Wait for import to complete (should take a few seconds)

### Step 3: Start Using!

Tag any page with structured types:
- `#Person` → Get properties: email, jobTitle, birthDate, etc.
- `#Organization` → Get properties: legalName, employee, member, etc.
- `#Event` → Get properties: eventStatus, attendee, organizer, etc.

**You're done! Start building your structured knowledge base.**

[Back to top](#quick-start-guide)

---

## For Developers: Set Up Development Environment

Want to contribute or customize templates? Follow these steps.

### Prerequisites

- ✅ Node.js 16+ installed
- ✅ Logseq DB version installed (see above)
- ✅ A Logseq DB graph for template development
- ✅ Git installed

### Step 1: Install Dependencies

Clone the repository and install all dependencies:

```bash
git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
cd logseq-template-graph
npm install
```

This installs:
- `@logseq/cli` - For exporting templates
- `git-conventional-commits` - For automated changelog generation
- Git hooks for commit validation

The installer will also check for Babashka (required for modular workflow).

**Install Babashka (optional but recommended):**

```bash
# Mac
brew install borkdude/brew/babashka

# Windows
scoop install babashka

# Linux
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
```

Verify:
```bash
bb --version
```

## Step 2: Configure Your Graph Path

### Option A: Set Environment Variable (Recommended)

**Windows (PowerShell):**
```powershell
# Temporary (current session)
$env:LOGSEQ_GRAPH_PATH = "C:\Users\YourName\logseq\template-dev"

# Permanent
[System.Environment]::SetEnvironmentVariable('LOGSEQ_GRAPH_PATH', 'C:\Users\YourName\logseq\template-dev', 'User')
```

**Mac/Linux (Bash):**
```bash
# Add to ~/.bashrc or ~/.zshrc
export LOGSEQ_GRAPH_PATH="$HOME/logseq/template-dev"

# Reload
source ~/.bashrc
```

### Option B: Edit Export Script

Edit `scripts/export.sh` or `scripts/export.ps1` and change:
```bash
GRAPH_PATH="C:/Users/YourName/logseq/template-dev"
```

To your actual path:
```bash
GRAPH_PATH="C:/Users/YourName/logseq/your-graph-name"
```

## Step 3: Run Your First Export

Now you can use npm scripts for all operations:

```bash
npm run export
```

Or run the scripts directly (for advanced usage):

**Windows:**
```powershell
.\scripts\export.ps1
```

**Mac/Linux:**
```bash
./scripts/export.sh
```

**Note:** Scripts may need to be made executable on Mac/Linux:
```bash
chmod +x scripts/*.sh
```

You should see:
```
🚀 Exporting Logseq Template Graph...
📦 Exporting template...
✅ Template exported
✅ Export complete!
📊 Statistics:
   Lines: 15422
   Properties: 1033
   Classes: 632
```

## Step 4: Review Modular Changes

The export automatically splits into modules (if Babashka is installed). Review modular source files:

```bash
# Review specific module changes (much easier than 15K line diff!)
git diff src/person/properties.edn
git diff src/event/classes.edn

# Or review all modular changes
git diff src/
```

**Note:** The monolith file (`archive/pre-modular/logseq_db_Templates.edn`) is ignored by git.

## Step 5: Build & Commit

Build template variants (optional):

```bash
npm run build:full      # Full template
npm run build:crm       # CRM preset
npm run build:research  # Research preset
```

Commit modular source using [conventional commits](https://www.conventionalcommits.org/):

```bash
# Add modular source files
git add src/

# Commit with descriptive message
git commit -m "feat(classes): add Recipe class with ingredients property"

# Push to remote
git push
```

---

## Daily Workflow

```bash
# 1. Work in Logseq on your template
# ... make changes ...

# 2. Export and split into modules
npm run export          # Auto-runs split if Babashka is installed

# 3. Build template variants (optional)
npm run build:full      # Full template with all classes
npm run build:crm       # CRM preset
npm run build:research  # Research preset

# 4. Review and commit modular source
git diff src/           # Review modular source changes (not archive/)
git add src/            # Only commit src/ (archive/ is gitignored)
git commit -m "feat(classes): add Recipe class"
git push
```

**Available npm scripts:**

**Export & Workflow:**
```bash
npm run export          # Export from Logseq + auto-split into modules
npm run export:full     # Export with timestamps (if available)
npm run validate        # Validate EDN syntax
```

**Modular Workflow (requires Babashka):**
```bash
npm run split           # Split monolith into src/ modules
npm run build           # Build default template variant
npm run build:full      # Build full template (all 632 classes)
npm run build:crm       # Build CRM preset
npm run build:research  # Build research preset
```

**Version & Changelog:**
```bash
npm run version         # Show next semantic version
npm run changelog       # Generate changelog
npm run changelog:write # Write changelog to CHANGELOG.md
```

---

## Troubleshooting

### "npx: command not found" or "logseq: command not found"

Make sure you've installed dependencies:
```bash
npm install
```

If the issue persists, ensure Node.js is installed:
```bash
node --version  # Should be 16.0.0 or higher
npm --version
```

Verify npm global path is in your PATH:
```bash
npm config get prefix
```

### "Graph directory not found"

Set the correct path:
```bash
# List all your graphs
logseq list

# Use the correct path
export LOGSEQ_GRAPH_PATH="/path/to/your/graph"
```

### Scripts won't run on Windows

Use PowerShell (not Command Prompt):
```powershell
.\scripts\export.ps1
```

If execution policy error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Next Steps

- Read [DEV_WORKFLOW.md](DEV_WORKFLOW.md) for complete documentation
- Set up automated validation with `scripts/validate.sh`
- Create releases with git tags
- Share your templates with the community!

---

## Additional Resources

### Documentation
- [README.md](README.md) - Project overview and features
- [DEV_WORKFLOW.md](DEV_WORKFLOW.md) - Complete CI/CD pipeline guide
- [RESEARCH_REPORT.md](RESEARCH_REPORT.md) - Deep dive into Logseq DB, Tana, Schema.org
- [CLAUDE.md](CLAUDE.md) - Technical architecture reference

### Getting Help
- Open an [issue on GitHub](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
- Check the [Logseq Forums](https://discuss.logseq.com)
- Review the [project documentation](.)

[Back to top](#quick-start-guide)
