# Self-Improvement Skill - Examples

This document shows real-world examples of the self-improvement skill in action, analyzing errors, optimizing documentation, and creating feedback loops.

---

## Example 1: PowerShell Emoji Corruption Analysis

### User Request
"The pre-push hook failed with a parse error. Was that caused by a Claude Code instruction? Can I make an update to improve the feedback loop?"

### Skill Activation
The self-improvement skill activates to analyze the PowerShell error and suggest improvements.

### Analysis Process

#### Step 1: Capture Error Context
```bash
# Error message
The string is missing the terminator: ".

# Location
.git-hooks/pre-push.ps1:92

# Tool used
Edit tool (Claude Code modified the file)

# What was changed
Commit ae642ba - Added error messages with emojis
```

#### Step 2: Identify Root Cause

**Category:** ENCODING

**Explanation:**
The Edit tool replaced emoji `❌` with corrupted bytes `M-bM-^]M-^L` due to character encoding issues when modifying PowerShell scripts.

**Evidence:**
```powershell
# Before (intended)
Write-Host "❌ Error message"

# After Edit tool (actual)
Write-Host "M-bM-^]M-^L Error message"  # Corrupted!
```

#### Step 3: Determine Preventability

**Preventable?** Yes

**Root Analysis:**
- Claude Code was not aware that PowerShell scripts have emoji encoding issues
- CLAUDE.md lacked guidance about PowerShell character handling
- No existing pattern documented for this issue

#### Step 4: Generate Learning

**Error Pattern Catalog Entry:**
```markdown
#### Pattern 1: PowerShell Emoji Corruption
**Error:** Emojis in `.ps1` files become garbled (`❌` → `M-bM-^]M-^L`)
**Root Cause:** Character encoding during Edit tool usage
**Solution:** Use ASCII alternatives (`[ERROR]`, `[SUCCESS]`)
**Prevention:** Add PowerShell guidelines to CLAUDE.md
**Learning:** Never use emojis in PowerShell scripts
**Commits:** ae642ba (introduced), 7e5d981 (fixed)
```

**CLAUDE.md Addition:**
```markdown
## PowerShell Script Guidelines

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

| Emoji | ASCII Alternative | Use Case |
|-------|-------------------|----------|
| ❌ | `[ERROR]` or `[X]` | Errors, failures |
| ✅ | `[SUCCESS]` or `[OK]` | Success, passed checks |
| ⚠️ | `[WARNING]` or `[!]` | Warnings, attention needed |
```

#### Step 5: Implement Improvement

**Actions Taken:**
1. ✅ Fixed `.git-hooks/pre-push.ps1` - Replaced all emojis with ASCII
2. ✅ Added PowerShell guidelines to CLAUDE.md (lines 208-276)
3. ✅ Documented pattern in self-improvement skill
4. ✅ Created ASCII alternatives table for reference

**Commit:**
```
fix(workflow): resolve PowerShell emoji corruption and add scripting guidelines

Fixed pre-push.ps1 emoji corruption and added comprehensive PowerShell
scripting guidelines to CLAUDE.md to prevent future encoding issues.
```

**Impact:**
- ✅ Error resolved
- ✅ Prevention documented
- ✅ Future occurrences unlikely
- ✅ Team has clear guidance

---

## Example 2: CLAUDE.md Health Check

### User Request
"Analyze if the CLAUDE.md file is getting too bloated and whether it should point to other files for further knowledge."

### Skill Activation
Self-improvement skill activates to assess CLAUDE.md structure and health.

### Health Check Report

