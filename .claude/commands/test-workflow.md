# Test Complete Workflow

Run the complete check for the schema library: test -> build -> validate (-> optional import check).

## What This Does

1. **Unit tests** - `bb test`
2. **Build** - `bb build` writes `build/schema-library.edn` and `build/schema-presets.edn` and prints the class and property counts
3. **Validate** - `bb validate` checks the build against Schema.org (`Valid` on success)
4. **Import check (optional)** - `LOGSEQ_DIR=/path/to/logseq bb check-import` imports the library into a fresh Logseq graph
5. **Report** - counts, version, and any errors with the `source/` file to fix

## Usage

```
/test-workflow
```

## Steps Automated

Instead of running these manually:

```bash
bb test
bb build
bb validate
LOGSEQ_DIR=/path/to/logseq bb check-import   # optional
```

## Expected Output

```
Ran N tests containing M assertions.
0 failures, 0 errors.
classes   : <count>
properties: <count>
version   : <package.json version>
wrote build/schema-library.edn
wrote build/schema-presets.edn
Valid
```

## Error Handling

### A test fails

Read the failing assertion; it names the ident or rule. Fix `source/` (or the code in `src/template_graph/`) and rerun.

### `bb build` throws `conflicting definitions`

The same ident is defined differently in two module files. Keep one definition.

### `bb validate` prints errors

Each line names the ident and rule; see `docs/developer-guide/validation-reference.md`.

### `bb check-import` reports `LOGSEQ_DIR must point at a logseq/logseq checkout`

Set `LOGSEQ_DIR` to a `logseq/logseq` clone and run `pnpm install --ignore-workspace` in its `scripts/` directory.

## Prerequisites

- Babashka (`bb`)
- For the import check only: a `logseq/logseq` checkout with dependencies installed in `scripts/`

## Related

- `/validate-env` - check the environment
- `docs/developer-guide/ci-cd-pipeline.md`
