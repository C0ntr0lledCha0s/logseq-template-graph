# Validate Development Environment

Comprehensive environment validation for Logseq Template Graph development.

Checks all dependencies, paths, and configurations needed for development.

## What This Does

Validates:
1. ✅ Node.js version (>= 16 required)
2. ✅ npm version
3. ✅ @logseq/cli installed
4. ✅ Babashka installed (for modular workflow)
5. ✅ Git configured
6. ✅ Git hooks installed
7. ✅ Conventional commits validation working
8. ✅ LOGSEQ_GRAPH_PATH environment variable
9. ✅ Logseq graph exists at path
10. ✅ Source modules present (11 modules)
11. ✅ Build directory writable
12. ✅ Scripts executable

## Usage

```
/validate-env
```

## Output

### All Checks Pass
```
🔍 Environment Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Node.js & npm
  ✅ Node.js v20.10.0 (>= 16 required)
  ✅ npm v10.2.3

Logseq CLI
  ✅ @logseq/cli installed (v0.3.2)
  ✅ logseq command available

Babashka (Modular Workflow)
  ✅ Babashka v1.3.186 installed
  ✅ bb command available
  ✅ Scripts validated:
      - scripts/split.clj ✓
      - scripts/build.clj ✓

Git Configuration
  ✅ Git v2.43.0 installed
  ✅ User name configured: John Doe
  ✅ User email configured: john@example.com
  ✅ Git hooks installed
  ✅ Conventional commits hook active

Environment Variables
  ✅ LOGSEQ_GRAPH_PATH set
      → C:/Users/mcnei/Logseq/template-dev
  ✅ Graph directory exists
  ✅ Graph is a Logseq DB graph (logseq/ folder found)

Project Structure
  ✅ Source modules present (11/11):
      - source/base/ ✓
      - source/person/ ✓
      - source/organization/ ✓
      - source/event/ ✓
      - source/creative-work/ ✓
      - source/place/ ✓
      - source/product/ ✓
      - source/intangible/ ✓
      - source/action/ ✓
      - source/health/ ✓
      - source/misc/ ✓
      - source/common/ ✓
  ✅ Build directory exists and writable
  ✅ Archive directory exists

Scripts
  ✅ export.sh executable
  ✅ export.ps1 present
  ✅ validate.sh executable
  ✅ analyze.sh executable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 All checks passed! Environment ready.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
  1. Run: /test-workflow (test complete workflow)
  2. Run: /new-class (add new class)
  3. See: docs/developer-guide/ci-cd-pipeline.md
```

### Some Checks Fail
```
🔍 Environment Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Node.js & npm
  ✅ Node.js v20.10.0 (>= 16 required)
  ✅ npm v10.2.3

Logseq CLI
  ❌ @logseq/cli NOT installed

Babashka (Modular Workflow)
  ❌ Babashka NOT installed

Git Configuration
  ✅ Git v2.43.0 installed
  ⚠️  Git hooks NOT installed
  ⚠️  Conventional commits NOT configured

Environment Variables
  ❌ LOGSEQ_GRAPH_PATH NOT set

Project Structure
  ✅ Source modules present (11/11)
  ✅ Build directory writable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  3 errors, 2 warnings detected
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Would you like help fixing these issues? [Y/n]:
```

## Fixing Issues

### Missing @logseq/cli
```
❌ @logseq/cli not installed

💡 Fix:
  npm install -g @logseq/cli

After installation, verify:
  logseq --version

Purpose:
  Required for exporting templates from Logseq graphs
```

### Missing Babashka
```
❌ Babashka not installed

💡 Fix (Mac/Linux):
  # Using Homebrew
  brew install borkdude/brew/babashka

  # Or using install script
  curl -s https://raw.githubusercontent.com/babashka/babashka/master/install | bash

💡 Fix (Windows):
  # Using Scoop
  scoop install babashka

  # Or download from:
  https://github.com/babashka/babashka/releases

After installation, verify:
  bb --version

Purpose:
  Required for modular workflow (split/build scripts)
  Optional if using monolithic workflow only
```

### Missing LOGSEQ_GRAPH_PATH
```
❌ LOGSEQ_GRAPH_PATH environment variable not set

💡 Fix (Mac/Linux - bash/zsh):
  # Add to ~/.bashrc or ~/.zshrc
  export LOGSEQ_GRAPH_PATH="/path/to/your/logseq/graph"

  # Apply changes
  source ~/.bashrc  # or ~/.zshrc

💡 Fix (Windows - PowerShell):
  # Set for current session
  $env:LOGSEQ_GRAPH_PATH = "C:/Path/To/Your/Graph"

  # Set permanently (requires admin)
  [System.Environment]::SetEnvironmentVariable(
    'LOGSEQ_GRAPH_PATH',
    'C:/Path/To/Your/Graph',
    'User'
  )

💡 Alternative:
  Edit scripts/export.sh and set GRAPH_PATH directly:
  GRAPH_PATH="C:/Users/YourName/Logseq/template-dev"

After setting, verify:
  echo $LOGSEQ_GRAPH_PATH  # Mac/Linux
  echo $env:LOGSEQ_GRAPH_PATH  # Windows

Purpose:
  Tells export scripts where your Logseq graph is located
```

