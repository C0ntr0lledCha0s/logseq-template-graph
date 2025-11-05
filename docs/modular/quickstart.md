## 🚀 Modular Development Quick Start

Your template has grown to **15,422 lines** with **1,033 properties** and **632 classes**! Time to modularize.

---

## One-Command Setup

```bash
./scripts/init-modular.sh
```

This will:
1. ✅ Install Babashka (if needed)
2. ✅ Create modular directory structure
3. ✅ Split your monolithic template into modules
4. ✅ Create preset configurations
5. ✅ Archive the original

---

## New Workflow

### 1. Work in Logseq
```
(Make changes to classes and properties in your Logseq graph)
```

### 2. Export & Split
```bash
# Export from Logseq (unchanged)
./scripts/export.sh

# Split into modules (NEW!)
bb scripts/split.clj
```

### 3. Review Changes
```bash
# Instead of 15,422-line diff, you see:
git diff source/person/properties.edn    # 15 lines changed
git diff source/event/classes.edn        # 8 lines changed
```

### 4. Build Variants
```bash
# Build all templates
bb scripts/build.clj full      # Everything (15K+ lines)
bb scripts/build.clj crm       # Person + Org only (~2K lines)
bb scripts/build.clj research  # Books + Articles (~3K lines)
bb scripts/build.clj content   # Creative works (~2K lines)
bb scripts/build.clj events    # Event management (~1.5K lines)
```

### 5. Validate & Test
```bash
# Validate built templates
./scripts/validate.sh build/logseq_db_Templates_full.edn
./scripts/validate.sh build/logseq_db_Templates_crm.edn

# Test import in Logseq
# Settings → Import → EDN to DB Graph
# Select: build/logseq_db_Templates_crm.edn
```

### 6. Commit
```bash
# Commit source files (not built artifacts)
git add source/
git commit -m "feat: add Recipe class to creative-work module"
git push
```

---

## Directory Structure

```
source/                          # EDIT THESE (modular source)
├── base/
│   ├── classes.edn             # Thing, Resource
│   ├── properties.edn          # Base properties
│   └── README.md
├── person/
│   ├── classes.edn             # Person class
│   ├── properties.edn          # 150+ person properties
│   └── README.md
├── organization/
│   ├── classes.edn             # Organization, Occupation
│   ├── properties.edn          # Org properties
│   └── README.md
├── event/
│   ├── classes.edn             # Event, EventSeries, Meeting
│   ├── properties.edn          # Event properties
│   └── README.md
├── creative-work/
│   ├── classes.edn             # Book, Article, Video, etc.
│   ├── properties.edn          # Creative work properties
│   └── README.md
└── presets/
    ├── full.edn                # All modules
    ├── crm.edn                 # CRM variant
    ├── research.edn            # Research variant
    ├── content.edn             # Content creation
    └── events.edn              # Event management

build/                           # GENERATED (compiled artifacts)
├── logseq_db_Templates_full.edn
├── logseq_db_Templates_crm.edn
├── logseq_db_Templates_research.edn
└── ...

scripts/
├── split.clj                   # Split monolith → modules
├── build.clj                   # Merge modules → artifacts
├── export.sh                   # Export from Logseq
├── validate.sh                 # Validate EDN
└── init-modular.sh             # One-time setup
```

---

## Available Presets

### Full Template
```bash
bb scripts/build.clj full
# Output: build/logseq_db_Templates_full.edn
# Includes: Everything (632 classes, 1033 properties)
```

### CRM Template
```bash
bb scripts/build.clj crm
# Output: build/logseq_db_Templates_crm.edn
# Includes: Person, Organization, Contact, Base
# Use for: Customer relationship management
```

### Research Template
```bash
bb scripts/build.clj research
# Output: build/logseq_db_Templates_research.edn
# Includes: Person, Organization, Books, Articles, Base
# Use for: Academic research, literature notes
```

### Content Creation Template
```bash
bb scripts/build.clj content
# Output: build/logseq_db_Templates_content.edn
# Includes: Person, Creative Works (Video, Article, Image), Base
# Use for: Content creators, bloggers, YouTubers
```

### Events Template
```bash
bb scripts/build.clj events
# Output: build/logseq_db_Templates_events.edn
# Includes: Person, Organization, Event, Place, Base
# Use for: Event planning, meeting management
```

---

## Creating Custom Presets

Create `source/presets/mypreset.edn`:

