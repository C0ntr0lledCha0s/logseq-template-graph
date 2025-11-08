# Update Documentation Command

Interactive command to update existing documentation or create new documentation for the Logseq Template Graph project.

## What This Does

This command provides an interactive workflow for:
- Creating missing module READMEs
- Updating existing documentation
- Refreshing outdated content
- Adding new sections to guides
- Fixing documentation issues

## Process

### 1. Determine What to Update

**Ask the user:**
```
📝 Documentation Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What would you like to update?

1. Module README (source/MODULE/README.md)
2. User guide (docs/user-guide/)
3. Developer guide (docs/developer-guide/)
4. Architecture documentation (docs/architecture/)
5. Command documentation (.claude/commands/)
6. Skills documentation (.claude/skills/)
7. Main project files (README.md, QUICK_START.md, etc.)
8. Custom (specify file)

Your choice: _____
```

### 2. Select Specific Target

**For modules:**
```
📦 Which module?

Available modules:
  [ ] base
  [ ] person
  [ ] organization
  [ ] event
  [ ] creative-work
  [ ] place
  [ ] product
  [ ] intangible
  [ ] action
  [ ] common
  [ ] misc

Missing READMEs: misc

Select module: _____
```

**For other docs:**
```
📄 Which document?

Recent files:
1. docs/user-guide/installation.md (updated 3 days ago)
2. docs/modular/quickstart.md (updated 1 week ago)
3. QUICK_START.md (updated 2 weeks ago)

Enter number or file path: _____
```

### 3. Identify Update Type

```
🔧 What type of update?

1. ✨ Create new documentation (file doesn't exist)
2. 🔄 Full refresh (rewrite entire document)
3. ➕ Add new section
4. ✏️  Update existing section
5. 🔗 Fix links and references
6. 📊 Update statistics/numbers
7. 🐛 Fix errors or outdated info

Your choice: _____
```

### 4. Gather Context

**For new documentation:**
```
📋 New Documentation Details

What should this document cover?
Description: _____

Who is the target audience?
1. Template users
2. Contributors/developers
3. Template maintainers
4. All audiences

Audience: _____

Priority level?
1. High (core functionality)
2. Medium (helpful but optional)
3. Low (nice to have)

Priority: _____
```

**For updates:**
```
🔍 What needs to be updated?

Current issue:
  [ ] Information outdated
  [ ] Missing important details
  [ ] Broken links
  [ ] Unclear examples
  [ ] Code doesn't work
  [ ] Other: _____

Specific changes needed: _____
```

### 5. Generate/Update Content

**Activate documentation-writer skill:**

```
📝 Generating documentation...

✓ Analyzing source files
✓ Extracting information
✓ Following project style guide
✓ Creating examples
✓ Adding cross-references
```

**For module README:**
```
Creating source/MODULE/README.md...

Sections:
✓ Module overview
✓ Classes list (X classes)
✓ Properties list (Y properties)
✓ Usage examples (3 examples)
✓ Schema.org references
✓ Related modules

Content: 450 lines generated
```

**For guide update:**
```
Updating docs/user-guide/installation.md...

Changes:
✓ Added Windows-specific Babashka install steps
✓ Updated Node.js version requirements
✓ Added troubleshooting section
✓ Refreshed command examples
✓ Fixed broken download links

Added: 85 lines
Modified: 23 lines
```

### 6. Validate Quality

**Activate docs-validator skill:**

```
✅ Validating documentation...

Quality checks:
✓ All code examples tested
✓ Commands produce expected output
✓ Links verified (internal + external)
✓ Formatting consistent
✓ Follows style guide
✓ Complete coverage

Quality score: 92/100
```

**Show any issues:**
```
⚠️  2 minor issues found:

1. Missing code language specifier (line 47)
   Fix: Add ```bash to code block

2. Example could be more specific
   Fix: Replace placeholder with real module name

Auto-fix these? [Y/n]: _____
```

### 7. Preview Changes

```
📄 Preview of changes:

File: source/person/README.md
Status: NEW FILE
Lines: 450

Sections created:
- Overview (2 paragraphs)
- Classes (Person, Patient)
- Properties (36 properties documented)
- Usage Examples (3 complete workflows)
- Schema.org References

Sample content:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Person Module

This module provides classes and properties for tracking people,
including contacts, users, patients, and team members...

[truncated - full content will be saved]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❓ Save this documentation? [Y/n]: _____
```

### 8. Save and Integrate

**If confirmed:**
```
💾 Saving documentation...

✓ Saved to source/person/README.md
✓ Updated docs index
✓ Added cross-references to:
  - source/organization/README.md
  - source/event/README.md
✓ Updated module coverage: 82% → 91%

Documentation ready!
```

### 9. Offer Next Steps

```
✅ Documentation Updated Successfully!

Impact:
- Module coverage: 82% → 91%
- Documentation quality: +8 points
- 450 lines of new documentation

Next steps:

1. Review the documentation:
   cat source/person/README.md

2. Document another module:
   /update-docs → module → organization

3. Commit changes:
   git add source/person/README.md
   git commit -m "docs(person): add module README with usage examples"

4. Validate all documentation:
   /docs-audit

❓ Would you like to:
  a) Document another module
  b) Commit these changes now
  c) Run full docs audit
  d) Done for now

Your choice: _____
```

## Interactive Workflows

### Workflow 1: Create Missing Module README

```
/update-docs

→ What to update? Module README
→ Which module? misc
→ Update type? Create new documentation

Analyzing source/misc/...
  Found: 82 classes, 59 properties
  Categories identified: 8 types

