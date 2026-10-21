# Schema Library Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn logseq-template-graph into a library. It publishes one `schema-library.edn` (every curated class and property, under fixed `schema.*` / `custom.*` names) and one `schema-presets.edn` (role bundles listed at class and property level).

**Architecture:**
- A one-off, tested conversion rewrites `source/` from random-suffix `user.*` names to `schema.*` / `custom.*` names.
- After that, `source/` is hand-edited EDN.
- Pure logic lives in Babashka namespaces under `src/template_graph/`, tested with `clojure.test`. Thin CLI scripts call it.
- CI builds both artifacts and validates them against the vendored Schema.org vocabulary.
- CI then proves they import into a fresh Logseq DB graph, using Logseq's own import code from a pinned logseq/logseq checkout.

**Tech Stack:** Babashka (bb 1.13+), Clojure EDN, `clojure.test`, GitHub Actions, nbb-logseq (CI import check only).

**Spec:** `../logseq-ontology-sync-plugin/docs/superpowers/specs/2026-10-21-role-builder-design.md` (Part 1). This plan is Plan A. The plugin's Plan B (`../logseq-ontology-sync-plugin/docs/superpowers/plans/2026-10-21-role-builder-plugin.md`) consumes this plan's artifacts.

## Global Constraints

**Names**
- Class idents are `:schema.class/<SchemaOrgName>`; property idents are `:schema.property/<schemaOrgName>`. Use Schema.org's exact spelling and case.
- Non-Schema.org entries are `:custom.class/<Name>` / `:custom.property/<name>`.
- No `:user.*` ident may remain anywhere in `source/` or `build/`.
- Renames:
  - class `LivestyleModification` → `:schema.class/LifestyleModification`
  - property `Parents` → `:schema.property/parent`
  - property `Event` → `:schema.property/event`. The class `:schema.class/Event` also exists and stays.
  - property `Rating` → `:custom.property/rating`
  - `areas`, `project`, `readBy` → `:custom.property/areas`, `:custom.property/project`, `:custom.property/readBy`
  - class `Resource` → `:custom.class/Resource`
- Drop: property `NewTest`; property `sourceSchema` and every reference to it.

**Content of each entry**
- Every `schema.*` class and property carries `:schema.property/url "https://schema.org/<Name>"` in `:build/properties`. `custom.*` entries get no url.
- Keep curation unchanged: class-properties, class-extends, property-classes, `:logseq.property/type`, `:db/cardinality`, icons, `:logseq.property/ui-position`, descriptions, `:logseq.property/exclude-from-graph-view`.
- Descriptions keep `[[Name]]` text, as upstream does. Remove the deterministic UUID rewrite of descriptions.

**Output files**
- Write EDN with `(binding [*print-namespace-maps* false] (pprint ...))`, so no `#:ns{}` literals are produced.
- `build/schema-library.edn`: `{:properties {...} :classes {...} :logseq.db.sqlite.export/export-type :graph-ontology :schema-library/version "<package.json version>"}`. The extra version key was verified accepted by Logseq's `build-import`.
- `build/schema-presets.edn`: `{:schema-library/version "<same>" :presets [{:id "crm" :name "CRM" :description "..." :classes {:schema.class/Person [:schema.property/email ...]}} ...]}`, sorted by `:id`.

**Process**
- Commits follow this repo's conventional-commit config (`git-conventional-commits.yaml`), e.g. `feat(build): ...`, `refactor(templates): ...`.
- The name change is breaking, so the release is `v2.0.0`. Tagging is done by the user (Task 8).

## Review Focus

1. **A reference inside `:build/properties` values** (e.g. a property-valued key, or `[:block/uuid #uuid ...]` refs like the old `sourceSchema`) must be rewritten or dropped. A dangling ref is a broken import. Test it in Task 1 (`rewrites-build-properties-keys`) and catch any leftover in Task 4 (`no-dangling-refs`).
2. **Two old idents mapping to the same new ident** (e.g. a duplicated `email-XXXX` in two modules) must be merged deliberately or fail loudly, not silently overwritten. Test in Task 1 (`duplicate-targets-are-reported`).
3. **A preset listing a property under a class that only inherits it** must be rejected by validation. Test in Task 4 (`preset-inherited-property-rejected`).
4. **Re-importing the same library into a graph that already has it** must succeed with no duplicates. Covered by Task 5's second import pass.
5. **Case-only collisions within one kind** (two classes or two properties whose names differ only in case) must fail the build. A class/property pair like `Event`/`event` is allowed. Test in Task 4 (`case-collision-same-kind-fails`).

