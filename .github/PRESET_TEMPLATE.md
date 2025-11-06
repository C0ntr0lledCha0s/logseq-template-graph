# Preset Configuration Template

This document explains how to create custom preset configurations for building template variants.

## What are Presets?

Presets are EDN configuration files that define which modules to include when building a template variant. They allow you to create focused, smaller templates for specific use cases.

## Preset File Format

**Location:** `source/presets/your-preset-name.edn`

**Structure:**

```clojure
{:name "Your Template Name"
 :description "Brief description of use case"
 :include ["module1" "module2" "base"]}
```

### Fields

- **`:name`** (string, required) - Display name for the template
- **`:description`** (string, required) - Brief description of the use case
- **`:include`** (vector or nil, required) - List of module names to include
  - Use `nil` to include ALL modules (full template)
  - Use `["module1" "module2"]` to include specific modules only

## Available Modules

The following modules are available to include in presets:

| Module | Classes | Properties | Description |
|--------|---------|------------|-------------|
| `base` | 2 | ~5 | Thing, Resource (foundational) |
| `person` | ~8 | ~150 | Person, Patient, Employee, etc. |
| `organization` | ~12 | ~80 | Organization, Corporation, NGO, etc. |
| `event` | ~25 | ~60 | Event, Meeting, Conference, etc. |
| `place` | ~18 | ~40 | Place, Address, City, etc. |
| `creative-work` | ~50 | ~100 | Book, Article, Video, Image, etc. |
| `product` | ~15 | ~30 | Product, Offer, Service, etc. |
| `action` | ~180 | ~200 | Action subtypes (SearchAction, etc.) |
| `intangible` | ~40 | ~80 | Audience, Rating, Review, etc. |
| `misc` | varies | varies | Uncategorized classes |
| `common` | 0 | varies | Shared properties across modules |

**Important:** Always include `base` module for foundational classes.

## Example Presets

### Full Template (All Modules)

**`source/presets/full.edn`:**
```clojure
{:name "Full Template"
 :description "All classes and properties from Schema.org"
 :include nil}
```

Setting `:include` to `nil` includes everything.

---

### CRM Template

**`source/presets/crm.edn`:**
```clojure
{:name "CRM Template"
 :description "Customer relationship management"
 :include ["base" "person" "organization"]}
```

**Result:**
- **Size:** ~2,000 lines
- **Focus:** Managing people and organizations
- **Ideal for:** Sales teams, business development, networking

---

### Research Template

**`source/presets/research.edn`:**
```clojure
{:name "Research Template"
 :description "Academic research and note-taking"
 :include ["base" "person" "creative-work" "event"]}
```

**Result:**
- **Size:** ~3,000 lines
- **Focus:** Authors, papers, conferences
- **Ideal for:** Academics, researchers, students

---

### Content Creator Template

**`source/presets/content.edn`:**
```clojure
{:name "Content Creator Template"
 :description "For bloggers, writers, and content creators"
 :include ["base" "creative-work" "person"]}
```

**Result:**
- **Size:** ~2,500 lines
- **Focus:** Articles, videos, images, authors
- **Ideal for:** Bloggers, YouTubers, writers

---

### Events & Calendar Template

**`source/presets/events.edn`:**
```clojure
{:name "Events & Calendar Template"
 :description "Event management and scheduling"
 :include ["base" "event" "person" "place" "organization"]}
```

**Result:**
- **Size:** ~1,500 lines
- **Focus:** Events, attendees, locations
- **Ideal for:** Event planners, conference organizers

---

### Project Management Template (Custom Example)

**`source/presets/project-management.edn`:**
```clojure
{:name "Project Management Template"
 :description "For managing projects, tasks, and teams"
 :include ["base" "person" "organization" "event" "action" "intangible"]}
```

**Result:**
- **Focus:** People, orgs, deadlines, actions, reviews
- **Ideal for:** Project managers, team leads

---

## Creating a Custom Preset

### Step 1: Create Preset File

```bash
# Create new preset
cat > source/presets/my-custom.edn << 'EOF'
{:name "My Custom Template"
 :description "Description of my specific use case"
 :include ["base" "person" "creative-work"]}
EOF
```

