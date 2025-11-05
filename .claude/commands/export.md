# Export Templates

Export the current Logseq template graph to version-controlled EDN files.

## Steps

1. **Determine platform and run export script:**
   - Mac/Linux/Git Bash: `./scripts/export.sh`
   - Windows PowerShell: `.\scripts\export.ps1`

2. **Script automatically displays:**
   - Export progress
   - File statistics (line count, properties, classes)
   - Git diff of changes
   - Commit prompt

3. **Review the changes:**
   - Check the diff for expected modifications
   - Verify property and class counts
   - Ensure no accidental deletions

4. **Commit if prompted:**
   - Script will offer to commit and push
   - Or manually commit with semantic message:
     ```bash
     git commit -m "feat: add new classes"
     git commit -m "fix: correct property cardinality"
     git commit -m "chore: update template"
     ```

## For Modular Workflow

If working with modular templates (15K+ lines):

```bash
# After export, split into modules
bb scripts/split.clj

# Build variants
bb scripts/build.clj full
bb scripts/build.clj crm
bb scripts/build.clj research
```

See: [docs/modular/quickstart.md](../../docs/modular/quickstart.md)

## Environment Setup

Ensure `LOGSEQ_GRAPH_PATH` environment variable is set, or edit the path in the export script.

Default: `C:/Users/YourName/Logseq/template-dev`