---

## File Structure

| Path | Responsibility |
|---|---|
| `bb.edn` (create) | `:paths ["src" "test"]`; tasks `test`, `convert`, `convert-presets`, `build`, `validate`, `check-import` |
| `vendor/schemaorg-current-https.json` (create) | Vendored Schema.org vocabulary (copy of `logseq-db/scripts/resources/schemaorg-current-https.json`, 1.5 MB) |
| `src/template_graph/edn_io.clj` | read/write EDN files (no namespace maps), list module files |
| `src/template_graph/vocab.clj` | load the vocabulary → sets of class and property names |
| `src/template_graph/convert.clj` | one-off ident conversion (pure) |
| `src/template_graph/library.clj` | merge modules → library map; library EDN string |
| `src/template_graph/presets.clj` | old→new preset conversion; presets EDN string |
| `src/template_graph/validate.clj` | all library and preset checks → vector of error strings |
| `scripts/convert.clj`, `scripts/build.clj`, `scripts/validate.clj` | thin CLIs over the namespaces |
| `scripts/ci/check-import.cljs` | nbb-logseq script: fresh import plus re-import |
| `test/template_graph/*_test.clj` | unit tests per namespace |
| Delete | `scripts/split.clj`, `scripts/export.sh`, `scripts/export.ps1`, `scripts/validate.sh`, `scripts/validate-refs.clj`, and any of `scripts/{add,toggle}-exclude-from-graph.clj`, `scripts/*.ps1` that hard-code `user.` names (check each with `grep -l 'user\.' scripts/*`) |

---

### Task 1: Ident conversion (pure, tested)

**Files:**
- Create: `bb.edn`, `vendor/schemaorg-current-https.json`, `src/template_graph/edn_io.clj`, `src/template_graph/vocab.clj`, `src/template_graph/convert.clj`
- Test: `test/template_graph/convert_test.clj`, `test/template_graph/vocab_test.clj`

**Interfaces:**
- Produces:
  - `(template-graph.vocab/load-vocab path) -> {:classes #{"Person" ...} :properties #{"email" ...}}`. A class is a `@graph` entry whose `@type` includes `"rdfs:Class"`; a property has `@type "rdf:Property"`; strip `schema:`.
  - `(template-graph.convert/base-name kw) -> "Person"`: the ident name before the first `-`.
  - `(template-graph.convert/ident-map modules vocab) -> {old-kw new-kw}`. `modules` is a seq of module maps (`{:classes {...}}` / `{:properties {...}}`). Dropped idents map to `::drop`.
  - `(template-graph.convert/convert-module module ident-map) -> module`: rewrites every keyword anywhere (`clojure.walk/postwalk`), removes dropped entries, removes any `:build/properties` entry keyed by a dropped ident, sets `:block/title` to the new name for renamed entries only, and adds `:schema.property/url` to `schema.*` entries lacking it.
  - `(template-graph.edn-io/write-edn! path data)`, `(template-graph.edn-io/read-edn path)` (reader for `#uuid`), `(template-graph.edn-io/module-files) -> ["source/person/classes.edn" ...]` (excludes `source/presets`).

- [ ] **Step 1: Vendor the vocabulary and add `bb.edn`.** Copy the vocab file and define bb tasks: `test` runs `clojure.test/run-all-tests` over `template-graph.*-test` and exits non-zero on failure.