```markdown
# CLAUDE.md Health Check

**Date:** 2025-11-09
**Status:** 🟡 Needs Attention (Approaching extraction threshold)

## Metrics
- **Size:** 493 lines (target: <600) - **82% of threshold**
- **Sections:** 11 main sections
- **Avg Section Length:** 45 lines (healthy)
- **Links:** 15 internal, 8 external (good balance)
- **Last Updated:** November 2025 (current)

## Issues Found

### 🟡 Warnings
1. **PowerShell Script Guidelines** (lines 208-276)
   - Size: 68 lines
   - Status: Growing (recently added)
   - Action: Monitor, consider extracting if >100 lines

2. **Git Workflow** (lines 279-460)
   - Size: 181 lines
   - Status: Large but essential
   - Action: Consider splitting into multiple guides

3. **Total approaching 600 lines**
   - Current: 493 lines
   - Headroom: 107 lines (22%)
   - Action: Plan extractions proactively

### 🟢 Healthy
- Project overview - concise
- Quick navigation - well-structured
- EDN format - clear examples
- Key concepts - brief and linked
- Documentation section - good cross-references

## Extraction Recommendations

### Soon (Next 100 lines added)
1. **Git Workflow → .claude/guides/git-workflow.md**
   - **Current Size:** 181 lines (lines 279-460)
   - **Extract to:** `.claude/guides/workflows/git-workflow.md`
   - **Reason:** Self-contained, frequently referenced
   - **Effort:** 1 hour
   - **Keep in CLAUDE.md:** Brief summary + link

2. **PowerShell Guidelines → .claude/guides/powershell.md**
   - **Current Size:** 68 lines (lines 208-276)
   - **Extract to:** `.claude/guides/platform/powershell.md`
   - **Reason:** Platform-specific, will grow with learnings
   - **Effort:** 30 minutes
   - **Keep in CLAUDE.md:** "See .claude/guides/platform/powershell.md"

### Future (When sections >100 lines)
3. **Development Workflow**
   - Currently distributed across document
   - Extract to: `.claude/guides/workflows/development.md`
   - Include: modular workflow, export process, build variants

## Structure Improvements

### Current Structure (Healthy)
```
CLAUDE.md (493 lines)
├─ Project Overview ✅
├─ Quick File Navigation ✅
├─ Development Workflow ✅
├─ EDN File Format ✅
├─ Key Concepts ✅
├─ Important Constraints ✅
├─ Common Development Tasks ✅
├─ PowerShell Script Guidelines ⚠️ (monitor)
├─ Git Workflow ⚠️ (large but essential)
├─ Quick Reference Links ✅
└─ Related Resources ✅
```

### Recommended Future Structure

```
CLAUDE.md (<400 lines)
├─ Project overview
├─ Quick navigation
├─ Core concepts (brief)
├─ Essential constraints
├─ Quick reference links → detailed guides
└─ Platform notes → .claude/guides/platform/

.claude/guides/
├─ platform/
│   ├─ powershell.md ⭐ (extract from CLAUDE.md)
│   ├─ bash.md
│   └─ cross-platform.md
├─ workflows/
│   ├─ git-workflow.md ⭐ (extract from CLAUDE.md)
│   ├─ development-workflow.md
│   └─ release-workflow.md
├─ tools/
│   ├─ edit-tool-patterns.md
│   ├─ bash-best-practices.md
│   └─ write-guidelines.md
└─ troubleshooting/
    ├─ common-errors.md
    ├─ encoding-issues.md
    └─ build-failures.md
```

## Action Plan

### Immediate (Not urgent yet)
- [x] Monitor CLAUDE.md growth
- [x] Document extraction plan
- [ ] Wait until 550+ lines or section >100 lines

### Next Extraction Trigger
When either occurs:
1. File reaches 550 lines
2. Any section exceeds 100 lines
3. New platform-specific content needed

Then extract Git Workflow first (largest section).

### Proactive Preparation
1. Create `.claude/guides/` folder structure
2. Draft extracted documents
3. Update CLAUDE.md with links
4. Test navigation
5. Commit extraction

## Estimated Effort
- **Git Workflow extraction:** 1 hour
- **PowerShell extraction:** 30 minutes
- **Total first extraction:** 1.5 hours

## Recommendation

**Status:** 🟡 Plan extraction, but not urgent yet

**Current:** CLAUDE.md is healthy and well-structured. At 493 lines with good organization, it's below the 600-line threshold.

**Action:** Monitor growth and plan proactive extraction when:
- Adding 50+ more lines
- Any section grows >100 lines
- Team finds navigation difficult

**Next Review:** After next major documentation addition
```

