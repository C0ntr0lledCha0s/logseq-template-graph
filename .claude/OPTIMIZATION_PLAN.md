# Claude Code Optimization Plan
## Logseq Template Graph - Enhancement Recommendations

**Status:** Draft
**Last Updated:** November 2025
**Priority:** High Impact Features First

---

## Executive Summary

This project is **perfectly suited** for Claude Code optimizations. Current automation (npm scripts, Babashka, GitHub Actions) is strong, but developer experience can be dramatically improved with:

- **10 Slash Commands** - Quick access to common workflows
- **3 Specialized Agents** - Complex multi-step automation
- **3 Git Hooks** - Passive validation and safety
- **3 Custom Skills** - Domain-specific analysis

**Expected Impact:**
- 30-40 min saved per developer/week (Phase 1)
- 120+ min saved per developer/week (Full implementation)
- **Payback period: 2-3 weeks**

---

## Quick Wins (Implement First)

### 1. `/test-workflow` Command ⭐⭐⭐
**Impact:** High | **Complexity:** Low | **Time:** 30 min

End-to-end testing workflow that's currently manual.

**Current Manual Process:**
```bash
npm run export
git diff src/
npm run build:full
npm run build:crm
./scripts/validate.sh build/*
# Read all output, verify manually
```

**As Command:**
```
/test-workflow
  ├─ Runs export + split
  ├─ Shows module changes summary
  ├─ Builds all variants in parallel
  ├─ Validates outputs
  ├─ Generates comparison table
  └─ Suggests next steps
```

**Implementation:**
Create `.claude/commands/test-workflow.md`

---

### 2. `/release-prep` Command ⭐⭐⭐
**Impact:** High | **Complexity:** Low | **Time:** 45 min

Pre-release checklist that prevents mistakes.

**Current Manual:**
```bash
npm run version  # Check version
npm run changelog  # Preview
git status  # Verify clean
# Tag and push (hoping it works)
```

**As Command:**
```
/release-prep [version]
  ├─ Validates all commits since last tag
  ├─ Generates changelog preview
  ├─ Confirms version bump logic
  ├─ Checks git status (clean?)
  ├─ Validates all builds succeed
  ├─ Shows release plan
  ├─ Executes: tag + push (if approved)
  └─ Links to GitHub Actions run
```

**Prevents:**
- Wrong version numbers
- Missing changelog entries
- Uncommitted changes in releases
- Failed builds reaching production

---

### 3. `/diagnose` Command ⭐⭐⭐
**Impact:** High | **Complexity:** Medium | **Time:** 1 hour

Debug build failures with intelligent analysis.

**Current Manual:**
```bash
npm run build:full  # Fails
# Read cryptic Babashka error
# Manually inspect 11 source modules
# Grep for issues
# Edit and retry (repeat)
```

**As Command:**
```
/diagnose [variant]
  ├─ Analyzes last build error
  ├─ Parses Babashka output
  ├─ Scans related modules
  ├─ Checks for common issues:
  │   - Invalid EDN syntax
  │   - Duplicate IDs
  │   - Missing parent classes
  │   - Invalid cardinality
  │   - Broken property references
  ├─ Proposes specific fixes
  ├─ Offers to apply fixes
  └─ Retries build
```

**Saves:** 10-15 minutes per build failure

---

## Phase 1: Core Commands (Week 1)

### 4. `/new-class` Command ⭐⭐
**Impact:** Medium | **Complexity:** Medium | **Time:** 2 hours

Interactive class creation with Schema.org integration.

**Workflow:**
```
/new-class Recipe
  ├─ Asks: "Which module?" (suggests: creative-work)
  ├─ Researches: schema.org/Recipe
  ├─ Shows: Parent class (CreativeWork)
  ├─ Shows: Suggested properties:
  │   - recipeIngredient (Text, many)
  │   - cookTime (Text, one)
  │   - recipeInstructions (Text, one)
  │   - nutrition (Node, one)
  ├─ Prompts: "Add all? [Y/n]"
  ├─ Creates: source/creative-work/classes.edn entry
  ├─ Updates: source/creative-work/README.md
  ├─ Builds: npm run build:full
  ├─ Validates: Output
  ├─ Suggests commit: "feat(classes): add Recipe class"
  └─ Ready to commit
```