- [ ] **Step 2: Write failing tests** in `convert_test.clj`, using small inline module maps and a stub vocab `{:classes #{"Thing" "Person" "Event" "LifestyleModification"} :properties #{"email" "event" "parent" "url"}}`:
  - `base-name-strips-suffix`: `(base-name :user.property/sameAs-d-nt_wFF)` → `"sameAs"`; `(base-name :user.property/superEvent-AdQv8SI-)` → `"superEvent"`.
  - `maps-schema-terms`: `:user.class/Person-cB8UklzM` → `:schema.class/Person`; `:user.property/email-UL_S9FXV` → `:schema.property/email`.
  - `applies-renames`: `LivestyleModification-X` → `:schema.class/LifestyleModification`; `Parents-X` → `:schema.property/parent`; `Event-X` (property) → `:schema.property/event`; `Rating-X` (property) → `:custom.property/rating`.
  - `non-schema-goes-custom`: `areas-X` → `:custom.property/areas`; `Resource-X` (class) → `:custom.class/Resource`.
  - `drops-newtest-and-sourceschema`: both map to `::convert/drop`.
  - `rewrites-build-properties-keys`: a class with `{:build/properties {:user.property/sourceSchema-mW7IZAwI [:block/uuid #uuid "67cfe8f6-6242-4a22-b196-8f6b95e96d8a"] :logseq.property/description "d"}}` → `:build/properties` has no sourceSchema key, keeps the description, and gains `:schema.property/url "https://schema.org/Person"`.
  - `renamed-title-updated`: `Parents` title `"parents"` → `"parent"`; an unrenamed entry keeps its existing title.
  - `duplicate-targets-are-reported`: two different old idents converting to the same new ident throw `ex-info` with message containing `"duplicate target"` and both old idents, unless their entry maps are equal after conversion (then merge).
  - `no-user-idents-remain`: after `convert-module`, `(re-find #":user\." (pr-str result))` is nil.

- [ ] **Step 3: Run** `bb test`. Expected: FAIL (namespaces missing).

- [ ] **Step 4: Implement** `vocab.clj`, `edn_io.clj`, `convert.clj` to the interfaces above. Renames and drops are a literal map in `convert.clj`, keyed by `[kind base-name]`.

- [ ] **Step 5: Run** `bb test`. Expected: all PASS.

- [ ] **Step 6: Commit** `feat(scripts): add schema ident conversion`.

### Task 2: Run the conversion on `source/`

**Files:**
- Create: `scripts/convert.clj` (CLI: reads all module files and the vocab, builds one `ident-map` across all modules, converts and rewrites each file in place, prints counts of schema/custom/dropped/renamed)
- Modify: every `source/*/classes.edn` and `source/*/properties.edn`
- Modify: `source/presets/*.edn` is NOT touched here (Task 4)

**Interfaces:** Consumes Task 1.

- [ ] **Step 1: Run** `bb scripts/convert.clj`. Expected output includes: 0 duplicate errors, dropped 2 (`NewTest`, `sourceSchema`), and custom entries exactly `areas, project, readBy, rating, Resource`.
  - If any other entry goes to custom, stop and list it for the user. It is either a misspelling to add to the rename map or a genuine custom entry, and only the user can say which.
- [ ] **Step 2: Verify** `grep -rn ':user\.' source/ --include=*.edn` returns nothing. Also verify `grep -rn 'sourceSchema\|NewTest' source/` returns nothing.
- [ ] **Step 3: Spot-check** `source/person/classes.edn`: `:schema.class/Person` extends `[:schema.class/Thing]`, and its class-properties include `:schema.property/email` and `:schema.property/parent`.
- [ ] **Step 4: Commit** `refactor(templates)!: convert source to schema.* and custom.* idents`, with body `BREAKING CHANGE: class and property idents changed; old template graphs are not compatible`.

### Task 3: Build the library

**Files:**
- Create: `src/template_graph/library.clj`
- Replace: `scripts/build.clj` (thin CLI; no presets argument; writes `build/schema-library.edn`)
- Test: `test/template_graph/library_test.clj`

**Interfaces:**
- Produces:
  - `(template-graph.library/merge-modules modules) -> {:classes {...} :properties {...}}`. Throws `ex-info` "conflicting definitions" if the same ident appears in two modules with unequal maps.
  - `(template-graph.library/library-map merged version) -> map` with the export-type and `:schema-library/version` keys.
  - `(template-graph.library/library-edn-string lib) -> string` (no namespace maps).

- [ ] **Step 1: Failing tests:**
  - `merge-combines-modules`
  - `merge-rejects-conflicts`
  - `library-has-export-type-and-version`: `(get lib :logseq.db.sqlite.export/export-type)` = `:graph-ontology`, and the version equals its input.
  - `edn-string-has-no-namespace-maps`: `(re-find #"#:" s)` is nil and `(edn/read-string ...)` round-trips to an equal map.
- [ ] **Step 2: Run** `bb test`. Expected: FAIL.
- [ ] **Step 3: Implement** `library.clj` and the CLI. The version is read from `package.json` `"version"`. Remove the UUID description rewrite entirely.
- [ ] **Step 4: Run** `bb test && bb scripts/build.clj`. Expected: PASS. Prints the class count (≈ 134 after dropping/renaming) and property count (≈ 333), and writes `build/schema-library.edn`.
- [ ] **Step 5: Commit** `feat(build): build a single schema library artifact`.

