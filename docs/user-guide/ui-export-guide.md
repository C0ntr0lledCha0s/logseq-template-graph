# UI Export Guide - Keyboard Shortcuts & Partial Exports

This guide explains how to export EDN data using Logseq's UI instead of the CLI, including how to configure keyboard shortcuts to avoid exporting unwanted pages and blocks.

**Quick Navigation:** [Why Use UI Export?](#why-use-ui-export) | [Setting Up Shortcuts](#setting-up-keyboard-shortcuts) | [Export Types](#understanding-export-types) | [Partial Exports](#partial-export-strategies)

---

## Why Use UI Export?

While the [CLI export workflow](../developer-guide/ci-cd-pipeline.md) is recommended for developers, UI-based exports are useful when:

- ✅ You want a quick one-off export without setting up CLI
- ✅ You're working on a non-developer machine
- ✅ You need to export specific pages or blocks (partial export)
- ✅ You prefer visual workflow over command-line

**However:** UI exports have an important limitation you need to understand.

---

## ⚠️ Critical: Keyboard Shortcuts Required

### The Problem

When using Logseq's UI to export EDN data **without setting keyboard shortcuts**, the export will include:

- ❌ ALL pages in your graph (including personal notes, journal entries, etc.)
- ❌ ALL blocks (not just your template classes and properties)
- ❌ Timestamped filenames (e.g., `logseq_db_Templates_1762330414.edn`)

**This is NOT what you want** when exporting templates from a working graph!

### The Solution

**Set up keyboard shortcuts** to export only specific data:

1. **For page-level exports** → Export entire pages with their properties
2. **For block-level exports** → Export individual blocks (more granular)
3. **For template-only exports** → Export just classes and properties (graph ontology)

---

## Setting Up Keyboard Shortcuts

### Step 1: Open Keymap Settings

1. Open Logseq
2. Click Settings (⚙️ icon)
3. Navigate to **Keymap** section
4. In the search box, type: `export`

You should see these export options:

```
Export page EDN data
Export block EDN data
Export public graph pages as html
Export graph's tags and properties EDN data
```

### Step 2: Configure Shortcuts

Click on each export type to set a keyboard shortcut:

| Export Type | Recommended Shortcut | What It Exports |
|-------------|---------------------|-----------------|
| **Export page EDN data** | `Ctrl+Alt+E` (Windows/Linux)<br>`⌘+Alt+E` (Mac) | Current page and its properties |
| **Export block EDN data** | `Ctrl+Alt+B` (Windows/Linux)<br>`⌘+Alt+B` (Mac) | Selected block only |
| **Export graph's tags and properties EDN data** | `Ctrl+Alt+T` (Windows/Linux)<br>`⌘+Alt+T` (Mac) | **All classes and properties** (template export) |

**Screenshot Reference:**

Your screenshot shows the default state where shortcuts are marked as "Unset" or "Custom". After setting them up, you'll see your configured shortcuts.

### Step 3: Test Your Shortcuts

1. Open any page in your graph
2. Press your configured shortcut (e.g., `Ctrl+Alt+E`)
3. A file save dialog should appear
4. Name your export file (e.g., `test_export.edn`)
5. Click Save

✅ **If the save dialog appears** → Your shortcut is working!
❌ **If nothing happens** → The shortcut may conflict with another app or wasn't saved properly

---

## Understanding Export Types

### 1. Export Page EDN Data (`Ctrl+Alt+E`)

**When to use:** Exporting a single class definition with all its properties.

**What it exports:**
- The current page
- All properties on that page
- All blocks on that page
- Metadata (created/updated timestamps if included)

**Example use case:**
```
You're working on a "Person" class page with properties:
- email
- jobTitle
- birthDate

Export this single page to share with another developer.
```

**Keyboard shortcut:** `Ctrl+Alt+E` (Custom: `⌘+Alt+E`)

---

### 2. Export Block EDN Data (`Ctrl+Alt+B`)

**When to use:** Exporting a single property or small section.

**What it exports:**
- The currently selected block only
- Child blocks (if any)
- No page-level metadata

**Example use case:**
```
You have a block defining a property:
- propertyName: "email"
- type: :default
- cardinality: :one

Export just this block definition.
```

**Keyboard shortcut:** `Ctrl+Alt+B` (Custom: `⌘+Alt+B`)

---

### 3. Export Graph's Tags and Properties EDN Data (`Ctrl+Alt+T`)

**When to use:** Exporting your ENTIRE template (all classes and properties).

**What it exports:**
- ✅ All classes (e.g., Person, Organization, Event)
- ✅ All properties (e.g., email, legalName, eventStatus)
- ✅ Class-property relationships
- ✅ Parent-child class hierarchy
- ❌ NO regular pages (journal entries, personal notes, etc.)
- ❌ NO content blocks (just structure)

**Example use case:**
```
You've built a complete template graph with 632 classes and 1,033 properties.

Export the entire ontology to share as a template.
```

**Keyboard shortcut:** `Ctrl+Alt+T` (Custom: `⌘+Alt+T` + `⌘+Alt+P`)

**⭐ This is the recommended export for template developers!**

---

## Partial Export Strategies

### Strategy 1: Export Ontology Only (Recommended)

**Goal:** Export just classes and properties, no content pages.

**Method:**
1. Use keyboard shortcut: `Ctrl+Alt+T`
2. This triggers: "Export graph's tags and properties EDN data"
3. Save as: `logseq_db_Templates.edn`

**What you get:**
```clojure
{:properties
 {:user.property/email-xyz {...}
  :user.property/jobTitle-abc {...}
  ...}

 :classes
 {:user.class/Person-123 {...}
  :user.class/Organization-456 {...}
  ...}

 :logseq.db.sqlite.export/export-type :graph-ontology}
```

✅ Clean template export
✅ No personal data
✅ Ready to share

---

### Strategy 2: Export Specific Classes

**Goal:** Export only certain classes (e.g., Person, Organization) without the entire template.

**Method:**
1. Create a new temporary graph
2. Import only the classes you need from your main template
3. Use `Ctrl+Alt+T` to export the filtered ontology

**Alternative (Manual):**
1. Export full template using `Ctrl+Alt+T`
2. Open the EDN file in a text editor
3. Manually remove unwanted classes and properties
4. Validate the EDN syntax

**⚠️ Warning:** Manual editing is error-prone. Use with caution.

---

### Strategy 3: Export Working Graph with Content (NOT Recommended for Templates)

**Goal:** Export everything (including pages, blocks, content).

**Method:**
1. **Do NOT set keyboard shortcuts** (leave them unset)
2. Go to: File → Export → Export graph as EDN
3. This will export your entire graph

**What you get:**
- All pages (including journal, personal notes)
- All blocks (including content, tasks, queries)
- All properties
- All classes
- Timestamped filename

**⚠️ Use case:** Backing up or migrating an entire graph, NOT for template distribution.

---

## Best Practices for Template Exports

### ✅ Do This

1. **Set keyboard shortcuts** for ontology export (`Ctrl+Alt+T`)
2. **Use consistent filenames** without timestamps:
   - `logseq_db_Templates.edn` (clean version)
   - `logseq_db_Templates_full.edn` (with metadata)
3. **Test imports** in a fresh graph before sharing
4. **Validate EDN syntax** using `scripts/validate.sh`
5. **Use CLI for automation** if you're doing frequent exports

### ❌ Don't Do This

1. ❌ Export without keyboard shortcuts configured (gets everything)
2. ❌ Keep timestamped filenames (e.g., `logseq_db_Templates_1762330414.edn`)
3. ❌ Export from a graph with personal data mixed in
4. ❌ Manually edit EDN without validation
5. ❌ Rely on UI export if you need version control (use CLI instead)

---

## Troubleshooting

### Problem: Keyboard Shortcut Doesn't Work

**Possible causes:**
1. Shortcut conflicts with system or browser shortcuts
2. Shortcut wasn't saved (didn't click "Save" or "Apply")
3. Logseq needs restart to apply changes

