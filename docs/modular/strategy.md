# Modularization Plan for 15,422-Line EDN Template

## 📊 Current Situation Analysis

### Stats (Verified)
```
Total lines:    15,422 ✅ MASSIVE GROWTH!
Properties:     1,033  ✅ (was 129)
Classes:        632    ✅ (was 47)
```

### Problem Statement
**This absolutely justifies modularization now!**

Original assessment was based on 1,214 lines. At 15,422 lines:
- ❌ Impossible to navigate efficiently
- ❌ Git diffs are meaningless (hundreds of lines changed)
- ❌ Merge conflicts inevitable with multiple contributors
- ❌ Performance issues in editors
- ❌ Can't create template variants (CRM, Research, etc.)

---

## 🎯 Recommended Approach

### Strategy: **Hybrid Logseq-Inspired + Babashka Build**

Inspired by existing tools:
1. **logseq-modules** pattern (modular → compiled)
2. **Babashka** for EDN manipulation
3. **edamame** parser for location-aware splitting
4. **Logseq's graph-parser** as reference architecture

---

## 🛠️ Implementation Plan

### Phase 1: Initial Split (Manual, One-Time)

Create source structure mirroring Schema.org hierarchy:

```
source/
├── base/
│   └── Thing.edn                    # Base class
├── person/
│   ├── Person.edn                   # Class definition
│   ├── properties.edn               # All person properties
│   └── README.md                    # Documentation
├── organization/
│   ├── Organization.edn
│   ├── properties.edn
│   └── README.md
├── event/
│   ├── Event.edn
│   ├── EventSeries.edn
│   ├── BusinessMeeting.edn
│   ├── properties.edn
│   └── README.md
├── place/
│   ├── Place.edn
│   ├── properties.edn
│   └── README.md
├── creative-work/
│   ├── CreativeWork.edn
│   ├── Book.edn
│   ├── Article.edn
│   ├── properties.edn
│   └── README.md
└── presets/
    ├── full.edn                     # Include everything
    ├── crm.edn                      # Person + Org + Contact
    ├── research.edn                 # Book + Article + Author
    └── content.edn                  # CreativeWork types
```

### Phase 2: Automated Splitting Script

Use **Babashka + edamame** to split the monolith:

**`scripts/split.clj`:**

```clojure
#!/usr/bin/env bb

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.string :as str]
         '[clojure.pprint :refer [pprint]])

(defn read-edn-file [path]
  "Read and parse EDN file"
  (-> path slurp edn/read-string))

(defn class-name->category [class-title]
  "Map class name to source category"
  (cond
    (str/includes? class-title "Person") "person"
    (str/includes? class-title "Organization") "organization"
    (str/includes? class-title "Event") "event"
    (str/includes? class-title "Place") "place"
    (str/includes? class-title "Creative") "creative-work"
    (str/includes? class-title "Book") "creative-work"
    (str/includes? class-title "Article") "creative-work"
    (str/includes? class-title "Thing") "base"
    :else "misc"))

(defn property-class->category [prop-classes]
  "Determine category based on property's associated classes"
  (let [class-ids (map name prop-classes)]
    (cond
      (some #(str/includes? % "Person") class-ids) "person"
      (some #(str/includes? % "Organization") class-ids) "organization"
      (some #(str/includes? % "Event") class-ids) "event"
      (some #(str/includes? % "Place") class-ids) "place"
      :else "common")))

(defn split-properties [properties]
  "Split properties by category"
  (group-by
    (fn [[prop-id prop-def]]
      (property-class->category
        (get-in prop-def [:build/property-classes])))
    properties))

(defn split-classes [classes]
  "Split classes by category"
  (group-by
    (fn [[class-id class-def]]
      (class-name->category (:block/title class-def)))
    classes))

(defn write-module [category type data]
  "Write module file to source directory"
  (let [dir (str "source/" category)
        file (str dir "/" type ".edn")]
    (io/make-parents file)
    (spit file (with-out-str (pprint data)))
    (println "✅" file)))

(defn split-template [input-file]
  "Main split function"
  (println "🔪 Splitting" input-file "into modules...")
  (let [template (read-edn-file input-file)
        properties (:properties template)
        classes (:classes template)]

    ;; Split properties by category
    (println "\n📦 Splitting properties...")
    (doseq [[category props] (split-properties properties)]
      (write-module category "properties" {:properties (into {} props)}))

    ;; Split classes by category
    (println "\n📦 Splitting classes...")
    (doseq [[category clss] (split-classes classes)]
      (write-module category "classes" {:classes (into {} clss)}))

    (println "\n✅ Split complete!")))

;; Run
(split-template "logseq_db_Templates.edn")
```