### Task 4: Presets and validation

**Files:**
- Create: `src/template_graph/presets.clj`, `src/template_graph/validate.clj`, `scripts/validate.clj`
- Modify: `source/presets/*.edn` (convert to the new format, once, via a `bb` task `convert-presets`); `scripts/build.clj` (also write `build/schema-presets.edn`)
- Delete: `scripts/validate.sh`, `scripts/validate-refs.clj`
- Test: `test/template_graph/presets_test.clj`, `test/template_graph/validate_test.clj`

**Interfaces:**
- Produces:
  - `(template-graph.presets/expand-old-preset old-preset module-maps) -> new-preset`. `old-preset` is `{:name :description :include [module...]|nil}`. Each included module's classes get all of their direct `:build/class-properties`. `nil` means all modules. `:id` is the file's base name.
  - `(template-graph.presets/presets-edn-string presets version) -> string`.
  - `(template-graph.validate/errors lib presets vocab) -> [string ...]`. Empty means valid.

- [ ] **Step 1: Failing tests:**
  - `expand-crm-preset`: an old preset including `["person"]` yields `:classes` with every person-module class and that class's direct properties.
  - `schema-name-not-in-vocab-flagged`: `:schema.property/emial` → an error mentioning `emial`.
  - `custom-name-in-vocab-flagged`: `:custom.property/email` → an error.
  - `no-dangling-refs`: a class-properties, class-extends, property-classes or `:build/properties` key referencing an ident not in the library → an error naming it. `:logseq.property/*` keys are allowed.
  - `user-ident-flagged`: any `:user.` keyword → an error.
  - `preset-unknown-class-flagged`
  - `preset-inherited-property-rejected`: a preset listing `:schema.property/url` under Person when url is only on Thing → an error.
  - `case-collision-same-kind-fails`: `:schema.property/email` and `:schema.property/Email` → an error. `:schema.class/Event` with `:schema.property/event` → no error.
- [ ] **Step 2: Run** `bb test`. Expected: FAIL.
- [ ] **Step 3: Implement** both namespaces. Run `bb convert-presets` once to rewrite `source/presets/*.edn` into the new format. `scripts/validate.clj` reads the build output and prints each error, exiting 1 if there are any.
- [ ] **Step 4: Run** `bb test && bb build && bb validate`. Expected: tests PASS, build writes both files, validate prints `Valid` and exits 0.
- [ ] **Step 5: Commit** `feat(presets): class-level presets with library validation`.

### Task 5: CI import check against real Logseq code

**Files:**
- Create: `scripts/ci/check-import.cljs`, `scripts/ci/nbb.edn.template`
- Modify: `bb.edn` (`check-import` task, which needs env `LOGSEQ_DIR` pointing at a logseq/logseq checkout with `scripts/` deps installed)

**Interfaces:**
- Consumes: `build/schema-library.edn`.
- The script uses `logseq.outliner.cli/init-conn`, `logseq.db.sqlite.export/build-import` and `logseq.db.sqlite.export/validate-import-txs`. These were proven in a spike on 2026-10-21 against logseq/logseq `69da7e2215b336cc5123dafb2a1686996e39596c`. Base the script on the spike at `docs/superpowers/plans/assets/check_import_spike.cljs`. Its core is reproduced below.

```clojure
;; for each pass: txs = (build-import m @conn {}); (:error txs) => fail
;; {:keys [error tx-data]} = (validate-import-txs txs @conn); error => fail
;; else (d/transact! conn tx-data {::sqlite-export/imported-data? true})
```

- [ ] **Step 1: Write the script.**
  - Pass 1 imports `build/schema-library.edn` into a fresh temp graph.
  - Pass 2 re-imports it.
  - Print `PASS <n> classes <m> properties` on success. Exit 1 with the error on any failure.
  - The `nbb.edn.template` has `:deps` `logseq/graph-parser`, `logseq/outliner`, `logseq/common` with `:local/root "${LOGSEQ_DIR}/deps/..."`. The bb task renders it next to the script.
- [ ] **Step 2: Run locally:**
  ```
  LOGSEQ_DIR=/home/mcnei/projects/logseq-db bb check-import
  ```
  Expected: `PASS`. Needs `npx pnpm@10.33.0 install --ignore-workspace` in `$LOGSEQ_DIR/scripts` and `bb` on PATH.
