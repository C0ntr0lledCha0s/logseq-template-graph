# Event Module

Part of the schema library source. `bb build` merges every module under `source/` into `build/schema-library.edn`.

## Files

- `classes.edn` - Class definitions (`:classes`)
- `properties.edn` - Property definitions (`:properties`)

## Conventions

- Idents are fixed: `:schema.class/*` and `:schema.property/*` for Schema.org terms, `:custom.class/*` and `:custom.property/*` for everything else.
- Every `schema.*` entry carries `:schema.property/url`.
- Edit these files directly, then run `bb test && bb build && bb validate`. Class and property counts are printed by `bb build`.

Schema.org reference: https://schema.org/