### Git Hooks Not Installed
```
⚠️  Git hooks not installed

💡 Fix:
  npm run setup

This installs:
  - pre-commit hook (validates commit messages)
  - commit-msg hook (enforces conventional commits)

Verify:
  ls -la .git/hooks/  # Should see pre-commit, commit-msg

Purpose:
  Validates conventional commit messages
  Prevents invalid commits
```

### Graph Directory Doesn't Exist
```
❌ Graph directory not found at: C:/Users/mcnei/Logseq/template-dev

💡 Options:
  1. Create the graph in Logseq first
  2. Update LOGSEQ_GRAPH_PATH to correct location
  3. Use existing graph path

Verify graph location:
  - Open Logseq
  - Settings → General → Graph location
  - Copy that path to LOGSEQ_GRAPH_PATH
```

### Old Node.js Version
```
❌ Node.js v14.20.0 (< 16 required)

💡 Fix:
  # Update Node.js to v16 or higher

  # Using nvm (recommended)
  nvm install 20
  nvm use 20

  # Or download from:
  https://nodejs.org/

After updating, verify:
  node --version  # Should show v16+ or v20+

Purpose:
  Modern JavaScript features
  @logseq/cli requires Node 16+
```

## Interactive Fix Mode

When issues detected, tool offers to fix:

```
Would you like help fixing these issues? [Y/n]: y

🔧 Fixing Issues
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Issue 1: @logseq/cli not installed
  Run: npm install -g @logseq/cli
  [Execute now? Y/n]: y

  ✓ Installing @logseq/cli...
  ✓ Installed successfully!

Issue 2: Git hooks not installed
  Run: npm run setup
  [Execute now? Y/n]: y

  ✓ Running npm run setup...
  ✓ Hooks installed!

Issue 3: LOGSEQ_GRAPH_PATH not set
  Cannot auto-fix (requires manual configuration)

  Please set manually:
    export LOGSEQ_GRAPH_PATH="/path/to/graph"

  Or edit scripts/export.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 2 issues fixed
⚠️  1 issue requires manual action
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Re-run validation? [Y/n]:
```

## Detailed Checks

### 1. Node.js Version
```bash
node --version
```
- Minimum: v16.0.0
- Recommended: v20.x (LTS)
- Purpose: Run npm scripts, @logseq/cli

### 2. npm Version
```bash
npm --version
```
- Minimum: v7.0.0
- Recommended: v10.x
- Purpose: Package management, scripts

### 3. Logseq CLI
```bash
logseq --version
```
- Required for export workflow
- Checks: command exists, version compatible

### 4. Babashka
```bash
bb --version
```
- Required for modular workflow
- Optional for monolithic workflow
- Minimum: v1.0.0

### 5. Git Configuration
```bash
git config user.name
git config user.email
```
- Checks: User identity configured
- Purpose: Commit attribution

### 6. Git Hooks
```bash
ls -la .git/hooks/pre-commit
ls -la .git/hooks/commit-msg
```
- Checks: Hooks exist and executable
- Purpose: Conventional commit validation

### 7. Environment Variables
```bash
echo $LOGSEQ_GRAPH_PATH
```
- Checks: Variable set and valid path
- Purpose: Export script knows where graph is

### 8. Graph Directory
```bash
ls "$LOGSEQ_GRAPH_PATH/logseq/"
```
- Checks: Directory exists, contains Logseq files
- Purpose: Verify graph is valid

### 9. Source Modules
```bash
ls source/*/
```
- Checks: All 11 modules present
- Expected: base, person, organization, event, creative-work, place, product, intangible, action, health, misc, common

### 10. Build Directory
```bash
mkdir -p build/ && touch build/.test
```
- Checks: Directory writable
- Purpose: Build artifacts destination

### 11. Scripts
```bash
test -x scripts/export.sh
test -f scripts/export.ps1
```
- Checks: Scripts exist and executable
- Purpose: Core workflow automation

## When to Run This Command

### Always Run When:
- Setting up new development machine
- Onboarding new contributor
- After system updates (Node.js, etc.)
- Troubleshooting build issues
- Before first contribution

### Good Practice:
- Run monthly to catch environment drift
- Run after long break from project
- Include in onboarding checklist

## Integration with Other Commands

This command is automatically called by:
- (Planned) `/test-workflow` - Before running tests
- (Planned) `/release-prep` - Before releasing

You can also call it standalone anytime.

## Time Savings

**Manual validation:** ~15-20 minutes
- Check each tool manually (5 min)
- Verify paths and configs (5 min)
- Test each command (5 min)
- Troubleshoot issues (5-10 min)

**With /validate-env:** ~2-3 minutes
- Automated checks (1 min)
- Review results (1 min)
- Fix issues (guided)

**Saves:** 12-17 minutes per validation

## Related Commands

- `/test-workflow` - Test complete development workflow
- `/release-prep` - Prepare release (also validates)

## Learn More

- [QUICK_START.md](../../QUICK_START.md) - Setup guide
- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)
- [Modular Quickstart](../../docs/modular/quickstart.md)
