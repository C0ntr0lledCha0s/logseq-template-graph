# Validation Reference

What `bb validate` checks, what each message means, and how to fix it.

## Running it

```bash
bb build      # validation reads build/, so build first
bb validate   # prints "Valid", or one line per error and "<n> errors" (exit code 1)
```

`bb validate` (`scripts/validate.clj`) reads `build/schema-library.edn` and `build/schema-presets.edn` and checks them against the vendored Schema.org vocabulary `vendor/schemaorg-current-https.json`. The rules live in `src/template_graph/validate.clj` and are unit-tested in `test/template_graph/validate_test.clj`. CI runs it on every PR and before every release; the pre-push hook runs it too.

## Library checks

| Message | Meaning | Fix |
|---------|---------|-----|
| `user ident not allowed: :user.<kind>/...` | A `:user.*` ident remains anywhere in the library. Released idents are fixed `schema.*` / `custom.*` names. | Rename to `:schema.*` (if the name is in Schema.org) or `:custom.*` |
| `<ident> is in :classes with a mismatched namespace` | A property ident is under `:classes`, or a class ident under `:properties`, or the namespace is not one of `schema.class`, `custom.class`, `schema.property`, `custom.property` | Move the entry or fix the namespace |
| `<ident> class-properties references unknown ident <x>` | A class lists a property that is not defined | Define the property, or fix the ident |
| `<ident> class-extends references unknown ident <x>` | A class extends a class that is not defined | Define the parent, or fix the ident |
| `<ident> build/properties references unknown ident <x>` | A key in `:build/properties` is a `schema.*` or `custom.*` ident that is not defined (`:logseq.property/*` keys are exempt) | Define it or remove the key |
| `<ident> property-classes references unknown ident <x>` | A property names a class that is not defined | Define the class, or fix the ident |
| `<ident> is not a Schema.org class` / `... property` | A `schema.*` ident whose name is not in Schema.org (exact case) | Use `custom.*`, or correct the name |
| `<ident> is custom but Schema.org has a class named <n>` / `... property ...` | A `custom.*` ident whose name matches a Schema.org term (any case) | Use `schema.*` |
| `case collision among class idents: ...` | Two idents of the same kind differ only by case | Keep one |
| `inconsistent property order: <x> and <y> are ordered differently in <classes>` | Two classes list the same pair of properties in opposite orders. Logseq import requires consistent order. | `bb build` normalises order to one global order, so this only fires on hand-written library data; rebuild |

## Preset checks

| Message | Meaning | Fix |
|---------|---------|-----|
| `preset <id>: unknown class <ident>` | The preset names a class that is not in the library | Fix the ident or add the class |
| `preset <id>: <prop> is not a direct property of <class>` | The preset lists a property that is not in that class's own `:build/class-properties` (for example one inherited from a parent) | List the property under the class that actually declares it, or drop it |

## Conventions not checked by `bb validate`

- Every `schema.*` entry carries `:schema.property/url` (`https://schema.org/<Name>`).
- `custom.*` entries do not carry that url.

## Import check

`bb validate` checks the data, not Logseq's importer. `LOGSEQ_DIR=/path/to/logseq bb check-import` imports `build/schema-library.edn` into a fresh graph with Logseq's own code; CI runs it for PRs and releases.

## Related

- [Technical Reference](../architecture/technical-reference.md)
- [CI/CD Pipeline](ci-cd-pipeline.md)
- [CONTRIBUTING.md](../../CONTRIBUTING.md)