---

## Example 3: Repeated Quote Escaping Analysis

### User Request
(After multiple PowerShell quote escaping errors in commits 099a4a8 and b4fc136)

"Why do we keep having PowerShell quoting issues? What pattern should we document?"

### Skill Activation
Self-improvement skill analyzes recurring error pattern.

### Pattern Analysis

#### Error Frequency
```bash
git log --all --grep="PowerShell\|quote\|escap" --oneline

b4fc136 fix(workflow): resolve PowerShell quote escaping in git hooks
099a4a8 fix(workflow): rewrite post-commit.ps1 to resolve all quote issues
```

**Frequency:** 2 occurrences in 1 week
**Severity:** Major (blocks git hooks)
**Category:** SYNTAX

#### Root Cause Analysis

**Pattern:** PowerShell interprets special characters differently in single vs double quotes

**Examples of Failures:**

```powershell
# FAIL: Pipe interpreted as command separator
$pattern = "feat|fix|docs"  # PowerShell sees: $pattern = "feat" | "fix" | "docs"

# FAIL: Parentheses cause parsing errors
Write-Host "Error (details)" # PowerShell tries to execute subexpression

# FAIL: Variables not expanded in single quotes
Write-Host 'Commit: $commitMsg'  # Prints literal "$commitMsg"
```

#### Learning Extraction

**Rule:** Single quotes for literals, double quotes for variable expansion

**Pattern Catalog Entry:**
```markdown
#### Pattern 2: PowerShell Quote Escaping
**Error:** Pipes `|` and parentheses `()` cause parse errors in double-quoted strings
**Root Cause:** PowerShell interprets special characters in double quotes
**Solution:** Use single quotes for literal strings, double quotes only for variables
**Prevention:** Added string quoting rules to CLAUDE.md
**Learning:** Single quotes = literal, double quotes = interpolation
**Commits:** 099a4a8, b4fc136 (fixes)
```

**CLAUDE.md Addition:**
```markdown
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
```

#### Impact Assessment

**Before Documentation:**
- 2 errors in 1 week
- 1-2 hours debugging each
- Total: 2-4 hours lost

**After Documentation:**
- Expected: 0 future errors
- Prevention: Claude Code checks CLAUDE.md
- Savings: 10-20 hours/year

**ROI:** High - simple guideline prevents recurring errors

---

## Example 4: Proactive Skill Enhancement

### User Request
"The github-issues skill is great, but could it learn from past validation mistakes?"

### Skill Activation
Self-improvement skill analyzes github-issues skill for enhancement opportunities.

### Enhancement Analysis

#### Current github-issues Skill

**Strengths:**
- Comprehensive validation workflow
- Relationship tracking
- Response templates

**Potential Improvements:**
1. Learn from past false positives
2. Track validation accuracy
3. Auto-update response templates
4. Build common pattern library

#### Proposed Enhancements

**1. Validation Accuracy Tracking**

Add to github-issues skill:
```markdown
## Validation Metrics (Self-Learning)

Track validation accuracy over time:

### After Each Validation
1. Record validation result (valid/invalid/duplicate)
2. Record search commands used
3. Record time to validation
4. Record confidence level

### Weekly Review
1. Check false positives (said invalid, was valid)
2. Check false negatives (said valid, was invalid)
3. Analyze search patterns that missed results
4. Update search strategy

### Pattern Library
Common search patterns that work:
- `grep -r "ClassName" source/` - Find classes
- `git log --all --grep="feature" --oneline` - Find past work
- `gh issue list --state all --search "keyword"` - Find duplicates

Common mistakes to avoid:
- Searching only current branch (use --all)
- Case-sensitive grep (use -i for class names)
- Missing closed issues (use --state all)
```

**2. Response Template Improvement**