Creating comprehensive README...
  ✓ Overview
  ✓ All 82 classes documented
  ✓ All 59 properties listed
  ✓ 5 usage examples
  ✓ Categorized by domain
  ✓ Schema.org references

Validating...
  ✓ Quality score: 89/100

Preview → Confirm → Save

Result: source/misc/README.md (1,250 lines)
Coverage: 91% → 100%
```

### Workflow 2: Update Existing Guide

```
/update-docs

→ What to update? User guide
→ Which document? docs/modular/quickstart.md
→ Update type? Add new section

What section? Git hooks integration

Analyzing recent changes...
  Found: 3 new git hooks (Phase 3)
  - post-commit
  - pre-push
  - post-merge

Adding section...
  ✓ Git Hooks Overview
  ✓ How each hook works
  ✓ Usage examples
  ✓ Bypass instructions
  ✓ Cross-references to CLAUDE.md

Added: 85 lines
Updated: Table of contents

Preview → Confirm → Save

Result: docs/modular/quickstart.md updated
```

### Workflow 3: Fix Outdated Content

```
/update-docs

→ What to update? Main project files
→ Which document? CLAUDE_CODE_OPTIMIZATIONS.md
→ Update type? Update statistics/numbers

Scanning for outdated info...
  Found 5 outdated items:
  1. "Phase 2 Complete" → "Phase 4 Complete"
  2. "10 features" → "19 features"
  3. "8 hours invested" → "32 hours invested"
  4. "Version 2.0" → "Version 5.0"
  5. "90-130 min/week" → "200-280 min/week"

Update all? [Y/n]: Y

Updating...
  ✓ All statistics refreshed
  ✓ Status updated
  ✓ Version incremented
  ✓ Impact numbers current

Validating...
  ✓ Consistent throughout
  ✓ Matches actual state

Preview → Confirm → Save

Result: CLAUDE_CODE_OPTIMIZATIONS.md updated
```

### Workflow 4: Batch Update Multiple Docs

```
/update-docs

→ What to update? Custom
→ Custom request: "Update all references to Phase 2 → Phase 4"

Scanning all documentation...
  Found 12 files with "Phase 2 Complete"

Files to update:
  1. CLAUDE_CODE_OPTIMIZATIONS.md
  2. .claude/PHASE_2_COMPLETE.md (keep as historical)
  3. docs/README.md
  4. QUICK_START.md

Update strategy:
  - Update current status references
  - Keep historical phase docs unchanged
  - Update feature counts
  - Refresh impact numbers

Update 4 files? [Y/n]: Y

Updating...
  ✓ CLAUDE_CODE_OPTIMIZATIONS.md
  ✓ docs/README.md
  ✓ QUICK_START.md
  ✓ Skipped historical .claude/PHASE_2_COMPLETE.md

Result: 3 files updated, 1 preserved
Consistency: Verified across all docs
```

## Validation Before Save

Before saving any documentation:

1. **Test all code examples**
   ```bash
   # Extract code blocks
   # Run in safe environment
   # Verify output matches
   ```

2. **Validate all links**
   ```bash
   # Check internal links exist
   # Test external URLs
   # Verify section anchors
   ```

3. **Check formatting**
   - Proper markdown syntax
   - Consistent header levels
   - Code blocks have languages
   - Tables properly aligned

4. **Verify accuracy**
   - Information is current
   - No contradictions
   - Examples are realistic
   - Numbers/stats are correct

5. **Ensure completeness**
   - All sections present
   - Examples included
   - Cross-references added
   - Style guide followed

## Success Criteria

Documentation update is successful when:

- [ ] Content accurately reflects current state
- [ ] All examples tested and working
- [ ] Links validated and functional
- [ ] Formatting consistent
- [ ] Style guide followed
- [ ] Quality validation passed
- [ ] Integrated with existing docs
- [ ] User confirms quality

## Tools Used

- **documentation-writer** skill - Generate/update content
- **docs-validator** skill - Validate quality
- **Read** - Read source files and current docs
- **Write** - Create new files
- **Edit** - Update existing files
- **Grep** - Find patterns and references
- **Bash** - Test commands

## Error Handling

### File Not Found
```
❌ Error: File not found
   Path: docs/nonexistent.md

Would you like to:
  1. Create it as new documentation
  2. Specify different file
  3. Cancel

Choice: _____
```

### Validation Failed
```
❌ Validation failed (score: 65/100)

Issues found:
  - 3 broken links
  - 2 code examples don't work
  - Missing required section

Fix automatically? [Y/n]: Y

Fixing...
  ✓ Updated links
  ✓ Corrected code examples
  ✓ Added missing section

Re-validating... ✓ Score: 92/100

Continue? [Y/n]: _____
```

### Conflicts with Existing Content
```
⚠️  Warning: This update conflicts with existing content

Existing section: "Installation"
Your update: Completely rewrites section

Options:
  1. Replace existing (lose old content)
  2. Append to existing (keep both)
  3. Merge carefully (manual review)
  4. Cancel

Choice: _____
```

## Best Practices

1. **Always validate** - Run quality checks before saving
2. **Preview first** - Show user what will change
3. **Test examples** - Verify all code works
4. **Cross-reference** - Link related documentation
5. **Update indexes** - Keep navigation current
6. **Commit separately** - One logical change per commit
7. **Maintain history** - Don't delete historical phase docs

## Output Format

All updates should result in:
- Clear indication of what changed
- Line counts (added/modified/deleted)
- Quality score
- Impact on coverage metrics
- Specific files affected
- Recommended next steps

---

**This command provides an interactive, guided workflow for creating and updating documentation with built-in quality validation.**