### Step 2: Build Template

```bash
# Build your custom preset
bb scripts/build.clj my-custom

# Output: build/logseq_db_Templates_my-custom.edn
```

### Step 3: Validate

```bash
# Validate the built template
./scripts/validate.sh build/logseq_db_Templates_my-custom.edn
```

### Step 4: Test Import

1. Open Logseq
2. Create new DB graph "test-my-custom"
3. Go to Settings → Import → EDN to DB Graph
4. Select `build/logseq_db_Templates_my-custom.edn`
5. Verify expected classes are present

### Step 5: Commit

```bash
git add source/presets/my-custom.edn
git commit -m "feat: add custom preset for [use case]"
git push
```

---

## Preset Best Practices

### 1. Always Include Base Module

```clojure
:include ["base" "...other modules..."]
```

The `base` module contains foundational classes like `Thing` that other classes inherit from.

### 2. Keep Presets Focused

Good presets solve a specific use case:
- ✅ CRM: person, organization
- ✅ Research: creative-work, person, event
- ❌ Kitchen Sink: all modules (just use full.edn)

### 3. Name Presets by Use Case

- ✅ `crm.edn`, `research.edn`, `events.edn`
- ❌ `preset1.edn`, `test.edn`, `temp.edn`

### 4. Write Clear Descriptions

```clojure
:description "Customer relationship management"  ; ✅ Clear
:description "CRM stuff"                         ; ❌ Vague
```

### 5. Test Before Committing

Always test import in Logseq before committing a new preset.

---

## Module Dependencies

Some modules naturally work together:

### Event Management
```clojure
:include ["base" "event" "person" "place" "organization"]
```

### Content Creation
```clojure
:include ["base" "creative-work" "person"]
```

### CRM/Sales
```clojure
:include ["base" "person" "organization" "event"]
```

### E-commerce
```clojure
:include ["base" "product" "person" "organization"]
```

---

## Troubleshooting

### Build fails: "source/ directory not found"

**Solution:** Run initialization first:
```bash
./scripts/init-modular.sh
```

### Preset not found

**Error:** `❌ Error: source/presets/my-preset.edn not found`

**Solution:** Create the preset file in `source/presets/` first.

### Built template has 0 classes/properties

**Problem:** `:include` list doesn't match any modules

**Solution:** Check module names match directory names in `source/`:
```bash
ls source/
# Should show: base, person, organization, event, etc.
```

### Classes missing after import

**Problem:** Forgot to include required module

**Solution:** Check which module contains the class:
```bash
grep -r "ClassName" source/*/classes.edn
```

---

## Advanced Usage

### Conditional Includes (Future)

Currently, `:include` is a simple list. Future versions may support:

```clojure
{:name "Advanced Preset"
 :include ["base" "person"]
 :exclude ["person/properties/password"]  ; Exclude specific properties
 :min-version "0.3.0"}                    ; Require minimum version
```

### Preset Inheritance (Future)

```clojure
{:name "Extended CRM"
 :extends "crm"                           ; Inherit from crm.edn
 :include ["event"]}                      ; Add event module
```

---

## Contributing Presets

To contribute a new preset:

1. **Create preset file** in `source/presets/`
2. **Test thoroughly** - Import into Logseq and verify
3. **Document use case** - Update this file with your preset
4. **Submit PR** with clear description

### PR Template for New Presets

```markdown
## New Preset: [Name]

**Use Case:** [Description]

**Modules Included:**
- base
- [module1]
- [module2]

**Target Users:** [Who will benefit from this preset]

**Testing:**
- [x] Built successfully
- [x] Imported into Logseq
- [x] All expected classes present
- [x] No errors in Logseq console

**Size:** ~[X,XXX] lines, [Y] classes, [Z] properties
```

---

## Resources

- **Build Script:** `scripts/build.clj`
- **Module Structure:** `source/[module-name]/`
- **Built Templates:** `build/`
- **Documentation:** `docs/modular/quickstart.md`

---

**Questions?** Open an issue at: https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues
