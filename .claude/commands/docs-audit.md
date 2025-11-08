# Documentation Audit Command

Comprehensive audit of all project documentation including coverage analysis, quality assessment, and actionable recommendations.

## What This Does

Performs a thorough audit of all documentation:
- **Coverage**: Checks what's documented vs. what needs documentation
- **Quality**: Validates accuracy, completeness, and formatting
- **Links**: Tests all internal and external links
- **Issues**: Identifies problems with specific locations
- **Recommendations**: Provides prioritized action items

## Usage

```bash
/docs-audit              # Full comprehensive audit
/docs-audit --quick      # Quick coverage check only
/docs-audit --coverage   # Coverage analysis only
/docs-audit --quality    # Quality metrics only
/docs-audit --links      # Link validation only
```

## Audit Process

### 1. Introduction
```
📚 Documentation Audit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Comprehensive audit of all project documentation.

Scope:
✓ Module READMEs (11 modules)
✓ User guides
✓ Developer guides
✓ Architecture docs
✓ Commands, skills, agents
✓ Main project files

Estimated time: 2-3 minutes

Start audit? [Y/n]: _____
```

### 2. Scanning Phase
```
🔍 Scanning documentation files...

Progress:
[████████░░░░░░░░░░░░] 40% - Modules
[████████████████░░░░] 80% - Guides
[████████████████████] 100% - Complete

Files scanned: 46 documentation files
```

### 3. Summary Report
```
📊 Documentation Audit Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2025-11-09
Overall Score: 87/100 (Good)

Status:
  ✅ Strengths: 12
  ⚠️  Warnings: 6
  ❌ Critical: 2

Coverage:
  Module READMEs: 10/11 (91%)
  Feature Documentation: 19/19 (100%)
  User Guides: 5 files
  Developer Guides: 3 files

Quality Metrics:
  Completeness: 88/100
  Accuracy: 92/100
  Formatting: 83/100
  Links: 85/100
  Consistency: 89/100
```

### 4. Coverage Analysis
```
📦 Module Documentation Coverage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌───────────────┬────────┬─────────┬────────┬─────────┐
│ Module        │ README │ Classes │ Props  │ Status  │
├───────────────┼────────┼─────────┼────────┼─────────┤
│ base          │ ✅     │ 2       │ 0      │ Good    │
│ person        │ ✅     │ 2       │ 36     │ Good    │
│ organization  │ ✅     │ 4       │ 15     │ Good    │
│ event         │ ✅     │ 17      │ 6      │ Good    │
│ creative-work │ ✅     │ 14      │ 7      │ Good    │
│ place         │ ✅     │ 2       │ 9      │ Good    │
│ product       │ ✅     │ 1       │ 2      │ Good    │
│ intangible    │ ✅     │ 9       │ 9      │ Good    │
│ action        │ ✅     │ 1       │ 1      │ Good    │
│ common        │ ✅     │ 0       │ 189    │ Good    │
│ misc          │ ❌     │ 82      │ 59     │ Missing │
└───────────────┴────────┴─────────┴────────┴─────────┘

Coverage: 91% (10/11 modules)

🎯 Feature Documentation Coverage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commands: 12/12 ✅
Skills: 6/6 ✅
Agents: 2/2 ✅
Git Hooks: 4/4 ✅
Scripts: 4/4 ✅

Total: 100% (28/28 features documented)
```

### 5. Issues Report
```
❌ Critical Issues (2)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Missing Module Documentation
   File: source/misc/README.md
   Impact: 82 classes (61% of total) undocumented
   Priority: High
   Effort: 3-4 hours
   Fix: Create comprehensive README
   Command: /update-docs → module → misc

2. Broken External Link
   File: docs/user-guide/installation.md:45
   Link: https://old-url.com/download
   Error: 404 Not Found
   Priority: High
   Effort: 2 minutes
   Fix: Update to current URL

⚠️  Warnings (6)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. Outdated Statistics
   File: CLAUDE_CODE_OPTIMIZATIONS.md
   Issue: Shows "16 features" but 19 exist
   Priority: Medium
   Effort: 15 minutes
   Fix: Update all statistics to current values

4. Inconsistent Terminology
   Files: docs/user-guide/*.md (3 files)
   Issue: "template variant" vs "preset" mixed
   Priority: Low
   Effort: 15 minutes
   Fix: Standardize on "preset"

5-8. [Additional warnings...]

✅ Strengths (12)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ 100% feature documentation coverage
✓ All commands well-documented
✓ Working code examples throughout
✓ Consistent formatting
✓ Good cross-referencing
✓ Clear organizational structure
✓ User-focused language
✓ Maintained documentation index
✓ Phase completion reports
✓ Comprehensive guides
✓ Up-to-date version info
✓ Quality validation system
```