Add learning from actual responses:
```markdown
## Response Template Evolution

### Template Performance Tracking
- Track which templates get positive feedback
- Note which templates cause confusion
- Identify missing information requests

### Auto-Update Based on Patterns
If reporters frequently ask:
- "Where is this documented?" → Add docs link to template
- "When will this be fixed?" → Add timeline section
- "Is this related to #X?" → Improve relationship detection
```

**3. Integration with self-improvement Skill**

```markdown
## Self-Improvement Integration

After each issue validation:
1. Log to `.claude/data/issue-validations.jsonl`
2. Weekly: Analyze validation patterns
3. Monthly: Update github-issues skill
4. Quarterly: Report metrics and improvements

Example log entry:
{
  "issue": 123,
  "type": "bug",
  "validation": "invalid - already fixed",
  "search_commands": ["grep -r Recipe", "git log --grep Recipe"],
  "time_spent": "5 min",
  "confidence": "high",
  "outcome": "closed with fix reference"
}
```

#### Implementation Plan

1. **Phase 1:** Add metrics tracking to github-issues
2. **Phase 2:** Create weekly analysis workflow
3. **Phase 3:** Auto-generate improvement suggestions
4. **Phase 4:** Update skill based on learnings

**Effort:** 2-3 hours
**Impact:** Continuously improving validation accuracy

---

## Example 5: Documentation Drift Detection

### User Request
"Check if CLAUDE.md has any outdated information compared to actual project state."

### Skill Activation
Self-improvement skill performs documentation drift analysis.

### Drift Analysis Process

#### Step 1: Check File References

```bash
# Files mentioned in CLAUDE.md
grep -o '\`[^`]*\.edn\`' CLAUDE.md
grep -o '\`[^`]*\.md\`' CLAUDE.md
grep -o '\`[^`]*\.sh\`' CLAUDE.md

# Check if they exist
find . -name "schema-library.edn"
find . -name "build.clj"
```

**Result:**
✅ All referenced files exist

#### Step 2: Check Metrics Accuracy

```bash
# CLAUDE.md claims:
"632 classes"
"1,033 properties"
"15,422 lines in main template file"

# Actual:
wc -l logseq_db_Templates.edn  # Verify line count
grep -c ':schema.class/' src/**/*.edn  # Count classes
grep -c ':schema.property/' src/**/*.edn  # Count properties
```

**Result:**
✅ Metrics accurate (as of last update)
⚠️ Date stamp shows "November 2025" - need to update after changes

#### Step 3: Check Workflow Accuracy

**CLAUDE.md describes:**
```markdown
bb test && bb build && bb validate  # Edit source/ then build
```

**Actual behavior:**
```bash
cat package.json | grep export
# "export": "node scripts/check-deps.js && ..."
```

**Result:**
✅ Workflow description matches implementation

#### Step 4: Check for New Features Not Documented

```bash
# Check recent commits for new features
git log --since="1 month ago" --grep="feat" --oneline

97ca139 feat(workflow): add github-issues management skill
dc59569 feat(workflow): add schema-research skill
...
```

**Findings:**
⚠️ New skills added but not mentioned in CLAUDE.md Quick Reference

#### Drift Report

```markdown
# Documentation Drift Analysis

**Date:** 2025-11-09
**Status:** 🟡 Minor drift detected

## Files & References
✅ All referenced files exist
✅ Links work correctly
✅ File paths accurate

## Metrics
✅ Class count accurate (632)
✅ Property count accurate (1,033)
✅ Line count accurate (15,422)
⚠️ Update date needs refresh after next change

## Workflows
✅ Export workflow accurate
✅ Build process accurate
✅ Release process accurate

## Missing Documentation

### New Skills Not Mentioned
1. **github-issues** (added commit 97ca139)
   - Should mention in Quick Reference
   - Should link from Git Workflow section

2. **schema-research** (added commit dc59569)
   - Should mention in Common Development Tasks
   - Should link from documentation structure

### Recommendation
Add "Skills" section to Quick Reference:

```markdown
### For Specialized Tasks
- [.claude/skills/schema-research/](.claude/skills/schema-research/) - Schema.org research before adding classes
- [.claude/skills/github-issues/](.claude/skills/github-issues/) - Intelligent issue management
- [.claude/skills/edn-analyzer/](.claude/skills/edn-analyzer/) - Deep template analysis
- [.claude/skills/commit-helper/](.claude/skills/commit-helper/) - Conventional commit assistance
```

## Action Items
1. [ ] Add Skills section to Quick Reference
2. [ ] Update "Last Updated" date after next change
3. [ ] Consider auto-generating metrics (class/property counts)

## Drift Score
**2/10** - Minor, easily fixed
```