---

### 5. `/new-property` Command ⭐⭐
**Impact:** Medium | **Complexity:** Medium | **Time:** 1.5 hours

Interactive property creation with type mapping.

**Workflow:**
```
/new-property jobTitle
  ├─ Researches: schema.org/jobTitle
  ├─ Shows: Expected type (Text)
  ├─ Maps: Logseq type (:default)
  ├─ Suggests: Cardinality (:one)
  ├─ Asks: "Which classes?" (suggests: Person, Patient)
  ├─ Asks: "Icon emoji?" (suggests: 💼)
  ├─ Creates: source/person/properties.edn entry
  ├─ Updates: source/person/README.md
  ├─ Validates: Builds successfully
  ├─ Shows: Diff preview
  └─ Suggests commit
```

---

### 6. `/validate-env` Command ⭐⭐
**Impact:** High (for new devs) | **Complexity:** Low | **Time:** 1 hour

Comprehensive environment validation.

**Current:** `npm run postinstall` only checks Babashka.

**Enhanced Check:**
```
/validate-env
  ├─ Node.js version (>= 16) ✓
  ├─ npm version ✓
  ├─ @logseq/cli installed ✓
  ├─ Babashka installed ✓
  ├─ Git configured ✓
  ├─ Git hooks installed ✓
  ├─ Conventional commits working ✓
  ├─ LOGSEQ_GRAPH_PATH set ✓
  ├─ Graph exists at path ✓
  ├─ Source modules present (11/11) ✓
  ├─ Build directory writable ✓
  └─ [Offers to fix any failures]
```

**Onboarding Impact:** Saves 30-60 minutes for new developers.

---

### 7. `/stats` Command ⭐
**Impact:** Medium | **Complexity:** Low | **Time:** 45 min

Quick project statistics dashboard.

**Output:**
```
📊 Logseq Template Graph Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Source Modules: 11
📄 Template Variants: 5

🏗️  Classes by Module
  base:           2 classes
  person:         2 classes,  36 properties
  organization:   4 classes,  15 properties
  event:         17 classes,   6 properties
  creative-work: 14 classes,   7 properties
  place:          2 classes,   9 properties
  product:        1 class,     2 properties
  intangible:     9 classes,   9 properties
  action:         1 class,     1 property
  health:         varies
  misc:          82 classes,  59 properties
  common:         0 classes, 189 properties (shared)

📊 Totals
  Classes: 632
  Properties: 1,033
  Lines (monolith): 15,422

🎯 Recent Changes (last commit)
  +3 classes
  +7 properties
  Modified modules: creative-work, person

⚡ Build Sizes
  full:     ~8,931 lines
  crm:      ~5,386 lines
  research: ~4,200 lines
  content:  ~3,900 lines
  events:   ~2,800 lines
```

---

## Phase 2: Advanced Agents (Week 2-3)

### 8. `feature-complete` Agent ⭐⭐⭐
**Impact:** Very High | **Complexity:** High | **Time:** 4-6 hours

End-to-end workflow for adding features (class or property).

**Autonomous Steps:**
1. **Research** - Schema.org lookup, parent class identification
2. **Plan** - Module selection, property list, icon selection
3. **Implement** - Edit source files, update READMEs
4. **Build** - All variants, parallel where possible
5. **Validate** - EDN syntax, property counts, size checks
6. **Document** - Update technical docs, add examples
7. **Commit** - Generate conventional commit, validate
8. **Report** - Show what was done, suggest testing

**User Interaction:**
- Confirms plan before implementation
- Approves edits before committing
- Can override any step

**Time Saved:** 20-30 minutes per feature (vs manual)

---

