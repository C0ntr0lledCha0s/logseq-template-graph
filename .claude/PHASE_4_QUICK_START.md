# Phase 4 Quick Start Guide

Welcome to the Phase 4 features! This guide will help you start using the new skills and commands immediately.

## What's New in Phase 4?

### 🎨 2 New Commands
- `/create-preset` - Build custom template variants interactively
- `/performance` - Monitor build performance and project health

### 🧠 3 New Skills
- **edn-analyzer** - Deep template analysis
- **commit-helper** - Conventional commit assistance
- **module-health** - Architecture health assessment

---

## Quick Start: 5-Minute Tour

### 1. Create a Custom Preset (2 min)

```
You: /create-preset

Follow the prompts to:
- Name your preset (e.g., "my-workflow")
- Select modules (person, organization, event, etc.)
- Build it automatically
- Get a ready-to-import template!
```

**Result:** Custom template variant tailored to your needs

---

### 2. Check Performance (1 min)

```
You: /performance

Get instant insights:
- Current build times
- Template growth trends
- Workflow efficiency
- Health score
```

**Result:** Data-driven understanding of your project

---

### 3. Use Skills (2 min)

Try these natural language requests:

**Analyze Templates:**
```
You: "Analyze the full template and show statistics"

Claude activates edn-analyzer skill and shows:
- Class and property counts
- Type distributions
- Orphaned items
- Health metrics
```

**Get Commit Help:**
```
You: "Suggest a commit message for my changes"

Claude activates commit-helper skill and:
- Analyzes your staged changes
- Suggests conventional commit format
- Provides copy-pasteable command
```

**Check Architecture:**
```
You: "Check module health"

Claude activates module-health skill and:
- Scores each module (0-100)
- Identifies issues (bloated modules, etc.)
- Suggests improvements
```

---

## Detailed Feature Guides

### `/create-preset` Command

**When to use:**
- You need a template for a specific workflow
- Existing presets (full, crm, research) don't fit
- You want to minimize template size
- You're sharing templates with specific audiences

**Example:**
```
Scenario: You're a student tracking courses and assignments

You: /create-preset

Name: student-life
Description: Course and assignment tracking
Modules: base, common, person, organization, creative-work, event

Result: Build/logseq_db_Templates_student-life.edn
- ~3K lines
- ~20 classes
- ~245 properties
- Perfect for students!
```

**Features:**
- ✅ Interactive guided workflow
- ✅ Validates all inputs
- ✅ Shows size estimates
- ✅ Builds immediately
- ✅ Generates documentation
- ✅ Can add npm scripts

---

### `/performance` Command

**When to use:**
- Monthly project reviews
- Before releases
- Tracking growth trends
- Identifying bottlenecks
- Demonstrating progress

**Options:**
```bash
/performance              # Quick check
/performance --full       # Comprehensive report
/performance --builds     # Build metrics only
/performance --trend      # Trend analysis
```

**What you get:**
- Build times per variant
- Template size growth (30/90 days)
- Workflow time savings
- CI/CD success rates
- Development velocity
- Quality metrics
- Health score (0-100)

**Example output:**
```
⚡ Build Performance Report

Current Build Times:
  full: 2.3s (497 KB)
  crm: 0.8s (298 KB)
  research: 0.9s (317 KB)

Template Growth (30 days):
  +15 classes (+2.4%)
  +28 properties (+2.8%)

Time Saved: 67% faster workflow

Health Score: 87/100 ✅
```

---

### EDN Analyzer Skill

**Activates when you ask:**
- "Analyze the template"
- "Find orphaned classes"
- "Show property distribution"
- "Compare variants"
- "Check for duplicates"

**What it does:**
- Counts classes and properties
- Identifies class hierarchies
- Finds orphaned items
- Analyzes distributions
- Compares templates
- Suggests fixes

**Example:**
```
You: "Find orphaned classes in the full template"

Claude (edn-analyzer):
🔍 Analyzing build/logseq_db_Templates_full.edn...

⚠️  Orphaned Classes Found (2):

1. Schedule (in intangible/)
   Line 847
   → Suggestion: Add parent :user.class/Intangible

2. ProductCategory (in product/)
   Line 1203
   → Suggestion: Add parent :user.class/DefinedTerm

Would you like me to fix these?
```

---

### Commit Helper Skill

**Activates when you ask:**
- "Suggest a commit message"
- "Help me commit"
- "Is this commit valid?"
- "What type should this be?"

**What it does:**
- Analyzes staged changes
- Determines commit type (feat, fix, docs, etc.)
- Selects appropriate scope
- Generates conventional format
- Validates message format
- Checks for common mistakes

