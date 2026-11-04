# Relationship Module

Part of the schema library source. `bb build` merges every module under `source/` into `build/schema-library.edn`.

Roles a person or organisation plays towards you. Tag them **alongside** `#Person` or `#Organization`, for example `#Organization #Client`.

- `Relationship` - abstract root holding `relationship-status` (prospect, active, former), `key-relationship-holder` and `operational-relationship-holder`. Never tagged directly.
- `Customer` - shown as **Client**. Rename the tag in your graph to suit your sector (Customer, Member, Donor).
- `Supplier`

Relationship holders point to `TeamMember` (Employee or Volunteer, in the person module).

Closed-value UUIDs are UUIDv5 in the URL namespace of `https://github.com/C0ntr0lledCha0s/logseq-template-graph/<property ident>/<value>`.

## Files

- `classes.edn` - Class definitions (`:classes`)
- `properties.edn` - Property definitions (`:properties`)

## Conventions

- Idents are fixed: `:schema.class/*` and `:schema.property/*` for Schema.org terms, `:custom.class/*` and `:custom.property/*` for everything else.
- Every `schema.*` entry carries `:schema.property/url`.
- Edit these files directly, then run `bb test && bb build && bb validate`. Class and property counts are printed by `bb build`.

Schema.org reference: https://schema.org/