### Phase 3: Merge/Build Script

**`scripts/build.clj`:**

```clojure
#!/usr/bin/env bb

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.pprint :refer [pprint]])

(defn read-edn-file [path]
  (-> path slurp edn/read-string))

(defn find-modules [dir pattern]
  "Find all module files matching pattern"
  (->> (file-seq (io/file dir))
       (filter #(and (.isFile %)
                     (re-find pattern (.getName %))))
       (map str)))

(defn load-preset [preset-file]
  "Load preset configuration"
  (-> preset-file read-edn-file :include))

(defn merge-modules [modules]
  "Deep merge all module EDN files"
  (reduce
    (fn [acc module-file]
      (let [module-data (read-edn-file module-file)]
        (merge-with merge acc module-data)))
    {}
    modules))

(defn build-template [preset output]
  "Build template from preset"
  (println "🔨 Building template from preset:" preset)

  (let [preset-config (load-preset (str "source/presets/" preset ".edn"))

        ;; Collect all matching modules
        all-modules (concat
                      (find-modules "source" #"properties\.edn")
                      (find-modules "source" #"classes\.edn"))

        ;; Filter based on preset (if specified)
        selected-modules (if preset-config
                           (filter #(some (fn [p] (str/includes? % p))
                                          preset-config)
                                   all-modules)
                           all-modules)

        ;; Merge all modules
        merged (merge-modules selected-modules)

        ;; Add export marker
        template (assoc merged
                   :logseq.db.sqlite.export/export-type
                   :graph-ontology)]

    ;; Write output
    (io/make-parents output)
    (spit output (with-out-str (pprint template)))
    (println "✅ Built:" output)

    ;; Stats
    (let [prop-count (count (:properties template))
          class-count (count (:classes template))]
      (println "📊 Properties:" prop-count)
      (println "📊 Classes:" class-count))))

;; CLI
(let [[preset output] *command-line-args*
      preset (or preset "full")
      output (or output (str "build/logseq_db_Templates_" preset ".edn"))]
  (build-template preset output))
```

### Phase 4: Preset Configurations

**`source/presets/full.edn`:**
```clojure
{:name "Full Template"
 :description "All classes and properties"
 :include ["person" "organization" "event" "place" "creative-work" "base"]}
```

**`source/presets/crm.edn`:**
```clojure
{:name "CRM Template"
 :description "Customer relationship management"
 :include ["person" "organization" "base"]}
```

**`source/presets/research.edn`:**
```clojure
{:name "Research Template"
 :description "Academic and research notes"
 :include ["person" "organization" "creative-work" "base"]}
```

---

## 📦 Available GitHub Tools

### 1. **edamame** (Recommended for parsing)
- **URL**: https://github.com/borkdude/edamame
- **Use**: Parse EDN with location metadata
- **Why**: Industry-standard, works with Babashka

### 2. **logseq-modules** (Inspiration)
- **URL**: https://github.com/quornian/logseq-modules
- **Use**: Reference for modular → compiled pattern
- **Why**: Proven pattern for Logseq ecosystem

### 3. **clj-mergetool** (Git integration)
- **URL**: https://github.com/kurtharriger/clj-mergetool
- **Use**: Semantic merging of EDN files
- **Why**: Better git conflict resolution

### 4. **Logseq graph-parser** (Reference)
- **URL**: https://github.com/logseq/logseq/tree/master/deps/graph-parser
- **Use**: Study how Logseq itself parses graphs
- **Why**: Align with Logseq's internal structure

---

## 🚀 New Workflow

### Development Workflow

```bash
# 1. Work in Logseq
# ... make changes to classes/properties ...

# 2. Export from Logseq (unchanged)
./scripts/export.sh

# 3. Split into modules (NEW)
bb scripts/split.clj

# 4. Review modular changes
git diff source/person/properties.edn

# 5. Build variants (NEW)
bb scripts/build.clj full      # Full template
bb scripts/build.clj crm       # CRM only
bb scripts/build.clj research  # Research only

# 6. Test builds
./scripts/validate.sh build/logseq_db_Templates_full.edn
./scripts/validate.sh build/logseq_db_Templates_crm.edn

# 7. Commit
git add source/ build/
git commit -m "feat: add Recipe class to creative-work"
git push
```

### What Gets Committed

```
source/              ← Modular source (human-edited)
├── person/
├── organization/
└── ...

build/               ← Compiled artifacts (git-ignored or committed)
├── logseq_db_Templates_full.edn
├── logseq_db_Templates_crm.edn
└── logseq_db_Templates_research.edn

scripts/
├── split.clj        ← NEW
├── build.clj        ← NEW
├── export.sh        ← Existing
└── validate.sh      ← Existing
```