---

## Example 6: Learning from Successful Pattern

### User Request
"The schema-research skill has been really helpful. Can we extract patterns that made it successful?"

### Skill Activation
Self-improvement skill analyzes successful patterns for reuse.

### Success Pattern Analysis

#### What Made schema-research Successful?

**1. Clear Workflow Integration**
```markdown
✅ Integrates with other skills
✅ Fits naturally into development workflow
✅ Reduces context switching
```

**2. Comprehensive Reference Data**
```markdown
✅ Type mapping tables
✅ Cardinality guidelines
✅ Module placement heuristics
✅ Real-world examples
```

**3. Actionable Output**
```markdown
✅ Not just information - gives next steps
✅ Provides file locations
✅ Suggests commit messages
✅ Estimates effort
```

**4. Supporting Tools**
```markdown
✅ Scripts for quick lookup (schema-lookup.sh/ps1)
✅ Cross-platform support
✅ Browser integration
```

#### Extractable Patterns

**Pattern 1: Integration-First Design**
```markdown
When creating new skills:
1. Identify 2-3 related skills
2. Design explicit integration points
3. Show combined workflow examples
4. Cross-reference in documentation
```

**Pattern 2: Reference + Action**
```markdown
Don't just provide information:
1. Include reference tables/data
2. Provide decision trees
3. Suggest specific actions
4. Give concrete next steps
```

**Pattern 3: Supporting Scripts**
```markdown
For lookups and common operations:
1. Create helper scripts
2. Support both Unix and Windows
3. Make browser-accessible when useful
4. Document in skill's scripts/ folder
```

#### Application to Future Skills

**For new "X-research" skills:**
- Follow same structure (SKILL.md, reference.md, examples.md, scripts/)
- Include comprehensive tables
- Provide actionable workflows
- Integrate with existing skills

**For enhancement of existing skills:**
- Add reference data where missing
- Create helper scripts
- Improve cross-skill integration
- Add decision trees

#### Template for Future Skills

```markdown
skill-name/
├─ SKILL.md
│  ├─ Capabilities
│  ├─ When to Activate
│  ├─ Integration with Other Skills ⭐
│  ├─ Workflow Steps
│  └─ Output Formats
├─ reference.md
│  ├─ Tables/Maps ⭐
│  ├─ Decision Trees ⭐
│  └─ Guidelines
├─ examples.md
│  └─ 3-5 real-world scenarios
└─ scripts/
   ├─ helper-tool.sh ⭐
   └─ helper-tool.ps1 ⭐
```

**Learning Documented:** Added successful pattern template to self-improvement skill

---

## Example 7: Automated Feedback Loop

### User Request
"Set up an automated weekly review of Claude Code performance."

### Skill Activation
Self-improvement skill creates automated feedback loop.

### Automated Review System

#### Weekly Review Script

