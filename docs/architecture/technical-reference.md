# Technical Reference

Format and build reference for the Logseq Schema Library. Counts of classes and properties are printed by `bb build`; they are not repeated here.

## Contents

- [Overview](#overview)
- [Repository structure](#repository-structure)
- [Idents](#idents)
- [EDN format](#edn-format)
- [Presets](#presets)
- [Build](#build)
- [Validation](#validation)
- [Common tasks](#common-tasks)
- [Constraints](#constraints)
- [Troubleshooting](#troubleshooting)

---

## Overview

The library is Schema.org vocabulary expressed as Logseq DB "graph ontology" EDN: classes (Tana-style supertags) and the properties they carry. You edit module files under `source/`; `bb build` merges them into two release files:

| Build output | Released as | Used for |
|--------------|-------------|----------|
| `build/schema-library.edn` | `schema-library.edn` | Import via Logseq **Import -> EDN to DB Graph** |
| `build/schema-presets.edn` | `schema-presets.edn` | Role presets, read by the Ontology Sync plugin together with the library |

## Repository structure

```
source/<module>/classes.edn      {:classes {ident definition ...}}
source/<module>/properties.edn   {:properties {ident definition ...}}
source/presets/<id>.edn          {:id :name :description :classes {class [props]}}
src/template_graph/
  edn_io.clj                     read/write EDN, list module files
  library.clj                    merge modules, normalise property order
  presets.clj                    read presets, write presets EDN
  validate.clj, vocab.clj        validation rules, Schema.org vocabulary loader
scripts/build.clj, validate.clj  bb build / bb validate
scripts/ci/                      bb check-import support (nbb-logseq)
test/template_graph/             unit tests (bb test)
vendor/schemaorg-current-https.json   vocabulary used by validation
build/                           generated, git-ignored
```

Modules group classes by theme (person, organization, event, place, creative-work, product, action, intangible, health, misc, base) and `common` holds shared properties. A module may have `classes.edn`, `properties.edn`, or both.

## Idents

| Ident | Use |
|-------|-----|
| `:schema.class/<Name>` | A class that exists in Schema.org (exact case) |
| `:schema.property/<name>` | A property that exists in Schema.org (exact case) |
| `:custom.class/<Name>` | A class that does not exist in Schema.org |
| `:custom.property/<name>` | A property that does not exist in Schema.org |

- Every `schema.*` entry carries `:schema.property/url` (`https://schema.org/<Name>`); `custom.*` entries do not.
- Idents are fixed. No random suffixes, no `:user.*`; validation rejects `:user.*`.
- Never rename a released ident; importing a newer release relies on stable idents to update in place.
- `:logseq.property/*` keys are Logseq built-ins and are used as-is.

## EDN format

A module file holds one section; the merged library holds both.

```clojure
{:properties
 {:schema.property/email
  {:db/cardinality :db.cardinality/one        ; or :db.cardinality/many
   :logseq.property/type :default             ; :node, :date, :url, :number, ...
   :block/title "email"
   :build/property-classes [:schema.class/Person]
   :build/properties
   {:logseq.property/icon {:id "email", :type :emoji}
    :logseq.property/description "Email address."
    :schema.property/url "https://schema.org/email"}}}

 :classes
 {:schema.class/Person
  {:block/title "Person"
   :build/class-properties [:schema.property/email]
   :build/class-extends [:schema.class/Thing]
   :build/properties
   {:logseq.property/description "A person (alive, dead, undead, or fictional)."
    :schema.property/url "https://schema.org/Person"}}}}
```

### Property keys

- `:db/cardinality` - `:db.cardinality/one` or `:db.cardinality/many`
- `:logseq.property/type` - `:default` (text), `:node` (page links), `:date`, `:url`, `:number`, and others Logseq supports
- `:block/title` - display name
- `:build/property-classes` - classes the property is attached to
- `:build/properties` - icon, description, `:schema.property/url`, flags such as `:logseq.property/exclude-from-graph-view`

### Class keys

- `:block/title` - display name
- `:build/class-properties` - property idents the class brings directly
- `:build/class-extends` - parent classes (inheritance)
- `:build/properties` - icon, description, `:schema.property/url`

### Added by the build

`bb build` adds `:logseq.db.sqlite.export/export-type :graph-ontology` and `:schema-library/version` (from `package.json`). Do not put them in module files.

## Presets

`source/presets/<id>.edn`:

```clojure
{:id "crm"
 :name "CRM"
 :description "Customer relationship management"
 :classes {:schema.class/Person [:schema.property/email]
           :custom.class/BusinessPerson []}}
```

Each preset lists the classes in a role and, per class, the properties the preset brings. A preset may list only properties attached **directly** to that class. `bb build` writes all presets to `build/schema-presets.edn` as `{:schema-library/version ... :presets [...]}`. See [source/presets/README.md](../../source/presets/README.md).

## Build

`bb build`:

1. Reads every module file under `source/` (not presets) and merges them. If the same ident is defined differently in two files it throws `conflicting definitions`.
2. Normalises each class's `:build/class-properties` to one global order (rank by first appearance walking classes from the root down, then by ident). Logseq import requires every class to order shared properties consistently.
3. Adds the export-type marker and version, writes `build/schema-library.edn`.
4. Reads `source/presets/*.edn`, writes `build/schema-presets.edn`.
5. Prints class count, property count and version.

## Validation

`bb validate` checks the build against Schema.org (names, namespaces, references, case collisions, property order, presets). Full list: [validation-reference.md](../developer-guide/validation-reference.md).

`LOGSEQ_DIR=/path/to/logseq bb check-import` imports the library into a fresh Logseq graph using Logseq's own importer.

## Common tasks

### Add a class

1. Choose the module under `source/`.
2. Add the class with `:block/title`, `:build/class-properties`, `:build/class-extends`, description and `:schema.property/url`.
3. Make sure every listed property and parent exists.
4. `bb test && bb build && bb validate`

### Add a property

1. Add it to the module's `properties.edn` with cardinality, type, title, description and url.
2. Add its ident to `:build/class-properties` of each class that carries it, and the classes to `:build/property-classes`.
3. `bb test && bb build && bb validate`

### Add a non-Schema.org term

Use `:custom.class/...` or `:custom.property/...`, with a name that Schema.org does not define, and no `:schema.property/url`.

### Inspect

```bash
scripts/analyze.sh                          # counts and class list for build/schema-library.edn
scripts/analyze.sh source/person/classes.edn Person
grep -n ":schema.class/Person" -A12 source/person/classes.edn
```

## Constraints

1. Fixed idents only (`schema.*`, `custom.*`).
2. Changing cardinality or type changes storage and UI behaviour; do it deliberately.
3. Do not edit `build/`; it is generated.
4. Keep presets to direct properties of each class.
5. Never hard-code library counts in documentation; run `bb build`.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `conflicting definitions` | The same ident appears with different content in two modules; keep one |
| `bb validate` errors | See [validation-reference.md](../developer-guide/validation-reference.md) |
| Import fails in Logseq | Run `bb check-import` and read the error; common causes are an unknown reference or inconsistent property order |

## Related

- [Quick Start](../../QUICK_START.md)
- [CI/CD Pipeline](../developer-guide/ci-cd-pipeline.md)
- [Logseq docs](https://docs.logseq.com), [Schema.org](https://schema.org), [EDN spec](https://github.com/edn-format/edn)