### 9. `drift-detector` Agent ⭐⭐
**Impact:** Medium | **Complexity:** High | **Time:** 3-4 hours

Detect when source modules drift from expectations.

**Triggers:**
- Build produces unexpected line counts
- Property/class counts differ from manifest
- Module sizes are imbalanced

**Analysis:**
1. Compare with last known good state
2. Identify changed modules
3. Show line-by-line diffs
4. Highlight breaking changes
5. Assess impact on variants
6. Suggest fixes or reverts

**Use Case:** "My full template is suddenly 12K lines instead of 9K. What happened?"

---

### 10. `parallel-build` Agent ⭐
**Impact:** Medium | **Complexity:** Medium | **Time:** 2-3 hours

Build all variants with comprehensive reporting.

**Features:**
- Parallel builds (where supported)
- Progress indicators per variant
- Validation for each
- Comparison matrix
- Anomaly detection
- Size trend analysis

**Output:**
```
Building 5 variants in parallel...
  [████████████] full      (8,931 lines) ✓
  [████████████] crm       (5,386 lines) ✓
  [████████████] research  (4,200 lines) ✓
  [████████████] content   (3,900 lines) ✓
  [████████████] events    (2,800 lines) ✓

| Variant  | Lines  | Props | Classes | Size   | Status |
|----------|--------|-------|---------|--------|--------|
| full     | 8,931  | 333   | 134     | 498 KB | ✅     |
| crm      | 5,386  | 240   | 8       | 298 KB | ✅     |
| research | 4,200  | 180   | 45      | 235 KB | ✅     |
| content  | 3,900  | 150   | 40      | 220 KB | ✅     |
| events   | 2,800  | 120   | 25      | 156 KB | ✅     |

No anomalies detected.
```

---

## Phase 3: Git Hooks (Week 3)

### 11. `post-commit` Hook ⭐⭐⭐
**Impact:** High | **Complexity:** Low | **Time:** 1 hour

Validate build after committing to `source/`.

**Trigger:** After `git commit` if `source/` was modified

**Actions:**
```bash
🔨 Building template to validate commit...
  ✓ Build succeeded (8,934 lines, +3 from last)
  ✓ Validation passed
  ✓ No anomalies detected
```

**If build fails:**
```bash
❌ Build failed!
Error: Invalid EDN syntax in source/person/properties.edn:42

💡 Options:
  1. /diagnose full - Analyze the failure
  2. git reset HEAD~ - Undo commit
  3. git commit --amend - Fix and retry

Review the error above or run /diagnose for help.
```

**Prevents:** Broken commits reaching remote.

---

### 12. `pre-push` Hook ⭐⭐
**Impact:** High | **Complexity:** Medium | **Time:** 1.5 hours

Full validation before pushing.

**Checks:**
1. All builds succeed
2. All validations pass
3. Commit messages follow conventional commits
4. No uncommitted changes in `source/`
5. If pushing to `main`, ensure proper versioning

**Prevents:**
- Broken builds on CI/CD
- Invalid releases
- Missing conventional commit formatting

---

### 13. `post-merge` Hook ⭐
**Impact:** Medium | **Complexity:** Low | **Time:** 45 min

Auto-rebuild after merging.

**Trigger:** After `git merge` or `git pull` if `source/` changed

**Actions:**
```bash
📦 Source modules changed - rebuilding...
  ✓ Built 5 variants
  ✓ Updated build/ directory

⚠️  Review changes before committing build artifacts.
```

---

## Phase 4: Custom Skills (Week 4)

### 14. `edn-analyzer` Skill ⭐⭐
**Impact:** Medium | **Complexity:** Medium | **Time:** 3-4 hours

Deep analysis of EDN template files.

**Capabilities:**
- Count classes and properties
- Identify class hierarchies
- Find orphaned properties/classes
- Analyze cardinality distribution
- Check for duplicate IDs
- Generate structure reports
- Compare variants

