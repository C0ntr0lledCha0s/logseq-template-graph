# Development Workflow and CI/CD Pipeline

How changes flow from `source/` to a release of `schema-library.edn` and `schema-presets.edn`.

## Contents

- [Local workflow](#local-workflow)
- [Commands](#commands)
- [GitHub Actions](#github-actions)
- [Release flow](#release-flow)
- [Git hooks](#git-hooks)
- [Troubleshooting](#troubleshooting)

---

## Local workflow

Curate by editing the EDN under `source/`. There is no export from a Logseq graph.

```bash
# 1. Edit source/<module>/classes.edn, properties.edn or source/presets/<id>.edn

# 2. Check
bb test && bb build && bb validate

# 3. Optional: import into a fresh Logseq graph, as CI does
LOGSEQ_DIR=/path/to/logseq bb check-import

# 4. Review the (small, per-module) diff and commit
git diff source/
git add source/
git commit -m "feat(classes): add Recipe class"
```

`build/` is generated and git-ignored; commit only `source/` and code.

## Commands

| Command | What it does |
|---------|--------------|
| `bb test` | Runs the unit tests in `test/template_graph/` |
| `bb build` | Merges `source/` into `build/schema-library.edn` and `build/schema-presets.edn`, normalises each class's property order to one global order, prints class and property counts and the version (from `package.json`) |
| `bb validate` | Validates the build against the vendored Schema.org vocabulary; prints `Valid` or each error. See [validation-reference.md](validation-reference.md) |
| `bb check-import` | Imports `build/schema-library.edn` into a fresh Logseq graph using nbb-logseq. Needs `LOGSEQ_DIR` pointing at a `logseq/logseq` checkout whose `scripts/` has dependencies installed (`pnpm install --ignore-workspace`) |

The npm scripts `npm run build`, `npm test` and `npm run validate` call the same `bb` tasks. `npm run changelog`, `version` and related scripts wrap git-conventional-commits.

## GitHub Actions

| Workflow | Trigger | Steps |
|----------|---------|-------|
| `test.yml` | PRs and pushes touching `source/`, `scripts/`, `src/`, `test/`, `bb.edn`, `vendor/` | `bb test`, `bb build`, `bb validate`; a second job runs `bb check-import` against a pinned `logseq/logseq` checkout |
| `build-templates.yml` | PRs and pushes | `bb build`, prints statistics, uploads `schema-library` build artifacts |
| `validate.yml` | PRs and pushes to main | `bb build`, `bb validate` |
| `validate-commits.yml` | PRs | Checks commits follow Conventional Commits |
| `auto-release.yml` | Push to `main` | Determines the next version from commits, updates `CHANGELOG.md` and `package.json`, tags `vX.Y.Z` |
| `release.yml` | Tag `v*` | `bb test`, `bb build`, `bb validate`, `bb check-import`; creates the GitHub release |
| `sync-branches.yml` | Push to `main` | Syncs `main` back into `dev` |

## Release flow

1. Work lands on `dev`; open a PR `dev` -> `main`.
2. Merging to `main` triggers `auto-release.yml`, which bumps the version from the conventional commits and pushes a `v*` tag.
3. The tag triggers `release.yml`, which runs the full check (tests, build, validate, import check) and publishes **exactly two files**:
   - `schema-library.edn`
   - `schema-presets.edn`
4. Users download `schema-library.edn` and import it via Logseq **Import -> EDN to DB Graph**, or build a role with the Ontology Sync plugin, which reads both files.

The released version is read from `package.json` by `bb build` and written into both files.

## Git hooks

Installed by `npm run setup` (`core.hooksPath = .git-hooks`):

| Hook | Behaviour |
|------|-----------|
| `commit-msg` | Validates the Conventional Commits format |
| `post-commit` | If `source/` changed, runs `bb build` and `bb validate` |
| `pre-push` | Runs `bb test`, `bb build`, `bb validate`, then validates commit messages |
| `post-merge` | If `source/` changed, runs `bb build` and `bb validate` |

Bypass (not recommended): `git commit --no-verify`, `git push --no-verify`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `bb: command not found` | Install [Babashka](https://babashka.org/) |
| `bb build` throws `conflicting definitions` | The same ident is defined differently in two modules; keep one |
| `bb validate` prints errors | See [validation-reference.md](validation-reference.md) |
| `bb check-import` fails with `LOGSEQ_DIR must point at a logseq/logseq checkout` | Set `LOGSEQ_DIR` and install dependencies in its `scripts/` directory |
| Import check fails in CI only | Run `LOGSEQ_DIR=... bb check-import` locally; read the reported import error |

See also: [CONTRIBUTING.md](../../CONTRIBUTING.md), [Conventional Commits Guide](conventional-commits-guide.md).
