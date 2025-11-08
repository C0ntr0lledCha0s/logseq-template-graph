# Test Complete Workflow

Run the complete development workflow: export → split → build → validate.

This command tests your changes end-to-end without manual steps.

## What This Does

1. **Export from Logseq** - Uses @logseq/cli to export current graph
2. **Split into modules** - Runs Babashka split script (if modular)
3. **Show changes** - Displays git diff summary by module
4. **Build all variants** - Builds full, crm, research, content, events
5. **Validate outputs** - Checks EDN structure and counts
6. **Report results** - Shows comparison table with statistics
7. **Suggest next steps** - Ready to commit, test in Logseq, etc.

## Usage

```
/test-workflow
```

## Steps Automated

Instead of running these manually:
```bash
npm run export                    # 1. Export
git diff src/                     # 2. Review changes
npm run build:full               # 3. Build full
npm run build:crm                # 4. Build CRM
npm run build:research           # 5. Build research
npm run build:content            # 6. Build content
npm run build:events             # 7. Build events
./scripts/validate.sh build/*    # 8. Validate
# ... read all output manually
```

You just run: `/test-workflow`

## Process

### Step 1: Check Environment
- Verify LOGSEQ_GRAPH_PATH is set
- Check graph directory exists
- Verify Babashka is installed (for modular workflow)

### Step 2: Export
Run platform-appropriate export:
```bash
# Mac/Linux
./scripts/export.sh

# Windows
.\scripts\export.ps1
```

### Step 3: Analyze Changes
Show summary:
```
📊 Changes Detected
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Modified Modules:
  ✓ source/person/ (+12 lines, +1 property)
  ✓ source/creative-work/ (+25 lines, +1 class)

Statistics:
  Classes: 632 → 633 (+1)
  Properties: 1,033 → 1,034 (+1)
  Total changes: +37 lines

New Class: Recipe
New Property: jobTitle
```

### Step 4: Build All Variants
Build templates:
```bash
npm run build:full
npm run build:crm
npm run build:research
npm run build:content
npm run build:events
```

Show progress for each.

### Step 5: Validate
Run validation on all outputs:
```bash
./scripts/validate.sh build/*.edn
```

### Step 6: Report
Display comparison table:
```
| Variant  | Lines  | Props | Classes | Size   | Status |
|----------|--------|-------|---------|--------|--------|
| full     | 8,934  | 334   | 135     | 499 KB | ✅     |
| crm      | 5,389  | 241   | 8       | 299 KB | ✅     |
| research | 4,203  | 181   | 45      | 236 KB | ✅     |
| content  | 3,902  | 151   | 40      | 221 KB | ✅     |
| events   | 2,801  | 121   | 25      | 157 KB | ✅     |

All builds validated successfully! ✅
```

### Step 7: Next Steps
Suggest actions:
```
✅ All tests passed!

Next steps:
  1. Review changes: git diff src/
  2. Test import in Logseq (manual)
  3. Commit: git commit -m "feat(classes): add Recipe class"
  4. Push: git push

Or use these commands:
  - /new-class - Add another class
  - /release-prep - Prepare for release
```

## Error Handling

If export fails:
```
❌ Export failed!
Error: LOGSEQ_GRAPH_PATH not set or graph not found

💡 Fix:
  1. Set environment variable:
     export LOGSEQ_GRAPH_PATH="/path/to/graph"

  2. Or edit scripts/export.sh and set GRAPH_PATH

  3. Verify graph exists:
     ls "$LOGSEQ_GRAPH_PATH"
```

If build fails:
```
❌ Build failed: full variant

Error in source/creative-work/classes.edn:
  Invalid EDN syntax at line 42

💡 Next steps:
  1. Run: /diagnose full
  2. Or manually inspect:
     cat -n source/creative-work/classes.edn | sed -n '35,50p'
```

If validation fails:
```
⚠️  Validation warnings detected

Warning: Property count mismatch
  Expected: ~334
  Found: 330
  Missing: 4 properties

Investigate:
  - Did you remove properties?
  - Check source/common/properties.edn
```

## Tips

- **First time?** Run `/validate-env` first to check setup
- **Build failed?** Use `/diagnose [variant]` for detailed analysis
- **Need help?** See docs/developer-guide/ci-cd-pipeline.md
- **Manual control?** Run individual npm scripts instead

## Environment Requirements

- Node.js >= 16
- npm
- @logseq/cli installed
- LOGSEQ_GRAPH_PATH set
- Babashka (for modular workflow)
- Git

Run `/validate-env` to check all requirements.

## Time Savings

**Manual workflow:** ~10-15 minutes
**With /test-workflow:** ~3-5 minutes

**Saves:** 7-10 minutes per test cycle

## Related Commands

- `/validate-env` - Check environment setup
- `/diagnose` - Debug build failures
- `/release-prep` - Prepare for release
- `/stats` - View project statistics
- `/new-class` - Add new class
- `/new-property` - Add new property

## Learn More

- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)
- [Modular Quickstart](../../docs/modular/quickstart.md)
- [CLAUDE.md](../../CLAUDE.md)