---

## 📈 Benefits

### Before (15,422-line monolith)
```
❌ logseq_db_Templates.edn (15,422 lines)
❌ Edit anywhere → full file diff
❌ Merge conflicts everywhere
❌ Can't create variants
❌ Impossible to navigate
```

### After (Modular)
```
✅ source/person/properties.edn (150 lines)
✅ source/person/Person.edn (80 lines)
✅ Clear git diffs per component
✅ Multiple contributors, no conflicts
✅ Build CRM, Research, Content variants
✅ Easy navigation and documentation
```

### Git Diff Example

**Before:**
```diff
# logseq_db_Templates.edn changed 450 lines
# (impossible to review)
```

**After:**
```diff
# source/person/properties.edn changed 15 lines
+ :user.property/pronouns-xyz123
+  {:db/cardinality :db.cardinality/one
+   :logseq.property/type :default
+   :block/title "pronouns"
+   ...}
```

---

## 🎯 Implementation Timeline

### Week 1: Setup Infrastructure
- [ ] Install Babashka
- [ ] Create `scripts/split.clj`
- [ ] Create `scripts/build.clj`
- [ ] Test on small subset

### Week 2: Initial Split
- [ ] Run `split.clj` on full template
- [ ] Review generated structure
- [ ] Manual cleanup and organization
- [ ] Add per-module README files

### Week 3: Validation & Testing
- [ ] Build all variants
- [ ] Test imports in Logseq
- [ ] Validate property references
- [ ] Compare with original

### Week 4: Documentation & Rollout
- [ ] Update DEV_WORKFLOW.md
- [ ] Create MODULAR_GUIDE.md
- [ ] Migration guide for contributors
- [ ] Announce to community

---

## 🛡️ Risk Mitigation

### Keep Original as Backup
```bash
# Archive the monolith
mkdir archive/pre-modular
cp logseq_db_Templates*.edn archive/pre-modular/
git tag v1.0-monolith
```

### Validation Strategy
```bash
# After split/build, ensure equivalence
bb scripts/build.clj full build/rebuilt.edn
diff logseq_db_Templates.edn build/rebuilt.edn

# Test import in clean Logseq graph
# Import original → Graph A
# Import rebuilt → Graph B
# Compare: should be identical
```

### Gradual Rollout
1. **Week 1-2**: Keep both systems (monolith + modular)
2. **Week 3-4**: Build from modules, compare
3. **Week 5+**: Fully switch to modular

---

## 💡 Quick Start Script

**`scripts/init-modular.sh`:**

```bash
#!/bin/bash

echo "🔧 Initializing modular structure..."

# Install Babashka (if not present)
if ! command -v bb &> /dev/null; then
    echo "Installing Babashka..."
    bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
fi

# Create directory structure
mkdir -p source/{base,person,organization,event,place,creative-work,presets}
mkdir -p build

# Copy split and build scripts
chmod +x scripts/split.clj
chmod +x scripts/build.clj

# Archive original
mkdir -p archive/pre-modular
cp logseq_db_Templates.edn archive/pre-modular/
git tag v1.0-monolith

# Run initial split
echo "🔪 Splitting template into modules..."
bb scripts/split.clj

echo "✅ Modular structure initialized!"
echo ""
echo "Next steps:"
echo "  1. Review: tree source/"
echo "  2. Build: bb scripts/build.clj full"
echo "  3. Test: ./scripts/validate.sh build/logseq_db_Templates_full.edn"
```

---

## 📚 Related Resources

- **Babashka Book**: https://book.babashka.org/
- **EDN Format**: https://github.com/edn-format/edn
- **Logseq Modules Pattern**: https://github.com/quornian/logseq-modules
- **Schema.org Structure**: https://schema.org/docs/full.html

---

## ✅ Success Criteria

Modularization is successful when:

- [ ] Source files average < 200 lines each
- [ ] Git diffs show < 50 lines per change
- [ ] Can build 3+ variants (full, crm, research)
- [ ] Build time < 5 seconds
- [ ] Imports match original exactly
- [ ] Documentation per module
- [ ] 3+ contributors without conflicts

---

## 🎉 Conclusion

With **15,422 lines, 1,033 properties, and 632 classes**, modularization is not just nice-to-have—it's **essential**.

The Babashka-based approach with split/build scripts gives you:
- ✅ Clean separation of concerns
- ✅ Multiple template variants
- ✅ Professional git workflow
- ✅ Scalability to 10,000+ classes
- ✅ Community contribution model

**Next step**: Run `./scripts/init-modular.sh` and start the transformation!