**File:** `.claude/scripts/weekly-review.sh`
```bash
#!/bin/bash
# Weekly Claude Code Performance Review
# Run this every Monday to analyze past week's activity

WEEK_AGO=$(date -d '7 days ago' +%Y-%m-%d)

echo "# Claude Code Weekly Review"
echo "**Period:** $(date -d '7 days ago' +%Y-%m-%d) to $(date +%Y-%m-%d)"
echo ""

# 1. Error Analysis
echo "## Errors and Fixes"
git log --since="$WEEK_AGO" --grep="fix\|error" --oneline | nl

# 2. New Features
echo ""
echo "## New Features"
git log --since="$WEEK_AGO" --grep="feat" --oneline | nl

# 3. Documentation Updates
echo ""
echo "## Documentation Changes"
git log --since="$WEEK_AGO" --grep="docs" -- CLAUDE.md .claude/ | wc -l
echo "documentation commits"

# 4. Skill Usage (from git commits mentioning skills)
echo ""
echo "## Skill Mentions"
git log --since="$WEEK_AGO" --all-match --grep="skill" -i --oneline | nl

# 5. File Growth
echo ""
echo "## CLAUDE.md Health"
wc -l CLAUDE.md

# 6. Generate Review File
OUTPUT_FILE=".claude/reviews/review-$(date +%Y-%m-%d).md"
mkdir -p .claude/reviews

# Create detailed review (would expand this)
cat > "$OUTPUT_FILE" << EOF
# Weekly Review - $(date +%Y-%m-%d)

## Summary
[Auto-generated analysis]

## Action Items
[ ] Review error patterns
[ ] Update documentation if needed
[ ] Check CLAUDE.md size
[ ] Review skill effectiveness

## Next Week Focus
[Manual input needed]
EOF

echo ""
echo "✅ Review saved to $OUTPUT_FILE"
```

#### PowerShell Version

**File:** `.claude/scripts/weekly-review.ps1`
```powershell
# Weekly Claude Code Performance Review
# Run this every Monday to analyze past week's activity

$weekAgo = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
$today = (Get-Date).ToString("yyyy-MM-dd")

Write-Host "# Claude Code Weekly Review"
Write-Host "**Period:** $weekAgo to $today"
Write-Host ""

# 1. Error Analysis
Write-Host "## Errors and Fixes"
git log --since="$weekAgo" --grep="fix|error" --oneline

# 2. New Features
Write-Host ""
Write-Host "## New Features"
git log --since="$weekAgo" --grep="feat" --oneline

# 3. CLAUDE.md Health
Write-Host ""
Write-Host "## CLAUDE.md Health"
$lineCount = (Get-Content CLAUDE.md | Measure-Object -Line).Lines
Write-Host "Lines: $lineCount / 600"

if ($lineCount -gt 550) {
    Write-Host "[WARNING] Approaching extraction threshold"
}

# 4. Generate Review File
$outputFile = ".claude/reviews/review-$today.md"
New-Item -ItemType Directory -Force -Path ".claude/reviews" | Out-Null

$reviewContent = @"
# Weekly Review - $today

## Summary
- Errors fixed: $(git log --since="$weekAgo" --grep="fix" --oneline | Measure-Object -Line).Lines
- Features added: $(git log --since="$weekAgo" --grep="feat" --oneline | Measure-Object -Line).Lines
- CLAUDE.md size: $lineCount lines

## Action Items
[ ] Review error patterns
[ ] Update documentation if needed
[ ] Check CLAUDE.md size
[ ] Review skill effectiveness

## Metrics
[Auto-generated from git history]

## Next Week Focus
[Manual input needed]
"@

$reviewContent | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host ""
Write-Host "[SUCCESS] Review saved to $outputFile"
```

#### Automation via npm Scripts

**Add to `package.json`:**
```json
{
  "scripts": {
    "review:weekly": "node scripts/check-deps.js && bash .claude/scripts/weekly-review.sh || powershell -ExecutionPolicy Bypass -File .claude/scripts/weekly-review.ps1"
  }
}
```

#### Scheduled Automation (Optional)

**Using GitHub Actions:**
```yaml
# .github/workflows/weekly-review.yml
name: Weekly Claude Code Review

on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9 AM

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm run review:weekly
      - uses: peter-evans/create-pull-request@v5
        with:
          title: 'Weekly Claude Code Review'
          body: 'Auto-generated weekly review'
          branch: 'auto-review'
```

#### Usage

```bash
# Manual run
npm run review:weekly

# Or directly
bash .claude/scripts/weekly-review.sh        # Unix
powershell .claude/scripts/weekly-review.ps1  # Windows

# Output location
cat .claude/reviews/review-2025-11-09.md
```

