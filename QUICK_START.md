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

Download [logseq_db_Templates.edn](logseq_db_Templates.edn) from this repository.

### Step 2: Import into Logseq

1. Open your Logseq **Database Graph**
2. Go to: Settings (⚙️) → Import → **EDN to DB Graph**
3. Select the downloaded `logseq_db_Templates.edn` file
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

### Step 1: Install Logseq CLI

```bash
npm install -g @logseq/cli
```

Verify installation:
```bash
logseq --version
```

## Step 2: Configure Your Graph Path

### Option A: Set Environment Variable (Recommended)

**Windows (PowerShell):**
```powershell
# Temporary (current session)
$env:LOGSEQ_GRAPH_PATH = "C:\Users\YourName\Logseq\template-dev"

# Permanent
[System.Environment]::SetEnvironmentVariable('LOGSEQ_GRAPH_PATH', 'C:\Users\YourName\Logseq\template-dev', 'User')
```

**Mac/Linux (Bash):**
```bash
# Add to ~/.bashrc or ~/.zshrc
export LOGSEQ_GRAPH_PATH="$HOME/Logseq/template-dev"

# Reload
source ~/.bashrc
```

### Option B: Edit Export Script

Edit `scripts/export.sh` or `scripts/export.ps1` and change:
```bash
GRAPH_PATH="C:/Users/YourName/Logseq/template-dev"
```

To your actual path:
```bash
GRAPH_PATH="C:/Users/YourName/Logseq/your-graph-name"
```

## Step 3: Make Scripts Executable (Mac/Linux only)

```bash
chmod +x scripts/export.sh
chmod +x scripts/validate.sh
```

## Step 4: Run Your First Export

**Windows:**
```powershell
.\scripts\export.ps1
```

**Mac/Linux:**
```bash
./scripts/export.sh
```

You should see:
```
🚀 Exporting Logseq Template Graph...
📦 Exporting minimal template...
✅ Minimal template exported
📦 Exporting full template...
✅ Full template exported
✅ Export complete!
```

## Step 5: Review Changes

```bash
git diff logseq_db_Templates.edn
```

## Step 6: Commit and Push

The script will prompt you, or manually:

```bash
git add logseq_db_Templates*.edn
git commit -m "feat: add new classes and properties"
git push
```

---

## Daily Workflow

```bash
# 1. Work in Logseq on your template
# ... make changes ...

# 2. Export
./scripts/export.sh    # or .\scripts\export.ps1

# 3. Review and commit
# (script will prompt you)
```

---

## Troubleshooting

### "logseq: command not found"

Install the CLI:
```bash
npm install -g @logseq/cli
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