**Example Usage:**
```
User: "Analyze the full template and show orphaned classes"

Output:
🔍 Analyzing logseq_db_Templates_full.edn...

⚠️  Orphaned Classes (no parent):
  - Schedule (appears in intangible/)
  - ProductCategory (appears in product/)

💡 Suggestion:
  - Schedule should probably inherit from Intangible
  - ProductCategory should inherit from Thing or DefinedTerm

Would you like me to add parent relationships?
```

---

### 15. `commit-helper` Skill ⭐⭐
**Impact:** Medium | **Complexity:** Low | **Time:** 2 hours

Assist with conventional commit messages.

**Features:**
- Validate commit message format
- Suggest commit types based on changes
- Recommend scopes
- Generate multi-line commits with body/footer
- Check for common mistakes

**Example:**
```
User: "Suggest a commit message for my changes"

Skill analyzes git diff:
  - source/creative-work/classes.edn (+15 lines)
  - source/creative-work/README.md (+3 lines)

Suggestion:
  feat(classes): add Recipe class to creative-work module

  - Added Recipe class with 5 properties
  - Properties: recipeIngredient, cookTime, recipeInstructions, nutrition, recipeYield
  - Parent class: CreativeWork
  - Updated module README with examples

  Closes #42
```

---

### 16. `module-health` Skill ⭐
**Impact:** Low-Medium | **Complexity:** Medium | **Time:** 2-3 hours

Assess modular architecture health.

**Checks:**
- Module size balance (misc too big?)
- Dependencies between modules
- Orphaned files
- Suggested reorganization
- Property/class ratio per module

**Output:**
```
📊 Module Health Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Well-Balanced Modules (8/11)
  person, organization, event, creative-work,
  place, product, intangible, action

⚠️  Attention Needed (3/11)

  misc/ - 82 classes, 59 properties
    Status: BLOATED (61% of all classes)
    Suggestion: Split into sub-modules:
      - communication/ (EmailMessage, Message, etc.)
      - medical/ (MedicalCondition, Drug, etc.)
      - financial/ (Invoice, PaymentCard, etc.)

  common/ - 0 classes, 189 properties
    Status: OK (shared properties across modules)
    Note: High reuse rate (good architecture)

  health/ - varies
    Status: INCOMPLETE
    Suggestion: Complete health module or merge into misc/

💡 Recommendations:
  1. Split misc/ into 5 focused modules
  2. Move health properties to dedicated module
  3. Consider adding financial/ module
```

---

## Implementation Roadmap

### Week 1: Quick Wins
- [ ] `/test-workflow` command (30 min)
- [ ] `/release-prep` command (45 min)
- [ ] `/diagnose` command (1 hour)
- [ ] `/validate-env` command (1 hour)
- [ ] `/stats` command (45 min)

**Total Time:** ~4 hours
**Impact:** 30-40 min saved per developer/week

---

### Week 2: Core Features
- [ ] `/new-class` command (2 hours)
- [ ] `/new-property` command (1.5 hours)
- [ ] `feature-complete` agent (6 hours)

**Total Time:** ~10 hours
**Impact:** 60-90 min saved per developer/week

---

### Week 3: Safety & Automation
- [ ] `drift-detector` agent (4 hours)
- [ ] `parallel-build` agent (3 hours)
- [ ] `post-commit` hook (1 hour)
- [ ] `pre-push` hook (1.5 hours)
- [ ] `post-merge` hook (45 min)

**Total Time:** ~10 hours
**Impact:** Passive protection, fewer errors

---

### Week 4: Polish & Skills
- [ ] `edn-analyzer` skill (4 hours)
- [ ] `commit-helper` skill (2 hours)
- [ ] `module-health` skill (3 hours)

**Total Time:** ~9 hours
**Impact:** Better insights, architecture guidance

---

## Success Metrics

### Phase 1 Targets (After Week 1)
- [ ] Export workflow reduced from 10 min → 3 min
- [ ] Build validation automated (was manual)
- [ ] Release prep checklist prevents 1+ error
- [ ] Team uses commands 5+ times/week