```clojure
{:name "My Custom Template"
 :description "Exactly what I need"
 :include ["person" "organization" "base" "common"]}
```

Build it:
```bash
bb scripts/build.clj mypreset
# Output: build/logseq_db_Templates_mypreset.edn
```

---

## Editing Modules

### Add a New Property

1. **Edit source file:**
   ```bash
   vim source/person/properties.edn
   ```

2. **Add property:**
   ```clojure
   :user.property/pronouns-xyz123
   {:db/cardinality :db.cardinality/one
    :logseq.property/type :default
    :block/title "pronouns"
    :build/property-classes [:user.class/Person]
    :build/properties
    {:logseq.property/icon {:id "rainbow-flag" :type :emoji}
     :logseq.property/description "Person's pronouns"}}
   ```

3. **Rebuild:**
   ```bash
   bb scripts/build.clj full
   ```

### Add a New Class

1. **Edit source file:**
   ```bash
   vim source/creative-work/classes.edn
   ```

2. **Add class:**
   ```clojure
   :user.class/Recipe-abc123
   {:block/title "Recipe"
    :build/class-properties
    [:user.property/recipeIngredient
     :user.property/recipeInstructions
     :user.property/cookTime]
    :build/class-parent :user.class/CreativeWork
    :build/properties
    {:logseq.property/icon {:id "cooking" :type :emoji}
     :logseq.property/description "A recipe"}}
   ```

3. **Rebuild:**
   ```bash
   bb scripts/build.clj full
   ```

---

## Benefits

### Before (Monolith)
```
❌ 15,422-line file
❌ Git diffs show 500+ lines changed
❌ Can't create variants
❌ Merge conflicts everywhere
❌ Impossible to navigate
```

### After (Modular)
```
✅ 50-200 line modules
✅ Git diffs show exact changes
✅ 5+ template variants
✅ No merge conflicts
✅ Easy to find and edit
✅ Multiple contributors
```

---

## Troubleshooting

### "bb: command not found"
```bash
# Install Babashka
./scripts/init-modular.sh  # Will auto-install

# Or manually:
# macOS: brew install borkdude/brew/babashka
# Linux: bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
```

### "source/ directory not found"
```bash
# Run the split first
bb scripts/split.clj
```

### Build output is empty
```bash
# Check that modules exist
ls source/*/properties.edn
ls source/*/classes.edn

# Check preset configuration
cat source/presets/full.edn
```

### Want to compare with original
```bash
# Build from modules
bb scripts/build.clj full build/rebuilt.edn

# Compare
diff logseq_db_Templates.edn build/rebuilt.edn
# Should be identical (except whitespace/ordering)
```

---

## CI/CD Integration

### GitHub Actions

Add to `.github/workflows/build-templates.yml`:

```yaml
name: Build Template Variants

on:
  push:
    paths:
      - 'source/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Babashka
        run: |
          curl -sLO https://raw.githubusercontent.com/babashka/babashka/master/install
          chmod +x install && ./install
      - name: Build all variants
        run: |
          bb scripts/build.clj full
          bb scripts/build.clj crm
          bb scripts/build.clj research
          bb scripts/build.clj content
          bb scripts/build.clj events
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: templates
          path: build/*.edn
```

---

## Commands Cheat Sheet

```bash
# Setup (one-time)
./scripts/init-modular.sh

# Daily workflow
./scripts/export.sh           # Export from Logseq
bb scripts/split.clj           # Split into modules
git diff source/               # Review changes
bb scripts/build.clj full      # Build templates
./scripts/validate.sh build/*  # Validate

# Build variants
bb scripts/build.clj full
bb scripts/build.clj crm
bb scripts/build.clj research
bb scripts/build.clj content
bb scripts/build.clj events

# Create custom preset
vim source/presets/mypreset.edn
bb scripts/build.clj mypreset

# Analyze structure
bb scripts/analyze.sh          # Show stats
tree source/                   # Browse modules
```

---

## Next Steps

1. ✅ Run `./scripts/init-modular.sh`
2. ✅ Review `source/` directory structure
3. ✅ Build full template: `bb scripts/build.clj full`
4. ✅ Test import in Logseq
5. ✅ Build CRM variant: `bb scripts/build.clj crm`
6. ✅ Share variants with community!

---

**Questions?** See [MODULARIZATION_PLAN.md](MODULARIZATION_PLAN.md) for complete details.

**Issues?** Open an issue on GitHub.

🎉 **Welcome to modular template development!**