**Solution:**
- Try a different key combination
- Restart Logseq
- Check if another app is capturing the shortcut

---

### Problem: Export Includes Unwanted Pages

**Cause:** You exported without using the "Export graph's tags and properties EDN data" option.

**Solution:**
- Use `Ctrl+Alt+T` (ontology export) instead of full graph export
- Configure the keyboard shortcut as described above

---

### Problem: File Has Timestamped Name

**Cause:** Logseq's default export behavior adds timestamps.

**Solution:**
- After export, manually rename the file:
  ```
  logseq_db_Templates_1762330414.edn
  →
  logseq_db_Templates.edn
  ```
- Or use the CLI export scripts which control filenames

---

### Problem: Export File is Huge (500MB+)

**Cause:** You exported the entire graph including all content blocks.

**Solution:**
- Use ontology-only export (`Ctrl+Alt+T`)
- Check `.gitignore` to avoid committing large files
- Template files should be < 5MB (text-only ontology)

---

## Workflow Comparison: UI vs CLI

| Aspect | UI Export | CLI Export |
|--------|-----------|------------|
| **Setup** | No setup, use immediately | Requires Node.js + `@logseq/cli` |
| **Speed** | Manual (2-3 clicks) | Automated (one command) |
| **Filename Control** | Manual rename required | Fully automated |
| **Consistency** | Depends on user | Always consistent |
| **Partial Exports** | Easy (page/block level) | Requires filters |
| **Version Control** | Manual git workflow | Integrated in scripts |
| **Best For** | One-off exports, quick tests | Daily development, CI/CD |