### Phase 2 Targets (After Week 2)
- [ ] New class/property workflow: 30 min → 5 min
- [ ] `feature-complete` handles 80% of new features
- [ ] Developer satisfaction improves (survey)

### Phase 3 Targets (After Week 3)
- [ ] Zero broken commits reach remote (hooks working)
- [ ] Build failures detected in 30 seconds (not 10 min)
- [ ] Team confidence in releasing increases

### Phase 4 Targets (After Week 4)
- [ ] Module health checked monthly
- [ ] Conventional commits adopted by 100% of team
- [ ] Architecture decisions data-driven (analyzer)

---

## Cost-Benefit Analysis

### Time Investment
- Week 1: 4 hours
- Week 2: 10 hours
- Week 3: 10 hours
- Week 4: 9 hours
- **Total: 33 hours**

### Time Savings
- Per developer per week: 30-40 min (Phase 1)
- Per developer per week: 60-90 min (Phase 2)
- Per developer per week: 120+ min (Full)

**Team of 3 developers:**
- Phase 1: 90-120 min/week saved = 6-8 hours/month
- Phase 2: 180-270 min/week saved = 12-18 hours/month
- Full: 360+ min/week saved = 24+ hours/month

**Payback Period:** 2-3 weeks (break-even)

**Annual Savings (Team of 3):** 288-432 hours

---

## Priority Matrix

| Feature | Impact | Complexity | Priority | Week |
|---------|--------|-----------|----------|------|
| `/test-workflow` | ⭐⭐⭐ | Low | 1 | 1 |
| `/release-prep` | ⭐⭐⭐ | Low | 1 | 1 |
| `/diagnose` | ⭐⭐⭐ | Medium | 1 | 1 |
| `post-commit` hook | ⭐⭐⭐ | Low | 1 | 3 |
| `feature-complete` | ⭐⭐⭐ | High | 2 | 2 |
| `/validate-env` | ⭐⭐ | Low | 2 | 1 |
| `/new-class` | ⭐⭐ | Medium | 2 | 2 |
| `/new-property` | ⭐⭐ | Medium | 2 | 2 |
| `edn-analyzer` | ⭐⭐ | Medium | 3 | 4 |
| `commit-helper` | ⭐⭐ | Low | 3 | 4 |
| `pre-push` hook | ⭐⭐ | Medium | 3 | 3 |
| `drift-detector` | ⭐⭐ | High | 3 | 3 |
| `parallel-build` | ⭐ | Medium | 4 | 3 |
| `/stats` | ⭐ | Low | 4 | 1 |
| `post-merge` hook | ⭐ | Low | 4 | 3 |
| `module-health` | ⭐ | Medium | 4 | 4 |

---

## Next Steps

### Immediate Actions (Today)
1. Review this plan with team
2. Prioritize Phase 1 features
3. Set up `.claude/commands/` folder structure (✅ Done)
4. Assign implementation tasks

### This Week
1. Implement `/test-workflow` command
2. Implement `/release-prep` command
3. Implement `/validate-env` command
4. Test with team, gather feedback

### Next Week
1. Implement `/new-class` and `/new-property`
2. Begin `feature-complete` agent
3. Document learnings

### Ongoing
- Measure time savings weekly
- Iterate based on usage patterns
- Add commands as pain points emerge
- Share learnings with community

---

## Resources

### Documentation
- [Claude Code Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Claude Code Agents](https://docs.claude.com/en/docs/claude-code/agents)
- [Claude Code Hooks](https://docs.claude.com/en/docs/claude-code/hooks)

### Project Files
- [CLAUDE.md](../CLAUDE.md) - Main configuration
- [.claude/commands/](commands/) - Custom commands
- [docs/developer-guide/ci-cd-pipeline.md](../docs/developer-guide/ci-cd-pipeline.md)

### Related
- [CLAUDE_CODE_SETUP.txt](../CLAUDE_CODE_SETUP.txt) - Setup documentation

---

**Last Updated:** November 2025
**Status:** Ready for implementation
**Owner:** Development team