### 6. Recommendations
```
💡 Priority Recommendations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

High Priority (Do Immediately):

1. Create misc/README.md
   Impact: Documents 61% of classes
   Effort: 3-4 hours
   Benefit: 100% module coverage
   Action: /update-docs → module → misc

2. Fix broken link
   Impact: Prevents user confusion
   Effort: 2 minutes
   Benefit: Working installation guide
   Action: Edit docs/user-guide/installation.md:45

Medium Priority (This Week):

3. Update statistics
   Impact: Accurate project status
   Effort: 30 minutes
   Benefit: Current documentation
   Action: Batch update all docs

4. Standardize terminology
   Impact: Consistency
   Effort: 15 minutes
   Benefit: Clearer communication

Low Priority (When Time Permits):

5. Add code language specifiers
6. Expand troubleshooting sections
7. Create glossary
```

### 7. Action Menu
```
❓ What would you like to do?

Quick Fixes (< 30 min):
  a) Fix all broken links (2 found)
  b) Update statistics (5 files)
  c) Standardize terminology
  d) All quick fixes

Major Tasks:
  e) Create misc/ module README
  f) Full documentation refresh
  g) Expand user guides

Reports:
  h) Save report to file
  i) Export as JSON
  j) Create GitHub issues

Other:
  k) Run specific check
  l) Show summary only
  m) Done

Your choice: _____
```

## Audit Modes

### Quick Audit
```
/docs-audit --quick

✓ Module coverage: 91% (10/11)
✓ Feature coverage: 100% (28/28)
✓ Critical issues: 2
✓ Overall score: 87/100

Run full audit: /docs-audit
```

### Coverage Only
```
/docs-audit --coverage

Module Coverage: 10/11 (91%)
Feature Coverage: 28/28 (100%)
Guide Coverage: 8 files

Missing:
- source/misc/README.md
```

### Quality Only
```
/docs-audit --quality

Quality Scores:
- Completeness: 88/100
- Accuracy: 92/100
- Formatting: 83/100
- Consistency: 89/100

Overall: 88/100 (Good)
```

### Links Only
```
/docs-audit --links

Checking all links...

Internal Links: 142 checked, 1 broken
External Links: 38 checked, 1 broken

Broken Links:
1. docs/README.md:15 → setup.md (not found)
2. docs/user-guide/installation.md:45 → old-url.com (404)
```

## Output Formats

### Console (Default)
Formatted output with colors and tables

### Markdown Report
```
/docs-audit --output=reports/audit-2025-11-09.md

✅ Saved to: reports/audit-2025-11-09.md
```

### JSON Export
```
/docs-audit --json=reports/audit.json

✅ Exported: reports/audit.json
```

## Validation Checklist

The audit validates:

**Module READMEs:**
- [ ] File exists
- [ ] Has overview
- [ ] Classes documented
- [ ] Properties listed
- [ ] Examples provided (min 2)
- [ ] Schema.org references
- [ ] Related modules linked

**Guides:**
- [ ] Prerequisites listed
- [ ] Instructions complete
- [ ] Examples working
- [ ] Troubleshooting present
- [ ] Cross-references correct

**Quality:**
- [ ] No broken links
- [ ] Code blocks have languages
- [ ] Examples tested
- [ ] Consistent terminology
- [ ] Proper headers
- [ ] Current statistics

## Tools Used

- **docs-validator** skill
- **Read**: Read documentation files
- **Grep**: Search patterns, extract links
- **Glob**: Find all documentation
- **Bash**: Test links, validate files

## Success Criteria

Audit complete when:
- [x] All files scanned
- [x] Coverage calculated
- [x] Quality assessed
- [x] Issues identified
- [x] Recommendations provided
- [x] Report generated

## Best Practices

1. **Run Monthly**: Regular quality checks
2. **Fix Critical First**: Priority-based fixes
3. **Track Progress**: Monitor improvements
4. **Save Reports**: Historical comparison
5. **Act on Findings**: Don't just audit, improve

---

**This command provides comprehensive documentation quality assessment with actionable recommendations for continuous improvement.**
