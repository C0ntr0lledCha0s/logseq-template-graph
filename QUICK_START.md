# Quick Start Guide

**Contents:**
- [For Users: Import the Library](#for-users-import-the-library)
- [For Developers: Edit and Build](#for-developers-edit-and-build)
- [Troubleshooting](#troubleshooting)

---

## For Users: Import the Library

### Step 0: Install Logseq Database Version

The library needs the Logseq **Database** version, not the markdown-based Logseq.

1. Download the DB version from [Logseq Downloads](https://logseq.com/downloads) or the [Logseq GitHub Releases](https://github.com/logseq/logseq/releases).
2. Install it and create a new graph. Choose **Database Graph**. If you are only offered markdown graphs, you have the wrong version.

### Step 1: Download the library

Download **`schema-library.edn`** from the [latest release](https://github.com/C0ntr0lledCha0s/logseq-template-graph/releases/latest).

Each release publishes exactly two files:

- `schema-library.edn` - all classes and properties. This is the file you import.
- `schema-presets.edn` - role presets, read by the Ontology Sync plugin. You do not import it directly.

Do not download the "Source code" archives; they are development files.

### Step 2: Import into Logseq

1. Open your Logseq Database Graph.
2. Go to Settings -> Import -> **EDN to DB Graph**.
3. Select `schema-library.edn` and wait for the import to finish.

### Alternative: build a role with the Ontology Sync plugin

If you want only the classes for a role (CRM, research, events, ...) rather than the whole library, use the [Ontology Sync plugin](https://github.com/C0ntr0lledCha0s/logseq-ontology-sync-plugin). It reads both `schema-library.edn` and `schema-presets.edn`.

### Step 3: Start using it

Tag any page with an imported class:

- `#Person` brings email, jobTitle, birthDate, and so on.
- `#Organization` brings legalName, employee, member, and so on.
- `#Event` brings eventStatus, attendee, organizer, and so on.

[Back to top](#quick-start-guide)

---

## For Developers: Edit and Build

You curate the library by editing the EDN files in `source/`. There is no export from a Logseq graph.

### Prerequisites

- [Babashka](https://babashka.org/) (`bb`)
- Node.js 16+ (optional, for git hooks and changelog tooling)
- A `logseq/logseq` checkout (optional, only for `bb check-import`)

```bash
# Mac
brew install borkdude/brew/babashka
# Windows
scoop install babashka
# Linux
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)

bb --version
```

### Set up

```bash
git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
cd logseq-template-graph
npm install        # installs git hooks and changelog tooling
```

### Edit, build, validate

1. Edit the files under `source/`:
   - `source/<module>/classes.edn` and `properties.edn` for definitions
   - `source/presets/<id>.edn` for presets
2. Run the checks:

```bash
bb test        # unit tests
bb build       # writes build/schema-library.edn and build/schema-presets.edn, prints counts
bb validate    # checks the build against Schema.org (vendor/)
```

3. Optionally confirm that Logseq itself accepts the library:

```bash
LOGSEQ_DIR=/path/to/logseq bb check-import
```

CI runs the same steps (see [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md)).

### Idents

| Kind | Ident |
|------|-------|
| Schema.org class | `:schema.class/Person` |
| Schema.org property | `:schema.property/email` |
| Non-Schema.org class or property | `:custom.class/FamilyGroup`, `:custom.property/rating` |

Every `schema.*` entry carries `:schema.property/url`. Idents are fixed and must not be changed once released. `:user.*` idents are rejected by validation.

### Commit

```bash
git add source/
git commit -m "feat(classes): add Recipe class"
```

Commits follow [Conventional Commits](docs/developer-guide/conventional-commits-guide.md); the git hooks enforce this.

More detail: [CONTRIBUTING.md](CONTRIBUTING.md) and the [Technical Reference](docs/architecture/technical-reference.md).

[Back to top](#quick-start-guide)

---

## Troubleshooting

### `bb: command not found`

Install Babashka (see above) and reopen your terminal.

### `bb validate` reports an error

See the [Validation Reference](docs/developer-guide/validation-reference.md) for what each message means. Typical causes: a name that is not in Schema.org used under `schema.*`, a reference to an ident that does not exist, or a leftover `:user.*` ident.

### `bb build` fails with "conflicting definitions"

The same ident is defined differently in two modules. Keep one definition.

### `bb check-import` says `LOGSEQ_DIR must point at a logseq/logseq checkout`

Set `LOGSEQ_DIR` to a `logseq/logseq` clone and run `pnpm install --ignore-workspace` in its `scripts/` directory.

### Scripts will not run on Windows

Run PowerShell as needed with `-ExecutionPolicy Bypass`, or use Git Bash. `bb` itself works the same on every platform.

## Next steps

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [Technical Reference](docs/architecture/technical-reference.md)
- [Documentation portal](docs/README.md)
- [GitHub Issues](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
