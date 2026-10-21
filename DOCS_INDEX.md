# Documentation Index

Map of the documentation in this repository.

**Start here:** [README](README.md) | [Quick Start](QUICK_START.md) | [Documentation portal](docs/README.md)

## By audience

### Users

- [README](README.md) - what the library is and what each release contains
- [Quick Start: import](QUICK_START.md#for-users-import-the-library) - download `schema-library.edn` and import it

### Developers

- [Quick Start: develop](QUICK_START.md#for-developers-edit-and-build) - edit `source/`, then `bb test && bb build && bb validate`
- [CONTRIBUTING.md](CONTRIBUTING.md) - workflow, commits, pull requests
- [Technical Reference](docs/architecture/technical-reference.md) - EDN format, idents, presets
- [Validation Reference](docs/developer-guide/validation-reference.md) - what `bb validate` checks
- [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) - workflows and releases

## Files

| File | Description |
|------|-------------|
| [README.md](README.md) | Project overview |
| [QUICK_START.md](QUICK_START.md) | Import and develop |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guide |
| [CLAUDE.md](CLAUDE.md) | Guidance for Claude Code |
| [source/presets/README.md](source/presets/README.md) | Preset format and the available presets |
| [docs/architecture/technical-reference.md](docs/architecture/technical-reference.md) | EDN format and conventions |
| [docs/developer-guide/ci-cd-pipeline.md](docs/developer-guide/ci-cd-pipeline.md) | CI/CD workflows |
| [docs/developer-guide/validation-reference.md](docs/developer-guide/validation-reference.md) | Validation rules |
| [docs/developer-guide/conventional-commits-guide.md](docs/developer-guide/conventional-commits-guide.md) | Commit standards and changelog |
| [docs/developer-guide/conventional-commits-integration.md](docs/developer-guide/conventional-commits-integration.md) | Commit tooling setup |
| [docs/research/comprehensive-analysis.md](docs/research/comprehensive-analysis.md) | Background research (historical) |
| [docs/developer-guide/implementation-summary.md](docs/developer-guide/implementation-summary.md) | Earlier implementation notes (historical) |

## I want to...

| Task | Where |
|------|-------|
| Import the library | [Quick Start: import](QUICK_START.md#for-users-import-the-library) |
| Add a class or property | [CONTRIBUTING.md](CONTRIBUTING.md#adding-classes-and-properties) |
| Change a preset | [source/presets/README.md](source/presets/README.md) |
| Understand a validation error | [Validation Reference](docs/developer-guide/validation-reference.md) |
| Understand the release process | [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) |

## External resources

- [Logseq docs](https://docs.logseq.com), [DB version guide](https://github.com/logseq/docs/blob/master/db-version.md)
- [Schema.org](https://schema.org)
- [Babashka](https://babashka.org/)
- [EDN specification](https://github.com/edn-format/edn)

[Back to README](README.md)