- [ ] **Step 3: Prove it fails.** Temporarily change one property's `:db/cardinality` in a copy of the library and import it after pass 1. Expected: an error containing `conflict with the current graph`. Don't commit this test file; note the result in the commit body.
- [ ] **Step 4: Commit** `test(ci): verify library imports into a fresh Logseq graph`.

### Task 6: Workflows

**Files:**
- Modify: `.github/workflows/test.yml`, `validate.yml`, `build-templates.yml`, `release.yml`
- Keep, but check path filters: `auto-release.yml`, `sync-branches.yml`, `validate-commits.yml`

**Interfaces:** Consumes the `bb` tasks from Tasks 1–5.

- [ ] **Step 1: Validation workflows.** In `test.yml` and `validate.yml`, replace per-variant builds and the inline checks with `bb test`, `bb build` and `bb validate`. Add a job `import-check`:
  - checkout `logseq/logseq` at `ref: 69da7e2215b336cc5123dafb2a1686996e39596c` into `logseq/`
  - setup Node 22
  - `npx pnpm@10.33.0 install --ignore-workspace` in `logseq/scripts`
  - install bb
  - `LOGSEQ_DIR=$GITHUB_WORKSPACE/logseq bb check-import`
- [ ] **Step 2: `build-templates.yml`:** build once and upload both artifacts.
- [ ] **Step 3: `release.yml`:** on `v*`, run `bb test`, `bb build`, `bb validate` and the import check. Attach exactly `build/schema-library.edn` and `build/schema-presets.edn`. Remove the per-preset loop and update the release-notes download text.
- [ ] **Step 4: Validate the workflow files** with `bb -e '(require (quote [clj-yaml.core :as y])) (doseq [f (file-seq (java.io.File. ".github/workflows")) :when (.isFile f)] (y/parse-string (slurp f)))'`. Expected: no exception.
- [ ] **Step 5: Commit** `ci: build, validate and import-check the schema library`.

### Task 7: Remove the old round trip and update docs

**Files:**
- Delete: `scripts/split.clj`, `scripts/export.sh`, `scripts/export.ps1`, and any other script matched by `grep -l 'user\.' scripts/*`
- Modify:
  - `package.json`: remove `export`, `export:full`, `split`, `build:*` preset scripts; add `"build": "bb build"`, `"test": "bb test"`, `"validate": "bb validate"`. Bump `"version"` to `"2.0.0"`. Remove the `@logseq/cli` devDependency (too old to read current graphs; verified 2026-10-21).
  - `README.md`, `QUICK_START.md`, `CLAUDE.md`, `DOCS_INDEX.md`, `docs/**`, `source/presets/README.md`, `source/*/README.md`, `.claude/` skills or commands that describe curating in the "Test Build" graph, export/split, per-preset downloads or `user.*` names
- Test: `grep -rln 'split.clj\|export.sh\|logseq_db_Templates_\|user\.class\|user\.property' --exclude-dir=.git .` returns only `CHANGELOG.md`.

- [ ] **Step 1: Delete the scripts and update `package.json`.**
- [ ] **Step 2: Rewrite the docs.**
  - Curating now means editing `source/` EDN directly, then `bb test && bb build && bb validate`.
  - Users download `schema-library.edn` (or build a role with the Ontology Sync plugin) and import it via **Import → EDN to DB Graph**.
  - Counts come from `bb build` output, not hard-coded.
- [ ] **Step 3: Run the grep test above.** Expected: only `CHANGELOG.md` matches.
- [ ] **Step 4: Run** `bb test && bb build && bb validate`. Expected: all pass.
- [ ] **Step 5: Commit** `docs: describe the schema library workflow`.

### Task 8: Release preparation (user tags)

- [ ] **Step 1: Branch and PR.** Work happened on a branch from `dev` per the repo's flow. Open a PR to `main` titled `feat!: schema library with fixed schema.* names`.
- [ ] **Step 2: Hand over to the user.** Once merged, add a `2.0.0` CHANGELOG section (hand-written; the generator misses merged commits). Stop and ask the user to push tag `v2.0.0`. Do not tag without their go-ahead.
- [ ] **Step 3: Verify the release.** After the user tags, `gh release view v2.0.0` lists exactly `schema-library.edn` and `schema-presets.edn`.
