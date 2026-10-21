# Presets

A preset describes a role: which classes it includes and which properties each class brings. Presets are published in `schema-presets.edn` and read by the [Ontology Sync plugin](https://github.com/C0ntr0lledCha0s/logseq-ontology-sync-plugin) to build a role-shaped graph from `schema-library.edn`.

## Format

One file per preset, `source/presets/<id>.edn`:

```clojure
{:id "crm"
 :name "CRM"
 :description "Customer relationship management - Person, Organization, and Contact"
 :classes
 {:schema.class/Person [:schema.property/email :schema.property/jobTitle]
  :schema.class/Organization [:schema.property/legalName]
  :custom.class/BusinessPerson []}}
```

- `:id` - matches the file name
- `:name`, `:description` - display text
- `:classes` - map of class ident to the vector of property idents the preset brings for that class (an empty vector brings the class with no properties)

Rules, enforced by `bb validate`:

- every class must exist in the library
- every listed property must be attached **directly** to that class (in its `:build/class-properties`), not inherited from a parent

## Available presets

| id | Purpose |
|----|---------|
| `full` | Every class in the library |
| `crm` | Customer relationship management: people, organizations, contacts |
| `research` | Academic and research notes: books, articles, authors, publications |
| `events` | Event management: meetings, conferences, schedules |
| `content` | Content creators: videos, articles, images, media |
| `student-life` | Student course and assignment tracking |

Class and property counts per preset are not listed here; read them from `build/schema-presets.edn` after `bb build`.

## Editing a preset

1. Edit `source/presets/<id>.edn` (add a class key, or add property idents to a class's vector).
2. Run `bb test && bb build && bb validate`.
3. Commit: `git commit -m "feat(presets): add Recipe to the content preset"`

## Adding a preset

1. Create `source/presets/<id>.edn` in the format above.
2. Run `bb build`; the new preset appears in `build/schema-presets.edn`.
3. Run `bb validate`.
4. Add a row to the table above.

Use `.github/PRESET_TEMPLATE.md` as a copyable starting point.

## Using a preset

Releases publish only `schema-library.edn` and `schema-presets.edn`. Per-preset import files are not built. To get a role-shaped graph, use the Ontology Sync plugin, which reads both files. To import everything, use `schema-library.edn` through Settings -> Import -> **EDN to DB Graph**.
