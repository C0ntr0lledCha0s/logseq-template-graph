# Validate Development Environment

Check that the tools needed to build and validate the schema library are available.

## What This Does

Validates:
1. Babashka (`bb`) installed (required: `bb test`, `bb build`, `bb validate`)
2. Node.js >= 16 and npm (optional: git hooks, changelog tooling)
3. Git configured, git hooks installed (`core.hooksPath = .git-hooks`)
4. Conventional commits validation working
5. `source/` modules present, `vendor/schemaorg-current-https.json` present
6. `build/` directory writable
7. Optional: `LOGSEQ_DIR` points at a `logseq/logseq` checkout with `scripts/node_modules` installed (needed only for `bb check-import`)

## Usage

```
/validate-env
```

## Checks to Run

```bash
bb --version
node --version && npm --version
git config core.hooksPath                  # expect .git-hooks
ls source | head
test -f vendor/schemaorg-current-https.json && echo vendor ok
mkdir -p build && test -w build && echo build writable
bb test && bb build && bb validate         # end-to-end smoke test
test -n "$LOGSEQ_DIR" && test -x "$LOGSEQ_DIR/scripts/node_modules/.bin/nbb-logseq" && echo import-check ready
```

## Output

```
Environment Validation
  OK   Babashka <version>
  OK   Node.js <version> / npm <version>
  OK   Git hooks installed
  OK   source/ modules present
  OK   vendor/ Schema.org vocabulary present
  OK   build/ writable
  OK   bb test, bb build, bb validate pass
  --   LOGSEQ_DIR not set (only needed for bb check-import)
```

## Fixes

### Babashka missing

```bash
# Mac
brew install borkdude/brew/babashka
# Windows
scoop install babashka
# Linux
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
```

### Git hooks missing

```bash
npm run setup
```

### `bb check-import` not ready

```bash
git clone --depth 1 https://github.com/logseq/logseq.git
cd logseq/scripts && pnpm install --ignore-workspace
export LOGSEQ_DIR=/path/to/logseq
```

## Related

- `/test-workflow` - run test, build and validate
- `docs/developer-guide/ci-cd-pipeline.md`