**Example:**
```
You: "Suggest a commit message"

Claude (commit-helper):
✨ Suggested Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feat(classes): add Recipe class with cooking properties

- Added Recipe class to creative-work module
- Properties: recipeIngredient, cookTime, recipeInstructions
- Parent class: CreativeWork
- Updated module README

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ To commit:
git commit -m "$(cat <<'EOF'
feat(classes): add Recipe class with cooking properties

- Added Recipe class to creative-work module
- Properties: recipeIngredient, cookTime, recipeInstructions
- Parent class: CreativeWork
- Updated module README
EOF
)"
```

---

### Module Health Skill

**Activates when you ask:**
- "Check module health"
- "Is misc/ too big?"
- "Show module statistics"
- "How should I reorganize?"

**What it does:**
- Calculates health scores (0-100)
- Identifies bloated modules
- Finds empty modules
- Suggests reorganization
- Tracks improvements

**Example:**
```
You: "Check module health"

Claude (module-health):
🏥 Module Health Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Health: 73/100 (Good)

Module Scores:
  person:       95/100 ✅
  organization: 90/100 ✅
  event:        88/100 ✅
  misc:         35/100 ❌ BLOATED

❌ Critical Issue:
  misc/ has 82 classes (61% of total)

💡 Recommendation:
  Split misc/ into 5 focused modules:
  - communication/ (10 classes)
  - medical/ (15 classes)
  - financial/ (12 classes)
  - education/ (8 classes)
  - misc/ (37 remaining)

  Estimated effort: 2-3 hours
  Health score after: 73 → 85
```

---

## Combining Features

Phase 4 features work great together:

### Workflow 1: Create and Optimize Preset
```
1. /create-preset → Create "sales-pipeline"
2. /performance --builds → Check build time
3. "Check module health" → Verify balance
4. Iterate and improve
```

### Workflow 2: Feature Development with Quality
```
1. /new-class → Add new class
2. "Check module health" → See impact
3. Export and build
4. "Suggest a commit message" → Quality commit
5. /performance → Track metrics
```

### Workflow 3: Monthly Review
```
1. /performance --full → Generate report
2. "Analyze the full template" → Deep dive
3. "Check module health" → Architecture review
4. Document findings
5. Plan improvements
```

---

## Best Practices

### Using Commands
- Use `/create-preset` for custom variants
- Run `/performance` monthly
- Check performance before releases
- Export reports for team reviews

### Using Skills
- Ask natural questions
- Skills activate automatically
- Combine multiple skills in workflow
- Provide context (file paths, etc.)
- Ask follow-up questions

### Combining Both
- Commands for actions (build, monitor)
- Skills for insights (analyze, suggest)
- Use together for complete workflow
- Iterate based on findings

---

## Troubleshooting

### Skills Not Activating?
- Be specific: "Analyze build/logseq_db_Templates_full.edn"
- Use keywords: "check health", "suggest commit", "analyze template"
- Try explicit: "Use edn-analyzer skill to..."

### Preset Build Failed?
- Check module names are valid
- Ensure Babashka is installed (`bb --version`)
- Verify source/ directory exists
- Check preset EDN syntax

### Performance Command Slow?
- Use quick check: `/performance` (no flags)
- Skip full report unless needed
- Cache results for multiple views
- Export to file for sharing

---

## What's Next?

### Try These Now
1. ✅ Create a custom preset for your workflow
2. ✅ Run performance check
3. ✅ Ask for a commit message suggestion
4. ✅ Check module health

### Coming in Phase 3
- Git hooks (post-commit, pre-push)
- `/diagnose` command
- Drift detection agent
- Automated quality gates

### Provide Feedback
- Which features are most useful?
- What's confusing or unclear?
- What's missing?
- How can we improve?

---

## Resources

### Documentation
- [Phase 4 Complete Report](.claude/PHASE_4_COMPLETE.md)
- [Skills README](.claude/skills/README.md)
- [Create Preset Command](.claude/commands/create-preset.md)
- [Performance Command](.claude/commands/performance.md)

### Main Docs
- [CLAUDE_CODE_OPTIMIZATIONS.md](../CLAUDE_CODE_OPTIMIZATIONS.md)
- [CLAUDE.md](../CLAUDE.md)

### External
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## Quick Reference

### Commands
```bash
/create-preset           # Interactive preset builder
/performance             # Quick performance check
/performance --full      # Comprehensive report
/performance --trend     # Trend analysis
```

### Skill Triggers
```
"Analyze the template"              → edn-analyzer
"Suggest a commit message"          → commit-helper
"Check module health"                → module-health
"Find orphaned classes"              → edn-analyzer
"Compare full and CRM templates"    → edn-analyzer
"Is misc/ module too big?"          → module-health
```

---

**🎉 You're ready to use Phase 4 features! Start with `/create-preset` or `/performance` and explore from there.**

**Questions?** Just ask Claude - the skills will guide you!