**Recommendation:**
- Use **UI export** for quick tests and one-off exports
- Use **CLI export** for daily development and automation

---

## Step-by-Step: Complete UI Export Workflow

### For Template Developers

```
1. Configure Keyboard Shortcuts (One-time)
   Settings → Keymap → Search "export"
   Set "Export graph's tags and properties EDN data" to Ctrl+Alt+T

2. Work in Your Template Graph
   Build classes, add properties, test functionality

3. Export Ontology
   Press Ctrl+Alt+T
   Save as: logseq_db_Templates_[timestamp].edn

4. Rename File
   logseq_db_Templates_1762330414.edn
   →
   logseq_db_Templates.edn

5. Review Changes
   git diff logseq_db_Templates.edn

6. Commit
   git add logseq_db_Templates.edn
   git commit -m "feat: add Recipe class"
   git push
```

---

## Advanced: Mixing UI and CLI Workflows

You can combine both approaches:

```bash
# Use UI for quick page-level exports during development
1. Press Ctrl+Alt+E to export current page
2. Review changes in that specific class

# Use CLI for final template export
3. Run: ./scripts/export.sh
4. Commit the CLI-generated clean version
```

**Benefits:**
- Fast iteration with UI exports
- Consistent final output with CLI

---

## Related Documentation

- [CI/CD Pipeline](../developer-guide/ci-cd-pipeline.md) - Complete CLI export workflow
- [Quick Start Guide](../../QUICK_START.md) - Getting started
- [Technical Reference](../architecture/technical-reference.md) - EDN format details

---

## FAQ

**Q: Can I export a subset of classes using UI?**
A: Not directly. You'd need to:
1. Create a temporary graph
2. Import only desired classes
3. Export that filtered graph

**Q: Should I commit timestamped exports to Git?**
A: No. Add them to `.gitignore` and rename to consistent filenames.

**Q: Is UI export suitable for CI/CD?**
A: No. Use CLI exports for automation and version control.

**Q: Can I automate UI exports?**
A: Not easily. The UI requires manual interaction. Use CLI for automation.

---

**Last Updated:** November 2025
**Maintained By:** Logseq Template Graph Contributors

[Back to Documentation Portal](../README.md)
