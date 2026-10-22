# Create Preset Command

Guide the user through creating a role preset for the schema library.

## What This Does

Creates `source/presets/<id>.edn`: a role described as a set of classes and, per class, the properties the role brings. Presets are published in `schema-presets.edn` and read by the Ontology Sync plugin. There are no per-preset build files.

## Format

```clojure
{:id "sales-pipeline"
 :name "Sales Pipeline"
 :description "Sales pipeline management with contacts and deals"
 :classes
 {:schema.class/Person [:schema.property/email :schema.property/jobTitle]
  :schema.class/Organization [:schema.property/legalName]
  :schema.class/Offer []}}
```

Rules (enforced by `bb validate`):
- `:id` matches the file name (lowercase, hyphens, no spaces; not an existing id)
- every class exists in the library
- every property listed for a class is in that class's own `:build/class-properties` (direct, not inherited)

## Process

### 1. Show existing presets

List `source/presets/*.edn` (ids and descriptions). Do not quote class or property counts from memory; run `bb build` and read `build/schema-presets.edn` if counts are needed.

### 2. Gather information

Ask for:
- preset id and display name
- one-line description
- which classes to include (search `source/*/classes.edn`; suggest related classes)
- for each class, which of its direct properties to bring (show the class's `:build/class-properties`)

### 3. Write the file

Create `source/presets/<id>.edn` in the format above, with idents exactly as they appear in the source files.

### 4. Check

```bash
bb test && bb build && bb validate
```

Show any error and fix the preset. Confirm the preset appears in `build/schema-presets.edn`.

### 5. Document and commit

- Add a row to `source/presets/README.md`
- `git add source/presets && git commit -m "feat(presets): add <id> preset"`

## Using the preset

Releases publish exactly `schema-library.edn` and `schema-presets.edn`. Users build the role with the Ontology Sync plugin, which reads both.

## Related

- `source/presets/README.md`
- `.github/PRESET_TEMPLATE.md`
- `docs/developer-guide/validation-reference.md`
