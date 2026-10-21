# Preset Template

Copy this file's example to `source/presets/<id>.edn` to create a new preset. See [source/presets/README.md](../source/presets/README.md) for the rules.

## What a preset is

A preset describes a role: the classes it includes and, per class, the properties it brings. Presets are published in `schema-presets.edn` and read by the Ontology Sync plugin.

## Template

```clojure
{:id "my-role"
 :name "My Role"
 :description "Brief description of the use case"
 :classes
 {:schema.class/Person [:schema.property/email :schema.property/jobTitle]
  :schema.class/Event [:schema.property/startDate :schema.property/location]
  :custom.class/FamilyGroup []}}
```

### Fields

- `:id` (string, required) - must match the file name
- `:name` (string, required) - display name
- `:description` (string, required) - one-line use case
- `:classes` (map, required) - class ident -> vector of property idents

### Rules

- Every class ident must exist in the library (`:schema.class/*` or `:custom.class/*`).
- Every property listed for a class must be in that class's own `:build/class-properties`. Inherited properties are not allowed.
- No `:user.*` idents.

## Steps

1. Find class and property idents in `source/<module>/classes.edn` and `properties.edn`.
2. Create `source/presets/<id>.edn`.
3. Run `bb test && bb build && bb validate`.
4. Commit: `git commit -m "feat(presets): add my-role preset"`

## Checklist

- [ ] File is `source/presets/<id>.edn` and `:id` matches
- [ ] `bb build` lists the preset in `build/schema-presets.edn`
- [ ] `bb validate` prints `Valid`
- [ ] Row added to `source/presets/README.md`