**Impact:**
- ✅ Automated error tracking
- ✅ Regular health checks
- ✅ Historical record of improvements
- ✅ Proactive issue detection

---

## Example 8: Cross-Skill Learning

### User Request
"The commit-helper and github-issues skills both analyze git history. Can they share learnings?"

### Skill Activation
Self-improvement skill analyzes cross-skill optimization opportunities.

### Cross-Skill Integration Analysis

#### Current Overlap

**commit-helper Capability:**
- Analyzes git diff
- Determines commit type
- Suggests scopes
- Validates format

**github-issues Capability:**
- Searches git history
- Finds related commits
- Checks if issue is resolved
- Maps relationships

**Overlap:**
Both search git history and analyze commits

#### Optimization Opportunity

**Shared Knowledge Base:**
`.claude/knowledge/git-patterns.md`

```markdown
# Git Patterns Knowledge Base

Shared by: commit-helper, github-issues, self-improvement

## Commit Search Patterns

### Finding Features
```bash
# Best practices learned from usage:
git log --all --grep="feature-name" --oneline
git log --all -S"ClassName" --oneline  # Code search
git log --all --since="1 month ago" --grep="^feat" --oneline
```

### Finding Fixes
```bash
git log --all --grep="^fix.*issue-keyword" --oneline
git log --all --grep="#[0-9]+" --oneline  # Find issue refs
```

### Finding Related Work
```bash
git log --all --grep="module-name" --author="developer" --oneline
git log --all --since="date" --until="date" --oneline
```

## Common Mistakes to Avoid

1. **Not using --all**
   - Problem: Misses commits on other branches
   - Solution: Always use --all for comprehensive search

2. **Case sensitivity**
   - Problem: Misses variations (Recipe vs recipe)
   - Solution: Use -i for case-insensitive or search both

3. **Missing closed issues**
   - Problem: Thinks feature doesn't exist
   - Solution: gh issue list --state all

## Skill-Specific Usage

### commit-helper
- Uses: Analyze recent commits for commit style patterns
- Pattern: `git log -10 --oneline` to match project style

### github-issues
- Uses: Validate if issue already resolved
- Pattern: `git log --all --grep="issue-topic" --since="6 months ago"`

### self-improvement
- Uses: Extract error patterns from fixes
- Pattern: `git log --grep="^fix.*error\|^fix.*PowerShell"`
```

#### Enhanced Integration

**commit-helper Enhancement:**
```markdown
## Integration with github-issues

When generating commit message for issue fix:
1. Check if issue number provided
2. Search related commits: git log --all --grep="#123"
3. Match commit style from related commits
4. Suggest: "fix(scope): resolve issue #123"

When issue was invalid/duplicate:
1. Suggest: "docs(issue): close #123 as duplicate of #456"
2. Or: "docs(issue): close #123 as already fixed in <commit>"
```

**github-issues Enhancement:**
```markdown
## Integration with commit-helper

When creating fix commit for valid issue:
1. Use commit-helper to generate proper message
2. Ensure format: "fix(scope): description

   Fixes #123
   Closes #123"
3. Follow project commit conventions
```

**self-improvement Enhancement:**
```markdown
## Learning from Both Skills

Track search patterns that work:
- commit-helper: Recent style analysis
- github-issues: Historical duplicate detection
- Extract: Best practices for git-patterns.md

Monitor patterns that fail:
- Add to common mistakes
- Update skill guidance
- Improve search strategies
```

#### Implementation

1. Create `.claude/knowledge/git-patterns.md`
2. Update all three skills to reference it
3. Add cross-references in SKILL.md files
4. Track improvements in self-improvement skill

**Effort:** 1 hour
**Impact:**
- Consistent git search across skills
- Shared learnings benefit all
- Reduced redundancy

---

These examples show how the self-improvement skill creates a continuous learning loop, improving Claude Code's performance over time through error analysis, documentation optimization, and cross-skill knowledge sharing.
