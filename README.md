# Logseq Schema Library

A Schema.org schema library for **Logseq Database** graphs. It brings Tana-style supertags to Logseq: classes (`#Person`, `#Organization`, `#Event`, ...) that carry their own properties, using standard Schema.org names.

**Quick Links:** [Quick Start](QUICK_START.md) | [Documentation](docs/README.md) | [Contributing](CONTRIBUTING.md)

---

## What you get

Each release publishes exactly two files:

| File | Contents |
|------|----------|
| `schema-library.edn` | Every class and property, with fixed idents (`:schema.class/Person`, `:schema.property/email`, `:custom.class/FamilyGroup`). Importable into Logseq. |
| `schema-presets.edn` | Role presets (full, crm, research, events, content, student-life). Each lists the classes in the role and, per class, the properties it brings. Read by the [Ontology Sync plugin](https://github.com/C0ntr0lledCha0s/logseq-ontology-sync-plugin). |

The class and property counts for the current source are printed by `bb build`.

- Every `schema.*` entry carries `:schema.property/url` pointing at its Schema.org definition.
- Terms that Schema.org does not define live under `custom.class/*` and `custom.property/*`.
- Idents are fixed, so re-importing a newer release updates the same entities instead of creating duplicates.

## Use it

1. Download `schema-library.edn` from the [latest release](https://github.com/C0ntr0lledCha0s/logseq-template-graph/releases/latest). Do not download the "Source code" archives.
2. In Logseq DB: Settings -> Import -> **EDN to DB Graph**, and select the file.
3. Tag pages with the imported classes. `#Person` gives you email, jobTitle, birthDate, and so on.

To build a smaller, role-shaped graph instead, use the Ontology Sync plugin, which reads both `schema-library.edn` and `schema-presets.edn`.

Details: [QUICK_START.md](QUICK_START.md).

## Develop it

Curating means editing the EDN under `source/` directly. There is no export step from a Logseq graph.

```bash
git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
cd logseq-template-graph
npm install                  # git hooks and changelog tooling (optional)

# edit source/<module>/classes.edn, properties.edn, source/presets/<id>.edn

bb test && bb build && bb validate && bb publish-library   # then commit library/
```

- `bb test` runs the unit tests.
- `bb build` merges `source/` into `build/schema-library.edn` and `build/schema-presets.edn` and prints the counts.
- `bb validate` checks the build against the vendored Schema.org vocabulary (`vendor/`).
- `bb publish-library` copies the build into `library/`; commit it. `library/` is generated (do not hand-edit) and is what the Ontology Sync plugin downloads. CI runs `bb check-library` to catch a stale copy.
- `LOGSEQ_DIR=/path/to/logseq bb check-import` imports the build into a fresh Logseq graph, as CI does.

Requires [Babashka](https://babashka.org/). See [CONTRIBUTING.md](CONTRIBUTING.md) for commit conventions and the release flow, and [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md) for the EDN format.

## Repository layout

```
source/<module>/classes.edn      class definitions, grouped by module
source/<module>/properties.edn   property definitions
source/presets/<id>.edn          {:id :name :description :classes {class [props]}}
src/template_graph/              build, merge and validation code
scripts/build.clj, validate.clj  the bb build / bb validate entry points
build/                           generated output (git-ignored)
vendor/                          Schema.org vocabulary used by validation
```

## Documentation

- [Documentation portal](docs/README.md) and [DOCS_INDEX.md](DOCS_INDEX.md)
- [Quick Start](QUICK_START.md)
- [Technical Reference](docs/architecture/technical-reference.md)
- [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md)
- [Validation Reference](docs/developer-guide/validation-reference.md)
- [Conventional Commits Guide](docs/developer-guide/conventional-commits-guide.md)

## Learn more

- [Logseq](https://docs.logseq.com) and its [DB version guide](https://github.com/logseq/docs/blob/master/db-version.md)
- [Schema.org](https://schema.org)
- [Tana supertags](https://tana.inc/docs/supertags), the inspiration

## License

MIT, see [LICENSE](LICENSE).
